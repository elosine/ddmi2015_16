(
SynthDef(\chippy, {
	arg pitch = 60, t_tr=1, dur=0.25,amp=1;
	var freq, sig, env, h1, h2;
	freq = pitch.midicps;
	h1 = TIRand.kr(2, 7, Impulse.kr(4));
	h2 = TIRand.kr(2, 7, Impulse.kr(4));
	env = EnvGen.ar( Env.perc(0.01, dur), t_tr );
	sig = AY.ar( AY.freqtotone(freq), AY.freqtotone(freq*h1), AY.freqtotone(freq*h2), 0.25,3,15,10,7);
	Out.ar(0, sig*env*amp);
}).add;
)
h = [2,3,4,5, 6];
a = Synth(\chippy, [\pitch, 60, \dur, 0.25, \t_tr, 1]);
a.set(\pitch, 60, \dur, 0.25, \t_tr, 1); //c
a.set(\pitch, 55, \dur, 0.25, \t_tr, 1); //g
a.set(\pitch, 52, \dur, 0.25, \t_tr, 1); //e
a.set(\pitch, 57, \dur, 0.25, \t_tr, 1);//a
a.set(\pitch, 59, \dur, 0.25, \t_tr, 1);//b
a.set(\pitch, 58, \dur, 0.25, \t_tr, 1);//a#
a.set(\pitch, 57, \dur, 0.25, \t_tr, 1);//a
a.set(\pitch, 55, \dur, 0.25, \t_tr, 1);//g
a.set(\pitch, 64, \dur, 0.25, \t_tr, 1);//e
a.set(\pitch, 67, \dur, 0.25, \t_tr, 1);//g
a.set(\pitch, 69, \dur, 0.25, \t_tr, 1);//a
a.set(\pitch, 65, \dur, 0.25, \t_tr, 1);//f
a.set(\pitch, 67, \dur, 0.25, \t_tr, 1);//g
a.set(\pitch, 64, \dur, 0.25, \t_tr, 1);//e
a.set(\pitch, 60, \dur, 0.25, \t_tr, 1);//c
a.set(\pitch, 62, \dur, 0.25, \t_tr, 1);//e
a.set(\pitch, 59, \dur, 0.25, \t_tr, 1);//b



(
SynthDef(\chippy_1, {
	arg pitch = 60, t_tr=1, dur=0.25,amp=1;
	var freq, sig, env, h1, h2;
	freq = pitch.midicps;
	h1 = TIRand.kr(2, 7, Impulse.kr(4));
	h2 = TIRand.kr(2, 7, Impulse.kr(4));
	env = EnvGen.ar( Env.perc(0.01, dur), t_tr, doneAction:2 );
	sig = AY.ar( AY.freqtotone(freq), AY.freqtotone(freq*h1), AY.freqtotone(freq*h2), 0.25,3,15,10,7);
	Out.ar(0, sig*env*amp);
}).add;
)

(
~bpm = 200;
~freq = ~bpm/60.0;
~tc = TempoClock(~freq);
 Pbind(
  \instrument, \chippy_1,
	\pitch,  Pseq([60, 55, \r, 52, \r, 57, 59, \r, 58, 57, 55, 64, 67, 69, 65, 67, \r, 64, 60, 62, 59], inf),
  \dur,  Pseq ([0.75, 0.5, 1, 1, 0.5, 1, 0.5, 0.5, 0.5, 1, 0.667, 0.667, 0.667, 1, 0.5, 0.5, 0.5, 1, 0.5, 0.5, 0.75], inf),
  \amp,  Pseq ([1,1,0, 1,0,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1,1], inf)

).play(~tc)
)