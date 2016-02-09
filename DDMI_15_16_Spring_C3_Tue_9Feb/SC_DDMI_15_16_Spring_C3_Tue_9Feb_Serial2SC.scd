Quark.gui
SerialPort.listDevices
~ino = ArduinoSMS("/dev/ttyACM0", 9600);
~kbs0 = Bus.control(s);
(
~ino.action = {
	arg msg;
	//msg.postln;
	var sm = msg.split($:);
	//sm.postln;
//	if( cond, {true}, {false} );
	if( sm[0] == "pot0", {
		var val = sm[1].asFloat.linlin(0, 1023, 0.0, 1.0);
		//sm[1].postln;
		~kbs0.setSynchronous(val);
	} );
};
)

SynthDef(\sin, {
	arg freq=300, amp=1;
	Out.ar(0, SinOsc.ar(freq)*amp);
}).add
a = Synth(\sin);
a.map(\amp, ~kbs0);
s.options.sampleRate = 44100;


~kbs0.get
s.meter

a = "fdsf:545454:fjfjfj:qwer";
b = a.split($:);
b[1]

Platform.classLibraryDir