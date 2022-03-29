

(
s.waitForBoot{
var output;
var w, sizes, colors, colorsOn, textcolors;
var notes, on, off, a, c;
var sounds, properties;
var keyButs, propView;
var knobView1, knobView2, knobs1to4, knobs5to8, allKnobs;
var sliders, sliderView, ampspec, buffers;
var knobSounds, sliderSounds;
var midisrc, midisrcindex;
var loadmenu, savefiles, files, backup, menuitem, wrefresh;
var title;
var responders1, responders2;
var filesDir;
var stopnote, playnote;
var looppointeditor;
var killothernotes, panic, velocitystate;
var loadPreset;
var currentPresetPath;
var effectGroup, effView, revSynth;
var t;
var masterprop;
var dirbutton;
var extrasample= false, extrasampleView, soundsASR;
var outputs, defaultProperties;
var progressView, progress, progressViewClear, progressState;
var timer;
var space;
var loadASRsound;
var keyViews;
var bender, bend;
var speechout;
var record, recordInstantly;
var noteon, noteoff;
var midichannel; // remove midisendwindow
var recordingsPath;
var reloadSavefiles;
var errorFileMessage;
var keyboardName, numKeys, startKey;
var slidersCC, knobsCC;
var midiDevice, midiPortName;
var soundcard;
var document, settings, settingsPath, thisFilePath;
var windowHeight, keyHSize;
var backgroundColor;
var preferences, preferencesView, folderRouting;
var preferencesFile, preferencesPath;
var ruleFolderNames, rulesList, rulesApply, rulesOnOff;
var arpRoutines, arpView;
var ctrl, shift, alt;
var keyPitch= 1, sliderPitch= 1, knobPitch= 1;
var kaossFilesDir, fxDict;
var verbose= false;
var touchOSC;
var ipDict, robotDict, oscRoutines;
var midiOut, sendWindow, sendWinOpen, sendWinLastTabFocus= 0, sendWinLastPos;
var updatePreferenceButtons;
var keyboardPressDown= true!14;
var midiBut, oscBut, dmxBut, slPitchBut, knPitchBut, kyPitchBut, prViewBut;
var coyoteResponders, coyoteMidiResponders, midiRoutines;
var midiInPriority, midiOutPriority;
var keyUserViews, colorsOnUV;
var previousMIDIProgMsg, panHackSynth;
var robotPresetCheck, midiPresetCheck;
var keyPropLabels;
var builtin;
var panSynth, panKnob;
var noteArray;
var sequencer, seqIsOpen= false;


// =============================================================================================
// ======================================== SETTINGS ===========================================
// =============================================================================================

outputs= [nil, 0, 2, 4, 6, 8, 10, 12, 14, 16];
noteArray= ["(C 1)", "(C# 1)", "(D 1)", "(D# 1)", "(E 1)", "(F 1)", "(F# 1)", "(G 1)", "(G# 1)", "(A 1)", "(A# 1)", "(B 1)", "(C 2)", "(C# 2)", "(D 2)", "(D# 2)", "(E 2)", "(F 2)", "(F# 2)", "(G 2)", "(G# 2)", "(A 2)", "(A# 2)", "(B 2)", "(C 3)", "(C# 3)", "(D 3)", "(D# 3)", "(E 3)", "(F 3)", "(F# 3)", "(G 3)", "(G# 3)", "(A 3)", "(A# 3)", "(B 3)", "(C 4)", "(C# 4)", "(D 4)", "(D# 4)", "(E 4)", "(F 4)", "(F# 4)", "(G 4)", "(G# 4)", "(A 4)", "(A# 4)", "(B 4)"];

//============== from settings file: ===================

thisFilePath= thisProcess.nowExecutingPath.standardizePath.dirname.dirname;

keyboardName= thisProcess.nowExecutingPath.basename.drop(-4);
//(thisFilePath.standardizePath++"/"++"SETTINGS/"++keyboardName++"SETUP").postln;
//(thisFilePath.standardizePath.dirname++"/"++"SETTINGS/"++keyboardName++"SETUP").postln;
document= thisProcess.nowExecutingPath.basename.drop(-4);
settingsPath= (thisFilePath.standardizePath++"/"++"SETTINGS/"++keyboardName++"SETUP");

//settingsPath.postln;

settings= Object.readArchive(settingsPath);
//settings.postln;
numKeys= settings[0].asInteger;
startKey= settings[1];
knobsCC= settings[2];
slidersCC= settings[3];
//name.string, = settings[4];
//midiDevice= settings[5];
midiInPriority= settings[5];
//midiPortName= settings[6];
midiOutPriority= settings[6];
backgroundColor= settings[7];


//Preferences, Overrides settings if exists.
//folders routing preferences[] ?? folderRouting= preferences[];
//sampler recordings - preferences[] ?? midichannel= preferences[];
//preferences[] ?? midichannel = preferences[];
// ?? do if nil

preferencesPath= (thisFilePath.standardizePath++"/"++"PREFERENCES/"++keyboardName);
preferencesFile= (preferencesPath++"/"++keyboardName++"_CURRENT").standardizePath;
if (preferencesFile.isFile, {
	
	preferences= Object.readArchive(preferencesFile);
	//("preferences:"+preferences).postln;
	numKeys= preferences[0].asInteger;
	startKey= preferences[1];
	knobsCC= preferences[2];
	slidersCC= preferences[3];
	//name.string, = preferences[4];
	//midiDevice= preferences[5];
	midiInPriority= preferences[5];
	//midiPortName= preferences[6];
	midiOutPriority= preferences[6];
	backgroundColor= preferences[7];
	midichannel= preferences[8];
	ruleFolderNames= preferences[9];
	rulesList= preferences[10];
	rulesApply= preferences[11];
	rulesOnOff= preferences[12];
	output= outputs[preferences[13]];
});

progressState= 1;

// set output to 1+2 if built in soundcard is used
("output after preferences:"+output).postln;
if (s.options.outDevice.contains("Built-in"), {output= 0; builtin= false}, {builtin= true});

("MIDI IN PRIO"+midiInPriority).postln;
midiInPriority[0][0].class.postln;
("MIDI OUT PRIO"+midiOutPriority).postln;

/*
// test witout settingsfile
keyboardName= Document.current.path.basename.drop(-4);//settings[0]; //name also in dir etc
numKeys = 25;
startKey= 36;
slidersCC = [74, 71, 91, 93, 73, 72, 5, 84, 7];
knobsCC= [75, 76, 92, 95, 10, 77, 78, 79];
midichannel= 1;
midiDevice= "Oxygen 49";
midiPortName= "Oxygen 49";
//soundcard
//settingsPath = 
backgroundColor= Color.grey;
*/


case //calculate size
	{ numKeys <= 37 } {keyHSize = 20}
	{ numKeys <= 49 } {keyHSize = 15}
	{ numKeys > 49 } {keyHSize = 10};

	windowHeight=  (numKeys*keyHSize).clip(600, 935);

Platform.case(
	\osx,		{ ctrl= 262401; shift= 131330; alt= 524576; },
	\linux,		{ ctrl= 262144; shift= 131072; },
	\windows, 	{ "ERROR: havent tested this on Windows".postcs }
);

~preferencesWindows= ~preferencesWindows ?? Dictionary.new;
~preferencesWindows.put(keyboardName.asSymbol, false);
filesDir= (String.scDir.dirname ++ "/Resources/SAVEFILES/"++keyboardName++"/");
if(filesDir.isFolder.not, {filesDir.makeDir});
recordingsPath= "~/SamplerRecordings/";
if (recordingsPath.isFolder.not, { recordingsPath.makeDir });
if (output == nil, {output= 0});
kaossFilesDir= (String.scDir.dirname ++ "/Resources/KAOSSPADSAVES/");
//output= outputs[output];
if (midichannel == 0, {midichannel= nil;});

if (s.options.device == nil, {output = 0});


ipDict= (
	\fatBot: ["172.16.3.177", 8888],  
	\circleBot: ["172.16.3.178", 8888],
	\updownBot: ["172.16.3.180", 8888],
	\headBot: ["172.16.3.179", 8888]
	);
robotDict= ( // label, controlSpec, initValues ([on, off], type, duration)
	\fatBot: [\SR1, [0, 127, \lin, 1].asSpec, [[127, 95], 0, 0.3]], 
	\circleBot: [\SR1, [0, 127, \lin, 1].asSpec, [[100, 95], 0, 0.3]], 
	\updownBot: [\SR1, [0, 127, \lin, 1].asSpec, [[127, 90], 0, 0.3]],
	\headBot: [\SR1, [0, 127, \lin, 1].asSpec, [[127, 90], 0, 0.3]]
	);



// ================ MIDI INITIALIZATION ================

//midiInPriority= [["IAC Driver", "Bus 1"], nil, nil];
//midiInPriority[0]= midiDevice;
// connect midi in
midiInPriority.do({|it, i|
	if (it.isNil.not and: {midisrc.isNil}, {
		MIDIClient.sources.do({ |midiSource, i|
			//("it device:"+midiSource.device.asString).postln;
			//(midiSource).postln;
	
			if((midiSource.device).contains(it[0]) and: {midisrc.isNil}, {
				midisrc= midiSource.uid; 
				midisrcindex= i;
				("MIDI IN DEVICE:"+it[0]).postln;
				//(it.uid).postln;
				});
		});
	});
});

if (midisrc.isNil.not, {
		MIDIIn.connectByUID(0, midisrc);
	},{
		SCAlert("No MIDI Keyboard connected", ["OK!"]).focus(0);
		midisrc= nil; 
		midisrcindex= nil;
});

/*
// commented out 4 march 2013
MIDIClient.sources.do({ |it, i|
	("it device:"+it.device.asString).postln;
	(midiDevice).postln;
	
	if((it.device).contains(midiDevice), {
		midisrc= it.uid; 
		midisrcindex= i;
		"found midi source with DO!".postln;
		//(it.uid).postln;
		});
	});

{ midisrc= (MIDIIn.findPort(midiDevice, midiPortName).uid) }.try;
*/

//midisrcindex= 1;

/*
MIDIClient.sources.do({ |it, i|
	if(it.uid== midisrc, {midisrcindex= i});
	});
*/

//("LE midisource: "++MIDIClient.sources.at(midisrcindex).asString).postln;

//MIDIIn.connect(1, MIDIClient.sources.at(1));
//MIDIIn.connect;

/* 
// commented out 4 march 2013
if (midisrc.isNil.not, {
		MIDIIn.connectByUID(0, midisrc);
	},{
		SCAlert("No MIDI Keyboard connected", ["OK!"]);
		midisrc= nil; 
		midisrcindex= nil;
});

("MIDI source:"+midisrc.asString).postln;
("MIDI src index:"+midisrcindex.asString).postln;
*/

//midiOutPriority= [["IAC Driver", "Bus 1"], nil, nil];
// connect midi out
midiOutPriority.do({|it, i|
	if (it.isNil.not and: {midiOut.isNil}, {
		if (MIDIOut.findPort(it[0], it[1]).isNil.not, {
			("MIDI OUT DEVICE:"+it[0]).postln;
			midiOut= MIDIOut.newByName(it[0], it[1]);
		});
		/*
		MIDIClient.destinations.do({ |midiDestination, i|
			//("MIDI OUT device:"+midiDestination.device.asString).postln;
			//(it).postln;

			if((midiDestination.device.asString).contains(it[0]), {
				//midiDestination.device.postln; midiDestination.port.postln;
				midiOut= MIDIOut.newByName(it[0], it[1]);
				midiOut.latency= 0;
				"found midi DESTINATION and connected!".postln;
				//(it.uid).postln;
			});
		});
		*/
	});
});

/*
MIDIClient.destinations.do({ |it, i|
	//("MIDI OUT device:"+it.device.asString).postln;
	//(midiDevice).postln;
	
	if((it.device).contains(midiDevice), {
		//it.device.postln; it.port.postln;
		midiOut= MIDIOut.newByName("AudioFire12 (1576)", "Plug 1");
		midiOut.latency= 0;
		"found midi DESTINATION and connected!".postln;
		//(it.uid).postln;
		});
	});

*/	

//midiOut= MIDIOut.newByName("AudioFire12 (1576)", "Plug 1");
//midiOut.latency= 0;


// ================= ROBOT INIT ======================
/*
if (p.isNil, {
	SerialPort.devices.do({|it|
		if (it.asSymbol == '/dev/tty.usbserial-A7007bBi',
			{ "connecting arduino".postln;
				p = ArduinoSMS("/dev/tty.usbserial-A7007bBi", 115200);
		});
	});
});
*/

// make a button that is automatically off if no arduino / dmx is present

// ================= DMX INITIALIZATION ===============

if (~dmx.isNil, {
	SerialPort.devices.do({|it|
		if (it.asSymbol == '/dev/tty.usbserial-EN109012',
			{ "connecting dmx".postln;
				~dmx= DMX.new;
				//~dmx.device= EntTecDMXUSBPro.new( "/dev/tty.usbserial-EN109012" );
				~dmx.currentCue= DMXCue.new; //make into subcue....
				//~dmx.setCue;
				("DMX is:"+~dmx).postln;
				("DMX current cue is:"+~dmx.currentCue).postln;
		});
	});
});




//============= SAMPLER INIT =============


//a= RedDiskInSamplerGiga(s);
a= RedCombiSampler(s, 30); //threshold of seconds to read from disk instead of ram




sounds= Array.newClear(numKeys);
soundsASR= ([]!numKeys).asList;
properties= numKeys.collect({ [0.5, 0, 0, 0.01, 0.1, 0, 0, 3, 0, 0, nil, [0, [0, 0], [0, 0], 0, 0.3, 0], [0.1, 0.2, 0], [0, 0, 1], 1, [0, Dictionary.new], [0, [DMXSubCue.new, DMXSubCue.new]] ].asList });
defaultProperties= numKeys.collect({ [0.5, 0, 0, 0.01, 0.1, 0, 0, 3, 0, 0, nil, [0, [0, 0], [0, 0], 0, 0.3, 0], [0.1, 0.2, 0], [0, 0, 1], 1, [0, Dictionary.new], [0, [DMXSubCue.new, DMXSubCue.new]] ].asList });
knobSounds= nil!8;
sliderSounds= nil!8;
masterprop= (\poly: 0, \vel: 0, \midi: 0, \osc: 0, \dmx: 0, \slPitch: 0, \knPitch: 0, \kyPitch: 1, \prView: 1);
progress= []!numKeys;
timer = (0!numKeys).asList;
arpRoutines= (0!numKeys);
bend= 1;
coyoteResponders= Array.newClear(numKeys);
coyoteMidiResponders= Array.newClear(numKeys);
midiRoutines= Array.newClear(numKeys);
oscRoutines= Array.newClear(numKeys);

ampspec= ControlSpec( 0.001, 1.0,\amp);

sizes= [1, 0.7, 1, 0.7, 1, 1, 0.7, 1, 0.7, 1, 0.7, 1, ];

colors= [Color.new255(160, 255, 160), Color.black, Color.white, Color.black, Color.white, Color.white, Color.black, Color.white, Color.black, Color.white, Color.black, Color.white];

textcolors= [Color.black, Color.white, Color.black, Color.white, Color.black, Color.black, Color.white, Color.black, Color.white, Color.black, Color.white, Color.black];

colorsOn= [Color.yellow.alpha_(0), Color.new255(255, 165, 0).alpha_(0), Color.yellow.alpha_(0), Color.new255(255, 165, 0).alpha_(0), Color.yellow.alpha_(0), Color.yellow.alpha_(0), Color.new255(255, 165, 0).alpha_(0), Color.yellow.alpha_(0), Color.new255(255, 165, 0).alpha_(0), Color.yellow.alpha_(0), Color.new255(255, 165, 0).alpha_(0), Color.yellow.alpha_(0)];

colorsOnUV= [Color.yellow, Color.new255(255, 165, 0), Color.yellow, Color.new255(255, 165, 0), Color.yellow, Color.yellow, Color.new255(255, 165, 0), Color.yellow, Color.new255(255, 165, 0), Color.yellow, Color.new255(255, 165, 0), Color.yellow];



// =============================================================================================
// ===================================== MIDI RESPONDERS =======================================
// =============================================================================================



noteon= NoteOnResponder({ |src,chan,note,vel|
	var num, event= nil;
	//[src,chan,note,vel].postln;
	note= note-startKey;
	if(note.inRange(0, (numKeys-1)), {
		num= sounds[note];
		if(verbose, {("snd"++((note).asString)).postln;});
		if (velocitystate == 1, { vel= vel/127 }, {vel = nil});
		playnote.value(event, num, note, vel);
	},
	{"key out of range".postln;});
	},
	midisrc, // source
	midichannel // channel
	);

noteoff= NoteOffResponder({ |src,chan,note,vel|
	var num;
	//[src,chan,note,vel].postln;
	note= note-startKey;
		if(note.inRange(0, (numKeys-1)), {
			num= sounds[note];
			stopnote.value(num, note);
		},
		{"key out of range".postln;});
	},
	midisrc, // source
	midichannel // channel
	);
	

// =============================================================================================
// ======================================== NOTE ON ============================================
// =============================================================================================

//remove event
playnote= {|event, num, key, vel, id, dur|
	var amp, seq= 4, out, asrName;
	
	if(masterprop[\osc] == 1, { 
		properties[key][15][1].keysValuesDo({|robot, value|
			if (value[1] == 1, { id= key });
		});
	});

	if (num.isNil.not, {
		
		if (properties[key][10].isNil.not && builtin, {out= properties[key][10] }, {
			if (sounds[key].contains(folderRouting), //speech
				{ "speaking".postln; out= speechout; }, { out= output;  });
			});
		if( vel.isNil, {amp = properties[key][0]}, {amp= vel});
		if( properties[key][5] == 1,{{killothernotes.value(key)}.try}); //killa
		case
		{properties[key][2] == 0} //playback mode piano (default)
		{
			a.play(("snd"++((key).asString)).asSymbol, 
				amp: amp,
				loop: properties[key][1],
				attack: properties[key][3],
				sustain: dur,
				pan: properties[key][9],
				speed: properties[key][14] * bend,
				offset: properties[key][13][0],
				startLoop: properties[key][13][1],
				endLoop: properties[key][13][2],
				id: id,
				out: out
			);
			//id.postln;
			if (progressState == 1, {progressView.value(key)});
			{ keyButs[key].value= 1; }.defer;
		}
		{properties[key][2] == 1} //playback mode one shot
		{a.play(("snd"++((key).asString)).asSymbol, 
				amp: amp,
				loop: 0,
				attack: properties[key][3],
				sustain: dur,
				pan: properties[key][9],
				speed: properties[key][14] * bend,
				offset: properties[key][13][0],
				out: out
			);
		{ keyButs[key].value= 1; }.defer;
		}
		{properties[key][2] == 2} //playback mode toggle
		{ 
			case 
			{a.isPlaying(("snd"++((key).asString)).asSymbol) == false} 
			{a.play(("snd"++((key).asString)).asSymbol, 
				amp: amp,
				loop: properties[key][1],
				attack: properties[key][3],
				sustain: dur,
				pan: properties[key][9],
				speed: properties[key][14] * bend,
				offset: properties[key][13][0],
				startLoop: properties[key][13][1],
				endLoop: properties[key][13][2],
				id: id,
				out: out );
				//"it is not playing".postln;
				{ keyButs[key].value= 1; }.defer;
				if (progressState == 1, {progressView.value(key)});
			}
			{a.isPlaying(("snd"++((key).asString)).asSymbol)}
			{stopnote.value(num, key, 1); { keyButs[key].value= 0; }.defer; };
		}
		{properties[key][2] == 3} //3 samples ASR
		{ 
		a.play(("snd"++((key).asString++"a")).asSymbol, //attack sound
				amp: amp,
				loop: 0,
				attack: 0.01,
				sustain: dur,
				pan: properties[key][9],
				speed: properties[key][14] * bend,
				offset: properties[key][13][0],
				out: out
			);	
		a.play(("snd"++((key).asString)).asSymbol, //looped sound
				amp: amp,
				loop: 1,
				attack: properties[key][3],
				sustain: dur,
				pan: properties[key][9],
				speed: properties[key][14] * bend,
				offset: properties[key][13][0],
				out: out
			);
			("key playnote"+key).postln;
			{ keyButs[key].value= 1; }.defer;
		}
		{properties[key][2] == 4} //2 samples 
		{ 
			if(properties[key][8] == 0, { //shot
				a.stop(("snd"++((key).asString++"x0")).asSymbol, properties[key][4]);
			});
			a.play(("snd"++((key).asString)).asSymbol, 
				amp: amp,
				loop: properties[key][1],
				attack: properties[key][3],
				sustain: dur,
				pan: properties[key][9],
				speed: properties[key][14] * bend,
				offset: properties[key][13][0],
				out: out
			);
			{ keyButs[key].value= 1; }.defer;
		}
		{properties[key][2] == 5} //5 samples 
		{ //"trying to play...".postln;
			if(properties[key][6] == 0, { //sequence
				if ((Date.getDate.bootSeconds.round(1) - timer[key]) > 5, {properties[key][7] = nil;});
				if (properties[key][7].isNumber.not, {properties[key][7]= 0});
				a.play(("snd"++((key).asString++"x"++(properties[key][7].asString))).asSymbol, 
				amp: amp,
				loop: properties[key][1],
				attack: properties[key][3],
				sustain: dur,
				pan: properties[key][9],
				speed: properties[key][14] * bend,
				offset: properties[key][13][0],
				out: out
				);
				asrName= soundsASR[key][properties[key][7]].basename.removeExtension;
				{ keyButs[key].states= ([[asrName, textcolors[key.wrap(0, 12);], colors[key.wrap(0, 12);]], [asrName, Color.black, colorsOn[key.wrap(0, 12)]] ]); 
					//key.deepCopy.wrap(0, 12).postln; 
					//key.postln; 
					}.defer;
				properties[key][7]= (properties[key][7]+1).deepCopy.wrap(0, (soundsASR[key].size-1));
				//timer[key] = Date.getDate.bootSeconds.round(1);

			});			
			if(properties[key][6] == 1, { //random
				properties[key][7]= ("snd"++((key).asString++"x"++((soundsASR[key].size.rand).asString))).asSymbol;
				//properties[key][7].postln;
				a.play(properties[key][7], 
					amp: amp,
					loop: properties[key][1],
					attack: properties[key][3],
					sustain: dur,
					pan: properties[key][9],
					speed: properties[key][14] * bend,
					offset: properties[key][13][0],
					out: out
				);
			});
			if(properties[key][6] == 2, { // no reset
				//if ((Date.getDate.bootSeconds.round(1) - timer[key]) > 5, {properties[key][7] = nil;});
				if (properties[key][7].isNumber.not, {properties[key][7]= 0});
				a.play(("snd"++((key).asString++"x"++(properties[key][7].asString))).asSymbol, 
				amp: amp,
				loop: properties[key][1],
				attack: properties[key][3],
				sustain: dur,
				pan: properties[key][9],
				speed: properties[key][14] * bend,
				offset: properties[key][13][0],
				out: out
				);
				asrName= soundsASR[key][properties[key][7]].basename.removeExtension;
				{ keyButs[key].states= ([[asrName, textcolors[key.wrap(0, 12);], colors[key.wrap(0, 12);]], [asrName, Color.black, colorsOn[key.wrap(0, 12)]] ]); 
					//key.deepCopy.wrap(0, 12).postln; 
					//key.postln; 
					}.defer;
				properties[key][7]= (properties[key][7]+1).deepCopy.wrap(0, (soundsASR[key].size-1));
				//timer[key] = Date.getDate.bootSeconds.round(1);

			});		
			{ keyButs[key].value= 1; }.defer;
		}
		{properties[key][2] == 6} //ARPEGGIO
		{
			case 
			{arpRoutines[key].isPlaying.not}
			{
			arpRoutines[key]= {
			var length=0.3, timeToNext=0.1;
			loop{
			length= properties[key][12][0];
			timeToNext= properties[key][12][1];
			a.play(("snd"++((key).asString)).asSymbol, 
			amp: amp,
			loop: 0,
			attack: properties[key][3],
			sustain: dur,
			pan: properties[key][9],
			speed: properties[key][14] * bend,
			offset: properties[key][13][0],
			out: out
			);
			length.wait;
			a.stop(("snd"++((key).asString)).asSymbol, properties[key][4]);
			timeToNext.wait;
			};
			}.fork;
			{ keyButs[key].value= 1; }.defer;
			}
			{arpRoutines[key].isPlaying}
			{arpRoutines[key].stop;
				a.stop(("snd"++((key).asString)).asSymbol, properties[key][4]);
				{ keyButs[key].value= 0; }.defer;};
		};	
	});
	//{ keyButs[key].value= 1; }.defer;
	if( ~logfile.isNil.not, { {~logfile.write(Date.getDate.hourStamp.asString+(sounds[key].basename)++"\n")}.defer; });
	
	//SEND MIDIOUT SYSEX
	if(masterprop[\midi] == 1, {
	if(midiOut.isNil.not, {
		if(properties[key][11][0] == 1, {
			//("midiprops:"+properties[key][11]).postln;
				//midiOut.control(1, properties[key][11][0], properties[key][11][1]) ;
				//p.send($w, $a, 0, properties[key][11][0])
				case 
				{properties[key][11][3] == 0} {	// ------ play single value ------
					case
					{properties[key][11][5] == 0} { // submaster
						//midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][1][0], 0x00, properties[key][11][1][1], 0x00, 0xf7]);
						midiOut.sysex(ETCEonSysex.submaster(1, properties[key][11][1][0], properties[key][11][1][1]));
					}
					{properties[key][11][5] == 1} { // macro
					//midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x07, properties[key][11][1][0], 0xf7]);
						midiOut.sysex(ETCEonSysex.macro(1, properties[key][11][1][0]));
					}
					{properties[key][11][5] == 2} { // go cue
						midiOut.sysex(ETCEonSysex.goCue(1, properties[key][11][1][0], properties[key][11][1][1]));
					}
					{properties[key][11][5] == 3} { // grandmaster
						midiOut.sysex(ETCEonSysex.grandmaster(1, properties[key][11][1][1]));
					};
				}
				{properties[key][11][3] == 1} {	// ------ play onset detection ------
					case
					{properties[key][11][5] == 0} { // submaster
						if(coyoteMidiResponders[key].isNil.not, {coyoteMidiResponders[key].remove});
						coyoteMidiResponders[key] = OSCresponderNode(s.addr, '/tr', { arg t, r, msg;
							if (msg[2] == id, {
							{
							//midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][1][0], 0x00, properties[key][11][1][1], 0x00, 0xf7]);
							midiOut.sysex(ETCEonSysex.submaster(1, properties[key][11][1][0], properties[key][11][1][1]));
							properties[key][11][4].wait; //duration.wait....
							//midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][2][0], 0x00, properties[key][11][2][1], 0x00, 0xf7]);
							midiOut.sysex(ETCEonSysex.submaster(1, properties[key][11][2][0], properties[key][11][2][1]));
						}.fork;
				Ê 	Ê 	//[t, msg].postln;
						});
						}).add;
					}
					{properties[key][11][5] == 1} { // macro
					nil
					}
					{properties[key][11][5] == 3} { // grandmaster
					nil
					};
				}
				
				{properties[key][11][3] == 2} {	// ------ play sequence ------
					midiRoutines[key]= Routine{
						var waitTimes;
						waitTimes= properties[key][11][1][1][0].collect({|it, i|
							case
							{i == 0} { properties[key][11][1][1][0][i+1]-properties[key][11][1][1][0][i] *properties[key][11][4].round(0.01) }
							{i == (properties[key][11][1][1][0].size-1)} { ((properties[key][11][1][1][0][i]-1).abs*properties[key][11][4]).round(0.01) }
							{i > 0} { ((properties[key][11][1][1][0][i+1]-properties[key][11][1][1][0][i])*properties[key][11][4]).round(0.01) }
							});
						loop{
							properties[key][11][1][1][0].do({|it, i|

								//"do I get here?".postln;
								//("whats is this:"+properties[key][11][1][1][1][i]).postln;
								//("set value:"+(properties[key][11][1][1][1][i]*100)).postln;
								// insert alternatives case here
								case
								{properties[key][11][5] == 0} { // submaster
									midiOut.sysex(ETCEonSysex.submaster(1, properties[key][11][1][0], properties[key][11][1][1][1][i]*100)); }
								{properties[key][11][5] == 1} { // macro
									nil
								}
								{properties[key][11][5] == 3} { // grandmaster
									midiOut.sysex(ETCEonSysex.grandmaster(1, properties[key][11][1][1][1][i]*100));
								};
								
																				if(i == (properties[key][11][1][1][0].size-1), {
								((properties[key][11][1][1][0][i]-1).abs*properties[key][11][4]).wait; //*durationView.value
								},{
									("waiting for:"+(waitTimes[i]).asString+"secs").postln;
								(waitTimes[i]).wait;
								});
								
								});
							}
					}.play(AppClock);
				};
		});
	});
	});
	
	//SEND OSC
	if(masterprop[\osc] == 1, {
	if( properties[key][15][0] == 1, {
		properties[key][15][1].keysValuesDo({|robot, value|
			case 
			{value[1] == 0} {	// play single value
				("Note on OSC:"+[robot, robotDict[robot][0], value[0][0]]).postln;
				NetAddr(ipDict[robot][0], ipDict[robot][1]).sendMsg(
					robotDict[robot][0]++value[0][0]);
			}
			{value[1] == 1} { //play onset detection
				if(coyoteResponders[key].isNil.not, {coyoteResponders[key].remove});
				coyoteResponders[key] = OSCresponderNode(s.addr, '/tr', { arg t, r, msg;
					if (msg[2] == id, {
					{
						NetAddr(ipDict[robot][0], ipDict[robot][1]).sendMsg(
					robotDict[robot][0]++value[0][0]);
						0.3.wait; //duration.wait....
						NetAddr(ipDict[robot][0], ipDict[robot][1]).sendMsg(robotDict[robot][0]++value[0][1]);
					}.fork;
				Ê Ê 	[t, msg].postln;
					});
				}).add;
			}
			{value[1] == 2} { // play sequence
				oscRoutines[key]= Routine{
					loop{
						value[0][0].do({|it, i|
							if(i == (value[0][0].size-1), {
							((value[0][0][i]-1).abs*value[2]).wait; //*durationView.value
							},{
								("waiting for:"+(value[0][0][i]).asString+"secs").postln;
							(it*value[2]).wait;
							});
							NetAddr(ipDict[robot][0], ipDict[robot][1]).sendMsg(robotDict[robot][0]++((value[0][1][i]*100).floor));
							value[0][1][i].postln;
							});
						}
				}.play(AppClock);
			};
		});
	});
	});
	
	//SEND DMX
	//("DMX props:"+properties[key][16]).postln;
	if(masterprop[\dmx] == 1, {
	if( ~dmx.isNil.not, {
		if( properties[key][16][0] == 1, {
			//("Sending DMX note ON:"+properties[key][16][1][0].data).postln;
			//~dmx.fade(properties[key][16][1][0], 0.1, 'linear', 0.1);
			properties[key][16][1][0].data.keysValuesDo({|chan, val|
				("chan:"+chan+"val:"+val).postln;
				NetAddr("127.0.0.1", 6666).sendMsg("dmx", chan, val*100);
			});
		});
	});
	});
	
};


// =============================================================================================
// ======================================== NOTE OFF ===========================================
// =============================================================================================

stopnote= {| num, key, forcestop, id|
	if (num.isNil.not, {
		
			//if(masterprop[\osc] == 1, { id= key }); //test
			
		case
		{properties[key][2] == 0} { 
			if(properties[key][8] == 0, { //shot
				a.stop(("snd"++((key).asString)).asSymbol, properties[key][4]);
			});
			{ keyButs[key].value= 0;
				if (progressState == 1, {
					progress[key].stop; 
					progressViewClear.value(key) 
				});
				}.defer; 
		}
		{properties[key][2] == 3} { // 3 samples ASR
			a.stop(("snd"++((key).asString)).asSymbol, properties[key][4]);
			a.play(("snd"++((key).asString++"x1")).asSymbol, //release sound
				amp: properties[key][0],
				loop: 0,
				out: output
			);
			{ keyButs[key].value= 0; }.defer;
		}
		{properties[key][2] == 4} { //2 samples - noteon/noteoff
			if(properties[key][8] == 0, { //shot
				a.stop(("snd"++((key).asString)).asSymbol, properties[key][4]);
			});
			a.play(("snd"++((key).asString++"x0")).asSymbol, //release sound
				amp: properties[key][0],
				loop: 0,
				out: output
			);
			{ keyButs[key].value= 0; }.defer;
		}
		{properties[key][2] == 5} { //many samples
			if(properties[key][8] == 0, { // ---- if its not shot:
				if(properties[key][6] == 0, { //sequence
					//a.stop(("snd"++((key).asString++"x"++(properties[key][7].asString))).asSymbol, properties[key][4]);
					timer[key] = Date.getDate.bootSeconds.round(1);
					a.stop(("snd"++((key).asString++"x"++(((properties[key][7]-1).wrap(0, (soundsASR[key].size-1))).asString))).asSymbol, properties[key][4]);
				{ keyButs[key].states= ([[soundsASR[key][properties[key][7]].basename.removeExtension, textcolors[key.wrap(0, 12);], colors[key.wrap(0, 12);]], [soundsASR[key][properties[key][7]].basename.removeExtension, Color.black, colorsOn[key.wrap(0, 12)]] ]) }.defer;
				});
				if(properties[key][6] == 1, { //random
				a.stop(properties[key][7], properties[key][4]);
				});
				if(properties[key][6] == 2, { //sequence
					//a.stop(("snd"++((key).asString++"x"++(properties[key][7].asString))).asSymbol, properties[key][4]);
					//timer[key] = Date.getDate.bootSeconds.round(1);
					a.stop(("snd"++((key).asString++"x"++(((properties[key][7]-1).wrap(0, (soundsASR[key].size-1))).asString))).asSymbol, properties[key][4]);
				{ keyButs[key].states= ([[soundsASR[key][properties[key][7]].basename.removeExtension, textcolors[key.wrap(0, 12);], colors[key.wrap(0, 12);]], [soundsASR[key][properties[key][7]].basename.removeExtension, Color.black, colorsOn[key.wrap(0, 12)]] ]) }.defer;
				});
			},{ // ------------------------------ if its not shot:
			if(properties[key][6] == 0, { //sequence
					//a.stop(("snd"++((key).asString++"x"++(properties[key][7].asString))).asSymbol, properties[key][4]);
					timer[key] = Date.getDate.bootSeconds.round(1);
					//a.stop(("snd"++((key).asString++"x"++(((properties[key][7]-1).wrap(0, (soundsASR[key].size-1))).asString))).asSymbol, properties[key][4]);
				{ keyButs[key].states= ([[soundsASR[key][properties[key][7]].basename.removeExtension, textcolors[key.wrap(0, 11);], colors[key.wrap(0, 11);]], [soundsASR[key][properties[key][7]].basename.removeExtension, Color.black, colorsOn[key.wrap(0, 11)]] ]) }.defer;
				});
			if(properties[key][6] == 2, { //sequence
					//a.stop(("snd"++((key).asString++"x"++(properties[key][7].asString))).asSymbol, properties[key][4]);
					//timer[key] = Date.getDate.bootSeconds.round(1);
					//a.stop(("snd"++((key).asString++"x"++(((properties[key][7]-1).wrap(0, (soundsASR[key].size-1))).asString))).asSymbol, properties[key][4]);
				{ keyButs[key].states= ([[soundsASR[key][properties[key][7]].basename.removeExtension, textcolors[key.wrap(0, 11);], colors[key.wrap(0, 11);]], [soundsASR[key][properties[key][7]].basename.removeExtension, Color.black, colorsOn[key.wrap(0, 11)]] ]) }.defer;
				});
	
			});

			
			{ keyButs[key].value= 0; }.defer;
		}
		{properties[key][2] == 6} //ARPEGGIO
		{
			if(properties[key][12][2]==0,
			{
			arpRoutines[key].stop;
			a.stop(("snd"++((key).asString)).asSymbol, properties[key][4]);
			{ keyButs[key].value= 0; }.defer;
			});
			
			
		};

		if(forcestop.isNil.not, { 
			a.stop(("snd"++((key).asString)).asSymbol, properties[key][4]); 
			{ keyButs[key].value= 0; }.defer;
			if (progressState == 1, {
					progress[key].stop; 
					progressViewClear.value(key) 
			});
			//"hva skjer a?".postln;
		});	
	},{
		{ keyButs[key].value= 0; }.defer; });
		
	//SEND MIDI SYSEX
	//if( properties[key][11].isNilNot, { midiOut.control(1, properties[key][11][0], 0) });
	if(masterprop[\midi] == 1, {
		if(properties[key][11][0] == 1, {
			if(midiOut.isNil.not, {
				if( properties[key][11][2].isNil.not, { 
					//midiOut.control(1, properties[key][11][0], properties[key][11][0]) ;
					//p.send($w, $a, 0, 55)
					//("sending midi on note OFF"+properties[key][11][2]).postln;
					//midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][2][0], 0x00, properties[key][11][2][1], 0x00, 0xf7]);
				case 
				{properties[key][11][3] == 0} {	// ------ stop single value ------
					case
					{properties[key][11][5] == 0} { // submaster
						//midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][2][0], 0x00, properties[key][11][2][1], 0x00, 0xf7]);
						midiOut.sysex(ETCEonSysex.submaster(1, properties[key][11][2][0], properties[key][11][2][1]));
					}
					{properties[key][11][5] == 1} { // macro
					nil
					}
					{properties[key][11][5] == 2} { // go cue
					nil
					}
					{properties[key][11][5] == 3} { // grandmaster
					//midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, 0x7e, 0x03, properties[key][11][2][1], 0x00, 0xf7]);
					midiOut.sysex(ETCEonSysex.grandmaster(1, properties[key][11][2][1]));
					};
				}
				{properties[key][11][3] == 1} {	// ------ stop onset detection ------
					case
					{properties[key][11][5] == 0} { // submaster
						coyoteMidiResponders[key].remove;
						//midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][2][0], 0x00, properties[key][11][2][1], 0x00, 0xf7]);
						midiOut.sysex(ETCEonSysex.submaster(1, properties[key][11][2][0], properties[key][11][2][1]));
					}
					{properties[key][11][5] == 1} { // macro
					coyoteMidiResponders[key].remove;
					}
					{properties[key][11][5] == 3} { // grandmaster
					coyoteMidiResponders[key].remove;
					//midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, 0x7e, 0x03, properties[key][11][2][1], 0x00, 0xf7]);
					midiOut.sysex(ETCEonSysex.grandmaster(1, properties[key][11][2][1]));
					};
				}
				
				{properties[key][11][3] == 2} {	// ------ stop sequence ------
					midiRoutines[key].stop;
					//midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][2][0], 0x00, properties[key][11][2][1], 0x00, 0xf7]);
					case
					{properties[key][11][5] == 0} { // submaster
						midiOut.sysex(ETCEonSysex.submaster(1, properties[key][11][2][0], properties[key][11][2][1])); }
					{properties[key][11][5] == 3} { // grandmaster
					midiOut.sysex(ETCEonSysex.grandmaster(1, properties[key][11][2][1]));
					};
				};

				});			
			});
		});
	});
	//SEND OSC
	if(masterprop[\osc] == 1, {
		if( properties[key][15][0] == 1, {
			properties[key][15][1].keysValuesDo({|robot, value|
				if( value[1] == 2, {oscRoutines[key].stop});
				if (value[1] == 1, { coyoteResponders[key].remove });
				NetAddr(ipDict[robot][0], ipDict[robot][1]).sendMsg(robotDict[robot][0]++value[0][1]);
				("Note off OSC:"+[robot, robotDict[robot][0], value[0][1]]).postln;
				 //a NetAddr .send(properties[key][15][1], properties[key][15][2][0]);
			});
			coyoteResponders.postln;
		});
	});
	//SEND DMX
	if(masterprop[\dmx] == 1, {
		if( ~dmx.isNil.not, {
			if( properties[key][16][0] == 1, { 
				//~dmx.fade(properties[key][16][1][1], 0.5, 'linear', 0.1)
				properties[key][16][1][1].data.keysValuesDo({|chan, val|
					("chan:"+chan+"val:"+val).postln;
					NetAddr("127.0.0.1", 6666).sendMsg("dmx", chan, val*100);
				});		});
		});
	});
};





	backup= {|file|
		var filename, backupname, backupdir, dir;
		file= file.basename;
		dir= filesDir;
		backupdir= dir++"backup/";
		
		if (File.exists(dir++file)) {
			if(backupdir.isFolder.not, {backupdir.makeDir});
			
			backupname = file ++ ".backup_" ++ Date.getDate.stamp;
			
			(dir++file).moveTo(dir++"backup/", backupname)

		};
		
	};


// =============================================================================================
// ================================= GUI - LOAD / SAVE =========================================
// =============================================================================================


w= Window.new(keyboardName, Rect(0, 0, 610, 935));
w.view.background_(backgroundColor);

/*
Button.new(w, Rect(20, 20, 50, 20))
.states_([["on", Color.black, Color.grey], ["on", Color.black, Color.green]])
.value_(1)
.action_({ | v |
	if (v.value == 1, 
	{on.play; off.play}, 
	{on.stop; off.stop});	
});
*/

Button.new(w, Rect(20, 20, 60, 20))
.states_([["setup", Color.white, Color.black]])
.action_({ | v |
	if(~preferencesWindows[keyboardName.asSymbol] == false, {
		preferencesView.value();
		~preferencesWindows.put(keyboardName.asSymbol, true);
	});
});


title= StaticText(w, Rect(80, 20, 120, 20))
.background_(Color.grey.alpha_(0.3));

Button(w, Rect(260, 50, 30, 20))
.states_([["S"]])
.canFocus_(false)
.action_({
//save preset
var w, t, saveBut;
	w= Window("save", Rect(400, 400, 300, 100))
	.alwaysOnTop_(true);

	t= TextView(w, Rect(10, 10, 280, 20))
	.focus(true)
	.keyDownAction_({|view, char, mod, uni, key|
		if(key == 36, { saveBut.valueAction= 1 });
	});

	saveBut= Button(w, Rect(10, 40, 100, 40))
	.states_([["save"]])
	.action_({
		var values, path, stringSize;
		stringSize= t.string.size;
		if (stringSize > 0, {
			
			path= filesDir++(t.string);
			backup.value(path);
			knobSounds= allKnobs.collect({ |it, i|
				{it.getValues}.try;
			});
			
			sliderSounds= sliders.collect({ |it, i|
				{it.getValues}.try;
			});

			values= [sounds, properties, knobSounds, sliderSounds, soundsASR, masterprop];
			values.writeArchive(path);
			currentPresetPath= path;
			dirbutton.doAction;
			title.string= path.basename;
			title.align= \center;
			reloadSavefiles.value;
			w.close;
		});

		
	});
	
	Button(w, Rect(120, 40, 100, 40))
	.states_([["cancel"]])
	.action_({
		w.close;
	});

	w.front;
	
/*
	CocoaDialog.savePanel({ arg path;
		var values;
		backup.value(path);
		knobSounds= allKnobs.collect({ |it, i|
			{it.getValues}.try;
		});

		values= [sounds, properties, knobSounds, nil, soundsASR];
		values.writeArchive(path);
		currentPresetPath= path;
		//dirbutton.doAction;
		title.string= path.basename;
		

	},{
		"cancelled".postln;
	});
	*/
});



reloadSavefiles= {
	files= (filesDir++"*").standardizePath.pathMatch;
	savefiles= files.addFirst("none");
	files= files.addFirst("none");
	savefiles= savefiles.collect({|it| it.basename});
	loadmenu.items= ( savefiles );
};


files= (filesDir++"*").standardizePath.pathMatch;
savefiles= files.addFirst("none");
files= files.addFirst("none");
savefiles= savefiles.collect({|it| it.basename});
loadmenu= PopUpMenu(w, Rect(80, 50, 120, 30))
.canFocus_(false)
.stringColor_(Color.green)
.background_(Color.grey.alpha_(0.5))
.items_( savefiles )
.action_({ |v|
	menuitem= v.items.at(v.value);
	//menuitem.postln;
	//files[loadmenu.value].postln;
	//("menu size:"+loadmenu.items.size).postln;
	//("files size:"+files.size).postln;
	//("loadmenu fileS:"+loadmenu.items).postcs;
	//("files fileS:"+files).postcs;
});
menuitem= "none";

StaticText(w, Rect(20, 50, 60, 15))
.string_("Presets:")
.background_(Color.grey.alpha_(0.5))
.align_(\center);
//.font_(Font("Monaco", 9));

dirbutton= Button(w, Rect(20, 65, 60, 15))
.canFocus_(false)
.states_([["saves"], ["backup"] ])
.font_(Font("Helvetica", 9))
.action_({ |v|
	var directory;
	if (v.value == 1, {
		directory= filesDir++"backup/"; 
		},{
		directory= filesDir;
	});
	files= (directory++"*").standardizePath.pathMatch;
	savefiles= files.addFirst("none");
	files= files.addFirst("none");
	savefiles= savefiles.collect({|it| it.basename});
	loadmenu.items= savefiles;
});

wrefresh= { {2.wait; {w.refresh}.defer }.fork };

Button(w, Rect(200, 50, 30, 20))
.canFocus_(false)
.states_([["L", Color.red, Color.black]])
.action_({ |v|
		var values, file, oldPropSize, shaveCheck;
		if (menuitem == "none" or: {menuitem == "backup"}, {nil}, {
		a.free;
		//t.view.remove;
		c.remove;
		//("loading"+files[loadmenu.value]).postln;
		//values= Object.readArchive(files[loadmenu.value]);
		currentPresetPath= filesDir++loadmenu.item;
		("loading"+(filesDir++loadmenu.item)).postln;
		values= Object.readArchive((filesDir++loadmenu.item));
		values.postcs;
		sounds= values[0];
		properties= values[1];
		if(values[4].isNil.not, {soundsASR= values[4]},{
			soundsASR= ([]!numKeys).asList;
		});
		if (values[5].isNil.not, {masterprop= values[5].deepCopy});
		updatePreferenceButtons.value;
		//free all previous buffers
		//load new buffers
		numKeys.do({ |i|
			var check;
			check= sounds[i];
			if (check.isNil.not, {
				if (File.exists(sounds[i]), {
			file= sounds[i].basename.replace(".wav", "");
			a.prepareForPlay(("snd"++i.asString).asSymbol, sounds[i]);
			soundsASR[i].size.do({ |it, ii|
				if(soundsASR[i][ii].isNil.not, {
					a.prepareForPlay(("snd"++i.asString++"x"++(ii.asString)).asSymbol, soundsASR[i][ii]); ("asr"+ii).postln;
				});
			});
			{keyButs[i].states= ([[file, textcolors[i.wrap(0, 11)], colors[i.wrap(0, 11)]], [file, Color.black, colorsOn[i.wrap(0, 11)]] ]);}.defer;
				},{
					("warning"+sounds[i]+"does not exist").postln;
					sounds[i]= nil; 
					{keyButs[i].states= ([["", textcolors[i.wrap(0, 11)], colors[i.wrap(0, 11)]], ["", textcolors[i.wrap(0, 11)], colorsOn[i.wrap(0, 11)]]]);}.defer;
					});
				}, {
			{keyButs[i].states= ([["", textcolors[i.wrap(0, 11)], colors[i.wrap(0, 11)]], ["", textcolors[i.wrap(0, 11)], colorsOn[i.wrap(0, 11)]]]);}.defer;
			});
		});
		allKnobs.do({ |it, i|
			{it.setValues(values[2][i])}.try
		});
		sliders.do({ |it, i|
			{it.setValues(values[3][i])}.try
		});

		
		title.string= menuitem;
		title.align= \center;

		wrefresh.value;
		
		// shave buggy values from previous samplers... ugh!
		shaveCheck= properties.collect({|it|
			it.size;
		});
		if( shaveCheck.sort.first != shaveCheck.sort.last, {
			if( shaveCheck.sort.last > 11, {
				properties.do({|it|
					while(
						{it.size > 11}, { it.pop; }); // 11
				});
			});	
		});
		
		
		//backwards compability
		if (properties[0].size < defaultProperties.size, {
			//("old properties:"+properties).postln;
			properties= properties.asList;
			oldPropSize= properties[0].size.deepCopy-1;
			defaultProperties.do({ |it, i|
				//("old props"+properties[i]).postln;
				//("---->"+i).postln;
				//var oldPropSize= properties[i].size.deepCopy-1;
				it.do({ |itt, ii|
					//ii.postln;
					if (ii > oldPropSize,
					//if (properties[i][ii].isNil,
						{ properties[i]= properties[i].add(it[ii]); });
				});
				//properties[i].postln;
			});
			//("new properties:"+properties).postln;
		});
		
		/*
		if(properties[0][2].isNil, {
			properties= properties.asList;
			"everything backwards1!!".postln;
			properties.do({|it, i|
				properties[i]= properties[i].add(0); //adding playback mode
				properties[i]= properties[i].add(0.01); //adding attack
				properties[i]= properties[i].add(0.2); //adding release
				properties[i]= properties[i].add(0); //adding killer
				properties[i]= properties[i].add(0); //adding 
				properties[i]= properties[i].add(3); //adding 
				properties[i]= properties[i].add(0); //adding 
			});
		});
		if(properties[0][6].isNil, {
			properties= properties.asList;
			"everything backwards1!!".postln;
			properties.do({|it, i|
				properties[i]= properties[i].add(0); //adding 
				properties[i]= properties[i].add(3); //adding 
				properties[i]= properties[i].add(0); //adding
			});
		});
		*/
		properties[0].postln;
		});
		{w.refresh}.defer;
		sliders[0].title.postln;
});


Button(w, Rect(230, 50, 30, 20))
.canFocus_(false)
.states_([["qs", Color.white, Color.grey]])
.action_({ |v|
		var values, path;
		path= currentPresetPath;
		backup.value(path);
		knobSounds= allKnobs.collect({ |it, i|
			{it.getValues}.try;
		});
		sliderSounds= sliders.collect({ |it, i|
			{it.getValues}.try;
		});
		values= [sounds, properties, knobSounds, sliderSounds, soundsASR, masterprop];
		values.writeArchive(path);
});

// =============================================================================================
// ================================= GUI - PREFERENCE BUTTONS ==================================
// =============================================================================================


Button(w, Rect(410,300, 30, 30))
.states_([["x", Color.green], ["x", Color.black]])
.action_({|v|
	if(seqIsOpen, { nil }, { sequencer.value; seqIsOpen= true });
	//if (v.value==1 && panSynth.isNil, {panSynth= Synth.tail(s, \PanningHack)}, { panSynth.free; panSynth= nil})
});

Button(w, Rect(410,350, 50, 30))
.states_([["remote", Color.black], ["remote", Color.white]])
.action_({|v|
	touchOSC.value;
});

panKnob= Knob(w, Rect(410, 460, 30, 30))
.centered_(true)
.canFocus_(false)
.value_(\pan.asSpec.unmap(0))
.action_({ |v|
	//pan= (\pan.asSpec.map(v.value));
	//if(firstRun.not, {syn.set(\pan, \pan.asSpec.map(v.value))});
	if (panSynth.isNil.not, { {panSynth.set(\pan, \pan.asSpec.map(v.value))}.try });
})
.color_([Color.gray, Color.red, Color.white, Color.black])
.mouseDownAction_({|view, x, y, mod|
	if (mod == alt, {view.valueAction= \pan.asSpec.unmap(0);})
})
.canReceiveDragHandler_(true)
.receiveDragHandler_({|view|
	var drag;
	drag= View.currentDrag;
	if (drag.class == UC33LoopChan, {
		drag.setAction({|v|{ panKnob.valueAction_(v.value)}.defer }, "MAIN");
	});
});


Button(w, Rect(400, 400, 50, 30))
.states_([["nil", Color.black, Color.grey], ["1-2", Color.yellow, Color.black],["3-4", Color.yellow, Color.black], ["5-6", Color.yellow, Color.black], ["7-8", Color.yellow, Color.black], ["9-10", Color.yellow, Color.black], ["11-12", Color.yellow, Color.black], ["13-14", Color.yellow, Color.black], ["15-16", Color.yellow, Color.black], ["17-18", Color.yellow, Color.black]] )
.canFocus_(false)
.value_(preferences[13])
.action_({ |v|
	output= outputs[v.value];
	sliders.do({ |it| it.defaultout_(outputs[v.value]); it.reloadSampleSoft;});
	allKnobs.do({ |it| it.defaultout_(outputs[v.value]); it.reloadSampleSoft; });
});

Button(w, Rect(250, 20, 40, 20))
.canFocus_(false)
.states_([["panic", Color.black, Color.grey]])
.action_({ |v|
	panic.value;
});

progressState= masterprop[\prView];
prViewBut= Button(w, Rect(290, 20, 50, 20))
.canFocus_(false)
.states_([["pr view", Color.white, Color.grey], ["pr view", Color.yellow, Color.grey]])
.value_(progressState)
.font_(Font("Helvetica", 10))
.action_({ |v|
	progressState= v.value;
	sliders.do({|it| it.progress(v.value) });
	allKnobs.do({|it| it.progress(v.value) });
	masterprop[\prView]= v.value;
});

sliderPitch= masterprop[\slPitch];
slPitchBut= Button(w, Rect(340, 20, 40, 20))
.canFocus_(false)
.states_([["SL bnd", Color.white, Color.grey], ["SL bnd", Color.yellow, Color.grey]])
.value_(sliderPitch)
.font_(Font("Helvetica", 10))
.action_({ |v|
	if(v.value == 1, { sliderPitch= 1 }, { sliderPitch= 0 });
	masterprop[\slPitch]= v.value;
});

knobPitch= masterprop[\knPitch];
knPitchBut= Button(w, Rect(380, 20, 40, 20))
.canFocus_(false)
.states_([["KN bnd", Color.white, Color.grey], ["KN bnd", Color.yellow, Color.grey]])
.value_(knobPitch)
.font_(Font("Helvetica", 10))
.action_({ |v|
	if(v.value == 1, { knobPitch= 1 }, { knobPitch= 0 });
	masterprop[\knPitch]= v.value;
});

keyPitch= masterprop[\kyPitch];
kyPitchBut= Button(w, Rect(420, 20, 40, 20))
.canFocus_(false)
.states_([["Ky bnd", Color.white, Color.grey], ["Ky bnd", Color.yellow, Color.grey]])
.value_(keyPitch)
.font_(Font("Helvetica", 10))
.action_({ |v|
	if(v.value == 1, { keyPitch= 1 }, { keyPitch= 0 });
	masterprop[\kyPitch]= v.value;
});

/*
PopUpMenu(w, Rect(300, 50, 30, 20))
.items_(["1", "2", "3", "4", "5"])
.value_(masterprop[\poly])
.action_({ arg menu;
a.overlaps= (menu.value+1);
a.overlaps.postln;
});

*/
/*
Button(w, Rect(330, 50, 40, 20))
.states_([["vel off", Color.black, Color.grey], ["vel on", Color.yellow, Color.grey]])
.value_(masterprop[\vel])
.action_({ |v|
	velocitystate= v.value;
});
*/

Button(w, Rect(290, 50, 40, 20))
.canFocus_(false)
.states_([["KB", Color.black, Color.grey], ["KB", Color.black, Color.green]])
.action_({ |v|
	if(v.value == 1, {
		w.view.keyDownAction= {|view, char|
			var keys= [$a, $w, $s, $e, $d, $f, $t, $g, $y, $h, $u, $j, $k, $l];
			//	if (char == $x, { + 12});
			//	if (char == $z, { - 12});
			keys.do({|it, i|
				if(char == it, {
					if(keyboardPressDown[i], {
						("playnote"+i).postln;
						playnote.value(nil, sounds[i], i, nil);
						keyboardPressDown[i]= false;
					});
				});
			});
			};
		w.view.keyUpAction= {|view, char|
			var keys= [$a, $w, $s, $e, $d, $f, $t, $g, $y, $h, $u, $j, $k, $l];
			keys.do({|it, i|
				if(char == it, {
					("stopnote"+i).postln;
					stopnote.value(sounds[i], i);
					keyboardPressDown[i]= true;
				});
			});
		};			
	}, {
		w.view.keyDownAction= {|view, char|
				if (char == $r, { record.value; });
				if (char == $i, { recordInstantly.value; });
			};
		w.view.keyUpAction= {};
	});
});

midiBut= Button(w, Rect(340, 50, 40, 20))
.canFocus_(false)
.states_([["MIDI", Color.black, Color.grey], ["MIDI", Color.black, Color.green]])
.value_(masterprop[\midi])
.action_({ |v|
	// toggle midi
	masterprop[\midi]= v.value;
});

oscBut= Button(w, Rect(380, 50, 40, 20))
.canFocus_(false)
.states_([["OSC", Color.black, Color.grey], ["OSC", Color.black, Color.green]])
.value_(masterprop[\osc])
.action_({ |v|
	masterprop[\osc]= v.value;
	//touchOSC.value;
});

dmxBut= Button(w, Rect(420, 50, 40, 20))
.canFocus_(false)
.states_([["DMX", Color.black, Color.grey], ["DMX", Color.black, Color.green]])
.value_(masterprop[\dmx])
.action_({ |v|
	// toggle dmx
	masterprop[\dmx]= v.value;
});



Button(w, Rect(200, 20, 50, 20))
.canFocus_(false)
.states_([["rec", Color.black, Color(1.0, 0.2089552238806, 0.25373134328358, 1.0)]])
.action_({ |v|
	record.value;
});



w.view.keyDownAction = {|view, char, mod, uni, key|
	//[view, char, mod, uni, key].postln;
	if (uni == $r, { record.value; });
	if (char == $i, { recordInstantly.value; });
};


record= 
{|instant= false|
var b, d, rec, stop, drag, recbut, sfpath, clockGUI;
var window = Window.new("record",Rect(465, 636, 306, 200)).front;

//RoundButton( w, 40@40 ).states_([[ \record, Color.red, Color.grey ],[ \stop, Color.black, Color.red ]] );

recbut= Button.new(window,Rect(20, 10, 260, 20))
	.states_([ [ "rec", Color.black, Color.red ], [ "stop", Color.white, Color.blue] ])
	.action_{|v|
		case 
		{v.value == 1} {rec.value}
		{v.value == 0} {stop.value};
		};
drag= DragSource.new(window,Rect(20, 150, 260, 20))
	.action_{|v| };
	
Button(window, Rect(20, 175, 260, 20))
.states_([["reveal in finder"]])
.action_({ drag.object[0].revealInFinder });

clockGUI= ClockGUI.new(window, Rect(20, 40, 260, 100));

// allocate a disk i/o buffer
b= Buffer.alloc(s, 65536, 2);

SynthDef(\recordGiga, {arg bufnum, in;
	DiskOut.ar(bufnum, In.ar(in,2));
}).send(s);



rec= { // start recording
	// create an output file for this buffer, leave it open
	sfpath= ((recordingsPath++keyboardName ++Date.localtime.stamp++".wav").standardizePath);
	b.write(sfpath, "wav", "int16", 0, 0, true);
	Routine({
		s.sync;
		d = Synth.tail(nil, \recordGiga, [\bufnum, b, \in, output]);
	}).play(AppClock);	
	clockGUI.reset;
	clockGUI.play;
};

stop= { // stop recording
	Routine({
	d.free; b.close; b.free;
	s.sync;
	drag.object= [sfpath];
	sfpath.postln;
	sfpath.class.postln;
	b= Buffer.alloc(s, 65536, 2);
	s.sync;
	//sfpath= ("/Volumes/MEDIA/Prosjekter/Vildanden/Villanden Lyd/recordings/"++"GigRec_" ++ Date.localtime.stamp ++ ".wav".standardizePath);
	//b.write(sfpath, "wav", "int16", 0, 0, true);
	clockGUI.pause;
}).play(AppClock);
};

recbut.focus(true);

window.onClose= {b.close; b.free;}

};


recordInstantly= 
{|midiCCnum= nil|
var b, d, rec, stop, drag, recbut, sfpath, clockGUI, ccResponder;
var window; 

window = Window.new("record",Rect(465, 336, 306, 180), border: false)
.alwaysOnTop_(true);

//RoundButton( w, 40@40 ).states_([[ \record, Color.red, Color.grey ],[ \stop, Color.black, Color.red ]] );

recbut= Button.new(window,Rect(20, 10, 260, 20))
	.states_([ [ "rec", Color.black, Color.red ], [ "stop", Color.white, Color.blue] ])
	.action_{|v|
		case 
		{v.value == 1} {rec.value}
		{v.value == 0} {stop.value};
		};

clockGUI= ClockGUI.new(window, Rect(20, 40, 260, 100));

// allocate a disk i/o buffer
b= Buffer.alloc(s, 65536, 2);

SynthDef(\recordGiga, {arg bufnum, in;
	DiskOut.ar(bufnum, In.ar(in,2));
}).send(s);



rec= { // start recording
	// create an output file for this buffer, leave it open
	sfpath= ((recordingsPath++keyboardName ++Date.localtime.stamp++".wav").standardizePath);
	b.write(sfpath, "wav", "int16", 0, 0, true);
	Routine({
		s.sync;
		d = Synth.tail(nil, \recordGiga, [\bufnum, b, \in, output]);
	}).play(AppClock);	
	clockGUI.reset;
	clockGUI.play;
};

stop= { // stop recording
	Routine({
	d.free; b.close; b.free;
	clockGUI.pause;
	s.sync;
	//stopnote.value(sounds[numKeys-1], numKeys-1, nil);
	loadPreset.value([sfpath], numKeys-1);
	a.isPlaying(("snd"++((numKeys-1).asString)).asSymbol).postln;
	s.sync;
	properties[numKeys-1][0]= 1;
	properties[numKeys-1][1]= 1;
	properties[numKeys-1][2]= 2;
	playnote.value(nil, sounds[numKeys-1], numKeys-1, nil);
	window.close;
}).play(AppClock);
};

recbut.focus(true);

if(midiCCnum.isNil.not, {
ccResponder = CCResponder({ |src,chan,num,value|
	//[src,chan,num,value].postln;
	stop.value;
	},
	midisrcindex, //  source
	midichannel, //  channel
	midiCCnum, // CC number
	nil // any value
);
});

rec.value; //START RECORDING STRAIGHT AWAY
{recbut.value= 1; }.defer;

window.onClose= {

	if(c.isNil.not, {ccResponder.remove;});
	
	};
	
	window.front;

};


updatePreferenceButtons = {
	midiBut.value = masterprop[\midi];
	oscBut.value = masterprop[\osc];
	dmxBut.value= masterprop[\dmx];
	slPitchBut.value= masterprop[\slPitch];
	knPitchBut.value= masterprop[\knPitch];
	kyPitchBut.value= masterprop[\kyPitch];
	prViewBut.value= masterprop[\prView];
	};


/*
GUI.popupMenu.new(w, Rect(20, 80, 100, 30))
.items_

*/

// =============================================================================================
// ==================================== GUI - KEYBOARD =========================================
// =============================================================================================

//progress view
keyUserViews= numKeys.collect({ |i|
	var num, size, amp, env, loop;
	num= i.wrap(0, 11);

	size= 130*(sizes[num]);

	UserView(w, Rect(470, keyHSize*((i-numKeys).abs)-10, size, keyHSize))
	.canFocus_(false)
	.background_(colorsOnUV[num]);
});

//key prop labels
keyPropLabels= numKeys.collect({ |i|
	var view;
	view= UserView(w, Rect(460, keyHSize*((i-numKeys).abs)-10, 10, 20))
	.background_(Color.grey.alpha_(0.5))
	.canFocus_(false);
	
	view.drawFunc = {
		//routing
		if(properties[i][10].isNil.not, {
			// set the Color
			Pen.color = Color.yellow;
		}, {
			Pen.color = Color.yellow.alpha_(0.0);
		});
		Pen.addRect(Rect(6, 0, 3, 20));
		Pen.perform(\fill);
		//toggle
		if(properties[i][2] == 2, {
			// set the Color
			Pen.color = Color.green;
		}, {
			Pen.color = Color.green.alpha_(0.0);
		});
		Pen.addRect(Rect(0, 0, 3, 20));
		Pen.perform(\fill);
	};
});

//keys
keyButs= numKeys.collect({ |i|
var num, size, amp, env, loop;
num= i.wrap(0, 11);

size= 130*(sizes[num]);


Button(w, Rect(470, keyHSize*((i-numKeys).abs)-10, size, keyHSize))
.font_(GUI.font.new("Monaco", 9))
.canFocus_(false)
.states_([["", textcolors[num], colors[num]], ["", Color.black, colorsOn[i.wrap(0, 11)]] ])
.mouseDownAction_({ |view, x, y, mod|

	if ( mod == shift, {
		CocoaDialog.getPaths({ arg paths; //load sound
		loadPreset.value(paths, i);
		},{
			"cancelled".postln;
		});
	});
	if ( mod == alt, { |v|
		{a.freeKey(("snd"++(i).asString).asSymbol);}.try;
		soundsASR[i].do({|it, iii|
			if (it[iii].isNil.not, {
			{a.freeKey(("snd"++(i).asString++"x"++(iii.asString)).asSymbol);}.try;
			});
		});
		soundsASR[i]= nil;
		sounds[i]= nil;
		properties[i]= defaultProperties[0].deepCopy;
		{keyButs[i].states= ([["", textcolors[i.wrap(0, 11)], colors[i.wrap(0, 11)]], ["", textcolors[i.wrap(0, 11)], colorsOn[i.wrap(0, 11)]]]);}.defer;
});
	
})
.beginDragAction_({ [sounds[i]] })
.canReceiveDragHandler_(true)
.receiveDragHandler_({|view|
	var values, paths;
	paths= View.currentDrag;
	//paths.postln;
	if (paths.class == UC33LoopChan, {
		paths.setAction({|v|
			properties[i][9]= \pan.asSpec.map(v.value);
			if (a.isPlaying(("snd"++((i).asString)).asSymbol), {
				a.set(("snd"++((i).asString)).asSymbol).pan_(\pan.asSpec.map(v.value)) });
			}
			, noteArray[i]);
		},{
		if(paths.isString, {paths= [paths];}); // qt compatibility..
		loadPreset.value(paths, i);
	});
})
.action_({ |v|
	c.remove;
	propView.value(i);
	if(sendWinOpen.isNil.not, { {sendWinOpen.close; 0.5.wait; sendWindow.value(i);}.fork(AppClock) });
	{v.value= 0}.defer;
	w.refresh;
});
});

loadPreset= {|paths, i|
	var folderName, num;
	num= i.wrap(0, 11);
	if (paths[0].isFolder, //if file is a folder, load all on one key
			{folderName= paths[0].basename; paths= (paths[0]++"/"++"*"); paths= paths.pathMatch; 
		{a.freeKey(("snd"++(i).asString).asSymbol);}.try;
		soundsASR[i].do({|it, iii|
			{a.freeKey(("snd"++(i).asString++"x"++(iii.asString)).asSymbol);}.try;
		});
		soundsASR[i]= paths;
		//path.postln;
		sounds[i]= paths[0];
		a.prepareForPlay(("snd"++(i).asString).asSymbol, sounds[(i)]);
		
		soundsASR[i].size.do({ |it, iii|
			if(soundsASR[i][iii].isNil.not, {
				a.prepareForPlay(("snd"++i.asString++"x"++(iii.asString)).asSymbol, soundsASR[i][iii]);
					});
				});
		{ keyButs[i].states= ([[folderName, textcolors[(i).wrap(0, 11);], colors[(i).wrap(0, 11);]], [folderName, Color.black, colorsOn[(i).wrap(0, 11)]] ]) }.defer;
		properties[i]= defaultProperties[0].deepCopy;
		properties[i][2]= 5; //set as sequence
		properties[i][6]= 0;
		},{
		// if path is not folder, normal
	paths.do({ |path, ii|
		if (path.isSoundFileOrMp3, {
		{a.freeKey(("snd"++(i+ii).asString).asSymbol);}.try;
		soundsASR[i+ii].do({|it, iii|
			{a.freeKey(("snd"++(i+ii).asString++"x"++(iii.asString)).asSymbol);}.try;
		});
		soundsASR[i+ii]= [];
		//path.postln;
		sounds[(i+ii)]= path;
		a.prepareForPlay(("snd"++(i+ii).asString).asSymbol, sounds[(i+ii)]);
		{ keyButs[i+ii].states= ([[path.basename.removeExtension, textcolors[(i+ii).wrap(0, 11);], colors[(i+ii).wrap(0, 11);]], [path.basename.removeExtension, Color.black, colorsOn[(i+ii).wrap(0, 11)]] ]) }.defer;
		properties[(i+ii)]= defaultProperties[0].deepCopy;
		//folder rules
		rulesOnOff.do({|it, onoff_iter|
			if(it == 1, {
				//"onoff!".postln;
				if (path.contains(ruleFolderNames[onoff_iter]), {
					//"it contains!!".postln;
					rulesApply[onoff_iter].do({|it, apply_iter|
						if(it == 1, {
							//"applying properties!!".postln;
							properties[i+ii][apply_iter]= rulesList[onoff_iter][apply_iter];
							});
					});
				});
			});
		});
		//if (path.contains("musicloops"), { properties[i+ii][1]= 1; properties[i+ii][2]= 2; });
		robotPresetCheck.value(path, i);
		if(a.mp3[("snd"++(i).asString).asSymbol].isNil.not, {sounds[i]= a.mp3[("snd"++(i).asString).asSymbol]});
		}, {errorFileMessage.value;});
	});
		});
	};

robotPresetCheck= {|soundfile, key|
	var saveDirectoryOSC, saveFilesOSC, saveFilesOSCNames, loadArray, index;
	
	saveDirectoryOSC= (String.scDir.dirname ++ "/Resources/SENDWINSAVES/OSC/");
	saveFilesOSC= (saveDirectoryOSC++"*").standardizePath.pathMatch;
	saveFilesOSCNames= saveFilesOSC.collect({|it| it.basename.asSymbol});
	soundfile= soundfile.basename.removeExtension.asSymbol;
	index= saveFilesOSCNames.indexOfWildcard(soundfile);
	
	if(index.isNil.not, {
		loadArray= Object.readArchive(saveFilesOSC[index]);
		properties[key][15][0]= loadArray[0];
		properties[key][15][1]= loadArray[1];
		});
	
	
	};

midiPresetCheck= {|soundfile, key|
	var saveDirectoryMIDI, saveFilesMIDI, saveFilesMIDINames, loadArray, index;
	
	saveDirectoryMIDI= (String.scDir.dirname ++ "/Resources/SENDWINSAVES/MIDI/");
	saveFilesMIDI= (saveDirectoryMIDI++"*").standardizePath.pathMatch;
	saveFilesMIDINames= saveFilesMIDI.collect({|it| it.basename.asSymbol});
	soundfile= soundfile.basename.removeExtension.asSymbol;
	index= saveFilesMIDINames.indexOfWildcard(soundfile);
	
	if(index.isNil.not, {
		loadArray= Object.readArchive(saveFilesMIDI[index]);
		properties[key][11]= loadArray;
		});
	
	
	};

errorFileMessage= {
var w, r;

	w= SCAlert( "the file you loaded is not valid. It's either just plain wrong or mp3..",["close.. 5"],[{w.window.close; r.stop; }] );
	
	/*
	w= Window("error", Rect(400, 400, 300, 100))
	.background_(
	.alwaysOnTop_("true");

	StaticText(w, Rect(10, 10, 280, 20))
	.string_("the file you loaded is not valid");
	StaticText(w, Rect(10, 30, 280, 20))
	.string_("either just plain wrong or mp3..");
	w.front;
	*/
	r= {1.wait; 
	5.do({|i| {w.buttonLabel_(0, "close.."+(5-i));}.defer; 1.wait;});
	w.window.close;}.fork(AppClock);
};



// =============================================================================================
// ============================= GUI - SLIDERS & KNOBS =========================================
// =============================================================================================

// ============= SLIDERS ==========

sliderView= HLayoutView(w, Rect(20, 540, 415, 180));
//sliderView.setProperty(\spacing,0);


sliders= slidersCC.size.collect({ |i|
	i= i+1;
	SliderLooper.new(sliderView, 0, 0, i, out: output, preferences: preferences);
});

sliders.do({|it| it.allSliders= sliders });

responders1= slidersCC.collect({|it, i|

		CCResponder({
			|src,chan,num,value|
			sliders[i].setVal((value*(127.reciprocal)).round(0.001));
		}, num: it, src: midisrcindex, chan: midichannel
		);

});

// ============= KNOBS ==========
knobView1= CompositeView(w, Rect(15, 300, 380, 230));
knobView1.decorator = FlowLayout(knobView1.bounds);


allKnobs= knobsCC.size.collect({|i|
	UC33LoopChan.new(knobView1, 0, 0, output, nil, preferences, properties, a, i+1);
});

allKnobs.do({|it| it.allSliders= allKnobs });

responders2= knobsCC.collect({|it, i|

		CCResponder({
			|src,chan,num,value|
			allKnobs[i].setVal((value*(127.reciprocal)).round(0.001));
		}, num: (it), src: midisrcindex, chan: midichannel
		);
	
});



// =============================================================================================
// ================================= GUI - EFFECT VIEW =========================================
// =============================================================================================

effView= {|storedValues|

var cblobs;

var fx_synths, fx_synth_names, fx_synth_namesShort, metadata, fxMenu, fxMenuItems, paramGUIs= [];
var gateControls, gates= [];
var allSynths= [];
//var fxDir= "/Users/martin/scwork/samplerProject/fx-lib";
var fxDir= (String.scDir.dirname ++ "/Resources/FXSynthDefs");


{
////////// ** FX SYNTHS LOAD ** /////////////
	(fxDir ++ "/*").loadPaths;
			s.sync;
	//collect list of synths with fx_ in the name
	fx_synths=SynthDescLib.global.synthDescs.select{|def|
     def.name.contains("fx_");
	};

  	fx_synth_names= fx_synths.collect({|it| it.name });	
 	fx_synth_namesShort= fx_synths.collect({|it| it.name.drop(3)});
 	
 	allSynths= nil!(fx_synths.size);
 	
 	t= TabbedView(w, Rect(250, 75, 200, 95), fx_synth_namesShort, [Color.new255(158, 158, 158), Color.new255(148, 148, 148), Color.new255(138, 138, 138)])
.followEdges_(false)
.font_(Font("Monaco",9)).tabHeight_(1).tabWidth_(15);
 	
 	fx_synth_names.do({|it, i|
	 	var metadatainfo, but, guis, synth, usefulControls, scroll, view, gatebutton;
	 	var currentValuesDict= Dictionary.new;
	 	it= fx_synths[it.asSymbol];
	 	currentValuesDict.put(\out, output);
	 	//make button
	 	scroll= ScrollView(t.views[i], Rect(0, 0, 200, 80))
	 	.hasHorizontalScroller_(false);
	 	//.hasBorder_(true);
	 	view= CompositeView(scroll, Rect(0, 0, 190, 150));
	 	but= Button(view, Rect(5, 5, 15, 15))
		.states_([["x"], ["x", Color.black, Color.green]])
		.value_(0)
		.canFocus_(false)
		.action_({|v| 
			if (v.value == 1,
			{ allSynths[i]= Synth.tail(effectGroup, it.name.asSymbol, currentValuesDict.asKeyValuePairs);
					allSynths[i].isRunning= true;
					fxMenuItems[i]= fxMenuItems[i]+"*";
					fxMenu.items= fxMenuItems;
				},{ 
					allSynths[i].free;
					fxMenuItems[i]= fxMenuItems[i].drop(-2);
					fxMenu.items= fxMenuItems; 
				});
		});
		
		usefulControls= it.controls.reject({|itt|
			var name= itt.name.asSymbol;
			var avoidList= [\out, \in, \gate, \recrun];
			avoidList.indexOf(name).isNil.not
		});
		
		gateControls= it.controls.detect({|itt|
			var name= itt.name.asSymbol;
			name == \gate
		});
		
		//if(gateControls.class != Array, {gateControls= [gateControls]; });
		
		//usefulControls.postln;
		//usefulControls.class.postln;

	 	guis= usefulControls.collect({|itt, ii|
		 		var name= itt.name.asSymbol;
		 		var spec;
		 		currentValuesDict.put(name, itt.defaultValue);
		 		spec= it.metadata[\specs][name];
				EZSlider(view,  	// parent
				Rect(10, 5+(15*ii), 180, 15),
				name,	// label
				spec, // controlSpec
				{|ez| if (but.value == 1, {allSynths[i].set(name, ez.value)});
					currentValuesDict.put(name, ez.value);
					//("setting"+name+":"+currentValuesDict[name].asString).postln;
				}, // action
				itt.defaultValue, // init value, set from A DICTIONARY
				labelWidth: 40
				).setColors(
					nil, //string backgr
					Color.white, //string
					Color(0.298, 0.298, 0.298, 1.0), //slider backgr
					Color.grey, //num backgr
					Color.white, //num clr
					nil,
					nil,
					Color(0.298, 0.776, 1.0, 1.0) //knob clr
					);
		});
		
		if(gateControls.isNil.not, {
		 	gatebutton= Button(view, Rect(10, 5+(15*guis.size), 160, 15))
		 	.states_([["gate"],["gate", Color.black, Color.yellow]])
		 	.action_({|v| allSynths[i].set(\gate, v.value) })
		 	.value_(gateControls.defaultValue); 	
			gates= gates.add(gatebutton);
		});

 		paramGUIs= paramGUIs++but++guis;
 		
 		view.bounds_(Rect(0, 0, 190, 40+(guis.size*15)));
 	
 		//fxDict.put(it.name.asSymbol, currentValuesDict);
	 });
	//paramGUIs.postln;
	//fx_synth_names.postln;
	//fx_synth_names.asArray.postln;
	
	fxMenuItems= fx_synth_namesShort.asArray;
	
	fxMenu= PopUpMenu(w, Rect(250, 75, 100, 15))
	.items_(fxMenuItems)
	.background_(Color.white)
	.canFocus_(false)
	.font_(Font("Helvetica", 10))
	.action_({|v| t.focus(v.value)});
	Button(w, Rect(350, 75, 30, 15))
	.canFocus_(false)
	.states_([["<<", Color(0.298, 0.776, 1.0, 1.0), Color(0.298, 0.298, 0.298, 1.0)]])
	.action_({|v| {fxMenu.valueAction= (fxMenu.value-1).wrap(0, (fxMenu.items.size-1)) }.defer; });
	Button(w, Rect(380, 75, 30, 15))
	.canFocus_(false)
	.states_([[">>", Color(0.298, 0.776, 1.0, 1.0), Color(0.298, 0.298, 0.298, 1.0)]])
	.action_({|v| {fxMenu.valueAction= (fxMenu.value+1).wrap(0, (fxMenu.items.size-1)) }.defer; });	
	Button(w, Rect(410, 75, 35, 15))
	.font_(Font("Helvetica", 10))
	.canFocus_(false)
	.states_([["allOff", Color.red, Color(0.298, 0.298, 0.298, 1.0)]])
	.action_({|v|
		allSynths.do({|it|
			if(it.isNil.not,{
				if(it.isRunning, {it.free;});
			});
		});
		paramGUIs.do({|it|
			if(it.class == SCButton, { {it.valueAction= 0}.defer; });
		});
		});	
	
	


/*
(ezrev++ezecho).do({|it, i|
	it.sliderView.canReceiveDragHandler= (true);
	it.sliderView.receiveDragHandler= ({|view|
		var drag, actfunc;
		actfunc= {|v| {view.value= v.value}.defer };
		View.currentDrag.knob1.action = view.action;
		View.currentDrag.knob1.addAction(actfunc);
		View.currentDrag.setValues([nil]);
		View.currentDrag.title.string = ("CC"++it.labelView.string);
		drag= View.currentDrag;
		view.onClose= {
			drag.setDefaultAction;
			drag.setValues([nil]);
			drag.knob1.removeAction(actfunc);
			"yaya".postln;
		};
})
});
*/

t.view.addAction({
	allSynths.do({|it|
		if(it.isNil.not,{
			if(it.isRunning, {it.free;});
		});
	});
}, \onClose);

/*
r{
	1.wait;
	if (masterprop[\revon] == 1, { {revOn.valueAction= 1}.defer; });
	if (masterprop[\eon] == 1, { {echoOn.valueAction= 1}.defer; });
}.play(AppClock);
*/


//paramGUIs.postln;
//gates.postln;

cblobs= Colorblobs2.new(w, Rect(250, 170, 200, 105), paramGUIs, kaossFilesDir, gates)

/*	, pressAction: { { sliders.do({|it| it.pause }) }.defer; }, 
	releaseAction: {  { sliders.do({|it| it.unpause }) }.defer; } 
	);
*/
	 }.fork(AppClock);
};

effView.value;


// =============================================================================================
// ============================= GUI - PROP VIEW ===============================================
// =============================================================================================

propView= { | key |
var t, panarr= [0, -1, 1], directionBut, rateKnob;

c= CompositeView(w, Rect(20, 100, 220, 190))
.background_(Color.new255(229, 229, 229));
//.relativeOrigin_(true);

if (sounds[key].isNil.not, {
StaticText(c, Rect(90, 0, 200, 15))
.string_(sounds[key].basename.replace(".wav", ""));
},{
StaticText(c, Rect(90, 0, 200, 15))
.string_("no soundfile on key");
});

/*
Button(c, Rect(20, 10, 30, 15))
.states_([["c", Color.black, Color.grey], ["<", Color.green, Color.black],[">", Color.green, Color.black] ])
.canFocus_(false)
.value_(panarr.indexOf(properties[key][9]))
.action_({ |v|
	properties[key][9]= panarr[v.value];
});
*/
Knob(c, Rect(10, 10, 15, 15))
.centered_(true)
.canFocus_(false)
.value_(\pan.asSpec.unmap(properties[key][9]))
.action_({ |v|
	//properties[key][9]= v.value;
	properties[key][9]= \pan.asSpec.map(v.value);
	if (a.isPlaying(("snd"++((key).asString)).asSymbol), {
				a.set(("snd"++((key).asString)).asSymbol).pan_(\pan.asSpec.map(v.value)) });
	//\pan.asSpec.map(v.value).postln;
})
.color_([Color.gray, Color.red, Color.white, Color.black])
.mouseDownAction_({|view, x, y, mod|
	if (mod == alt, {view.valueAction= \pan.asSpec.unmap(0); properties[key][9]= 0})
});


Button(c, Rect(30, 10, 30, 15))
.states_([["nil", Color.black, Color.grey], ["1-2", Color.yellow, Color.black],["3-4", Color.yellow, Color.black], ["5-5", Color.yellow, Color.black], ["7-8", Color.yellow, Color.black], ["9-10", Color.yellow, Color.black], ["11-12", Color.yellow, Color.black], ["13-14", Color.yellow, Color.black], ["15-16", Color.yellow, Color.black]] )
.canFocus_(false)
.value_(if (properties[key][10]==nil, { 0 }, { outputs.indexOf(properties[key][10]) }) )
.action_({ |v|
	properties[key][10]= outputs[v.value];
});


Slider(c, Rect(10, 30, 50, 120))
.background_(Color.grey)
.canFocus_(false)
.value_(properties[key][0])
.action_({ |v|
	properties[key][0]= v.value;
	if (a.isPlaying(("snd"++((key).asString)).asSymbol), {
		a.set(("snd"++((key).asString)).asSymbol).amp_(v.value) });
	
});
Button(c, Rect(70, 20, 60, 20))
.states_([["loop off", Color.black, Color.grey], ["loop on", Color.white, Color.black]])
.canFocus_(false)
.value_(properties[key][1])
.action_({ |v|
	properties[key][1]= v.value;
});

Button(c, Rect(130, 20, 30, 20))
.states_([["|--|", Color.white, Color.grey]])
.canFocus_(false)
.action_({ |v|
	if(sounds[key].isNil, {"no sound loaded".postln},
	{looppointeditor.value(key)}
	//{midiSendWindow.value(key)}
	);
});

Button(c, Rect(160, 20, 20, 20))
.states_([["rm", Color.black, Color.grey]])
.canFocus_(false)
.action_({ |v|
	{a.freeKey(("snd"++(key).asString).asSymbol);}.try;
	soundsASR[key].do({|it, iii|
		if (it[iii].isNil.not, {
		{a.freeKey(("snd"++(key).asString++"x"++(iii.asString)).asSymbol);}.try;
		//it[iii]= nil;
		});
	});
	soundsASR[key]= nil;
	sounds[key]= nil;
	properties[key]= defaultProperties[0].deepCopy;
	{keyButs[key].states= ([["", textcolors[key.wrap(0, 11)], colors[key.wrap(0, 11)]], ["", textcolors[key.wrap(0, 11)], colorsOn[key.wrap(0, 11)]]]);}.defer;
});

//("prop 14:"+properties[key][14]).postln;

rateKnob= Knob(c, Rect(185, 20, 20, 20)) //speed / rate
.centered_(true)
.canFocus_(false)
.value_(\pan.asSpec.unmap(properties[key][14]))
.action_({ |v|
	//\pan.asSpec.map(v.value).postln;
	properties[key][14]= \pan.asSpec.map(v.value);
	if(\pan.asSpec.map(v.value).isPositive, 
		{directionBut.value= 0; properties[key][13][0]= 0}, 
		{directionBut.value= 1; properties[key][13][0]= 1});
	if (a.isPlaying(("snd"++((key).asString)).asSymbol), {
		a.set(("snd"++((key).asString)).asSymbol).speed_(\pan.asSpec.map(v.value)) });

})
.color_([Color.grey, Color.red, Color.white, Color.black])
.mouseDownAction_({|view, x, y, mod|
	if (mod == alt, {view.valueAction= \pan.asSpec.unmap(1); properties[key][14]= 1})
})
.canReceiveDragHandler_(true)
.receiveDragHandler_({|view|
	var drag;
	drag= View.currentDrag;
	if (drag.class == UC33LoopChan, {
		drag.setAction({|v|{ rateKnob.valueAction_(v.value)}.defer }, "MAIN");
	});
});



directionBut= Button(c, Rect(180, 45, 30, 20))
.states_([[">>", Color.green, Color.white], ["<<", Color.red, Color.white]])
.canFocus_(false)
.action_({ |v|
	if(v.value == 1, {
		rateKnob.valueAction= \pan.asSpec.unmap(\pan.asSpec.map(rateKnob.value).neg)
		},{
		rateKnob.valueAction= \pan.asSpec.unmap(\pan.asSpec.map(rateKnob.value).abs)
		});
});
if(properties[key][14].isNegative, {directionBut.value= 1});


Button(c, Rect(130, 45, 30, 20))
.states_([["killa", Color.black, Color.grey], ["killa", Color.red, Color.black]])
.canFocus_(false)
.value_(properties[key][5])
.action_({ |v|
	properties[key][5]= v.value;
});

Button(c, Rect(160, 45, 20, 20))
.states_([["sh", Color.black, Color.grey], ["sh", Color.red, Color.black]])
.canFocus_(false)
.value_(properties[key][8])
.action_({ |v|
	properties[key][8]= v.value;
	if (v.value == 1, {properties[key][1]= 0});
});


Button(c, Rect(70, 45, 60, 20))
.states_([["|>", Color.black, Color.grey], ["|>", Color.white, Color.black]])
.canFocus_(false)
.value_(if (a.isPlaying(("snd"++((key).asString)).asSymbol), {1}, {0}) )
.action_({ |v|
	var b= keyButs[key], time;
	if (v.value == 1, {
		playnote.value(nil, sounds[key], key, nil);
	},{
		stopnote.value(sounds[key], key);
	});
	if( ~logfile.isNil.not, { {~logfile.write(Date.getDate.hourStamp.asString+(sounds[key].basename)++"\n")}.defer; });
});

EZNumber( c,  	// parent
	Rect(50, 70, 80, 20),	// bounds
	"atk",	// label
	[0,6,\lin,0.01, properties[key][3]].asSpec, 	// controlSpec
	{|ez| 
	properties[key][3]= ez.value;
	}, // action
	labelWidth: 30,
	numberWidth: 40,
	unitWidth: 1
);

EZNumber( c,  	// parent
	Rect(110, 70, 80, 20),	// bounds
	"rel",	// label
	[0,6,\lin,0.01, properties[key][4]].asSpec, 	// controlSpec
	{|ez| 
	properties[key][4]= ez.value;
	}, // action
	labelWidth: 30,
	numberWidth: 40,
	unitWidth: 1
);

Button(c, Rect(190, 70, 20, 20))
.canFocus_(false)
.states_([["S", Color.white, Color.green]])
.action_({|v| sendWindow.value(key) });

PopUpMenu(c, Rect(5, 155, 70, 20))
.items_(["piano", "shot", "toggle", "3 samples", "2 samples", "many", "arpeggio"])
.value_(properties[key][2])
.canFocus_(false)
.action_({ arg menu;
	properties[key][2] = menu.value;

	if(arpRoutines[key].isPlaying, {arpRoutines[key].stop});
	if (a.isPlaying(("snd"++((key).asString)).asSymbol) and: {menu.value != 2}, {
		a.stop(("snd"++((key).asString)).asSymbol, properties[key][4]);
		{ keyButs[key].value= 0 }.defer;
		if (progressState == 1, {
			progress[key].stop; 
			progressViewClear.value(key);
		});
	});

	if( menu.value == 3, {
		extrasampleView.value(key, soundsASR[key]);
		extrasample= true;
	});
	if( menu.value == 4, {
		extrasampleView.value(key, soundsASR[key]);
		extrasample= true;
			
	});
	if( menu.value == 5, {
		extrasampleView.value(key, soundsASR[key]);
	});
	if( menu.value == 6, {
		arpView.value(key);
	});
});

if(properties[key][2] == 3, { extrasampleView.value(key, soundsASR[key]) });
if(properties[key][2] == 4, { extrasampleView.value(key, soundsASR[key]) });
if(properties[key][2] == 5, { extrasampleView.value(key, soundsASR[key]) });
if(properties[key][2] == 6, { arpView.value(key) });

};

// =============================================================================================
// ====================================== SEND WINDOW ==========================================
// =============================================================================================

sendWindow= {|key = 0|
//var properties= ([0.5, 0, 0, 0.01, 0.2, 0, 0, 3, 0, 0, nil, nil, [0.1, 0.2, 0], [0, 0, 1], 1, nil, nil]!36).asList, midiOut;
var testCue, testCue2;

var w, t, tabNames;
var midiNoteOnSlider, midiNoteOnValSlider, midiNoteOffSlider, midiNoteOffValSlider, testMIDI= false;
var midiView, makeNewMidiView, midiSendBut;
var oscTab, oscOnOffBut, loadOscTab, oscTypeMenu;
var robotMenu, makeNewOscTab;
var durationView, waitStringView, setWaitString, envView;
var dmxOnOffBut, dmxNoteOnChannel, dmxNoteOnSliders, dmxNoteOnView;
var dmxNoteOnViewAdd, dmxNoteOnViewSelect;
var dmxNoteOnScroll, dmxNoteOnLayout, updateDmxNoteOnView;
var dmxNoteOffChannel, dmxNoteOffSliders, dmxNoteOffView;
var dmxNoteOffViewAdd, dmxNoteOffViewSelect;
var dmxNoteOffScroll, dmxNoteOffLayout, updateDmxNoteOffView;
var testDMX= false, addBlack= true;

var saveFilesMIDI, loadMenuMIDI, loadMenuItemMIDI, saveDirectoryMIDI;
var saveFilesOSC, loadMenuOSC, loadMenuItemOSC, saveDirectoryOSC;
var saveFilesDMX, loadMenuDMX, loadMenuItemDMX, saveDirectoryDMX;
var verbose= true;


if(sendWinOpen.isNil.not, {sendWinOpen.close; });
if(sendWinLastTabFocus.isNil, {sendWinLastTabFocus= 0});

//midi default
if (properties[key][11].isNil, {
	properties[key][11]= [0, [0, 0], [0, 0]];
	});


//osc default
if (properties[key][15].isNil, {properties[key][15]= [0, Dictionary.new]});
//osc test
//properties[key][15]= [1, (\robot1: [127, 0, 7.456])]; // noteon/off
//properties[key][15]= [1, (\robot1: [[[0.0, 0.5], [0.1, 0.8]], 0, 7.456])]; //sequence


//dmx default
if (properties[key][16].isNil, {properties[key][16]= [0, [DMXSubCue.new, DMXSubCue.new]];});
//dmx test

//testCue= DMXSubCue.new;
//testCue2= DMXSubCue.new;
//[0, 1, 2, 10, 56, 34, 26, 73].do({|it, i| testCue.put(it, i*0.1) });
//[0, 1, 2, 10, 56, 34, 26, 73].do({|it, i| testCue2.put(it, 0) });
//properties[key][16]= [0, [testCue, testCue2]];

/*
if (~dmx.isNil, {
	SerialPort.devices.do({|it|
		if (it.asSymbol == '/dev/tty.usbserial-EN109012',
			{ "connecting dmx".postln;
				~dmx= DMX.new;
				~enttec= EntTecDMXUSBPro.new( "/dev/tty.usbserial-EN109012" );
				~dmx.device= ~enttec;
				~dmx.currentCue= DMXCue.new; //make into subcue....
				~dmx.setCue;
		});
	});
});
*/


if (sendWinLastPos.isNil, {
	w= Window("send:"+key+(noteArray[key]), Rect(0, 0, 400, 750));
},{
	w= Window("send:"+key+(noteArray[key]), Rect(sendWinLastPos[0], sendWinLastPos[1], 400, 750));
});
sendWinOpen= w;
tabNames= ["MIDI", "OSC", "DMX"];

t= TabbedView(w, Rect(0, 0, 400, 750), tabNames, [Color.new255(158, 158, 158), Color.new255(148, 148, 148), Color.new255(138, 138, 138)]);

// =================================================
// =================== M I D I =====================
// =================================================

	//t.views[0].decorator=FlowLayout(w.view.bounds);
	//t.views[0].decorator.gap=2@2;
	
	midiSendBut= Button(t.views[0], Rect(4, 4, 100, 30))
	.canFocus_(false)
	.states_([["MIDI send OFF", Color.grey, Color.black], ["MIDI send ON", Color.green, Color.black]])
	.value_(properties[key][11][0])
		.action_({|v|
			properties[key][11][0]= v.value;
		});
	
Button(t.views[0], Rect(106, 4, 40, 20))
.canFocus_(false)
.states_([["test", Color.white, Color.black], ["test", Color.green, Color.black]])
.action_({|v|
	if(v.value == 1, {testMIDI= true; if(midiOut.isNil, {"midiOUT not connected!".postln;}); }, 
		{testMIDI= false;
			if(midiOut.isNil.not, {
				midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][2][0], 0x00, properties[key][11][2][1], 0x00, 0xf7]);
			});
		});
});


