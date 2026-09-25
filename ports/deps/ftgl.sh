#!/usr/bin/env bash
# Builds FTGL (MIT) for Emscripten: FreeType text rendered with OpenGL, on gl4es headers.
# Output: $DEPS/ftgl/lib/libftgl.a, $DEPS/ftgl/include and $DEPS/ftgl/lib/pkgconfig/ftgl.pc
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
DEPS="${DEPS:-$HERE/../.work/deps}"; mkdir -p "$DEPS"; cd "$DEPS"
[ -f ftgl/lib/libftgl.a ] && exit 0
"$HERE/gl4es.sh"
[ -d ftgl-src ] || git clone -q --depth 1 https://github.com/frankheckenbach/ftgl ftgl-src
mkdir -p ftgl/lib/pkgconfig ftgl/include ftgl-cfg
printf '#define PACKAGE_VERSION "2.4.0"\n#define __FUNC__ __func__\n' > ftgl-cfg/config.h   # what autoconf would generate that FTGL uses
for f in ftgl-src/src/*.cpp ftgl-src/src/*/*.cpp; do
  o="ftgl/lib/$(echo "${f#ftgl-src/src/}" | tr / _).o"
  em++ -O2 -sUSE_FREETYPE -I"$DEPS/gl4es/include" -Iftgl-cfg -Iftgl-src/src -Iftgl-src/src/FTFont -Iftgl-src/src/FTGlyph -Iftgl-src/src/FTLayout -c "$f" -o "$o"
done
emar rcs ftgl/lib/libftgl.a ftgl/lib/*.o && rm ftgl/lib/*.o
cp -r ftgl-src/src/FTGL ftgl/include/
printf 'Name: ftgl\nDescription: FTGL\nVersion: 2.4.0\nCflags: -I%s -sUSE_FREETYPE\nLibs: %s -sUSE_FREETYPE\n' "$DEPS/ftgl/include" "$DEPS/ftgl/lib/libftgl.a" > ftgl/lib/pkgconfig/ftgl.pc
