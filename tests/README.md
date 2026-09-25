# Quantiverse tests

Browser tests that drive the real `index.html` in headless Chromium through Playwright.

```
tests/run_all.sh            # everything except the 4.5 GB ZIP64 test
ZIP64=1 tests/run_all.sh    # include it
BIG=1 tests/run_all.sh      # also time a 1.5 GB bundle launch
```

`make_fixtures.py` builds the test games from scratch under `tests/.work/fixtures`, so no third-party game files are needed:

- a two-part Flash movie (hand-assembled SWFs, where one loads the other at runtime)
- DOS `.COM` programs that paint the VGA screen, and one that creates `SAVE.DAT`
- small web games, one of which saves through `localStorage` and IndexedDB

| Script | Checks |
| --- | --- |
| `e2e.cjs` | Converts a source in QuantiVerter, boots the bundle in QuantiLoader with **all network blocked**, and checks screen pixels |
| `saves.cjs web\|dos\|flash\|disk` | The save guard captures saves, restores them after lost browser data, and recovers from a full wipe via `Saves/<game>/save.json` |
| `harden.cjs` | A full `localStorage` doesn't break a save; a database locked by another tab is reported |
| `bulk.cjs` | QuantiSorter selection, range select, bulk tags, favourites, delete, persistence |
| `backup.cjs` | Backup → restore in a fresh profile reproduces the library and saves; restoring again merges |
| `zip64.cjs` | A backup with a 4.5 GB entry is readable by our reader and by Python's `zipfile` |
| `threads.cjs` | A multithreaded (pthreads) game is flagged by QuantiVerter, runs after QuantiLoader switches on cross-origin isolation over http, and gets a clear explanation on `file://` |
| `love.cjs` | A LÖVE game packaged by love.js runs from its bundle, saves through `love.filesystem` (Emscripten IDBFS), and its save is restored after the browser loses it. Run with the single-threaded and the threaded build |
| `godot.cjs` | A Godot web export (4.x or 3.x, with or without threads) runs from its bundle, saves to `user://`, and its save is restored after the browser loses it. The Godot test games are built by `engines/build_godot.sh` (not committed, several MB each) |
| `bigload.cjs` | Seconds to running and memory for a big bundle (streamed, not loaded into RAM) |
| `engines/` | Engine test games: Emscripten probes (classic, threaded, modularized) built from `probe.c` by `build_probes.sh`, and love.js builds of `love-src/` made by `build_love.sh` |
| `check_syntax.py` | Every inline script in `index.html` parses |
