// Converts the Flash, DOS and Web fixtures with QuantiVerter and boots each bundle in QuantiLoader
// with every network request blocked, then checks pixels on screen.
// Leaves flash/dos/web .bootable.zip in tests/.out for the Sorter tests.
const fs = require('fs'), path = require('path');
const { chromium, OUT, FX, APP, ok, pixel, near } = require('./lib.cjs');

const CASES = [
  // green square comes from child.swf, loaded by game.swf at run time (asset served from the bundle)
  { label: 'flash', src: 'flashgame.zip', after: async (p) => { await p.mouse.click(400, 300); await p.waitForTimeout(1500); },
    px: [[80, 250, 0, 255, 0], [600, 450, 255, 0, 255], [400, 250, 0, 0, 80]] },
  { label: 'dos', src: 'dosgame.zip', after: async (p) => { await p.mouse.click(424, 220); await p.waitForTimeout(6000); },
    px: [[400, 300, 170, 0, 0]] },
  { label: 'web', src: 'webgame.zip', after: async () => {}, px: [[400, 300, 255, 136, 0]] }
];

(async () => {
  const browser = await chromium.launch();
  for (const c of CASES) {
    const ctx = await browser.newContext({ viewport: { width: 800, height: 600 }, locale: 'en-US', acceptDownloads: true });
    const leaked = [], errs = [];
    await ctx.route('**/*', r => { const u = r.request().url(); if (/^(file|blob|data):/.test(u)) return r.continue(); leaked.push(u); return r.abort(); });
    const watch = (p) => {
      p.on('pageerror', e => errs.push(e.message));
      // js-dos probes Cache Storage/OPFS, which Chromium refuses on file:// pages; it handles that itself.
      p.on('console', m => { if (m.type() === 'error' && !/SecurityError/.test(m.text())) errs.push(m.text().slice(0, 300)); });
    };
    const v = await ctx.newPage(); watch(v);
    await v.goto(APP); await v.click('#nexusVerterBtn');
    await v.setInputFiles('#zipPicker', path.join(FX, c.src));
    await v.waitForFunction(() => !document.getElementById('entry').disabled, null, { timeout: 15000 });
    const [dl] = await Promise.all([v.waitForEvent('download', { timeout: 120000 }), v.click('#convert')]);
    const bundle = path.join(OUT, c.label + '.bootable.zip');
    await dl.saveAs(bundle);
    await v.close();

    const p = await ctx.newPage(); watch(p);
    await p.goto(APP); await p.setInputFiles('#bl-file', bundle);
    await p.waitForTimeout(8000);
    await c.after(p);
    const shot = path.join(OUT, c.label + '.png');
    await p.screenshot({ path: shot });
    const bad = c.px.filter(([x, y, ...rgb]) => !near(pixel(shot, x, y), rgb));
    ok(!bad.length, `${c.label}: converted (${(fs.statSync(bundle).size / 1048576).toFixed(1)} MB) and rendered correctly offline`);
    ok(!leaked.length, `${c.label}: no network requests` + (leaked.length ? ' ' + JSON.stringify(leaked) : ''));
    ok(!errs.length, `${c.label}: no page errors` + (errs.length ? ' ' + JSON.stringify(errs) : ''));
    await ctx.close();
  }
  await browser.close();
})().catch(e => { console.error('CRASH', e); process.exit(1); });
