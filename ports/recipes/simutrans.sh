# Simutrans (Artistic Licence 1.0) with pak64 (Artistic Licence 1.0), from the fork's emscripten
# branch, following its EMSCRIPTEN.md. MIDI music needs a GUS patch set the branch does not
# include, so this build plays sound effects only. Saves and settings in the user folder
# (/home/web_user/simutrans) are kept in IndexedDB (persist.js).
autoreconf -fi >/dev/null 2>&1 || autoreconf
emconfigure ./configure > configure.log 2>&1 || { tail -30 configure.log; exit 1; }
emmake make -j"$JOBS" -k LTO= USE_FONTCONFIG= MULTI_THREAD= USE_FLUIDSYNTH_MIDI= USE_UPNP= USE_ZSTD= BACKEND=mixer_sdl2 || true
curl -sSL -o pak64.zip "https://downloads.sourceforge.net/project/simutrans/pak64/124-1-1/simupak64-124-1-1.zip"
unzip -qo pak64.zip
OBJ=$(find build -name '*.o' 2>/dev/null; find src -name '*.o' 2>/dev/null)
OBJ=$(echo "$OBJ" | sort -u)
test -n "$OBJ"
echo 'var Module = typeof Module != "undefined" ? Module : {}; Module.qvPersist = ["/home/web_user/simutrans"];' > qv-persist-dirs.js
cd simutrans
PRE=""; for d in pak config text font themes ai script music; do [ -e "$d" ] && PRE="$PRE --preload-file $d"; done
em++ -O2 $(cd .. && for o in $OBJ; do echo "../$o"; done) -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_BZIP2 -sUSE_LIBPNG \
  -sUSE_FREETYPE=1 -sUSE_SDL_MIXER=2 -sASYNCIFY -sASYNCIFY_STACK_SIZE=81920 -sSTACK_SIZE=1MB -sINITIAL_MEMORY=128mb \
  -Wl,-u,htons -Wl,-u,ntohs -Wl,-u,htonl -lidbfs.js --pre-js ../qv-persist-dirs.js --pre-js "$QV_PERSIST_JS" $PRE
