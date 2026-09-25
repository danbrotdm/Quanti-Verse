#!/usr/bin/env python3
"""Writes docs/CATALOG.md and library/README.md.

docs/CATALOG.md gives every entry of the Ultimate Catalog of Web Game Ports (snapshot in
ports/catalog-snapshot.json) a status, and for each game that is not in library/ what it would
take to run it in Quantiverse. library/README.md lists the bundles that are.

    python3 ports/catalog.py
"""
import json, os

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
CATALOG = json.load(open(os.path.join(HERE, "catalog-snapshot.json")))
GAMES = {g["id"]: g for g in json.load(open(os.path.join(HERE, "games.json")))}
RESULTS = json.load(open(os.path.join(HERE, "results.json")))

# Catalog entry number -> ports/games.json ids built from it.
PORTED = {
    7: ["abuse"], 9: ["anarch"], 11: ["angband"], 23: ["astromenace"], 25: ["atomiks"], 26: ["azimuth"],
    46: ["blobbyvolley2"], 51: ["bombermaaan"], 54: ["breakhack"], 55: ["brogue"], 62: ["cdogs"],
    64: ["candycrisis"], 78: ["chromiumbsu"], 88: ["cromagrally"], 93: ["cuyo"],
    110: ["freedoom1", "freedoom2"], 112: ["freedoom1", "freedoom2"], 127: ["dungeonrush"],
    130: ["emptyclip"], 170: ["freegemas"], 171: ["freegish"], 173: ["freesiege"], 199: ["haxima"],
    203: ["hannah"], 229: ["jumpnbump"], 245: ["lbreakouthd"], 248: ["liri"], 279: ["neverball"], 281: ["nikwi"],
    286: ["numptyphysics"], 295: ["openttd"], 315: ["powermanga"], 351: ["sopwith"], 352: ["sdlball"],
    357: ["simutrans"], 393: ["starfighter"], 444: ["vectoroids"], 445: ["violetland"], 449: ["watercloset"],
    465: ["xgalaga"],
}
PORTED_NOTES = {
    110: "id's Doom needs its own IWAD (the shareware doom1.wad may be shared); the library has the engine with the free Freedoom data.",
    112: "Engine only. The library has it with the free Freedoom data.",
}

# Free and open games (code and data) that can be built the same way but are not in the library yet.
CANDIDATE = {
    34: "GPL-3.0. SDL 1.2 + SDL_ttf, small. Its sources (baller.tuxfamily.org, SourceForge) could not be reached from the build environment.",
    47: "GPL-2.0, data included. SDL 1.2 + SDL_image/SDL_mixer + OpenGL (gl4es). The catalog's repository (midzer/bloboats) no longer exists; needs another copy of the source.",
    165: "Flare engine GPL-3.0 plus the flare-game data (CC-BY-SA), which is about 640 MB (385 MB of images): far over GitHub's 100 MB file limit. Needs the images downscaled (the half-scale minicore mod still leaves 234 MB) or the bundle hosted outside git (Git LFS or a release asset).",
    296: "GPL-2.0 engine with the Tyrian 2.1 data its authors released as freeware (camanis.net/tyrian/tyrian21.zip, which the build environment could not reach). SDL2, small.",
    343: "GPL-2.0 code; art and sound CC-BY-SA 4.0; the music/old folder has other terms and must be left out. SDL 1.2 only: it uses TTF_OpenFontRW, TTF_SetFontOutline and SDL_SoftStretch, which Emscripten's built-in SDL 1.2 lacks. Needs sdl12-compat with SDL 1.2 builds of SDL_ttf, SDL_image, SDL_mixer and SDL_gfx on top of Emscripten's SDL2 (the game compiles; ports/deps/sdl_gfx.sh builds SDL_gfx). Each of its two games is about 50 MB.",
    406: "GPL-3.0, data included, with upstream Emscripten support (SDL3). The data is about 330 MB (144 MB music, 126 MB images): over GitHub's 100 MB file limit unless the music is re-encoded and the bundle hosted outside git.",
    423: "BSD-2-Clause, data included. Written in D: needs LDC's WebAssembly target plus a D runtime and SDL/OpenGL bindings for the web, which the ports pipeline does not have.",
}

