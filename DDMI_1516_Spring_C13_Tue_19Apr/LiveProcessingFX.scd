//Template
//Features: in from bus; out to a bus; has envelope
SynthDef( \template, {
	arg ibs, obs, atk=0.01, rel=0.1, crv= -4, gate=1;
	var env, src, sig, amp;
	amp = \amp.kr(1.0, 0.01);
	env = EnvGen.ar(Env.asr(atk, 1, rel, crv), gate);
	src = In.ar(ibs);
	sig = //FX.ar(src); put fx here
	Out.ar(obs, sig);
}).add;