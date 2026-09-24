// usage: node e2e.cjs <source-file> <outdir> <label> <x,y,r,g,b;...>
const { chromium, APP_FILE, FIXTURES, OUT: OUTDIR, WORK } = require('./lib.cjs');
const fs = require('fs'), path = require('path');
const [src, out, label, checks] = process.argv.slice(2);
const APP = process.env.APP || APP_FILE;
(async () => {
  const browser = await chromium.launch();
  const ctx = await browser.newContext({ viewport: { width: 800, height: 600 }, locale: 'en-US', acceptDownloads: true });
  const leaked = [];
  await ctx.route('**/*', r => { const u = r.request().url(); if (/^(file|blob|data):/.test(u) || /^http:\/\/127\.0\.0\.1:876[0-9]\//.test(u)) return r.continue(); leaked.push(u); return r.abort(); });
  const errs = [];
  const watch = (p, tag) => { p.on('pageerror', e => errs.push(tag + ' pageerror: ' + e.message)); p.on('console', m => { if (m.type() === 'error') errs.push(tag + ' console: ' + m.text().slice(0, 300)); }); };

  // 1. Convert with QuantiVerter.
  const v = await ctx.newPage(); watch(v, 'verter');
  await v.goto(APP); await v.click('#nexusVerterBtn');
  await v.setInputFiles('#zipPicker', src);
  await v.waitForFunction(() => !document.getElementById('entry').disabled, null, { timeout: 15000 });
  console.log('kind note:', await v.textContent('#kindNote'));
  const t0 = Date.now();
  const [dl] = await Promise.all([v.waitForEvent('download', { timeout: 120000 }), v.click('#convert')]);
  const bundle = path.join(out, label + '.bootable.zip'); await dl.saveAs(bundle);
  console.log(`bundle: ${(fs.statSync(bundle).size / 1048576).toFixed(2)} MB in ${((Date.now() - t0) / 1000).toFixed(1)}s`);
  console.log('verter log:\n  ' + (await v.$$eval('#log > div', ds => ds.map(d => d.textContent))).join('\n  '));
  await v.close();

  // 2. Boot it with QuantiLoader.
  const p = await ctx.newPage(); watch(p, 'loader');
  await p.goto(APP); await p.setInputFiles('#bl-file', bundle);
  await p.waitForTimeout(8000);
  if (label.startsWith('flash')) { await p.mouse.click(400, 300); await p.waitForTimeout(1500); } // dismiss Ruffle's unmute overlay
  if (label.startsWith('dos')) { await p.mouse.click(424, 220); await p.waitForTimeout(6000); } // js-dos Play button
  await p.screenshot({ path: path.join(out, label + '.png') });
  const px = await p.evaluate(async (checks) => {
    // Grab the rendered frame and sample it.
    return checks;
  }, checks);
  await browser.close();
  // Sample pixels from the screenshot with a tiny PNG decoder via python (keeps this dependency-free).
  const res = require('child_process').execFileSync('python3', ['-c', `
import sys, zlib, struct
d=open(sys.argv[1],'rb').read(); i=8; w=h=0; idat=b''
while i<len(d):
  n=struct.unpack('>I',d[i:i+4])[0]; t=d[i+4:i+8]; c=d[i+8:i+8+n]; i+=12+n
  if t==b'IHDR': w,h=struct.unpack('>II',c[:8]); bpp={2:3,6:4}[c[9]]
  if t==b'IDAT': idat+=c
raw=zlib.decompress(idat); stride=w*bpp; rows=[]; prev=bytearray(stride); p=0
for y in range(h):
  f=raw[p]; line=bytearray(raw[p+1:p+1+stride]); p+=1+stride
  for x in range(stride):
    a=line[x-bpp] if x>=bpp else 0; b=prev[x]; c=prev[x-bpp] if x>=bpp else 0
    if f==1: line[x]=(line[x]+a)&255
    elif f==2: line[x]=(line[x]+b)&255
    elif f==3: line[x]=(line[x]+(a+b)//2)&255
    elif f==4:
      pa=abs(b-c); pb=abs(a-c); pc=abs(a+b-2*c)
      line[x]=(line[x]+(a if pa<=pb and pa<=pc else b if pb<=pc else c))&255
  rows.append(line); prev=line
ok=True
for spec in sys.argv[2].split(';'):
  x,y,r,g,b=map(int,spec.split(',')); px=tuple(rows[y][x*bpp:x*bpp+3]); good=all(abs(px[k]-(r,g,b)[k])<40 for k in range(3))
  ok&=good; print(f'  pixel {x},{y} = {px} want {(r,g,b)} {"OK" if good else "MISMATCH"}')
print('PIXELS', 'PASS' if ok else 'FAIL')
`, path.join(out, label + '.png'), checks]).toString();
  console.log(res.trimEnd());
  console.log('network requests that tried to leave the machine:', leaked.length ? leaked : 'none');
  console.log('errors:', errs.length ? '\n  ' + errs.join('\n  ') : 'none');
})().catch(e => { console.error('E2E CRASH', e); process.exit(1); });
