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
| `$QV_LINK` | Link flags every recipe passes: the port shell, `-sENVIRONMENT=web`, memory growth |
| `$QV_CMAKE` | CMake hints that point SDL2 find-modules at Emscripten's ports |
| `$PORTS/deps/gl4es.sh` | Builds [gl4es](https://github.com/ptitSeb/gl4es) (legacy desktop OpenGL on WebGL); gives `$DEPS/gl4es/lib/libGL.a` |
| `$PORTS/deps/cmake_sdl_fix.sh` | Patches bundled `FindSDL2*.cmake` modules that insist on a system Threads package |
| `emtools/emcc`, `emtools/em++` | Wrap Emscripten so ports it downloads from GitHub archives are fetched with git instead (`emtools/portfetch.py --all` prefetches them all) |

Recipes link with plain `-sASYNCIFY` rather than the per-game `ASYNCIFY_ONLY` lists found in upstream notes: those lists are tied to a particular Emscripten version, and a stale one crashes the game at runtime.
