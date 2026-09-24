const { chromium, APP_FILE, FIXTURES, OUT: OUTDIR, WORK } = require('./lib.cjs');
const path = require('path'), cp = require('child_process');
const OUT = OUTDIR, APP = APP_FILE;
const ok = (c, m) => { console.log((c ? 'PASS ' : 'FAIL ') + m); if (!c) process.exitCode = 1; };
(async () => {
  const b = await chromium.launch();
  const errs = [];
  async function profile() {
    const ctx = await b.newContext({ viewport: { width: 1280, height: 1000 }, locale: 'en-US', acceptDownloads: true });
    const p = await ctx.newPage();
    p.on('pageerror', e => errs.push(e.message)); p.on('dialog', d => d.accept());
    p.on('console', m => { if (m.type() === 'error' && !/SecurityError/.test(m.text())) errs.push(m.text().slice(0, 200)); });
    await p.goto(APP); await p.click('#nexusSorterBtn'); await p.waitForTimeout(300);
    return { ctx, p };
  }
  const tag = async (p) => (await p.textContent('#qs-tagline'));
  const until = (p, re) => p.waitForFunction(r => new RegExp(r).test(document.getElementById('qs-tagline').textContent), re, { timeout: 60000 });
  const cards = (p) => p.evaluate(() => [...document.querySelectorAll('.qs-card')].map(c => ({
    title: c.querySelector('.qs-title').textContent,
    tags: [...c.querySelectorAll('.qs-mini-tag')].map(t => t.textContent).filter(t => t !== '#untagged').join(' '),
    fav: c.querySelector('[data-action=favorite]').textContent.trim() === '★',
    save: /SAVE BACKED UP/.test(c.textContent), load: Boolean(c.querySelector('[data-action=launch]')) })));

  // --- profile A: a library with tags, a favorite and a real save
  const A = await profile();
  await A.p.setInputFiles('#qs-file', ['flash', 'dos', 'web', 'savegame'].map(n => `${OUT}/${n}.bootable.zip`));
  await until(A.p, 'ADDED');
  await A.p.locator('.qs-sel').nth(0).click(); await A.p.locator('.qs-sel').nth(1).click();
  await A.p.fill('#qs-bulk-tag', 'classic'); await A.p.click('#qs-bulk-tagadd'); await until(A.p, 'ADDED TO 2');
  await A.p.click('#qs-bulk-fav'); await until(A.p, 'FAVORITES');
  // play savegame once so it has a save
  const g = await A.ctx.newPage(); await g.goto(APP); await g.setInputFiles('#bl-file', `${OUT}/savegame.bootable.zip`);
  await g.waitForFunction(() => document.title === 'saved 1'); await g.evaluate(() => window.__quantiSaves.snapshot()); await g.close();
  await A.p.reload(); await A.p.click('#nexusSorterBtn'); await A.p.waitForTimeout(500);
  const before = await cards(A.p);
  console.log('  library A:', JSON.stringify(before));
  ok(before.find(c => c.title === 'savegame').save, 'savegame card shows SAVE BACKED UP');

  const [dl] = await Promise.all([A.p.waitForEvent('download'), A.p.click('#qs-backup')]);
  const backup = path.join(OUT, dl.suggestedFilename()); await dl.saveAs(backup);
  console.log('  ' + await tag(A.p));
  const listing = cp.execFileSync('python3', ['-c', `import zipfile,sys,json
z=zipfile.ZipFile(sys.argv[1]); bad=z.testzip(); m=json.loads(z.read('quantiverse-backup.json'))
print(json.dumps({'bad':bad,'names':z.namelist(),'games':len(m['games']),'saves':[s['folder'] for s in m['saves']]}))`, backup]).toString();
  const L = JSON.parse(listing);
  console.log('  python zipfile:', listing.trim());
  ok(L.bad === null && L.games === 4 && L.names.filter(n => n.startsWith('games/')).length === 4 && L.saves.includes('savegame'), 'backup is a valid zip with 4 games and the save (CRC-checked by Python)');

  // selection backup
  await A.p.locator('.qs-sel').nth(3).click();
  const [dl2] = await Promise.all([A.p.waitForEvent('download'), A.p.click('#qs-bulk-backup')]);
  const sel = path.join(OUT, dl2.suggestedFilename()); await dl2.saveAs(sel);
  const L2 = JSON.parse(cp.execFileSync('python3', ['-c', `import zipfile,sys,json
z=zipfile.ZipFile(sys.argv[1]); m=json.loads(z.read('quantiverse-backup.json')); print(json.dumps({'bad':z.testzip(),'games':[g['title'] for g in m['games']],'saves':[s['folder'] for s in m['saves']]}))`, sel]).toString());
  console.log('  selection backup:', JSON.stringify(L2), path.basename(sel));
  ok(L2.bad === null && L2.games.length === 1, 'selected-games backup holds just the selection');

  // --- profile B: empty browser, restore
  const B = await profile();
  await B.p.setInputFiles('#qs-restore-file', backup);
  await until(B.p, 'RESTORED');
  console.log('  ' + await tag(B.p));
  const after = await cards(B.p);
  const norm = (a) => JSON.stringify([...a].sort((x, y) => x.title.localeCompare(y.title)));
  ok(norm(after) === norm(before), 'restored library matches the original (titles, tags, favorites, save badges, playable)');
  const h = await B.ctx.newPage(); await h.goto(APP); await h.setInputFiles('#bl-file', `${OUT}/savegame.bootable.zip`);
  await h.waitForFunction(() => /^saved /.test(document.title)); 
  ok(await h.title() === 'saved 2', 'the save came back with the backup: game continued at launch 2 (' + await h.title() + ')');
  await h.close();
  // restoring again merges instead of duplicating; dropping via "Add games" also restores
  await B.p.setInputFiles('#qs-file', backup);
  await until(B.p, '0 ADDED, 4 ALREADY HERE');
  console.log('  ' + await tag(B.p));
  ok((await cards(B.p)).length === 4 && /0 ADDED, 4 ALREADY HERE/.test(await tag(B.p)), 'a backup added through ADD GAMES is restored and merged, not duplicated');
  // restored games launch from the Sorter
  await B.p.evaluate(() => { const c = [...document.querySelectorAll('.qs-card')].find(c => c.textContent.includes('webgame')); c.querySelector('[data-action=launch]').click(); });
  await B.p.waitForTimeout(3000);
  ok(await B.p.title() === 'Web', 'a restored game launches from QuantiSorter');
  console.log('errors:', errs.length ? errs : 'none');
  await b.close();
})().catch(e => { console.error('CRASH', e); process.exit(1); });
