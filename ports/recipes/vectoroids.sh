# Vectoroids (Bill Kendrick, GPL-2.0) - midzer's Emscripten branch.
P='-sUSE_SDL=2 -sUSE_SDL_IMAGE=2 -sSDL2_IMAGE_FORMATS=["jpg"] -sUSE_SDL_MIXER=2 -sSDL2_MIXER_FORMATS=["mod","wav"]'
emcc -O2 -c vectoroids.c -o vectoroids.o $P
em++ -O2 vectoroids.o -o "$OUT/index.html" $P $QV_LINK -sASYNCIFY --preload-file data/ -Wl,-u,fileno
