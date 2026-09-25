# Candy Crisis (GPL-2.0), SDL3.
mkdir -p build && cd build
emcmake cmake .. -DCMAKE_BUILD_TYPE=Release >/dev/null || true
emmake make -j$JOBS || true
emcc -O2 $(find . -name '*.o') -o "$OUT/index.html" $QV_LINK -sUSE_SDL=3 -sASYNCIFY --preload-file ../CandyCrisisResources/@CandyCrisisResources/
