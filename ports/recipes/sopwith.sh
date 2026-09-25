# SDL Sopwith (GPL-2.0). No external data: the planes and ground are built into the program.
./autogen.sh >/dev/null 2>&1 || autoreconf -fi >/dev/null 2>&1
emconfigure ./configure CFLAGS="-O2 -sUSE_SDL=2" >"$OUT/../configure-sopwith.log" 2>&1 || { tail -15 "$OUT/../configure-sopwith.log"; exit 1; }
emmake make -j$JOBS -k || true
OBJ=$(find src -name '*.o')
emcc -O2 $OBJ -o "$OUT/index.html" $QV_LINK -sUSE_SDL=2 -sASYNCIFY -sFORCE_FILESYSTEM -lidbfs.js -Wl,-u,ntohs
