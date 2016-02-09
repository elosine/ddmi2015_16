(
SynthDef(\pad, {
	arg atk=0.3, dur=3, rel=0.5,gate=1, crv = -2,
	lffreq1=2, lffreq2=2, lf1lo=0.14, lf1hi=0.20,
	lf2lo=0.74, lf2hi=0.8, detune1= -0.06, detune2 = 0.06, detune3 = -12.06,
	ffreq = 2500;
	var osc1,osc2, osc3;
	var freq1, freq2, freq3;
	var env, sus, sig, amp, pitch, sig2;
	var lfo1, lfo2;
	pitch = \pitch.kr(64, 0.03);
	amp = \amp.kr(0.75, 0.03);
	lfo1 = SinOsc.kr(lffreq1).range(lf1lo, lf1hi);
	lfo2 = SinOsc.kr(lffreq2).range(lf2lo, lf2hi);
	sus = dur-atk;
	env = EnvGen.ar(Env.linen(atk, sus, rel, curve: crv),gate, doneAction:2);
	freq1 = (pitch+detune1).midicps;
	freq2 = (pitch+detune2).midicps;
	freq3 = (pitch+detune3).midicps;
	osc1 = Pulse.ar(freq1, lfo1);
	osc2 = Pulse.ar(freq2, lfo2);
	osc3 = Pulse.ar(freq3, lfo1);
	sig = Mix.ar([osc1*0.33333, osc2*0.33333, osc3*0.33333]);
	sig = DFM1.ar(sig, ffreq, type:0);
	sig2 = DelayC.ar(sig, 0.2, 0.05);

	Out.ar(0, [sig, sig2]*env*amp);
}).add;
)

a = Synth(\pad);
(
 Pbind(
  \instrument, \pad,
	\pitch,  Pseq([
		[52, 68, 71, 76 ],
		[52, 68, 71, 75 ],
		[52, 66, 69, 74 ],
		[52, 67, 72 ],
		[52, 64, 66, 71 ],
		[47, 63, 66, 71 ]
	], 1),
  \dur,  Pseq( [2, 2, 2, 2, 4, 4], 1 ),
 \amp,  Pseq( [ 0.7, 0.7, 0.7, 0.7, 0.7, 0.7 ], 1 )
 ).play
)

(
 Pbind(
  \instrument, \pad,
	\pitch,  Prand([
		[52, 68, 71, 76 ],
		[52, 68, 71, 75 ],
		[52, 66, 69, 74 ],
		[52, 67, 72 ],
		[52, 64, 66, 71 ],
		[47, 63, 66, 71 ]
	], inf),
  \dur,  Prand( [0.25], inf)

 ).play
)

(
 Pbind(
  \instrument, \pad,
	\pitch,  Prand([
		52, 68, 71, 76 , 74, 67, 72, 66
	], inf),
  \dur,  Prand( [0.051], inf)

 ).play
)