// ============  MIDI Load Save Menu  ============

saveDirectoryMIDI= (String.scDir.dirname ++ "/Resources/SENDWINSAVES/MIDI/");
//saveDirectoryMIDI= "/Users/martin/scwork/samplerProject/Sampler \Central.app/Contents/Resources/SENDWINSAVES/MIDI/";

		saveFilesMIDI= (saveDirectoryMIDI++"*").standardizePath.pathMatch;
		//saveDirectory.postln;
		//saveFiles.postln;
		StaticText(t.views[0], Rect(148, 4, 60, 30)).string_("save/load:").align_(\left);
		loadMenuMIDI= PopUpMenu(t.views[0], Rect(210, 4, 100, 20)) // -----
		.items_(saveFilesMIDI.collect({|it| it.basename}))
		.canFocus_(false)
		.background_(Color.white)
		.font_(Font("Helvetica", 10))
		.action_({|v|
			loadMenuItemMIDI= v.items.at(v.value);
			if(verbose, {
			loadMenuItemMIDI.postln; 
			saveFilesMIDI[loadMenuMIDI.value].postln;
			});
		});
		//load preset
		Button(t.views[0], Rect(312, 4, 20, 20)) // ------
		.states_([["L", Color.red, Color.black]])
		.canFocus_(false)
		.font_(Font("Helvetica", 10))
		.action_({ 
			if (loadMenuItemMIDI.isNil.not, { 
				//this.load(saveFilesMIDI[loadMenuMIDI.value])
				//("before load:"+properties[key][11]).postln;
				properties[key][11]= Object.readArchive(saveFilesMIDI[loadMenuMIDI.value]);
				//remove view
				midiView.remove;
				//add view
				midiView= CompositeView(t.views[0], Rect(4, 36, 400, 400));
				makeNewMidiView.value;
				{midiSendBut.value= 1}.defer;
				/*
				midiView= CompositeView(t.views[0], Rect(4, 36, 400, 400));
				{ midiNoteOnSlider.value= properties[key][11][1][0] }.defer;
				{ midiNoteOnValSlider.value= properties[key][11][1][1] }.defer;
				{ midiNoteOffSlider.value= properties[key][11][2][0] }.defer;
				{ midiNoteOffValSlider.value= properties[key][11][2][1] }.defer;
				*/
				//("after load:"+properties[key][11]).postln;
			});
		});
		Button(t.views[0], Rect(334, 4, 30, 20))
		.states_([["qs"]])
		.canFocus_(false)
		.font_(Font("Helvetica", 12))
		.action_({ 
			//this.save(saveDirectoryMIDI+/+saveFilesMIDI[loadMenuMIDI.value]) 
			properties[key][11].writeArchive(saveFilesMIDI[loadMenuMIDI.value]);
		});
		Button(t.views[0], Rect(366, 4, 20, 20))
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
						path= saveDirectoryMIDI+/+(name);
						//this.save(path);
						("saving this:"+properties[key][11]).postln;
						properties[key][11].writeArchive(path);
						//currentSaveFile= path;
						saveFilesMIDI= (saveDirectoryMIDI++"*").standardizePath.pathMatch;
						{loadMenuMIDI.items= saveFilesMIDI.collect({|it| it.basename.asSymbol});}.defer;
						loadMenuMIDI.value= loadMenuMIDI.items.indexOf(name.asSymbol);
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
	
	midiView= CompositeView(t.views[0], Rect(4, 36, 400, 400)).background_(Color.new255(158, 158, 158));
	midiView.decorator=FlowLayout(w.view.bounds);
	midiView.decorator.gap=2@2;
	

