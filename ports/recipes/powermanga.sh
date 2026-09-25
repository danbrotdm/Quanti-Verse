# Powermanga (TLK Games, GPL-3.0)
mkdir -p build && cd build
emcmake cmake .. -DCMAKE_BUILD_TYPE=Release >/dev/null
emmake make -j$JOBS || true
emcc -O2 $(find . -name '*.o') -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_SDL_MIXER=2 -sSDL2_MIXER_FORMATS=ogg -sASYNCIFY -sINITIAL_MEMORY=128mb --preload-file ../data/@data/ --preload-file ../graphics/@graphics/ --preload-file ../sounds/@sounds/ --preload-file ../texts/@texts/
