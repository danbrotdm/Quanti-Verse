/* Neverball's web build calls into a `Neverball` object that its own launcher page provides
 * (audio through Web Audio, quit). This is the part of it the game needs, adapted from
 * js/index.html in the Neverball repository (GPL-2.0). */
var Neverball = {
  audioContext: null, audioSoundSink: null, audioMusicSink: null,
  audioMusicFile: null, audioMusicSourceNode: null, audioMusicGainNode: null, audioCanPlayOgg: true,
  quit: function () {}, refreshReplays: function () {},
  audioInit: function () {
    this.audioContext = new AudioContext({ sampleRate: 44100.0 });
    this.audioSoundSink = new GainNode(this.audioContext);
    this.audioMusicSink = new GainNode(this.audioContext);
    this.audioSoundSink.connect(this.audioContext.destination);
    this.audioMusicSink.connect(this.audioContext.destination);
    this.audioCanPlayOgg = (new Audio()).canPlayType('audio/ogg') !== '';
    var ctx = this.audioContext;
    function resume() { if (ctx.state === 'suspended') ctx.resume(); }
    addEventListener('pointerdown', resume, true); addEventListener('keydown', resume, true);
  },
  audioVolume: function (s, m) {
    if (!this.audioContext) return;
    this.audioSoundSink.gain.setValueAtTime(s, this.audioContext.currentTime);
    this.audioMusicSink.gain.setValueAtTime(m, this.audioContext.currentTime);
  },
  audioQuit: function () {
    if (this.audioContext) this.audioContext.close();
    this.audioContext = this.audioSoundSink = this.audioMusicSink = null;
    this.audioMusicFile = this.audioMusicSourceNode = this.audioMusicGainNode = null;
  },
  audioPlay: async function (fileName, fileData, a) {
    var ctx = this.audioContext; if (!ctx || !this.audioSoundSink) return;
    var buf = await ctx.decodeAudioData(fileData); if (!buf) return;
    var src = new AudioBufferSourceNode(ctx, { buffer: buf }), gain = new GainNode(ctx, { gain: a });
    src.onended = function () { gain.disconnect(); };
    src.connect(gain); gain.connect(this.audioSoundSink); src.start();
  },
  audioMusicFadeTo: async function (fileName, fileData, t) {
    if (!this.audioContext) return;
    if (this.audioMusicFile && fileName === this.audioMusicFile) { this.audioMusicFadeIn(t); return; }
    this.audioMusicFadeOut(t);
    if (this.audioMusicSourceNode) { var old = this.audioMusicSourceNode.mediaElement; setTimeout(function () { old.pause(); }, t * 1000); }
    var url = URL.createObjectURL(new Blob([fileData], { type: this.audioCanPlayOgg ? 'audio/ogg' : 'audio/mp3' }));
    var el = new Audio(url); el.loop = true;
    var src = new MediaElementAudioSourceNode(this.audioContext, { mediaElement: el });
    var gain = new GainNode(this.audioContext, { gain: 0.0 });
    this.audioMusicFile = fileName; this.audioMusicSourceNode = src; this.audioMusicGainNode = gain;
    gain.gain.setValueAtTime(0, this.audioContext.currentTime);
    gain.gain.linearRampToValueAtTime(1.0, this.audioContext.currentTime + t);
    src.connect(gain); gain.connect(this.audioMusicSink);
    el.play().catch(function () {
      function go() { el.play(); removeEventListener('pointerdown', go, true); removeEventListener('keydown', go, true); }
      addEventListener('pointerdown', go, true); addEventListener('keydown', go, true);
    });
  },
  audioMusicFadeIn: function (t) {
    var g = this.audioMusicGainNode; if (!g) return;
    g.gain.setValueAtTime(g.gain.value, this.audioContext.currentTime);
    g.gain.linearRampToValueAtTime(1.0, this.audioContext.currentTime + t);
  },
  audioMusicFadeOut: function (t) {
    var g = this.audioMusicGainNode; if (!g) return;
    g.gain.setValueAtTime(g.gain.value, this.audioContext.currentTime);
    g.gain.linearRampToValueAtTime(0.0, this.audioContext.currentTime + t);
  },
  audioMusicStop: function () { if (this.audioMusicSourceNode) this.audioMusicSourceNode.mediaElement.pause(); }
};
