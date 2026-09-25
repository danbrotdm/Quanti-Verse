# Anarch (drummyfish, CC0 - public domain code and data). Everything is compiled into one C file.
# It declares emscripten_set_main_loop by hand with an int argument; current Emscripten headers
# use bool, so the real header is included instead.
python3 - <<'PY'
p = "main_sdl.c"; s = open(p).read()
s = s.replace("typedef void (*em_callback_func)(void);\nvoid emscripten_set_main_loop(\n       em_callback_func func, int fps, int simulate_infinite_loop);", "#include <emscripten.h>")
open(p, "w").write(s)
PY
emcc -O2 main_sdl.c -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -lopenal -sEXPORTED_FUNCTIONS='["_main","_webButton"]' -sEXPORTED_RUNTIME_METHODS='["ccall","cwrap"]'
