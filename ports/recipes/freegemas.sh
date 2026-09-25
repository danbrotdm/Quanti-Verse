# Freegemas (GPL-2.0). Needs jsoncpp (MIT), built here from source.
[ -d jsoncpp ] || git clone -q --depth 1 -b 1.9.5 https://github.com/open-source-parsers/jsoncpp jsoncpp
JS="$PWD/jsoncpp"
mkdir -p build && cd build
emcmake cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-I$JS/include" >/dev/null
emmake make -j$JOBS || true
for f in "$JS"/src/lib_json/*.cpp; do em++ -O2 -I"$JS/include" -c "$f" -o "jsoncpp_$(basename "$f" .cpp).o"; done
em++ -O2 $(find . -name '*.o') -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_SDL_IMAGE=2 -sSDL2_IMAGE_FORMATS='["png"]' -sUSE_SDL_TTF=2 -sUSE_SDL_MIXER=2 -sSDL2_MIXER_FORMATS='["ogg"]' -sASYNCIFY --preload-file ../media@media/ -Wl,-u,fileno
