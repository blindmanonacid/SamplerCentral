// ========================
// MENUUU
// ========================

(
var w, c, wb, nameList, actionList, homeDir, soundcardMenu;
var samplerFiles, samplerNames, buttonColors, buttonColorsNeg;
var winHeight;
var soundcardOuts, soundcardOrder;
var preferences, defaultPreferences, preferencesFile;
var card;
var midiDict, oscDict, midi2oscRespArr;
var metronomeResp;

//GUI.cocoa;
GUI.qt;

s= Server.internal;

~recOSC= false;
~openSamplers= Dictionary.new;
~globalPreferencesOpen= false;
~makeNewWindowOpen= false;
~ableton2oscOpen= false;
~joy2oscOpen= false;
~mixerChans= Dictionary.new;
~mixerOpen= false;

~ipDict= Dictionary.newFrom( List[
	\fatBot, ["172.16.3.177", 8888],  
	\circleBot, ["172.16.1.178", 8888],
	\updownBot, ["172.16.1.180", 8888],
	\updownEyes, ["172.16.1.180", 8888],
	\updownMove, ["172.16.1.180", 8888],
	\headBot, ["172.16.1.179", 8888],
	\headBotEyes, ["172.16.1.179", 8888],
	\headBotMouth, ["172.16.1.179", 8888],
	\headBotMove, ["172.16.1.180", 8888],
	\servo, ["172.16.1.200", 8888],
	\servoMouth, ["172.16.1.200", 8888],
	\relay8_1, ["172.16.1.200", 8888],
	\relay8_2, ["172.16.1.200", 8888],
	\relay8_3, ["172.16.1.200", 8888],
	\relay8_4, ["172.16.1.200", 8888],
	\relay8_5, ["172.16.1.200", 8888],
	\relay8_6, ["172.16.1.200", 8888],
	\relay8_7, ["172.16.1.200", 8888],
	\relay8_8, ["172.16.1.200", 8888],
	\wifi, ["172.16.1.6", 8888],
	\wifiMouth, ["172.16.1.6", 8888],
	\first, ["172.16.1.150", 8888],
	\firstEyes, ["172.16.1.150", 8888],
	\firstMouth, ["172.16.1.150", 8888],
	\head2, ["172.16.1.151", 8888],
	\head2Eyes, ["172.16.1.151", 8888],
	\head2Mouth, ["172.16.1.151", 8888],
	\head3, ["172.16.1.152", 8888],
	\head3Eyes, ["172.16.1.152", 8888],
	\head3Mouth, ["172.16.1.152", 8888],
	\head4, ["172.16.1.153", 8888],
	\head4Eyes, ["172.16.1.153", 8888],
	\head4Mouth, ["172.16.1.153", 8888],
	\sparkHead, ["192.168.0.19", 8888],
	\sparkEyes, ["192.168.0.19", 8888],
	\sparkMouth, ["192.168.0.19", 8888],
	\sparkHome, ["192.168.178.125", 8888],
	\max, ["127.0.0.1", 6666],
	\mega, ["172.16.1.176", 8888],
	\conductor, ["172.16.1.160", 8888]
	]
	);

~robotDict= ( // label, controlSpec, initValues ([on, off], type, duration) // dur up 4 grabs!
	\fatBot: [\SR1, [0, 127, \lin, 1].asSpec, [[127, 95], 0, 0.3]], 
	\circleBot: [\SR1, [0, 127, \lin, 1].asSpec, [[100, 95], 0, 0.3]],
	\conductor: [\SR3, [0, 127, \lin, 1].asSpec, [[80, 100], 0, 0.3]],
	\updownBot: [\SR2, [0, 127, \lin, 1].asSpec, [[127, 125], 0, 0.3]],
	\updownEyes: [\SR1, [0, 127, \lin, 1].asSpec, [[127, 95], 0, 0.3]],
	\updownMove: [\SR3, [0, 127, \lin, 1].asSpec, [[127, 100], 0, 0.3]],
	\headBot: [\SR2, [0, 127, \lin, 1].asSpec, [[127, 125], 0, 0.3]],
	\headBotMove: [\SR3, [0, 127, \lin, 1].asSpec, [[95, 95], 0, 0.3]],
	\headBotMouth: [\SR2, [0, 127, \lin, 1].asSpec, [[130, 125], 0, 0.3]],
	\headBotEyes: [\SR2, [0, 127, \lin, 1].asSpec, [[130, 125], 0, 0.3]],
	\servo: [\SR1, [0, 127, \lin, 1].asSpec, [[127, 65], 0, 0.3]],
	\servoMouth: [\SR2, [0, 127, \lin, 1].asSpec, [[80, 127], 0, 0.3]],
	\relay8_1: [\RL1, [0, 1, \lin, 1].asSpec, [[0, 1], 0, 0.3]],
	\relay8_2: [\RL2, [0, 1, \lin, 1].asSpec, [[0, 1], 0, 0.3]],
	\relay8_3: [\RL3, [0, 1, \lin, 1].asSpec, [[0, 1], 0, 0.3]],
	\relay8_4: [\RL4, [0, 1, \lin, 1].asSpec, [[0, 1], 0, 0.3]],
	\relay8_5: [\RL5, [0, 1, \lin, 1].asSpec, [[0, 1], 0, 0.3]],
	\relay8_6: [\RL6, [0, 1, \lin, 1].asSpec, [[0, 1], 0, 0.3]],
	\relay8_7: [\RL7, [0, 1, \lin, 1].asSpec, [[0, 1], 0, 0.3]],
	\relay8_8: [\RL8, [0, 1, \lin, 1].asSpec, [[0, 1], 0, 0.3]],
	\wifi: [\SR2, [0, 180, \lin, 1].asSpec, [[80, 64], 0, 0.3]],
	\wifiMouth: [\SR2, [0, 180, \lin, 1].asSpec, [[100, 130], 0, 0.3]],
	\firstEyes: [\SR1, [0, 180, \lin, 1].asSpec, [[130, 90], 0, 0.3]],
	\firstMouth: [\SR2, [0, 180, \lin, 1].asSpec, [[100, 130], 0, 0.3]],
	\head2: [\SR2, [0, 180, \lin, 1].asSpec, [[100, 130], 0, 0.3]],
	\head2Eyes: [\SR1, [0, 180, \lin, 1].asSpec, [[130, 90], 0, 0.3]],
	\head2Mouth: [\SR2, [0, 180, \lin, 1].asSpec, [[100, 130], 0, 0.3]],
	\head3: [\SR2, [0, 180, \lin, 1].asSpec, [[130, 130], 0, 0.3]],
	\head3Eyes: [\SR1, [0, 180, \lin, 1].asSpec, [[130, 90], 0, 0.3]],
	\head3Mouth: [\SR2, [0, 180, \lin, 1].asSpec, [[100, 130], 0, 0.3]],
	\head4: [\SR2, [0, 180, \lin, 1].asSpec, [[130, 130], 0, 0.3]],
	\head4Eyes: [\SR1, [0, 180, \lin, 1].asSpec, [[130, 90], 0, 0.3]],
	\head4Mouth: [\SR2, [0, 180, \lin, 1].asSpec, [[100, 130], 0, 0.3]],
	\sparkHead: [\SR2, [0, 180, \lin, 1].asSpec, [[100, 130], 0, 0.3]],
	\sparkEyes: [\SR1, [0, 180, \lin, 1].asSpec, [[100, 90], 0, 0.3]],
	\sparkMouth: [\SR2, [0, 180, \lin, 1].asSpec, [[100, 130], 0, 0.3]],
	\sparkHome: [\SR1, [0, 180, \lin, 1].asSpec, [[100, 130], 0, 0.3]],
	\max: ["/dmx", [0, 180, \lin, 1].asSpec, [[100, 130], 0, 0.3]],
	\mega: [\SR1, [0, 180, \lin, 1].asSpec, [[100, 130], 0, 0.3]],
	\megaEyes: [\SR1, [0, 180, \lin, 1].asSpec, [[100, 130], 0, 0.3]],
	\megaMouth: [\SR2, [0, 180, \lin, 1].asSpec, [[100, 130], 0, 0.3]]
	);

midiDict= Dictionary.new;
midiDict.putPairs([21, "SR1", 22, "SR2", 23, "SR3", 24, "SR4", 25, "SR5", 26, "SR6", 27, "SR7", 28, "SR8", 29, "SR9", 30, "BRK", 41, "RL1", 42, "RL2", 43, "RL3", 44, "RL4", 45, "RL5", 46, "RL6", 47, "RL7", 48, "RL8", 49, "RL9"]);
oscDict= Dictionary.new;
oscDict.putPairs([1, \updownBot, 2, \head2, 3, \head3, 4, \head4, 5, \head5, 6, \sparkHead, 7, \circleBot, 8, \headBot]);

midi2oscRespArr= List.new;

preferencesFile = String.scDir++"/PREFERENCES/globalPreferences";
defaultPreferences= [nil!4, 12, 0, 44100, 1024, 65536, nil!4, nil, nil, nil];

if( preferencesFile.isFile, 
	{ preferences= Object.readArchive(preferencesFile); }, 
	{ preferences= defaultPreferences }
);

soundcardOrder= preferences[0];

soundcardOuts= ServerOptions.outDevices;

samplerFiles= (String.scDir+/+"SAMPLERS/*").pathMatch;

samplerNames= samplerFiles.collect({|it| it.basename.removeExtension});

~openSamplers= Dictionary.new;
samplerNames.do({|it|
	~openSamplers.put(it.asSymbol, true);
});


winHeight= (20*samplerFiles.size)+155;

w= Window("", Rect(1180, 655, 100, winHeight));
wb= w.bounds;
c= GUI.vLayoutView.new(w, Rect(0, 30, wb.width, wb.height-30));

StaticText(w, Rect(0, 10, 100, 15))
.string_("SAMPLERS")
.font_(Font("Helvetica", 15))
.align_(\center);

nameList= samplerNames;
actionList= samplerFiles;

//get background colors
buttonColors= samplerNames.collect({|it|
	var file, prefs, color;
	file= String.scDir++"/PREFERENCES/"++it++"/"++it++"_CURRENT";
	if(file.isFile, {
		prefs= Object.readArchive(file);
		color= prefs[7];
	}, {
		color= Color.white;	
	});
	
});

/*
buttonColorsNeg= buttonColors.collect({|it|
	Color(it.red.neg+1, it.green.neg+1, it.blue.neg+1, 1.0);
});


buttonColorsNeg= buttonColors.collect({|it|
	var r, g, b;
	if(it.red < 0.5, {r= 1}, {r= 0});
	if(it.green < 0.5, {g= 1}, {g= 0});
	if(it.blue < 0.5, {b= 1}, {b= 0});
	Color(r, g, b, 1.0);
});
*/

buttonColorsNeg= buttonColors.collect({|it|
	if((it.red+it.green+it.blue) < 1.5,  {Color.white}, {Color.black});
});

nameList.size.do({ |i|
	Button(c, 50@15)
	.states_([[nameList[i], buttonColorsNeg[i], buttonColors[i]]])
	.action_({
		if(~openSamplers[samplerNames[i].asSymbol], {actionList[i].load; ~openSamplers[samplerNames[i].asSymbol]= false })
	})
	.mouseDownAction_({ |view, x, y, mod|
			if (mod.isShift, { Document.open(actionList[i]); });
		})
});

StaticText(c, Rect(0, 0, 50, 10))
.string_("s o u n d c a r d")
.font_(Font("Helvetica", 10))
.align_(\center);

soundcardMenu= PopUpMenu(c, (Rect(0, 0, 50, 20)))
.items_(soundcardOuts)
.value_(0)
.action_({ |v|
	s.options.outDevice= soundcardOuts[v.value]
	});

Button(c, 50@15)
	.states_([["MAKE NEW", Color.white,Color.grey]])
	.action_({
	if( ~makeNewWindowOpen == false, {
	((String.scDir).dirname++"/makeNewSampler.scd").standardizePath.load;
	});
	});

Button(c, 50@15)
	.states_([["global setup", Color.white,Color.black]])
	.action_({
	if( ~globalPreferencesOpen == false, {
	((String.scDir).dirname++"/globalPreferencesWindow.scd").standardizePath.load;
	});
	});
	
Button(c, 50@15)
.states_([ [ "mixer", Color.black, Color.green ] ])
.action_({|v|
	if(~mixerOpen== false, {
		((String.scDir).dirname++"/mixer.scd").standardizePath.load;
	});
});

Button(c, 50@15)
	.states_([["Rec OSC", Color.black,Color.red]])
	.action_({
	((String.scDir).dirname++"/OSCRecGUI.scd").standardizePath.load;
	});

Button(c, 50@15)
	.states_([["re-init midi", Color.blue,Color.grey]])
	.action_({ MIDIClient.init; });

Button(c, 50@15)
.states_([ [ "recAbleton", Color.black, Color.yellow ] ])
.action_({|v|
	if(~ableton2oscOpen== false, {
		((String.scDir).dirname++"/ableton2osc.scd").standardizePath.load;
	});
});

Button(c, 50@15)
.states_([ [ "recJoystick", Color.black, Color.yellow ] ])
.action_({|v|
	if(~joy2oscOpen== false, {
		((String.scDir).dirname++"/joy2osc2.scd").standardizePath.load;
	});
});

Button(c, 50@15)
	.states_([["qlab2osc off", Color.white,Color.grey], ["qlab2osc on", Color.white,Color.green]])
	.action_({ |v|
		if(v.value==1, {
			MIDIClient.sources.do({|it, i|
				var busNum, uid, resp;
				if(it.name.contains("IAC"), {
					uid= it.uid;
					busNum= it.name.last.asString.asInteger;
					//[oscDict[busNum], uid, ~ipDict[oscDict[busNum]]].postln;
					resp= MIDIFunc.cc({|val, cc, chan|
						if(midiDict[cc].notNil, {
							NetAddr(~ipDict[oscDict[busNum]][0], ~ipDict[oscDict[busNum]][1] ).sendMsg(midiDict[cc]++((val/100)*127).floor);
							//[val, cc, chan].postln;
							//(midiDict[cc]++((val/100)*127).floor).postln;
							});
					}, srcID: uid );
				midi2oscRespArr.add(resp);
				MIDIIn.connectByUID(0, uid);
				});
			});
			midi2oscRespArr.postln;
			}, {
			midi2oscRespArr.do({|it| it.free });
				
		});
	});

Button(c, 50@15)
	.states_([["conduct OFF", Color.white,Color.grey], ["conduct ON", Color.white,Color.green]])
	.action_({ |v|
		if(v.value==1, {
			(String.scDir.dirname+/+"conductor.scd").load;
			/*
			metronomeResp= OSCFunc.new({
				"play metronome tick!".postln;
				}, \playMetronome, NetAddr(~ipDict[\conductor][0], ~ipDict[\conductor][1]),~ipDict[\conductor][1]);
				*/
		},{
			//metronomeResp.free;
		});
});				

Button(c, 50@15)
	.states_([["kill all sound", Color.red,Color.grey]])
	.action_({ Server.killAll; });
	
Button(c, 50@15)
	.states_([["H E L P", Color.black,Color.white]])
	.action_({ (String.scDir+/+"Help2/Help.rtf").openDocument; });

DragSink(c, 50@40)
	.string_("post tags")
	//.canReceiveDragHandler_({ true });
	.receiveDragHandler_({ arg v;
		View.currentDrag.value.class.postln;
		View.currentDrag.value.postln;
		("Tags for file"+View.currentDrag.value.basename++":").postln;
Ê Ê Ê	View.currentDrag.value.getTags.postln;
});

{
soundcardOrder.size.do({|it, i|
	var check;
	i= ((soundcardOrder.size-1) - i);

	check= soundcardOuts.detect({|it|
		it == soundcardOrder[i]
	});
	if (check.isNil.not, {card= check});
});

if (card.isNil.not, {soundcardMenu.value= soundcardMenu.items.indexOf(card); s.options.outDevice= card},{ s.options.device= nil; });
}.value;

w.view.keyDownAction= {|view, char, mod|
//[view, char, mod, char.class].postln;
case 
	{char === $l} { s.tryPerform(\meter) }
	{char === $p} { Document.open(String.scDir.dirname+/+"loadMenu.sc") };
};

w.front;
//MIDIClient.init;

//s.options.memSize= preferences[5];
s.options.memSize= 256 * 1024; // 256 mb
s.options.numOutputBusChannels= preferences[1];
s.options.numInputBusChannels= preferences[2];
s.options.sampleRate= preferences[3];
s.options.hardwareBufferSize= preferences[4];

("num outts:"+preferences[1]).postln;

//LAUNCH SAMPLER AT STARTUP
preferences[6].do({|it, i|
	{
		if(it.isNil.not && {it.isFile}, {
			samplerFiles.do({ |sf|
				if(sf == it, {
					it.load; ~openSamplers[(it.basename.removeExtension).asSymbol]= false; 1.wait; });
			});
		});
	}.fork(AppClock);
});


if("/Users/martin/scwork/samplerProject/autoBackup".isFolder, {
	AutoBackup.backupFolder= "/Users/martin/scwork/samplerProject/autoBackup/";
	AutoBackup.start;
	});
	


)

