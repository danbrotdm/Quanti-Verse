// Multithreaded games: QuantiVerter flags them, QuantiLoader switches on cross-origin isolation
// through qv-coi-sw.js (served over http), reloads and resumes the game by itself.
// usage: node threads.cjs <threaded-src.zip> <plain-src.zip>   (expects http://127.0.0.1:8766 serving the repo)
const { chromium, APP_FILE, OUT } = require('./lib.cjs');
const path = require('path'), cp = require('child_process');
const [threaded, plain] = process.argv.slice(2);
const HTTP = 'http://127.0.0.1:8766/index.html';
const ok = (c, m) => { console.log((c ? 'PASS ' : 'FAIL ') + m); if (!c) process.exitCode = 1; };
(async () => {
  const b = await chromium.launch();
  const ctx = await b.newContext({ viewport: { width: 800, height: 600 }, locale: 'en-US', acceptDownloads: true });
  const errs = []; ctx.on('page', p => p.on('pageerror', e => errs.push(p.url() + ' :: ' + e.message + ' :: ' + (e.stack || '').split('\n').slice(1, 3).join(' | '))));
  async function convert(src, label) {
    const v = await ctx.newPage(); await v.goto(HTTP); await v.click('#nexusVerterBtn'); await v.setInputFiles('#zipPicker', src);
    await v.waitForFunction(() => !document.getElementById('entry').disabled);
    const [dl] = await Promise.all([v.waitForEvent('download'), v.click('#convert')]);
    const f = path.join(OUT, label + '.bootable.zip'); await dl.saveAs(f);
    const log = await v.$$eval('#log > div', ds => ds.map(d => d.textContent).join('\n')); await v.close();
    const mf = JSON.parse(cp.execFileSync('python3', ['-c', 'import zipfile,sys;z=zipfile.ZipFile(sys.argv[1]);print(z.read([n for n in z.namelist() if n.endswith("manifest.json")][0]).decode())', f]).toString());
    return { f, log, mf };
  }
  const t = await convert(threaded, 'threads'), n = await convert(plain, 'classic');
  ok(JSON.stringify(t.mf.requires) === '["crossOriginIsolated"]' && /multithreaded build/.test(t.log), 'QuantiVerter flags the threaded build and warns');
  ok(Array.isArray(n.mf.requires) && n.mf.requires.length === 0, 'a plain build is recorded as needing nothing');

  // Threaded game over http: reload with isolation, then it runs.
  const p = await ctx.newPage(); await p.goto(HTTP);
  await p.setInputFiles('#bl-file', t.f);
  await p.waitForURL(/coi=1/, { timeout: 20000 });
  await p.waitForFunction(() => /^probe /.test(document.title), null, { timeout: 20000 });
  const st = await p.evaluate(() => ({ iso: crossOriginIsolated, title: document.title, url: location.search }));
  ok(st.iso && st.title === 'probe #00ff00', 'page reloaded cross-origin isolated and the threaded game ran: ' + JSON.stringify(st));
  ok(!/qvResume/.test(st.url), 'resume marker cleaned from the URL');

  // A plain game never triggers isolation.
  const q = await ctx.newPage(); await q.goto(HTTP); await q.setInputFiles('#bl-file', n.f);
  await q.waitForFunction(() => /^probe /.test(document.title), null, { timeout: 20000 });
  ok(!/coi=1/.test(q.url()) && !(await q.evaluate(() => crossOriginIsolated)), 'non-threaded game runs without a reload or isolation');

  // From disk it cannot work: say why instead of failing obscurely.
  const r = await ctx.newPage(); await r.goto(APP_FILE); await r.setInputFiles('#bl-file', t.f);
  await r.waitForSelector('#bl-ui[data-state="fault"]', { timeout: 20000 });
  const msg = await r.textContent('#bl-log');
  ok(/multithreaded/.test(msg) && /http\.server/.test(msg), 'file:// explains what the game needs');
  console.log('errors:', errs.length ? errs : 'none');
  await b.close();
})().catch(e => { console.error('CRASH', e); process.exit(1); });
