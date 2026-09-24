// usage: node saves.cjs <web|dos|flash|disk>
const { chromium, APP_FILE, FIXTURES, OUT: OUTDIR, WORK } = require('./lib.cjs');
const fs = require('fs'), path = require('path'), cp = require('child_process');
const FX = FIXTURES, OUT = OUTDIR;
const which = process.argv[2];
const APP = which === 'disk' ? 'http://127.0.0.1:8766/index.html' : APP_FILE;
const ok = (c, m) => { console.log((c ? 'PASS ' : 'FAIL ') + m); if (!c) process.exitCode = 1; };
function pixel(png, x, y) {
  return JSON.parse(cp.execFileSync('python3', ['-c', `
import sys,zlib,struct,json
d=open(sys.argv[1],'rb').read();i=8;idat=b''
while i<len(d):
  n=struct.unpack('>I',d[i:i+4])[0];t=d[i+4:i+8];c=d[i+8:i+8+n];i+=12+n
  if t==b'IHDR':w,h=struct.unpack('>II',c[:8]);bpp={2:3,6:4}[c[9]]
  if t==b'IDAT':idat+=c
raw=zlib.decompress(idat);st=w*bpp;prev=bytearray(st);p=0;X,Y=int(sys.argv[2]),int(sys.argv[3])
for y in range(Y+1):
  f=raw[p];ln=bytearray(raw[p+1:p+1+st]);p+=1+st
  for x in range(st):
    a=ln[x-bpp] if x>=bpp else 0;b=prev[x];c=prev[x-bpp] if x>=bpp else 0
    if f==1:ln[x]=(ln[x]+a)&255
    elif f==2:ln[x]=(ln[x]+b)&255
    elif f==3:ln[x]=(ln[x]+(a+b)//2)&255
    elif f==4:
      pa=abs(b-c);pb=abs(a-c);pc=abs(a+b-2*c);ln[x]=(ln[x]+(a if pa<=pb and pa<=pc else b if pb<=pc else c))&255
  prev=ln
print(json.dumps(list(prev[X*bpp:X*bpp+3])))`, png, x, y]).toString());
}
const near = (px, rgb) => px.every((v, i) => Math.abs(v - rgb[i]) < 40);

