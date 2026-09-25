// usage: node port_saves.cjs <library bundle> <file path inside the game's filesystem>
// Launches a ported game from library/ in QuantiLoader, writes a file where the game keeps its
// saves, then launches it again in a fresh page and checks the file came back (ports/persist.js
// restores it from IndexedDB), and that QuantiLoader's save guard recorded it.
const { chromium, APP_FILE } = require('./lib.cjs');
const [bundle, file] = process.argv.slice(2);
const ok = (c, m) => { console.log((c ? 'PASS ' : 'FAIL ') + m); if (!c) process.exitCode = 1; };

(async () => {
  const b = await chromium.launch({ args: ['--use-angle=swiftshader', '--enable-unsafe-swiftshader'] });
  const ctx = await b.newContext({ viewport: { width: 960, height: 720 } });
  await ctx.route('**/*', r => /^(file|blob|data):/.test(r.request().url()) ? r.continue() : r.abort());
  const launch = async () => {
    const p = await ctx.newPage();
    p.on('pageerror', e => console.log('  [pageerror]', e.message.slice(0, 200)));
    await p.goto(APP_FILE); await p.setInputFiles('#bl-file', bundle);
    // The game has started once its persisted folder is mounted and restored.
    await p.waitForFunction(d => { try { return typeof FS === 'object' && FS.analyzePath(d).exists; } catch (e) { return false; } },
      file.replace(/\/[^/]*$/, '') || '/', { timeout: 90000 });
    await p.waitForTimeout(5000);
    return p;
  };
  const token = 'quantiverse-' + Date.now();
  let p = await launch();
  await p.evaluate(([f, t]) => FS.writeFile(f, t), [file, token]);
  await p.waitForTimeout(4500);   // persist.js writes back every 3 s
  const guarded = await p.evaluate(() => new Promise(res => {
    const r = indexedDB.open('quantiverse-saves');
    r.onsuccess = () => { const db = r.result; if (!db.objectStoreNames.contains('games')) return res(0);
      const g = db.transaction('games').objectStore('games').getAll(); g.onsuccess = () => res(g.result.reduce((n, v) => n + (v.idb || []).length, 0)); };
    r.onerror = () => res(0);
  }));
  await p.close();
  p = await launch();
  const back = await p.evaluate(f => { try { return FS.readFile(f, { encoding: 'utf8' }); } catch (e) { return null; } }, file);
  ok(back === token, 'save file survives a relaunch (' + file + ')');
  ok(guarded > 0, 'save guard holds the game\'s IndexedDB saves');
  await b.close();
})();
