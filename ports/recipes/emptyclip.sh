# Empty Clip (GPL-3.0 code, CC-BY-SA art/sound). SQLite (public domain) from the amalgamation mirror.
# It catches C++ exceptions during start-up, so they are enabled (-fexceptions).
# Its asset steps (stats.db from TSV files) need the sqlite3 command-line tool on the build machine.
[ -d sqlite ] || git clone -q --depth 1 https://github.com/azadkuh/sqlite-amalgamation sqlite
"$PORTS/deps/cmake_sdl_fix.sh" .
mkdir -p build && cd build
emcmake cmake .. $QV_CMAKE -DCMAKE_C_FLAGS="-I$PWD/../sqlite" -DCMAKE_CXX_FLAGS="-fexceptions -I$PWD/../sqlite -sUSE_SDL=2 -sUSE_SDL_IMAGE=2 -sUSE_VORBIS -sUSE_FREETYPE" >/dev/null
emmake make -j$JOBS -k || true
emcc -O2 -c ../sqlite/sqlite3.c -o sqlite3.o -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0
em++ -O2 -fexceptions $(find . -name "*.o") -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_SDL_IMAGE=2 -sSDL2_IMAGE_FORMATS=png -sUSE_VORBIS -sUSE_FREETYPE -sASYNCIFY -lGL -sFULL_ES3 -lopenal -sINITIAL_MEMORY=128mb --preload-file ../working/@/
