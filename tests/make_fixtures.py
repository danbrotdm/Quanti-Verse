import struct, zipfile, os
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), ".work", "fixtures"); os.makedirs(OUT, exist_ok=True)

class Bits:
    def __init__(s): s.bits = []
    def u(s, v, n): s.bits += [(v >> (n - 1 - i)) & 1 for i in range(n)]
    def sb(s, v, n): s.u(v & ((1 << n) - 1), n)
    def bytes(s):
        b = s.bits + [0] * (-len(s.bits) % 8)
        return bytes(int("".join(map(str, b[i:i+8])), 2) for i in range(0, len(b), 8))

def rect(x0, x1, y0, y1, nb=16):
    b = Bits(); b.u(nb, 5)
    for v in (x0, x1, y0, y1): b.sb(v, nb)
    return b.bytes()

def tag(code, body):
    if len(body) < 63: return struct.pack("<H", (code << 6) | len(body)) + body
    return struct.pack("<HI", (code << 6) | 63, len(body)) + body

def shape(cid, rgb, x, y, w, h):
    # DefineShape: one solid fill, a rectangle outline drawn with straight edges.
    body = struct.pack("<H", cid) + rect(x, x + w, y, y + h)
    body += bytes([1, 0x00]) + bytes(rgb) + bytes([0])   # 1 fill style (solid), 0 line styles
    b = Bits(); b.u(1, 4); b.u(0, 4)                      # NumFillBits=1, NumLineBits=0
    b.u(0, 1); b.u(0b00011, 5); b.u(16, 5); b.sb(x, 16); b.sb(y, 16); b.u(1, 1)  # moveTo + fill0
    for dx, dy in ((w, 0), (0, h), (-w, 0), (0, -h)):
        b.u(1, 1); b.u(1, 1); b.u(14, 4)                  # edge, straight, NumBits=16
        if dx and dy: b.u(1, 1); b.sb(dx, 16); b.sb(dy, 16)
        else: b.u(0, 1); b.u(1 if dy else 0, 1); b.sb(dy or dx, 16)
    b.u(0, 1); b.u(0, 5)                                  # end of shape
    return tag(2, body + b.bytes())

def place(cid, depth):
    return tag(26, bytes([0x02]) + struct.pack("<HH", depth, cid))  # PlaceObject2 with character

def swf(tags, bg):
    body = rect(0, 400 * 20, 0, 300 * 20) + struct.pack("<HH", 24 << 8, 1)
    body += tag(69, struct.pack("<I", 0))                 # FileAttributes: AS1/2, no network flag
    body += tag(9, bytes(bg)) + b"".join(tags) + tag(1, b"") + tag(0, b"")
    return b"FWS" + bytes([8]) + struct.pack("<I", 8 + len(body)) + body

# Child: a green square at top-left. Parent: dark blue stage, magenta square at bottom-right,
# then AS1 loadMovieNum("child.swf", 1) which must be served from the bundle.
open(f"{OUT}/child.swf", "wb").write(swf([shape(1, (0, 255, 0), 20*20, 20*20, 120*20, 120*20), place(1, 1)], (0, 0, 80)))
url, target = b"child.swf\0", b"_level1\0"
doaction = tag(12, bytes([0x83]) + struct.pack("<H", len(url) + len(target)) + url + target + b"\0")
open(f"{OUT}/game.swf", "wb").write(swf([shape(1, (255, 0, 255), 260*20, 160*20, 120*20, 120*20), place(1, 1), doaction], (0, 0, 80)))
with zipfile.ZipFile(f"{OUT}/flashgame.zip", "w") as z:
    z.write(f"{OUT}/game.swf", "flashgame/game.swf"); z.write(f"{OUT}/child.swf", "flashgame/child.swf")

# DOS: mode 13h, fill the screen with palette index 4 (red, 170,0,0), then spin.
com = bytes.fromhex("B81300CD10" "B800A08EC0" "31FF" "B004" "B900FA" "F3AA" "EBFE")
os.makedirs(f"{OUT}/dosgame", exist_ok=True)
open(f"{OUT}/dosgame/RED.COM", "wb").write(com)
with zipfile.ZipFile(f"{OUT}/dosgame.zip", "w") as z: z.write(f"{OUT}/dosgame/RED.COM", "dosgame/RED.COM")
print("ok", os.listdir(OUT))

