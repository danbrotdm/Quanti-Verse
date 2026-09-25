# AstroMenace (GPL-3.0 code, CC-BY-SA 4.0 / free data), from the fork's emscripten branch.
# A native build packs gamedata/ into gamedata.vfs (as upstream does with --pack); the web build
# uses gl4es + GLU for its legacy GL and freealut on Emscripten's OpenAL.
"$PORTS/deps/gl4es.sh"
"$PORTS/deps/glu.sh"
"$PORTS/deps/freealut.sh"
# Native packer: the same sources, without the branch's Emscripten-only compiler flags.
rm -rf qv-native && mkdir -p qv-native/src && cp -r src share CMakeLists.txt qv-native/src/ && ln -s "$PWD/gamedata" qv-native/src/gamedata
sed -i '/-sUSE_SDL=2/d; /-flto")/d; s/^\( *\)#SET(ALL_LIBRARIES/\1SET(ALL_LIBRARIES/' qv-native/src/CMakeLists.txt
mkdir -p qv-native/stub && echo 'static inline void initialize_gl4es(void) {}' > qv-native/stub/gl4esinit.h
(cd qv-native && export CPATH="$PWD/stub" && CC=gcc CXX=g++ cmake src -DCMAKE_BUILD_TYPE=Release >/dev/null && PATH=/usr/bin:/bin make -j"$JOBS" >/dev/null)
# (the native build packs gamedata.vfs itself as a post-link step)
cp "$(find qv-native -name gamedata.vfs | head -1)" gamedata.vfs
# The branch skips loading the config file, which also holds the pilot profiles (game progress).
# Load it again (the game saves it on every screen change), still skipping the first-start checks.
sed -i 's|bool FirstStart = false;//LoadXMLConfigFile(NeedResetConfig);|LoadXMLConfigFile(NeedResetConfig); bool FirstStart = false;|' src/main.cpp
grep -q 'LoadXMLConfigFile(NeedResetConfig); bool FirstStart = false;' src/main.cpp
# Web build.
mkdir -p build && cd build
emcmake cmake .. $QV_CMAKE -DCMAKE_CXX_FLAGS="-I$DEPS/gl4es/include -I$DEPS/glu/include -I$DEPS/freealut/include" > cmake.log 2>&1 || { tail -30 cmake.log; exit 1; }
emmake make -j"$JOBS" -k || true
OBJ=$(find . -path '*CMakeFiles/*' -name '*.o')
echo 'var Module = typeof Module != "undefined" ? Module : {}; Module.qvPersist = ["/home/web_user/.config/astromenace"];' > qv-persist-dirs.js
em++ -O2 $OBJ "$DEPS/freealut/lib/libalut.a" "$DEPS/glu/lib/libGLU_mgl.a" "$DEPS/gl4es/lib/libGL.a" -o "$OUT/index.html" $QV_LINK \
  -lopenal -sUSE_SDL=2 -sUSE_SDL_MIXER=2 -sUSE_FREETYPE -sUSE_OGG -sUSE_VORBIS -sASYNCIFY -sSTACK_SIZE=1MB -sFULL_ES2 \
  -lidbfs.js --pre-js qv-persist-dirs.js --pre-js "$QV_PERSIST_JS" --preload-file ../gamedata.vfs@/gamedata.vfs
