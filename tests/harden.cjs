const { chromium, APP_FILE, FIXTURES, OUT: OUTDIR, WORK } = require('./lib.cjs');
const ok = (c, m) => { console.log((c ? 'PASS ' : 'FAIL ') + m); if (!c) process.exitCode = 1; };
const APP = APP_FILE;
(async () => {
  const b = await chromium.launch(); const ctx = await b.newContext({ locale: 'en-US' });
  // 1. localStorage full: the game's save must not throw, must read back, and must be kept.
  const p = await ctx.newPage(); await p.goto(APP);
  const r = await p.evaluate(async () => {
    let i = 0;
    for (const size of [512 * 1024, 16 * 1024, 256, 8]) { const chunk = 'x'.repeat(size); try { for (;; i++) localStorage.setItem('filler' + i, chunk); } catch (e) { i++; } }
    const before = (() => { try { localStorage.setItem('probe', 'y'.repeat(200000)); return 'no-throw'; } catch (e) { return e.name; } })();
    await window.__quantiSaves.begin({ title: 'Quota Test' });
    let threw = null;
    try { localStorage.setItem('game_save', 'z'.repeat(200000)); } catch (e) { threw = e.name; }
    const readBack = (localStorage.getItem('game_save') || '').length;
    await window.__quantiSaves.snapshot();
    const toast = [...document.querySelectorAll('[role=alert]')].map(d => d.textContent)[0] || '';
    const rec = await new Promise(res => { const q = indexedDB.open('quantiverse-saves', 1); q.onsuccess = () => { const g = q.result.transaction('games').objectStore('games').get('quota test'); g.onsuccess = () => res(g.result); }; });
    for (let j = 0; j <= i; j++) localStorage.removeItem('filler' + j);
    return { before, threw, readBack, toast, saved: rec && rec.local && (rec.local.game_save || '').length };
  });
  console.log('  ', JSON.stringify({ ...r, toast: r.toast.slice(0, 90) }));
  ok(r.before === 'QuotaExceededError', 'storage really was full (a plain setItem threw ' + r.before + ')');
  ok(r.threw === null && r.readBack === 200000, 'under the guard the save did not throw and reads back');
  ok(r.saved === 200000, 'the overflowed save is kept in the save store');
  ok(/storage is full/i.test(r.toast), 'the player is told storage is full');
  await p.close();

  // 2. Another tab holds the game's database at an old version: the upgrade would hang silently.
  const other = await ctx.newPage(); await other.goto(APP);
  await other.evaluate(() => new Promise(res => { const q = indexedDB.open('lockdb', 1); q.onsuccess = () => { window.keep = q.result; res(); }; }));  // no versionchange handler: it never lets go
  const g = await ctx.newPage(); await g.goto(APP);
  const toast = await g.evaluate(async () => {
    await window.__quantiSaves.begin({ title: 'Locked Game' });
    indexedDB.open('lockdb', 2);
    await new Promise(r => setTimeout(r, 1000));
    return [...document.querySelectorAll('[role=alert]')].map(d => d.textContent)[0] || '';
  });
  ok(/locked by another tab/i.test(toast), 'a save database locked by another tab is reported: ' + toast.slice(0, 80));
  await b.close();
})();
