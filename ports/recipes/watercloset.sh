# Water Closet (GPL-3.0). Its two MP3 tracks are re-encoded as Ogg under the same names (SDL_mixer
# detects the format from the data), because Emscripten's MP3 decoder port is not reachable here.
for f in music/*.mp3; do ffmpeg -loglevel error -y -i "$f" -c:a libvorbis -q:a 5 -f ogg "$f.tmp" && mv "$f.tmp" "$f"; done
sed -i 's/-Werror//g' makefile common.mk
emmake make -j$JOBS -k CC="emcc -O2 -sUSE_SDL=2 -sUSE_SDL_MIXER=2 -sUSE_SDL_IMAGE=2 -sUSE_SDL_TTF=2" || true
OBJ=$(find . -name '*.o' | grep -vE '/tools/|mapEditor')   # mapEditor is a separate program
emcc -O2 $OBJ -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_SDL_MIXER=2 -sSDL2_MIXER_FORMATS='["ogg"]' -sUSE_SDL_IMAGE=2 -sSDL2_IMAGE_FORMATS='["png"]' -sUSE_SDL_TTF=2 -sASYNCIFY --preload-file data/@data/ --preload-file fonts/@fonts/ --preload-file gfx/@gfx/ --preload-file music/@music/ --preload-file sound/@sound/ -Wl,-u,fileno
