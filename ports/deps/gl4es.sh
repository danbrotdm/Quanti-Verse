#!/usr/bin/env bash
# Builds gl4es (MIT) for Emscripten: legacy desktop OpenGL (immediate mode, fixed function)
# translated to GLES2/WebGL. Several ports link against the resulting libGL.a.
# Output: $DEPS/gl4es/lib/libGL.a and $DEPS/gl4es/include
set -e
DEPS="${DEPS:-$(dirname "$0")/../.work/deps}"; mkdir -p "$DEPS"; cd "$DEPS"
[ -f gl4es/lib/libGL.a ] && exit 0
[ -d gl4es-src ] || git clone -q --depth 1 https://github.com/ptitSeb/gl4es gl4es-src
cd gl4es-src && mkdir -p build && cd build
emcmake cmake .. -DCMAKE_BUILD_TYPE=Release -DNOX11=ON -DNOEGL=ON -DSTATICLIB=ON >/dev/null
emmake make -j"${JOBS:-4}" >/dev/null
mkdir -p "$DEPS/gl4es/lib" && cp ../lib/libGL.a "$DEPS/gl4es/lib/" && cp -r ../include "$DEPS/gl4es/"
