(s.waitForBoot{ fork{
	//Make groups
	s.sendMsg(\g_new, 300);
	10.do{|ix| s.sendMsg(\g_new, 301+ix, 3, 300+ix)};
	//Load Sample as Source
	s.sendMsg(\b_allocRead, 0, "/home/ddmi/Documents/the_ocean-master/samples/LZ_OceanRiff_Mono.aif" );
	//Synth Defs
	////Play Sample
	SynthDef(\playsamp, {
		arg obs, pathnum, trig=1, loop=1;
		var sample;
		sample = PlayBuf.ar(1, pathnum, 1, trig, 0, loop);
		Out.ar(obs, sample);
	}).add;
	////Live Input
	SynthDef(\micin,{
		arg inch=0, obs, gate=1;
		var sig, env, amp;
		amp = \amp.kr(0.0, 0.01).dbamp;
		env = EnvGen.ar(Env.asr(0.01, 1, 0.1, -4), gate);
		sig = SoundIn.ar(inch);
		Out.ar(obs, sig*env*amp);
	}).add;
	//FXS
	////Reverb
	SynthDef(\verb1,{
		arg ibs, obs, gate=1,
		t60=1, damp=0, sz=1, diff=0.707;
		var sig, env, amp, src;
		amp = \amp.kr(0.0, 0.01).dbamp;
		env = EnvGen.ar(Env.asr(0.01, 1, 0.1, -4), gate);
		src = In.ar(ibs);
		sig = JPverb.ar(src, t60, damp, sz, diff);
		Out.ar(obs, sig*env*amp);
	}).add;

	0.3.wait;


//Start PlaySamp & MicIn Synths
	s.sendMsg( \s_new, \playsamp, 3000, 0, 301, \pathnum, 0, \obs, 50);
	s.sendMsg(\s_new, \micin, 3010, 0, 301, \inch, 0, \obs, 52);

}})

//listen to sample out 0
s.sendMsg(\n_set, 3000, \obs, 0);
s.sendMsg(\n_set, 3000, \obs, 50);
//listen to mic out 0
s.sendMsg(\n_set, 3010, \obs, 0);
s.sendMsg(\n_set, 3000, \obs, 52);

//Process Sample with Reverb
s.sendMsg(\s_new, \verb1, 3020, 0, 302, \ibs, 50, \obs, 0);
s.sendMsg(\n_set, 3020, \t60, 7.7, \damp, 0, \sz, 8.5, \diff, 0.9, \ibs, 52);
s.sendMsg(\n_free, 3020);



a.free;
s.sendMsg(\n_free, 3000);
server command reference
s.queryAllNodes

/*
LEGEND
Groups @ Nodes 300-310
Sample @ Node 3000
Mic @ Node 3010
Sample @ Buffer 0
Sample out private audio bus 50
mic out private audio bus 52

*/