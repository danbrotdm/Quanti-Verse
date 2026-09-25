#!/usr/bin/env python3
"""emcc / em++ stand-in: runs the real tool, and if a port download fails, fetches the port
with portfetch.py (git) and retries. Symlink it as emcc and em++ early on PATH."""
import os, re, subprocess, sys
here = os.path.dirname(os.path.realpath(__file__))
tool = os.path.join(os.environ["EMSDK"], "upstream", "emscripten", os.path.basename(sys.argv[0]))
for _ in range(10):
    p = subprocess.run([tool] + sys.argv[1:], stderr=subprocess.PIPE, text=True)
    m = re.search(r'failed to download port "([^"]+)" from (\S+?):', p.stderr)
    if p.returncode == 0 or not m or subprocess.run([sys.executable, os.path.join(here, "portfetch.py"), m.group(1), m.group(2)]).returncode:
        sys.stderr.write(p.stderr)
        sys.exit(p.returncode)
sys.exit(1)
