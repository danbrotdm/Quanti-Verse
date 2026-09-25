# Blobby Volley 2 (GPL-2.0): SDL2 + PhysicsFS + Lua (bundled) + Boost headers. The main loop
# paces itself with SDL_Delay, which yields to the browser under ASYNCIFY.
"$PORTS/deps/physfs.sh"
mkdir -p build && cd build
emcmake cmake .. $QV_CMAKE -DPHYSFS_INCLUDE_DIR="$DEPS/physfs/include" -DPHYSFS_LIBRARY="$DEPS/physfs/lib/libphysfs.a" \
  -DBoost_INCLUDE_DIR="$SYSROOT/include" -DCMAKE_CXX_FLAGS="-sUSE_SDL=2 -sUSE_BOOST_HEADERS=1" -DCMAKE_C_FLAGS="-sUSE_SDL=2" > cmake.log 2>&1 || { tail -30 cmake.log; exit 1; }
emmake make -j"$JOBS" -k blobby gfx_zip sounds_zip scripts_zip backgrounds_zip rules_zip || true
OBJ=$(find src -path '*CMakeFiles/blobby.dir/*' -name '*.o')
LIBS=$(find src deps -name '*.a')
test -n "$OBJ"
mkdir -p ../qv-data && cp data/*.zip ../qv-data/ && cp ../data/*.lua ../data/*.xml ../data/Icon.bmp ../qv-data/
em++ -O2 $OBJ $LIBS "$DEPS/physfs/lib/libphysfs.a" -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_BOOST_HEADERS=1 \
  -lGL -sLEGACY_GL_EMULATION -sASYNCIFY -sSTACK_SIZE=1MB --preload-file ../qv-data@data
