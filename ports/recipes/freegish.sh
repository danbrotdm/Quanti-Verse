# Freegish (GPL-2.0 code, CC-BY-SA 3.0 data): legacy OpenGL through gl4es, OpenAL audio.
# The game runs many nested blocking loops (menus, levels, editor) that each end a frame with
# SDL_GL_SwapWindow; the swap is wrapped so every frame also yields to the browser (ASYNCIFY).
# gl4es only exports the core names of the ARB multitexture calls the game uses.
"$PORTS/deps/gl4es.sh"
cat > qv_swap.c <<'C'
#include <SDL2/SDL.h>
#include <emscripten.h>
void qv_swap(SDL_Window *w) { SDL_GL_SwapWindow(w); emscripten_sleep(0); }
void initialize_gl4es(void);
/* gl4es is initialised first, as the project's web branch does. The game paces frames with
   SDL_Delay between drawing and swapping; if that yielded too, the browser would show the frame
   before it is finished (flicker), so only the swap yields. */
__attribute__((constructor)) static void qv_init(void) {
  initialize_gl4es();
  SDL_SetHint(SDL_HINT_EMSCRIPTEN_ASYNCIFY, "0");
}
void gl4es_glActiveTexture(unsigned int t);
void gl4es_glMultiTexCoord2f(unsigned int t, float s, float r);
void gl4es_glActiveTextureARB(unsigned int t) { gl4es_glActiveTexture(t); }
void gl4es_glMultiTexCoord2fARB(unsigned int t, float s, float r) { gl4es_glMultiTexCoord2f(t, s, r); }
C
emcc -O2 -sUSE_SDL=2 -c qv_swap.c -o qv_swap.o
FLAGS="-O2 -DLINUX -DSDL_GL_SwapWindow=qv_swap -I$DEPS/gl4es/include -Wno-implicit-function-declaration -Wno-int-conversion -Wno-incompatible-pointer-types -sUSE_SDL=2 -sUSE_VORBIS=1 -sUSE_OGG=1 -sUSE_LIBPNG=1"
objs=(qv_swap.o)
for f in $(sed -n '/set(GISH_SRCS/,/)/p' src/CMakeLists.txt | grep '\.c' | tr -d ' '); do
  o="src/${f%.c}.o"; emcc $FLAGS -c "src/$f" -o "$o" & objs+=("$o")
  while [ "$(jobs -r | wc -l)" -ge "$JOBS" ]; do wait -n; done
done
wait
emcc -O2 "${objs[@]}" "$DEPS/gl4es/lib/libGL.a" -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sUSE_VORBIS=1 -sUSE_OGG=1 \
  -sUSE_LIBPNG=1 -lopenal -lGL -sFULL_ES2 -sASYNCIFY -sSTACK_SIZE=1MB $QV_DEBUG \
  --preload-file animation --preload-file level --preload-file music --preload-file sound --preload-file texture \
  --preload-file freegish.bmp
