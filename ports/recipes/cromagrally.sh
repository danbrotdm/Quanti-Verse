# Cro-Mag Rally (CC BY-NC-SA 4.0). Pomme (Mac Toolbox shim) and legacy GL through gl4es.
"$PORTS/deps/gl4es.sh"
git submodule update --init --depth 1 extern/Pomme
"$PORTS/deps/cmake_sdl_fix.sh" .
# The music is 68 MB of 44.1 kHz stereo IMA4 AIFF-C, which puts the bundle over GitHub's 100 MB
# file limit. Only the songs are resampled to 22.05 kHz (still stereo IMA4, a format Pomme plays);
# sound effects are untouched. Build without this step for full-quality music.
for f in Data/Audio/*Song*.aiff Data/Audio/*Theme*.aiff; do
  [ -f "$f" ] || continue
  ffmpeg -nostdin -loglevel error -y -i "$f" -ar 22050 -c:a adpcm_ima_qt -f aiff "$f.tmp.aiff" && mv "$f.tmp.aiff" "$f"
done
mkdir -p build && cd build
emcmake cmake .. $QV_CMAKE -DCMAKE_C_FLAGS="-I$DEPS/gl4es/include -sUSE_SDL=2" -DCMAKE_CXX_FLAGS="-I$DEPS/gl4es/include -sUSE_SDL=2" >/dev/null
emmake make -j$JOBS -k || true
em++ -O2 $(find . -name '*.o') $(find . -name 'libPomme.a') "$DEPS/gl4es/lib/libGL.a" -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sFULL_ES2=1 -lGL -sASYNCIFY -sINITIAL_MEMORY=512mb --preload-file ../Data@Data
