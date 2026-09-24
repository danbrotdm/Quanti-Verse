/* Quantiverse cross-origin isolation service worker.
 *
 * Multithreaded web games (Emscripten pthreads, Godot 4, threaded LÖVE and .NET builds) need
 * SharedArrayBuffer, which browsers only enable on a "cross-origin isolated" page: one served
 * with Cross-Origin-Opener-Policy and Cross-Origin-Embedder-Policy headers. Static hosts such as
 * GitHub Pages cannot set headers, so this worker adds them.
 *
 * It only does so for page loads whose URL carries ?coi=1, which QuantiLoader uses when it
 * starts a game that needs threads. Every other visit is left exactly as the server sent it,
 * so external cover images and the like keep working normally.
 *
 * Keep this file next to index.html. It has no effect when Quantiverse is opened from disk
 * (file://), where service workers do not run.
 */
self.addEventListener("install", () => self.skipWaiting());
self.addEventListener("activate", (e) => e.waitUntil(self.clients.claim()));

self.addEventListener("fetch", (e) => {
  const req = e.request;
  if (req.mode !== "navigate") return;
  let url;
  try { url = new URL(req.url); } catch (_) { return; }
  if (url.origin !== self.location.origin || url.searchParams.get("coi") !== "1") return;
  e.respondWith(fetch(req).then((res) => {
    if (res.status === 0) return res;
    const headers = new Headers(res.headers);
    headers.set("Cross-Origin-Opener-Policy", "same-origin");
    headers.set("Cross-Origin-Embedder-Policy", "require-corp");
    headers.set("Cross-Origin-Resource-Policy", "same-origin");
    return new Response(res.body, { status: res.status, statusText: res.statusText, headers });
  }));
});
