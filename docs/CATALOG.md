# Catalog status

Every entry of the [Ultimate Catalog of Web Game Ports](https://github.com/Carter54git/Ultimate-Catalog-Of-Web-Game-Ports) (474 entries, snapshot in [ports/catalog-snapshot.json](../ports/catalog-snapshot.json)) and whether it can run in Quantiverse.

Most of the catalog is unofficial web ports of commercial games. Their engines work in QuantiLoader (see [ENGINES.md](ENGINES.md)), but the games themselves cannot be redistributed, so only games whose code and data are free are built into [library/](../library/). How the library is built: [ports/README.md](../ports/README.md).

| Status | Entries |
| --- | --- |
| [In the library](#in-the-library) | 32 |
| [Free games not ported yet](#free-games-not-ported-yet) | 15 |
| [Needs the original game data](#needs-the-original-game-data) | 64 |
| [Free code, protected characters](#free-code-protected-characters) | 12 |
| [Licence unclear](#licence-unclear) | 14 |
| [Proprietary games](#proprietary-games) | 312 |
| [Not a game](#not-a-game) | 15 |
| [No link in the catalog](#no-link-in-the-catalog) | 10 |

## In the library

Built from source and verified (boots offline in QuantiLoader, draws, no errors). Download from [library/](../library/).

| # | Catalog entry | Library bundle | Licence |
| --- | --- | --- | --- |
| 9 | Anarch ([source](https://gitlab.com/drummyfish/anarch)) | [Anarch](../library/Anarch.bootable.zip) | CC0 1.0 (public domain, code and data) |
| 25 | Atomiks ([source](https://github.com/midzer/atomiks)) | [Atomiks](../library/Atomiks.bootable.zip) | GPL-3.0 (code and data) |
| 26 | Azimuth ([source](https://github.com/midzer/azimuth)) | [Azimuth](../library/Azimuth.bootable.zip) | GPL-3.0 (code and data) |
| 46 | Blobby Volley 2 ([source](https://github.com/danielknobe/blobbyvolley2)) | [Blobby Volley 2](../library/Blobby_Volley_2.bootable.zip) | GPL-2.0 |
| 51 | Bombermaaan ([source](https://github.com/midzer/Bombermaaan)) | [Bombermaaan](../library/Bombermaaan.bootable.zip) | GPL-3.0 |
| 55 | Brogue ([source](https://github.com/midzer/BrogueCE)) | [Brogue Community Edition](../library/Brogue_Community_Edition.bootable.zip) | AGPL-3.0 (code and data) |
| 62 | C-Dogs SDL ([source](https://github.com/midzer/cdogs-sdl)) | [C-Dogs SDL](../library/C-Dogs_SDL.bootable.zip) | GPL-2.0 / BSD-2-Clause (code); CC0, CC-BY, CC-BY-SA (data) |
| 64 | Candy Crisis ([source](https://github.com/midzer/CandyCrisis)) | [Candy Crisis](../library/Candy_Crisis.bootable.zip) | GPL-2.0 (code and data) |
| 88 | Cro-Mag Rally ([source](https://github.com/midzer/CroMagRally)) | [Cro-Mag Rally](../library/Cro-Mag_Rally.bootable.zip) | CC BY-NC-SA 4.0 (non-commercial) |
| 93 | Cuyo ([source](https://github.com/midzer/cuyo)) | [Cuyo](../library/Cuyo.bootable.zip) | GPL-2.0 (code and data) |
| 110 | Doom ([source](https://github.com/midzer/chocolate-doom)) | [Freedoom: Phase 1](../library/Freedoom_Phase_1.bootable.zip), [Freedoom: Phase 2](../library/Freedoom_Phase_2.bootable.zip) id's Doom needs its own IWAD (the shareware doom1.wad may be shared); the library has the engine with the free Freedoom data. | BSD-3-Clause (Freedoom data), GPL-2.0 (Chocolate Doom) |
| 112 | Doom Engine ([source](https://github.com/GMH-Code/Dwasm)) | [Freedoom: Phase 1](../library/Freedoom_Phase_1.bootable.zip), [Freedoom: Phase 2](../library/Freedoom_Phase_2.bootable.zip) Engine only. The library has it with the free Freedoom data. | BSD-3-Clause (Freedoom data), GPL-2.0 (Chocolate Doom) |
| 127 | Dungeon Rush ([source](https://github.com/midzer/DungeonRush)) | [Dungeon Rush](../library/Dungeon_Rush.bootable.zip) | GPL-3.0 (code), free art packs |
| 130 | Empty Clip ([source](https://github.com/midzer/empty-clip)) | [Empty Clip](../library/Empty_Clip.bootable.zip) | GPL-3.0 (code), CC-BY-SA (art and sound) |
| 170 | Freegemas ([source](https://github.com/midzer/freegemas)) | [Freegemas](../library/Freegemas.bootable.zip) | GPL-2.0 (code), GPL/CC art |
| 171 | Freegish ([source](https://github.com/midzer/freegish)) | [Freegish](../library/Freegish.bootable.zip) | GPL-2.0 (code); CC-BY-SA 3.0 (data, per directory notes) |
| 173 | FreeSiege ([source](https://github.com/midzer/freesiege)) | [FreeSiege](../library/FreeSiege.bootable.zip) | GPL-2.0 (code and data) |
| 199 | Haxima ([source](https://github.com/midzer/nazghul)) | [Haxima](../library/Haxima.bootable.zip) | GPL-2.0 (engine and game) |
| 203 | Help Hannah's Horse ([source](https://github.com/midzer/hannah)) | [Help Hannah's Horse](../library/Help_Hannah_s_Horse.bootable.zip) | GPL-2.0 (code and data) |
| 229 | Jump 'n Bump ([source](https://github.com/midzer/jumpnbump)) | [Jump 'n Bump](../library/Jump_n_Bump.bootable.zip) | GPL-2.0 (code and data) |
| 245 | LBreakoutHD ([source](https://github.com/midzer/lbreakouthd)) | [LBreakoutHD](../library/LBreakoutHD.bootable.zip) | GPL-3.0 (code and data) |
| 248 | Li-Ri ([source](https://github.com/midzer/Li-Ri)) | [Li-Ri](../library/Li-Ri.bootable.zip) | GPL-2.0 (code), free music |
| 281 | Nikwi ([source](https://github.com/midzer/nikwi)) | [Nikwi Deluxe](../library/Nikwi_Deluxe.bootable.zip) | zlib licence (code); WTFPL (data) |
| 286 | Numpty Physics ([source](https://github.com/midzer/numptyphysics)) | [Numpty Physics](../library/Numpty_Physics.bootable.zip) | GPL-3.0 (code and data) |
| 315 | Powermanga ([source](https://github.com/midzer/Powermanga)) | [Powermanga](../library/Powermanga.bootable.zip) | GPL-3.0 (code and data) |
| 351 | SDL Sopwith ([source](https://github.com/fragglet/sdl-sopwith)) | [SDL Sopwith](../library/SDL_Sopwith.bootable.zip) | GPL-2.0 (code and data) |
| 352 | SDL-Ball ([source](https://github.com/midzer/sdl-ball)) | [SDL-Ball](../library/SDL-Ball.bootable.zip) | GPL-3.0 (code and data) |
| 393 | Starfighter ([source](https://github.com/midzer/starfighter)) | [Project: Starfighter](../library/Project_Starfighter.bootable.zip) | GPL-3.0 (code), free art and music (see LICENSES) |
| 444 | Vectoroids ([source](https://github.com/midzer/vectoroids)) | [Vectoroids](../library/Vectoroids.bootable.zip) | GPL-2.0 (code and data) |
| 445 | Violetland ([source](https://github.com/midzer/violetland)) | [Violetland](../library/Violetland.bootable.zip) | GPL-3.0 (code), CC-BY-SA 3.0 (assets) |
| 449 | Water Closet ([source](https://github.com/midzer/waterCloset)) | [Water Closet](../library/Water_Closet.bootable.zip) | GPL-3.0 (code), see LICENSE for assets |
| 465 | XGalaga ([source](https://github.com/midzer/xgalaga-sdl)) | [XGalaga](../library/XGalaga.bootable.zip) | GPL-2.0 (code and data) |

## Free games not ported yet

Open code and data, so these can join the library. The note says what the build needs.

| # | Game | What it needs |
| --- | --- | --- |
| 7 | Abuse ([source](https://github.com/midzer/abuse)) | Code and most data are public domain; a few sound effects have unclear terms and would need to be left out. SDL2, CMake. |
| 11 | Angband ([source](https://github.com/angband/angband)) | GPL-2.0 / Angband licence, data included. SDL2 front end; turn-based, so a plain Emscripten build with ASYNCIFY. |
| 23 | AstroMenace ([source](https://github.com/midzer/astromenace)) | GPL-3.0 code, free data. SDL2 + OpenGL + OpenAL + Vorbis + FreeType; needs gl4es and about 150 MB of data (size limit of a single file on GitHub). |
| 34 | Ballerburg SDL ([site](https://baller.tuxfamily.org/)) | GPL-3.0. SDL 1.2 + SDL_ttf; small. |
| 47 | Bloboats ([source](https://github.com/midzer/bloboats)) | GPL-2.0, data included. SDL 1.2 + SDL_image/SDL_mixer + OpenGL (gl4es). |
| 54 | BreakHack ([source](https://github.com/midzer/breakhack)) | GPL-3.0 code, CC-BY-SA data. Build attempted: its SDL3-era submodules could not be fetched recursively. Needs its CMake build pointed at Emscripten's SDL2 ports. |
| 78 | Chromium B.S.U. ([source](https://github.com/midzer/chromium-bsu)) | Clarified Artistic licence. Build attempted: needs FTGL, freealut and glpng built for Emscripten (not yet in ports/deps). |
| 165 | Flare ([source](https://github.com/midzer/flare-engine)) | Flare engine GPL-3.0 plus the flare-game data (CC-BY-SA). SDL2 + SDL_image/mixer/ttf; data is fetched from a second repository. |
| 279 | Neverball ([source](https://github.com/Neverball/neverball)) | GPL-2.0, data included. SDL2 + OpenGL ES + PhysFS + libpng/jpeg/vorbis; PhysFS is in ports/deps now. |
| 295 | OpenTTD ([source](https://github.com/OpenTTD/OpenTTD)) | GPL-2.0 plus the free OpenGFX/OpenSFX/OpenMSX sets (GitHub releases). Has upstream Emscripten support; needs zlib, lzma, libpng, freetype and a large link. |
| 296 | OpenTyrian ([source](https://github.com/midzer/opentyrian)) | GPL-2.0 engine with the Tyrian 2.1 data its authors released as freeware (camanis.net/tyrian/tyrian21.zip, which the build environment could not reach). SDL2, small. |
| 343 | Rockbot ([source](https://github.com/midzer/rockbot)) | GPL code; check the art licence in the repository before publishing. SDL 1.2/2 + SDL_mixer. |
| 357 | Simutrans ([source](https://github.com/midzer/simutrans)) | Artistic licence 1.0 code with the free pak64 data. SDL2 + zlib + bzip2; has an Emscripten target upstream. |
| 406 | SuperTux ([source](https://github.com/SuperTux/supertux)) | GPL-3.0, data included. SDL2 + OpenGL + OpenAL + PhysFS + Boost + libpng/vorbis; large but mostly covered by Emscripten ports. |
| 423 | Torus Trooper ([source](https://github.com/speps/tt)) | BSD-2-Clause, data included. Written in D: needs LDC's WebAssembly target plus an SDL/OpenGL binding, which the ports pipeline does not have. |

## Needs the original game data

The engine is free, the game is not. Build the engine, then add your own copy of the files listed (via QuantiVerter's file picker, or put them in the zip before converting). Shareware or demo data, where noted, may be shared.

| # | Catalog entry | Game data needed |
| --- | --- | --- |
| 3 | 3D Pinball for Windows - Space Cadet ([source](https://github.com/k4zmu2a/SpaceCadetPinball)) | 3D Pinball Space Cadet: PINBALL.DAT and sound files from Windows XP |
| 63 | Caesar III ([source](https://github.com/bvschaik/julius)) | Caesar III: the original game directory |
| 69 | Cave Story ([source](https://github.com/midzer/nxengine-evo)) | Cave Story: the freeware Cave Story data (redistribution not licensed) |
| 70 | Celeste ([source](https://github.com/MercuryWorkshop/celeste-wasm)) | Celeste: your own copy of the game, which the project loads in the browser |
| 80 | Claw ([source](https://github.com/midzer/OpenClaw)) | Captain Claw: CLAW.REZ |
| 82 | Command & Conquer ([source](https://github.com/midzer/Vanilla-Conquer)) | Command & Conquer: the C&C (Tiberian Dawn) MIX files; EA released them as freeware but not for redistribution |
| 83 | Commander Keen ([source](https://github.com/jamesfmackenzie/chocolatekeen)) | Commander Keen: the episode files; the shareware episode 1 may be redistributed as shareware |
| 84 | Counter Strike & Half Life ([source](https://github.com/yohimik/webxash3d-fwgs)) | Half-Life: the valve/ directory |
| 85 | Counter Strike & Half Life (2) ([source](https://github.com/Pixelsuft/hl)) | Half-Life: the valve/ directory |
| 86 | Counter Strike & Half Life frontend (2) ([source](https://github.com/Pixelsuft/hl)) | Half-Life: the valve/ directory |
| 101 | Der Clou! ([source](https://github.com/midzer/derclou)) | Der Clou!: the original data files |
| 103 | Descent I ([source](https://github.com/midzer/dxx-rebirth)) | Descent: descent.hog/pig; the shareware version may be redistributed |
| 104 | Diablo ([source](https://github.com/d07RiV/diabloweb)) | Diablo: DIABDAT.MPQ, or the shareware spawn.mpq |
| 121 | Duke Nukem 3D ([source](https://github.com/midzer/BelgianChocolateDuke3D)) | Duke Nukem 3D: DUKE3D.GRP; the shareware version may be redistributed |
| 123 | Duke Nukem II ([source](https://github.com/lethal-guitar/RigelEngine)) | Duke Nukem II: the game files; the shareware episode may be redistributed |
| 125 | Dune II ([source](https://github.com/midzer/OpenDUNE)) | Dune II: the original data files |
| 133 | Fade To Black ([source](https://github.com/midzer/f2bgl)) | Fade To Black: the original data files |
| 134 | Fallout ([source](https://github.com/midzer/fallout1-ce)) | Fallout: master.dat and critter.dat |
| 135 | Fallout 2 ([source](https://github.com/roginvs/fallout2-ce)) | Fallout 2: master.dat and critter.dat |
| 166 | Flashback ([source](https://github.com/midzer/reminiscence)) | Flashback: the DOS or Amiga data files |
| 172 | Freeserf ([source](https://github.com/midzer/freeserf)) | The Settlers: SPAE.PA or SPAD.PA |
| 194 | GTA Vice City ([source](https://github.com/Lolendor/reVCDOS)) | GTA: Vice City: the PC game files (the decompilation itself is legally contested) |
| 201 | Heart of Darkness ([source](https://github.com/midzer/hode)) | Heart of Darkness: the PC data files |
| 205 | Heroes of Might and magic 3 for Web ([source](https://github.com/caiiiycuk/vcmi-wasm)) | Heroes of Might and Magic III: the game's Data, Maps and Mp3 directories |
| 206 | Heroes of Might and Magic II ([source](https://github.com/midzer/fheroes2)) | Heroes of Might and Magic II: the game files (the demo's data works) |
| 211 | Homeworld ([source](https://github.com/GardensOfKadesh/Homeworld)) | Homeworld: the game's big files; the released source is licensed for non-commercial use |
| 221 | Jagged Alliance 2 ([source](https://github.com/midzer/ja2-stracciatella)) | Jagged Alliance 2: the game's Data directory |
| 222 | Jazz Jackrabbit ([source](https://github.com/midzer/openjazz)) | Jazz Jackrabbit: the game files; the shareware episode may be redistributed |
| 223 | Jazz Jackrabbit 2 ([source](https://github.com/deathkiller/jazz2-native)) | Jazz Jackrabbit 2: the game files; the shareware demo works |
| 253 | Master of Orion ([source](https://github.com/midzer/1oom)) | Master of Orion: the original data files |
| 277 | NBlood ([site](https://retrogamescenter.ru/ports/nbloodweb/run.html)) | Blood: BLOOD.RFF, SOUNDS.RFF and the other game files; the shareware version may be redistributed |
| 292 | Oneshot: World Machine Edition ([source](https://github.com/MercuryWorkshop/webshot)) | OneShot: World Machine Edition: your own copy of the game, which the project loads in the browser |
| 294 | OpenFodder ([source](https://github.com/OpenFodder/openfodder)) | Cannon Fodder: the game data (free Amiga Format demo data works) |
| 309 | Plants vs Zombies: GOTY Edition ([source](https://github.com/wszqkzqk/PvZ-Portable)) | Plants vs. Zombies: main.pak and the game's properties folder |
| 317 | Prince of Persia ([source](https://github.com/midzer/SDLPoP)) | Prince of Persia: the original data (bundled in the SDLPoP repository, but still copyrighted) |
| 325 | Quake ([source](https://github.com/GMH-Code/Qwasm)) | Quake: pak0.pak (the shareware one may be redistributed) and pak1.pak |
| 326 | Quake 2 ([source](https://github.com/GMH-Code/Qwasm2)) | Quake II: the baseq2 pak files; demo data works |
| 327 | Quake 3 ([source](https://github.com/lrusso/Quake3)) | Quake III Arena: baseq3 pak files; the demo's pak works |
| 334 | Raptor - Call of the Shadows ([source](https://github.com/midzer/raptor)) | Raptor: the game's GLB files; the shareware version may be redistributed |
| 340 | REminiscence ([source](https://github.com/midzer/reminiscence)) | Flashback: the DOS or Amiga data files |
| 342 | Rise of the Triad ([source](https://github.com/midzer/rottexpr)) | Rise of the Triad: the game's WAD files; the shareware version may be redistributed |
| 354 | Shadow Warrior ([source](https://github.com/midzer/jfsw)) | Shadow Warrior: SW.GRP; the shareware version may be redistributed |
| 369 | sm64plus webport PoC ([source](https://github.com/burnedpopcorn/sm64plus-webport-PoC)) | Super Mario 64: a Super Mario 64 ROM |
| 373 | Sonic CD ([source](https://github.com/TWS2401/Sonic-CD-WASM)) | Sonic CD: Data.rsdk from the 2011 remaster |
| 375 | Sonic Mania ([source](https://github.com/VinMannie/SonicManiaWeb)) | Sonic Mania: Data.rsdk |
| 378 | Sonic the Hedgehog (2013) ([source](https://github.com/VinMannie/Sonic-1-WASM)) | Sonic the Hedgehog (2013): Data.rsdk from the mobile remaster |
| 379 | Sonic the Hedgehog 2 ([source](https://github.com/VinMannie/Sonic-2-WASM)) | Sonic the Hedgehog 2 (2013): Data.rsdk from the mobile remaster |
| 383 | sonic3air webport ([source](https://github.com/burnedpopcorn/sonic3air-webport)) | Sonic 3 & Knuckles: the Sonic 3 & Knuckles ROM |
| 385 | Space Cadet ([source](https://github.com/k4zmu2a/SpaceCadetPinball)) | 3D Pinball Space Cadet: PINBALL.DAT and sound files from Windows XP |
| 391 | Star Wars Jedi Knight: Dark Forces II ([source](https://github.com/shinyquagsire23/OpenJKDF2)) | Jedi Knight: Dark Forces II: the game's GOB files |
| 392 | Stardew Valley ([source](https://github.com/degloved-net/stardew-wasm)) | Stardew Valley: your own copy of the game, which the project loads in the browser |
| 398 | Supaplex ([source](https://github.com/midzer/open-supaplex)) | Supaplex: the Supaplex data files (released as freeware, redistribution terms unclear) |
| 402 | Super Mario 64 FPS ([source](https://github.com/gays-studio/sm64fps-port)) | Super Mario 64: a Super Mario 64 ROM |
| 408 | Syndicate ([source](https://github.com/midzer/freesynd)) | Syndicate: the original data files |
| 412 | Terraria ([source](http://github.com/mercuryWorkshop/terraria-wasm)) | Terraria: your own copy of the game, which the project loads in the browser |
| 416 | The Legend of Zelda - A Link to the Past ([source](https://github.com/midzer/zelda3)) | Zelda: A Link to the Past: the US SNES ROM |
| 422 | Tomb Raider ([source](https://github.com/XProger/OpenLara)) | Tomb Raider: the level files (the demo levels work) |
| 438 | Unreal Gold ([source](https://github.com/National-Porting-Association/unrealgold-emscripten)) | Unreal Gold: the game's System, Maps, Textures, Sounds and Music directories |
| 447 | VVVVVV ([source](https://github.com/midzer/vvvvvv)) | VVVVVV: data.zip (source is under a non-commercial licence; the free Make and Play edition's data works) |
| 456 | WipEout ([source](https://github.com/phoboslab/wipeout-rewrite)) | Wipeout: the PSX data files |
| 459 | Wolfenstein 3D ([source](https://github.com/midzer/wolf4sdl)) | Wolfenstein 3D: the game files; the shareware episode may be redistributed |
| 463 | Xash3D ([source](https://github.com/btarg/Xash3D-Emscripten)) | Half-Life: the valve/ directory |
| 464 | XCOM ([source](https://github.com/midzer/OpenXcom)) | UFO: Enemy Unknown / X-COM: the original game files |
| 466 | xrick ([site](https://www.xrick.net/)) | Rick Dangerous: the game data (xrick's own build embeds it, which is not licensed) |

## Free code, protected characters

The code is open, but the game uses characters or trademarks the authors do not own, so it is not redistributed here. It builds like any other Emscripten game if you want it for yourself.

| # | Game | Characters / trademarks |
| --- | --- | --- |
| 254 | Mega Mario ([source](https://github.com/midzer/megamario)) | Mario (Nintendo) |
| 267 | MiniSlug ([source](https://github.com/midzer/minislug)) | Metal Slug (SNK) |
| 298 | Pacman ([source](https://github.com/midzer/pacman)) | Pac-Man (Bandai Namco) |
| 374 | Sonic GDevelop ([source](https://github.com/burnedpopcorn/Sonic-GDevelop-Web-Port)) | Sonic (Sega) |
| 376 | Sonic Robo Blast 2 ([source](https://github.com/chromaticpipe/SRB2-WASM)) | Sonic (Sega) |
| 377 | Sonic Robo Blast 2 (2) ([source](https://github.com/web-ports/srb2)) | Sonic (Sega) |
| 380 | SONIC.EXE ([source](https://github.com/genizy/web-port/tree/main/sonic.exe)) | Sonic (Sega) |
| 381 | Sonic.EXE (ORIGINAL) ([site](https://gn-math.dev/?id=606)) | Sonic (Sega) |
| 382 | Sonic2 Community Cut WebPort ([source](https://github.com/burnedpopcorn/Sonic2-Community-Cut-WebPort)) | Sonic (Sega) |
| 389 | SRB2 Kart ([source](https://github.com/skyleite/Kart-Public-WASM/)) | Sonic and Mario Kart (Sega, Nintendo) |
| 403 | Super Mario Bros. Remastered ([source](https://github.com/bubbls/ports/blob/main/smb-remastered)) | Super Mario Bros. (Nintendo) |
| 404 | Super Mario War ([source](https://github.com/mmatyas/supermariowar)) | Mario (Nintendo) |

## Licence unclear

Source is available, but the repository does not clearly allow sharing the game. It can join the library once the authors state a licence.

| # | Game | Why |
| --- | --- | --- |
| 20 | Apotris ([source](https://gitea.com/akouzoukos/apotris)) | Apotris: source published on Gitea without a clear licence for its assets (Tetris is also a protected trademark). |
| 24 | Asylum ([source](https://github.com/GMH-Code/Asylum)) | Asylum: SDL port of the 1994 Archimedes game; the data's redistribution terms are not stated. |
| 45 | Biolab Disaster ([source](https://github.com/phoboslab/high_biolab)) | Biolab Disaster: engine code is MIT, the game's graphics and sound are not openly licensed. |
| 97 | Defblade ([source](https://github.com/midzer/paper-world)) | Defblade: no licence for the game data in the repository. |
| 184 | Gilbert and the doors ([source](https://github.com/midzer/gilbert)) | Gilbert and the Doors: no licence in the repository. |
| 214 | Hurrican ([source](https://github.com/midzer/hurrican)) | Hurrican: code is open, the data's licence is not stated clearly. |
| 251 | Magic Sushi ([source](https://github.com/EXL/Magic-Sushi)) | Magic Sushi: no licence for the data in the repository. |
| 262 | Minecraft 4k ([source](https://github.com/midzer/m4kc)) | Minecraft 4k (m4kc): check the repository's licence; the original Minecraft 4k is Mojang's. |
| 293 | Open Golf ([source](https://github.com/mgerdes/Open-Golf)) | Open Golf: check the repository's licence for the assets. |
| 320 | Prototype ([source](https://github.com/midzer/prototype)) | Prototype: freeware game; the repository does not grant redistribution. |
| 344 | Rocks'n'Diamonds ([site](https://www.artsoft.org/rocksndiamonds/)) | Rocks'n'Diamonds: the code is GPL, the classic graphics and levels have their own terms. |
| 356 | Shiromino ([source](https://github.com/midzer/shiromino)) | Shiromino: code is open, some assets have unclear terms. |
| 370 | Sokoban ([source](https://github.com/midzer/simple-sokoban)) | Sokoban: no licence in the repository. |
| 428 | Tower To Heaven ([source](https://codeberg.org/midzer/tth)) | Tower To Heaven: no licence for the game in the repository. |

## Proprietary games

Only the game's publisher can license it for sharing, so it is not in the library. If you own the game and have a web build of it, convert it with QuantiVerter: its engine is covered in [ENGINES.md](ENGINES.md).

| # | Game | Link |
| --- | --- | --- |
| 1 | -3 | [source](https://github.com/aukak/-3) |
| 2 | 20 Minutes Till Dawn | [source](https://github.com/web-ports/20-minutes) |
| 4 | A Bite at Freddy's | [source](https://github.com/freebuisness/assets/tree/main/258) |
| 5 | A Difficult Game About Climbing | [source](https://github.com/web-ports/adgac) |
| 6 | A Game about Feeding a Black Hole | [source](https://github.com/GrassPorts/A-Game-About-Feeding-A-Black-Hole) |
| 8 | Amanda The Adventurer | [source](https://github.com/genizy/web-port/tree/main/amanda-the-adventurer) |
| 10 | Andy's Apple Farm | [source](https://github.com/genizy/web-port/tree/main/andys-apple-farm) |
| 12 | Angry Birds 2 | [source](https://github.com/Reeyuki/angry2) |
| 13 | Angry Birds Epic v3.0.1 | [source](https://github.com/DarkTerraYT/EpicWeb) |
| 14 | Animal Crossing | [source](https://github.com/web-ports/ac-gamecube) |
| 15 | Animal Crossing (GAMECUBE) | [site](https://gn-math.dev/?id=828) |
| 16 | Anton Blast Demo | [source](https://github.com/burnedpopcorn/Anton-Blast-Demo-Web-Port) |
| 17 | Antonblast | [source](https://github.com/web-ports/antonblast) |
| 18 | Apes vs Helium | [source](https://github.com/bubbls/UGS-Assets/tree/main/apesvshelium) |
| 19 | Apotheon | [source](https://github.com/degloved-net/Apotheon) |
| 21 | Arco | [source](https://github.com/degloved-net/arco) |
| 22 | Arthur's Nightmare | [site](https://gn-math.dev/?id=645) |
| 27 | Bad Parenting 1 | [site](https://gn-math.dev/?id=166) |
| 28 | Bad Piggies | [site](https://gn-math.dev/?id=752) |
| 29 | Balatro | [source](https://github.com/W0W53R/web-balatro) |
| 30 | Baldi's Basics Birthday Bash | [source](https://github.com/woahhcrackers/BirthdayBashWeb) |
| 31 | Baldi's Basics Classic Remastered | [source](https://github.com/genizy/web-port/tree/main/baldi-remaster) |
| 32 | Baldi's Basics Plus | [source](https://github.com/genizy/web-port/tree/main/baldi-plus) |
| 33 | Baldi's Basics: Minus 3 | [source](https://github.com/aukak/-3) |
| 35 | Bat to Bed Demo | [source](https://github.com/gays-studio/BatToBed-DEMO-webport) |
| 36 | Bat to the Heavens | [source](https://github.com/gays-studio/bat-to-the-heavens) |
| 37 | Beat Banger | [source](https://github.com/ajtabjs/bbport) |
| 38 | Beatblock | [site](https://gn-math.dev/?id=787) |
| 39 | Bendy and The Ink Machine | [source](https://github.com/genizy/web-port/tree/main/bendy) |
| 40 | Bendy and The Ink Machine (2) | [source](https://github.com/slqntdevss/BATIMFullPort) |
| 41 | Bendy and The Ink Machine (3) | [source](https://github.com/genizy/web-port/tree/main/bendy) |
| 42 | Bendy and The Ink Machine (4) | [source](https://github.com/web-ports/bendy-and-the-ink-machine) |
| 43 | Bendy and the Ink Machine: ALL CHAPTERS | [site](https://gn-math.dev/?id=803) |
| 44 | BERGENTRUCK 201x | [source](https://github.com/genizy/web-port/tree/main/bergentruck) |
| 48 | BLOODMONEY! | [source](https://github.com/genizy/web-port/tree/main/bloodmoney) |
| 50 | boil Noodles at Night | [source](https://github.com/SomeRandomFella/portsandrips/tree/master/boilnoodles) |
| 56 | Brotato | [source](https://github.com/BlueGameMC/BrotatoWeb) |
| 57 | Brotato (2) | [source](https://github.com/gays-studio/brotato-webport/) |
| 58 | Brotato (3) | [source](https://github.com/wowdabug/s1/tree/main/brotato) |
| 59 | Buckshot Roulette | [source](https://github.com/genizy/web-port/tree/main/buckshot-roulette) |
| 61 | Buster Jam | [site](https://gn-math.dev/?id=646) |
| 65 | Capuchin | [source](https://github.com/aukak/Capuchin) |
| 66 | CaseOh's Basics in Eating and Fast Food | [site](https://gn-math.dev/?id=758) |
| 67 | Cat Goes Fishing | [source](https://github.com/Reeyuki/CatFish) |
| 68 | Catchaware | [source](https://github.com/barnicalstuff/captchaware) |
| 71 | Celeste (2) | [source](https://github.com/web-ports/celeste) |
| 72 | Celeste 3D | [source](https://github.com/gays-studio/celeste3d) |
| 73 | Chasing Tails ~A Promise in the Snow~ | [source](https://github.com/gays-studio/chasingtails) |
| 74 | Cheese Rollers | [source](https://github.com/SomeRandomFella/portsandrips/tree/master/CheeseRollingWeb) |
| 75 | Cheese Rolling | [site](https://gn-math.dev/?id=762) |
| 76 | Cheesed Up 1.3.1 | [source](https://github.com/burnedpopcorn/Cheesed-Up-1.3.1-Web-Port) |
| 77 | Christmas Massacre | [source](https://github.com/web-ports/christmas-massacre) |
| 79 | Class of '09 | [source](https://github.com/genizy/web-port/tree/main/class-of-09) |
| 81 | Clover Pit | [source](https://github.com/web-ports/clover-pit) |
| 87 | Crazy Cattle 3D | [site](https://gn-math.dev/?id=164) |
| 89 | Cruelty Squad | [source](https://github.com/imt00dizzy/cruelty-squad) |
| 90 | Cruelty Squad (2) | [source](https://github.com/web-ports/cruelty-squad) |
| 91 | Cuphead | [source](https://github.com/genizy/web-port/tree/main/cuphead) |
| 92 | Cuphead (2) | [source](https://github.com/woahhcrackers/CupheadWeb) |
| 94 | Dawnfolk | [source](https://github.com/degloved-net/dawnfolk) |
| 95 | Dead Plate | [source](https://github.com/genizy/web-port/tree/main/dead-plate) |
| 96 | Deadseat | [source](https://github.com/genizy/web-port/tree/main/deadseat) |
| 98 | Deltarune | [source](https://github.com/genizy/web-port/tree/main/deltatraveler) |
| 99 | Deltarune Chapters 1-4 | [site](https://aukak.itch.io/deltarune) |
| 100 | Deltatraveler | [site](https://gn-math.dev/?id=560) |
| 102 | Descent | [site](https://retrogamescenter.ru/ports/descentweb/index.html) |
| 105 | Dice a Million | [source](https://github.com/NotRexed/Unblocked-Games/tree/main/diceamillion) |
| 106 | Dictators:No Peace Countryballs | [source](https://github.com/web-ports/countryballsdictator) |
| 107 | Do NOT Take This Cat Home | [source](https://github.com/genizy/web-port/tree/main/donottakethiscathome) |
| 108 | Doki Doki Literature Club | [source](https://github.com/EmeraldGreenR/EmeraldGreenR.github.io) |
| 109 | Doki Doki Literature Club Plus! | [site](https://selenite.cc/resources/semag/ddlcplus/index.html) |
| 111 | Doom 3 | [source](https://github.com/web-ports/doom-3) |
| 113 | DOOM I & II | [site](https://retrogamescenter.ru/ports/truedoom/index.html) |
| 116 | Duck Life 8 | [site](https://gn-math.dev/?id=695) |
| 117 | Duck Life Adventure | [source](https://github.com/aukak/duck-life-adventure) |
| 118 | Duck Life Adventure (2) | [source](https://github.com/web-ports/duck-8) |
| 119 | Dude Simulator | [site](https://dude-simulator-webgl.netlify.app/) |
| 120 | Dude Simulator 2 | [site](https://dude-sim-2-webgl-ported-by-carteryes.netlify.app/) |
| 122 | Duke Nukem 3D TG | [site](https://retrogamescenter.ru/ports/duke3dtg/index.html) |
| 124 | Dumb Ways to Die (v1.6) | [source](https://github.com/web-ports/dumb-ways-to-die) |
| 126 | DUNE II TG | [site](https://retrogamescenter.ru/ports/dune2tg/index.html) |
| 128 | Eaglercraft | [site](https://retrogamescenter.ru/ports/eaglecarftg/index.html) |
| 131 | Endoparasitic | [site](https://gn-math.dev/?id=286) |
| 132 | Endoparasitic 2 | [site](https://gn-math.dev/?id=724) |
| 136 | Faster Than Light: Demo | [site](https://retrogamescenter.ru/ports/ftldemo/index.html) |
| 137 | Fear & Hunger | [site](https://gn-math.dev/?id=706) |
| 138 | Fear & Hunger 2: Termina | [site](https://gn-math.dev/?id=794) |
| 139 | Fear and Hunger | [source](https://github.com/web-ports/fear-and-hunger) |
| 140 | Fear and Hunger 2: Termina | [source](https://github.com/web-ports/fear-and-hunger-2) |
| 141 | Fears To Fathom | [source](https://github.com/genizy/web-port/tree/main/fears-to-fathom) |
| 142 | Fears to Fathom: Home Alone | [source](https://github.com/slqntdevss/FTFHAPort) |
| 143 | Fih | [site](https://gn-math.dev/?id=797) |
| 144 | FISH | [source](https://github.com/web-ports/fish) |
| 145 | Five Nighs at Epstein's | [source](https://github.com/web-ports/fnae) |
| 146 | Five Nights at Candy's | [site](https://gn-math.dev/?id=503) |
| 147 | Five Nights at Candy's 1 | [source](https://github.com/web-ports/fnac/tree/main/1) |
| 148 | Five Nights at Candy's 2 | [source](https://github.com/web-ports/fnac/tree/main/2) |
| 149 | Five Nights at Epstein's | [source](https://github.com/web-ports/fnae) |
| 150 | Five Nights at Freddy's | [site](https://gn-math.dev/?id=38) |
| 151 | Five Nights at Freddy's 1 | [source](https://github.com/irv77/hd_fnaf/tree/main/1) |
| 152 | Five Nights at Freddy's 2 | [source](https://github.com/irv77/hd_fnaf/tree/main/2) |
| 153 | Five Nights at Freddy's 3 | [source](https://github.com/irv77/hd_fnaf/tree/main/3) |
| 154 | Five Nights at Freddy's 4 | [source](https://github.com/irv77/hd_fnaf/tree/main/4) |
| 155 | Five Nights at Freddy's 4: Halloween | [site](https://gn-math.dev/?id=428) |
| 156 | Five Nights at Freddy's World: Refreshed | [source](https://github.com/web-ports/fnaf-world-refreshed) |
| 157 | Five Nights at Freddy's: Pizza Simulator | [site](https://gn-math.dev/?id=191) |
| 158 | Five Nights at Freddy's: Pizzeria Simulator | [source](https://github.com/irv77/hd_fnaf/tree/main/ps) |
| 159 | Five Nights at Freddy's: Sister Location | [source](https://github.com/irv77/hd_fnaf/tree/main/sl) |
| 160 | Five Nights at Freddy's: Ultimate Custom Night | [source](https://github.com/irv77/hd_fnaf/tree/main/ucn) |
| 161 | Five Nights at Freddy's: World | [source](https://github.com/irv77/hd_fnaf/tree/main/w) |
| 162 | Five Nights at Frickbear's 3 | [source](https://github.com/Reeyuki/frickbears3port/) |
| 163 | Five Nights at Last Breath | [site](https://gn-math.dev/?id=750) |
| 164 | Five Nights in Anime 3D | [source](https://github.com/Reeyuki/fivenightsanime3dport) |
| 167 | Flying Gorilla | [source](https://github.com/web-ports/flying-gorilla) |
| 168 | Flying Gorilla 3D | [source](https://github.com/web-ports/flying-gorilla) |
| 169 | FNAF | [source](https://github.com/genizy/web-port/tree/main/fnaf) |
| 174 | Fundamental Paper Novel | [site](https://gn-math.dev/?id=746) |
| 175 | Fungiman | [source](https://github.com/GrassPorts/Fungiman) |
| 176 | Fused 240 | [site](https://gn-math.dev/?id=722) |
| 177 | Gabriel's Awesome Schoolhouse | [source](https://github.com/web-ports/gash) |
| 178 | Gabriel's Awesome Schoolhouse (GASH) | [site](https://gn-math.dev/?id=784) |
| 180 | Genital Jousting | [source](https://github.com/degloved-net/genital-jousting) |
| 181 | Geometry Dash | [site](https://gn-math.dev/?id=785) |
| 182 | Getting Over It | [source](https://github.com/genizy/web-port/tree/main/getting-over-it) |
| 183 | Getting Over It with Bennett Foddy | [site](https://gn-math.dev/?id=557) |
| 187 | Gorilla Tag | [source](https://github.com/web-ports/gorilla-tag) |
| 188 | Gorilla Tag (2) | [source](https://github.com/aukak/gorrila-tag) |
| 189 | Granny | [source](https://github.com/web-ports/granny) |
| 190 | Granny (2) | [source](https://github.com/aukak/Granny) |
| 191 | Granny (3) | [source](https://github.com/woahhcrackers/GrannyWeb) |
| 192 | Gravity Circuit | [source](https://github.com/TheChillVideoGameNerd/Gravity-Circuit-Web-Port) |
| 193 | GTA 3 | [source](https://github.com/larpinguser/HelloWorldScriptBasicFunctionCSharpIsCool/) |
| 195 | Half Life | [site](https://gn-math.dev/?id=262) |
| 196 | Half Life 2 | [site](https://hl2.slqnt.dev/) |
| 197 | Half Life: Opposing Force | [site](https://gn-math.dev/?id=693) |
| 198 | Happy Sheepies | [source](https://github.com/genizy/web-port/tree/main/happy-sheepies) |
| 200 | HAYAI | [source](https://github.com/degloved-net/HAYAI) |
| 202 | Helltaker | [source](https://github.com/larpinguser/Helltaker-Web/tree/main/helltakerweb) |
| 204 | HERETIC / HEXEN | [site](https://retrogamescenter.ru/ports/heretichex/index.html) |
| 207 | Hexen II | [site](https://dos.zone/hexen-2-fteqw/) |
| 208 | Hollow Knight | [source](https://github.com/aukak/hollow-knight) |
| 209 | Hollow Knight: Silksong | [source](https://github.com/web-ports/hollow-knight-silksong) |
| 210 | Hollow Knight: Silksong (2) | [source](https://github.com/webporting/Hollow-Knight-Silksong) |
| 212 | Hotline Miami | [source](https://github.com/genizy/web-port/tree/main/hotline-miami) |
| 213 | Human Expenditure Program | [source](https://github.com/genizy/web-port/tree/main/human-expenditure-program) |
| 215 | I Spoke to God | [source](https://github.com/degloved-net/i-spoke-to-god) |
| 216 | I Wanna Be The Guy | [site](https://gn-math.dev/?id=834) |
| 217 | In Stars and Time | [source](https://github.com/Reeyuki/InStarsAndTime) |
| 218 | Inscryption | [source](https://github.com/Reeyuki/InscryptionWebport) |
| 219 | Iron Lung | [source](https://github.com/web-ports/iron-lung) |
| 220 | IS THAT A GUBBY? | [source](https://github.com/xxskidxx69420-ai/isthatagubbywebportheh) |
| 224 | Jeffrey Epstein Basics In Education And Kidnapping | [site](https://gn-math.dev/?id=751) |
| 225 | Jelly Drift | [source](https://github.com/genizy/web-port/tree/main/jelly-drift) |
| 226 | JENNY | [source](https://github.com/MRVAPORWAVE25/JennyGameFiles) |
| 228 | Jumbo Mario | [site](https://gn-math.dev/?id=712) |
| 230 | Just Shapes & Beats | [source](https://github.com/web-ports/jsab) |
| 231 | Karlson | [source](https://github.com/genizy/web-port/tree/main/karlson) |
| 232 | Karlson (2) | [source](https://github.com/thecheetoman/KarlsonWebPort) |
| 233 | Kill the Ice Age Baby Adventure 2 | [source](https://github.com/SomeRandomFella/kill-ice-age-baby-adventure-2-) |
| 234 | Kindergarten | [site](https://gn-math.dev/?id=445) |
| 235 | Kindergarten 1 & 2 | [source](https://github.com/genizy/web-port/tree/main/kindergarten) |
| 236 | Kindergarten 2 | [site](https://gn-math.dev/?id=446) |
| 237 | Kindergarten 3 | [source](https://github.com/slqntdevss/Kindergarten3Port) |
| 238 | Kirby ~ Soft & Wet | [site](https://gn-math.dev/?id=692) |
| 239 | Kirby ~ Soft and Wet | [source](https://github.com/web-ports/soft-and-wet) |
| 240 | Klifur | [source](https://github.com/aukak/klifur) |
| 241 | koi/_flixel | [site](https://oldgrounds.xyz/) |
| 242 | La Madriguera | [source](https://github.com/web-ports/la-madriguera) |
| 243 | La Madriguera (Lazy Bear Game) | [site](https://gn-math.dev/?id=843) |
| 246 | Lethal Ape | [source](https://github.com/web-ports/lethal-ape) |
| 249 | Lobotomy Corporation | [source](https://github.com/Reeyuki/lobcorp) |
| 250 | Look Outside | [source](https://github.com/web-ports/look-outside) |
| 252 | Marble Blast Gold & Marble Blast Platinum | [source](https://github.com/Vanilagy/MarbleBlast) |
| 255 | Meteor 60 Seconds | [source](https://github.com/ThatWirdGuy/Meteor-60-Seconds-Web) |
| 256 | Midnight Shift | [site](https://gn-math.dev/?id=658) |
| 257 | Milk inside a bag of milk inside a bag of milk | [source](https://github.com/web-ports/milk-bag-games/tree/main/inside) |
| 258 | Milk outside a bag of milk outside a bag of milk | [source](https://github.com/web-ports/milk-bag-games/tree/main/outside) |
| 259 | Milkman Karlson | [source](https://github.com/genizy/web-port/tree/main/milkman-karlson) |
| 260 | Mindwave | [site](https://gn-math.dev/?id=648) |
| 261 | Minecraft 0.6.1 | [site](https://retrogamescenter.ru/ports/minecraft061/index.html) |
| 264 | Minecraft Pocket Edition | [site](https://gn-math.dev/?id=754) |
| 266 | Minesweeper Plus | [source](https://github.com/genizy/web-port/tree/main/minesweeperplus) |
| 268 | MiSide | [source](https://github.com/web-ports/miside/) |
| 269 | MiSide (2) | [source](https://github.com/woahhcrackers/MiSideWeb) |
| 270 | Muddy Heights | [source](https://github.com/gabadagabadgoo/morbidy-obese-chickens) |
| 271 | My Baby Talking Hippo | [source](https://github.com/web-ports/talking-hippo) |
| 272 | My Dictator Stalin Can't Be This Cute ?! | [source](https://github.com/degloved-net/my-dictator-stalin-cant-be-this-cute) |
| 273 | My Femboy Roommate | [source](http://github.com/gays-studio/mfr-webport) |
| 274 | My Femboy Roommate (2) | [source](https://github.com/Cute-Orange-Cat/MFR/tree/main) |
| 275 | My Talking Baby Hippo | [site](https://gn-math.dev/?id=840) |
| 276 | NAM / Napalm | [site](https://retrogamescenter.ru/ports/namweb/run.html) |
| 278 | Needy Streamer Overload | [source](https://github.com/web-ports/needy-streamer-overload) |
| 280 | Night in the Woods | [source](https://github.com/reeyuki/NightInTheWoods/) |
| 282 | Nodebuster | [source](https://github.com/degloved-net/nodebuster) |
| 283 | Nothing | [source](https://github.com/gays-studio/nothing-wasm-web) |
| 284 | Nothing (2) | [source](https://github.com/googoogoob/NothingWebPort) |
| 285 | Nubby's Number Factory | [source](https://github.com/genizy/biologyexams/tree/main/nubbys-number-factory) |
| 287 | OLD CheesedUP | [source](https://github.com/burnedpopcorn/OLD-CheesedUP-Web-Port) |
| 288 | OMORI | [source](https://github.com/genizy/web-port/tree/main/omori-fixed) |
| 289 | One Night At Kim Jong Un's | [source](https://github.com/usheje883-maker/One-Night-At-Kim-Jong-Un-s-Webport) |
| 290 | One Potion Please! | [source](https://github.com/ajtabjs/onepotionplease) |
| 291 | Oneshot (Legacy) | [site](https://gn-math.dev/?id=622) |
| 297 | Overburden | [site](https://gn-math.dev/?id=760) |
| 299 | PEAK (VERY wip) | [source](https://github.com/wasmdotrip/Peak-Port) |
| 300 | Peaks of Yore | [source](https://github.com/web-ports/peaks-of-yore) |
| 301 | People Playground | [source](https://github.com/genizy/web-port/tree/main/people-playground) |
| 302 | Pizza Tower | [source](https://github.com/genizy/web-port/tree/main/pizza-tower) |
| 303 | Pizza Tower 1.1.0 | [source](https://github.com/burnedpopcorn/Pizza-Tower-1.1.0-Web-Port) |
| 304 | Pizza Tower: Scoutdigo | [site](https://gn-math.dev/?id=628) |
| 305 | PizzaTower April2021 WebPort | [source](https://github.com/burnedpopcorn/PizzaTower-April2021-WebPort) |
| 306 | Plague Inc | [site](https://gn-math.dev/?id=805) |
| 307 | Plague Inc: Evolved | [source](https://github.com/Reeyuki/PlagueIncEvolved) |
| 308 | Plants vs Zombies: Fusion | [source](https://github.com/gays-studio/pvzfusion) |
| 310 | Plants vs Zombies: GOTY Edition (2) | [source](https://github.com/web-ports/pvz) |
| 311 | Plants vs Zombies: GOTY Edition (3) | [source](https://github.com/ajtabjs/pvzdeploy) |
| 312 | Plants vs. Zombies | [site](https://retrogamescenter.ru/ports/pvzweb/index.html) |
| 313 | Portal | [source](https://github.com/weliveinhell/source-engine) |
| 314 | Power Hover | [source](https://github.com/web-ports/power-hover) |
| 319 | Promises to Keep | [site](https://gitea.mcalec.dev/mcalec/ptk) |
| 323 | PT Scoutdigo | [source](https://github.com/burnedpopcorn/PT-Scoutdigo-Web-Port) |
| 328 | Quake II | [site](https://retrogamescenter.ru/ports/Q2web/index.html) |
| 329 | Quake III Arena | [site](https://gn-math.dev/?id=263) |
| 330 | Quake TG | [site](https://retrogamescenter.ru/ports/quaketg/index.html) |
| 331 | R.E.P.O | [source](https://github.com/genizy/web-port/tree/main/repo) |
| 332 | RAFT | [source](https://github.com/genizy/web-port/tree/main/raft) |
| 333 | Raldi's Crackhouse | [site](https://gn-math.dev/?id=670) |
| 335 | RE:RUN | [source](https://github.com/aukak/RE-RUN) |
| 337 | Redneck Rampage | [site](https://retrogamescenter.ru/ports/redneckrweb/run.html) |
| 338 | Redneck Rampage: Rides Again | [site](https://retrogamescenter.ru/ports/rrridesagain/run.html) |
| 339 | Redneck Rampage: Route 66 | [site](https://retrogamescenter.ru/ports/rrroute66/run.html) |
| 341 | Return to Castle Wolfenstein | [site](https://retrogamescenter.ru/ports/castlewolf/index.html) |
| 345 | Running Fred | [source](https://github.com/aukak/running-fred) |
| 346 | S.P.L.I.T | [source](https://github.com/degloved-net/s.p.l.i.t) |
| 347 | Saihate Station (さいはて駅) | [source](https://github.com/web-ports/saihate-station) |
| 348 | Scampton The Great | [site](https://gn-math.dev/?id=802) |
| 349 | Schoolboy Runaway | [source](https://github.com/genizy/web-port/tree/main/schoolboy-runaway) |
| 350 | Scoutdingo | [source](https://github.com/web-ports/scoutdingo) |
| 353 | Sex with Hitler | [source](https://github.com/ajtabjs/swhport) |
| 355 | Shift at Midnight | [source](https://github.com/webporting/Shift-At-Midnight) |
| 358 | Slender: The 8 Pages | [site](https://gn-math.dev/?id=451) |
| 359 | Slender: The Eight Pages | [source](https://github.com/genizy/web-port/tree/main/slender) |
| 360 | Slenderina The Cellar | [source](https://github.com/Reeyuki/slenderina) |
| 361 | Slendytubbies | [source](https://github.com/web-ports/slendytubbies) |
| 362 | Slendytubbies 1 | [site](https://gn-math.dev/?id=796) |
| 363 | Slendytubbies 2 | [source](https://github.com/web-ports/slendytubbies/tree/main/2) |
| 364 | Slendytubbies 2D | [source](https://github.com/web-ports/slendytubbies/tree/main/2d) |
| 365 | Slime Rancher | [site](https://gn-math.dev/?id=591) |
| 366 | Slime Ranchers | [source](https://github.com/web-ports/slime-ranchers) |
| 367 | Slime Ranchers (2) | [source](https://github.com/Reeyuki/SlimeRanch) |
| 368 | SM Kart ZX | [source](https://github.com/burnedpopcorn/SM-Kart-ZX-Web-Port) |
| 371 | Something | [source](https://github.com/gays-studio/something-web) |
| 372 | Something (2) | [source](https://github.com/googoogoob/SomethingWebPort) |
| 384 | SonicManiaPlusWebPort | [source](https://github.com/burnedpopcorn/SonicManiaPlusWebPort) |
| 386 | Space Rangers: Quests | [site](https://spacerangers.gitlab.io/) |
| 387 | Spaceflight Simulator | [source](https://github.com/web-ports/spaceflight-simulator) |
| 388 | Speed Stars | [source](https://github.com/genizy/web-port/tree/main/speed-stars) |
| 390 | Star Wars Jedi Knight Dark Forces 2 | [site](https://retrogamescenter.ru/ports/oswjkdf2/index.html) |
| 394 | Stick with It | [source](https://github.com/slqntdevss/StickWithItPort) |
| 395 | Sugary Spire | [source](https://github.com/burnedpopcorn/Sugary-Spire-Web-Port) |
| 396 | Suicide Guy Deluxe | [source](https://github.com/Reeyuki/SuicideGuyDeluxe) |
| 397 | Sunky's Schoolhouse | [source](https://github.com/gays-studio/sunkys-schoolhouse-webport) |
| 399 | Super Bo Noise | [source](https://github.com/burnedpopcorn/Super-Bo-Noise-Web-Port) |
| 400 | Super Choppy Orc | [source](https://github.com/gays-studio/super-choppy-orc) |
| 401 | Super Mario 64 | [site](https://gn-math.dev/?id=588) |
| 405 | Super Monkey Ball | [site](https://monkeyball-online.pages.dev/) |
| 407 | Swabs Expedition | [source](https://github.com/burnedpopcorn/Swabs-Expedition-Web-Port) |
| 409 | T Cubed | [source](https://github.com/web-ports/baldi-mods/tree/main/t3) |
| 410 | Taiko no Tatsujin | [site](https://cjdgrevival.com/) |
| 411 | Tattletail | [source](https://github.com/genizy/web-port/tree/main/tattletail) |
| 413 | Terraria (2) | [source](https://github.com/web-ports/terraria) |
| 414 | That's Not My Neighbor | [source](https://github.com/genizy/web-port/tree/main/thats-not-my-neighbor) |
| 415 | The Deadseat | [source](https://github.com/genizy/web-port/tree/main/deadseat) |
| 417 | The Man From the Window | [source](https://github.com/genizy/web-port/tree/main/the-man-in-the-window) |
| 418 | The Man From the Window 2 | [source](https://github.com/wasm-rip/the-man-from-the-window-2-web) |
| 419 | The Man In The Window | [site](https://gn-math.dev/?id=459) |
| 420 | There's a Butcher Around | [source](https://github.com/usheje883-maker/There-s-A-Butcher-Around-Webport) |
| 424 | Totally Accurate Battle Simulator | [source](https://github.com/web-ports/tabs) |
| 425 | Totally Accurate Battle Simulator (2) | [source](https://github.com/Reeyuki/Tabs) |
| 426 | Totally Accurate Battle Simulator (TABS) | [site](https://gn-math.dev/?id=827) |
| 427 | Touhou Mother | [source](https://github.com/aukak/gameports/tree/main/touhou%20mother) |
| 429 | Traffic Racer | [source](https://github.com/genizy/traffic-racer) |
| 430 | TriZon | [source](https://github.com/degloved-net/trizon) |
| 431 | Trombone Champ | [source](https://github.com/degloved-net/trombone-champ) |
| 432 | t³ (T cubed) | [site](https://gn-math.dev/?id=818) |
| 433 | ULTRAKILL | [site](https://gn-math.dev/?id=196) |
| 434 | Ultrakill Prelude | [source](https://github.com/genizy/web-port/tree/main/ultrakill) |
| 435 | Ultrapool | [source](https://github.com/ParrrotVR/ultrapoolwebport) |
| 436 | Undertale | [source](https://github.com/genizy/web-port/tree/main/undertale) |
| 437 | Undertale Yellow | [source](https://github.com/genizy/web-port/tree/main/undertale-yellow) |
| 439 | Untitled Goose Game | [source](https://github.com/web-ports/untitled-goose-game) |
| 440 | Untitled Goose Game (2) | [source](https://github.com/webporting/Untitled-Goose-Game) |
| 441 | Upload Labs | [source](https://github.com/googoogoob/UploadLabsWebPort) |
| 442 | Upstream | [source](https://github.com/degloved-net/upstream) |
| 443 | UvuvwevwevweOnyetenvewveUgwemubwemOssas | [source](https://github.com/bubbls/ports/tree/main/UvuvwevwevweOnyetenvewveUgwemubwemOssas) |
| 446 | Void Whispers | [source](https://github.com/degloved-net/void-whispers) |
| 451 | Webfishing | [source](https://github.com/genizy/web-port/tree/main/web-fishing) |
| 453 | while True: learn() | [source](https://github.com/dashiellbenton/ports/tree/main/while-true-learn) |
| 454 | Who's Your Daddy? | [source](https://github.com/Reeyuki/daddygame) |
| 455 | Who's Your Daddy? (2) | [source](https://github.com/web-ports/daddygame) |
| 457 | Witch's Heart | [source](https://github.com/genizy/web-port/tree/main/witch-heart) |
| 458 | Wizards in Shorts | [source](https://github.com/Reeyuki/WizardsInShorts) |
| 460 | Wolfenstein 3D TG | [site](https://retrogamescenter.ru/ports/wolf3dtg/index.html) |
| 461 | Worldbox | [source](https://gitlab.com/Shindo957-Official/worldfox) |
| 462 | WWII GI | [site](https://retrogamescenter.ru/ports/ww2giweb/run.html) |
| 467 | Yandere Simulator | [source](https://github.com/genizy/web-port/tree/main/yandere-simulator) |
| 468 | Yesterday's Meat | [source](https://github.com/SoupcanUBG/Yesterdays-Meat) |
| 469 | yomih hustle | [source](https://github.com/web-ports/yomi-hustle) |
| 470 | You Want Half a Mounds Bar | [source](https://github.com/wasm-rip/You-Want-Half-A-Mounds-Bar-Web) |
| 471 | Your Only Move is Hustle | [source](https://github.com/webporting/Your-Only-Move-Is-HUSTLE) |
| 472 | Your Only Move is Hustle (2) | [source](https://github.com/web-ports/yomi-hustle) |
| 473 | Youtubers Life OMG! | [source](https://github.com/Reeyuki/ytlifeomg) |
| 474 | Yume Nikki | [source](https://github.com/genizy/web-port/tree/main/yume-nikki) |

## Not a game

Accounts, websites and collections listed in the catalog.

| # | Entry | What it is |
| --- | --- | --- |
| 49 | bog/aukak ([source](https://github.com/aukak)) | a GitHub account |
| 53 | breadbb/genizy ([source](https://github.com/genizy)) | a GitHub account |
| 60 | burnedwebsite ([source](https://github.com/burnedpopcorn/burnedwebsite)) | a website |
| 114 | Dos.Zone ([site](https://dos.zone)) | a website with a DOS game collection |
| 179 | gays dot' studio ([source](https://github.com/gays-studio)) | a GitHub account |
| 185 | GMH-Code ([source](https://github.com/GMH-Code)) | a GitHub account |
| 227 | JS-DOS ([source](https://github.com/js-dos/)) | the js-dos project (Quantiverse already embeds js-dos) |
| 244 | Lacey's Flash Games ([source](https://github.com/genizy/web-port/tree/main/lacysflashgames)) | a collection of Flash games (proprietary; Flash itself works through Ruffle) |
| 321 | Proxified Ports ([source](https://github.com/burnedpopcorn/Proxified-Ports)) | a collection of proxied ports |
| 322 | PT HTML Launcher ([source](https://github.com/burnedpopcorn/PT-HTML-Launcher)) | a launcher |
| 324 | PTWebLauncher ([source](https://github.com/burnedpopcorn/PTWebLauncher)) | a launcher |
| 336 | Rec Room ([source](https://github.com/98corbins)) | a GitHub account |
| 448 | wasm.rip ([site](https://wasm.rip)) | a website |
| 450 | Web Port Unblocked ([source](https://github.com/burnedpopcorn/Web-Port-Unblocked)) | a collection website |
| 452 | webport.ing ([source](https://github.com/webporting)) | a website |

## No link in the catalog

The catalog lists the name without a source or a site.

| # | Game | Link |
| --- | --- | --- |
| 52 | Bowerwhelm | — |
| 115 | Dressing Room | — |
| 129 | Egg Fried Rice | — |
| 186 | GO TO BED | — |
| 247 | Lethal Company | — |
| 263 | Minecraft LCE | — |
| 265 | Minecraft Story Mode | — |
| 316 | Pretend it's not there | — |
| 318 | Project Zomboid | — |
| 421 | To The Core | — |
