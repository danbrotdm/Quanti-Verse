# Numpty Physics (GPL-3.0)
emmake make -j$JOBS || true
em++ -O2 external/Box2D/Source/Gen/float/libbox2d.a external/glaserl/libglaserl.a external/petals_log/*.o external/stb_loader/*.o external/thp/*.o external/tinyxml2/*.o src/*.o platform/sdl2/*.o platform/gl/*.o -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_SDL_IMAGE=2 -sSDL2_IMAGE_FORMATS=png -sUSE_SDL_TTF=2 -sASYNCIFY --preload-file data/ -sLEGACY_GL_EMULATION -lGL -Wl,-u,fileno
