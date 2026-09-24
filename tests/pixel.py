"""Print the [r, g, b] of pixel (x, y) in a PNG: python3 pixel.py shot.png x y"""
import json, struct, sys, zlib

d = open(sys.argv[1], "rb").read()
X, Y = int(sys.argv[2]), int(sys.argv[3])
i, idat = 8, b""
while i < len(d):
    n = struct.unpack(">I", d[i:i + 4])[0]
    t, c = d[i + 4:i + 8], d[i + 8:i + 8 + n]
    i += 12 + n
    if t == b"IHDR":
        w, h = struct.unpack(">II", c[:8])
        bpp = {2: 3, 6: 4}[c[9]]
    elif t == b"IDAT":
        idat += c
raw = zlib.decompress(idat)
stride, prev, p = w * bpp, bytearray(w * bpp), 0
for y in range(Y + 1):
    f, line = raw[p], bytearray(raw[p + 1:p + 1 + stride])
    p += 1 + stride
    for x in range(stride):
        a = line[x - bpp] if x >= bpp else 0
        b = prev[x]
        c = prev[x - bpp] if x >= bpp else 0
        if f == 1: line[x] = (line[x] + a) & 255
        elif f == 2: line[x] = (line[x] + b) & 255
        elif f == 3: line[x] = (line[x] + (a + b) // 2) & 255
        elif f == 4:
            pa, pb, pc = abs(b - c), abs(a - c), abs(a + b - 2 * c)
            line[x] = (line[x] + (a if pa <= pb and pa <= pc else b if pb <= pc else c)) & 255
    prev = line
print(json.dumps(list(prev[X * bpp:X * bpp + 3])))
