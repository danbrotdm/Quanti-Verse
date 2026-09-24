const { chromium, APP_FILE, FIXTURES, OUT: OUTDIR, WORK } = require('./lib.cjs');
const fs = require('fs'), cp = require('child_process');
const html = fs.readFileSync(require('./lib.cjs').ROOT + '/index.html', 'utf8');
const code = html.slice(html.indexOf('  const CRC_TABLE = '), html.indexOf('  async function isBackupZip('));
const ok = (c, m) => { console.log((c ? 'PASS ' : 'FAIL ') + m); if (!c) process.exitCode = 1; };
(async () => {
  const b = await chromium.launch(); const ctx = await b.newContext({ acceptDownloads: true }); const p = await ctx.newPage();
  await p.goto(APP_FILE);
  const t0 = Date.now();
  const r = await p.evaluate(async (code) => {
    eval(code + '; window.__t = { buildStoredZip, openZipIndex };');
    const chunk = new Blob([new Uint8Array(64 * 1024 * 1024).fill(7)]);
    const big = new Blob(Array(70).fill(chunk));                       // 4.48 GB, no copy
    const zip = await window.__t.buildStoredZip([{ name: 'big.bin', blob: big }, { name: 'après-4GB.txt', blob: new Blob(['hello from past 4 GB']) }]);
    const idx = await window.__t.openZipIndex(new File([zip], 't.zip'));
    const back = await idx.blob('big.bin');
    const tail = new Uint8Array(await back.slice(back.size - 4).arrayBuffer());
    window.__zip = zip;
    return { zipSize: zip.size, bigSize: back.size, bigTail: [...tail], text: await idx.text('après-4GB.txt'), names: idx.names() };
  }, code);
  console.log('  ', JSON.stringify(r), ((Date.now() - t0) / 1000).toFixed(1) + 's');
  ok(r.bigSize === 70 * 64 * 1024 * 1024 && r.bigTail.every(x => x === 7), 'ZIP64 entry (4.48 GB) reads back at full size through our reader');
  ok(r.text === 'hello from past 4 GB', 'entry stored past the 4 GB offset reads back (UTF-8 name too)');
  const [dl] = await Promise.all([p.waitForEvent('download'), p.evaluate(() => { const a = document.createElement('a'); a.href = URL.createObjectURL(window.__zip); a.download = 'z64.zip'; document.body.append(a); a.click(); })]);
  const f = OUTDIR + '/z64.zip'; await dl.saveAs(f); await b.close();
  const py = cp.execFileSync('python3', ['-c', `import zipfile,sys
z=zipfile.ZipFile(sys.argv[1]); print([(i.filename,i.file_size) for i in z.infolist()], 'testzip:', z.testzip())`, f]).toString().trim();
  console.log('   python:', py);
  ok(/testzip: None/.test(py) && py.includes('4697620480'), 'Python zipfile accepts the ZIP64 archive and every CRC');
  fs.unlinkSync(f);
})().catch(e => { console.error('CRASH', e); process.exit(1); });