makeNewMidiView= {|seq= false|
	var durationView, waitStringView, setWaitString, envView;
	
	midiView.decorator=FlowLayout(w.view.bounds);
	midiView.decorator.gap=2@2;

	PopUpMenu(midiView, 150@20)
	.items_(["single value", "onset detect", "sequencer"])
	.value_(properties[key][11][3])
	.background_(Color.white)
	.canFocus_(false)
	.font_(Font("Helvetica", 15))
	.action_({|v|
		var val;
		val= v.value;
		properties[key][11][3]= v.value;
		case
		{v.value == 0} {
			properties[key][11][3]= v.value.deepCopy;
			//remove view
			midiView.remove;
			//add view
			midiView= CompositeView(t.views[0], Rect(4, 36, 400, 400));
			properties[key][11][1]= [1, 0]; //noteon
			properties[key][11][2]= [1, 0]; //noteoff
			properties[key][11][3]= 0; //type (0 = single)
			properties[key][11][4]= 0.3; //duration
			//properties[key][11][5]= 1; //midimsgType *change*
			makeNewMidiView.value;
			}
		{v.value == 1} {
			properties[key][11][3]= v.value.deepCopy;
			//remove view
			midiView.remove;
			//add view
			midiView= CompositeView(t.views[0], Rect(4, 36, 400, 400));
			properties[key][11][1]= [1, 0]; //noteon
			properties[key][11][2]= [1, 0]; //noteoff
			properties[key][11][3]= 1; //type (1 = onset)
			properties[key][11][4]= 0.3; //duration
			//properties[key][11][5]= 1; //midimsgType *change*
			makeNewMidiView.value;
			}
		{v.value == 2} { // make sequencer
			properties[key][11][3]= v.value.deepCopy;
			//remove view
			midiView.remove;
			//add view
			midiView= CompositeView(t.views[0], Rect(4, 36, 400, 400));
			properties[key][11][1]= [1, [[0.0, 0.5], [0.1, 0.8]]]; //noteon
			properties[key][11][2]= [1, 0]; //noteoff
			properties[key][11][3]= 2; //type (2 = seq)
			properties[key][11][4]= a.length(("snd"++(key).asString).asSymbol); //duration
			//properties[key][11][5]= 1;  //midimsgType *change*
			//properties[key][11][1]= [[1, [[0.0, 0.5], [0.1, 0.8]]] [1, 0], 2, a.length(("snd"++(key).asString).asSymbol), 95];
			("sound length:"+a.length(("snd"++(key).asString).asSymbol)).postln;
			//properties[key][15][1][label][1]= [[0.0, 0.5], [0.1, 0.8]];
			("making seq with these props:"+properties[key][11]).postln;
			makeNewMidiView.value(true);
			};
	});
	
	PopUpMenu(midiView, 150@20)
	.items_(["submaster", "macro", "go cue", "grandmaster"])
	.value_(properties[key][11][5])
	.background_(Color.white)
	.canFocus_(false)
	.font_(Font("Helvetica", 12))
	.action_({|v|
		var val;
		val= v.value;
		properties[key][11][5]= v.value;
		/*
		case
		{v.value == 0} {
			properties[key][11][5]= v.value;
			
			//remove view
			midiView.remove;
			//add view
			midiView= CompositeView(t.views[0], Rect(4, 36, 400, 400));
			properties[key][11][1]= [1, 0]; //noteon
			properties[key][11][2]= [1, 0]; //noteoff
			properties[key][11][3]= 0; //type (0 = single)
			properties[key][11][4]= 0.3; //duration
			properties[key][11][5]= 1; //midimsgType *change*
			makeNewMidiView.value;
			
			}
		{v.value == 1} {
			properties[key][11][5]= v.value;
			
			//remove view
			midiView.remove;
			//add view
			midiView= CompositeView(t.views[0], Rect(4, 36, 400, 400));
			properties[key][11][1]= [1, 0]; //noteon
			properties[key][11][2]= [1, 0]; //noteoff
			properties[key][11][3]= 1; //type (1 = onset)
			properties[key][11][4]= 0.3; //duration
			properties[key][11][5]= 1; //midimsgType *change*
			makeNewMidiView.value;
			}
		{v.value == 2} { // make sequencer
			properties[key][11][3]= v.value;
			//remove view
			midiView.remove;
			//add view
			midiView= CompositeView(t.views[0], Rect(4, 36, 400, 400));
			properties[key][11][1]= [1, [[0.0, 0.5], [0.1, 0.8]]]; //noteon
			properties[key][11][2]= [1, 0]; //noteoff
			properties[key][11][3]= 2; //type (2 = seq)
			properties[key][11][4]= a.length(("snd"++(key).asString).asSymbol); //duration
			properties[key][11][5]= 1;  //midimsgType *change*
			//properties[key][11][1]= [[1, [[0.0, 0.5], [0.1, 0.8]]] [1, 0], 2, a.length(("snd"++(key).asString).asSymbol), 95];
			("sound length:"+a.length(("snd"++(key).asString).asSymbol)).postln;
			//properties[key][15][1][label][1]= [[0.0, 0.5], [0.1, 0.8]];
			("making seq with these props:"+properties[key][11][1]).postln;
			makeNewMidiView.value(true);
			};
			*/
	});
	
	StaticText(midiView, Rect(0, 0, 400, 30)).string_("NOTE ON:").align_(\center);
	
	if(properties[key][11][3] == 2, {
		//"making seq".postln; 
	("chek dis val:"+properties[key][11][1][0]).postln;
	midiNoteOnSlider= EZSlider(midiView, 392@30, 
		"subm",
		[0, 300, \lin, 1].asSpec,
		initVal: properties[key][11][1][0], 
		numberWidth:60,
		layout:\horz)
		.setColors(Color.grey,Color.white)
		.font_(Font("Helvetica",20))
		.action_({|v|
			properties[key][11][1][0]= v.value;
			properties[key][11][2][0]= v.value;
			midiNoteOffSlider.value= v.value;
		});
	
	StaticText(midiView, 55@20).string_("Duration:");
	durationView= NumberBox(midiView, 70@20)
	.value_(properties[key][11][4])
	.action_({|v|
		properties[key][11][4]= v.value;
		setWaitString.value(envView);
		});
	StaticText(midiView, 30@20).string_("sec");

envView = EnvelopeView(midiView, Rect(0, 0, 400, 200))
	.drawLines_(true)
	.selectionColor_(Color.red)
	.drawRects_(true)
	.resize_(5)
	.step_(0.005)
	.background_(Color.white)
	.gridOn_(true)
	.grid_((1/durationView.value)@0)
	.action_({arg view;
		setWaitString.value(view);
		view.value[1].do({|it, i|
			view.setString(i, it.asString);
		});
		properties[key][11][1][1]= view.value;
	//[view.index, view.value].postln
	})
	.thumbSize_(15)
	.thumbWidth_(30)
	.fillColor_(Color.green)
	.value_(
	properties[key][11][1][1]
	//[[0.0, 0.1, 0.5, 1.0],[0.1,1.0,0.8,0.0]]
	)
	.mouseDownAction_({|view, x, y, mod, button, click|
		if(click == 2, {
			y= ((y / view.bounds.height)-1).abs;
			x= x / view.bounds.width;
			view.addValue(x, y);
		});
		setWaitString.value(view);
	})
	.mouseUpAction_({|view, x, y, mod, button, click|
		setWaitString.value(view);
		view.value[1].do({|it, i|
			view.setString(i, it.asString);
		});
		//view.value.postln;
	});
	
	
waitStringView= StaticText(midiView, 400@20).resize_(5);

setWaitString= {|view|
var a;
a= view.value[0].collect({|it, i|
	case
	{i == 0} { (i.asString++"wait:"++((view.value[0][i+1]-view.value[0][i])*durationView.value).round(0.01)) }
	{i == (view.value[0].size-1)} { "end +"+(((view.value[0][i]-1).abs*durationView.value).round(0.01)) }
	{i > 0} { (i.asString++"wait:"++((view.value[0][i+1]-view.value[0][i])*durationView.value).round(0.01)) }

	});
waitStringView.string=  (a.asString);
};

setWaitString.value(envView);

		}, {
			//"NOT making seq!".postln;
			
	//StaticText(midiView, Rect(0, 0, 300, 30)).string_("NOTE ON:").align_(\center);
	midiNoteOnSlider= EZSlider(midiView, 392@30, 
		"subm",
		[0, 300, \lin, 1].asSpec,
		initVal: properties[key][11][1][0], 
		numberWidth:60,
		layout:\horz)
		.setColors(Color.grey,Color.white)
		.font_(Font("Helvetica",20))
		.action_({|v|
			properties[key][11][1][0]= v.value;
			properties[key][11][2][0]= v.value;
			midiNoteOffSlider.value= v.value;
		});
	midiNoteOnValSlider= EZSlider(midiView, 392@30, 
		"val",
		[0, 100, \lin, 1].asSpec,
		initVal: properties[key][11][1][1], 
		numberWidth:60,
		layout:\horz)
		.setColors(Color.grey,Color.white)
		.font_(Font("Helvetica",20))
		.action_({|v|
			properties[key][11][1][1]= v.value;
			if(testMIDI, {
				if(midiOut.isNil.not, {
					midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][1][0], 0x00, properties[key][11][1][1], 0x00, 0xf7]);
				});
			});
		});


	
		});

		
	StaticText(midiView, Rect(0, 0, 300, 30)).string_("NOTE OFF:").align_(\center);
	midiNoteOffSlider= EZSlider(midiView, 392@30, 
		"subm",
		[0, 300, \lin, 1].asSpec,
		initVal: properties[key][11][2][0], 
		numberWidth:60,
		layout:\horz)
		.setColors(Color.grey,Color.white)
		.font_(Font("Helvetica",20))
		.action_({|v|
			properties[key][11][2][0]= v.value;
		});
	midiNoteOffValSlider= EZSlider(midiView, 392@30, 
		"val",
		[0, 100, \lin, 1].asSpec,
		initVal: properties[key][11][2][1], 
		numberWidth:60,
		layout:\horz)
		.setColors(Color.grey,Color.white)
		.font_(Font("Helvetica",20))
		.action_({|v|
			properties[key][11][2][1]= v.value;
			if(testMIDI, {
				if(midiOut.isNil.not, {
					midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][2][0], 0x00, properties[key][11][2][1], 0x00, 0xf7]);
				});
			});
		});
		
	if(properties[key][11][3] == 1, {
		StaticText(midiView, Rect(0, 0, 70, 30))
		.string_("Duration:");
		NumberBox(midiView, Rect(0, 0, 100, 20))
		.value_(properties[key][11][4])
		.action_({|v| properties[key][11][4]= v.value })
		.clipLo_(0)
		.clipHi_(1.5);
	});

	};
	
	makeNewMidiView.value;

		
