const { chromium, APP_FILE, FIXTURES, OUT: OUTDIR, WORK } = require('./lib.cjs');
(async () => {
  const b = await chromium.launch();
  const p = await b.newPage({ viewport: { width: 1280, height: 860 } });
  const errs = [];
  p.on('pageerror', e => errs.push('pageerror: ' + e.message));
  p.on('console', m => { if (m.type() === 'error') errs.push('console: ' + m.text()); });
  await p.goto(APP_FILE);
  await p.waitForTimeout(2500);
  const dir = process.argv[2] || OUTDIR; await p.screenshot({ path: dir + '/boot.png' });
  for (const m of await p.$$('#nexus-modebar .nexus-mode')) {
    const t = (await m.textContent()).trim(); await m.click(); await p.waitForTimeout(600);
    await p.screenshot({ path: dir + '/mode-' + t.replace(/\W+/g,'_') + '.png' });
    console.log('mode:', t);
  }
  console.log(errs.length ? errs.join('\n') : 'no errors');
  await b.close();
})();
