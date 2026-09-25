# Cro-Mag Rally (CC BY-NC-SA 4.0). Pomme (Mac Toolbox shim) and legacy GL through gl4es.
"$PORTS/deps/gl4es.sh"
git submodule update --init --depth 1 >/dev/null 2>&1 || true
mkdir -p build && cd build
emcmake cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-I$DEPS/gl4es/include" -DCMAKE_CXX_FLAGS="-I$DEPS/gl4es/include" >/dev/null || true
emmake make -j$JOBS || true
em++ -O2 $(find . -name '*.o') $(find . -name 'libPomme.a') "$DEPS/gl4es/lib/libGL.a" -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sFULL_ES2=1 -lGL -sASYNCIFY -sINITIAL_MEMORY=512mb --preload-file ../Data@Data
