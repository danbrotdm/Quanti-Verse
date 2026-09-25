# BreakHack (GPL-3.0 code; CC-BY-SA data, see CREDITS.md), from the fork's emscripten branch,
# following its EMSCRIPTEN.md: SDL3 and its add-on libraries are git submodules built with the
# game. Saves, settings and high scores live in one SQLite file, moved from the working
# directory into /save, which is kept in IndexedDB (persist.js).
sed -i 's|#define DB_FILE ".data.db"|#define DB_FILE "/save/.data.db"|' src/db.h
grep -q '/save/.data.db' src/db.h
git submodule update --init --depth 1
git submodule foreach -q 'git clean -ffdxq; git checkout -q -- .'
# The add-ons vendor their codecs as further submodules. The game only needs PNG (SDL_image's
# built-in stb decoder), WAV and Ogg (SDL_mixer's built-in decoders) and FreeType for SDL_ttf.
git -C external/SDL_ttf submodule update --init --depth 1 external/freetype
# The version comes from `git describe`, which finds no tags in this fork's shallow clone. The
# fork follows upstream v4.0.3 (LiquidityC/breakhack).
sed -i 's|^get_version_from_git()|set(PROJECT_VERSION_MAJOR 4)\nset(PROJECT_VERSION_MINOR 0)\nset(PROJECT_VERSION_PATCH 3)\nset(PROJECT_VERSION 4.0.3)\nset(FULL_VERSION 4.0.3)|' CMakeLists.txt
grep -q 'set(PROJECT_VERSION_MAJOR 4)' CMakeLists.txt
OPTS="-DSDLTTF_HARFBUZZ=OFF -DSDLTTF_PLUTOSVG=OFF -DSDLIMAGE_BACKEND_STB=ON -DSDLIMAGE_AVIF=OFF -DSDLIMAGE_JXL=OFF -DSDLIMAGE_TIF=OFF -DSDLIMAGE_WEBP=OFF
  -DSDLMIXER_GME=OFF -DSDLMIXER_MOD=OFF -DSDLMIXER_MIDI=OFF -DSDLMIXER_OPUS=OFF -DSDLMIXER_WAVPACK=OFF -DSDLMIXER_SNDFILE=OFF
  -DSDLMIXER_FLAC_LIBFLAC=OFF -DSDLMIXER_MP3_MPG123=OFF"
emcmake cmake -B build . $QV_CMAKE $OPTS > cmake.log 2>&1 || { tail -30 cmake.log; exit 1; }
cmake --build build -j"$JOBS" || true
cd build
ls ../assets.pack ../data.pack
echo 'var Module = typeof Module != "undefined" ? Module : {}; Module.qvPersist = ["/save"];' > qv-persist-dirs.js
emcc -O2 $(find external -name '*.a') $(find lib -name '*.a') CMakeFiles/breakhack.dir/lib/sqlite3/*.o CMakeFiles/breakhack.dir/src/*.o \
  -o "$OUT/index.html" $QV_LINK -sASYNCIFY -sSTACK_SIZE=1MB -sINITIAL_HEAP=32mb \
  -lidbfs.js --pre-js qv-persist-dirs.js --pre-js "$QV_PERSIST_JS" --preload-file ../assets.pack@assets.pack --preload-file ../data.pack@data.pack
