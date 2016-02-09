SerialPort.listDevices
(
~ino = ArduinoSMS("/dev/ttyACM0", 9600);
~kbs = {Bus.control(s)}!50;
~mapings = [ [0, 1023, 0.0, 1.0] ]
)
(
~ino.action = {
	arg msg;
	var sm = msg.split($:);
	var num=0;
	//pot0//////////////////////////////////////////////////
	if( sm[0] == "pot0", {
		var val = sm[1].asFloat.linlin( ~mapings[num][0], ~mapings[num][1], ~mapings[num][2], ~mapings[num][3] );
		~kbs[num].setSynchronous(val);
	} );
};
)

