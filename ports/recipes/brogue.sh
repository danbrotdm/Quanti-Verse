# Brogue CE (AGPL-3.0)
emmake make -j$JOBS || true
emcc -O2 src/*/*.o -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_SDL_IMAGE=2 -sSDL2_IMAGE_FORMATS=png -sASYNCIFY -sINITIAL_MEMORY=128mb -sSTACK_SIZE=1048576 --preload-file bin/assets/@assets/
