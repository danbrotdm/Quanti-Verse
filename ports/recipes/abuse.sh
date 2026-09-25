# Abuse (public domain code and data; SDL port GPL-2.0+, some tools WTFPL), from the fork's
# emscripten branch, following its EMSCRIPTEN.md. The repository leaves out the original sound
# effects and music, whose redistribution permission was given to Debian only, so the game is
# silent. Saves and settings in $HOME/.abuse are kept in IndexedDB (persist.js).
# Built at -O1: at -O2 and above the Lisp interpreter's garbage collector corrupts memory while
# loading the game scripts (undefined behaviour in the 1996 code that newer clang exploits).
mkdir -p build && cd build
emcmake cmake .. $QV_CMAKE -DCMAKE_CXX_FLAGS_RELEASE=-O1 -DCMAKE_CXX_FLAGS="-fno-strict-aliasing -fno-delete-null-pointer-checks" > cmake.log 2>&1 || { tail -30 cmake.log; exit 1; }
emmake make -j"$JOBS" -k || true
OBJ=$(find src -path '*CMakeFiles/abuse.dir/*' -name '*.o')
LIBS=$(find src -name '*.a')
test -n "$OBJ"
echo 'var Module = typeof Module != "undefined" ? Module : {}; Module.qvPersist = ["/home/web_user/.abuse"];' > qv-persist-dirs.js
em++ -O2 $OBJ $LIBS $LIBS -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_SDL_MIXER=2 -sASYNCIFY -sSTACK_SIZE=1MB \
  -lidbfs.js --pre-js qv-persist-dirs.js --pre-js "$QV_PERSIST_JS" --preload-file ../data/@data/
