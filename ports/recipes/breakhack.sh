# BreakHack (GPL-3.0), SDL3 build through CMake.
emcmake cmake -B build . -DCMAKE_BUILD_TYPE=Release >/dev/null || true
cmake --build build -j$JOBS || true
cd build
emcc -O2 $(find external -name '*.a') $(find lib -name '*.a') CMakeFiles/breakhack.dir/lib/sqlite3/*.o CMakeFiles/breakhack.dir/src/*.o -o "$OUT/index.html" $QV_LINK -sASYNCIFY -sINITIAL_HEAP=32mb --preload-file assets.pack --preload-file data.pack
