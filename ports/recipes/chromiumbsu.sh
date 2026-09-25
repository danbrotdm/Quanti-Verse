# Chromium B.S.U. (Clarified Artistic License). Legacy GL through gl4es; OpenAL via Emscripten.
"$PORTS/deps/gl4es.sh"
autoreconf -fi >/dev/null 2>&1 || true
emconfigure ./configure --disable-nls CPPFLAGS="-I$DEPS/gl4es/include" >/dev/null 2>&1 || true
emmake make -j$JOBS -C src CXXFLAGS="-O2 -I$DEPS/gl4es/include -sUSE_SDL=2 -sUSE_FREETYPE" || true
em++ -O2 src/*.o "$DEPS/gl4es/lib/libGL.a" -o "$OUT/index.html" $QV_LINK -lopenal -sUSE_SDL=2 -sUSE_LIBPNG -sUSE_FREETYPE -sFULL_ES2 -lGL -sASYNCIFY --preload-file data/@data/