# Web: a page whose script fetches a data file at runtime and paints the page with it (#ff8800).
with zipfile.ZipFile(f"{OUT}/webgame.zip", "w") as z:
    z.writestr("webgame/index.html", "<!doctype html><html><head><title>Web</title><link rel=stylesheet href=s.css></head><body><div id=b></div><script src=js/app.js></script></body></html>")
    z.writestr("webgame/s.css", "html,body{margin:0;height:100%}#b{position:fixed;inset:0;background:#123456}")
    z.writestr("webgame/js/app.js", "fetch('data/color.txt').then(r=>r.text()).then(c=>{document.getElementById('b').style.background=c.trim()})")
    z.writestr("webgame/data/color.txt", "#ff8800")

# Unity-style build compressed for a web server's Content-Encoding (.br / .gz / .unityweb): the
# page expects the bytes already decoded, as a correctly configured server would deliver them.
import gzip, zlib
try:
    import brotli
    br = brotli.compress
except ImportError:
    br = None
if br:
    fw = b"window.FW_OK = 'framework-ok';"
    data = bytes(range(256)) * 64
    unity_js = r"""
(async () => {
  const txt = await (await fetch('Build/game.framework.js.br')).text();
  const data = new Uint8Array(await (await fetch('Build/game.data.gz')).arrayBuffer());
  const wasm = await (await fetch('Build/game.wasm.unityweb')).text();
  let ok = txt.includes('framework-ok') && data.length === 16384 && data[255] === 255 && wasm === 'wasm-ok';
  document.getElementById('b').style.background = ok ? '#00ff00' : '#ff0000';
  document.title = ok ? 'unity ok' : 'unity bad';
})();
"""
    with zipfile.ZipFile(f"{OUT}/unitylike.zip", "w") as z:
        z.writestr("unitylike/index.html", "<!doctype html><html><head><title>Unity-like</title></head><body style='margin:0'><div id=b style='position:fixed;inset:0;background:#000'></div><script src=loader.js></script></body></html>")
        z.writestr("unitylike/loader.js", unity_js)
        z.writestr("unitylike/Build/game.framework.js.br", br(fw))
        z.writestr("unitylike/Build/game.data.gz", gzip.compress(data))
        z.writestr("unitylike/Build/game.wasm.unityweb", br(b"wasm-ok"))

# ES modules loaded through a computed URL (import(new URL(name, import.meta.url))), like .NET's dotnet.js.
with zipfile.ZipFile(f"{OUT}/modules.zip", "w") as z:
    z.writestr("modules/index.html", "<!doctype html><html><head><title>Modules</title></head><body style='margin:0'><div id=b style='position:fixed;inset:0;background:#f00'></div><script type=module src=main.mjs></script></body></html>")
    z.writestr("modules/main.mjs", "const name = ['dyn', 'js'].join('.');\nconst m = await import(new URL('./lib/' + name, import.meta.url));\ndocument.getElementById('b').style.background = m.color;\ndocument.title = 'modules ' + m.color;\n")
    z.writestr("modules/lib/dyn.js", "import { green } from './util.js';\nexport const color = green;\n")
    z.writestr("modules/lib/util.js", "export const green = '#00ff00';\n")

