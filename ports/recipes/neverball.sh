# Neverball (GPL-2.0, data included), following emscripten/ball.mk upstream: gl4es for GL, the
# game's Web Audio bridge (recipes/neverball/shell-extra.js), levels compiled by a host mapc.
# All level sets are preloaded, since the upstream page downloads them from neverball.org.
# The game sizes its canvas from CSS, so the page lets the canvas fill the window.
"$PORTS/deps/gl4es.sh"
make -j"$JOBS" mapc
make -j"$JOBS" sols
sh scripts/version.sh >/dev/null 2>&1 || true
# The bundle is offline and ships every level set: skip fetching the add-on list from
# play.neverball.org at start (the game then starts as it does without a connection).
sed -i 's|    return fetch_available_packages(callback);|    (void) callback; return 0;|' share/package.c
grep -q '(void) callback; return 0;' share/package.c
SRCS=$(sed -n '/^BALL_SRCS := /,/^$/p' emscripten/ball.mk | grep -o '[a-z_0-9]*/[a-z_0-9]*\.c')
# share/fbo.c is used by the offscreen level shots but not yet listed in ball.mk.
grep -q 'share/fbo.c' emscripten/ball.mk || SRCS="$SRCS share/fbo.c"
# Upstream's GL mapping for the web does not cover the framebuffer calls used by offscreen level
# shots yet (added September 2026); map them to the native functions like the other extensions.
FBO="-DglBindFramebuffer_=glBindFramebuffer -DglDeleteFramebuffers_=glDeleteFramebuffers -DglGenFramebuffers_=glGenFramebuffers -DglFramebufferTexture2D_=glFramebufferTexture2D -DglCheckFramebufferStatus_=glCheckFramebufferStatus"
CFLAGS="$FBO -O2 -std=gnu99 -Ishare -DNDEBUG -I$DEPS/gl4es/include -sUSE_SDL=2 -sUSE_SDL_TTF=2 -sUSE_LIBPNG=1 -sUSE_LIBJPEG=1"
objs=()
for f in $SRCS; do
  o="${f%.c}.em.o"; emcc $CFLAGS -c "$f" -o "$o" & objs+=("$o")
  while [ "$(jobs -r | wc -l)" -ge "$JOBS" ]; do wait -n; done
done
wait
# Data: everything the game reads, without the map sources.
rm -rf qv-data && cp -r data qv-data && find qv-data -name '*.map' -delete
# Page: the port shell with a full-window canvas plus the Neverball bridge.
python3 - "$PORTS/shell.html" "$PORTS/recipes/neverball/shell-extra.js" qv-shell.html <<'PY'
import sys
html = open(sys.argv[1]).read().replace("{{{ QV_TITLE }}}", "Neverball")
html = html.replace("#canvas{position:absolute;inset:0;margin:auto;", "#canvas{position:absolute;inset:0;width:100%;height:100%;")
html = html.replace("      if (!c.width || !c.height) return;", "      return;   // Neverball sizes the canvas itself")
html = html.replace("{{{ SCRIPT }}}", "<script>\n" + open(sys.argv[2]).read() + "</script>\n{{{ SCRIPT }}}")
open(sys.argv[3], "w").write(html)
PY
echo 'var Module = typeof Module != "undefined" ? Module : {}; Module.qvPersist = ["/neverball"];' > qv-persist-dirs.js
emcc -O2 "${objs[@]}" "$DEPS/gl4es/lib/libGL.a" -o "$OUT/index.html" $QV_LINK --shell-file qv-shell.html \
  -sUSE_SDL=2 -sUSE_SDL_TTF=2 -sUSE_LIBPNG=1 -sUSE_LIBJPEG=1 -sFULL_ES2=1 -sFETCH=1 -sEXPORTED_RUNTIME_METHODS=HEAP8 -sEXPORTED_FUNCTIONS=_main,_push_user_event,_config_set \
  -lidbfs.js --pre-js qv-persist-dirs.js --pre-js "$QV_PERSIST_JS" --preload-file qv-data@/data
