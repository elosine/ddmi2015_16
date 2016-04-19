
SerialPort.listDevices; //run this to get name of arduino device
(s.waitForBoot{ fork{
	~ino = ArduinoSMS("/dev/ttyACM0", 9600);
	~path = "/home/ddmi/Documents/DDMI_1516_Spring_C13_Tue_19Apr/";
	////Control Busses
	~kbs = {Bus.control(s)}!50;
	////Mapping
	~ma = [
		[0,1023,0.0,1.0], //mapping for Pot0
		[0,1023,150,10000], //mapping for Pot1
		[ 0,1023,0.0,1.0 ],
		[ 0.0,1.0,0.0,1.0 ],
		[ 0,1,0,1 ],
		[ 0.0,1.0,0.0,1.0 ],
		[200,800, 0.5, 20.0 ],
		[200,800, 0.0, 1.2 ]
	];

	0.1.wait;

	//ARDUINO
	~ino.action = {
		arg msg;
		var sm = msg.split($:);
		//////////////////////////////////////////////////////////////////////////////
		//
		// Pot0 - the if statement represents 1 sensor ////////////////////////////////
		//
		//////////////////////////////////////////////////////////////////////////////
		if( sm[0] == "p0", { //which sensor?
			var val = sm[1].asFloat.linlin( ~ma[0][0], ~ma[0][1],  ~ma[0][2],  ~ma[0][3] );
			~kbs[0].setSynchronous(val);
			val.postln;
		} );

		//Pot1
		if( sm[0] == "p1", { //which sensor?
			var val = sm[1].asFloat.linlin( ~ma[1][0], ~ma[1][1],  ~ma[1][2],  ~ma[1][3]);
			~kbs[1].setSynchronous(val);
		} );

		//Pot2
		if( sm[0] == "p2", { //which sensor?
			var val = sm[1].asFloat.linlin( ~ma[2][0], ~ma[2][1],  ~ma[2][2],  ~ma[2][3]);
			~kbs[2].setSynchronous(val);
		} );

		//Button0 momentary
		if( sm[0] == "b0", {
			//var val = sm[1].asFloat.linlin( ~ma[2][0], ~ma[2][1],  ~ma[2][2],  ~ma[2][3]);
			//~kbs[2].setSynchronous(val);
		} );

		//Button0 toggle //Preset Button
		if( sm[0] == "bt0", {
			var val = sm[1].asInteger;
			switch( val,
				0, {
				},
				1, {



				},
				2, {

				},
				3, {
				}

			);
		} );

		//Button01 momentary
		if( sm[0] == "b1", {
			var val = sm[1].asFloat.linlin( ~ma[4][0], ~ma[4][1],  ~ma[4][2],  ~ma[4][3]);
			~kbs[4].setSynchronous(val);
		} );


		//FSR0 raw
		if( sm[0] == "fsr0", {
			var val = sm[1].asFloat.linlin( ~ma[6][0], ~ma[6][1],  ~ma[6][2],  ~ma[6][3] );
			~kbs[6].setSynchronous(val);
		} );


		//FSR peak value 0
		if( sm[0] == "fsp0", {
			var val = sm[1].asFloat.linlin( ~ma[7][0], ~ma[7][1],  ~ma[7][2],  ~ma[7][3] );
			~kbs[7].setSynchronous(val);
		} );

	}; //end Arduino


	s.sendMsg(\b_allocRead, 100, ~path ++ "grainEnv/gEnv_hamming.aif");
	s.sendMsg(\b_allocRead, 101, ~path ++  "grainEnv/gEnv_tri.aif");
	s.sendMsg(\b_allocRead, 102, ~path ++  "grainEnv/gEnv_expodec.aif");
	s.sendMsg(\b_allocRead, 103, ~path ++  "grainEnv/gEnv_rexpodec.aif");
	s.sendMsg(\b_allocRead, 104, ~path ++  "grainEnv/gEnv_3stageLinear.aif");


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

	SynthDef(\basicgrain, {
		arg ibs, obs, atk=0.01, rel=0.08, crv= -1, rate=3, sus=0.1;
		var src, amp, env, trig;
		//trig = Impulse.ar(rate);
		trig = Dust.ar(rate);
		amp = \amp.kr(0.0, 0.01).dbamp;
		src = In.ar(ibs);
		//env = EnvGen.ar( Env.perc(atk, rel, 1, crv), trig );
		env = EnvGen.ar( Env.linen(atk, sus, rel, 1, crv), trig );
		Out.ar(obs, src*env*amp);
	}).add;

	SynthDef(\gr2, {
		arg ibs, obs, atk=0.01, rel=0.08, crv= -1, rate=3, gate=1,
		envbuf= -1, panrate=0.5, dur=0.1;
		var src, amp, env, trig, sig, pan;
		//pan = SinOsc.kr(panrate); //leslie style panning
		//trig = Impulse.ar(rate);
		trig = Dust.ar(rate);
		pan = TRand.ar(-1, 1, trig);
		amp = \amp.kr(0.0, 0.01).dbamp;
		src = In.ar(ibs);
		sig = GrainIn.ar(2, trig, dur, src, pan, envbuf);
		env = EnvGen.ar( Env.asr(atk, 1, rel, crv), gate );
		Out.ar(obs, sig*env);
	}).add;
	/*
SynthDef( \template, {
	arg ibs, obs, atk=0.01, rel=0.1, crv= -4, gate=1;
	var env, src, sig, amp;
	amp = \amp.kr(1.0, 0.01);
	env = EnvGen.ar(Env.asr(atk, 1, rel, crv), gate);
	src = In.ar(ibs);
	sig = //FX.ar(src); put fx here
	Out.ar(obs, sig*amp*env);
}).add;
	*/
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
s.sendMsg(\n_set, 3010, \obs, 52);

//delay fx
s.sendMsg(\s_new, \gde, 3300, 0, 304, \ibs, 50, \obs, 0); //start synth
//change mapping
~ma[0] = [0,1023,0.0,3.0];
//map del argument of synth to pot0 (control bus 0)
s.sendMsg(\n_map, 3300, \del, ~kbs[0]);
s.sendMsg(\n_set, 3300, \del, 0.0011);
s.sendMsg(\n_free, 3300);



//basic granulation
//creating a new synth w/node messaging
// \s_new, name of synthdef, node you want to assign it to, 'add to' tag, group you are adding it to, arg pairs: argname, value
s.sendMsg(\s_new, \basicgrain, 3100, 0, 303, \ibs, 50, \obs, 0, \atk, 0.01, \rel, 0.08, \crv, -1, \rate, 3);
s.sendMsg(\n_set, 3100, \rate, 3, \rel, 0.01, \sus, 0.0, \atk, 0.3);
s.sendMsg(\n_free, 3100);

//advanced granulation
s.sendMsg(\s_new, \gr2, 3200, 0, 303, \ibs, 50, \obs, 0, \atk, 0.01, \rel, 0.08, \crv, -1, \rate, 3, \envbuf, -1, \panrate, 0.5, \dur, 0.1);
s.sendMsg(\n_set, 3200, \rate, 6, \envbuf, 103, \panrate, 0.1, \dur, 0.1, \obs, 70);
s.sendMsg(\n_free, 3200);

//grain 2
s.sendMsg(\s_new, \gr2, 3230, 0, 303, \ibs, 50, \obs, 72, \atk, 0.01, \rel, 0.08, \crv, -1, \rate, 11, \envbuf, 104, \panrate, 0.5, \dur, 0.1);
s.sendMsg(\n_set, 3230, \rate, 2, \envbuf, 102, \panrate, 0.1, \dur, 0.1, \obs, 70);
s.sendMsg(\n_free, 3230);


//Process Sample with Reverb
s.sendMsg(\s_new, \verb1, 3020, 0, 302, \ibs, 50, \obs, 0, \t60, 7.7, \damp, 0, \sz, 8.5, \diff, 0.9);
s.sendMsg(\n_set, 3020, \t60, 7.7, \damp, 0, \sz, 8.5, \diff, 0.9, \ibs, 52);
s.sendMsg(\n_free, 3020);

s.sendMsg(\n_set, 3020, \t60, 0.3);

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