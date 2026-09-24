// Time-to-running and memory for a 1.5 GB bundle.
const { chromium, APP_FILE } = require('./lib.cjs');
(async () => {
  const b = await chromium.launch({ args: ['--js-flags=--expose-gc'] });
  const p = await b.newPage({ locale: 'en-US' });
  const errs = []; p.on('pageerror', e => errs.push(e.message)); p.on('crash', () => errs.push('PAGE CRASHED'));
  await p.goto(APP_FILE);
  const cdp = await p.context().newCDPSession(p);
  const t0 = Date.now();
  await p.setInputFiles('#bl-file', process.argv[2]);
  try { await p.waitForFunction(() => /^probe /.test(document.title), null, { timeout: 180000 }); } catch (e) { errs.push('timeout'); }
  const t = (Date.now() - t0) / 1000;
  const m = await cdp.send('Performance.getMetrics').catch(() => ({ metrics: [] }));
  const heap = (m.metrics.find(x => x.name === 'JSHeapUsedSize') || {}).value;
  const { processInfo } = await (await b.newBrowserCDPSession()).send('SystemInfo.getProcessInfo').catch(() => ({ processInfo: [] }));
  const rss = processInfo.filter(x => x.type === 'renderer').map(x => (x.cpuTime ? x : x));
  console.log(JSON.stringify({ secondsToRunning: t, title: await p.title().catch(() => '?'), jsHeapMB: heap && Math.round(heap / 1048576), errs }));
  await b.close();
})();
