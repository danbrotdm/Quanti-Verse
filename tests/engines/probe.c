#include <stdio.h>
#include <string.h>
#include <emscripten.h>
#ifdef THREADS
#include <pthread.h>
static char color[32];
static void *worker(void *arg) { FILE *f = fopen("/data/color.txt", "r"); fgets(color, sizeof color, f); fclose(f); return 0; }
#endif
int main(void) {
  char c[32] = "#ff0000";   /* red = the data file was not read */
#ifdef THREADS
  pthread_t t; pthread_create(&t, 0, worker, 0); pthread_join(t, 0); strcpy(c, color);
#else
  FILE *f = fopen("/data/color.txt", "r"); if (f) { fgets(c, sizeof c, f); fclose(f); }
#endif
  c[strcspn(c, "\r\n")] = 0;
  EM_ASM({ var cv = document.getElementById('canvas') || document.body.appendChild(document.createElement('canvas'));
           cv.width = 400; cv.height = 300; cv.style.cssText = 'position:fixed;inset:0;width:100%;height:100%';
           var x = cv.getContext('2d'); x.fillStyle = UTF8ToString($0); x.fillRect(0, 0, 400, 300); document.title = 'probe ' + UTF8ToString($0); }, c);
  return 0;
}
