# OpenTTD (GPL-2.0) with the free OpenGFX/OpenSFX/OpenMSX base sets built from source.
# Follows os/emscripten/README.md upstream: host tools first, then the web build with the
# project's own shell and pre.js (which keeps saves and settings in IndexedDB). The base sets
# are preloaded, so the game starts without downloading them from the content service.
"$PORTS/deps/openttd-basesets.sh"
mkdir -p build-host && (cd build-host && cmake .. -DOPTION_TOOLS_ONLY=ON -DCMAKE_BUILD_TYPE=Release >/dev/null && make -j"$JOBS" tools >/dev/null)
mkdir -p build/baseset && cp "$DEPS"/openttd-basesets/* build/baseset/
cd build
emcmake cmake .. -DHOST_BINARY_DIR=../build-host -DCMAKE_BUILD_TYPE=Release -DOPTION_USE_ASSERTS=OFF > cmake.log 2>&1 || { tail -30 cmake.log; exit 1; }
emmake make -j"$JOBS"
cp openttd.html "$OUT/index.html"; cp openttd.js openttd.wasm openttd.data "$OUT/"
sed -i "s/openttd\.js/index.js/g" "$OUT/index.html"
mv "$OUT/openttd.js" "$OUT/index.js"
