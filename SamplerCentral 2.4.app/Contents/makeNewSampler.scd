(
var w, name, numberKeys, numKeysView, numFadersView, numKnobsView, numSlidersView;
var knobs, learnKnobs, numberOfKnobs, knobsCCArray;
var sliders, learnSliders, numberOfSliders, slidersCCArray;
var startKey;
var c, cc, noteResponder;
var midi, midimenu, midimenuitems, midiDevice, midiPortName, midistring;
var backgroundColor;
var settings, writeSettings;
var thisFilePath, settingsPath, documentPath;
var preferencesPath;
var knobsOK, slidersOK;
var savefilePath, backupfilePath;

~makeNewWindowOpen= true;

thisFilePath= (thisProcess.nowExecutingPath.standardizePath).dirname.standardizePath;
settingsPath= (thisFilePath++"/"++"Resources/SETTINGS/").standardizePath;
documentPath= (thisFilePath++"/"++"Resources/SAMPLERS/").standardizePath;
//savefilePath= (thisFilePath++"/"++"Resources/SAVEFILES/"++name.string).standardizePath;
backupfilePath= (savefilePath++"/_backup");


//[1, 2, 3].writeArchive(settingsPath++"uouo1");
//[1, 2, 3].writeArchive("/Users/martin/scwork/samplerProject/Sampler Central.app/Contents/Resources/SETTINGS/"++"uouo");

//settingsPath= Document.current.path.dirname++"/"++"Resources/SETTINGS/";
//documentPath= Document.current.path.dirname++"/"++"Resources/SAMPLERS/";

w= Window("setup new keyboard", Rect(0, 0, 400, 560));

//midi connect
MIDIClient.init;
MIDIIn.connectAll;

CompositeView(w, Rect(10, 10, w.bounds.width-20, w.bounds.height-20))
.background_(Color(0.76119402985075, 0.76119402985075, 0.76119402985075, 1.0));

//keyboard name
StaticText(w, Rect(20, 50, 100, 20))
.string_("Name:");
name= TextView(w, Rect(120, 50, 100, 20))
.font_(Font("Helvetica", 12));

//number of keys
StaticText(w, Rect(20, 80, 100, 20))
.string_("Number of keys:");
numKeysView= NumberBox(w, Rect(120, 80, 30, 20))
.step_(12)
.clipLo_(13)
.clipHi_(49);


//number of knobs
StaticText(w, Rect(20, 110, 100, 20))
.string_("Number of knobs:");
numKnobsView= NumberBox(w, Rect(120, 110, 30, 20)).action_({|v| numberOfKnobs= v.value});

//number of sliders
StaticText(w, Rect(20, 140, 100, 20))
.string_("Number of sliders:");
numSlidersView= NumberBox(w, Rect(120, 140, 30, 20)).action_({|v| numberOfSliders= v.value});

knobsOK= StaticText(w, Rect(100, 170, 150, 20)).string_("");

Button(w, Rect(20, 170, 70, 20))
.states_([["set knobs"], ["ok"]])
.action_({
	|v|
	if (v.value == 1, {learnKnobs.value; knobsOK.string_(""); }, {
		c.remove; knobs.do({|it| it.remove; }); w.refresh; 
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
		knobs[i]= Knob(w, Rect(10+(30*i), 200, 20, 20));
	});
	}.defer;
	
	c = CCResponder({ |src,chan,num,value|
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

slidersOK= StaticText(w, Rect(100, 230, 150, 20));

Button(w, Rect(20, 230, 70, 20))
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
		sliders[i]= Slider(w, Rect(20+(30*i), 260, 20, 40));
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
StaticText(w, Rect(20, 310, 220, 20))
.string_("Push lowest key on keyboard:");
startKey= NumberBox(w, Rect(190, 310, 30, 20))
.action_({
	|v|
	
});

Button(w, Rect(230, 310, 70, 20))
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

StaticText(w, Rect(20, 340, 100, 20)).string_("MIDI Input:");

midistring= StaticText(w, Rect(250, 360, 60, 20)).string_("");

midi= MIDIClient.sources;
//midimenuitems= midi.size.collect({|i|midi[i].asString.replace("MIDIEndPoint", "").drop(-1).drop(1); });
midimenuitems= midi.collect({|it| (it.asString.replace("MIDIEndPoint", "").drop(-1).drop(1)).tr($(,$[).tr($),$]); });

midimenuitems= ["select midi input..."]++midimenuitems;
midimenuitems.postln;
PopUpMenu(w, Rect(20, 360, 220, 20))
.items_(midimenuitems)
.action_({ |v|
if (v.value > 0, {
	v.items[v.value].postln;
	midiDevice= midi[v.value-1].device.postln;
	midiPortName= midi[v.value-1].name.postln;
	midistring.string_("OK").stringColor_(Color.green);
	},{
		midistring.string_("!").stringColor_(Color.red);
	});
});

if(midimenu.value == 0, { midistring.string_("!").stringColor_(Color.red); });



StaticText(w, Rect(20, 390, 200, 20))
.string_("Select background color:");
//ColorPicker.hsvMini(w, Rect(200, 390, 50, 50), Color.blue, {|clr| backgroundColor= clr; }, true);
ColorPicker.new(w, Point(10, 410), Color.blue, {|clr| backgroundColor= clr; }, true);



writeSettings= {
	var preferences, knobsSave, slidersSave;
	(settingsPath++name.string++"SETUP";).postln;
	
	savefilePath= (thisFilePath+/+"Resources/SAVEFILES/"++name.string).standardizePath;
	backupfilePath= (savefilePath++"/_backup");
	preferencesPath= (thisFilePath+/+"Resources/PREFERENCES/"++name.string).standardizePath;
	
	
	//if( (knobsCCArray++slidersCCArray++numKeysView.value++startKey++name).indexOf(nil).isNil, {
	if( [numKeysView.value, startKey, name].indexOf(nil).isNil, {
	savefilePath.makeDir;
	backupfilePath.makeDir;
	preferencesPath.makeDir;

	settings= [numKeysView.value, startKey.value, knobsCCArray, slidersCCArray, name.string, [[midiDevice, midiPortName], nil, nil], [nil, nil, nil], backgroundColor];
	settings.writeArchive(settingsPath++name.string++"SETUP"; );
	
	preferences= [numKeysView.value, startKey.value, knobsCCArray, slidersCCArray, name.string, [[midiDevice, midiPortName], nil, nil], [nil, nil, nil], backgroundColor, 0, nil!4, ([0.5, 0, 0, 0.01, 0.2, 0, 0, 3, 0, 0, nil, nil]!4).asList, ((0!12)!4), 0!4, 0];
	preferences.writeArchive(preferencesPath+/+name.string++"_CURRENT"; );

	
	//copy template with new name
	(thisFilePath++"/samplerTemplate.scd").copyTo(documentPath, name.string++".scd");
	StaticText(w, Rect(20, 530, 360, 25)).string_(
	"OK! Make sure you dont have any unsaved samplers running and push Restart").background_(Color.green);

	Button(w, Rect(180, 500, 150, 20))
	.states_([["Restart", Color.black, Color.green]])
	.action_({
	thisProcess.recompile;
	});
	
	},{
		//SCAlert
		SCAlert("some setting is missing", ["OK!"]); //maybe alert window!
	});

};
	

Button(w, Rect(20, 500, 150, 20))
.states_([["Save New Sampler!", Color.black, Color.green]])
.action_({
	|v|
	writeSettings.value;
	});
	



w.front;
w.onClose= {
	c.remove; 
	cc.remove; 
	noteResponder.remove;
	~makeNewWindowOpen= false;
	};
)

/*
w.bounds
a= [[23, 2],[]] // for folders with files to be routed specifically
a[1][222]

MIDIClient.sources.detectIndex({ |device| device.uid == nil})
MIDIIn.findPort("Oxygen 49", "Oxygen 49").uid
*/

/*
find directory of app
sense if its the first time it is run, make setup, or... have setup/install file???
	maybe even cooler, make an install app that makes the app! copies itself and then adds settings, icon
	or adds new keyboard to side menu.... YES. THROUGH MENU ITEM ON TOP
make my own save dialog so you cant save outside the dir
	change dirs, and go to backup
	
	reverse playback?
	
*/

