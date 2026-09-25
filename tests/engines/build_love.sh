#!/usr/bin/env bash
# Rebuilds the love.js test games (npm: love.js 11.4.1): compat = single-threaded, release = threaded.
set -e; cd "$(dirname "$0")"; T=$(mktemp -d)
(cd love-src && zip -q -r "$T/game.love" .)
cd "$T" && npm init -y >/dev/null && npm install --silent love.js@11.4.1 >/dev/null
npx love.js game.love compat -t LoveCompat -c && npx love.js game.love release -t LoveRelease
for d in compat release; do (cd $d && zip -qr "$OLDPWD/love-$d.zip" .); done
cp love-*.zip "$(dirname "$(readlink -f "$0")")/"
