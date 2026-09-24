import re, subprocess, sys, tempfile, os
s = open(os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "index.html"), encoding="utf-8").read()
bad = 0
for i, m in enumerate(re.finditer(r"<script(?![^>]*application/octet-stream)[^>]*>(.*?)</script>", s, re.S)):
    code = m.group(1)
    if not code.strip(): continue
    f = tempfile.NamedTemporaryFile("w", suffix=".js", delete=False); f.write(code); f.close()
    r = subprocess.run(["node", "--check", f.name], capture_output=True, text=True); os.unlink(f.name)
    if r.returncode: bad += 1; print(f"script #{i} line {s[:m.start()].count(chr(10))+1}:", r.stderr[:600])
print("syntax errors:", bad); sys.exit(bad)
