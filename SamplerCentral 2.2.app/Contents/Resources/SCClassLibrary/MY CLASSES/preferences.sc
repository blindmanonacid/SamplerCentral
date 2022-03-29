KeyboardPreferences{
	*new{ arg thisFile;
		
var w, name, numberKeys, numKeysView, numFadersView, numKnobsView, numSlidersView;
var knobs, learnKnobs, numberOfKnobs, knobsCCArray;
var sliders, learnSliders, numberOfSliders, slidersCCArray;
var startKey;
var cc1, cc, noteResponder;
var midi, midimenu, midimenuitems, midiDevice, midiPortName, midistring;
var midichannelView, midichannel;
var backgroundColor;
var settings, writeSettings;
var thisFilePath, settingsPath, documentPath;
var knobsOK, slidersOK;
var savefilePath, backupfilePath;
var preferences, preferencesPath, preferencesFile, defaultPreferences;
var thisFileName;
var ruleFolder, routingPan, routingChannel;
var outputs, defaultFolderRuleList, folderRuleList, folderNames, folderNamesView, onoffButtons, applyButtons;
var c, propView;
var applyStates, applyStatesDefault, onoffStates;
var backup;
var colorPicker;
var savefilesWithPath, savefiles, loadmenu,loadPreferences;
var mainoutputs, outputView;
var selectionView, backgroundFolderView, selectionFunc;
var ctrl, shift, alt;
var prefBackground, midiPrefView;
var backgroundFolderUnderView, midiInPriority, midiOutPriority, midiOutMenuitems, midiOut;

Platform.case(
	\osx,		{ ctrl= 262401; shift= 131330; alt= 524576; },
	\linux,		{ ctrl= 262144; shift= 131072; },
	\windows, 	{ "ERROR: havent tested this on Windows".postcs }
);

midiInPriority= [nil, nil, nil];
midiOutPriority= [nil, nil, nil];

outputs= [nil, 0, 2, 4, 6, 8, 10, 12, 14, 16];

//if (folderRuleList[newItem].isNil.not, {folderRuleList.add(newItem, folderRuleList.deepCopy)}

onoffButtons= Array.newClear(4); 
applyButtons= List.newClear(4);
applyStatesDefault= (0!12)!4;
folderNamesView= Array.newClear(4); 
defaultFolderRuleList= ([0.5, 0, 0, 0.01, 0.2, 0, 0, 3, 0, 0, nil, nil]!4).asList;
defaultPreferences= [nil, nil, nil, nil, nil, nil, nil, nil, 0, nil!4, defaultFolderRuleList, applyStatesDefault, 0!4, 0];

thisFilePath= thisFile.dirname.dirname;
thisFileName= thisFile.basename;
("path:"+thisFilePath).postln;
("name:"+thisFileName).postln;
settingsPath= (thisFilePath++"/"++"Resources/SETTINGS/"++(thisFileName)++"SETUP").standardizePath;
//documentPath= (thisFilePath++"/"++"Resources/SAMPLERS/").standardizePath;
preferencesPath= (thisFilePath++"/"++"Resources/PREFERENCES/"++thisFileName).standardizePath;
preferencesFile= (preferencesPath++"/"++thisFileName++"_CURRENT").standardizePath;
//savefilePath= (thisFilePath++"/"++"Resources/SAVEFILES/"++name.string).standardizePath;

if(preferencesFile.isFile, {
	preferences= Object.readArchive(preferencesFile);
	},{
	preferences= Object.readArchive(settingsPath);
	//preferences[5]= [[preferences[5].deepCopy, preferences[6].deepCopy], nil, nil];
	//preferences[6]= [nil, nil, nil];
});

//numKeysView.value= preferences[0].asInteger;
//startKey.value= preferences[1];
knobsCCArray= preferences[2];
slidersCCArray= preferences[3];
//name.string, = preferences[4];
//midiDevice= preferences[5];
midiInPriority= preferences[5];
//midiPortName= preferences[6];
midiOutPriority= preferences[6];
backgroundColor= preferences[7];
if (preferences[8].isNil, {midichannel= 0}, {midichannel= preferences[8]}); // ! ! ! ! !!
if (preferences[9].isNil, {folderNames= Array.newClear(4)}, {folderNames= preferences[9]});
if (preferences[10].isNil, {folderRuleList= defaultFolderRuleList;},{folderRuleList= preferences[10]});
if (preferences[11].isNil.not, {applyStates= preferences[11]}, {applyStates= applyStatesDefault});
if (preferences[12].isNil.not, {onoffStates= preferences[12]}, {onoffStates= 0!4});
if (preferences[13].isNil.not, {mainoutputs= preferences[13]}, {mainoutputs= 0});

//preferences.postcs;

//backwards compability
if (preferences.size < defaultPreferences.size, {
	preferences= preferences.asList;
	defaultPreferences.do({ |it, i|
			if (preferences[i].isNil, { preferences= preferences.add(it) });
	});
});



w= Window( (preferences[4]+"preferences"), Rect(200, 0, 1100, 650));

prefBackground= CompositeView(w, Rect(10, 10, 300, 580))
.background_(Color(0.5, 0.6, 0.6, 1.0));

StaticText(prefBackground, Rect(0, 0, 300, 40))
.string_("Preferences:")
.align_(\center)
.font_(Font.new("Helvetica", 24));

//midi connect
/*
MIDIClient.init;
MIDIIn.connectAll;
*/

//keyboard name
StaticText(prefBackground, Rect(10, 60, 100, 20))
.string_("Name:");
name= TextView(prefBackground, Rect(110, 60, 100, 20))
.font_(Font("Helvetica", 12))
.string_(preferences[4])
.editable_(false);

//number of keys
StaticText(prefBackground, Rect(10, 90, 100, 20))
.string_("Number of keys:");
numKeysView= NumberBox(prefBackground, Rect(110, 90, 30, 20))
.value_(preferences[0].asInteger)
.enabled_(false)
.step_(12)
.clipLo_(13)
.clipHi_(49);


//number of knobs
StaticText(prefBackground, Rect(10, 120, 100, 20))
.string_("Number of knobs:");
numKnobsView= NumberBox(prefBackground, Rect(110, 120, 30, 20))
.value_(knobsCCArray.size)
.enabled_(false)
.action_({|v| numberOfKnobs= v.value});

//number of sliders
StaticText(prefBackground, Rect(10, 150, 100, 20))
.string_("Number of sliders:");
numSlidersView= NumberBox(prefBackground, Rect(110, 150, 30, 20))
.value_(slidersCCArray.size)
.enabled_(false)
.action_({|v| numberOfSliders= v.value});

knobsOK= StaticText(prefBackground, Rect(90, 180, 150, 20)).string_("");

Button(prefBackground, Rect(10, 180, 70, 20))
.states_([["set knobs"], ["ok"]])
.action_({
	|v|
	if (v.value == 1, {learnKnobs.value; knobsOK.string_(""); }, {
		cc1.remove; knobs.do({|it| it.remove; }); w.refresh; 
		if(knobsCCArray.size == numberOfKnobs, {
			knobsOK.string_("OK!");
			},{
			knobsOK.string_("not enough input..");
			});
		});
	});


learnKnobs= {
	var ccArray= [];
	numberOfKnobs= numKnobsView.value.asInteger;
	knobs= Array.newClear(numberOfKnobs);
	{
	numberOfKnobs.do({|it, i|
		knobs[i]= Knob(prefBackground, Rect((30*i), 210, 20, 20));
	});
	}.defer;
	
	cc1 = CCResponder({ |src,chan,num,value|
		//[src,chan,num].postln;
		
		if (ccArray.indexOf(num).isNil, { 
			if (ccArray.size >= numberOfKnobs, {"all knobs filled!".postln; knobsCCArray= ccArray;}, {
				ccArray= ccArray.add(num);});
			}, {
				if (ccArray.size >= numberOfKnobs, {"all knobs filled!".postln; knobsCCArray= ccArray;});
					{knobs[(ccArray.indexOf(num))].value= (value/127)}.defer;
		});
		ccArray.postln;
		});

	w.refresh;
	};

slidersOK= StaticText(prefBackground, Rect(90, 240, 150, 20));

Button(prefBackground, Rect(10, 240, 70, 20))
.states_([["set sliders"], ["ok"]])
.action_({
	|v|
	if (v.value == 1, {learnSliders.value; slidersOK.string_(""); }, {
		cc.remove; sliders.do({|it| it.remove; }); w.refresh;
		if(slidersCCArray.size == numberOfSliders, {
			slidersOK.string_("OK!");
			},{
			slidersOK.string_("not enough input..");
			});
		});
	});


learnSliders= {
	var ccArray= [];
	numberOfSliders= numSlidersView.value.asInteger;
	sliders= Array.newClear(numberOfSliders);
	{
	numberOfSliders.do({|it, i|
		sliders[i]= Slider(prefBackground, Rect(10+(30*i), 270, 20, 40));
	});
	}.defer;
	
	cc = CCResponder({ |src,chan,num,value|
		//[src,chan,num].postln;
		
		if (ccArray.indexOf(num).isNil, { 
			if (ccArray.size >= numberOfSliders, {"all sliders filled!".postln; slidersCCArray= ccArray;}, {
				ccArray= ccArray.add(num);});
			}, {
				if (ccArray.size >= numberOfSliders, {"all sliders filled!".postln; slidersCCArray= ccArray;});
					{sliders[(ccArray.indexOf(num))].value= (value/127)}.defer;
		});
		ccArray.postln;
		});

	w.refresh;
	};


//start key
StaticText(prefBackground, Rect(10, 320, 220, 20))
.string_("Push lowest key on keyboard:");
startKey= NumberBox(prefBackground, Rect(180, 320, 30, 20))
.value_(preferences[1])
.enabled_(false);

Button(prefBackground, Rect(220, 320, 70, 20))
.states_([["edit"], ["ok"]])
.action_({
	|v|
	if (v.value == 1, {
			noteResponder = NoteOnResponder({ |src,chan,note,vel|
			[src,chan,note,vel].postln;
			{startKey.value= note}.defer;
		});
		}, {
			noteResponder.remove;
		});
	});



StaticText(prefBackground, Rect(10, 430, 200, 20))
.string_("Main Output Channels:");
outputView= Button(prefBackground, Rect(140, 430, 40, 20))
.states_([["nil", Color.black, Color.grey], ["1-2", Color.yellow, Color.black],["3-4", Color.yellow, Color.black], ["5-5", Color.yellow, Color.black], ["7-8", Color.yellow, Color.black], ["9-10", Color.yellow, Color.black], ["11-12", Color.yellow, Color.black]] )
.canFocus_(false)
.value_(preferences[13])
.action_({ |v|
	preferences[13]= v.value;
});

StaticText(prefBackground, Rect(10, 460, 200, 20))
.string_("Select background color:");
//colorPicker= ColorPicker.hsvMini(w, Rect(200, 470, 50, 50), backgroundColor, {|clr| backgroundColor= clr; }, true);
ColorPicker.new(prefBackground, Point(0, 480), backgroundColor, {|clr| backgroundColor= clr; }, true);


// ====================== MIDI PREFERENCES ==========================

midiPrefView= CompositeView(w, Rect(320, 10, 240, 580))
.background_(Color(0.52238805970149, 0.62686567164179, 0.65671641791045, 1.0));

StaticText(midiPrefView, Rect(10, 0, 240, 40))
.string_("MIDI settings:")
.align_(\center)
.font_(Font.new("Helvetica", 24));


StaticText(midiPrefView, Rect(10, 50, 100, 20)).string_("MIDI Input:");

midistring= StaticText(midiPrefView, Rect(235, 70, 60, 20)).string_("");

midi= MIDIClient.sources;
//midimenuitems= midi.size.collect({|i|(midi[i].asString.replace("MIDIEndPoint", "").drop(-1).drop(1)); });
midimenuitems= midi.collect({|it| (it.asString.replace("MIDIEndPoint", "").drop(-1).drop(1)).tr($(,$[).tr($),$]); });

midimenuitems= ["select midi input..."]++midimenuitems;
midimenuitems.postln;

/*
midimenu= PopUpMenu(midiPrefView, Rect(10, 70, 220, 20))
.items_(midimenuitems)
.action_({ |v|
if (v.value > 0, {
	v.items[v.value].postln;
	midiDevice= midi[v.value-1].device;
	midiPortName= midi[v.value-1].name;
	midistring.string_("OK").stringColor_(Color.green);
	});
});

midimenu.items.do({|it, i| if (it.asString.contains(midiDevice), {midimenu.value_(i)}) });
if(midimenu.value == 0, { midistring.string_("!").stringColor_(Color.red); });
*/

StaticText(midiPrefView, Rect(10, 100, 120, 20)).string_("MIDI Channel:");
midichannelView= NumberBox(midiPrefView, Rect(120, 100, 30, 20))
.value_(midichannel)
.action_({|v| midichannel= v.value; })
.step_(1)
.clipLo_(0)
.clipHi_(16);

// MIDI IN CONNECTION PRIORITY
StaticText(midiPrefView, Rect(10, 130, 220, 20))
.string_("MIDI IN Connection Priority:")
.align_(\center)
.background_(Color.grey)
.font_(Font.new("Helvetica", 15));

midiInPriority.do({|it, i|
	var current;

	StaticText(midiPrefView, Rect(10, 150+(i*30), 20, 20))
	.string_((i+1).asString++".")
	.align_(\left)
	.font_(Font.new("Helvetica", 12));

	current= StaticText(midiPrefView, Rect(20, 150+(i*30), 100, 20))
	.string_(it.asString)
	.align_(\center)
	.background_(Color.white)
	.font_(Font.new("Helvetica", 10));	
	
	PopUpMenu(midiPrefView, Rect(120, 150+(i*30), 110, 20))
	.items_(midimenuitems)
	.action_({|v|
		if (v.value == 0, {
			midiInPriority[i]= nil;
			current.string= nil;
			current.align= \center;
			current.font= Font.new("Helvetica", 10);
			}, {
			midiInPriority[i]= [midi[v.value-1].device.asString, midi[v.value-1].name.asString];
			current.string= v.items[v.value];
			current.align= \center;
			current.font= Font.new("Helvetica", 10);
		});
		});

});

// MIDI OUT CONNECTION PRIORITY

midiOut= MIDIClient.destinations;
midiOutMenuitems= midiOut.collect({|it| (it.asString.replace("MIDIEndPoint", "").drop(-1).drop(1)).tr($(,$[).tr($),$]); });

midiOutMenuitems= ["select midi input..."]++midiOutMenuitems;

StaticText(midiPrefView, Rect(10, 340, 220, 20))
.string_("MIDI OUT Connection Priority:")
.align_(\center)
.background_(Color.grey)
.font_(Font.new("Helvetica", 15));

midiOutPriority.do({|it, i|
	var current;

	StaticText(midiPrefView, Rect(10, 360+(i*30), 20, 20))
	.string_((i+1).asString++".")
	.align_(\left)
	.font_(Font.new("Helvetica", 12));

	current= StaticText(midiPrefView, Rect(20, 360+(i*30), 100, 20))
	.string_(it.asString)
	.align_(\center)
	.background_(Color.white)
	.font_(Font.new("Helvetica", 10));	
	
	PopUpMenu(midiPrefView, Rect(120, 360+(i*30), 110, 20))
	.items_(midiOutMenuitems)
	.action_({|v|
		if (v.value == 0, {
			midiOutPriority[i]= nil;
			current.string= nil;
			current.align= \center;
			current.font= Font.new("Helvetica", 10);
			}, {
			midiOutPriority[i]= [midiOut[v.value-1].device.asString, midiOut[v.value-1].name.asString];
			current.string= v.items[v.value];
			current.align= \center;
			current.font= Font.new("Helvetica", 10);
		});
		});

});


// ==================================== R U L E S ==================================== //


backgroundFolderUnderView= CompositeView(w, Rect(570, 10, 520, 580))
.background_(Color(0.52238805970149, 0.62686567164179, 0.65671641791045, 1.0));

backgroundFolderView= CompositeView(w, Rect(570, 10, 520, 580))
.background_(Color.white.alpha_(0));

StaticText(backgroundFolderView, Rect(10, 0, 500, 40))
.string_("Folder Specific Rules:")
.align_(\center)
.font_(Font.new("Helvetica", 24));

CompositeView(backgroundFolderView, Rect(145, 360, 220, 190))
.background_(Color.new255(229, 229, 229));

selectionFunc= {|i|
	selectionView.remove;
	selectionView= CompositeView(backgroundFolderUnderView, Rect(0, 60+(i*70), 520, 72))
	.background_(Color.new255(229, 229, 229));
};

4.do({ |i|
	var onoffValue;
	
	if (onoffStates[i].isNil, {onoffValue= 0},{onoffValue= onoffStates[i]});
	
	StaticText(backgroundFolderView, Rect(10, 60+(i*70), 500, 20))
	.string_("Rule"+(i+1).asString++":")
	.align_(\center)
	.font_(Font.new("Helvetica", 16));
	
	folderNamesView[i]= StaticText(backgroundFolderView, Rect(10, 80+(i*70), 500, 20))
	.align_(\center)
	.background_(Color.grey)
	.string_(folderNames[i]).align_(\center);

//	folderNames[i]= PopUpMenu(w, Rect(390, 80+(i*30), 80, 20))
//	.items_(["--"]);

	Button(backgroundFolderView, Rect(10, 100+(i*70), 60, 20))
	.states_([["folder"]])
	.action_({
		CocoaDialog.getPaths({ arg paths;
			var p, pp;
			pp= paths[0].dirname;
			//p= pp.copyRange(pp.size-18, pp.size-1);
			p= pp;
			folderNames[i]= p;
			
			folderNamesView[i].string= p;			
			folderNamesView[i].align= \center;
			p.postln;
			//folderNames[i].items= [paths[0].dirname];
			//clearButton.valueAction
		},{
			"cancelled".postln;
		});
	});
	
	
	onoffButtons[i]= Button(backgroundFolderView, Rect(80, 100+(i*70), 30, 20))
	.states_([["off", Color.black, Color.grey], ["on", Color.black, Color.green]])
	.value_(onoffValue)
	.action_({|v| if (folderNames[i].isNil, { v.value=0 },{ onoffStates[i]= v.value }); });
	
	applyButtons[i]= ["vol", "loop", "mnu", "atk", "rls", "kill", "-", "-","shot", "pan", "out", "midi"].collect({|it, ii|
		var state, enabled;
		enabled= [true, true, true, true, true, true, false, false,true, true, true, true];
		if (applyStates.isNil.not, {state= applyStates[i][ii]},{state= 0});
		Button(backgroundFolderView, Rect(120+(ii*30), 110+(i*70), 30, 20))
		.states_([[it, Color.black, Color.grey], [it, Color.black, Color(1.0, 0.95522388059701, 0.08955223880597, 1.0)]])
		.enabled_(enabled[ii])
		.canFocus_(false)
		.value_(state)
		.action_({|v| applyStates[i][ii]= v.value });
	});
	
	Button(backgroundFolderView, Rect(120+(30*applyButtons[i].size), 110+(i*70), 30, 20)) //edit that rule
	.states_([["edit", Color.black, Color.white]])
	.action_({ c.remove; propView.value(i); selectionFunc.value(i) });

});

/*
	Button(w, Rect(450, 550, 80, 50)) //DEBUG
	.states_([["debug!", Color.black, Color.white]])
	.action_({  
		applyStates= applyButtons.collect({|it, i|
			it.collect({|it|
				it.value;
			});
		});
		applyButtons.size.postln;
		applyStates.postln;
	});
*/	




// ====================== RULES PROPERITES WINDOW ===================
// christ... Dictionary! NO, LIST!!!
// ok so setting them is ok, but how to know which rules are actually being applied??
// check all buttons when saving.!

propView= { | key |
var panarr= [0, -1, 1];

c= CompositeView(backgroundFolderView, Rect(145, 360, 220, 190))
.background_(Color.new255(229, 229, 229));
//.relativeOrigin_(true);

StaticText(c, Rect(90, 0, 200, 15))
.string_(("Rule"+(key+1).asString));

/*
Button(c, Rect(20, 10, 30, 15))
.states_([["c", Color.black, Color.grey], ["<", Color.green, Color.black],[">", Color.green, Color.black] ])
.canFocus_(false)
.value_(panarr.indexOf(folderRuleList[key][9]))
.action_({ |v|
	folderRuleList[key][9]= panarr[v.value];
});
*/

Knob(c, Rect(20, 10, 15, 15))
.centered_(true)
.canFocus_(false)
.value_(\pan.asSpec.unmap(folderRuleList[key][9]))
.value_(folderRuleList[key][9])
.action_({ |v|
	folderRuleList[key][9]= \pan.asSpec.map(v.value);
	\pan.asSpec.map(v.value).postln;
})
.color_([Color.gray, Color.red, Color.white, Color.black])
.mouseDownAction_({|view, x, y, mod|
	if (mod == alt, {view.valueAction= \pan.asSpec.unmap(0); folderRuleList[key][9]= 0})
});

//(outputs.indexOf(folderRuleList[key][10])).postln;

Button(c, Rect(50, 10, 30, 15))
.states_([["nil", Color.black, Color.grey], ["1-2", Color.yellow, Color.black],["3-4", Color.yellow, Color.black], ["5-5", Color.yellow, Color.black], ["7-8", Color.yellow, Color.black], ["9-10", Color.yellow, Color.black], ["11-12", Color.yellow, Color.black], ["13-14", Color.yellow, Color.black], ["15-16", Color.yellow, Color.black]] )
.canFocus_(false)
.value_(if (folderRuleList[key][10]==nil, { 0 }, { outputs.indexOf(folderRuleList[key][10]) }) )
.action_({ |v|
	folderRuleList[key][10]= outputs[v.value];
});


Slider(c, Rect(20, 30, 60, 120))
.background_(Color.grey)
.canFocus_(false)
.value_(folderRuleList[key][0])
.action_({ |v|
	folderRuleList[key][0]= v.value;
});
Button(c, Rect(90, 20, 60, 20))
.states_([["loop off", Color.black, Color.grey], ["loop on", Color.white, Color.black]])
.canFocus_(false)
.value_(folderRuleList[key][1])
.action_({ |v|
	folderRuleList[key][1]= v.value;
});

Button(c, Rect(150, 20, 30, 20))
.states_([["|--|", Color.white, Color.grey]])
.canFocus_(false)
.action_({ |v|

	//{looppointeditor.value(key)}
	//{midiSendWindow.value(key)}
});


Button(c, Rect(150, 45, 30, 20))
.states_([["killa", Color.black, Color.grey], ["killa", Color.red, Color.black]])
.canFocus_(false)
.value_(folderRuleList[key][5])
.action_({ |v|
	folderRuleList[key][5]= v.value;
});

Button(c, Rect(180, 45, 20, 20))
.states_([["sh", Color.black, Color.grey], ["sh", Color.red, Color.black]])
.canFocus_(false)
.value_(folderRuleList[key][8])
.action_({ |v|
	folderRuleList[key][8]= v.value;
	folderRuleList[key][8].postln;
	if (v.value == 1, {folderRuleList[key][1]= 0});
});


Button(c, Rect(90, 45, 60, 20))
.states_([["|>", Color.black, Color.grey], ["|>", Color.white, Color.black]])
.canFocus_(false);

EZNumber( c,  	// parent
	Rect(70, 70, 80, 20),	// bounds
	"atk",	// label
	[0,6,\lin,0.01, folderRuleList[key][3]].asSpec, 	// controlSpec
	{|ez| 
	folderRuleList[key][3]= ez.value;
	}, // action
	labelWidth: 30,
	numberWidth: 40,
	unitWidth: 1
);

EZNumber( c,  	// parent
	Rect(130, 70, 80, 20),	// bounds
	"rel",	// label
	[0,6,\lin,0.01, folderRuleList[key][4]].asSpec, 	// controlSpec
	{|ez| 
	folderRuleList[key][4]= ez.value;
	}, // action
	labelWidth: 30,
	numberWidth: 40,
	unitWidth: 1
);


PopUpMenu(c, Rect(10, 155, 80, 20))
.items_(["piano", "shot", "toggle"])
.value_(folderRuleList[key][2])
.canFocus_(false)
.action_({ arg menu;
	folderRuleList[key][2] = menu.value;

});

};


writeSettings= { //write both setup and preferences? or have preferences override settings?
	var currentPrefs, savedText;
	
	//collect info
	applyStates= applyButtons.collect({|it, i|
		it.collect({|it|
			it.value;
		});
	});

	//check paths
	preferencesPath.postln;
	//make dir for keyboard if not existing (preferencesPath++name.string), declare at top
	preferencesFile.postln;
	//(preferencesPath++name.string++"PREFS").postln;	
	if(preferencesPath.isFolder.not, {preferencesPath.makeDir});
	
	//check 4 errors and SAVE
	if( (knobsCCArray++slidersCCArray++numKeysView.value++startKey++name).indexOf(nil).isNil, { 

		currentPrefs= [numKeysView.value, startKey.value, knobsCCArray, slidersCCArray, name.string, midiInPriority, midiOutPriority, backgroundColor, midichannel, folderNames, folderRuleList, applyStates, onoffStates];
	
		backup.value(preferencesFile);
		currentPrefs.writeArchive(preferencesFile);

		{ // confirmation text routine
		savedText= StaticText(w, Rect(180, 610, 150, 20)).string_(
		"Preferences saved!").background_(Color.green).align_(\center);
		2.wait;
		savedText.string= "";
		savedText.background_(Color(0.0, 0.0, 0.0, 0.0));
		Button(w, Rect(180, 610, 150, 20))
		.states_([["Restart", Color.black, Color.green]])
		.action_({
		thisProcess.recompile;
		});
		}.fork(AppClock);
		


	},{// Post Error Window
		SCAlert("some number is wrrrong", ["oh!"]);
	});
	
};

	backup= {|file|
		var filename, backupname, dir;
		dir= file.dirname;
		filename= file.basename;
		
		("dir:"+dir).postln;
		("file:"+file).postln;
		
		if (File.exists(file)) {
			backupname = filename ++ ".backup_" ++ Date.getDate.stamp;

			(file).moveTo(dir, backupname);
			("moved:"+file+"to"+(dir++backupname)).postln;
		};
	};

loadPreferences= {|file|
if(file.isFile, {
	preferences= Object.readArchive(file);

	numKeysView.value= preferences[0].asInteger;
	startKey.value= preferences[1];
	knobsCCArray= preferences[2]; numKnobsView.value= preferences[2].size;
	slidersCCArray= preferences[3]; numSlidersView.value= preferences[3].size;
	//name.string, = preferences[4];
	midiInPriority= preferences[5];
	midiOutPriority= preferences[6];
	midimenu.items.do({|it, i| if (it.contains(midiDevice), {midimenu.value_(i)}) });
	backgroundColor= preferences[7];
	colorPicker= ColorPicker.hsvMini(w, Rect(200, 420, 50, 50), backgroundColor, {|clr| backgroundColor= clr; }, true);
	if (preferences[8].isNil, {midichannel= 1}, {midichannel= preferences[8]});
	midichannelView.value= midichannel;
	if (preferences[9].isNil, {folderNames= Array.newClear(4)}, {folderNames= preferences[9]});
	folderNamesView.do({|it, i| it.string= folderNames[i]; it.align= \center; });
	if (preferences[10].isNil, {folderRuleList= defaultFolderRuleList;},{folderRuleList= preferences[10]});
	if (preferences[11].isNil.not, {applyStates= preferences[11]}, {applyStates= applyStatesDefault});
	applyButtons.do({|it, i| it.do({|itt, ii| itt.value= applyStates[i][ii]; }); });
	if (preferences[12].isNil.not, {onoffStates= preferences[12]}, {onoffStates= 0!4});
	onoffButtons.do({|it, i| it.value= onoffStates[i]});

	},{ "error reading preset file!".postln; });
};

CompositeView(w, Rect(10, 600, 830, 40))
.background_(Color(0.46268656716418, 0.47761194029851, 0.53731343283582, 1.0));


Button(w, Rect(20, 610, 150, 20))
.states_([["Save Preferences!", Color.black, Color(0.46268656716418, 0.86567164179104, 0.47761194029851, 1.0)]])
.action_({
	|v|
	writeSettings.value;
	savefilesWithPath= (preferencesPath++"/*").standardizePath.pathMatch;
	savefiles= savefilesWithPath.collect({|it| it.basename});
	loadmenu.items= savefiles;
	});



StaticText(w, Rect(330, 610, 180, 20))
.string_("Backed up preferences:");

savefilesWithPath= (preferencesPath++"/*").standardizePath.pathMatch;
savefiles= savefilesWithPath.collect({|it| it.basename});
loadmenu= PopUpMenu(w, Rect(460, 610, 340, 20))
.canFocus_(false)
.stringColor_(Color.green)
.items_( savefiles )
.action_({ |v|
	var menuitem;
	menuitem= v.items.at(v.value);
	//menuitem.postln;
	//savefilesWithPath[loadmenu.value].postln;
	//("menu size:"+loadmenu.items.size).postln;
	//("files size:"+savefiles.size).postln;
	//("loadmenu fileS:"+loadmenu.items).postcs;
	//("files fileS:"+savefilesWithPath).postcs;
});

Button(w, Rect(800, 610, 30, 20))
.canFocus_(false)
.states_([["L", Color.red, Color.black]])
.action_({ |v|
	("load preferences from:"+savefilesWithPath[loadmenu.value]).postln;
	loadPreferences.value(savefilesWithPath[loadmenu.value]);
});


w.front;
w.onClose= {
	cc1.remove; 
	cc.remove; 
	noteResponder.remove;
	~preferencesWindows.put(preferences[4].asSymbol, false);
	};
}
}

