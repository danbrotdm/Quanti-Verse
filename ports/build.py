#!/usr/bin/env python3
"""Builds catalog games from source into QuantiLoader bundles in library/.

    source <emsdk>/emsdk_env.sh
    python3 ports/build.py vectoroids atomiks ...     (or --all)

For each game in ports/games.json:
  1. clone its repository at the listed ref,
  2. run ports/recipes/<id>.sh in it (emcc/em++ on PATH fetch Emscripten ports through git,
     see emtools/), which writes the web build to $OUT using the Quantiverse port shell,
  3. convert that build with QuantiVerter itself (headless) and boot it in QuantiLoader with
     the network blocked (tests/port_check.cjs),
  4. add the game's metadata (title, developer, year, genre, licences, source) to the bundle's
     manifest.json, which QuantiSorter shows,
  5. write library/<Title>.bootable.zip and record the result in ports/results.json.
"""
import json, os, re, shutil, subprocess, sys, zipfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
WORK = os.path.join(HERE, ".work")
LIBRARY = os.path.join(ROOT, "library")
GAMES = json.load(open(os.path.join(HERE, "games.json")))
RESULTS_PATH = os.path.join(HERE, "results.json")


def run(cmd, **kw):
    print("  $", cmd if isinstance(cmd, str) else " ".join(cmd), flush=True)
    return subprocess.run(cmd, **kw)


def folder_name(title):
    return re.sub(r"[^A-Za-z0-9._-]+", "_", title).strip("_") or "game"


def clone(g):
    src = os.path.join(WORK, "src", g["id"])
    if not os.path.isdir(os.path.join(src, ".git")):
        shutil.rmtree(src, ignore_errors=True)
        args = ["git", "clone", "-q", "--depth", "1"]   # recipes init the submodules they need
        if g.get("ref"):
            args += ["-b", g["ref"]]
        if run(args + [g["repo"], src]).returncode:
            raise RuntimeError("clone failed")
    else:
        # Start every build from a pristine checkout: objects left by an earlier attempt (built
        # with other flags) would otherwise be linked in.
        run(["git", "-C", src, "clean", "-fdxq"])
        run(["git", "-C", src, "checkout", "-q", "--", "."])
    return src


