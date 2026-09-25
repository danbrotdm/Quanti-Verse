// LÖVE (love.js) under QuantiLoader: runs from the bundle, saves through love.filesystem
// (Emscripten IDBFS, the same path as Balatro and other LÖVE ports), and the save guard
// restores that save after the browser loses it.  usage: node love.cjs <love.js-output.zip>
const { chromium, OUT } = require('./lib.cjs');
const APP_FILE = process.env.APP || require('./lib.cjs').APP_FILE;
const path = require('path');
const ok = (c, m) => { console.log((c ? 'PASS ' : 'FAIL ') + m); if (!c) process.exitCode = 1; };
(async () => {
  const b = await chromium.launch();
  const ctx = await b.newContext({ viewport: { width: 800, height: 600 }, locale: 'en-US', acceptDownloads: true });
  const errs = []; ctx.on('page', p => p.on('pageerror', e => errs.push(e.message)));
  const v = await ctx.newPage(); await v.goto(APP_FILE); await v.click('#nexusVerterBtn'); await v.setInputFiles('#zipPicker', process.argv[2]);
  await v.waitForFunction(() => !document.getElementById('entry').disabled);
  const [dl] = await Promise.all([v.waitForEvent('download'), v.click('#convert')]);
  const bundle = path.join(OUT, 'love.bootable.zip'); await dl.saveAs(bundle); await v.close();
  // The save file as love.js stored it in IDBFS.
  const readSave = (p) => p.evaluate(() => new Promise(res => {
    const q = indexedDB.open('/home/web_user/love');
    q.onupgradeneeded = () => { q.transaction.abort(); };
    q.onerror = () => res(null);
    q.onsuccess = () => { const db = q.result; if (!db.objectStoreNames.contains('FILE_DATA')) { db.close(); return res(null); }
      const g = db.transaction('FILE_DATA').objectStore('FILE_DATA').get('/home/web_user/love/qvlovetest/save.txt');
      g.onsuccess = () => { db.close(); res(g.result ? new TextDecoder().decode(g.result.contents) : null); }; };
  }));
  const run = async (label) => {
    const p = await ctx.newPage(); await p.goto(APP_FILE); await p.setInputFiles('#bl-file', bundle);
    await p.waitForTimeout(6000);
    await p.waitForTimeout(6000);   // the guard flushes IDBFS every 5 s
    await p.evaluate(() => window.__quantiSaves && window.__quantiSaves.snapshot());
    const v = await readSave(p); await p.close(); return v;
  };
  const first = await run('run1');
  ok(first === '1', 'run 1: the game started from the bundle and saved through love.filesystem (save.txt = ' + first + ')');
  const h = await ctx.newPage(); await h.goto(APP_FILE);
  await h.evaluate(() => new Promise(r => { const q = indexedDB.deleteDatabase('/home/web_user/love'); q.onsuccess = q.onerror = q.onblocked = () => r(); }));
  ok(await readSave(h) === null, 'browser lost the LÖVE save (IDBFS database deleted)');
  await h.close();
  const second = await run('run2');
  ok(second === '2', 'run 2: the save guard restored it before the game started, so the game continued (save.txt = ' + second + ')');
  console.log('errors:', errs.length ? errs : 'none');
  await b.close();
})().catch(e => { console.error('CRASH', e); process.exit(1); });
