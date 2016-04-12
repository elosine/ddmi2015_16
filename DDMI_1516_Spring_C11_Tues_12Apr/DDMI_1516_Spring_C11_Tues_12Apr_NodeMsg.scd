//Make groups using osc messaging
g = Group.new(s);
s.sendMsg(\g_new, 300);
~g2 = Group.after(g);
s.sendMsg(\g_new, 301, 3, 300);
s.sendMsg(\g_new, 302, 3, 301);
s.sendMsg(\g_new, 303, 3, 302);
//for loop short cut for making 10 groups after group at node 300
10.do{|ix| s.sendMsg(\g_new, 301+ix, 3, 300+ix)};

//Node messaging for Buffers
b = Buffer.read(s, "/home/ddmi/Documents/the_ocean-master/samples/LZ_OceanRiff_Mono.aif" );
s.sendMsg(\b_allocRead, 0, "/home/ddmi/Documents/the_ocean-master/samples/LZ_OceanRiff_Mono.aif" );

SynthDef(\playsamp, {
	arg obs, pathnum, trig=1, loop=1;
	var sample;
	sample = PlayBuf.ar(1, pathnum, 1, trig, 0, loop);
	Out.ar(obs, sample);
}).add;

a = Synth( \playsamp, [\pathnum, 0], group );
//osc messaging for new synth
//// \s_new, synthdef name, node, node placement code, group, args
s.sendMsg( \s_new, \playsamp, 3000, 0, 301, \pathnum, 0);
a.free;
s.sendMsg(\n_free, 3000);
server command reference
s.queryAllNodes