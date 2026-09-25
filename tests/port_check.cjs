// Converts a game with QuantiVerter, boots it in QuantiLoader with the network blocked, and
// reports whether it runs: page errors, requests that tried to leave the machine, and how much
// is on screen over time (distinct colours in screenshots). Used to verify the catalog ports.
// usage: node port_check.cjs <source.zip> <label> [seconds]   -> prints one JSON line
const { chromium, OUT } = require('./lib.cjs');
const APP = process.env.APP || require('./lib.cjs').APP_FILE;
const path = require('path'), cp = require('child_process');
const [src, label, secs] = process.argv.slice(2);
function colors(png) {
  return Number(cp.execFileSync('python3', ['-c', `
import sys,zlib,struct
d=open(sys.argv[1],'rb').read();i=8;idat=b''
while i<len(d):
  n=struct.unpack('>I',d[i:i+4])[0];t=d[i+4:i+8];c=d[i+8:i+8+n];i+=12+n
  if t==b'IHDR':w,h=struct.unpack('>II',c[:8]);bpp={2:3,6:4}[c[9]]
  if t==b'IDAT':idat+=c
raw=zlib.decompress(idat);st=w*bpp;prev=bytearray(st);p=0;seen=set()
for y in range(h):
  f=raw[p];ln=bytearray(raw[p+1:p+1+st]);p+=1+st
  for x in range(st):
    a=ln[x-bpp] if x>=bpp else 0;b=prev[x];c=prev[x-bpp] if x>=bpp else 0
    if f==1:ln[x]=(ln[x]+a)&255
    elif f==2:ln[x]=(ln[x]+b)&255
    elif f==3:ln[x]=(ln[x]+(a+b)//2)&255
    elif f==4:
      pa=abs(b-c);pb=abs(a-c);pc=abs(a+b-2*c);ln[x]=(ln[x]+(a if pa<=pb and pa<=pc else b if pb<=pc else c))&255
  if y%4==0:
    for x in range(0,w,4): seen.add(bytes(ln[x*bpp:x*bpp+3]))
  prev=ln
print(len(seen))`, png]).toString());
}
(async () => {
  const b = await chromium.launch({ args: ['--use-angle=swiftshader', '--enable-unsafe-swiftshader', '--autoplay-policy=no-user-gesture-required'] });
  const ctx = await b.newContext({ viewport: { width: 960, height: 720 }, locale: 'en-US', acceptDownloads: true });
  const leaked = [], errs = [];
  await ctx.route('**/*', r => { const u = r.request().url(); if (/^(file|blob|data):/.test(u) || /^http:\/\/127\.0\.0\.1:876\d\//.test(u)) return r.continue(); leaked.push(u); return r.abort(); });
  ctx.on('page', p => { if (process.env.DEBUG) p.on('console', m => console.error('   [' + m.type() + '] ' + m.text().slice(0, 240))); p.on('pageerror', e => errs.push(e.message.slice(0, 200))); p.on('console', m => { if (m.type() === 'error' && !/SecurityError|Failed to load resource: net::ERR_FAILED|using emscripten GL emulation/.test(m.text())) errs.push('console: ' + m.text().slice(0, 200)); }); });
  const v = await ctx.newPage(); await v.goto(APP); await v.click('#nexusVerterBtn'); await v.setInputFiles('#zipPicker', src);
  await v.waitForFunction(() => !document.getElementById('entry').disabled, null, { timeout: 60000 });
  const [dl] = await Promise.all([v.waitForEvent('download', { timeout: 600000 }), v.click('#convert')]);
  const bundle = path.join(OUT, label + '.bootable.zip'); await dl.saveAs(bundle);
  const vlog = (await v.$$eval('#log > div', ds => ds.map(d => d.textContent))).filter(l => /WARN|FAIL/.test(l));
  await v.close();
  const p = await ctx.newPage(); await p.goto(APP); await p.setInputFiles('#bl-file', bundle);
  const shots = [], total = Number(secs || 12);
  for (let t = 3; t <= total; t += 3) {
    await p.waitForTimeout(3000);
    if (t === 6) { await p.mouse.click(480, 360).catch(() => {}); await p.keyboard.press('Enter').catch(() => {}); await p.keyboard.press('Space').catch(() => {}); }
    const f = path.join(OUT, `${label}-${t}s.png`); await p.screenshot({ path: f }); shots.push(colors(f));
  }
  const title = await p.title().catch(() => '');
  console.log(JSON.stringify({ label, bundleMB: +(require('fs').statSync(bundle).size / 1048576).toFixed(1), title, colorsOverTime: shots, errors: [...new Set(errs)].slice(0, 6), leaked: leaked.slice(0, 5), verterWarnings: vlog.slice(0, 4) }));
  await b.close();
})().catch(e => { console.log(JSON.stringify({ label: process.argv[3], crash: String(e.message || e).slice(0, 300) })); process.exit(1); });
