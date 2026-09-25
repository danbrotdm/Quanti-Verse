# Cuyo (GPL-2.0). Data is preloaded at /data (configure needs an absolute --datadir).
./autogen.sh >/dev/null 2>&1 || autoreconf -fi >/dev/null 2>&1
emconfigure ./configure --datadir=/data CXX="em++ -std=c++14" ac_cv_lib_SDL_mixer_Mix_OpenAudio=yes ac_cv_header_SDL_mixer_h=yes ac_cv_lib_SDL_image_IMG_Load=yes ac_cv_header_SDL_image_h=yes ac_cv_lib_SDL2_mixer_Mix_OpenAudio=yes ac_cv_lib_SDL2_image_IMG_Load=yes ac_cv_lib_z_gzopen=yes CPPFLAGS="-sUSE_SDL=2 -sUSE_SDL_IMAGE=2 -sUSE_SDL_MIXER=2 -sUSE_ZLIB=1" CXXFLAGS="-O2 -sUSE_SDL=2 -sUSE_SDL_IMAGE=2 -sUSE_SDL_MIXER=2 -sUSE_ZLIB=1" >"$OUT/../configure-cuyo.log" 2>&1 || { tail -20 "$OUT/../configure-cuyo.log"; exit 1; }
emmake make -j$JOBS -k -C src CXX="em++ -std=c++14" || true
em++ -O2 src/*.o -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_SDL_IMAGE=2 -sUSE_SDL_MIXER=2 -sSDL2_MIXER_FORMATS='["wav","mod"]' -sUSE_ZLIB=1 -sASYNCIFY -sINITIAL_HEAP=32mb --preload-file data@/data/cuyo --preload-file data@/data