def build(g, src):
    out = os.path.join(WORK, "out", g["id"])
    shutil.rmtree(out, ignore_errors=True)
    os.makedirs(out)
    shell = os.path.join(WORK, f"shell-{g['id']}.html")
    html = open(os.path.join(HERE, "shell.html"), encoding="utf-8").read()
    open(shell, "w", encoding="utf-8").write(html.replace("{{{ QV_TITLE }}}", g["title"]))
    env = dict(os.environ)
    env["PATH"] = os.path.join(HERE, "emtools") + os.pathsep + env["PATH"]
    env["OUT"] = out
    env["QV_LINK"] = f"--shell-file {shell} -sENVIRONMENT=web -sALLOW_MEMORY_GROWTH=1"
    env["JOBS"] = str(os.cpu_count() or 2)
    # Older ports guard their web code with #ifdef EMSCRIPTEN, a macro current Emscripten no longer
    # defines (only __EMSCRIPTEN__); without it they busy-wait instead of yielding to the browser.
    env["EMCC_CFLAGS"] = (env.get("EMCC_CFLAGS", "") + " -DEMSCRIPTEN=1").strip()
    env["QV_PERSIST_JS"] = os.path.join(HERE, "persist.js")   # see persist.js: keeps save folders in IndexedDB
    env["PORTS"] = HERE                       # recipes call $PORTS/deps/<dep>.sh for shared libraries
    env["DEPS"] = os.path.join(WORK, "deps")
    # CMake find-modules do not know Emscripten's SDL ports: point them at the sysroot.
    sysroot = os.path.join(os.environ["EMSDK"], "upstream", "emscripten", "cache", "sysroot")
    lib = os.path.join(sysroot, "lib", "wasm32-emscripten")
    inc = os.path.join(sysroot, "include")
    hints = {"SDL2_INCLUDE_DIR": inc + "/SDL2", "SDL2_INCLUDE_DIRS": inc + "/SDL2", "SDL2_LIBRARY": lib + "/libSDL2.a",
             "SDL2_LIBRARIES": lib + "/libSDL2.a", "SDL2MAIN_LIBRARY": lib + "/libSDL2.a", "SDL2_FOUND": "ON",
             "SDL2_IMAGE_INCLUDE_DIR": inc + "/SDL2", "SDL2_IMAGE_LIBRARY": lib + "/libSDL2.a", "SDL2_IMAGE_LIBRARIES": lib + "/libSDL2.a",
             "SDL2_MIXER_INCLUDE_DIR": inc + "/SDL2", "SDL2_MIXER_LIBRARY": lib + "/libSDL2.a", "SDL2_MIXER_LIBRARIES": lib + "/libSDL2.a",
             "SDL2_TTF_INCLUDE_DIR": inc + "/SDL2", "SDL2_TTF_LIBRARY": lib + "/libSDL2.a", "SDL2_TTF_LIBRARIES": lib + "/libSDL2.a",
             "CMAKE_THREAD_LIBS_INIT": "-lpthread", "CMAKE_HAVE_THREADS_LIBRARY": "1", "CMAKE_USE_PTHREADS_INIT": "1",
             "Threads_FOUND": "TRUE", "THREADS_PREFER_PTHREAD_FLAG": "ON", "CMAKE_BUILD_TYPE": "Release"}
    env["QV_CMAKE"] = " ".join(f"-D{k}={v}" for k, v in hints.items())
    env["SYSROOT"] = sysroot
    # pkg-config files for Emscripten's SDL add-on ports and the shared GL libraries, found by
    # emconfigure through EM_PKG_CONFIG_PATH (the sysroot only ships sdl2.pc and a few others).
    pc = os.path.join(WORK, "pkgconfig")
    os.makedirs(pc, exist_ok=True)
    deps = env["DEPS"]
    for name, cflags, libs in [
        ("SDL2_mixer", "-sUSE_SDL_MIXER=2", "-sUSE_SDL_MIXER=2"), ("SDL2_image", "-sUSE_SDL_IMAGE=2", "-sUSE_SDL_IMAGE=2"),
        ("SDL2_ttf", "-sUSE_SDL_TTF=2", "-sUSE_SDL_TTF=2"), ("SDL2_net", "-sUSE_SDL_NET=2", "-sUSE_SDL_NET=2"),
        ("SDL2_gfx", "-sUSE_SDL_GFX=2", "-sUSE_SDL_GFX=2"), ("libpng", "-sUSE_LIBPNG", "-sUSE_LIBPNG"),
        ("openal", "", "-lopenal"), ("gl", f"-I{deps}/gl4es/include", f"{deps}/gl4es/lib/libGL.a -sFULL_ES2"),
        ("glu", f"-I{deps}/glu/include", f"{deps}/glu/lib/libGLU.a -sDEFAULT_TO_CXX")]:   # GLU has C++ (NURBS) inside
        open(os.path.join(pc, name + ".pc"), "w").write(
            f"Name: {name}\nDescription: Emscripten\nVersion: 99\nRequires: sdl2\nCflags: {cflags}\nLibs: {libs}\n")
    env["EM_PKG_CONFIG_PATH"] = pc
    env["PKG_CONFIG_PATH"] = pc
    recipe = os.path.join(HERE, "recipes", g["id"] + ".sh")
    log = open(os.path.join(WORK, f"build-{g['id']}.log"), "w")
    r = run(["bash", "-e", "-o", "pipefail", recipe], cwd=src, env=env, stdout=log, stderr=subprocess.STDOUT)
    if r.returncode or not os.path.exists(os.path.join(out, "index.html")):
        tail = open(log.name, errors="replace").read()[-1500:]
        raise RuntimeError("build failed:\n" + tail)
    # Recipes tolerate a failing desktop link step, which can hide a compile that stopped
    # halfway. Without main() Emscripten still emits a page that simply never starts.
    js = open(os.path.join(out, "index.js"), errors="replace").read()
    if not re.search(r"__main_argc_argv|_main\b|callMain", js):
        errs = [l for l in open(log.name, errors="replace").read().splitlines() if "error" in l.lower()][:8]
        raise RuntimeError("no main() linked, the compile did not finish:\n" + "\n".join(errs))
    # Zip the web build under a folder named after the game (QuantiVerter names the bundle after it).
    web = os.path.join(WORK, "web", folder_name(g["title"]) + ".zip")
    os.makedirs(os.path.dirname(web), exist_ok=True)
    with zipfile.ZipFile(web, "w", zipfile.ZIP_DEFLATED) as z:
        for base, _, files in os.walk(out):
            for f in files:
                p = os.path.join(base, f)
                z.write(p, folder_name(g["title"]) + "/" + os.path.relpath(p, out))
    return web


