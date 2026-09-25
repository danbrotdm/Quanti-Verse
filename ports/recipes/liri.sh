# Li-Ri (GPL-2.0)
mkdir -p build && cd build
emcmake cmake .. -DCMAKE_BUILD_TYPE=Release -DLIRI_DATA_DIR=data/ >/dev/null || true
emmake make -j$JOBS || true
em++ -O2 $(find . -name '*.o') -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_SDL_MIXER=2 -sSDL2_MIXER_FORMATS='["wav","mod"]' -sASYNCIFY -sINITIAL_HEAP=32mb --preload-file ../data/@data/ --preload-file ../Sounds/@Sounds/
