# SDL-Ball (GPL-3.0). Legacy GL + GLU through gl4es.
"$PORTS/deps/glu.sh"
G="-I$DEPS/glu/include -I$DEPS/gl4es/include"
emmake make -j$JOBS -k CXX=em++ CXXFLAGS="-O2 $G -sUSE_SDL=2 -sUSE_SDL_TTF=2 -sUSE_SDL_MIXER=2 -sUSE_SDL_IMAGE=2" || true
em++ -O2 *.o "$DEPS/glu/lib/libGLU_mgl.a" "$DEPS/gl4es/lib/libGL.a" -sFULL_ES2 -lGL -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_SDL_TTF=2 -sUSE_SDL_MIXER=2 -sUSE_SDL_IMAGE=2 -sSDL2_IMAGE_FORMATS='["jpg","png"]' -sSDL2_MIXER_FORMATS='["ogg"]' -sSTACK_SIZE=262144 -sASYNCIFY -sASYNCIFY_STACK_SIZE=81920 --preload-file themes/ -sINITIAL_MEMORY=64MB -Wl,-u,fileno
