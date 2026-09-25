#!/usr/bin/env python3
"""Get Emscripten "ports" (SDL2, SDL_mixer, ...) without GitHub archive downloads.

Emscripten downloads most ports as https://github.com/<owner>/<repo>/archive/<ref>.zip. Where
that host is unreachable but git works, this clones <owner>/<repo> at <ref>, lays it out the way
the archive unpacks (<repo>-<ref>/), and writes Emscripten's .emscripten_url marker, so emcc
treats the port as already downloaded.

  portfetch.py --all      prefetch every GitHub-hosted port this Emscripten knows
  portfetch.py NAME URL   fetch one (used by the emcc wrapper when a download fails)
"""
import os, re, shutil, subprocess, sys

EMSCRIPTEN = os.path.join(os.environ["EMSDK"], "upstream", "emscripten")
CACHE = os.path.join(EMSCRIPTEN, "cache", "ports")
GH = re.compile(r"https://github\.com/([^/]+)/([^/]+)/archive/(?:refs/(?:tags|heads)/)?(.+?)\.(?:zip|tar\.gz)$")


def fetch(name, url):
    m = GH.match(url)
    if not m:
        return False
    owner, repo, ref = m.groups()
    dest = os.path.join(CACHE, name)
    marker = os.path.join(dest, ".emscripten_url")
    if os.path.exists(marker) and open(marker).read().strip() == url:
        return True
    shutil.rmtree(dest, ignore_errors=True)
    os.makedirs(dest)
    sub = os.path.join(dest, repo + "-" + (ref[1:] if re.match(r"v\d", ref) else ref))
    src = f"https://github.com/{owner}/{repo}"
    sys.stderr.write(f"portfetch: {name} <- {owner}/{repo} @ {ref}\n")
    if subprocess.run(["git", "clone", "-q", "--depth", "1", "-b", ref, src, sub], capture_output=True).returncode:
        subprocess.run(["git", "init", "-q", sub], check=True)   # a commit hash, not a tag or branch
        subprocess.run(["git", "-C", sub, "fetch", "-q", "--depth", "1", src, ref], check=True)
        subprocess.run(["git", "-C", sub, "checkout", "-q", "FETCH_HEAD"], check=True)
    shutil.rmtree(os.path.join(sub, ".git"), ignore_errors=True)
    open(marker, "w").write(url + "\n")
    return True


def all_ports():
    sys.path.insert(0, EMSCRIPTEN)
    from tools import ports
    for name, mod in sorted(ports.ports_by_name.items()):
        src = open(mod.__file__).read()
        for m in re.finditer(r"fetch_project\(\s*['\"]([^'\"]+)['\"]\s*,\s*(f?)(['\"])(.+?)\3", src):
            pname, is_f, url = m.group(1), m.group(2), m.group(4)
            try:
                url = eval("f" + repr(url), dict(vars(mod))) if is_f else url
            except Exception:
                continue
            if "{" not in url:
                try:
                    fetch(pname, url)
                except Exception as e:
                    sys.stderr.write(f"portfetch: {pname} failed: {e}\n")


if __name__ == "__main__":
    if sys.argv[1:] == ["--all"]:
        all_ports()
    else:
        sys.exit(0 if fetch(sys.argv[1], sys.argv[2]) else 1)
