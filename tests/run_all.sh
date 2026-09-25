#!/usr/bin/env bash
# Runs every Quantiverse browser test against ../index.html. Needs python3, node and Playwright
# with Chromium (npm i -D playwright && npx playwright install chromium, or a global install).
set -u
cd "$(dirname "$0")"
W=.work; O=$W/out; mkdir -p "$O"
fail=0
check() { if "$@"; then :; else fail=1; fi; }

python3 make_fixtures.py >/dev/null
check python3 check_syntax.py
# The "disk" save test needs a real (http) origin for its stand-in library folder.
python3 -m http.server 8766 --bind 127.0.0.1 --directory .. >/dev/null 2>&1 & SRV=$!
trap 'kill $SRV 2>/dev/null' EXIT
sleep 1

e2e() { node e2e.cjs "$W/fixtures/$1" "$O" "$2" "$3" | tee "$O/$2.log" | grep -E 'PIXELS|leave'; grep -q 'PIXELS PASS' "$O/$2.log" && grep -q 'leave the machine: none' "$O/$2.log" || fail=1; }
echo "== convert + boot offline";  e2e flashgame.zip flash "80,250,0,255,0;600,450,255,0,255;400,250,0,0,80"
e2e dosgame.zip dos "400,300,170,0,0"; e2e webgame.zip web "400,300,255,136,0"
echo "== engines: Emscripten classic + modularized"
node e2e.cjs engines/probe-classic.zip "$O" probe-classic "400,300,0,255,0" | grep PIXELS; grep -q 'PIXELS PASS' <(node e2e.cjs engines/probe-modular.zip "$O" probe-modular "400,300,0,255,0") || fail=1
echo "== engines: multithreaded (cross-origin isolation)"; check node threads.cjs engines/probe-threads.zip engines/probe-classic.zip
echo "== engines: LÖVE (love.js) single-threaded, saves via IDBFS";  check node love.cjs engines/love-compat.zip
echo "== engines: LÖVE (love.js) multithreaded over http";           APP=http://127.0.0.1:8766/index.html check node love.cjs engines/love-release.zip
if ls engines/godot*.zip >/dev/null 2>&1; then   # built by engines/build_godot.sh
  echo "== engines: Godot 4 + 3 single-threaded (file://)"; check node godot.cjs engines/godot4-nothreads.zip; check node godot.cjs engines/godot3-plain.zip
  echo "== engines: Godot 4 + 3 multithreaded (http)"; APP=http://127.0.0.1:8766/index.html check node godot.cjs engines/godot4-threads.zip; APP=http://127.0.0.1:8766/index.html check node godot.cjs engines/godot3-threads.zip
else echo "== engines: Godot skipped (run engines/build_godot.sh to build the test games)"; fi
for t in web dos flash disk; do echo "== saves: $t"; check node saves.cjs $t; done
echo "== save hardening"; check node harden.cjs
echo "== bulk actions";   check node bulk.cjs "$O"
echo "== backup/restore"; check node backup.cjs
echo "== startup";        node smoke.cjs "$O" | tail -1
if [ "${BIG:-0}" = 1 ]; then
  echo "== 1.5 GB bundle launch (streamed)"
  python3 -c "
import zipfile,os
with zipfile.ZipFile('$W/big.bootable.zip','w') as z:
  s=zipfile.ZipFile('$O/probe-classic.bootable.zip')
  for i in s.infolist(): z.writestr('big/'+i.filename.split('/',1)[1], s.read(i), compress_type=i.compress_type)
  with z.open('big/assets/level-data.pak','w',force_zip64=True) as f:
    c=os.urandom(1<<20)
    for _ in range(1536): f.write(c)"
  node bigload.cjs "$W/big.bootable.zip"; rm -f "$W/big.bootable.zip"
fi
if [ "${ZIP64:-0}" = 1 ]; then echo "== zip64 (writes 4.5 GB)"; check node zip64.cjs; fi
[ $fail = 0 ] && echo "ALL PASSED" || { echo "SOME TESTS FAILED"; exit 1; }
