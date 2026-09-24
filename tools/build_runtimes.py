#!/usr/bin/env python3
"""Embed the offline Flash (Ruffle) and DOS (js-dos) runtimes into index.html.

Downloads the pinned npm packages, keeps only the files a browser actually
loads at run time, zips each runtime and writes it into index.html as a
base64 <script type="application/octet-stream" id="qv-runtime-..."> block.
Those blocks are inert data: the page only decodes one when QuantiVerter
builds a Flash or DOS bundle.

Usage:  python3 tools/build_runtimes.py            (needs `npm` on PATH)
"""
import base64, io, os, re, subprocess, sys, tarfile, tempfile, zipfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
INDEX = os.path.join(ROOT, "index.html")

RUNTIMES = [
    {
        "id": "qv-runtime-ruffle",
        "package": "@ruffle-rs/ruffle@0.6.0",
        "version": "0.6.0",
        # ruffle.js picks the "WebAssembly extensions" build whenever the browser supports
        # SIMD, bulk memory, reference types, sign extension and saturating float-to-int
        # (every current Chrome, Edge, Firefox and Safari). The vanilla build for older
        # engines is left out: it would add another ~5 MB to every Flash bundle.
        "files": {
            "ruffle.js": "package/ruffle.js",
            "core.ruffle.c80159b526e567babaf5.js": "package/core.ruffle.c80159b526e567babaf5.js",
            "826bb0938097485a2c9d.wasm": "package/826bb0938097485a2c9d.wasm",
            "LICENSE_MIT": "package/LICENSE_MIT",
            "LICENSE_APACHE": "package/LICENSE_APACHE",
        },
    },
    {
        "id": "qv-runtime-jsdos",
        "package": "js-dos@8.4.1",
        "version": "8.4.1",
        # The classic DOSBox core only (the boot script locks js-dos to it). DOSBox-X,
        # its JSPI variant and the networking/file-explorer extras are left out.
        "files": {
            "js-dos.js": "package/dist/js-dos.js",
            "js-dos.css": "package/dist/js-dos.css",
            "emulators/emulators.js": "package/dist/emulators/emulators.js",
            "emulators/wdosbox.js": "package/dist/emulators/wdosbox.js",
            "emulators/wdosbox.wasm": "package/dist/emulators/wdosbox.wasm",
            "emulators/wlibzip.js": "package/dist/emulators/wlibzip.js",
            "emulators/wlibzip.wasm": "package/dist/emulators/wlibzip.wasm",
            "README.md": "package/README.md",
        },
    },
]

SOURCE_MAP = re.compile(rb"\n?//# sourceMappingURL=[^\n]*\s*$")


def fetch(package, workdir):
    out = subprocess.run(["npm", "pack", package, "--silent"], cwd=workdir,
                         check=True, capture_output=True, text=True).stdout.strip().splitlines()[-1]
    return tarfile.open(os.path.join(workdir, out))


def build(rt, workdir):
    tar = fetch(rt["package"], workdir)
    buf = io.BytesIO()
    with zipfile.ZipFile(buf, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for name, member in rt["files"].items():
            data = tar.extractfile(member).read()
            if name.endswith(".js"):
                data = SOURCE_MAP.sub(b"\n", data)   # the .map files are not shipped
            z.writestr(name, data)
    return buf.getvalue()


def main():
    html = open(INDEX, encoding="utf-8").read()
    with tempfile.TemporaryDirectory() as workdir:
        for rt in RUNTIMES:
            data = build(rt, workdir)
            block = (f'<script type="application/octet-stream" id="{rt["id"]}" '
                     f'data-version="{rt["version"]}">{base64.b64encode(data).decode()}</script>')
            pattern = re.compile(r'<script type="application/octet-stream" id="' + rt["id"] + r'"[^>]*>[^<]*</script>')
            if pattern.search(html):
                html = pattern.sub(lambda _: block, html, count=1)
            else:
                marker = "<!-- qv-runtimes -->"
                if marker not in html:
                    sys.exit(f"index.html has no {marker} marker to insert {rt['id']} at")
                html = html.replace(marker, marker + "\n" + block, 1)
            print(f"{rt['id']}: {rt['package']} -> {len(data) / 1048576:.2f} MB zipped")
    open(INDEX, "w", encoding="utf-8").write(html)


if __name__ == "__main__":
    main()
