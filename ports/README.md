# Ports

Build recipes that turn games from the [Ultimate Catalog of Web Game Ports](https://github.com/Carter54git/Ultimate-Catalog-Of-Web-Game-Ports) into QuantiLoader bundles in [`../library`](../library). Only games whose code **and** data may be freely redistributed are built here; see [`../docs/CATALOG.md`](../docs/CATALOG.md) for the status of every catalog entry.

```
source <emsdk>/emsdk_env.sh          # Emscripten SDK (tested with 4.x)
python3 ports/build.py <id> ...      # or --all; ids are in games.json
```

For each game, `build.py`:

1. clones the source at the pinned ref into `ports/.work/src`, reset to a clean checkout before every build;
2. runs `recipes/<id>.sh` there, which writes the web build into `$OUT` using `shell.html` (a black full-window page with the canvas scaled to fit);
3. converts it with QuantiVerter itself and boots it in QuantiLoader with the network blocked (`tests/port_check.cjs`), which checks for page errors, network use and whether anything is drawn;
4. adds the game's metadata from `games.json` (title, developer, year, genre, licences, source) to the bundle's `manifest.json`, which QuantiSorter shows;
5. writes `library/<Title>.bootable.zip` and records the result in `results.json`.

## Helpers available to recipes

| Variable / script | What it is |
| --- | --- |
| `$OUT` | Where the recipe must write `index.html` (+ `.js`, `.wasm`, `.data`) |
| `$QV_LINK` | Link flags every recipe passes: the port shell, `-sENVIRONMENT=web`, memory growth, and save persistence (below) |
| `$QV_PERSIST_JS` | `persist.js`, for recipes that list their own save folders |
| `$QV_CMAKE` | CMake hints that point SDL2 find-modules at Emscripten's ports |
| `$PORTS/deps/gl4es.sh` | Builds [gl4es](https://github.com/ptitSeb/gl4es) (legacy desktop OpenGL on WebGL); gives `$DEPS/gl4es/lib/libGL.a` |
| `$PORTS/deps/physfs.sh` | Builds [PhysicsFS](https://github.com/icculus/physfs); gives `$DEPS/physfs/lib/libphysfs.a` |
| `$PORTS/deps/glu.sh`, `freedoom.sh` | GLU (on gl4es headers) and the Freedoom WADs |
| `$PORTS/deps/freealut.sh`, `ftgl.sh` | freealut on Emscripten's OpenAL; FTGL text on gl4es |
| `$PORTS/deps/openttd-basesets.sh` | OpenGFX, OpenSFX and OpenMSX built from source (nml, grfcodec, catcodec) |
| `$PORTS/deps/cmake_sdl_fix.sh` | Patches bundled `FindSDL2*.cmake` modules that insist on a system Threads package |
| `emtools/emcc`, `emtools/em++` | Wrap Emscripten so ports it downloads from GitHub archives are fetched with git instead (`emtools/portfetch.py --all` prefetches them all) |

`python3 ports/catalog.py` regenerates [`../docs/CATALOG.md`](../docs/CATALOG.md) and [`../library/README.md`](../library/README.md) from `catalog-snapshot.json`, `games.json` and `results.json`; the status of each catalog entry is set in that script.

## Saves

Emscripten games write to an in-memory filesystem that is lost on reload. `persist.js` backs a
game's save folders with IDBFS: they are restored before `main()` and written back every 3 s and
when the tab is hidden, and QuantiLoader's save guard then protects them like any other save.
`$QV_LINK` enables it for every port with the two usual places, `$HOME` (`/home/web_user`) and
SDL's pref path (`/libsdl`). A recipe whose game saves elsewhere either moves the save file there
(Anarch, Dungeon Rush, Haxima) or lists its own folders:

```
echo 'var Module = typeof Module != "undefined" ? Module : {}; Module.qvPersist = ["/lib/save"];' > qv-persist-dirs.js
emcc ... $QV_LINK --pre-js qv-persist-dirs.js
```

## Porting notes

Problems met while porting, and the fix each recipe uses:

- **Blocking game loops.** Recipes link with plain `-sASYNCIFY` rather than the per-game `ASYNCIFY_ONLY` lists found in upstream notes: those lists are tied to a particular Emscripten version, and a stale one crashes the game at runtime. A loop that never waits gets an explicit `emscripten_sleep(0)` per frame (Nikwi), or its buffer swap is wrapped to yield (Freegish).
- **`SDL_Delay` in SDL 1.2 games.** Emscripten's built-in SDL 1.2 maps `SDL_Delay` to `emscripten_sleep` under an alias that Asyncify does not see as asynchronous, so the first delay crashes with `unreachable`. Compile with `-DSDL_Delay=emscripten_sleep` (Nikwi). SDL2 is not affected.
- **Flicker.** If a game waits (and so yields) between drawing a frame and swapping it, the browser shows the unfinished frame. Set `SDL_HINT_EMSCRIPTEN_ASYNCIFY` to `"0"` so only the swap yields (Freegish).
- **Stack size.** Emscripten's default stack is 64 KB. Games with recursive loaders or big local buffers overflow it into the heap, which shows up as `memory access out of bounds` or a crashed tab far from the cause; give them `-sSTACK_SIZE=1MB` or more (C-Dogs SDL).
- **gl4es** needs `initialize_gl4es()` before the first GL call in some games, and only exports the core names of ARB calls (Freegish).
- **Optimiser-sensitive code.** Abuse's 1996 Lisp interpreter corrupts memory above `-O1`; build such games at `-O1`.
- **Headers that bypass gl4es.** A file that takes its GL declarations from `SDL_opengl.h` calls WebGL directly, which rejects legacy formats (`GL_CLAMP`, numeric internal formats). Make it include gl4es's `GL/gl.h` (Chromium B.S.U.).
- **Data size.** GitHub refuses files over 100 MB, so a bundle must stay under that. Re-encode music (Cro-Mag Rally) or leave the game out (Flare, SuperTux; see docs/CATALOG.md).
- **Diagnosing a crash:** `DEBUG=1 node tests/port_check.cjs <web.zip> <label>` prints the console and page error stacks. Link with `--profiling-funcs` to get function names in them. When the headless shell crashes silently, the full Chromium (`channel: 'chromium'` in Playwright) usually reports the actual error.
