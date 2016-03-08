SerialPort.listDevices
~ino = ArduinoSMS("/dev/ttyUSB0", 9600);
~kbs = {Bus.control(s)}!50; //short hand for array of busses
~ma = [ [0,1023,0.0,1.0], [0,1023,150,10000], [ 0,1,0,1 ], [ 0.0,1.0,0.0,1.0 ] ];
(
~ino.action = {
	arg msg;
	var sm = msg.split($:);

	//Pot0 - the if statement represents 1 sensor
	if( sm[0] == "pot0", { //which sensor?
		var val = sm[1].asFloat.linlin( ~ma[0][0], ~ma[0][1],  ~ma[0][2],  ~ma[0][3] );
		~kbs[0].setSynchronous(val);
	} );

	//Pot1
	if( sm[0] == "pot1", { //which sensor?
		var val = sm[1].asFloat.linlin( ~ma[1][0], ~ma[1][1],  ~ma[1][2],  ~ma[1][3]);
		~kbs[1].setSynchronous(val);
	} );

	//Button01 momentary
	if( sm[0] == "b0", {
		var val = sm[1].asFloat.linlin( ~ma[2][0], ~ma[2][1],  ~ma[2][2],  ~ma[2][3]);
		~kbs[2].setSynchronous(val);
	} );

	//Button01 toggle
	if( sm[0] == "bt", {
		var val = sm[1].asFloat.linlin( ~ma[3][0], ~ma[3][1],  ~ma[3][2],  ~ma[3][3]);
		//sm[1].postln;
		//	var val = sm[1].asInteger;
		~kbs[2].setSynchronous(val);
		//val.postln;
	} );

};
)

//SynthBass
~ma = [ [0, 1023,0.6, 1.4], [0, 1023, 300, 15000.0] ];
~mt.map(\rq1, ~kbs[0]);
~mt.map(\ffrq1, ~kbs[1]);

//snh
~ma = [ [0, 1023, 0.6, 1.4], [0, 1023, 0.1,7.0], [ 0,1,0,1 ]  ];
~mt.map(\res, ~kbs[0]);
~mt.map(\rel, ~kbs[1]);
~mt.set(\rel, 7.5);
~mt.set(\sfreq, 9);
~mt.map(\amp, ~kbs[1]);
~mt.map(\trig, ~kbs[2]);
~mt.set(\amp, 1);

arg atk=0.01, rel=0.5, crv= -2,trig=0, sfreq=7.5,
dt1= -7, oamp1=0.35, oamp2=0.35, oamp3=0.2, oamp4=0.1,
wtbuf, offset=0.4, res=1.2, pan=1, pitch=60;


~ino.close
~kbs[2].get
s.meter
