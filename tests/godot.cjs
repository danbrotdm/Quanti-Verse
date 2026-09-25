// Godot 4 web export under QuantiLoader: runs from the bundle, keeps a run counter in user://
// (IndexedDB), and the save guard restores it after the browser loses it.
// usage: node godot.cjs <godot-web-export.zip>   (APP env to test over http)
const { chromium, OUT } = require('./lib.cjs');
const APP = process.env.APP || require('./lib.cjs').APP_FILE;
const path = require('path');
const ok = (c, m) => { console.log((c ? 'PASS ' : 'FAIL ') + m); if (!c) process.exitCode = 1; };
(async () => {
  const b = await chromium.launch();
  const ctx = await b.newContext({ viewport: { width: 800, height: 600 }, locale: 'en-US', acceptDownloads: true });
  const errs = [];
  ctx.on('page', p => { p.on('pageerror', e => errs.push(e.message)); if (process.env.DEBUG) p.on('console', m => console.log('   [' + m.type() + '] ' + m.text().slice(0, 200))); });
  const v = await ctx.newPage(); await v.goto(APP); await v.click('#nexusVerterBtn'); await v.setInputFiles('#zipPicker', process.argv[2]);
  await v.waitForFunction(() => !document.getElementById('entry').disabled);
  const [dl] = await Promise.all([v.waitForEvent('download'), v.click('#convert')]);
  const bundle = path.join(OUT, 'godot.bootable.zip'); await dl.saveAs(bundle); await v.close();
  const run = async () => {
    const p = await ctx.newPage(); await p.goto(APP); await p.setInputFiles('#bl-file', bundle);
    try { await p.waitForFunction(() => /^godot runs/.test(document.title), null, { timeout: 30000 }); } catch (_) {}
    const t = await p.title();
    await p.waitForTimeout(1500);
    await p.evaluate(() => window.__quantiSaves && window.__quantiSaves.flush());
    await p.close(); return t;
  };
  const t1 = await run();
  ok(t1 === 'godot runs 1', 'run 1: the Godot game started from the bundle (' + t1 + ')');
  const h = await ctx.newPage(); await h.goto(APP);
  const gone = await h.evaluate(async () => {
    const mine = /^(quantinexus-sorter|quantiverse-saves|quantiverter-webretro-cores|quantiverse-pending)$/;
    const names = (await indexedDB.databases()).map(d => d.name).filter(n => !mine.test(n));
    for (const n of names) await new Promise(r => { const q = indexedDB.deleteDatabase(n); q.onsuccess = q.onerror = q.onblocked = () => r(); });
    return names;
  });
  ok(gone.length > 0, 'browser lost the game\'s own storage: ' + JSON.stringify(gone));
  await h.close();
  const t2 = await run();
  ok(t2 === 'godot runs 2', 'run 2: user:// save restored by the guard, the game continued (' + t2 + ')');
  console.log('errors:', errs.length ? errs : 'none');
  await b.close();
})().catch(e => { console.error('CRASH', e); process.exit(1); });
