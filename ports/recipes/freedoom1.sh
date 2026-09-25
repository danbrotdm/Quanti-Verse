# Freedoom: Phase 1 (BSD-3-Clause data) on Chocolate Doom (GPL-2.0). The IWAD is found in the
# working directory; music plays through Chocolate Doom's OPL emulation.
"$PORTS/deps/freedoom.sh"
cp "$DEPS/freedoom/freedoom1.wad" .
mkdir -p build && cd build
emcmake cmake .. $QV_CMAKE >/dev/null
emmake make -j$JOBS -k || true
cd src
emcc -O2 CMakeFiles/chocolate-doom.dir/*.o doom/libdoom.a ../opl/libopl.a ../textscreen/libtextscreen.a ../pcsound/libpcsound.a -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_SDL_MIXER=2 -sSDL2_MIXER_FORMATS='["mid"]' -sUSE_LIBPNG -sASYNCIFY -sINITIAL_HEAP=32mb --preload-file ../../freedoom1.wad@freedoom1.wad -Wl,-u,htons,-u,ntohs
