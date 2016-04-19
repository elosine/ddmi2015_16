//Template
//Features: in from bus; out to a bus; has envelope
SynthDef( \template, {
	arg ibs, obs, atk=0.01, rel=0.1, crv= -4, gate=1;
	var env, src, sig, amp;
	amp = \amp.kr(1.0, 0.01);
	env = EnvGen.ar(Env.asr(atk, 1, rel, crv), gate);
	src = In.ar(ibs);
	sig = //FX.ar(src); put fx here
	Out.ar(obs, sig*amp*env);
}).add;
//general delay effect
SynthDef( \gde, {
	arg ibs, obs, atk=0.01, rel=0.1, crv= -4, gate=1, del=0.1;
	var env, src, sig, amp;
	amp = \amp.kr(1.0, 0.01);
	env = EnvGen.ar(Env.asr(atk, 1, rel, crv), gate);
	src = In.ar(ibs);
	sig = DelayL.ar(src, 10.0, del);
	sig = Mix.ar([src, sig]);
	Out.ar(obs, sig*amp*env);
}).add;

//Flanger
SynthDef( \flanger, {
	arg ibs, obs, atk=0.01, rel=0.1, crv= -4, gate=1,
	lfreq=0.5, dlo=0.0, dhi=0.1;
	var env, src, sig, amp, lfo;
	lfo = SinOsc.kr(lfreq).range(dlo, dhi);
	amp = \amp.kr(1.0, 0.01);
	env = EnvGen.ar(Env.asr(atk, 1, rel, crv), gate);
	src = In.ar(ibs);
	sig = DelayL.ar(src, 10.0, lfo);
	sig = Mix.ar([src, sig]);
	Out.ar(obs, sig*amp*env);
}).add;//Flanger

SynthDef( \comb, {
	arg ibs, obs, atk=0.01, rel=0.1, crv= -4, gate=1,
	lfreq=0.5, dlo=0.0, dhi=0.1, del=0.2;
	var env, src, sig, amp, lfo;
	lfo = SinOsc.kr(lfreq).range(dlo, dhi);
	amp = \amp.kr(1.0, 0.01);
	env = EnvGen.ar(Env.asr(atk, 1, rel, crv), gate);
	src = In.ar(ibs);
	sig = CombC.ar(src, 10.0, del);
	//sig = Mix.ar([src, sig]);
	Out.ar(obs, sig*amp*env);
}).add;

SynthDef( \mcomb, {
	arg ibs, obs, atk=0.01, rel=0.1, crv= -4, gate=1,
	lfreq=0.1, dlo=0.0, dhi=0.03, del=0.2;
	var env, src, sig, amp, lfo;
	lfo = SinOsc.kr(lfreq).range(dlo, dhi);
	amp = \amp.kr(1.0, 0.01);
	env = EnvGen.ar(Env.asr(atk, 1, rel, crv), gate);
	src = In.ar(ibs);
	sig = CombC.ar(src, 10.0, lfo);
	//sig = Mix.ar([src, sig]);
	Out.ar(obs, sig*amp*env);
}).add;

SynthDef( \rmcomb, {
	arg ibs, obs, atk=0.01, rel=0.1, crv= -4, gate=1,
	rate=0.1, dlo=0.0, dhi=0.03;
	var env, src, sig, amp, rdel, trig;
	//trig = Dust.kr(rate);
	trig = Impulse.kr(rate);
	rdel = TRand.kr(dlo, dhi, trig);
	amp = \amp.kr(1.0, 0.01);
	env = EnvGen.ar(Env.asr(atk, 1, rel, crv), gate);
	src = In.ar(ibs);
	sig = CombC.ar(src, 10.0, rdel);
	Out.ar(obs, sig*amp*env);
}).add;

SynthDef( \chordcomb, {
	arg ibs, obs, atk=0.01, rel=0.1, crv= -4, gate=1,
	p1=60,p2=64,p3=67;
	var env, src, sig, amp, d1,d2,d3,s1,s2,s3;
	amp = \amp.kr(1.0, 0.01);
	d1 = 1.0/p1.midicps;
	d2 = 1.0/p2.midicps;
	d3 = 1.0/p3.midicps;
	env = EnvGen.ar(Env.asr(atk, 1, rel, crv), gate);
	src = In.ar(ibs);
	s1 = CombC.ar(src, 1.0, d1);
	s2 = CombC.ar(src, 1.0, d2);
	s3 = CombC.ar(src, 1.0, d3);
	sig = Mix.ar([s1,s2,s3]);
	Out.ar(obs, sig*amp*env);
}).add;

//flanger
s.sendMsg(\s_new, \flanger, 3301, 0, 304, \ibs, 50, \obs, 0); //start synth
s.sendMsg(\n_set, 3301, \lfreq, 0.05, \dlo, 0.001, \dhi, 0.01);
s.sendMsg(\n_free, 3301);

//comb
s.sendMsg(\s_new, \comb, 3302, 0, 304, \ibs, 50, \obs, 0); //start synth
s.sendMsg(\n_set, 3302, \del, 0.00227);
s.sendMsg(\n_free, 3302);

//mcomb
s.sendMsg(\s_new, \mcomb, 3303, 0, 304, \ibs, 50, \obs, 0); //start synth
s.sendMsg(\n_set, 3303, \lfreq, 0.01, \dlo, 0.001, \dhi, 0.03);
s.sendMsg(\n_free, 3303)
s.sendMsg(\n_free, 3303);

//rmcomb
s.sendMsg(\s_new, \rmcomb, 3304, 0, 304, \ibs, 50, \obs, 0);
s.sendMsg(\n_set, 3304, \rate, 1.6, \dlo, 0.001, \dhi, 0.03);
s.sendMsg(\n_free, 3304);
//frequency of comb is inverse of delay time 0.03 1/440 = 0.00227



//chordcomb
s.sendMsg(\s_new, \chordcomb, 3305, 0, 304, \ibs, 50, \obs, 0);
s.sendMsg(\n_set, 3305, \p1, 43, \p2, 50, \p3, 57, \amp, 0.3);
s.sendMsg(\n_set, 3305, \p1, 45, \p2, 59, \p3, 52, \amp, 0.3);
s.sendMsg(\n_free, 3305);




//rmcomb from grain
s.sendMsg(\s_new, \rmcomb, 3304, 0, 304, \ibs, 70, \obs, 0);
s.sendMsg(\n_set, 3304, \rate, 1.6, \dlo, 0.001, \dhi, 0.03);
s.sendMsg(\n_free, 3304);



//flanger
s.sendMsg(\s_new, \flanger, 3301, 0, 304, \ibs, 72, \obs, 0); //start synth
s.sendMsg(\n_set, 3301, \lfreq, 0.05, \dlo, 0.001, \dhi, 0.01, \amp, 0.5);
s.sendMsg(\n_free, 3301);

s.queryAllNodes
