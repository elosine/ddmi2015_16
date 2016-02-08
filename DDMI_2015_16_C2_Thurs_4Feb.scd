(
//Groups
~g0 = Group.new(s);
~g1 = Group.after(~g0);
~g2 = Group.after(~g1);
//Busses
~b0 = Bus.audio(s);
~b1 = Bus.audio(s);
~b2 = Bus.audio(s);
//Synth Defs

//Basic FX Template
/*
SynthDef(\fxtemplate, {
	arg ibs, obs, amp=1, drywet=1,
	atk=0.01, rel=0.1, crv= -3, gate=1;
	var source, sig, env, mix;
	env = EnvGen.ar( Env.asr(atk, 1, rel, crv), gate );
	source = In.ar(ibs);
	sig = FX(source); //Replace This Line
	mix = Mix.ar( [ ( source*(1-drywet) ), (sig*drywet)  ] );
	Out.ar(obs, mix*amp*env);
}).add;
*/

SynthDef(\bitcrush, {
	arg ibs, obs, amp=1, drywet=1,
	atk=0.01, rel=0.1, crv= -3, gate=1,
	sampr=44100, bit=16;
	var source, sig, env, mix;
	env = EnvGen.ar( Env.asr(atk, 1, rel, crv), gate );
	source = In.ar(ibs);
	sig = Decimator.ar(source, sampr, bit); //Replace This Line
	mix = Mix.ar( [ ( source*(1-drywet) ), (sig*drywet)  ] );
	Out.ar(obs, mix*amp*env);
}).add;


SynthDef(\reverb, {
	arg ibs, obs, amp=1, drywet=1,
	atk=0.01, rel=0.1, crv= -3, gate=1,
	del=0.2 /*(0-60)*/, damp=0/*(0-1)*/, sz=1/*(0.5-5)*/, diff=0.707/*(0-1)*/, fb=0.5/*(0-1)*/, md=0.1/*(0-1)*/, mf=1/*(0-10)*/;
	var source, sig, env, mix;
	env = EnvGen.ar( Env.asr(atk, 1, rel, crv), gate );
	source = In.ar(ibs);
	sig = Greyhole.ar( source, del, damp, sz, diff, fb, md, mf); //
	mix = Mix.ar( [ ( source*(1-drywet) ), (sig*drywet)  ] );
	Out.ar(obs, mix*amp*env);
}).add;



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

a = Synth( \micin, [ \micch, 0, \obs, ~b0 ], ~g0 ); //start mic to private bus
c = Synth(\bitcrush, [ \ibs, ~b0, \obs, 0, \bit, 4, \sampr, 5000], ~g1 );
c.set(\obs, ~b1);
c.set(\obs, 0);

b = Synth(\reverb, [ \ibs, ~b1, \obs, 0], ~g2 );
b.set(\ibs, ~b1, \obs, ~b2);

c.set(\bit, 4, \sampr, 5000);
c.free;
b = Synth(\reverb, [ \ibs, ~b0, \obs, 0], ~g1 );
b.set(\drywet, 1, \del, 0.3, \damp, 0.0, \sz, 0.5, \diff, 0.9, \fb, 0.3, \md, 0.1, \mf,1);

	arg ibs, obs, amp=1, drywet=1,
	atk=0.01, rel=0.1, crv= -3, gate=1,
	del=0.2 /*(0-60)*/, damp=0/*(0-1)*/, sz=1/*(0.5-5)*/, diff=0.707/*(0-1)*/, fb=0.5/*(0-1)*/, md=0.1/*(0-1)*/, mf=1/*(0-10)*/;

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

0-1
amp = 1
dry wet
dry*1 wet*0
dry*0 wet*1
dry*0.5 wet*0.5
w/d factor 0-1
dry*(1-wd) wet*wd
wd=0.2
dry*0.8 wet*0.2

Platform.userExtensionDir
















s.queryAllNodes;