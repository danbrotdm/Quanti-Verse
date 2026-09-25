/* Quantiverse port helper: keeps a game's save folders in IndexedDB.
 *
 * Emscripten games write saves to an in-memory filesystem that is gone on reload. A recipe
 * lists the folders to keep in Module.qvPersist (a --pre-js placed before this one) and links
 * with -lidbfs.js. Each folder is backed by IDBFS: restored before main() runs, and written
 * back every few seconds and whenever the tab is hidden or closed. QuantiLoader's save guard
 * then snapshots those IndexedDB records like any other game save.
 */
Module.preRun = [].concat(Module.preRun || [], function () {
  var dirs = Module.qvPersist || [];
  if (!dirs.length) return;
  dirs.forEach(function (d) { FS.mkdirTree(d); FS.mount(IDBFS, {}, d); });
  addRunDependency('qv-persist');
  FS.syncfs(true, function (err) {
    if (err) console.warn('Quantiverse: could not restore saves', err);
    removeRunDependency('qv-persist');
  });
  var busy = false, again = false;
  function flush() {
    if (busy) { again = true; return; }
    busy = true;
    FS.syncfs(false, function (err) {
      busy = false;
      if (err) console.warn('Quantiverse: could not store saves', err);
      if (again) { again = false; flush(); }
    });
  }
  setInterval(flush, 3000);
  document.addEventListener('visibilitychange', function () { if (document.visibilityState === 'hidden') flush(); });
  addEventListener('pagehide', flush);
});
