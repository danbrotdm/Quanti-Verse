# Chromium B.S.U. (Clarified Artistic License). Legacy GL + GLU through gl4es, text through FTGL
# with the DejaVu Sans Bold font (free licence; the build host's fonts-dejavu-core), images
# through SDL2_image and sound through SDL2_mixer (the configure script's alternatives to glpng
# and OpenAL/ALUT). Settings and high scores (dotfiles in $HOME) are kept in IndexedDB.
"$PORTS/deps/glu.sh"
"$PORTS/deps/ftgl.sh"
G="-I$DEPS/glu/include -I$DEPS/gl4es/include"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$DEPS/ftgl/lib/pkgconfig:$SYSROOT/lib/pkgconfig"
export EM_PKG_CONFIG_PATH="$PKG_CONFIG_PATH"
mkdir -p qv-fonts && cp /usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf qv-fonts/
# Its SDL2 image path converts surfaces with a hand-built SDL_PixelFormat whose format code is
# never set, which gives garbage. Convert
# to RGBA32 by format code instead.
sed -i 's|tmp = SDL_ConvertSurface(image, &rgba, SDL_SWSURFACE);|tmp = SDL_ConvertSurfaceFormat(image, SDL_PIXELFORMAT_RGBA32, 0);|' src/Image.cpp
grep -q SDL_PIXELFORMAT_RGBA32 src/Image.cpp
# The same file takes its GL declarations from SDL_opengl.h, so its texture calls bypass gl4es
# and reach WebGL directly, which rejects the legacy formats. Use gl4es's GL/gl.h like the rest.
sed -i 's|#include <SDL_opengl.h>|#include <GL/gl.h>|' src/Image.cpp
autoreconf -fi >/dev/null 2>&1
emconfigure ./configure --disable-nls --disable-dependency-tracking --disable-glc --disable-glut --disable-sdl \
  --disable-openal --disable-sdlmixer --disable-glpng --disable-sdlimage --with-font-path=/fonts/DejaVuSans-Bold.ttf \
  CPPFLAGS="$G" LDFLAGS="-L$DEPS/glu/lib -L$DEPS/gl4es/lib" \
  ax_cv_check_glu_link=yes ac_cv_lib_GL_glBegin=yes ac_cv_lib_GLU_gluPerspective=yes ac_cv_search_glBegin="-lGL" ac_cv_search_gluPerspective="-lGLU" >configure.log 2>&1 || { tail -30 configure.log; exit 1; }
grep -E "^(#define|/\* #undef) (TEXT_|IMAGE_|AUDIO_|USE_)" config.h || true
emmake make -j$JOBS -k -C src CXXFLAGS="-O2 $G -I$DEPS/ftgl/include -sUSE_SDL=2 -sUSE_SDL_IMAGE=2 -sUSE_SDL_MIXER=2 -sUSE_FREETYPE" || true
echo 'var Module = typeof Module != "undefined" ? Module : {}; Module.qvPersist = ["/home/web_user"];' > qv-persist-dirs.js
em++ -O2 src/*.o "$DEPS/ftgl/lib/libftgl.a" "$DEPS/glu/lib/libGLU.a" "$DEPS/glu/lib/libGLU_mgl.a" "$DEPS/gl4es/lib/libGL.a" -o "$OUT/index.html" $QV_LINK \
  -sUSE_SDL=2 -sUSE_SDL_IMAGE=2 -sSDL2_IMAGE_FORMATS='["png"]' -sUSE_SDL_MIXER=2 -sUSE_FREETYPE -sFULL_ES2 -lGL -sASYNCIFY -lidbfs.js --pre-js qv-persist-dirs.js --pre-js "$QV_PERSIST_JS" \
  --preload-file data/@data/ --preload-file qv-fonts@/fonts
