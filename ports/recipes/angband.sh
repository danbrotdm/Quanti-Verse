# Angband (GPL-2.0 / Angband licence, data included): the SDL2 front end with SDL2 sound.
# Savefiles (lib/save), scores, panic saves and preferences (lib/user) are kept in IndexedDB (persist.js).
# SDL_WaitEvent polls with SDL_Delay on the web, which yields to the browser under ASYNCIFY.
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$SYSROOT/lib/pkgconfig:$SYSROOT/local/lib/pkgconfig"
mkdir -p build && cd build
emcmake cmake .. $QV_CMAKE -DSUPPORT_SDL2_FRONTEND=ON -DSUPPORT_SDL2_SOUND=ON -DSUPPORT_BORG=OFF -DSC_INSTALL=ON \
  -DCMAKE_C_FLAGS="-sUSE_SDL=2 -sUSE_SDL_IMAGE=2 -sUSE_SDL_TTF=2 -sUSE_SDL_MIXER=2" > cmake.log 2>&1 || { tail -30 cmake.log; exit 1; }
emmake make -j"$JOBS" -k || true
OBJ=$(find . -path '*CMakeFiles/*' -name '*.o' | grep -v -i test)
LIBS=$(find . -name '*.a')
echo 'var Module = typeof Module != "undefined" ? Module : {}; Module.qvPersist = ["/lib/user", "/lib/save", "/lib/scores", "/lib/panic"];' > qv-persist-dirs.js
emcc -O2 $OBJ $LIBS -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_SDL_IMAGE=2 -sSDL2_IMAGE_FORMATS='["png"]' \
  -sUSE_SDL_TTF=2 -sUSE_SDL_MIXER=2 -sASYNCIFY -sSTACK_SIZE=1MB -lidbfs.js --pre-js qv-persist-dirs.js --pre-js "$QV_PERSIST_JS" \
  --preload-file ../lib@lib --exclude-file ../lib/user
