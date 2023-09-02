//OSCdef.trace(true)
//OSCdef.trace(false)



(

var n;
var names, outputs, ipNames;
var names2, outputs2, ipNames2;
var verbose;

n = NetAddr("127.0.0.1", nil); // local machine

~recOSC= false;
verbose= false;
~ableton2oscOpen= true;

outputs= ["SR1", "SR2", "SR3", "SR4", "BRK", "RL1", "RL2"
/*, "RL3", "RL4", "RL5", "RL6", "RL7", "RL8"
*/];

outputs2= ["2_SR1", "2_SR2", "2_SR3", "2_SR4", "2_BRK", "2_RL1", "2_RL2"
/*, "RL3", "RL4", "RL5", "RL6", "RL7", "RL8"
*/];

/*
~ipDict= (
	\fatBot: ["172.16.3.177", 8888],  
	\circleBot: ["172.16.3.178", 8888],
	\updownBot: ["172.16.3.180", 8888],
	\headBot: ["172.16.3.179", 8888],
	\servo: ["172.16.3.200", 8888],
	\servoMouth: ["172.16.3.200", 8888],
	\relay8_1: ["172.16.3.200", 8888],
	\relay8_2: ["172.16.3.200", 8888],
	\relay8_3: ["172.16.3.200", 8888],
	\relay8_4: ["172.16.3.200", 8888],
	\relay8_5: ["172.16.3.200", 8888],
	\relay8_6: ["172.16.3.200", 8888],
	\relay8_7: ["172.16.3.200", 8888],
	\relay8_8: ["172.16.3.200", 8888],
	\wifi: ["172.16.1.6", 8888],
	\wifiMouth: ["172.16.1.6", 8888],
	\first: ["172.16.3.150", 8888]
	);
*/

ipNames= ~ipDict.keys.asArray.sort;

names= ();
outputs.do({|it|
	names.put(it, [nil, 64, true, nil, nil, ["172.16.3.150", 8888]]);
	// [(0)slider/buttn,   (1)last value,    (2)on/off,    (3)CheckBx,    (4)nil,    (5)ip]
});

names2= ();
outputs2.do({|it|
	names2.put(it, [nil, 64, true, nil, nil, ["172.16.3.150", 8888]]);
	// [(0)slider/buttn,   (1)last value,    (2)on/off,    (3)CheckBx,    (4)nil,    (5)ip]
});

w= Window("ableton2osc", Rect(0, 0, 220, 420));
w.view.decorator = FlowLayout(w.bounds);

StaticText(w, 218@20).string_("Ableton 2 OSC Relay").font_(Font("Arial", 20));

StaticText(w, 80@20).string_("Set All:");
PopUpMenu(w, 100@20).items_(ipNames)
.action_({|m| 
	names.keysValuesDo({|key, val|
		val[5]= ~ipDict[m.item];
		val[0].value= m.value;
		});
});
CheckBox(w, 20@20).value_(1)
.action_({|v| v.value.postln;
			if(v.value==true, {
				names.keysValuesDo({|key, val|
					OSCdef(("ableton"++key).asSymbol).enable;
					val[2]= 1;
					val[3].value_(true)
				});
				},{
				names.keysValuesDo({|key, val|
					OSCdef(("ableton"++key).asSymbol).disable;
					val[2]= 0;
					val[3].value_(false);
				});
				});
			});

outputs.do({|it|
		Button(w, Rect(0, 0, 80, 20))
		.states_([[it.asString, Color.black, Color.white]]);
		names[it][0]= PopUpMenu(w, 100@20).items_(ipNames)
		.action_({|m| names[it][5]= ~ipDict[m.item]});
		names[it][3]= CheckBox(w, 20@20).value_(names[it][2])
		.action_({|v|
			if(v.value==true, {
				OSCdef(("ableton"++it).asSymbol).enable;
				names[it][2]= true;
				},{
				OSCdef(("ableton"++it).asSymbol).disable;
				names[it][2]= false;
				});
			});
		OSCdef(("ableton"++it).asSymbol).enable;
		OSCdef(("ableton"++it).asSymbol, {|msg, time, addr, recvPort|
			var val;
			val= (msg[1]*127).floor(0.1);
			if(val != names[it][1], {
				NetAddr(names[it][5][0], names[it][5][1]).sendMsg(it++((val+3).asString));
				if (~recOSC, {
				NetAddr("localhost", NetAddr.langPort).sendMsg(names[it][5][0], it++((val+3).asString)); 
				 });

			names[it][1]= val;
			if(verbose, { (it++((val+3).asString)).postln; });
			});
			}, ("/"++(it.asString)).asSymbol, n);
	
});

outputs2.do({|it|
		Button(w, Rect(0, 0, 80, 20))
		.states_([[it.asString, Color.black, Color.white]]);
		names2[it][0]= PopUpMenu(w, 100@20).items_(ipNames)
		.action_({|m| names2[it][5]= ~ipDict[m.item]});
		names2[it][3]= CheckBox(w, 20@20).value_(names2[it][2])
		.action_({|v|
			if(v.value==true, {
				OSCdef(("ableton"++it).asSymbol).enable;
				names2[it][2]= true;
				},{
				OSCdef(("ableton"++it).asSymbol).disable;
				names2[it][2]= false;
				});
			});
		OSCdef(("ableton"++it).asSymbol).enable;
		OSCdef(("ableton"++it).asSymbol, {|msg, time, addr, recvPort|
			var val;
			val= (msg[1]*127).floor(0.1);
			if(val != names2[it][1], {
				NetAddr(names2[it][5][0], names2[it][5][1]).sendMsg((it.replace("2_"))++(val.asString));
				if (~recOSC, {
				NetAddr("localhost", NetAddr.langPort).sendMsg(names2[it][5][0], (it.replace("2_"))++(val.asString)); 
				 });

			names2[it][1]= val;
			if(verbose, { (it++(val.asString)).postln; });
			});
			}, ("/"++(it.asString)).asSymbol, n);
	
});

CheckBox(w, 80@20).value_(false).string_("print vals")
.action_({|v| 
	if(v.value==true, {verbose= true}, {verbose= false});
});

Button(w, 110@20).states_([["open max app", Color.black, Color.white]])
.action_({
//"open /Applications/joy2osc.app".unixCmd;
"open /Volumes/MEDIA/MaxPatches/joy2oscNEW/joy2oscAppXbox.maxpat".unixCmd;
});


w.onClose = {
	names.keysDo({|it|
		OSCdef(("ableton"++it).asSymbol).disable;
		OSCdef(("ableton"++it).asSymbol).free;
	});
	~ableton2oscOpen= false;
	};
	
w.front;
)



/*
NetAddr("172.16.1.6", 8888).sendMsg("SR1127");
NetAddr("172.16.1.6", 8888).sendMsg("SR195");

NetAddr("172.16.1.6", 8888).sendMsg("SR165");


NetAddr("172.16.1.6", 8888).sendMsg("SR258");
NetAddr("172.16.1.6", 8888).sendMsg("SR295");


NetAddr("172.16.3.150", 8888).sendMsg("SR13");
NetAddr("172.16.3.150", 8888).sendMsg("SR23");
NetAddr("172.16.3.150", 8888).sendMsg("SR33");
NetAddr("172.16.3.150", 8888).sendMsg("SR43");
NetAddr("172.16.3.150", 8888).sendMsg("SR53");

*/



