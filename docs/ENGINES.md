# Engine compatibility

This is what QuantiVerter and QuantiLoader can run, grouped by the engine or packaging a web game uses, with what each one needs. It covers the engine families found in the [Ultimate Catalog of Web Game Ports](https://github.com/Carter54git/Ultimate-Catalog-Of-Web-Game-Ports).

**Tested** means a real build made with that engine runs in the test suite (`tests/run_all.sh`), including its saves where the engine has them. **Fixture** means the engine's packaging pattern is reproduced by a small test game, because the engine itself cannot be run in the test environment.

## Two things decide most cases

1. **Threads.** A multithreaded build needs `SharedArrayBuffer`, and browsers only allow that on a *cross-origin isolated* page. A page opened straight from disk (`file://`) can never be isolated. Serve Quantiverse over http(s) instead (GitHub Pages, or `python3 -m http.server` in its folder) and keep `qv-coi-sw.js` next to `index.html`. QuantiLoader then turns isolation on by itself: it reloads once and resumes the game. QuantiVerter spots threaded builds and marks them `"requires": ["crossOriginIsolated"]`.
2. **Size.** Bundles are read lazily, so a multi-gigabyte game starts at once. The browser still needs enough memory for whatever the game itself loads.

## Status by engine

| Engine / packaging | Catalog examples | Status | Needs | Verified by |
| --- | --- | --- | --- | --- |
| Plain HTML5 / JS / Canvas / WebGL | Construct, Phaser and GameMaker HTML5 games | ✅ Works | — | Tested (`webgame`) |
| Emscripten C/C++ (SDL etc.), single-threaded | most `midzer` ports: Abuse, OpenTyrian, Chocolate Doom, … | ✅ Works | — | Tested (probe builds: classic and modularized) |
| Emscripten, multithreaded (pthreads) | Source/Xash3D ports, heavier C++ ports | ✅ Works | http(s) + `qv-coi-sw.js` | Tested (`probe-threads`) |
| LÖVE via love.js, compat (single-threaded) | Balatro and other LÖVE ports | ✅ Works; saves protected | — | Tested (love.js 11.4 build: runs, saves, restore after data loss) |
| LÖVE via love.js, release (threaded) | same | ✅ Works; saves protected | http(s) + `qv-coi-sw.js` | Tested |
| Godot 4.x | Brotato, Buckshot Roulette, … | ✅ Works with audio; saves protected | Threaded exports (all of 4.0–4.2, optional in 4.3+): http(s) + `qv-coi-sw.js` | Tested (Godot 4.3, both variants) |
| Godot 3.x | Cruelty Squad, … | ✅ Works with audio; saves protected | Threaded exports: http(s) + `qv-coi-sw.js` | Tested (Godot 3.6, both variants) |
| Unity WebGL | most Unity ports | ✅ Expected to work | Threaded Unity builds (rare): http(s) | Fixture: Brotli/gzip-compressed build files |
| Flash (Ruffle) | Flash games | ✅ Works offline | AS3-heavy games depend on [Ruffle's AS3 support](https://ruffle.rs/#compatibility) | Tested (SWF loading a second SWF, SharedObject saves) |
| DOS (js-dos) | DOS games | ✅ Works offline; saves protected | Games that need DOSBox-X (Windows 9x images, sockdrive) are not supported: only the classic DOSBox core is bundled | Tested (VGA program, `SAVE.DAT` persistence on `file://`) |
| Retro consoles (WebRetro) | NES, SNES, GB/GBA, Genesis, N64, … | ✅ Works offline | Import a WebRetro package once for the cores. PS1, Saturn, 3DO and Neo-Geo CD also need a BIOS file | Pre-existing support |
| .NET WebAssembly | `celeste-wasm`, `terraria-wasm`, `stardew-wasm` | ⚠️ Partly | Computed module imports are fixed. These projects start `type: "module"` workers, which are not redirected into the bundle yet, and they are built around the player supplying their own copy of the game | Fixture: computed `import()`. .NET itself was not testable (SDK download blocked in the build environment) |
| GameCube/Wii (Dolphin) ports | Animal Crossing | ❓ Unknown | Threads (http(s)), very large data, WebGL2 | Not tested |
| Games that need their original server | online multiplayer, games streaming assets from a CDN | ❌ Not offline | A network connection to that server; bundles cannot contain a backend | — |

## What was fixed to get here

The compatibility work found and fixed these problems in QuantiVerter and QuantiLoader:

- **Threads:** cross-origin isolation through `qv-coi-sw.js`, with automatic detection, reload and resume.
- **Workers:** `new Worker(url)` on a bundle file (Emscripten `*.worker.js`) now starts from a bootstrap. The bootstrap loads the script from the bundle and replays any messages sent before it was ready, and `importScripts` is mapped into the bundle too.
- **AudioWorklets:** worklet files in the bundle (Godot's `*.audio.worklet.js`) are served as code. Without this, Godot games had no sound.
- **Script attributes:** inline handlers such as love.js's `onload="applicationLoad(this)"` were being dropped, so the game never started.
- **Data blocks:** `<script>` tags holding WebGL shaders or JSON were executed as JavaScript; they now stay in the page as data.
- **Zip roots:** a zip with files at its top level plus one folder was mis-rooted, which broke every path.
- **Page-relative absolute URLs:** URLs an engine builds from the page location (`http://host/dir/x.js`) now resolve into the bundle.
- **Web-server compression:** Brotli/gzip build files (`.br`, `.gz`, `.unityweb`) are stored decoded, because a bundle has no web server to send `Content-Encoding`.
- **ES modules:** every script in the bundle is in the import map, so imports by computed URL work.
- **Big bundles:** they are read lazily (a 1.5 GB game starts in 0.15 s instead of about 10 s, and uses about 1.5 GB less memory).
- **Saves:** love.js-style games that only save in `beforeunload` are flushed every 5 s and when the tab is hidden. See [Saves](../README.md#saves).

## Known gaps

- Module workers (`new Worker(url, { type: "module" })`) whose script is in the bundle still load from the network. This affects .NET multithreaded builds.
- DOSBox-X titles.
- Rendering in headless test browsers: WebGL output of love.js is not checked by pixels in CI, only its behaviour (run, save, restore).
