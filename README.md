# Quantiverse

A browser game bootloader suite that lives in a single, self-contained HTML file. Open `index.html` and it runs. You don't need a server, a build step, or an install.

| Tool | Version | What it does |
| --- | --- | --- |
| **QuantiLoader** | v3.1 | Boots a `.bootable.zip` bundle: unpacks it in the browser, reads its `manifest.json`, and hands off to the game. |
| **QuantiVerter** | v5.0 | Converts Web, Unity, Flash (`.swf`), DOS (`.jsdos` / `.exe`) and retro ROM sources into bootable bundles. |
| **QuantiSorter** | v2.0 | A local game library: index, search, sort, tag, edit, and launch bundles, one at a time or in bulk (shift-click selects a range). Backs up and restores the whole library. The library is stored in IndexedDB and can also be linked to a folder on disk. |

Build tag: `NEXUS-4`

## Running it

Flash and DOS games are fully offline too: Ruffle and js-dos are built into the page, and QuantiVerter packs the emulator into each Flash or DOS bundle it makes.

- **Locally:** open `index.html` in a Chromium-based browser or in Firefox. Folder features (Scan Folder, Set Library Folder) use the File System Access API, so they need Chromium.
- **Hosted:** the file is named `index.html` so GitHub Pages can serve it without any setup. To publish it, go to *Settings → Pages* and deploy from the default branch root.

## Bundle format

A bootable bundle is a `.zip` file. The folder that holds `manifest.json` is the bundle root; when there is more than one manifest, the shallowest one wins.

```json
{
  "kind": "web",
  "title": "My Game",
  "body": "body.html",
  "preload": [],
  "postload": ["boot.js"]
}
```

- **`kind`:** one of `web`, `flash`, `dos`, `webretro`.
- **Optional metadata**, which QuantiSorter reads: `entry`, `system`, `core`, `author`, `developer`, `genre`, `year`, `tags`, `description`.

## Backups

**Back up library** in QuantiSorter downloads a single `.zip` file. It holds every game bundle (`games/`), every library entry with its tags, cover, notes, favourite and order (`quantiverse-backup.json`), and every guarded save (`saves/`). **Back up** in the bulk bar does the same for just the selected games.

To restore, use **Restore backup**, or drop the backup file on the library. A restore merges into the library: new games are added, and for games already present the newer details win. A game whose file this browser lost gets it back, and saves are imported with the newest copy winning. Nothing already in the library is deleted.

Backups are ordinary zips: entries are stored uncompressed (the bundles are zips already) and switch to ZIP64 past 4 GB. They are written and read without holding the archive in memory, so a multi-gigabyte library works the same way as a small one.

## Saves

Every game QuantiLoader starts runs under a **save guard**. All games share one origin inside Quantiverse, so their saves all live in the same `localStorage` and IndexedDB. The guard works out which data belongs to the running game: the `localStorage` keys it writes (including `localStorage.x = …` writes) and the IndexedDB records it writes. It snapshots exactly that data into a save store of its own.

- **`Saves/<game>/save.json`:** once QuantiSorter has a library folder, every snapshot is mirrored there. The file is swapped in atomically, so a crash can't leave half a save behind. When the folder is connected, saves on disk are imported and saves that exist only in the browser are written out; the newer copy wins.
- **Restore:** at launch, anything the browser has lost (cleared site data, a new browser, a restored backup) is put back before the game's scripts run. Data the browser still has is never overwritten.
- **Hardening:** a full `localStorage` no longer throws halfway through a save; the value is kept by the guard and the player is warned. IndexedDB quota errors, and databases locked by another tab, show a warning instead of leaving the game stuck on a save that never finishes. The guard also asks the browser to keep site data persistent.
- **Flash:** each game runs from its own virtual folder, so two games that both ship a `game.swf` no longer overwrite each other's SharedObjects.
- **DOS:** js-dos progress (its disk changes) is stored by the guard. js-dos's own store (OPFS) is unavailable when the page is opened from disk, where saving used to fail silently.

These fixes apply to bundles made by this version of QuantiVerter. Flash, DOS and WebRetro bundles made earlier still run, but they keep their old save behaviour until they are converted again.

## Repository layout

```
index.html                 the whole app (HTML + CSS + JS + embedded runtimes)
tools/build_runtimes.py    re-embeds the Ruffle and js-dos runtimes into index.html
README.md
```

Everything ships inside `index.html` on purpose. Keep it that way: the app should always work from a double-click, fully offline.

## Embedded third-party code

- [JSZip](https://stuk.github.io/jszip/) v3.10.2, with pako (MIT / GPLv3 dual-licensed)
- [webretro](https://github.com/BinBashBanana/webretro) shell (MIT), packed as a base64 zip. The [libretro](https://github.com/libretro) cores are imported by the user.
- [Ruffle](https://ruffle.rs) 0.6.0 (MIT / Apache-2.0). Only the WebAssembly-extensions build is included, which every current Chrome, Edge, Firefox and Safari uses.
- [js-dos](https://js-dos.com) 8.4.1 (GPL-2.0), with the classic DOSBox core only.

The Ruffle and js-dos blocks (`<script type="application/octet-stream" id="qv-runtime-…">`) are generated by `tools/build_runtimes.py`. To upgrade either runtime, change the pinned version and file list in that script and run it again.

## Roadmap

1. ~~**Fully offline Flash and DOS**~~ (done)
2. ~~**QuantiSorter bulk actions**~~ (done)
3. ~~**Full library backup and restore**~~ (done, see [Backups](#backups))
4. ~~**Saves:** `Saves/<game>/` and save hardening~~ (done, see [Saves](#saves))