# ---- save fixtures -------------------------------------------------------------------
# Web: counts launches in localStorage (setItem + a property-style write) and IndexedDB, and
# paints the launch count: #run = 1 red, 2 green, 3+ blue; #idb = green if its IDB record was
# already there at start (i.e. survived or was restored).
game_js = r"""
const n = Number(localStorage.getItem('sg_count') || 0) + 1;
localStorage.setItem('sg_count', String(n));
localStorage.sg_prop = 'launch-' + n;            // property-style write, bypasses setItem
const colors = ['#000', '#ff0000', '#00ff00', '#0000ff'];
document.getElementById('run').style.background = colors[Math.min(n, 3)];
const req = indexedDB.open('sgdb', 1);
req.onupgradeneeded = () => req.result.createObjectStore('s');
req.onsuccess = () => {
  const db = req.result, tx = db.transaction('s', 'readwrite'), os = tx.objectStore('s');
  const g = os.get('slot1');
  g.onsuccess = () => {
    document.getElementById('idb').style.background = g.result ? '#00ff00' : '#ff0000';
    os.put({ count: n, bytes: new Uint8Array([1, 2, 3, n]), when: new Date() }, 'slot1');
  };
  tx.oncomplete = () => { document.title = 'saved ' + n; };
};
"""
with zipfile.ZipFile(f"{OUT}/savegame.zip", "w") as z:
    z.writestr("savegame/index.html", "<!doctype html><html><head><title>Save Game</title></head><body style='margin:0'>"
               "<div id=run style='position:fixed;left:0;top:0;width:50%;height:100%'></div>"
               "<div id=idb style='position:fixed;right:0;top:0;width:50%;height:100%'></div><script src=game.js></script></body></html>")
    z.writestr("savegame/game.js", game_js)

# DOS: if SAVE.DAT exists paint green, else create it and paint red.
#   org 100h
#   mov ax,3D00h / mov dx,fname / int 21h / jnc found
#   mov ah,3Ch / xor cx,cx / mov dx,fname / int 21h / mov bx,ax
#   mov ah,40h / mov cx,4 / mov dx,fname / int 21h / mov ah,3Eh / int 21h / mov bl,4 / jmp paint
#   found: mov bl,2
#   paint: mov ax,13h / int 10h / mov ax,0A000h / mov es,ax / xor di,di / mov al,bl / mov cx,64000 / rep stosb / jmp $
code = bytearray()
def emit(h): code.extend(bytes.fromhex(h))
emit("B8003D"); emit("BA0000"); fixups = [len(code) - 2]; emit("CD21"); emit("7300"); jnc_at = len(code) - 1
emit("B43C"); emit("31C9"); emit("BA0000"); fixups.append(len(code) - 2); emit("CD21"); emit("89C3")
emit("B440"); emit("B90400"); emit("BA0000"); fixups.append(len(code) - 2); emit("CD21"); emit("B43E"); emit("CD21")
emit("B304"); emit("EB00"); jmp_at = len(code) - 1
found = len(code); emit("B302")
paint = len(code); emit("B81300CD10B800A08EC031FF88D8B900FAF3AAEBFE")
code[jnc_at] = found - (jnc_at + 1); code[jmp_at] = paint - (jmp_at + 1)
fname = 0x100 + len(code)
for f in fixups: code[f:f + 2] = struct.pack("<H", fname)
code += b"SAVE.DAT\0"
os.makedirs(f"{OUT}/dossave", exist_ok=True)
open(f"{OUT}/dossave/SAVER.COM", "wb").write(code)
with zipfile.ZipFile(f"{OUT}/dossave.zip", "w") as z: z.write(f"{OUT}/dossave/SAVER.COM", "dossave/SAVER.COM")

# Flash: AS1 that writes a SharedObject:  so = SharedObject.getLocal("qvtest"); so.data.v = 42; so.flush();
def push(*items):
    body = b""
    for it in items:
        if isinstance(it, str): body += b"\x00" + it.encode() + b"\x00"
        else: body += b"\x07" + struct.pack("<I", it)
    return b"\x96" + struct.pack("<H", len(body)) + body
acts = (push("so", "qvtest", 1, "SharedObject") + b"\x1c" + push("getLocal") + b"\x52" + b"\x3c"   # so = SharedObject.getLocal("qvtest")
        + push("so") + b"\x1c" + push("data") + b"\x4e" + push("v", 42) + b"\x4f"                   # so.data.v = 42
        + push(0, "so") + b"\x1c" + push("flush") + b"\x52" + b"\x17" + b"\x00")                     # so.flush()
open(f"{OUT}/so.swf", "wb").write(swf([shape(1, (255, 255, 0), 100*20, 100*20, 200*20, 100*20), place(1, 1), tag(12, acts)], (0, 0, 80)))
with zipfile.ZipFile(f"{OUT}/flashsave.zip", "w") as z: z.write(f"{OUT}/so.swf", "flashsave/game.swf")
print("save fixtures ok")
