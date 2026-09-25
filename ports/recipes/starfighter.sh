# Project: Starfighter (GPL-3.0)
./autogen.sh >/dev/null 2>&1 || autoreconf -fi >/dev/null 2>&1 || true
emconfigure ./configure SF_RUN_IN_PLACE=1 SF_NOFONT=1 SF_OLD_MUSIC=1 CFLAGS="-O2 -sUSE_SDL=2 -sUSE_SDL_IMAGE=2 -sUSE_SDL_MIXER=2" >/dev/null 2>&1 || true
emmake make -j$JOBS || true
emcc -O2 src/*.o -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_SDL_IMAGE=2 -sSDL2_IMAGE_FORMATS='["png","jpg"]' -sUSE_SDL_MIXER=2 -sSDL2_MIXER_FORMATS='["ogg","mod"]' -sASYNCIFY -sINITIAL_HEAP=32mb --preload-file gfx/ --preload-file music/ --preload-file sound/ --preload-file data/