// ======== O S C =======

// button to choose which host to send to
//	when pressed check if handshake has been made if not make handshake
//	use NetAddr, stored in Dict (its only sending so dont need much OSCfuncs)

// for noteon and noteoff:

// menu with relative options of \symbols - commands
// direct value or ramp to (fork?)


	t.views[1].decorator=FlowLayout(w.view.bounds);
	t.views[1].decorator.gap=2@2;
	
	oscOnOffBut= Button(t.views[1], Rect(0, 0, 100, 30))
	.canFocus_(false)
	.states_([["OSC send OFF", Color.grey, Color.black], ["OSC send ON", Color.green, Color.black]])
	.value_(properties[key][15][0])
	.action_({|v| 
		properties[key][15][0]= v.value;
	});

Button(t.views[1], Rect(0, 0, 30, 30))
.states_([["-"]])
.canFocus_(false)
.action_({
	if (oscTab.views.size > 0, {
			properties[key][15][1].removeAt(oscTab.labels[oscTab.activeTab].asSymbol);
			oscTab.removeAt(oscTab.activeTab);
		});
});
Button(t.views[1], Rect(0, 0, 30, 30))
.states_([["+"]])
.canFocus_(false)
.action_({
	if(oscTab.labels.indexOfEqual(robotMenu.item.asString).isNil, {
		oscTab.add(robotMenu.item);
		properties[key][15][1].add(robotMenu.item.deepCopy -> robotDict[robotMenu.item][2].deepCopy);
		makeNewOscTab.value(oscTab.labels.size-1, robotMenu.item);
	}, {"Allready a Tab for this Robot!!".postln;});
});
robotMenu= PopUpMenu(t.views[1], Rect(0, 0, 100, 30))
.items_(robotDict.keys.asArray)
.background_(Color.white)
.canFocus_(false)
.font_(Font("Helvetica", 15));

