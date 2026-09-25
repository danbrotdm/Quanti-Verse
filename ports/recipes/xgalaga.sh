# XGalaga (GPL-2.0)
autoreconf -fi >/dev/null 2>&1 || true
emconfigure ./configure --enable-sdl2 CFLAGS="-O2 -sUSE_SDL=2 -sUSE_SDL_TTF=2 -sUSE_SDL_GFX=2 -sUSE_SDL_IMAGE=2 -sUSE_SDL_MIXER=2" >/dev/null 2>&1 || true
emmake make -j$JOBS || true
emcc -O2 $(find . -maxdepth 2 -name '*.o') -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_SDL_TTF=2 -sUSE_SDL_GFX=2 -sUSE_SDL_IMAGE=2 -sUSE_SDL_MIXER=2 -sSDL2_IMAGE_FORMATS=png -sSDL2_MIXER_FORMATS=wav -sASYNCIFY --preload-file fonts/@fonts/ --preload-file images/@images/ --preload-file levels/@levels/ --preload-file sounds/@sounds/
