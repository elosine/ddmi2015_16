(
//Groups
~g0 = Group.new(s);
~g1 = Group.after(~g0);
//Busses
~b0 = Bus.audio(s);
//Synth Defs
SynthDef( \micin, {
	arg micch=0, obs;
	var source;
	source = SoundIn.ar(micch);
	Out.ar(obs, source);
} ).add;
SynthDef(\router, {
	arg ibs, obs;
	var source;
	source = In.ar(ibs);
	Out.ar(obs, source);
}).add;
SynthDef(\gh, {
	arg ibs, obs, del=2, damp=0, sz=1, diff=0.707, fb=0.9;
	var source, sig;
	source = In.ar(ibs);
	sig = Greyhole.ar( source, del, damp, sz, diff, fb);
	//sig = FreeVerb.ar();
	Out.ar(obs, sig);
}).add;
SynthDef(\m2s, {
	arg ibs, obs;
	var source, ch2;
	source = In.ar(ibs);
	ch2 = DelayC.ar(source, 0.2, 0.25);
	Out.ar( 0, [source, ch2] );
}).add;
SynthDef(\les, {
	arg ibs, obs, freq=0.5;
	var source, sig, lfo;
	lfo = SinOsc.kr(freq);
	source = In.ar(ibs);
	sig = Pan2.ar(source, lfo);
	Out.ar( 0, sig);
}).add;

)

a = Synth( \micin, [ \micch, 0, \obs, ~b0 ], ~g0 );
b = Synth( \router, [\ibs, ~b0, \obs, 0], ~g1 );
c = Synth( \gh, [\ibs, ~b0, \obs, 0], ~g1 );
d = Synth( \m2s, [\ibs, ~b0, \obs, 0], ~g1 );
e = Synth( \les, [\ibs, ~b0, \obs, 0], ~g1 );
e.set(\freq, 14);
c.set(\damp, 0.3, \fb, 0.1, \del, 0.1);
b.set(\obs, 1);]
b.free;
c.free;
d.free;

s.queryAllNodes;

s.meter;
















s.queryAllNodes;