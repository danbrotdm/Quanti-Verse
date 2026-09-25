#!/usr/bin/env bash
# Builds GLU (SGI Free Software License B, via ptitSeb/GLU, the GLU used with gl4es) for
# Emscripten. Output: $DEPS/glu/lib/libGLU.a, headers in $DEPS/glu/include
set -e
DEPS="${DEPS:-$(dirname "$0")/../.work/deps}"; mkdir -p "$DEPS"; cd "$DEPS"
[ -f glu/lib/libGLU_mgl.a ] && [ -f glu/.gl4es-headers ] && exit 0
"$(dirname "$0")/gl4es.sh"
[ -d glu-src ] || git clone -q --depth 1 https://github.com/ptitSeb/GLU glu-src
cd glu-src
mkdir -p "$DEPS/glu/lib" "$DEPS/glu/include/GL"
SRC=$(find src -name '*.c' -o -name '*.cc' | grep -vE '/(test|samples?)/|priorityq-heap\.c')   # priorityq-heap.c is #included by priorityq.c
objs=""
for f in $SRC; do
  o="obj/$(echo "$f" | tr '/' '_').o"; mkdir -p obj
  case "$f" in *.cc) em++ -std=c++14 -O2 -DNDEBUG -DLIBRARYBUILD -I"$DEPS/gl4es/include" -Iinclude -Isrc/include -Isrc/libnurbs/internals -Isrc/libnurbs/interface -Isrc/libnurbs/nurbtess -I"$DEPS/gl4es/include" -c "$f" -o "$o" ;;
                 *)    emcc -O2 -DNDEBUG -DLIBRARYBUILD -I"$DEPS/gl4es/include" -Iinclude -Isrc/include -I"$DEPS/gl4es/include" -c "$f" -o "$o" ;; esac
  objs="$objs $o"
done
emar rcs "$DEPS/glu/lib/libGLU.a" $objs
# Some games include a glu.h built with USE_MGL_NAMESPACE, which renames every gluX to mgluX.
# GLU's gl.h then also wants Mesa's gl_mangle.h (renaming glX to mglX); gl4es provides the plain
# names, so an empty one keeps GL itself unmangled.
mkdir -p mgl-include && : > mgl-include/gl_mangle.h
mobjs=""
for f in $SRC; do
  o="obj/mgl_$(echo "$f" | tr '/' '_').o"
  case "$f" in *.cc) em++ -std=c++14 -O2 -DNDEBUG -DUSE_MGL_NAMESPACE -DLIBRARYBUILD -I"$DEPS/gl4es/include" -Imgl-include -Iinclude -Isrc/include -Isrc/libnurbs/internals -Isrc/libnurbs/interface -Isrc/libnurbs/nurbtess -I"$DEPS/gl4es/include" -c "$f" -o "$o" ;;
                 *)    emcc -O2 -DNDEBUG -DUSE_MGL_NAMESPACE -DLIBRARYBUILD -I"$DEPS/gl4es/include" -Imgl-include -Iinclude -Isrc/include -I"$DEPS/gl4es/include" -c "$f" -o "$o" ;; esac
  mobjs="$mobjs $o"
done
emar rcs "$DEPS/glu/lib/libGLU_mgl.a" $mobjs
touch "$DEPS/glu/.gl4es-headers"
cp include/GL/*.h "$DEPS/glu/include/GL/"