t.views[1].decorator.nextLine;



// ============  OSC Load Save Menu  ============

saveDirectoryOSC= (String.scDir.dirname ++ "/Resources/SENDWINSAVES/OSC/");
//saveDirectoryOSC= "/Users/martin/scwork/samplerProject/Sampler \Central.app/Contents/Resources/SENDWINSAVES/OSC/";

		saveFilesOSC= (saveDirectoryOSC++"*").standardizePath.pathMatch;
		//saveDirectory.postln;
		//saveFiles.postln;
		StaticText(t.views[1], 58@30).string_("save/load:").align_(\left);
		loadMenuOSC= PopUpMenu(t.views[1], 100@20) // -----
		.items_(saveFilesOSC.collect({|it| it.basename}))
		.canFocus_(false)
		.background_(Color.white)
		.font_(Font("Helvetica", 10))
		.action_({|v|
			loadMenuItemOSC= v.items.at(v.value);
			if(verbose, {
			loadMenuItemOSC.postln; 
			saveFilesOSC[loadMenuOSC.value].postln;
			});
		});
		//load preset
		Button(t.views[1], 20@20) // ------
		.states_([["L", Color.red, Color.black]])
		.canFocus_(false)
		.font_(Font("Helvetica", 10))
		.action_({
			var loadArray;
			if (loadMenuItemOSC.isNil.not, { 
				//this.load(saveFilesOSC[loadMenuOSC.value])
				//("before load:"+properties[key][11]).postln;
				loadArray= Object.readArchive(saveFilesOSC[loadMenuOSC.value]);
				properties[key][15][0]= loadArray[0];
				oscOnOffBut.value= properties[key][15][0];
				// remove all tabs and properties
				(oscTab.views.size).do({|it|
					//properties[key][15][1].removeAt(oscTab[it].asSymbol);
					// maybe properties[key][15][1]= Dictionary.new;
					oscTab.removeAt(it);
				});
				properties[key][15][1]= loadArray[1].postln;
				
				properties[key][15][1].keysValuesDo({|name, value, i|
					var seq= false;
					oscTab.add(name);
					//("checkit:"+properties[key][15][1][name][0]).postln;
					if(value[1] == 2, { seq= true});
					makeNewOscTab.value(i, name, seq); //|i, label, seq= false|
				});
				
				("after load:"+properties[key][15]).postln;
			});
		});
		Button(t.views[1], 30@20)
		.states_([["qs"]])
		.canFocus_(false)
		.font_(Font("Helvetica", 12))
		.action_({ 
			//this.save(saveDirectoryOSC+/+saveFilesOSC[loadMenuOSC.value]) 
			properties[key][11].writeArchive(saveDirectoryOSC+/+saveFilesOSC[loadMenuOSC.value]);
		});
		Button(t.views[1], 20@20)
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
						path= saveDirectoryOSC+/+(name);
						//this.save(path);
						("saving this:"+properties[key][15]).postln;
						properties[key][15].writeArchive(path);
						//currentSaveFile= path;
						saveFilesOSC= (saveDirectoryOSC++"*").standardizePath.pathMatch;
						{loadMenuOSC.items= saveFilesOSC.collect({|it| it.basename.asSymbol});}.defer;
						loadMenuOSC.value= loadMenuOSC.items.indexOf(name.asSymbol);
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


