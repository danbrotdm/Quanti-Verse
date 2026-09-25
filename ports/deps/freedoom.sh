#!/usr/bin/env bash
# Freedoom 0.13.0 (BSD-3-Clause): free game data for Doom engines. Output: $DEPS/freedoom/*.wad
set -e
DEPS="${DEPS:-$(dirname "$0")/../.work/deps}"; mkdir -p "$DEPS"; cd "$DEPS"
[ -f freedoom/freedoom1.wad ] && exit 0
curl -sSL -o freedoom.zip https://github.com/freedoom/freedoom/releases/download/v0.13.0/freedoom-0.13.0.zip
rm -rf freedoom && mkdir freedoom && unzip -qjo freedoom.zip '*.wad' '*COPYING*' -d freedoom
