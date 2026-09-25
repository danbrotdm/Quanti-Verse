# Jump 'n Bump (Brainchild Design, GPL-2.0). The data file is packed by two small host tools.
# MOD music (libmodplug) is C++, so the link uses em++.
gcc -O2 -o gobpack modify/gobpack.c && gcc -O2 -o jnbpack modify/jnbpack.c
make -C data EXEC= GOBPACK=../gobpack JNBPACK=../jnbpack
emmake make -j$JOBS -k CC=emcc SDL_CFLAGS="-sUSE_SDL=2 -sUSE_SDL_MIXER=2" SDL_LIBS="-sUSE_SDL=2" || true
em++ -O2 $(find . -maxdepth 2 -name '*.o' -not -path './modify/*') -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_SDL_MIXER=2 -sSDL2_MIXER_FORMATS='["mod"]' -sASYNCIFY --preload-file data/jumpbump.dat@assets/jumpbump.dat
