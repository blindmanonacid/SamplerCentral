//OSCdef.trace(true)
//OSCdef.trace(false)



(
//var n,  robotIp= "172.16.1.6"; // wifi
//var n,  robotIp= "172.16.1.200"; //mini
//var n,  robotIp= "172.16.1.10"; //mini ethercard
var n,  robotIp= "172.16.1.150"; //1st head 
var names, outputs, ipNames;
var checkBoxes;
var verbose= false;
var servoMenus, botMenus, onOffButtons;
var saveDirectory, saveFiles, loadMenu, loadMenuItem;
var buffers, synths, midiFiles, midiPlayers, soundDrag, midiDrag;

s= Server.default;
n = NetAddr("127.0.0.1", nil); // local machine

~recOSC= false;
~joy2oscOpen= true;

outputs= ["SR1", "SR2", "SR3", "SR4", "SR5", "SR6", "RL1", "RL2", "RL3", "RL4", "RL5", "RL6", "RL7", "RL8"];

/*
~ipDict= (
	\fatBot: ["172.16.1.177", 8888],  
	\circleBot: ["172.16.1.178", 8888],
	\updownBot: ["172.16.1.180", 8888],
	\headBot: ["172.16.1.179", 8888],
	\servo: ["172.16.1.200", 8888],
	\servoMouth: ["172.16.1.200", 8888],
	\relay8_1: ["172.16.1.200", 8888],
	\relay8_2: ["172.16.1.200", 8888],
	\relay8_3: ["172.16.1.200", 8888],
	\relay8_4: ["172.16.1.200", 8888],
	\relay8_5: ["172.16.1.200", 8888],
	\relay8_6: ["172.16.1.200", 8888],
	\relay8_7: ["172.16.1.200", 8888],
	\relay8_8: ["172.16.1.200", 8888],
	\wifi: ["172.16.1.6", 8888],
	\wifiMouth: ["172.16.1.6", 8888],
	\first: ["172.16.1.150", 8888]
	);
*/

ipNames= ~ipDict.keys.asArray.sort;

names= ();
[\joyLX, \joyLY, \joyLB, \joyRX, \joyRY, \joyRB, \joyB1, \joyB2, \joyB3, \joyB4, \joyB5, \joyB6, \joyFPS, \joyL1, \joyL2, \joyR1, \joyR2, \joyArU, \joyArR, \joyArD, \joyArL].do({|it|
	names.put(it, [nil, 130, 100, 130, "SR1", ["172.16.1.150", 8888], nil, nil]);
	// [(0)slider/buttn,   (1)last value,    (2)on,    (3)off,    (4)servo,    (5)ip, (6)sound, (7)midi]
});

buffers= nil!names.size;
synths= nil!names.size;
midiFiles= nil!names.size;
midiPlayers= nil!names.size;

checkBoxes= nil!names.size;

servoMenus= nil!names.size;
botMenus= nil!names.size;
onOffButtons= [nil, nil]!names.size;
soundDrag= nil!names.size;
midiDrag= nil!names.size;

w= Window("joy2osc", Rect(0, 0, 545, 600));
w.view.decorator = FlowLayout(w.bounds);


StaticText(w, Rect(0, 0, 100, 20)).string_("Preset:");
saveDirectory= (String.scDir.dirname ++ "/Resources/JOY2OSCPRESETS/");
saveFiles= (saveDirectory+/+"*").standardizePath.pathMatch;

		loadMenu= PopUpMenu(w, 200@20) // -----
		.items_(saveFiles.collect({|it| it.basename}))
		.canFocus_(false)
		.background_(Color.white)
		.font_(Font("Helvetica", 10))
		.action_({|v|
			loadMenuItem= v.items.at(v.value);
		});
		
		//load preset
		Button(w, 20@20) // ------
		.states_([["L", Color.red, Color.black]])
		.canFocus_(false)
		.font_(Font("Helvetica", 10))
		.action_({
			var loadArray;
			if (loadMenuItem.isNil.not, { 
				loadArray= Object.readArchive(saveFiles[loadMenu.value]);
				names= loadArray.interpret;
				[\joyLX, \joyLY, \joyLB, \joyRX, \joyRY, \joyRB, \joyB1, \joyB2, \joyB3, \joyB4, \joyB5, \joyB6, \joyFPS, \joyL1, \joyL2, \joyR1, \joyR2, \joyArU, \joyArR, \joyArD, \joyArL].do({|it, i|
					servoMenus[i].value= outputs.indexOfEqual(names[it][4]);names[it][4].postln;
					botMenus[i].value= ipNames.indexOf(~ipDict.findKeyForValue(names[it][5]));					if(onOffButtons[i][0].isNil.not, {
						onOffButtons[i][0].value_(names[it][2]);
						onOffButtons[i][1].value_(names[it][3]);
						});
					if(names[it][6].isNil.not, {
						if(buffers[i].isNil.not, {buffers[i].free});
						buffers[i]= Buffer.read(s, View.currentDrag.value);
						soundDrag[i].string= (names[it][6].basename.removeExtension);
					});
					if(midiDrag[i].isNil.not, {
						midiDrag[i].string= (names[it][7]);
						midiFiles[i]= names[it][7];
						if(names[it][7].isNil.not, {
							midiDrag[i].string= (names[it][7].basename.removeExtension);
						});
					});
					});
			});
		});
		Button(w, 30@20)
		.states_([["qs"]])
		.canFocus_(false)
		.font_(Font("Helvetica", 12))
		.action_({ 
			names.asCompileString.writeArchive(saveDirectory+/+loadMenuItem);
		});
		Button(w, 20@20)
		.states_([["s"]])
		.canFocus_(false)
		.font_(Font("Helvetica", 12))
		.action_({
			//save preset
			var w, t, name, saveBut;
				w= Window("save", Rect(400, 400, 230, 100), border: false)
				.background_(Color.black)
				.alwaysOnTop_(true);
	
				t= TextView(w, Rect(10, 10, 210, 20))
				.focus(true)
				.keyDownAction_({|view, char, mod, uni, key|
					if(key == 36, { {saveBut.valueAction= 1}.defer; });
				});
				
				saveBut= Button(w, Rect(10, 40, 100, 40))
				.states_([["save"]])
				.action_({
					var values, path, stringSize;
					stringSize= t.string.size;
					if (stringSize > 0, {
						name= t.string;
						path= saveDirectory+/+(name);
						//this.save(path);
						//("saving this:"+properties[key][15]).postln;
						names.asCompileString.writeArchive(path);
						//currentSaveFile= path;
						saveFiles= (saveDirectory++"*").standardizePath.pathMatch;
						{loadMenu.items= saveFiles.collect({|it| it.basename.asSymbol});}.defer;
						loadMenu.value= loadMenu.items.indexOf(name.asSymbol);
						w.close;
					});
				});
				Button(w, Rect(120, 40, 100, 40))
				.states_([["cancel"]])
				.action_({
					w.close;
				});
				w.front;
		});

StaticText(w, Rect(0, 0, 240, 20)).string_("Set All:");
PopUpMenu(w, 55@20).items_(outputs)
		.action_({|m| 
			servoMenus.do({|it, i|
				it.valueAction= outputs.indexOfEqual(m.item);
				});
			});
PopUpMenu(w, 100@20).items_(ipNames)
		.action_({|m| 
			botMenus.do({|it, i|
				it.valueAction= ipNames.indexOfEqual(m.item);
				});
			});
StaticText(w, 100@20).string_("");

[\joyLX, \joyLY, \joyLB, \joyRX, \joyRY, \joyRB, \joyB1, \joyB2, \joyB3, \joyB4, \joyB5, \joyB6, \joyFPS, \joyL1, \joyL2, \joyR1, \joyR2, \joyArU, \joyArR, \joyArD, \joyArL].do({|it, i|
	if(it.asString.last.asString == "X" or: {it.asString.last.asString == "Y"}, {
		// ------------ SLIDER --------------
		StaticText(w, Rect(0, 0, 45, 20)).string_(it.asString);
		names[it][0]= Slider(w, Rect(0, 0, 190, 20))
		.action_({|v|
			NetAddr(names[it][5][0], names[it][5][1]).sendMsg(names[it][4]++((v.value*180).floor(0.1)));
			((v.value*180).floor(0.1)).postln;
		});
		servoMenus[i]= PopUpMenu(w, 55@20).items_(outputs)
		.action_({|m| names[it][4]= m.item });
		botMenus[i]= PopUpMenu(w, 100@20).items_(ipNames)
		.action_({|m| names[it][5]= ~ipDict[m.item]});
		checkBoxes[i]= CheckBox(w, 20@20)
		.action_({|v|
			if(v.value==true, {
				OSCdef((it).asSymbol).enable;
				//names[it][2]= true;
				},{
				OSCdef((it).asSymbol).disable;
				//names[it][2]= false;
				});
			});
		StaticText(w, 100@20).string_("");
		OSCdef(it).enable;
		OSCdef(it, {|msg, time, addr, recvPort|
			if(msg[1] != names[it][1], {
			NetAddr(names[it][5][0], names[it][5][1]).sendMsg(names[it][4]++(msg[1].asString));
			if (~recOSC, {
			NetAddr("localhost", NetAddr.langPort).sendMsg(names[it][5][0], names[it][4]++(msg[1].asString)); 
			 });
			if(verbose, {msg.postln;});
			{names[it][0].value= msg[1]/180}.defer;
			});
			names[it][1]= msg[1];
			}, ("/"++(it.asString)).asSymbol, n);
		
	},{ // ---------- BUTTON ----------
		names[it][0]= Button(w, Rect(0, 0, 80, 20))
		.states_([[it.asString, Color.black, Color.white], [it.asString, Color.black, Color.red]])
		.action_({|v|
			if(v.value==1, {
				NetAddr(names[it][5][0], names[it][5][1]).sendMsg(names[it][4]++names[it][2]);
				if(buffers[i].isNil.not, {
					synths[i]= Synth(\simpleLooper_++(buffers[i].numChannels), [\buf, buffers[i]]);
					});
				if(midiFiles[i].isNil.not, {
					NetAddr(names[it][5][0],names[it][5][1]).postln;
					midiPlayers[i]= OSCFileLogPlayer.new(midiFiles[i], NetAddr(names[it][5][0],names[it][5][1]));
					midiPlayers[i].play;
					});
				
			},{
				NetAddr(names[it][5][0], names[it][5][1]).sendMsg(names[it][4]++names[it][3]);
				if(buffers[i].isNil.not, { synths[i].free });
				if(midiFiles[i].isNil.not, { midiPlayers[i].stop; midiPlayers[i].close; });
			});
		});
		onOffButtons[i][0]= EZNumber(w, 75@20, "on", [0, 170, \lin, 1].asSpec, {|v| names[it][2]= v.value }, 100 , false, 25);
		onOffButtons[i][1]= EZNumber(w, 75@20, "off", [0, 170, \lin, 1].asSpec, {|v| names[it][3]= v.value }, 130 , false, 25);
		servoMenus[i]= PopUpMenu(w, 55@20).items_(outputs)
		.action_({|m| names[it][4]= m.item });
		botMenus[i]= PopUpMenu(w, 100@20).items_(ipNames)
		.action_({|m| names[it][5]= ~ipDict[m.item]});
		checkBoxes[i]= CheckBox(w, 20@20)
		.action_({|v|
			if(v.value==true, {
				OSCdef((it).asSymbol).enable;
				//names[it][2]= true;
				},{
				OSCdef((it).asSymbol).disable;
				//names[it][2]= false;
				});
			});
		soundDrag[i]= DragSink(w, 50@20)
		.string_("no snd")
		.receiveDragHandler_({ arg v;
			View.currentDrag.value.class.postln;
			View.currentDrag.value.postln;
			//{x.free}.try;
			if (View.currentDrag.value.isSoundFile, {
				if(buffers[i].isNil.not, {buffers[i].free});
				buffers[i]= Buffer.read(s, View.currentDrag.value);
				names[it][6]= View.currentDrag.value;
				v.string_(View.currentDrag.value.basename.removeExtension);
			});
		});
		midiDrag[i]= DragSink(w, 50@20)
		.string_("no midi")
		.receiveDragHandler_({ arg v;
			View.currentDrag.value.class.postln;
			View.currentDrag.value.postln;
			//{x.free}.try;
			if (View.currentDrag.value.extension == "mid", {
				midiFiles[i]= View.currentDrag.value;
				names[it][7]= View.currentDrag.value;
				v.string_(View.currentDrag.value.basename.removeExtension);
			});
		});
		OSCdef(it).enable;
		OSCdef(it, {|msg, time, addr, recvPort|
			if(msg[1] != names[it][1], {
				if(msg[1]==1, {
				NetAddr(names[it][5][0], names[it][5][1]).sendMsg(names[it][4]++(names[it][2].asString));
				if (~recOSC, {
				NetAddr("localhost", NetAddr.langPort).sendMsg(names[it][5][0], names[it][4]++(names[it][2].asString)); 
				 });
				},{
				NetAddr(names[it][5][0], names[it][5][1]).sendMsg(names[it][4]++(names[it][3].asString));
				if (~recOSC, {
				NetAddr("localhost", NetAddr.langPort).sendMsg(names[it][5][0], names[it][4]++(names[it][3].asString)); 
				 });	
			});
			names[it][1]= msg[1];
			{names[it][0].value= msg[1]}.defer;
			if(verbose, {msg.postln;});
			});
			}, ("/"++(it.asString)).asSymbol, n);
	});
	
});

Button(w, 120@20).states_([["open max app", Color.black, Color.white]])
.action_({
//"open /Applications/joy2osc.app".unixCmd;
"open /Volumes/MEDIA/MaxPatches/joy2oscNEW/joy2oscAppXbox.maxpat".unixCmd;

});

CheckBox(w, 80@20).value_(false).string_("print vals")
.action_({|v| 
	if(v.value==true, {verbose= true}, {verbose= false});
});


w.onClose = {
	names.keysDo({|it|
		OSCdef(it).disable;
		OSCdef(it).free;
	});
	~joy2oscOpen= false;
	};
	
w.front;

SynthDef(\simpleLooper_1, {|buf|
Out.ar(0, PlayBuf.ar(1, buf, loop:1)!2)
}).add;

SynthDef(\simpleLooper_2, {|buf|
Out.ar(0, PlayBuf.ar(2, buf, loop:1))
}).add;

)


/*
NetAddr("172.16.1.6", 8888).sendMsg("SR1127");
NetAddr("172.16.1.6", 8888).sendMsg("SR195");

NetAddr("172.16.1.6", 8888).sendMsg("SR165");


NetAddr("172.16.1.6", 8888).sendMsg("SR258");
NetAddr("172.16.1.6", 8888).sendMsg("SR295");


NetAddr("172.16.1.150", 8888).sendMsg("SR13");
NetAddr("172.16.1.150", 8888).sendMsg("SR23");
NetAddr("172.16.1.150", 8888).sendMsg("SR33");
NetAddr("172.16.1.150", 8888).sendMsg("SR43");
NetAddr("172.16.1.150", 8888).sendMsg("SR53");
*/



