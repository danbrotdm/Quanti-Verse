#!/usr/bin/env bash
# Rebuilds the Emscripten probe games in this folder (needs emsdk: source emsdk_env.sh first).
# Each paints the screen with the colour read from its preloaded data file (#00ff00), so a green
# screen means the engine's scripts, .wasm and .data all loaded from the bundle.
set -e; cd "$(dirname "$0")"; T=$(mktemp -d)
mkdir -p $T/data && echo "#00ff00" > $T/data/color.txt && cp probe.c $T/ && cd $T
F="-O2 --preload-file data@/data -sEXPORTED_RUNTIME_METHODS=UTF8ToString"
mkdir classic threads modular
emcc probe.c $F -o classic/index.html
emcc probe.c $F -DTHREADS -pthread -sPTHREAD_POOL_SIZE=2 -o threads/index.html
emcc probe.c $F -sMODULARIZE -sEXPORT_NAME=createGame -o modular/game.js
printf '%s' '<!doctype html><html><head><title>modular</title></head><body style="margin:0"><canvas id="canvas"></canvas><script src="game.js"></script><script>createGame({canvas:document.getElementById("canvas")});</script></body></html>' > modular/index.html
for d in classic threads modular; do (cd $d && rm -f "$OLDPWD/../probe-$d.zip" && zip -qr "$OLDPWD/probe-$d.zip" .); done
cp probe-*.zip "$(dirname "$0")" 2>/dev/null || cp probe-*.zip "$OLDPWD"
