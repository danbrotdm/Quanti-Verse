# Atomiks (Mateusz Viste, GPL-3.0)
emmake make -j$JOBS CC=emcc CFLAGS="-O2 -sUSE_SDL=2 -sUSE_SDL_MIXER=2" || true   # the Makefile's link step targets a desktop binary
em++ -O2 *.o -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_SDL_MIXER=2 -sSDL2_MIXER_FORMATS='["mod","wav"]' -sASYNCIFY --preload-file img/ --preload-file lev/ --preload-file snd/