# Free engines or source ports that need the original commercial game files.
NEEDS_DATA = {
    3: ("3D Pinball Space Cadet", "PINBALL.DAT and sound files from Windows XP"), 385: ("3D Pinball Space Cadet", "PINBALL.DAT and sound files from Windows XP"),
    63: ("Caesar III", "the original game directory"), 69: ("Cave Story", "the freeware Cave Story data (redistribution not licensed)"),
    80: ("Captain Claw", "CLAW.REZ"), 82: ("Command & Conquer", "the C&C (Tiberian Dawn) MIX files; EA released them as freeware but not for redistribution"),
    83: ("Commander Keen", "the episode files; the shareware episode 1 may be redistributed as shareware"),
    84: ("Half-Life", "the valve/ directory"), 85: ("Half-Life", "the valve/ directory"), 86: ("Half-Life", "the valve/ directory"),
    101: ("Der Clou!", "the original data files"), 103: ("Descent", "descent.hog/pig; the shareware version may be redistributed"),
    104: ("Diablo", "DIABDAT.MPQ, or the shareware spawn.mpq"),
    121: ("Duke Nukem 3D", "DUKE3D.GRP; the shareware version may be redistributed"),
    123: ("Duke Nukem II", "the game files; the shareware episode may be redistributed"), 125: ("Dune II", "the original data files"),
    133: ("Fade To Black", "the original data files"), 134: ("Fallout", "master.dat and critter.dat"), 135: ("Fallout 2", "master.dat and critter.dat"),
    166: ("Flashback", "the DOS or Amiga data files"), 172: ("The Settlers", "SPAE.PA or SPAD.PA"),
    194: ("GTA: Vice City", "the PC game files (the decompilation itself is legally contested)"),
    201: ("Heart of Darkness", "the PC data files"), 205: ("Heroes of Might and Magic III", "the game's Data, Maps and Mp3 directories"),
    206: ("Heroes of Might and Magic II", "the game files (the demo's data works)"), 211: ("Homeworld", "the game's big files; the released source is licensed for non-commercial use"),
    221: ("Jagged Alliance 2", "the game's Data directory"), 222: ("Jazz Jackrabbit", "the game files; the shareware episode may be redistributed"),
    223: ("Jazz Jackrabbit 2", "the game files; the shareware demo works"), 253: ("Master of Orion", "the original data files"),
    294: ("Cannon Fodder", "the game data (free Amiga Format demo data works)"), 317: ("Prince of Persia", "the original data (bundled in the SDLPoP repository, but still copyrighted)"),
    325: ("Quake", "pak0.pak (the shareware one may be redistributed) and pak1.pak"), 326: ("Quake II", "the baseq2 pak files; demo data works"),
    327: ("Quake III Arena", "baseq3 pak files; the demo's pak works"), 334: ("Raptor", "the game's GLB files; the shareware version may be redistributed"),
    342: ("Rise of the Triad", "the game's WAD files; the shareware version may be redistributed"),
    354: ("Shadow Warrior", "SW.GRP; the shareware version may be redistributed"), 373: ("Sonic CD", "Data.rsdk from the 2011 remaster"),
    375: ("Sonic Mania", "Data.rsdk"), 378: ("Sonic the Hedgehog (2013)", "Data.rsdk from the mobile remaster"), 379: ("Sonic the Hedgehog 2 (2013)", "Data.rsdk from the mobile remaster"),
    383: ("Sonic 3 & Knuckles", "the Sonic 3 & Knuckles ROM"), 369: ("Super Mario 64", "a Super Mario 64 ROM"), 402: ("Super Mario 64", "a Super Mario 64 ROM"),
    309: ("Plants vs. Zombies", "main.pak and the game's properties folder"), 391: ("Jedi Knight: Dark Forces II", "the game's GOB files"),
    398: ("Supaplex", "the Supaplex data files (released as freeware, redistribution terms unclear)"), 408: ("Syndicate", "the original data files"),
    416: ("Zelda: A Link to the Past", "the US SNES ROM"), 422: ("Tomb Raider", "the level files (the demo levels work)"),
    438: ("Unreal Gold", "the game's System, Maps, Textures, Sounds and Music directories"),
    447: ("VVVVVV", "data.zip (source is under a non-commercial licence; the free Make and Play edition's data works)"),
    277: ("Blood", "BLOOD.RFF, SOUNDS.RFF and the other game files; the shareware version may be redistributed"),
    340: ("Flashback", "the DOS or Amiga data files"), 466: ("Rick Dangerous", "the game data (xrick's own build embeds it, which is not licensed)"),
    456: ("Wipeout", "the PSX data files"), 459: ("Wolfenstein 3D", "the game files; the shareware episode may be redistributed"),
    463: ("Half-Life", "the valve/ directory"), 464: ("UFO: Enemy Unknown / X-COM", "the original game files"),
    70: ("Celeste", "your own copy of the game, which the project loads in the browser"), 412: ("Terraria", "your own copy of the game, which the project loads in the browser"),
    392: ("Stardew Valley", "your own copy of the game, which the project loads in the browser"), 292: ("OneShot: World Machine Edition", "your own copy of the game, which the project loads in the browser"),
}

