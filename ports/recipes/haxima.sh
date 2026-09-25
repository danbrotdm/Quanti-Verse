# Haxima on the Nazghul engine (GPL-2.0). Its .c files are C++ (the original build uses g++).
./autogen.sh >/dev/null 2>&1 || autoreconf -fi >/dev/null 2>&1 || true
emconfigure ./configure >/dev/null 2>&1 || true
emmake make -j$JOBS -k CC="em++ -x c++" CXX=em++ CFLAGS="-O2 -Wno-error -fpermissive -sUSE_SDL=2 -sUSE_SDL_IMAGE=2 -sUSE_SDL_MIXER=2 -sUSE_LIBPNG" CXXFLAGS="-O2 -sUSE_SDL=2 -sUSE_SDL_IMAGE=2 -sUSE_SDL_MIXER=2 -sUSE_LIBPNG" || true
# Saved games go to $HOME (kept in IndexedDB by persist.js) through the game's -G option;
# without it they land in the working directory next to the game files.
echo 'var Module = typeof Module != "undefined" ? Module : {}; Module.arguments = ["-G", "/home/web_user"];' > qv-args.js
em++ -O2 src/*.o -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_SDL_IMAGE=2 -sSDL2_IMAGE_FORMATS='["xpm","png"]' -sUSE_SDL_MIXER=2 -sUSE_LIBPNG -sASYNCIFY -sASYNCIFY_STACK_SIZE=81920 -sINITIAL_MEMORY=256mb --pre-js qv-args.js --preload-file worlds/haxima-1.002/@/
