#!/usr/bin/env bash
# Many games ship their own FindSDL2*.cmake that insist on a system Threads package, which
# Emscripten's toolchain does not report. Patch them (in the source tree being built) to accept
# -lpthread, a no-op under Emscripten.
find "${1:-.}" -iname 'FindSDL2*.cmake' -print0 | xargs -0 -r sed -i 's/find_package(Threads\( QUIET\)\{0,1\})/&\nset(CMAKE_THREAD_LIBS_INIT "-lpthread")/'
