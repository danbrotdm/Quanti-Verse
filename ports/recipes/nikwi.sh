# Nikwi Deluxe: SDL 1.2 (Emscripten's built-in SDL). The data pack is made with the game's own
# host tools; the main loop never waits, so it gets a yield per frame (ASYNCIFY sleep). SDL_Delay
# is Emscripten's alias of emscripten_sleep, which Asyncify does not see as an async import, so
# the game calls emscripten_sleep directly.
make tools CC=gcc
./makedata.sh
./makepack.sh
sed -i 's/^\(\t\tdraw();\)$/\1\n\t\temscripten_sleep(0);/' src/nikwi/main.cpp
grep -q emscripten_sleep src/nikwi/main.cpp
FLAGS="${QV_OPT:--O2} -include emscripten.h -DSDL_Delay=emscripten_sleep -D_GNU_SOURCE -include sys/types.h -Wno-write-strings -Isrc/badcfg -Isrc/nikwi -Isrc/slashfx -Isrc/slashtdp -Isrc/us"
objs=()
for f in src/nikwi/*.cpp src/slashtdp/*.cpp src/us/*.cpp src/slashfx/main.c src/badcfg/main.c; do
  o="${f%.*}.o"; cc=em++; [ "${f##*.}" = c ] && cc=emcc; $cc $FLAGS -c "$f" -o "$o" & objs+=("$o")
  while [ "$(jobs -r | wc -l)" -ge "$JOBS" ]; do wait -n; done
done
wait
em++ $QV_DEBUG ${QV_OPT:--O2} "${objs[@]}" -o "$OUT/index.html" $QV_LINK -sASYNCIFY --preload-file justdata.up@justdata.up
