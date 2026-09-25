#!/usr/bin/env bash
# Builds freealut (LGPL-2.0) for Emscripten on top of Emscripten's OpenAL.
# Output: $DEPS/freealut/lib/libalut.a and $DEPS/freealut/include/AL/alut.h
set -e
DEPS="${DEPS:-$(dirname "$0")/../.work/deps}"; mkdir -p "$DEPS"; cd "$DEPS"
[ -f freealut/lib/libalut.a ] && exit 0
[ -d freealut-src ] || git clone -q --depth 1 https://github.com/vancegroup/freealut freealut-src
mkdir -p freealut/lib freealut/include/AL
for f in freealut-src/src/*.c; do
  emcc -O2 -DHAVE_STDINT_H -DHAVE_UNISTD_H -DHAVE_NANOSLEEP -DHAVE_TIME_H -DHAVE_STAT -DHAVE_BASETSD_H=0 \
    -Ifreealut-src/include -Ifreealut-src/src -c "$f" -o "freealut/lib/$(basename "${f%.c}").o"
done
emar rcs freealut/lib/libalut.a freealut/lib/*.o && rm freealut/lib/*.o
cp freealut-src/include/AL/alut.h freealut/include/AL/
