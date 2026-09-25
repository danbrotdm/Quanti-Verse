# Chromium B.S.U. (Clarified Artistic License). Legacy GL + GLU through gl4es; OpenAL via Emscripten.
"$PORTS/deps/glu.sh"
G="-I$DEPS/glu/include -I$DEPS/gl4es/include"
autoreconf -fi >/dev/null 2>&1
emconfigure ./configure --disable-nls --disable-dependency-tracking CPPFLAGS="$G" LDFLAGS="-L$DEPS/glu/lib -L$DEPS/gl4es/lib" \
  ac_cv_lib_GL_glBegin=yes ac_cv_lib_GLU_gluPerspective=yes ac_cv_search_glBegin="-lGL" ac_cv_search_gluPerspective="-lGLU" >"$OUT/../configure-chromiumbsu.log" 2>&1 || { tail -20 "$OUT/../configure-chromiumbsu.log"; exit 1; }
emmake make -j$JOBS -k -C src CXXFLAGS="-O2 $G -sUSE_SDL=2 -sUSE_FREETYPE" || true
em++ -O2 src/*.o "$DEPS/glu/lib/libGLU.a" "$DEPS/gl4es/lib/libGL.a" -o "$OUT/index.html" $QV_LINK -lopenal -sUSE_SDL=2 -sUSE_LIBPNG -sUSE_FREETYPE -sFULL_ES2 -lGL -sASYNCIFY --preload-file data/@data/
