{DFM1.ar(In.ar(55), 64.midicps, 1.2, 0.85, 0)}.play
{DFM1.ar(Saw.ar(64.midicps), LFNoise0.kr(7.5).range(30 , 100).midicps, 1.2, 1, 0)}.play

(
~wt1 = Buffer.read(s, "/Users/jyang/GitHub/wavetablesynthesis/wavetables/FM - Complex Sine 135.wav");
~wt2 = Buffer.read(s, "/Users/jyang/GitHub/wavetablesynthesis/wavetables/FM Sine 3 4 1.wav");

SynthDef(\snh, {
	arg atk=0.01, rel=0.5, crv= -2,trig=1, sfreq=7.5,
	dt1= -7, oamp1=0.35, oamp2=0.35, oamp3=0.2, oamp4=0.1,
	wtbuf, offset=0.4, res=1.2, pan=1, pitch=60;
	var sig, amp, env;
	var osc1, osc2, osc3, osc4;
	var freq, freq2, sh;
	sh = LFNoise0.kr(sfreq);
	env = EnvGen.ar(Env.asr(atk, 1, rel, crv), trig);
	amp = \amp.kr(0.85, 0.03);
	freq = pitch.midicps;
	freq2 = (pitch+dt1).midicps;
	osc1 = Saw.ar(freq);
	osc2 = Saw.ar(freq2);
	osc3 = VOsc3.ar(wtbuf+offset, freq, freq+0.37, freq+0.43, 0.333333);
	osc4 = DFM1.ar(In.ar(55), freq, res);
	sig = Mix.ar([osc1*oamp1, osc2*oamp2, osc3*oamp3, osc4*oamp4]);
	sig = DFM1.ar(sig, sh.range(pitch+12, pitch+36).midicps, res);
	sig = Pan2.ar(sig, sh.range(-1, 1) );
	Out.ar(0, sig*amp*env);
}).add;

)
a = Synth(\snh, [\wtbuf, ~wt1]);
a.set(\res, 1.3, \sfreq, 7.5, \pitch, 48);


SynthDef("help-Pan2", {
	Out.ar( 0, Pan2.ar( PinkNoise.ar(0.4), FSinOsc.kr(2), 0.3 ) )
}).play;
