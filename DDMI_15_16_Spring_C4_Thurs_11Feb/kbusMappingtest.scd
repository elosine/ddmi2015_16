SerialPort.listDevices
(
~ino = ArduinoSMS("/dev/ttyACM0", 9600);
~kbs = {Bus.control(s)}!50;
~mp = [ [0, 1023,150, 10000], [0, 1023,0.0, 0.4], [0, 1,0, 1] ];
)
(
~ino.action = {
	arg msg;


	var sm = msg.split($:);

	//pot0/////////////////////////////////////////////////////////////////////////////////
	if( sm[0] == "pot0", {
		var num=0;
		var val = sm[1].asFloat.linlin( ~mp[num][0], ~mp[num][1], ~mp[num][2], ~mp[num][3] );
		~kbs[num].setSynchronous(val);
	});
	//end pot0 /////////////////////////////////////////////////////////////////////////////

	//pot1/////////////////////////////////////////////////////////////////////////////////
	if( sm[0] == "pot1", {
		var num=1;
		var val = sm[1].asFloat.linlin( ~mp[num][0], ~mp[num][1], ~mp[num][2], ~mp[num][3] );
		~kbs[num].setSynchronous(val);
	});
	//end pot1 /////////////////////////////////////////////////////////////////////////////

		//b1 - momentary ///////////////////////////////////////////////////////////////////////
			if( sm[0] == "b0", {
				var num=2;
				var val = sm[1].asFloat.linlin( ~mp[num][0], ~mp[num][1], ~mp[num][2], ~mp[num][3] );
		~kbs[num].setSynchronous(val);
			});
			//b1 - momentary ///////////////////////////////////////////////////////////////////////

};
)

~kbs[2].get