# Free code, but a game built on someone else's characters or trademarks.
FAN_IP = {
    254: "Mario (Nintendo)", 298: "Pac-Man (Bandai Namco)", 404: "Mario (Nintendo)", 267: "Metal Slug (SNK)",
    376: "Sonic (Sega)", 377: "Sonic (Sega)", 389: "Sonic and Mario Kart (Sega, Nintendo)", 374: "Sonic (Sega)",
    403: "Super Mario Bros. (Nintendo)", 380: "Sonic (Sega)", 381: "Sonic (Sega)", 382: "Sonic (Sega)",
}

# Source is available, but the repository does not say (clearly) under which terms the game may be shared.
UNCLEAR = {
    20: "Apotris: source published on Gitea without a clear licence for its assets (Tetris is also a protected trademark).",
    24: "Asylum: SDL port of the 1994 Archimedes game; the data's redistribution terms are not stated.",
    45: "Biolab Disaster: engine code is MIT, the game's graphics and sound are not openly licensed.",
    97: "Defblade: no licence for the game data in the repository.",
    184: "Gilbert and the Doors: no licence in the repository.",
    214: "Hurrican: code is open, the data's licence is not stated clearly.",
    251: "Magic Sushi: no licence for the data in the repository.",
    262: "Minecraft 4k (m4kc): check the repository's licence; the original Minecraft 4k is Mojang's.",
    293: "Open Golf: check the repository's licence for the assets.",
    320: "Prototype: freeware game; the repository does not grant redistribution.",
    344: "Rocks'n'Diamonds: the code is GPL, the classic graphics and levels have their own terms.",
    356: "Shiromino: code is open, some assets have unclear terms.",
    370: "Sokoban: no licence in the repository.",
    428: "Tower To Heaven: no licence for the game in the repository.",
}

# Links that are not a single game.
NOT_A_GAME = {
    49: "a GitHub account", 53: "a GitHub account", 60: "a website", 114: "a website with a DOS game collection",
    179: "a GitHub account", 185: "a GitHub account", 227: "the js-dos project (Quantiverse already embeds js-dos)",
    244: "a collection of Flash games (proprietary; Flash itself works through Ruffle)", 321: "a collection of proxied ports",
    322: "a launcher", 324: "a launcher", 448: "a website", 450: "a collection website", 452: "a website", 336: "a GitHub account",
}

PROPRIETARY_REQ = ("Only the game's publisher can license it for sharing, so it is not in the library. If you own the game "
                   "and have a web build of it, convert it with QuantiVerter: its engine is covered in [ENGINES.md](ENGINES.md).")


def link(e):
    r = e.get("repo") or e.get("demo")
    return f"[source]({r})" if e.get("repo") else (f"[site]({r})" if r else "—")


def status_of(e):
    n = e["n"]
    if n in PORTED:
        return "ported"
    if n in CANDIDATE:
        return "candidate"
    if n in NEEDS_DATA:
        return "needs-data"
    if n in FAN_IP:
        return "fan-ip"
    if n in UNCLEAR:
        return "unclear"
    if n in NOT_A_GAME:
        return "not-a-game"
    if not e.get("repo") and not e.get("demo"):
        return "no-link"
    return "proprietary"


def md_escape(s):
    return s.replace("|", "\\|")


