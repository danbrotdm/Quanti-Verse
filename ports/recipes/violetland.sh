# Violetland (GPL-3.0 code, CC-BY-SA 3.0 assets). Legacy GL through gl4es.
"$PORTS/deps/gl4es.sh"
mkdir -p build && cd build
emcmake cmake .. -DDATA_INSTALL_DIR=./ -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-I$DEPS/gl4es/include -sUSE_BOOST_HEADERS=1" >/dev/null || true
emmake make -j$JOBS || true
P=""; for d in fonts images monsters music sounds weapon icon-light.png; do [ -e ../$d ] && P="$P --preload-file ../$d@$d"; done
em++ -O2 "$DEPS/gl4es/lib/libGL.a" $(find . -name '*.o') "$DEPS/gl4es/lib/libGL.a" -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_SDL_IMAGE=2 -sSDL2_IMAGE_FORMATS=png -sUSE_SDL_MIXER=2 -sSDL2_MIXER_FORMATS=ogg -sUSE_SDL_TTF=2 -sUSE_BOOST_HEADERS=1 -lGL -sFULL_ES2 -sASYNCIFY $P
