# FreeSiege (GPL-2.0)
mkdir -p build && cd build
emcmake cmake .. -DCMAKE_BUILD_TYPE=Release >/dev/null || true
emmake make -j$JOBS || true
cd ..
em++ -O2 $(find build -name '*.o') -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_SDL_IMAGE=2 -sSDL2_IMAGE_FORMATS='["png"]' -sUSE_SDL_MIXER=2 -sSDL2_MIXER_FORMATS='["ogg"]' -sUSE_SDL_TTF=2 -sASYNCIFY --preload-file anims/ --preload-file sounds/ --preload-file sprites/ --preload-file anims.cfg --preload-file combi.cfg --preload-file musics.cfg --preload-file sprites.cfg --preload-file Swift.ttf -Wl,-u,fileno
