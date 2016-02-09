{DFM1.ar(In.ar(55), 64.midicps, 1.2, 0.85, 0)}.play
{DFM1.ar(Saw.ar(64.midicps), LFNoise0.kr(7.5).range(30 , 100).midicps, 0.999, 1.2, 0)}.play

(
~wt1 = Buffer.read(s, "/Users/jyang/GitHub/wavetablesynthesis/wavetables/FM - Complex Sine 135.wav");
~wt2 = Buffer.read(s, "/Users/jyang/GitHub/wavetablesynthesis/wavetables/FM Sine 3 4 1.wav");

SynthDef(\snh, {
	arg atk=0.01, rel=0.1, crv= -2,trig=1,
	dt1= -7, oamp1=0.35, oamp2=0.35, oamp3=0.2, oamp4=0.1,
	wtbuf, offset=0.4, res=1.2;
	var sig, pitch, amp, env;
	var osc1, osc2, osc3, osc4;
	var freq, freq2;
	env = EnvGen.ar(Env.asr(atk, 1, rel, crv), trig);
	pitch = \pitch.kr(64, 0.03);
	amp = \amp.kr(0.85, 0.03);
	freq = pitch.midicps;
	freq2 = (pitch+dt1).midicps;
	osc1 = Saw.ar(freq);
	osc2 = Saw.ar(freq2);
	osc3 = VOsc3.ar(wtbuf+offset, freq, freq+0.37, freq+0.43, 0.333333);
	osc4 = DFM1.ar(In.ar(55), freq, res);
	sig = Mix.ar([osc1*oamp1, osc2*oamp2, osc3*oamp3, osc4*oamp4]);
	Out.ar(0, sig);

}).add;

)

a = Synth(\snh, [\wtbuf, ~wt1]);



