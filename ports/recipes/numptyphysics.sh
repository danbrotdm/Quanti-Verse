# Numpty Physics (GPL-3.0). Links the game's objects and Box2D (its Makefile's own link targets desktop GL).
emmake make -j$JOBS -k PKG_CONFIG=empkg-config || true
OBJ=$(find . -name '*.o' -not -path './external/Box2D/*' -not -path '*/test*')
em++ -O2 $OBJ external/Box2D/Source/Gen/float/libbox2d.a -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_SDL_IMAGE=2 -sSDL2_IMAGE_FORMATS=png -sUSE_SDL_TTF=2 -sASYNCIFY --preload-file data/ -sLEGACY_GL_EMULATION -lGL -Wl,-u,fileno