def convert_and_check(g, web):
    label = folder_name(g["title"])
    r = run(["node", os.path.join(ROOT, "tests", "port_check.cjs"), web, label, str(g.get("check_seconds", 12))],
            capture_output=True, text=True, cwd=os.path.join(ROOT, "tests"))
    line = (r.stdout.strip().splitlines() or ["{}"])[-1]
    info = json.loads(line)
    bundle = os.path.join(ROOT, "tests", ".work", "out", label + ".bootable.zip")
    return info, bundle


def add_metadata(g, bundle, dest):
    meta = {k: g[k] for k in ("title", "developer", "year", "genre", "description", "tags") if g.get(k)}
    meta["license"] = g["license"]
    meta["source"] = g["repo"]
    meta["catalog"] = "Ultimate Catalog of Web Game Ports"
    with zipfile.ZipFile(bundle) as zin, zipfile.ZipFile(dest, "w") as zout:
        for info in zin.infolist():
            data = zin.read(info)
            if info.filename.endswith("manifest.json") and info.filename.count("/") == 1:
                m = json.loads(data)
                m.update(meta)
                data = json.dumps(m, indent=2).encode()
            zout.writestr(info, data)


def main(ids):
    results = json.load(open(RESULTS_PATH)) if os.path.exists(RESULTS_PATH) else {}
    os.makedirs(LIBRARY, exist_ok=True)
    by_id = {g["id"]: g for g in GAMES}
    for gid in ids:
        g = by_id[gid]
        print(f"== {g['title']}", flush=True)
        try:
            src = clone(g)
            web = build(g, src)
            info, bundle = convert_and_check(g, web)
            ok = not info.get("crash") and not info.get("errors") and not info.get("leaked") and max(info.get("colorsOverTime") or [0]) >= 4   # CGA-era games use 4 colours
            dest = os.path.join(LIBRARY, folder_name(g["title"]) + ".bootable.zip")
            if ok:
                add_metadata(g, bundle, dest)
            results[gid] = {"status": "ok" if ok else "check-failed", "bundle": os.path.relpath(dest, ROOT) if ok else None,
                            "sizeMB": round(os.path.getsize(dest) / 1048576, 1) if ok else None, "check": info}
            print("  ->", results[gid]["status"], json.dumps(info)[:400], flush=True)
        except Exception as e:
            results[gid] = {"status": "build-failed", "error": str(e)[-1200:]}
            print("  -> build-failed", str(e)[-600:], flush=True)
        json.dump(results, open(RESULTS_PATH, "w"), indent=1, sort_keys=True)


if __name__ == "__main__":
    args = sys.argv[1:]
    main([g["id"] for g in GAMES] if args == ["--all"] else args)
