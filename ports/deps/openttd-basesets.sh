#!/usr/bin/env bash
# Builds OpenTTD's free base sets from source: OpenGFX (graphics, GPL-2.0), OpenSFX (sound,
# CC-BY-SA 3.0) and OpenMSX (music, GPL-2.0). Their releases live on cdn.openttd.org and GitHub
# release pages, which the build environment cannot reach. Needs nml (pip), grfcodec, catcodec.
# Output: $DEPS/openttd-basesets/*.{grf,obg,cat,obs,obm,mid,...}
set -e
DEPS="${DEPS:-$(dirname "$0")/../.work/deps}"; mkdir -p "$DEPS"; cd "$DEPS"
OUTD="$DEPS/openttd-basesets"
[ -f "$OUTD/opengfx.obg" ] && [ -f "$OUTD/opensfx.obs" ] && [ -f "$OUTD/openmsx.obm" ] && exit 0
command -v nmlc >/dev/null || pip install -q nml
for r in grfcodec catcodec OpenGFX OpenSFX OpenMSX; do
  [ -d "ottd-$r" ] || git clone -q --depth 1 "https://github.com/OpenTTD/$r" "ottd-$r"
done
for t in grfcodec catcodec; do
  (cd "ottd-$t" && mkdir -p build && cd build && cmake .. -DCMAKE_BUILD_TYPE=Release >/dev/null && make -j"${JOBS:-4}" >/dev/null)
done
export PATH="$DEPS/ottd-grfcodec/build:$DEPS/ottd-catcodec/build:$PATH"
rm -rf "$OUTD" && mkdir -p "$OUTD"
(cd ottd-OpenGFX && make -j"${JOBS:-4}" all >/dev/null && cp *.grf opengfx.obg "$OUTD/")
(cd ottd-OpenSFX && make -j"${JOBS:-4}" all >/dev/null && cp opensfx.cat opensfx.obs "$OUTD/")
(cd ottd-OpenMSX && make -j"${JOBS:-4}" all >/dev/null && d=$(ls -d openmsx-*/ | head -1) && cp "$d"* "$OUTD/")
ls "$OUTD"
