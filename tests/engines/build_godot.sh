#!/usr/bin/env bash
# Builds the Godot test games into tests/engines/ (godot4-threads.zip, godot4-nothreads.zip,
# godot3-threads.zip, godot3-plain.zip). Downloads Godot 4.3 / 3.6 and their export templates
# (~1.7 GB in total) from the official GitHub releases into tests/.work/godot.
set -e
E="$(cd "$(dirname "$0")" && pwd)"; W="$E/../.work/godot"; mkdir -p "$W"; cd "$W"
R=https://github.com/godotengine/godot/releases/download
[ -f Godot_v4.3-stable_linux.x86_64 ] || { curl -sSLo g4.zip $R/4.3-stable/Godot_v4.3-stable_linux.x86_64.zip && unzip -qo g4.zip; }
[ -f Godot_v3.6-stable_linux_headless.64 ] || { curl -sSLo g3.zip $R/3.6-stable/Godot_v3.6-stable_linux_headless.64.zip && unzip -qo g3.zip; }
T4=~/.local/share/godot/export_templates/4.3.stable; T3=~/.local/share/godot/templates/3.6.stable
[ -f $T4/web_release.zip ] || { curl -sSLo t4.tpz $R/4.3-stable/Godot_v4.3-stable_export_templates.tpz; mkdir -p $T4; unzip -qjo t4.tpz templates/web_release.zip templates/web_nothreads_release.zip templates/version.txt -d $T4; }
[ -f $T3/webassembly_release.zip ] || { curl -sSLo t3.tpz $R/3.6-stable/Godot_v3.6-stable_export_templates.tpz; mkdir -p $T3; unzip -qjo t3.tpz templates/webassembly_release.zip templates/webassembly_threads_release.zip templates/version.txt -d $T3; }
build() { # engine srcdir preset outname
  rm -rf p o && cp -r "$E/$2" p && mkdir o && (cd p && [ "$1" = 4 ] && ../Godot_v4.3-stable_linux.x86_64 --headless --path . --import >/dev/null 2>&1 || true)
  if [ "$1" = 4 ]; then (cd p && ../Godot_v4.3-stable_linux.x86_64 --headless --path . --export-release "$3" ../o/index.html >/dev/null 2>&1)
  else (cd p && ../Godot_v3.6-stable_linux_headless.64 --path . --export "$3" ../o/index.html >/dev/null 2>&1); fi
  (cd o && rm -f "$E/$4" && zip -qr "$E/$4" .)
}
build 4 godot4-src Web godot4-threads.zip; build 4 godot4-src WebNoThreads godot4-nothreads.zip
build 3 godot3-src HTML5Threads godot3-threads.zip; build 3 godot3-src HTML5 godot3-plain.zip
ls -la "$E"/godot*.zip
