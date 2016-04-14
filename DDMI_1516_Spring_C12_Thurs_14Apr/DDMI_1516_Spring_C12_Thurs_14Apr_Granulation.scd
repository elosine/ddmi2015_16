
SerialPort.listDevices; //run this to get name of arduino device
(s.waitForBoot{ fork{
	//	~ino = ArduinoSMS("/dev/ttyUSB0", 9600);
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
	/*
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
	} );

	//Pot1
	if( sm[0] == "p1", { //which sensor?
	var val = sm[1].asFloat.linlin( ~ma[1][0], ~ma[1][1],  ~ma[1][2],  ~ma[1][3]);
	~kbs[1].setSynchronous(val);
	} );

	//Pot2
	if( sm[0] == "p2", { //which sensor?
	var val = sm[1].asFloat.linlin( ~ma[2][0], ~ma[2][1],  ~ma[2][2],  ~ma[2][3]);
	val.postln;
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
	s.sendMsg(\n_free, 3020);
	},
	1, {

	s.sendMsg(\s_new, \verb1, 3020, 0, 302, \ibs, 52, \obs, 0,  \damp, 0, \sz, 8.5);
	//pot 1 to diff
	~ma[0] = [0, 1023, 0.0, 1.0];
	s.sendMsg(\n_map, 3020, \diff, ~kbs[0]);

	//pot 2 to t60
	~ma[2] = [0, 1023, 0.03, 5.0];
	s.sendMsg(\n_map, 3020, \t60, ~kbs[2]);

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
	*/

	s.sendMsg(\b_allocRead, 100, "/home/ddmi/Documents/grainEnv/gEnv_hamming.aif");
	s.sendMsg(\b_allocRead, 101, "/home/ddmi/Documents/grainEnv/gEnv_tri.aif");
	s.sendMsg(\b_allocRead, 102, "/home/ddmi/Documents/grainEnv/gEnv_expodec.aif");
	s.sendMsg(\b_allocRead, 103, "/home/ddmi/Documents/grainEnv/gEnv_rexpodec.aif");
	s.sendMsg(\b_allocRead, 104, "/home/ddmi/Documents/grainEnv/gEnv_3stageLinear.aif");


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

//basic granulation
//creating a new synth w/node messaging
// \s_new, name of synthdef, node you want to assign it to, 'add to' tag, group you are adding it to, arg pairs: argname, value
s.sendMsg(\s_new, \basicgrain, 3100, 0, 303, \ibs, 50, \obs, 0, \atk, 0.01, \rel, 0.08, \crv, -1, \rate, 3);
s.sendMsg(\n_set, 3100, \rate, 3, \rel, 0.01, \sus, 0.0, \atk, 0.3);
s.sendMsg(\n_free, 3100);

//advanced granulation
s.sendMsg(\s_new, \gr2, 3200, 0, 303, \ibs, 50, \obs, 0, \atk, 0.01, \rel, 0.08, \crv, -1, \rate, 3, \envbuf, -1, \panrate, 0.5, \dur, 0.1);
s.sendMsg(\n_set, 3200, \rate, 6, \envbuf, 103, \panrate, 0.1, \dur, 0.1);
s.sendMsg(\n_free, 3200);


//Process Sample with Reverb
s.sendMsg(\s_new, \verb1, 3020, 0, 302, \ibs, 50, \obs, 0, \t60, 7.7, \damp, 0, \sz, 8.5, \diff, 0.9);
s.sendMsg(\n_set, 3020, \t60, 7.7, \damp, 0, \sz, 8.5, \diff, 0.9, \ibs, 52);
s.sendMsg(\n_free, 3020);

s.sendMsg(\n_set, 3020, \t60, 0.3);


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