oscTab= TabbedView(t.views[1], Rect(0, 0, 400, 400), properties[key][15][1].keys, [Color.new255(158, 158, 158)]);

properties[key][15][1].keysValuesDo({|name, value, i|
	var seq= false;
	var durationView, waitStringView, setWaitString, envView;
	
	if(value[1] == 2, { seq= true});
	
	oscTab.views[i].decorator=FlowLayout(w.view.bounds);
	oscTab.views[i].decorator.gap=2@2;
	
	oscTypeMenu= PopUpMenu(oscTab.views[i], 150@20)
	.items_(["single value", "onset detect", "sequencer"])
	.background_(Color.white)
	.canFocus_(false)
	.value_(properties[key][15][1][name][1])
	.font_(Font("Helvetica", 15))
	.action_({|v|
		properties[key][15][1][name][1]= v.value.deepCopy;
		case
		{v.value == 0} {
			//remove view
			oscTab.removeAt(oscTab.activeTab);
			//add view
			oscTab.add(name);
			properties[key][15][1][name]= robotDict[name][2].deepCopy;
			makeNewOscTab.value(oscTab.labels.size-1, name, false);
			oscTab.focus(oscTab.labels.size-1);
			}
		{v.value == 1} {
			properties[key][15][1][name]= robotDict[name][2].deepCopy;
			properties[key][15][1][name][1]= v.value;
			//remove view
			oscTab.removeAt(oscTab.activeTab);
			//add view
			oscTab.add(name);
			makeNewOscTab.value(oscTab.labels.size-1, name, false);
			oscTab.focus(oscTab.labels.size-1);
			}
		{v.value == 2} {
			//remove view
			oscTab.removeAt(oscTab.activeTab);
			//add view
			oscTab.add(name);
			properties[key][15][1][name]= [[[0.0, 0.5], [0.1, 0.8]], 2, a.length(("snd"++(key).asString).asSymbol), 95];
			("sound length:"+a.length(("snd"++(key).asString).asSymbol)).postln;
			//("making seq with these props:"+properties[key][15][1][name]).postln;
			makeNewOscTab.value(oscTab.labels.size-1, name, true);
			oscTab.focus(oscTab.labels.size-1);
			};
	});
	
	StaticText(oscTab.views[i], Rect(0, 0, 400, 30)).string_("NOTE ON:").align_(\center);
	
	if(seq, {
		//"making seq".postln; value[0].postln;
	
	StaticText(oscTab.views[i], 55@20).string_("Duration:");
	durationView= NumberBox(oscTab.views[i], 50@20)
	.value_(properties[key][15][1][name][2])
	.action_({|v|
		properties[key][15][1][name][2]= v.value;
		setWaitString.value(envView);
		});
	StaticText(oscTab.views[i], 30@20).string_("sec");

envView = EnvelopeView(oscTab.views[i], Rect(0, 0, 400, 200))
	.drawLines_(true)
	.selectionColor_(Color.red)
	.drawRects_(true)
	.resize_(5)
	.step_(0.005)
	.background_(Color.white)
	.gridOn_(true)
	.grid_((1/durationView.value)@0)
	.action_({arg view;
		setWaitString.value(view);
		view.value[1].do({|it, i|
			view.setString(i, it.asString);
		});
		properties[key][15][1][name][0]= view.value;
		//[view.index, view.value].postln
	})
	.thumbSize_(15)
	.thumbWidth_(30)
	.fillColor_(Color.green)
	.value_(
	value[0]
	//[[0.0, 0.1, 0.5, 1.0],[0.1,1.0,0.8,0.0]]
	)
	.mouseDownAction_({|view, x, y, mod, button, click|
		if(click == 2, {
			y= ((y / view.bounds.height)-1).abs;
			x= x / view.bounds.width;
			view.addValue(x, y);
		});
		setWaitString.value(view);
	})
	.mouseUpAction_({|view, x, y, mod, button, click|
		setWaitString.value(view);
		view.value[1].do({|it, i|
			view.setString(i, it.asString);
		});
		//view.value.postln;
	});
	
	
waitStringView= StaticText(oscTab.views[i], 400@20).resize_(5);

setWaitString= {|view|
var a;
a= view.value[0].collect({|it, i|
	case
	{i == 0} { (i.asString++"wait:"++((view.value[0][i+1]-view.value[0][i])*durationView.value).round(0.01)) }
	{i == (view.value[0].size-1)} { "end +"+(((view.value[0][i]-1).abs*durationView.value).round(0.01)) }
	{i > 0} { (i.asString++"wait:"++((view.value[0][i+1]-view.value[0][i])*durationView.value).round(0.01)) }

	});
waitStringView.string=  (a.asString);
};

setWaitString.value(envView);

		}, {
			//"NOT making seq!".postln;
	EZSlider(oscTab.views[i], 392@30, 
		name, // label
		robotDict[name][1], // control spec
		initVal: value[0][0], 
		numberWidth:60,
		layout:\horz)
		.setColors(Color.grey,Color.white)
		.font_(Font("Helvetica",20))
		.action_({|v|
			properties[key][15][1][name][0][0]= v.value;
		});

	});
		
	StaticText(oscTab.views[i], Rect(0, 0, 300, 30)).string_("NOTE OFF:").align_(\center);
	EZSlider(oscTab.views[i], 392@30, 
		name, // label
		robotDict[name][1], // control spec
		initVal: 	
			if(properties[key][15][1][name][1] == 2, {
				properties[key][15][1][name][3];
			},{
				properties[key][15][1][name][0][1];
			}), // init value 
		numberWidth:60,
		layout:\horz)
		.setColors(Color.grey,Color.white)
		.font_(Font("Helvetica",20))
		.action_({|v|
			if(properties[key][15][1][name][1] == 2, {
				properties[key][15][1][name][3]= v.value;
			},{
				properties[key][15][1][name][0][1]= v.value;
			})
			
		});
		
	

});

makeNewOscTab= {|i, label, seq= false|
	var durationView, waitStringView, setWaitString, envView;
	
	oscTab.views[i].decorator=FlowLayout(w.view.bounds);
	oscTab.views[i].decorator.gap=2@2;

	oscTypeMenu= PopUpMenu(oscTab.views[i], 150@20)
	.items_(["single value", "onset detect", "sequencer"])
	.value_(properties[key][15][1][label][1])
	.background_(Color.white)
	.canFocus_(false)
	.font_(Font("Helvetica", 15))
	.action_({|v|
		var val;
		val= v.value;
		properties[key][15][1][label][1]= v.value;
		case
		{v.value == 0} {
			//remove view
			oscTab.removeAt(oscTab.activeTab);
			//add view
			oscTab.add(label);
			properties[key][15][1][label]= robotDict[label][2].deepCopy;
			//properties[key][15][1][label][1]= 0;
			makeNewOscTab.value(oscTab.labels.size-1, label, false);
			oscTab.focus(oscTab.labels.size-1);
			}
		{v.value == 1} {
			properties[key][15][1][label]= robotDict[label][2].deepCopy;
			properties[key][15][1][label][1]= v.value.deepCopy;
			//remove view
			oscTab.removeAt(oscTab.activeTab);
			//add view
			oscTab.add(label);
			makeNewOscTab.value(oscTab.labels.size-1, label, false);
			oscTab.focus(oscTab.labels.size-1);
			}
		{v.value == 2} { // make sequencer
			//remove view
			oscTab.removeAt(oscTab.activeTab);
			//add view
			oscTab.add(label);
			properties[key][15][1][label]= [[[0.0, 0.5], [0.1, 0.8]], 2, a.length(("snd"++(key).asString).asSymbol), 95];
			("sound length:"+a.length(("snd"++(key).asString).asSymbol)).postln;
			//properties[key][15][1][label][1]= [[0.0, 0.5], [0.1, 0.8]];
			//("making seq with these props:"+properties[key][15][1][label]).postln;
			makeNewOscTab.value(oscTab.labels.size-1, label, true);
			oscTab.focus(oscTab.labels.size-1);
			};
	});
	
	StaticText(oscTab.views[i], Rect(0, 0, 400, 30)).string_("NOTE ON:").align_(\center);
	
	if(seq, {
		//"making seq".postln; 
			
	StaticText(oscTab.views[i], 55@20).string_("Duration:");
	durationView= NumberBox(oscTab.views[i], 50@20)
	.value_(properties[key][15][1][label][2])
	.action_({|v|
		properties[key][15][1][label][2]= v.value;
		setWaitString.value(envView);
		});
	StaticText(oscTab.views[i], 30@20).string_("sec");

envView = EnvelopeView(oscTab.views[i], Rect(0, 0, 400, 200))
	.drawLines_(true)
	.selectionColor_(Color.red)
	.drawRects_(true)
	.resize_(5)
	.step_(0.005)
	.background_(Color.white)
	.gridOn_(true)
	.grid_((1/durationView.value)@0)
	.action_({arg view;
		setWaitString.value(view);
		view.value[1].do({|it, i|
			view.setString(i, it.asString);
		});
		properties[key][15][1][label][0]= view.value;
	//[view.index, view.value].postln
	})
	.thumbSize_(15)
	.thumbWidth_(30)
	.fillColor_(Color.green)
	.value_(
	properties[key][15][1][label][0]
	//[[0.0, 0.1, 0.5, 1.0],[0.1,1.0,0.8,0.0]]
	)
	.mouseDownAction_({|view, x, y, mod, button, click|
		if(click == 2, {
			y= ((y / view.bounds.height)-1).abs;
			x= x / view.bounds.width;
			view.addValue(x, y);
		});
		setWaitString.value(view);
	})
	.mouseUpAction_({|view, x, y, mod, button, click|
		setWaitString.value(view);
		view.value[1].do({|it, i|
			view.setString(i, it.asString);
		});
		//view.value.postln;
	});
	
	
waitStringView= StaticText(oscTab.views[i], 400@20).resize_(5);

setWaitString= {|view|
var a;
a= view.value[0].collect({|it, i|
	case
	{i == 0} { (i.asString++"wait:"++((view.value[0][i+1]-view.value[0][i])*durationView.value).round(0.01)) }
	{i == (view.value[0].size-1)} { "end +"+(((view.value[0][i]-1).abs*durationView.value).round(0.01)) }
	{i > 0} { (i.asString++"wait:"++((view.value[0][i+1]-view.value[0][i])*durationView.value).round(0.01)) }

	});
waitStringView.string=  (a.asString);
};

setWaitString.value(envView);

		}, {
			//"NOT making seq!".postln;
			
	EZSlider(oscTab.views[i], 392@30, 
		robotDict[label.asSymbol][0], // label
		robotDict[label.asSymbol][1], // control spec
		initVal: robotDict[label.asSymbol][2][0][0], 
		numberWidth:60,
		layout:\horz)
		.setColors(Color.grey,Color.white)
		.font_(Font("Helvetica",20))
		.action_({|v|
			properties[key][15][1][label][0][0]= v.value;
		});
	
		});

	StaticText(oscTab.views[i], Rect(0, 0, 300, 30)).string_("NOTE OFF:").align_(\center);
	EZSlider(oscTab.views[i], 392@30, 
		robotDict[label.asSymbol][0], // label
		robotDict[label.asSymbol][1], // control spec
		initVal: 	
			if(properties[key][15][1][label][1] == 2, {
				properties[key][15][1][label][3];
			},{
				properties[key][15][1][label][0][1];
			}), // init value
		numberWidth:60,
		layout:\horz)
		.setColors(Color.grey,Color.white)
		.font_(Font("Helvetica",20))
		.action_({|v|
			if(properties[key][15][1][label][1] == 2, {
				properties[key][15][1][label][3]= v.value;
			},{
				properties[key][15][1][label][0][1]= v.value;
			});
		});
		
	if(properties[key][15][1][label][1] == 1, {
		StaticText(oscTab.views[i], Rect(0, 0, 70, 30))
		.string_("Duration:");
		NumberBox(oscTab.views[i], Rect(0, 0, 100, 20))
		.value_(properties[key][15][1][label][2])
		.action_({|v| properties[key][15][1][label][2]= v.value })
		.clipLo_(0)
		.clipHi_(1.5);
	});

	};


// =============== D M X ==================

	t.views[2].decorator=FlowLayout(w.view.bounds);
	t.views[2].decorator.gap=2@2;


	dmxOnOffBut= Button(t.views[2], Rect(0, 0, 60, 20))
	.canFocus_(false)
	.states_([["DMX OFF", Color.grey, Color.black], ["DMX ON", Color.green, Color.black]])
	.value_(properties[key][16][0])
	.action_({|v| 
		properties[key][16][0]= v.value;
	});
	
Button(t.views[2], Rect(0, 0, 60, 20))
.canFocus_(false)
.states_([["rcv Dump", Color.white, Color.black], ["rcv Dump", Color.green, Color.black]])
.action_({|v|
	if(v.value == 1, {
		//somehow receive dmx
		}, {
		// stop that somehow
		});
});

Button(t.views[2], Rect(0, 0, 30, 20))
.canFocus_(false)
.states_([["tst", Color.white, Color.black], ["tst", Color.green, Color.black]])
.action_({|v|
	if(v.value == 1, {testDMX= true}, {testDMX= false});
});


// ============  DMX Load Save Menu  ============

