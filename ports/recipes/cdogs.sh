# C-Dogs SDL: follows the project's own make_emscripten.sh (a direct emcc build of all sources),
# optimised instead of a debug build. The config headers CMake would generate come from a
# cmake -P script, since the project's configure step cannot find Emscripten's SDL2 ports.
# Loading screens and some menus wait with SDL_Delay, which only yields with ASYNCIFY.
# Its recursive directory loaders keep path buffers on the stack: give it a desktop-sized stack
# (Emscripten defaults to 64 KB, which overflows into the heap while loading sounds).
cat > qv-config.cmake <<'CM'
set(VERSION "1.4.1")
set(CDOGS_DATA_DIR "./")
set(CDOGS_CFG_DIR ".config/cdogs-sdl/")
configure_file(src/cdogs/sys_config.h.cmake src/cdogs/sys_config.h)
set(YAJL_MAJOR 2)
set(YAJL_MINOR 1)
set(YAJL_MICRO 1)
configure_file(src/cdogs/yajl/api/yajl_version.h.cmake qv-gen/yajl/yajl_version.h)
file(GLOB yajl_headers src/cdogs/yajl/api/*.h)
file(COPY ${yajl_headers} DESTINATION qv-gen/yajl)
file(READ src/cdogs/SDL_JoystickButtonNames/gamecontrollerbuttondb.txt DB)
string(REPLACE "\n" "\\n\\\n" DB "${DB}")
configure_file(src/cdogs/SDL_JoystickButtonNames/db.h.cmake src/cdogs/SDL_JoystickButtonNames/db.h)
CM
cmake -P qv-config.cmake
emcc -O2 -DPB_FIELD_16BIT=1 -Isrc/ -Isrc/cdogs/ -Isrc/proto/nanopb/ -Isrc/proto/ -Isrc/cdogs/enet/include/ \
  -Isrc/cdogs/include/ -Isrc/tests/ -Iqv-gen \
  src/*.c $(find src/cdogs/ -name "*.c") src/json/*.c src/proto/*.c src/proto/nanopb/pb_*.c \
  -sUSE_SDL=2 -sUSE_SDL_IMAGE=2 -sUSE_SDL_MIXER=2 -sSDL2_IMAGE_FORMATS='["png"]' -sUSE_VORBIS=1 -sUSE_OGG=1 \
  -lidbfs.js $QV_LINK -sASYNCIFY -sSTACK_SIZE=4MB $QV_DEBUG \
  --preload-file data --preload-file doc --preload-file dogfights --preload-file graphics \
  --preload-file missions --preload-file music --preload-file sounds \
  -o "$OUT/index.html"
