# Bombermaaan (GPL-3.0), from the fork's sdl2-emscripten branch, following its EMSCRIPTEN.md
# (plain ASYNCIFY instead of its hand-kept ASYNCIFY_ONLY list).
cd trunk && mkdir -p build && cd build
emcmake cmake .. $QV_CMAKE >/dev/null
emmake make -j"$JOBS" -k || true
OBJ=$(find . -path '*CMakeFiles/Bombermaaan*' -name '*.o')
LIB=$(find .. -name libtinyxml.a | head -1)
test -n "$OBJ" && test -n "$LIB"
em++ -O2 $OBJ "$LIB" -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_SDL_MIXER=2 \
  -sASYNCIFY -sSTACK_SIZE=1MB \
  --preload-file ../levels@levels/ --preload-file ../res/images@images/ --preload-file ../res/sounds@sounds/
