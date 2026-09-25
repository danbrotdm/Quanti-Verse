# Dungeon Rush (GPL-3.0)
# High scores in $HOME (kept in IndexedDB by persist.js) rather than the working directory.
sed -i 's|#define STORAGE_PATH "storage.dat"|#define STORAGE_PATH "/home/web_user/storage.dat"|' src/storage.h
grep -q '/home/web_user/storage.dat' src/storage.h
mkdir -p build && cd build
emcmake cmake .. -DCMAKE_BUILD_TYPE=Release >/dev/null
emmake make -j$JOBS || true
emcc -O2 $(find . -name '*.o') -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_SDL_IMAGE=2 -sUSE_SDL_NET=2 -sUSE_SDL_MIXER=2 -sUSE_SDL_TTF=2 -sSDL2_IMAGE_FORMATS='["png"]' -sSDL2_MIXER_FORMATS='["wav","ogg"]' -sASYNCIFY --preload-file ../res/@res/ -Wl,-u,fileno -Wl,-u,htons -Wl,-u,ntohs