def main():
    groups = {}
    for e in CATALOG:
        groups.setdefault(status_of(e), []).append(e)
    order = [
        ("ported", "In the library", "Built from source and verified (boots offline in QuantiLoader, draws, no errors). Download from [library/](../library/)."),
        ("candidate", "Free games not ported yet", "Open code and data, so these can join the library. The note says what the build needs."),
        ("needs-data", "Needs the original game data", "The engine is free, the game is not. Build the engine, then add your own copy of the files listed (via QuantiVerter's file picker, or put them in the zip before converting). Shareware or demo data, where noted, may be shared."),
        ("fan-ip", "Free code, protected characters", "The code is open, but the game uses characters or trademarks the authors do not own, so it is not redistributed here. It builds like any other Emscripten game if you want it for yourself."),
        ("unclear", "Licence unclear", "Source is available, but the repository does not clearly allow sharing the game. It can join the library once the authors state a licence."),
        ("proprietary", "Proprietary games", PROPRIETARY_REQ),
        ("not-a-game", "Not a game", "Accounts, websites and collections listed in the catalog."),
        ("no-link", "No link in the catalog", "The catalog lists the name without a source or a site."),
    ]
    out = ["# Catalog status", "",
           "Every entry of the [Ultimate Catalog of Web Game Ports](https://github.com/Carter54git/Ultimate-Catalog-Of-Web-Game-Ports) "
           f"({len(CATALOG)} entries, snapshot in [ports/catalog-snapshot.json](../ports/catalog-snapshot.json)) and whether it can run in Quantiverse.",
           "",
           "Most of the catalog is unofficial web ports of commercial games. Their engines work in QuantiLoader "
           "(see [ENGINES.md](ENGINES.md)), but the games themselves cannot be redistributed, so only games whose code "
           "and data are free are built into [library/](../library/). How the library is built: [ports/README.md](../ports/README.md).",
           "", "| Status | Entries |", "| --- | --- |"]
    for key, title, _ in order:
        out.append(f"| [{title}](#{title.lower().replace(' ', '-').replace(',', '').replace('.', '')}) | {len(groups.get(key, []))} |")
    for key, title, intro in order:
        rows = groups.get(key, [])
        out += ["", f"## {title}", "", intro, ""]
        if key == "ported":
            out += ["| # | Catalog entry | Library bundle | Licence |", "| --- | --- | --- | --- |"]
            for e in rows:
                ids = PORTED[e["n"]]
                bundles = ", ".join(f"[{GAMES[i]['title']}](../{RESULTS[i]['bundle']})" for i in ids)
                lic = "; ".join(sorted({GAMES[i]["license"] for i in ids}))
                note = f" {PORTED_NOTES[e['n']]}" if e["n"] in PORTED_NOTES else ""
                out.append(f"| {e['n']} | {md_escape(e['game'])} ({link(e)}) | {bundles}{note} | {lic} |")
        elif key in ("candidate", "unclear"):
            notes = CANDIDATE if key == "candidate" else UNCLEAR
            out += ["| # | Game | What it needs |" if key == "candidate" else "| # | Game | Why |", "| --- | --- | --- |"]
            for e in rows:
                out.append(f"| {e['n']} | {md_escape(e['game'])} ({link(e)}) | {notes[e['n']]} |")
        elif key == "needs-data":
            out += ["| # | Catalog entry | Game data needed |", "| --- | --- | --- |"]
            for e in rows:
                game, files = NEEDS_DATA[e["n"]]
                out.append(f"| {e['n']} | {md_escape(e['game'])} ({link(e)}) | {game}: {files} |")
        elif key == "fan-ip":
            out += ["| # | Game | Characters / trademarks |", "| --- | --- | --- |"]
            for e in rows:
                out.append(f"| {e['n']} | {md_escape(e['game'])} ({link(e)}) | {FAN_IP[e['n']]} |")
        elif key == "not-a-game":
            out += ["| # | Entry | What it is |", "| --- | --- | --- |"]
            for e in rows:
                out.append(f"| {e['n']} | {md_escape(e['game'])} ({link(e)}) | {NOT_A_GAME[e['n']]} |")
        else:
            out += ["| # | Game | Link |", "| --- | --- | --- |"]
            for e in rows:
                out.append(f"| {e['n']} | {md_escape(e['game'])} | {link(e)} |")
    open(os.path.join(ROOT, "docs", "CATALOG.md"), "w").write("\n".join(out) + "\n")

    lib = ["# Library", "",
           "Ready-to-boot bundles of free games from the [Ultimate Catalog of Web Game Ports](https://github.com/Carter54git/Ultimate-Catalog-Of-Web-Game-Ports), "
           "built from source by [ports/build.py](../ports/build.py). Open one in QuantiLoader, or import them all into QuantiSorter. "
           "Every bundle runs offline and carries its licence and source link in its `manifest.json`.",
           "", "| Game | Developer | Year | Genre | Size | Licence | Source |", "| --- | --- | --- | --- | --- | --- | --- |"]
    for gid, g in sorted(GAMES.items(), key=lambda kv: kv[1]["title"].lower()):
        r = RESULTS.get(gid, {})
        if r.get("status") != "ok":
            continue
        name = os.path.basename(r["bundle"])
        lib.append(f"| [{g['title']}]({name}) | {g.get('developer', '')} | {g.get('year', '')} | {g.get('genre', '')} | "
                   f"{r['sizeMB']} MB | {g['license']} | [repository]({g['repo']}) |")
    lib += ["", "Status of the rest of the catalog, and what each game would need: [docs/CATALOG.md](../docs/CATALOG.md)."]
    open(os.path.join(ROOT, "library", "README.md"), "w").write("\n".join(lib) + "\n")
    print({k: len(v) for k, v in groups.items()})


if __name__ == "__main__":
    main()
