# Quantiverse

A browser game bootloader suite that lives in a single, self-contained HTML file. Open `index.html` and it runs. You don't need a server, a build step, or an install.

| Tool | Version | What it does |
| --- | --- | --- |
| **QuantiLoader** | v3.1 | Boots a `.bootable.zip` bundle: unpacks it in the browser, reads its `manifest.json`, and hands off to the game. |
| **QuantiVerter** | v5.0 | Converts Web, Unity, Flash (`.swf`), DOS (`.jsdos` / `.exe`) and retro ROM sources into bootable bundles. |
| **QuantiSorter** | v2.0 | A local game library: index, search, sort, tag, edit, and launch bundles. The library is stored in IndexedDB and can also be linked to a folder on disk. |

Build tag: `NEXUS-4`

## Running it

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

## Repository layout

```
index.html   the whole app (HTML + CSS + JS + embedded runtimes)
README.md
```

Everything ships inside `index.html` on purpose. Keep it that way: the app should always work from a double-click, fully offline.

## Embedded third-party code

- [JSZip](https://stuk.github.io/jszip/) v3.10.2, with pako (MIT / GPLv3 dual-licensed)
- [webretro](https://github.com/BinBashBanana/webretro) shell and [libretro](https://github.com/libretro) cores, packed as a base64 zip

Flash and DOS currently load [Ruffle](https://ruffle.rs) and [js-dos](https://js-dos.com) from a CDN at boot time.

## Roadmap

1. **Fully offline Flash and DOS:** embed trimmed Ruffle and js-dos runtimes, boot them through the same VFS shim that WebRetro uses, copy the runtimes into generated bundles, and remove the CDN override fields from QuantiVerter.
2. **QuantiSorter bulk actions:** multi-select, then tag, delete, or export in one step.
3. **Full library backup and restore:** a single archive that holds the index, the bundles, and the saves.
4. **Saves:** a per-game `Saves/<game>/` folder structure and hardening of save I/O, so that interrupted or stuck saves can't hang a game (the "hanging save icon" class of bug).
