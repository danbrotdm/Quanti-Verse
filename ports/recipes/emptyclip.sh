# Empty Clip (GPL-3.0 code, CC-BY-SA art/sound)
mkdir -p build && cd build
emcmake cmake .. -DCMAKE_BUILD_TYPE=Release >/dev/null || true
emmake make -j$JOBS || true
em++ -O2 $(find . -name '*.o') $(find . -name '*.a') -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_SDL_IMAGE=2 -sSDL2_IMAGE_FORMATS=png -sUSE_VORBIS -sUSE_FREETYPE -sASYNCIFY -lGL -sFULL_ES3 -lopenal -sINITIAL_MEMORY=128mb --preload-file ../working/@/
