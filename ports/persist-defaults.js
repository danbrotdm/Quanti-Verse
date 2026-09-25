/* Quantiverse port helper: default folders for persist.js, where most games keep their saves:
 * $HOME (Emscripten's /home/web_user) and SDL's SDL_GetPrefPath() root (/libsdl). */
var Module = typeof Module != 'undefined' ? Module : {};
Module.qvPersist = Module.qvPersist || ['/home/web_user', '/libsdl'];
