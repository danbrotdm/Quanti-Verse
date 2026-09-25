# LBreakoutHD (GPL-3.0)
autoreconf -fi >/dev/null 2>&1 || true
emconfigure ./configure CFLAGS="-O2 -sUSE_SDL=2" CXXFLAGS="-O2 -sUSE_SDL=2 -sUSE_SDL_MIXER=2 -sUSE_SDL_IMAGE=2 -sUSE_SDL_TTF=2" >/dev/null 2>&1 || true
emmake make -j$JOBS || true
cd src
em++ -O2 *.o ../libgame/libgame.a -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_SDL_MIXER=2 -sSDL2_MIXER_FORMATS=wav -sUSE_SDL_IMAGE=2 -sSDL2_IMAGE_FORMATS='["jpg","png"]' -sUSE_SDL_TTF=2 -sASYNCIFY -sASYNCIFY_STACK_SIZE=81920 -sINITIAL_MEMORY=64mb --preload-file levels/ --preload-file themes/ -Wl,-u,fileno