(async () => {
  const browser = await chromium.launch();
  const ctx = await browser.newContext({ viewport: { width: 800, height: 600 }, locale: 'en-US', acceptDownloads: true });
  const errs = [];
  const watch = (p, tag) => { p.on('pageerror', e => errs.push(tag + ': ' + e.message)); p.on('console', m => { if (m.type() === 'error' && !/SecurityError|Changes not found/.test(m.text())) errs.push(tag + ' console: ' + m.text().slice(0, 240)); }); };

  async function convert(src) {
    const v = await ctx.newPage(); watch(v, 'verter');
    await v.goto(APP); await v.click('#nexusVerterBtn'); await v.setInputFiles('#zipPicker', src);
    await v.waitForFunction(() => !document.getElementById('entry').disabled);
    const [dl] = await Promise.all([v.waitForEvent('download'), v.click('#convert')]);
    const out = path.join(OUT, path.basename(src, '.zip') + '.bootable.zip'); await dl.saveAs(out); await v.close(); return out;
  }
  async function launch(bundle, tag) {
    const p = await ctx.newPage(); watch(p, tag);
    await p.goto(APP); await p.setInputFiles('#bl-file', bundle);
    return p;
  }
  const loaderLog = async (p) => { try { return await p.$eval('#bl-log', e => e.textContent); } catch (_) { return '(loader log gone after handoff)'; } };
  const saveRecord = (p, key) => p.evaluate(key => new Promise(res => {
    const r = indexedDB.open('quantiverse-saves', 1);
    r.onupgradeneeded = () => r.result.createObjectStore('games', { keyPath: 'key' });
    r.onsuccess = () => { const g = r.result.transaction('games').objectStore('games').get(key); g.onsuccess = () => { const v = g.result; r.result.close();
      res(v ? { local: v.local, idb: (v.idb || []).map(d => ({ name: d.name, stores: d.stores.map(s => ({ name: s.name, keys: s.records.map(x => x[0]) })) })), files: Object.keys(v.files || {}), updatedAt: v.updatedAt } : null); }; };
  }), key);
  const shot = async (p, name) => { const f = path.join(OUT, name + '.png'); await p.screenshot({ path: f }); return f; };

  if (which === 'web' || which === 'disk') {
    const bundle = await convert(FX + '/savegame.zip');
    let helper = await ctx.newPage(); helper.on('console', m => { if (m.type() !== 'log') console.log('  [helper ' + m.type() + ']', m.text().slice(0, 300)); }); await helper.goto(APP);
    if (which === 'disk') {
      // Library folder = the origin's private file system, which has the same handle API.
      await helper.evaluate(() => new Promise(async res => {
        const root = await navigator.storage.getDirectory();
        const r = indexedDB.open('quantinexus-sorter', 2);
        r.onsuccess = () => { const tx = r.result.transaction('settings', 'readwrite'); const s = tx.objectStore('settings');
          s.put({ key: 'libraryDirHandle', value: root }); s.put({ key: 'libraryDirName', value: 'OPFS' }); tx.oncomplete = () => { r.result.close(); res(); }; };
      }));
      await helper.reload(); await helper.waitForTimeout(800);
      console.log('  sorter folder status:', await helper.textContent('#qs-dirstatus'));
    }
    let p = await launch(bundle, 'run1');
    await p.waitForFunction(() => document.title === 'saved 1', null, { timeout: 15000 });
    await p.waitForTimeout(3500);
    let f = await shot(p, which + '-save-run1');
    ok(near(pixel(f, 200, 300), [255, 0, 0]) && near(pixel(f, 600, 300), [255, 0, 0]), 'run 1: fresh game (count 1, no IDB record yet)');
    let rec = await saveRecord(helper, 'savegame');
    console.log('  save store after run 1:', JSON.stringify(rec));
    ok(rec && rec.local.sg_count === '1' && rec.local.sg_prop === 'launch-1' && rec.idb[0] && rec.idb[0].stores[0].keys.includes('slot1'),
      'guard captured setItem key, property-style key and the IndexedDB record');
    if (which === 'disk') {
      const onDisk = await helper.evaluate(async () => { const root = await navigator.storage.getDirectory();
        const f = await (await (await (await root.getDirectoryHandle('Saves')).getDirectoryHandle('savegame')).getFileHandle('save.json')).getFile(); return JSON.parse(await f.text()); });
      ok(onDisk.key === 'savegame' && onDisk.local.sg_count === '1', 'Saves/savegame/save.json written to the library folder');
    }
    await p.close();

    // The browser loses the game's data (and, for the disk test, Quantiverse's save store too).
    await helper.evaluate(async (all) => {
      localStorage.removeItem('sg_count'); localStorage.removeItem('sg_prop');
      const del = n => new Promise(r => { const q = indexedDB.deleteDatabase(n); q.onsuccess = q.onerror = q.onblocked = () => r(); });
      await del('sgdb'); if (all) await del('quantiverse-saves');
    }, which === 'disk');
    if (which === 'disk') {
      await helper.reload(); await helper.waitForTimeout(1500);    // Sorter reconnects the folder and imports Saves/
      console.log('  status after reload:', await helper.textContent('#qs-dirstatus'), '|', await helper.textContent('#qs-tagline'));
      rec = await saveRecord(helper, 'savegame');
      ok(rec && rec.local.sg_count === '1', 'save store rebuilt from Saves/savegame/save.json after a full wipe');
    }

    p = await launch(bundle, 'run2');
    const log = await p.evaluate(() => document.getElementById('bl-log') && document.getElementById('bl-log').textContent);
    await p.waitForFunction(() => /^saved /.test(document.title), null, { timeout: 15000 });
    await p.waitForTimeout(1000);
    f = await shot(p, which + '-save-run2');
    ok(near(pixel(f, 200, 300), [0, 255, 0]) && near(pixel(f, 600, 300), [0, 255, 0]), 'run 2: save restored before the game started (count 2, IDB record present) ' + await p.title());
    const ls = await p.evaluate(() => [localStorage.getItem('sg_count'), localStorage.sg_prop]);
    ok(ls[0] === '2' && ls[1] === 'launch-2', 'localStorage continues from the restored save: ' + JSON.stringify(ls));
  }

  if (which === 'dos') {
    const bundle = await convert(FX + '/dossave.zip');
    let p = await launch(bundle, 'dos1');
    await p.waitForTimeout(6000); await p.mouse.click(424, 220); await p.waitForTimeout(6000);
    let f = await shot(p, 'dos-save-run1');
    ok(near(pixel(f, 400, 300), [170, 0, 0]), 'run 1: SAVE.DAT did not exist yet (red)');
    await p.mouse.click(24, 24);                                   // js-dos "save" button
    await p.waitForTimeout(3000);
    const helper = await ctx.newPage(); await helper.goto(APP);
    const rec = await saveRecord(helper, 'dossave');
    console.log('  save store:', JSON.stringify(rec));
    ok(rec && rec.files.includes('dos-changes'), 'js-dos pushed its disk changes into the save guard');
    await p.close();
    p = await launch(bundle, 'dos2');
    await p.waitForTimeout(6000); await p.mouse.click(424, 220); await p.waitForTimeout(6000);
    f = await shot(p, 'dos-save-run2');
    ok(near(pixel(f, 400, 300), [0, 170, 0]), 'run 2: SAVE.DAT came back from the save (green) on a file:// page');
  }

  if (which === 'flash') {
    const bundle = await convert(FX + '/flashsave.zip');
    const p = await launch(bundle, 'flash1');
    await p.waitForTimeout(7000); await p.mouse.click(400, 300); await p.waitForTimeout(3000);
    const keys = await p.evaluate(() => Object.keys(localStorage));
    console.log('  localStorage keys:', JSON.stringify(keys));
    ok(keys.some(k => k.includes('/flashsave/') && k.includes('qvtest')), 'SharedObject key includes the per-game folder');
    await p.evaluate(() => window.__quantiSaves.snapshot());
    const helper = await ctx.newPage(); await helper.goto(APP);
    const rec = await saveRecord(helper, 'flashsave');
    ok(rec && Object.keys(rec.local).some(k => k.includes('qvtest')), 'guard captured the SharedObject: ' + JSON.stringify(rec && Object.keys(rec.local)));
  }
  console.log('errors:', errs.length ? '\n  ' + errs.join('\n  ') : 'none');
  await browser.close();
})().catch(e => { console.error('CRASH', e); process.exit(1); });
