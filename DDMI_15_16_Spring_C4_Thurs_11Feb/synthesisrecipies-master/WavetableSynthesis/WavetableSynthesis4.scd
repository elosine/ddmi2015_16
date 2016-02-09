
(
s.waitForBoot{
	fork{
		~wsb = SoundFile.collectIntoBuffers("/Users/jyang/GitHub/synthesisrecipies/WavetableSynthesis/ArchitectureWaveforms/*",s,);//Buffers to hold waveshapesfor shaper
		~ibufnum = ~wsb.size + 1; //Grabs a starting number to put in the algorithmically generated wavetables
		32.do{~wsb = ~wsb.add(Buffer.alloc(s, 2048))}; //Create empty buffers to store algorithmically generated wavetables
		//Clunky Function that will generate waveforms from the help file and load them into bufs
		~genvosc = {|ibufnum|
			var ar1, ar2;
			8.do{|i|
				var part, array;
				part = (i+1)**2;
				array = Array.fill(part, { arg j; ((part-j)/part).squared.round(0.001) });
				s.performList(\sendMsg, \b_gen, ibufnum+i, \sine1, 7, array);
			};
			8.do{|i|
				var array;
				array = Array.fill(i, 0) ++ [0.5, 1, 0.5];
				s.performList(\sendMsg, \b_gen, ibufnum+i+8, \sine1, 7, array);
			};
			8.do{|i|
				var a, n;
				n = (i+1)*8;
				a = Array.fill(n,0);
				(n>>1).do({ arg i; a.put(n.rand, 1) });
				s.performList(\sendMsg, \b_gen, ibufnum+i+16, \sine1, 7, a);
			};
			8.do{ |i|
				var a;
				n = (i+1)**2;
				a = Array.fill(n, { arg j; 1.0.rand2 });
				// fill table
				s.performList(\sendMsg, \b_gen, ibufnum+i+24, \sine1, 7, a);
			};
		};
		//Run function to add algorithmically generated wavetables to buffer array
		~genvosc.value(~ibufnum);

		//Use Mouse to see which wave you like and put that number into the \wavshp offset
		SynthDef(\waveshape_test, {
			arg pitch=60, buf, numbuf=32;
			var sig, freq, offset;
			offset = MouseX.kr(0.0, numbuf).poll;
			freq = pitch.midicps;
			sig = VOsc3.ar(buf+offset, freq+[0,1],freq+[0.37,1.1],freq+[0.43, -0.29], 0.333333);
			Out.ar(0, sig);
		}).add;
		SynthDef(\wavtab, {
			arg pitch=60, ibuf, offset=0.5;
			var sig, freq;
			freq = pitch.midicps;
			sig = VOsc3.ar(ibuf+offset, freq+[0,1],freq+[0.37,1.1],freq+[0.43, -0.29], 0.333333);
			Out.ar(0, sig);
		}).add;
	}//end fork
}//end s.waitForBoot
)
a = Synth(\waveshape_test, [\buf, ~wsb[0].bufnum, \numbuf, ~wsb.size]);
a.free;
~wsb[59];
~wsb[55];
b = Buffer.read(s, "/Users/jyang/GitHub/synthesisrecipies/WavetableSynthesis/ArchitectureWaveforms/Bandlimited Saw 1024 Partials.wav");
c = Buffer.read(s, );
d = Synth(\wavtab, [\ibuf, b.bufnum]);

32.do{|ix| ~wsb[ix+60].write(
	"/Users/jyang/GitHub/synthesisrecipies/WavetableSynthesis/GeneratedWaveforms/WT"++ix++".aif");}
