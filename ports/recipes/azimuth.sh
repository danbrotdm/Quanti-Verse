# Azimuth (GPL-3.0). Legacy GL through gl4es.
"$PORTS/deps/gl4es.sh"
emmake make -j$JOBS -k CC=emcc CFLAGS="-Isrc -I$DEPS/gl4es/include -O2 -Wno-error -sUSE_SDL=2" || true
# The Makefile embeds the resource blob with the host linker (ld -r -b binary), which gives a
# native object. Embed it as a C array instead; only _binary_resources_start is used.
O=$(dirname "$(find out -name resources -path '*/system/*' | head -1)")
printf 'const char _binary_resources_start[] = {\n#embed "resources"\n};\n' > "$O/resource_blob_data.c"
(cd "$O" && emcc -std=c23 -O2 -c resource_blob_data.c -o resource_blob_data.o)
OBJ=$(find out -path '*/obj/azimuth/*' -name '*.o')   # the game only; editor, muse, test and zfxr are tools
emcc -O2 $OBJ "$DEPS/gl4es/lib/libGL.a" -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sFULL_ES2 -lGL -sASYNCIFY --preload-file data/music/@music/ --preload-file data/rooms/@rooms/