saveDirectoryDMX= (String.scDir.dirname ++ "/Resources/SENDWINSAVES/DMX/");
//saveDirectoryDMX= "/Users/martin/scwork/samplerProject/Sampler \Central.app/Contents/Resources/SENDWINSAVES/DMX/";

		saveFilesDMX= (saveDirectoryDMX++"*").standardizePath.pathMatch;
		//saveDirectory.postln;
		//saveFiles.postln;
		StaticText(t.views[2], 58@30).string_("save/load:").align_(\left);
		loadMenuDMX= PopUpMenu(t.views[2], 100@20) // -----
		.items_(saveFilesDMX.collect({|it| it.basename}))
		.canFocus_(false)
		.background_(Color.white)
		.font_(Font("Helvetica", 10))
		.action_({|v|
			loadMenuItemDMX= v.items.at(v.value);
			if(verbose, {
			//loadMenuItemDMX.postln; 
			//saveFilesDMX[loadMenuDMX.value].postln;
			});
		});
		//load preset
		Button(t.views[2], 20@20) // ------
		.states_([["L", Color.red, Color.black]])
		.canFocus_(false)
		.font_(Font("Helvetica", 10))
		.action_({ 
			var loadArray;
			if (loadMenuItemDMX.isNil.not, { 
				//this.load(saveFilesDMX[loadMenuDMX.value])
				//("before load:"+properties[key][16]).postln;
				loadArray= Object.readArchive(saveFilesDMX[loadMenuDMX.value]);
				//saveFilesDMX[loadMenuDMX.value].postln;
				//("loadArray:"+loadArray).postln;
				properties[key][16][0]= loadArray[0];
				dmxOnOffBut.value= properties[key][16][0];
				properties[key][16][1][0]= DMXSubCue.new;
				properties[key][16][1][1]= DMXSubCue.new;
				loadArray[1][0][0].do({|it, i| properties[key][16][1][0].put(it, loadArray[1][0][1][i]) });
				loadArray[1][1][0].do({|it, i| properties[key][16][1][1].put(it, loadArray[1][1][1][i]) });
				
				//("after load:"+properties[key][16]).postln;
				updateDmxNoteOnView.value;
				updateDmxNoteOffView.value;
				
			});
		});
		Button(t.views[2], 30@20)
		.states_([["qs"]])
		.canFocus_(false)
		.font_(Font("Helvetica", 12))
		.action_({
			var noteOnChans, noteOnVal, noteOffChans, noteOffVals, saveArray;
			//this.save(saveDirectoryDMX+/+saveFilesDMX[loadMenuDMX.value]) 
			//noteOnChans= properties[key][16][1][0].data.indices.collect({|it| it})
			saveArray= [properties[key][16][0], [[properties[key][16][1][0].data.indices, properties[key][16][1][0].data], [properties[key][16][1][1].data.indices, properties[key][16][1][1].data]]];
			//saveArray= [properties[key][16][0], [properties[key][16][1][0].indices, properties[key][16][1][0].data, properties[key][16][1][1].indices, properties[key][16][1][1].data ]]
			saveArray.writeArchive(saveDirectoryDMX+/+saveFilesDMX[loadMenuDMX.value]);
		});
		Button(t.views[2], 20@20)
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
					var saveArray;
					
					stringSize= t.string.size;
					if (stringSize > 0, {
						name= t.string;
						path= saveDirectoryDMX+/+(name);
						saveArray= [properties[key][16][0], [[properties[key][16][1][0].data.indices, properties[key][16][1][0].data.asArray], [properties[key][16][1][1].data.indices, properties[key][16][1][1].data.asArray]]];
						//this.save(path);
						//("saving this:"+saveArray).postln;
						saveArray.writeArchive(path);
						//currentSaveFile= path;
						saveFilesDMX= (saveDirectoryDMX++"*").standardizePath.pathMatch;
						{loadMenuDMX.items= saveFilesDMX.collect({|it| it.basename.asSymbol});}.defer;
						loadMenuDMX.value= loadMenuDMX.items.indexOf(name.asSymbol);
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
		
t.views[2].decorator.nextLine;


	StaticText(t.views[2], Rect(0, 0, 400, 30)).string_("NOTE ON:").align_(\center);

Button(t.views[2], Rect(0, 0, 30, 20))
.states_([["-"]])
.canFocus_(false)
.action_({
	if (dmxNoteOnSliders.size > 0, {
			properties[key][16][1][0].data.removeAtSlot(dmxNoteOnViewSelect.value);
			dmxNoteOnViewSelect.value= 0;
			dmxNoteOnViewSelect.clipHi= (properties[key][16][1][0].data.size-1);
			updateDmxNoteOnView.value;
		});
	//also remove noteoff
	if(addBlack, {
		if (dmxNoteOffSliders.size > 0, {
			properties[key][16][1][1].data.removeAtSlot(dmxNoteOffViewSelect.value);
			dmxNoteOffViewSelect.value= 0;
			dmxNoteOffViewSelect.clipHi= (properties[key][16][1][1].data.size-1);
			updateDmxNoteOffView.value;
		});
	});
});


dmxNoteOnViewSelect= NumberBox(t.views[2], Rect(0, 0, 30, 20))
		.value_(0)
		.step_(1)
		.scroll_step_(1)
		.clipLo_(0)
		.clipHi_(
			{properties[key][16][1][0].data.size -1}.try;
		)
		.action_({|v| 
			{ dmxNoteOnSliders[v.value].sliderView.focus }.defer;
			dmxNoteOffViewSelect.value= v.value;
		});


Button(t.views[2], Rect(0, 0, 30, 20))
.states_([["+"]])
.canFocus_(false)
.action_({
	if(properties[key][16][1][0].data.indices.includes(dmxNoteOnViewAdd.value.asInteger).not, {
		properties[key][16][1][0].put(dmxNoteOnViewAdd.value, 0);
		dmxNoteOnViewSelect.clipHi= (properties[key][16][1][0].data.size -1);
		updateDmxNoteOnView.value;
		if(addBlack, {
			properties[key][16][1][1].put(dmxNoteOnViewAdd.value, 0);
			dmxNoteOffViewSelect.clipHi= (properties[key][16][1][1].data.size -1);
			updateDmxNoteOffView.value;		
		});
	}, {"Allready a Fader for this Channel!!".postln;});
});


dmxNoteOnViewAdd= NumberBox(t.views[2], Rect(0, 0, 30, 20))
		.value_(0)
		.step_(1)
		.scroll_step_(1)
		.clipLo_(0)
		.clipHi_(512);


Button(t.views[2], Rect(0, 0, 60, 20))
.canFocus_(false)
.states_([["add BLK", Color.white, Color.black], ["add BLK", Color.green, Color.black]])
.value_(1)
.action_({|v|
	if(v.value == 1, {addBlack= true}, {addBlack= false});
});


t.views[2].decorator.nextLine;

dmxNoteOnScroll= ScrollView(t.views[2], 400@300);
dmxNoteOnScroll.hasVerticalScroller= false;
dmxNoteOnScroll.hasHorizontalScroller= true;


dmxNoteOnLayout= CompositeView(dmxNoteOnScroll, 800@300).decorator_(FlowLayout(w.view.bounds));


if( properties[key][16][1][0].data.size > 0, {
dmxNoteOnView= properties[key][16][1][0].data.indices.collect({|it, i|
		CompositeView(dmxNoteOnLayout, Rect(0, 0, 30, 300));
});

dmxNoteOnChannel= properties[key][16][1][0].data.indices.collect({|it, i|
		NumberBox(dmxNoteOnView[i], 30@20)
		.value_(it)
		//.background_(white)
		.step_(1)
		.clipLo_(0)
		.clipHi_(512)
		.action_({|v|
			properties[key][16][1][0].put(v.value, dmxNoteOnSliders[i].value);
		});
});

dmxNoteOnSliders= properties[key][16][1][0].data.indices.collect({|it, i|
		EZSlider(dmxNoteOnView[i], Rect(0, 20, 30, 260), 
		nil, // label
		[0.0, 1.0, \lin, 0.01].asSpec, // control spec
		initVal: properties[key][16][1][0].at(properties[key][16][1][0].data.indices[i]), 
		numberWidth:20,
		layout:\vert)
		.setColors(Color.grey,Color.white)
		.font_(Font("Helvetica",10))
});


dmxNoteOnSliders.do({ |it, i|
		dmxNoteOnSliders[i].sliderView.mouseUpAction= ({
			properties[key][16][1][0].put(dmxNoteOnChannel[i].value, dmxNoteOnSliders[i].value);
			//~dmx.postln;
			//properties[key][16][1][0].postln;
			//properties[key][16][1][0].data.postln;
			if(testDMX, { ~dmx.fade(properties[key][16][1][0], 0.1, 'linear', 0.1) });
		});
		dmxNoteOnSliders[i].numberView.mouseUpAction= ({
			properties[key][16][1][0].put(dmxNoteOnChannel[i].value, dmxNoteOnSliders[i].value);
			if(testDMX, { ~dmx.fade(properties[key][16][1][0], 0.1, 'linear', 0.1) });
		});
});

});


updateDmxNoteOnView= {

	{
	dmxNoteOnLayout.remove;
	
	dmxNoteOnLayout= CompositeView(dmxNoteOnScroll, 800@300).decorator_(FlowLayout(w.view.bounds));
	
	dmxNoteOnView= properties[key][16][1][0].data.indices.collect({|it, i|
			CompositeView(dmxNoteOnLayout, Rect(0, 0, 30, 300));
	});
	
	dmxNoteOnChannel= properties[key][16][1][0].data.indices.collect({|it, i|
			NumberBox(dmxNoteOnView[i], 30@20)
			.value_(it)
			//.background_(white)
			.step_(1)
			.clipLo_(0)
			.clipHi_(512)
			.action_({|v|
				properties[key][16][1][0].put(v.value, dmxNoteOnSliders[i].value);
			});
	});

	//properties[key][16][1][0].at(properties[key][16][1][0].data.indices[i]).postln;	

	dmxNoteOnSliders= properties[key][16][1][0].data.indices.collect({|it, i|
		EZSlider(dmxNoteOnView[i], Rect(0, 20, 30, 260), 
		nil, // label
		[0.0, 1.0, \lin, 0.01].asSpec, // control spec
		initVal: properties[key][16][1][0].at(it), 
		numberWidth:20,
		layout:\vert)
		.setColors(Color.grey,Color.white)
		.font_(Font("Helvetica",10))
	});
	

	dmxNoteOnSliders.do({ |it, i|
		dmxNoteOnSliders[i].sliderView.mouseUpAction= ({
			properties[key][16][1][0].put(dmxNoteOnChannel[i].value, dmxNoteOnSliders[i].value);
			if(testDMX, { ~dmx.fade(properties[key][16][1][0], 0.1, 'linear', 0.1) });
		});
		dmxNoteOnSliders[i].numberView.mouseUpAction= ({
			properties[key][16][1][0].put(dmxNoteOnChannel[i].value, dmxNoteOnSliders[i].value);
			if(testDMX, { ~dmx.fade(properties[key][16][1][0], 0.1, 'linear', 0.1) });
		});
	});
	}.fork(AppClock);
};


StaticText(t.views[2], Rect(0, 0, 400, 30)).string_("NOTE OFF:").align_(\center);

t.views[2].decorator.nextLine;

Button(t.views[2], Rect(0, 0, 30, 20))
.states_([["-"]])
.canFocus_(false)
.action_({
	if (dmxNoteOffSliders.size > 0, {
			properties[key][16][1][1].data.removeAtSlot(dmxNoteOffViewSelect.value);
			dmxNoteOffViewSelect.value= 0;
			dmxNoteOffViewSelect.clipHi= (properties[key][16][1][1].data.size-1);
			updateDmxNoteOffView.value;
		});
});


dmxNoteOffViewSelect= NumberBox(t.views[2], Rect(0, 0, 30, 20))
		.value_(0)
		.step_(1)
		.scroll_step_(1)
		.clipLo_(0)
		.clipHi_( {properties[key][16][1][1].data.size -1}.try )
		.action_({|v| dmxNoteOffSliders[v.value].sliderView.focus; });

Button(t.views[2], Rect(0, 0, 30, 20))
.states_([["+"]])
.canFocus_(false)
.action_({
	if(properties[key][16][1][1].data.indices.includes(dmxNoteOffViewAdd.value.asInteger).not, {
		properties[key][16][1][1].put(dmxNoteOffViewAdd.value, 0);
		dmxNoteOffViewSelect.clipHi= (properties[key][16][1][1].data.size -1);
		updateDmxNoteOffView.value;
	}, {"Allready a Fader for this Channel!!".postln;});
});


dmxNoteOffViewAdd= NumberBox(t.views[2], Rect(0, 0, 30, 20))
		.value_(0)
		.step_(1)
		.scroll_step_(1)
		.clipLo_(0)
		.clipHi_(512);
		


t.views[2].decorator.nextLine;

dmxNoteOffScroll= ScrollView(t.views[2], 400@300);
dmxNoteOffScroll.hasVerticalScroller= false;
dmxNoteOffScroll.hasHorizontalScroller= true;

dmxNoteOffLayout= CompositeView(dmxNoteOffScroll, 800@300).decorator_(FlowLayout(w.view.bounds));

if( properties[key][16][1][0].data.size > 0, {
dmxNoteOffView= properties[key][16][1][1].data.indices.collect({|it, i|
		CompositeView(dmxNoteOffLayout, Rect(0, 0, 30, 300));
});

dmxNoteOffChannel= properties[key][16][1][1].data.indices.collect({|it, i|
		NumberBox(dmxNoteOffView[i], 30@20)
		.value_(it)
		//.background_(white)
		.step_(1)
		.clipLo_(0)
		.clipHi_(512)
		.action_({|v|
			properties[key][16][1][1].put(v.value, dmxNoteOffSliders[i].value);
		});
});

dmxNoteOffSliders= properties[key][16][1][1].data.indices.collect({|it, i|
		EZSlider(dmxNoteOffView[i], Rect(0, 20, 30, 260), 
		nil, // label
		[0.0, 1.0, \lin, 0.01].asSpec, // control spec
		initVal: properties[key][16][1][1].at(properties[key][16][1][1].data.indices[i]), 
		numberWidth:20,
		layout:\vert)
		.setColors(Color.grey,Color.white)
		.font_(Font("Helvetica",10))
});


dmxNoteOffSliders.do({ |it, i|
		dmxNoteOffSliders[i].sliderView.mouseUpAction= ({
			properties[key][16][1][1].put(dmxNoteOffChannel[i].value, dmxNoteOffSliders[i].value);
			if(testDMX, { ~dmx.fade(properties[key][16][1][1], 0.5, 'linear', 0.1) });
		});
		dmxNoteOffSliders[i].numberView.mouseUpAction= ({
			properties[key][16][1][1].put(dmxNoteOffChannel[i].value, dmxNoteOffSliders[i].value);
			if(testDMX, { ~dmx.fade(properties[key][16][1][1], 0.5, 'linear', 0.1) });
		});
});
});



updateDmxNoteOffView= {

	{
	dmxNoteOffLayout.remove;
	
	dmxNoteOffLayout= CompositeView(dmxNoteOffScroll, 800@300).decorator_(FlowLayout(w.view.bounds));
	
	dmxNoteOffView= properties[key][16][1][1].data.indices.collect({|it, i|
			CompositeView(dmxNoteOffLayout, Rect(0, 0, 30, 300));
	});
	
	dmxNoteOffChannel= properties[key][16][1][1].data.indices.collect({|it, i|
			NumberBox(dmxNoteOffView[i], 30@20)
			.value_(it)
			//.background_(white)
			.step_(1)
			.clipLo_(0)
			.clipHi_(512)
			.action_({|v|
				properties[key][16][1][1].put(v.value, dmxNoteOffSliders[i].value);
			});
	});

	//properties[key][16][1][1].at(properties[key][16][1][1].data.indices[i]).postln;	

	dmxNoteOffSliders= properties[key][16][1][1].data.indices.collect({|it, i|
		EZSlider(dmxNoteOffView[i], Rect(0, 20, 30, 260), 
		nil, // label
		[0.0, 1.0, \lin, 0.01].asSpec, // control spec
		initVal: properties[key][16][1][1].at(it), 
		numberWidth:20,
		layout:\vert)
		.setColors(Color.grey,Color.white)
		.font_(Font("Helvetica",10))
	});
	

	dmxNoteOffSliders.do({ |it, i|
		dmxNoteOffSliders[i].sliderView.mouseUpAction= ({
			properties[key][16][1][1].put(dmxNoteOffChannel[i].value, dmxNoteOffSliders[i].value);
			if(testDMX, { ~dmx.fade(properties[key][16][1][1], 0.5, 'linear', 0.1) });
		});
		dmxNoteOffSliders[i].numberView.mouseUpAction= ({
			properties[key][16][1][1].put(dmxNoteOffChannel[i].value, dmxNoteOffSliders[i].value);
			if(testDMX, { ~dmx.fade(properties[key][16][1][1], 0.5, 'linear', 0.1) });
		});
	});
	}.fork(AppClock);
};


t.focus(sendWinLastTabFocus);

w.front;

w.onClose = { 
	sendWinOpen= nil;
	//~dmx = nil;
	//{~dmx.close; }.try;
	//{~enttec.close; }.try;
	sendWinLastTabFocus= t.activeTab;
	sendWinLastPos= [w.bounds.left, w.bounds.top];
	("last focused tab:"+sendWinLastTabFocus);
	 };

};



// =============================================================================================
// =================================== LOOP POINT EDITOR =======================================
// =============================================================================================

looppointeditor= { |key|
	var w, sfView, f, frames;
		w = Window.new("set loop position", Rect(200, 200, 850, 160));
		sfView = SoundFileView.new(w, Rect(20,20, 800, 100))
		//.gridResolution
		.canFocus_(false)
		.gridColor_(Color.grey)
		.timeCursorOn_(false)
		.waveColors_([Color.red, Color.red])
		.background_(Color(0.298, 0.298, 0.298, 1.0))
		;
		sfView.setSelectionColor(0, Color.white);
		f = SoundFile.new;
		f.openRead(sounds[key]);
		frames= f.numFrames;
		sfView.soundfile = f;
		sfView.read(0, f.numFrames);
		sfView.mouseUpAction= {
			var start, end;
			start= sfView.selectionStart(0)/frames;
			end= sfView.selectionSize(0)/frames + start;
			[start, end].postln;
			properties[key][13][1]= start;
			properties[key][13][2]= end;
			if(a.isPlaying(("snd"++((key).asString)).asSymbol), {
			a.set(("snd"++((key).asString)).asSymbol).startLoop_(start);
			a.set(("snd"++((key).asString)).asSymbol).endLoop_(end);
			});
		};
		
		if(properties[key][13].isNil.not, {
			sfView.setSelectionStart(0, properties[key][13][1]*frames);
			sfView.setSelectionSize(0, (properties[key][13][2]*frames) - (properties[key][13][1]*frames));
		});
		
		
		Button(w, Rect(825, 20, 20, 20))
		.states_([["+"]])
		.canFocus_(false)
		.action_({ sfView.zoom(0.8).refresh });
		
		Button(w, Rect(825, 40, 20, 20))
		.states_([["-"]])
		.canFocus_(false)
		.action_({ sfView.zoom(1.2) });
		
		Button(w, Rect(825, 60, 20, 20))
		.states_([["0"]])
		.canFocus_(false)
		.action_({ sfView.zoomAllOut });

		Button(w, Rect(825, 90, 20, 20))
		.states_([["rm", Color.red, Color.black]])
		.canFocus_(false)
		.action_({ 
			sfView.zoomAllOut;
			properties[key][13][1]= 0;
			properties[key][13][2]= 1;
			sfView.setSelectionStart(0, properties[key][13][1]*frames);
			sfView.setSelectionSize(0, properties[key][13][2]*frames);
		});		
		
		
		Slider(w, Rect(20, 125, 800, 30))
		.canFocus_(false)
		.background_(Color(0.298, 0.298, 0.298, 1.0))
		.knobColor_(Color(0.298, 0.776, 1.0, 1.0))
		.action_({|v|
			sfView.scrollTo(v.value);
		});
		sfView.focus(true);
		w.front;
	};
	
killothernotes= { |key|
	numKeys.do({|i|
	if(i == key, {nil},{ //all other keys than key
		if (a.isPlaying(("snd"++((i).asString)).asSymbol), {
			a.stop(("snd"++((i).asString)).asSymbol, properties[i][4]);
			{ keyButs[i].value= 0 }.defer;
			if (progressState == 1, {
				progress[i].stop; 
				progressViewClear.value(i);
			});
		});
		if(arpRoutines[i].isPlaying, {arpRoutines[i].stop});
	});
	})
};

panic= {
	/*
	numKeys.do({|i|
		a.overlaps.do({
			if (a.isPlaying(("snd"++((i).asString)).asSymbol), {
				a.stop(("snd"++((i).asString)).asSymbol, properties[i][4]);
			});
		});
		//also do "snd1x1".....
		// a.flush(0);
	});
	*/
	 a.flush(0);
	
	arpRoutines.do({|it|
		if(it.isPlaying,{it.stop});
	});
	allKnobs.do({|it|
		it.setVal(0);
	});
	sliders.do({|it|
		it.setVal(0);
	});
	coyoteResponders.do({|it|
		if(it.isNil.not, {it.remove});
	});
};

arpView= {|i|
	var v, h, lenghtKnob, spaceKnob;
	//var loadASRsound;
	//h= ScrollView(c, Rect(90, 100, 120, 80));
	h= CompositeView(c, Rect(90, 100, 120, 90))
	.background_(Color.new255(229, 229, 229));
	
	lenghtKnob= EZKnob(	h,  	// parent
		Rect(10, 0, 40, 70),	// bounds
		" length ",	// label
		\rq, 	// controlSpec
		{|ez| properties[i][12][0]= ez.value }, // action
		properties[i][12][0] //init value
	);
	lenghtKnob.setColors(Color.grey,Color.white);
	
	spaceKnob = EZKnob(	h,  	// parent
		Rect(70, 0, 40, 70),	// bounds
		" space ",	// label
		\delay, 	// controlSpec
		{|ez| properties[i][12][1]= ez.value }, // action
		properties[i][12][1] //init value
	);
	spaceKnob.setColors(Color.grey,Color.white);
	
	Button(h, Rect(10, 70, 100, 18))
	.states_([["toggle (hold)", Color.white, Color.black],["toggle (hold)", Color.green, Color.black]])
	.value_(properties[i][12][2])
	.action_({|v| properties[i][12][2]= v.value });
	
};


extrasampleView= {|i, sam|
	var v, h, sambut;
	//var loadASRsound;
	//h= ScrollView(c, Rect(90, 100, 120, 80));
	h= VLayoutView(c, Rect(90, 100, 120, 90)).background_(Color.new255(229, 229, 229)).spacing_(2);

	//h= VLayoutView(v, Rect(0, 0, 110, 140));
	//properties[i][6].postln;
	if (properties[i][2] == 5, {
		PopUpMenu(h, Rect(0, 0, 80, 15))
		.canFocus_(false)
		.items_(["sequence", "random", "no reset"])
		.value_(properties[i][6])
		.action_({|menu|
			properties[i][6]= menu.value;
		});
	});

	sambut= (sam.size+1).collect({|ii|
	Button(h, Rect(0, 0, 80, 15))
	.font_(GUI.font.new("Monaco", 9))
	.canFocus_(false)
	.states_([["", textcolors[0], colors[0]]])
	.mouseDownAction_({ |view, x, y, mod|
	
		if ( mod == 131330, {  //shift
			CocoaDialog.getPaths({ arg paths; //load sound
			loadASRsound.value(paths, i, ii, view);
			/*
			if (paths[0].isString, {
			{a.freeKey(("snd"++i.asString++letters[ii]).asSymbol);}.try;
			paths[0].postln;
			a.prepareForPlay(("snd"++i.asString++letters[ii]).asSymbol, paths[0]);
			soundsASR[i][ii]= paths[0]; // where to store?????
			view.states= ([[paths[0].basename.replace(".wav", ""), textcolors[0], colors[0]]]);
			});
			*/
			},{
				"cancelled".postln;
			});
		});
		
	})
	.canReceiveDragHandler_(true)
	.receiveDragHandler_({|view|
			var paths;
			paths= View.currentDrag;
			loadASRsound.value(paths, i, ii, view);
			/*
			if (paths[0].isString, {
			{a.freeKey(("snd"++i.asString++letters[ii]).asSymbol);}.try;
			paths[0].postln;
			ii.postln;
			("snd"++i.asString++letters[ii]).asSymbol.postln;
			a.prepareForPlay(("snd"++i.asString++letters[ii]).asSymbol, paths[0]);
			soundsASR[i][ii]= paths[0]; // where to store?????
			view.states= ([[paths[0].basename.replace(".wav", ""), textcolors[0], colors[0]]]);
			}, {paths[0].postln;"ERROR: you cant drag that here".postln;});
			*/
	})
/*	.action_({|v|
		a.play(("snd"++((i).asString++"a")).asSymbol, //attack sound
				amp: 0.5,
				loop: 0,
				attack: 0.01,
				out: output
		);
	})
	*/
	;

	});
	
	//sam.postln;

	sam.size.do({|i|
	if (sam[i].isNil.not, { 
		{sambut[i].states= ([[sam[i].removeExtension, textcolors[0], colors	[0]]]);}.defer });
	});

};




progressView= {|key|
	//routine to draw progress view on key
	progress[key]= {
		var elapsed, b, mul= 10, time= a.length(("snd"++(key).asString).asSymbol).round(1);
		time= time*(properties[key][14].abs).reciprocal;
		b= keyUserViews[key];
		(time*mul).do({|i|
			elapsed= (i+1)/(time*mul);
			b.drawFunc = {
				// set the Color
				if((i+1)==(time*mul), { Pen.fillColor = Color.red.alpha_(0.0);},
				{ Pen.fillColor = Color.red.alpha_(0.3) });
			
				Pen.addRect(
					Rect(0, 0, (b.bounds.width*elapsed), b.bounds.height)
					);
				Pen.fill;
			};
			{w.refresh}.defer;
			(1/mul).wait;
		});
	}.fork(AppClock);	
};


progressViewClear= {|key|
	//function to clear progress view on key
		var b;
		b= keyUserViews[key];

			b.drawFunc = {
				// fill with clear
				Pen.fillColor = Color.red.alpha_(0.0);
			
				Pen.addRect(
					Rect(0, 0, b.bounds.width, b.bounds.height)
					);
				Pen.fill;
			};
			{ keyButs[key].value= 0; }.defer
			{w.refresh}.defer;
};



loadASRsound= {|paths, i, num, view|
	paths.do({ |path, ii|
		if (path.isString, {
			//"loadASR:".postln; [i, ii, num].postln;
		{a.freeKey(("snd"++i.asString++"x"++((num+ii).asString)).asSymbol);}.try;
		//path.postln;
		a.prepareForPlay(("snd"++i.asString++"x"++((num+ii).asString)).asSymbol, path);
		if (soundsASR[i][num+ii].isNil, {soundsASR[i]= soundsASR[i].add(path)}, {soundsASR[i][num+ii]= path });
		/*
		{sambut[num+ii].states= ([[path.basename.replace(".wav", ""), textcolors[0], colors[0]]])}.defer;
		*/
		});
	});
	properties[i][7]= soundsASR[i].size-1;
	//maybe 
	{c.remove; propView.value(i)}.defer;
	};


// ======================== TOUCH OSC INTERFACE ================
touchOSC= {
var resp1=Array.newClear(12);
var resp2=Array.newClear(12);
var resp3=Array.newClear(12);
var resp4=Array.newClear(12);
var win;
	
6.do({|i|
	resp1.put(i, OSCresponderNode(nil, '/1/fader'++(i+1).asString, {|t, r, msg|
			{sliders[i].setVal((msg[1]).round(0.001))}.defer;	
			}).add;);	
	resp1.put(i, OSCresponderNode(nil, '/1/rotary'++(i+1).asString, {|t, r, msg|
			{sliders[i].setPan((msg[1]).round(0.001))}.defer;	
			}).add;);	
});

12.do({|i|
		resp2.put(i, OSCresponderNode(nil, '/2/push'++(i+1).asString, {|t, r, msg|
			if(sounds[i+1].isNil.not, {
				if( msg[1] == 1, 
					{playnote.value(nil, i, i, nil)},
					{stopnote.value(i, i)}
				);
			});	
	}).add;)
});

12.do({|i|
		resp3.put(i, OSCresponderNode(nil, '/3/push'++(i+13).asString, {|t, r, msg|
			if(sounds[i+1].isNil.not, {
				//sounds[i+12].postln; msg[1].postln;
				if( msg[1] == 1, 
					{playnote.value(nil, i+12, i+12, nil)},
					{stopnote.value(i+1, i+12)}
				);
			});
	}).add;)
});

12.do({|i|
		resp4.put(i, OSCresponderNode(nil, '/4/push'++(i+25).asString, {|t, r, msg|
			if(sounds[i+1].isNil.not, {
				//sounds[i+12].postln; msg[1].postln;
				if( msg[1] == 1, 
					{playnote.value(nil, i+24, i+24, nil)},
					{stopnote.value(i+1, i+24)}
				);
			});
	}).add;)
});

OSCdef(\pingResp, {|msg, time, addr, recvPort|
	//var n= NetAddr("android-186c303cd60796d", recvPort);
	var n= NetAddr(addr.ip, recvPort);
	
	{
	sliders.do({|it, i|
		var name;
		if(it.title.string.isNil, {name= " "}, {name= it.title.string });
		n.sendMsg('/1/label'++(i+1).asSymbol, name); 0.1.wait; 
		});
	sounds.do({|it, i|
		var name;
		if(it.isNil, {name= " "}, {name= it.basename.removeExtension});
		n.sendMsg('/2/label'++(i+1).asSymbol, name); 0.1.wait;
		});
	}.fork(AppClock);
	n.free;
	}, '/ping', nil);

win= Window("TouchOSC", Rect(300, 300, 300, 300))
.front
.alwaysOnTop_(true);

// REMOVE RESPONDERS (don't forget)
win.onClose_({
(resp1.size).do({|i| resp1[i].remove});
(resp2.size).do({|i| resp2[i].remove});
(resp3.size).do({|i| resp3[i].remove});
(resp4.size).do({|i| resp4[i].remove});
OSCdef(\pingResp).free;
});

};


// ========================= SEQUENCER =========================
sequencer= {
	
var w, topGrid, gridArray, clockArray, meter, freq;
var columns= 16;
var boxHeight= 16, boxSpace= 3, topSpace= 50;
var length, mute, muteButtons;
var randomize, names;
var playBut, stopBut, recBut;
var t, beat= 1, recSeq, recSeqNoteOn, tapTempoGUI, tapTempoView;
//to remove
var samples;
var colors;
colors= [Color.new255(160, 255, 160).alpha_(0.5), Color.black, Color.white, Color.black, Color.white, Color.white, Color.black, Color.white, Color.black, Color.white, Color.black, Color.white];

mute= 0!numKeys;

w = Window.new("Step sequencer", Rect(10, 500, 800, 760)).front;

Button(w, Rect(0, 0, 40, 40))
.states_([["A"],["V"]])
.action_({|v| if (v.value == 1, { w.setInnerExtent(nil, 50) }, { w.setInnerExtent(nil, 760) }) });

randomize= Button(w, Rect(60, 0, 50, 20))
.canFocus_(false)
.states_([["randomize"]])
.action_({
		numKeys.do({|i|
10.do({gridArray[i].setState_(columns.rand, 0, [0, 0, 0, 0, 1].choose);}); // column, row, state
	});
});

EZSlider(w,  	
	Rect(120, 0, 180, boxHeight),
	"tempo",	// label
	[50, 250, \lin, 1, 120, "tempo"].asSpec, // controlSpec
	{|ez| t.clock.tempo_(ez.value/30) }, // action
	120, // init value, set from A DICTIONARY
	labelWidth: 30,
	numberWidth: 30
	).setColors(
		nil, //string backgr
		Color.white, //string
		Color(0.298, 0.298, 0.298, 1.0), //slider backgr
		Color.grey, //num backgr
		Color.white, //num clr
		nil,
		nil,
		Color(0.298, 0.776, 1.0, 1.0) //knob clr
);

playBut = RoundButton( w, Rect(310, 0, 50, 20) )
.states_([[ \play ], [\pause]] )
.action_({|v| if(v.value == 1, {t.play}, {t.pause}) });

stopBut = RoundButton( w, Rect(360, 0, 30, 20) )
.states_([[ \stop ]] )
.action_({ t.stop; t.reset; playBut.value= 0; });

recBut = RoundButton( w, Rect(390, 0, 30, 20) )
.states_([[ \record, Color.black ],[\record, Color.red]] )
.action_({ if (v.value==1, {recSeq.value }, { recSeqNoteOn.remove; }); });

topGrid = BoxGrid.new(w, bounds: Rect(60, 25, 360, boxHeight), columns: columns, rows: 1)
.setFillMode_(true)
.setFillColor_(Color.red)
	.setBackgrDrawFunc_({
		16.do({arg i;
			if((i==0)||(i==4)||(i==8)||(i==12)||(i==16),{
			GUI.pen.fillColor = Color.new255(60, 60, 60).alpha_(0.5);
			},{
			GUI.pen.fillColor = Color.new255(255, 255, 255).alpha_(0.5);
			});
			GUI.pen.fillRect(Rect(1+(i*(360/columns)), 0, 360/columns, 240));
		})
	});

gridArray = Array.fill(numKeys, {arg i;
	BoxGrid.new(w, bounds: Rect(60, (boxHeight+boxSpace)*((i-numKeys).abs)+topSpace-(boxHeight+boxSpace), 360, boxHeight), columns: columns, rows: 1)
	.setFillMode_(true)
	.setFillColor_(Color.green)
	.setBackgrColor_(colors[i.wrap(0, 11)])
	.setBackgrDrawFunc_({
		16.do({arg i;
			if((i==0)||(i==4)||(i==8)||(i==12)||(i==16),{
			GUI.pen.fillColor = Color.new255(60, 60, 60).alpha_(0.5);
			},{
			GUI.pen.fillColor = Color.new255(255, 255, 255).alpha_(0.5);
			});
			GUI.pen.fillRect(Rect(1+(i*(360/16)), 0, 360/16, 240));
		})
	});
});

EZSlider(w, // master duration
	Rect(440, 25, 180, boxHeight),
				"dur",	// label
				nil, // controlSpec
				{|ez| length.do({|it| {it.valueAction= ez.value}.defer; });
				}, // action
				0.3, // init value, set from A DICTIONARY
				labelWidth: 30,
				numberWidth: 25
				).setColors(
					nil, //string backgr
					Color.white, //string
					Color(0.298, 0.298, 0.298, 1.0), //slider backgr
					Color.grey, //num backgr
					Color.white, //num clr
					nil,
					nil,
					Color.red //knob clr
					);

length = Array.fill(numKeys, {arg i;
	EZSlider(w,  	// parent
				Rect(440, (boxHeight+boxSpace)*((i-numKeys).abs)+topSpace-(boxHeight+boxSpace), 180, boxHeight),
				"dur",	// label
				nil, // controlSpec
				{|ez| nil
				}, // action
				0.3, // init value, set from A DICTIONARY
				labelWidth: 30,
				numberWidth: 25
				).setColors(
					nil, //string backgr
					Color.white, //string
					Color(0.298, 0.298, 0.298, 1.0), //slider backgr
					Color.grey, //num backgr
					Color.white, //num clr
					nil,
					nil,
					Color(0.298, 0.776, 1.0, 1.0) //knob clr
					);
});

muteButtons = Array.fill(numKeys, {arg i;
	Button(w, Rect(420, (boxHeight+boxSpace)*((i-numKeys).abs)+topSpace-(boxHeight+boxSpace), 20, 20))
	.states_([["m", Color.black, Color.grey], ["m", Color.black, Color.red]])
	.action_({|v| mute[i]= v.value })
	.value_(0);
});

names= Array.fill(numKeys, {arg i;
	if(sounds[i].isNil.not, {
	StaticText(w, Rect(10, (boxHeight+boxSpace)*((i-numKeys).abs)+topSpace-(boxHeight+boxSpace), 50, 20))
	.string_(sounds[i].basename.removeExtension)
	});
});


t= Task({
	inf.do({|i|
		beat= i%columns;
{topGrid.setState_( i%columns, 0, 1)}.defer;
{topGrid.setState_( i%columns, 0, 0)}.defer(thisThread.clock.beatDur);

numKeys.do({arg ii;
if(gridArray[ii].getState(i%16, 0) == 1, {
	if(mute[ii].value==0 && sounds[ii].isNil.not, {
		//playnote.value(nil, ii, ii, nil, nil, length[ii].value);
		playnote.value(nil, ii, ii, nil, nil);
		{stopnote.value(ii, ii)}.defer(length[ii].value);
	//a.play(ii.asSymbol, 0.01, 0, length[ii].value);
	});
});
});
1.wait;
	});
}, TempoClock(4));

tapTempoView= CompositeView(w, Rect(430, 0, 230, 20));
tapTempoGUI= RedTapTempoGUI(t.clock, 4, 3, s, tapTempoView);

recSeq= {
	recSeqNoteOn= NoteOnResponder({ |src,chan,note,vel|
	var num, event= nil;
	//[src,chan,note,vel].postln;
	note= note-startKey;
	if(note.inRange(0, (numKeys-1)), {
		gridArray[num].seState_(0, beat-1, 1);
	},
	{"key out of range".postln;});
	},
	midisrc, // source
	midichannel // channel
	);
	
	};


prViewBut.valueAction= 0;

w.onClose = {tapTempoGUI.close; t.stop; seqIsOpen= false; {recSeqNoteOn.remove}.try; };
};


// ------- preferences view (setup)

preferencesView= {
	KeyboardPreferences.new(thisFilePath+/+keyboardName);
	};



// -----  bend responder

	bender = BendResponder({ |src,chan,value|
		//[src,chan,value].postln;
		//if(bendfreeze == 0, {
			value= value.linlin(0, 16383, 0.0, 2.0).round(0.001).clip(0.1, 2.0);
			if( masterprop[\kyPitch] == 1, { a.speed_(value); });
			if( masterprop[\slPitch] == 1, { sliders.do({|it| it.setPitch(value); }); });
			if( masterprop[\knPitch] == 1, { allKnobs.do({|it| it.setPitch(value); }); });
			bend= value;
		//});
		},
		src: midisrcindex
	);



// ----- prog change responder
/*
MIDIFunc.program({arg value, channel, srcID; 
	args.postln;
	if( args[0] > previousMIDIProgMsg, 
		{routingButton.valueAction= 5;
			if(panHackSynth.isNil or: {panHackSynth.isPlaying.not}, {
				panHackSynth= Synth.tail(s, \panHackSynth); panHackSynth.isPlaying_(true) })
			}, // route outputs to balcony and pan with hack
		{routingButton.valueAction= 0;
			if(panHackSynth.isNil.not and: {panHackSynth.isPlaying}, {panHackSynth.free; panHackSynth.isPlaying_(false) })
			} // route outputs back to normal
	)
	
	},
	nil,
	midichannel,
	src: midisrcindex
	);
*/

// =========== ON CLOSE ==================

w.front;

w.onClose= {
	~openSamplers[keyboardName.asSymbol]= true;
	a.free;
	{on.stop; off.stop}.try;
	MIDIIn.disconnectByUID(0, midisrc);
	responders1.size.do({|i| responders1[i].remove});
	responders2.size.do({|i| responders2[i].remove});
	effectGroup.free;
	bender.remove;
	
	noteon.remove;
	noteoff.remove;
	
	if(p.isNil.not, {p.close}); // close arduino REMOVE !
	
	if(sendWinOpen.isNil.not, {sendWinOpen.close});
	
	if(~openSamplers.values.includes(true).not, {~dmx= nil;}); // dmx to nil. enough?
	~preferencesWindows.put(\keyboardName, false);
	if(MultiTouchPad.isRunning, {MultiTouchPad.stop;});
};




//============== SYNTHDEFS ==================

	SynthDef(\gpLooperMono, {
		arg bufnum=0, a= 0.01, s=1, r=0.1, rate= 1, amp=1, gate= 1, pan= 0, out= 0;
		var env, signal;
		env= EnvGen.kr(Env.asr(a, s, r), gate, doneAction:2);
		signal= PlayBuf.ar(1, bufnum, rate, loop:1)*amp;
		Out.ar(out, Pan2.ar(signal * env, pan))
	}).send(s);
	
	SynthDef(\gpLooperStereo, {
		arg bufnum=0, a= 0.01, s=1, r=0.1, rate= 1, amp=1, gate= 1, pan= 0, out= 0;
		var env, signal;
		env= EnvGen.kr(Env.asr(a, s, r), gate, doneAction:2);
		signal= PlayBuf.ar(2, bufnum, rate, loop:1)*amp;
		Out.ar(out, Balance2.ar(signal[0], signal[1], pan) * env)
	}).send(s);
	
	SynthDef(\diskinMono, { arg bufnum = 0, out= 0, a= 0.01, s=1, r=0.1, rate= 1, amp=1, gate= 1, pan= 0, synthID= 33;
		var signal, env;
		env= EnvGen.kr(Env.asr(a, s, r), gate, doneAction:2);
		signal= VDiskIn.ar(1, bufnum, rate, 1, synthID) * amp;
		Out.ar(out, Pan2.ar(signal * env, pan));
	}).send(s);
	
	SynthDef(\diskinStereo, { arg bufnum = 0, out= 0, a= 0.01, s=1, r=0.1, rate= 1, amp=1, gate= 1, pan= 0, synthID= 3;
		var signal, env;
		env= EnvGen.kr(Env.asr(a, s, r), gate, doneAction:2);
		signal= VDiskIn.ar(2, bufnum, rate, 1, synthID) * amp;
		Out.ar(out, Balance2.ar(signal[0], signal[1], pan) * env);
	}).send(s);

SynthDef(\FreeVerb2x2, {|out= 0, mix = 0.25, room = 0.15, damp = 0.5, amp = 1.0|
	var signal;
	signal = In.ar(out, 2);
	ReplaceOut.ar(out,
		FreeVerb2.ar( // FreeVerb2 - true stereo UGen
			signal[0], // Left channel
			signal[1], // Right Channel
			mix, room, damp, amp)); // same params as FreeVerb 1 chn version
}).add;

SynthDef(\PanningHack, {|out= 0, amp = 1.0, pan= 0|
	var signal;
	signal = In.ar(out, 2);
	ReplaceOut.ar(out, Balance2.ar(signal[0], signal[1], pan));
}).add;


s.sync;

// Start some synths

panSynth= Synth.tail(s, \PanningHack);



};
);




