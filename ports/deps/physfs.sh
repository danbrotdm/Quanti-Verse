#!/usr/bin/env bash
# Builds PhysicsFS (zlib licence) for Emscripten as a static library.
# Output: $DEPS/physfs/lib/libphysfs.a and $DEPS/physfs/include
set -e
DEPS="${DEPS:-$(dirname "$0")/../.work/deps}"; mkdir -p "$DEPS"; cd "$DEPS"
[ -f physfs/lib/libphysfs.a ] && exit 0
[ -d physfs-src ] || git clone -q --depth 1 -b release-3.2.0 https://github.com/icculus/physfs physfs-src
cd physfs-src && mkdir -p build && cd build
emcmake cmake .. -DCMAKE_BUILD_TYPE=Release -DPHYSFS_BUILD_SHARED=OFF -DPHYSFS_BUILD_TEST=OFF -DPHYSFS_BUILD_DOCS=OFF >/dev/null
emmake make -j"${JOBS:-4}" >/dev/null
mkdir -p "$DEPS/physfs/lib" "$DEPS/physfs/include" && cp libphysfs.a "$DEPS/physfs/lib/" && cp ../src/physfs.h "$DEPS/physfs/include/"
