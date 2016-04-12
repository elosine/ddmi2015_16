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

	wait.0.3;

//Start PlaySamp & MicIn Synths
	s.sendMsg( \s_new, \playsamp, 3000, 0, 301, \pathnum, 0, \obs, 50);
	s.sendMsg(\s_new, \micin, 3010, 0, 301, \inch, 0, \obs, 52);

}})


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