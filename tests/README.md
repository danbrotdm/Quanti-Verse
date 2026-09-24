# Quantiverse tests

Browser tests that drive the real `index.html` in headless Chromium through Playwright.

```
tests/run_all.sh            # everything except the 4.5 GB ZIP64 test
ZIP64=1 tests/run_all.sh    # include it
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
| `check_syntax.py` | Every inline script in `index.html` parses |
