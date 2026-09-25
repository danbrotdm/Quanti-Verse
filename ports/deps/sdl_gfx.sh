#!/usr/bin/env bash
# Builds SDL_gfx 2.0.25 (zlib licence) for Emscripten's built-in SDL 1.2: primitives, rotozoom,
# framerate and image filters. Output: $DEPS/sdl_gfx/lib/libSDL_gfx.a and $DEPS/sdl_gfx/include
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
DEPS="${DEPS:-$HERE/../.work/deps}"; mkdir -p "$DEPS"; cd "$DEPS"
[ -f sdl_gfx/lib/libSDL_gfx.a ] && exit 0
[ -d SDL_gfx-2.0.25 ] || curl -sSL "https://downloads.sourceforge.net/project/sdlgfx/SDL_gfx-2.0.25.tar.gz" | tar xz
mkdir -p sdl_gfx/lib sdl_gfx/include
for f in SDL_gfxPrimitives SDL_rotozoom SDL_framerate SDL_imageFilter SDL_gfxBlitFunc; do
  emcc -O2 -sUSE_SDL=1 -ISDL_gfx-2.0.25 -c "SDL_gfx-2.0.25/$f.c" -o "sdl_gfx/lib/$f.o"
done
emar rcs sdl_gfx/lib/libSDL_gfx.a sdl_gfx/lib/*.o && rm sdl_gfx/lib/*.o
cp SDL_gfx-2.0.25/*.h sdl_gfx/include/
