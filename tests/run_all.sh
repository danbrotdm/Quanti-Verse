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
for t in web dos flash disk; do echo "== saves: $t"; check node saves.cjs $t; done
echo "== save hardening"; check node harden.cjs
echo "== bulk actions";   check node bulk.cjs "$O"
echo "== backup/restore"; check node backup.cjs
echo "== startup";        node smoke.cjs "$O" | tail -1
if [ "${ZIP64:-0}" = 1 ]; then echo "== zip64 (writes 4.5 GB)"; check node zip64.cjs; fi
[ $fail = 0 ] && echo "ALL PASSED" || { echo "SOME TESTS FAILED"; exit 1; }
