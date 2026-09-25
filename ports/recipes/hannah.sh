# Help Hannah's Horse (GPL-2.0)
autoreconf -fi >/dev/null 2>&1 || true
emconfigure ./configure CXXFLAGS="-O2 -sUSE_SDL=2 -sUSE_SDL_MIXER=2 -sUSE_SDL_IMAGE=2 -sUSE_SDL_TTF=2" >/dev/null 2>&1 || true
emmake make -j$JOBS || true
em++ -O2 $(find . -name '*.o' -not -path './resources/*') -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_SDL_MIXER=2 -sSDL2_MIXER_FORMATS='["wav","ogg"]' -sUSE_SDL_IMAGE=2 -sSDL2_IMAGE_FORMATS=png -sUSE_SDL_TTF=2 -sASYNCIFY --preload-file resources/
