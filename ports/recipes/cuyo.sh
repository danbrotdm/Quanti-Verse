# Cuyo (GPL-2.0)
./autogen.sh >/dev/null 2>&1 || autoreconf -fi >/dev/null 2>&1 || true
emconfigure ./configure --datadir=./data CXXFLAGS="-O2 -sUSE_SDL=2 -sUSE_SDL_IMAGE=2 -sUSE_SDL_MIXER=2 -sUSE_ZLIB=1" >/dev/null 2>&1 || true
emmake make -j$JOBS -C src || true
em++ -O2 src/*.o -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_SDL_IMAGE=2 -sUSE_SDL_MIXER=2 -sSDL2_MIXER_FORMATS='["wav","mod"]' -sUSE_ZLIB=1 -sASYNCIFY -sINITIAL_HEAP=32mb --preload-file data/
