

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
var midichannel, midiSendWindow;
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
var ipDict;

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
midiDevice= settings[5];
midiPortName= settings[6]; 
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
	midiDevice= preferences[5];
	midiPortName= preferences[6]; 
	backgroundColor= preferences[7];
	midichannel= preferences[8];
	ruleFolderNames= preferences[9];
	rulesList= preferences[10];
	rulesApply= preferences[11];
	rulesOnOff= preferences[12];
	output= preferences[13];
});

progressState= 1;

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
outputs= [nil, 0, 2, 4, 6, 8, 10];
output= outputs[output];
if (midichannel == 0, {midichannel= nil;});

if (s.options.device == nil, {output = 0});


// ================ MIDI INITIALIZATION ================

MIDIClient.sources.do({ |it, i|
	if((it.device).matchRegexp(midiDevice), {
		midisrc= it.uid; 
		midisrcindex= i;
		//(it.uid).postln;
		});
	});

{ midisrc= (MIDIIn.findPort(midiDevice, midiPortName).uid) }.try;
//midisrcindex= 1;

/*
MIDIClient.sources.do({ |it, i|
	if(it.uid== midisrc, {midisrcindex= i});
	});
*/

//("LE midisource: "++MIDIClient.sources.at(midisrcindex).asString).postln;

//MIDIIn.connect(1, MIDIClient.sources.at(1));
//MIDIIn.connect;

if (midisrcindex.isNil.not, {
		MIDIIn.connectByUID(0, midisrc);
	},{
		SCAlert("No MIDI Keyboard connected", ["OK!"]);
		midisrc= nil; 
		midisrcindex= nil;
});

// ================= DMX INITIALIZATION ===============

if (~dmx.isNil, {
	SerialPort.devices.do({|it|
		if (it.asSymbol == '/dev/tty.Bluetooth-PDA-Sync',
			{ "connecting dmx".postln;
				//~dmx= DMX.new;
				//~dmx.device= EntTecDMXUSBPro.new( "/dev/ttyUSB0" );
		});
	});
});


// ================= ROBOT INIT ======================

ipDict= (\naziBot: "127.0.0.1", \hornBot: "127.0.0.1");




sounds= Array.newClear(numKeys);
soundsASR= ([]!numKeys).asList;
properties= ([0.5, 0, 0, 0.01, 0.2, 0, 0, 3, 0, 0, nil, nil, [0.1, 0.2, 0], [0, 0, 1], 1, nil, nil]!numKeys).asList;
defaultProperties= ([0.5, 0, 0, 0.01, 0.2, 0, 0, 3, 0, 0, nil, nil, [0.1, 0.2, 0], [0, 0, 1], 1, nil, nil]!numKeys).asList;
knobSounds= nil!8;
sliderSounds= nil!8;
masterprop= (\poly: 0, \vel: 0, \revon: 0, \revmix: 0.5, \rroom: 0.75, \rdamp: 0.3, \eon: 0, \emix: 0.35, \edelay: 0.6, \edecay: 7, \pmix: 0, \pfreq: 0.1, \gmix: 1, \grate: 0.5, \gdur: 0.5, \gpitch: 0.5);
progress= []!numKeys;
timer = (0!numKeys).asList;
arpRoutines= (0!numKeys);
bend= 1;

ampspec= ControlSpec( 0.001, 1.0,\amp);

sizes= [1, 0.7, 1, 0.7, 1, 1, 0.7, 1, 0.7, 1, 0.7, 1, ];

colors= [Color.new255(160, 255, 160), Color.black, Color.white, Color.black, Color.white, Color.white, Color.black, Color.white, Color.black, Color.white, Color.black, Color.white];

textcolors= [Color.black, Color.white, Color.black, Color.white, Color.black, Color.black, Color.white, Color.black, Color.white, Color.black, Color.white, Color.black];

colorsOn= [Color.yellow, Color.new255(255, 165, 0), Color.yellow, Color.new255(255, 165, 0), Color.yellow, Color.yellow, Color.new255(255, 165, 0), Color.yellow, Color.new255(255, 165, 0), Color.yellow, Color.new255(255, 165, 0), Color.yellow];




// ===== MIDI NOTE RESPONDERS ========


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
	

// =============== N O T E   O N ==================
//remove event
playnote= {|event, num, key, vel|
	var amp, seq= 4, out, asrName;
	if (num.isNil.not, {
		if (properties[key][10].isNil.not, {out= properties[key][10] }, {
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
				pan: properties[key][9],
				speed: properties[key][14] * bend,
				offset: properties[key][13][0],
				startLoop: properties[key][13][1],
				endLoop: properties[key][13][2],
				out: out
			);
			if (progressState == 1, {progressView.value(key)});
			{ keyButs[key].value= 1; }.defer;
		}
		{properties[key][2] == 1} //playback mode one shot
		{a.play(("snd"++((key).asString)).asSymbol, 
				amp: amp,
				loop: 0,
				attack: properties[key][3],
				pan: properties[key][9],
				speed: properties[key][14] * bend,
				offset: properties[key][13][0],
				out: out
			);
		{ keyButs[key].value= 1; }.defer;
		}
		{properties[key][2] == 2} //playback mode loop on off
		{ 
			case 
			{a.isPlaying(("snd"++((key).asString)).asSymbol) == false} 
			{a.play(("snd"++((key).asString)).asSymbol, 
				amp: amp,
				loop: properties[key][1],
				attack: properties[key][3],
				pan: properties[key][9],
				speed: properties[key][14] * bend,
				offset: properties[key][13][0],
				startLoop: properties[key][13][1],
				endLoop: properties[key][13][2],
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
				pan: properties[key][9],
				speed: properties[key][14] * bend,
				offset: properties[key][13][0],
				out: out
			);	
		a.play(("snd"++((key).asString)).asSymbol, //looped sound
				amp: amp,
				loop: 1,
				attack: properties[key][3],
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
				pan: properties[key][9],
				speed: properties[key][14] * bend,
				offset: properties[key][13][0],
				out: out
				);
				asrName= soundsASR[key][properties[key][7]].basename.removeExtension;
				{ keyButs[key].states= ([[asrName, textcolors[key.wrap(0, 12);], colors[key.wrap(0, 12);]], [asrName, Color.black, colorsOn[key.wrap(0, 12)]] ]) }.defer;
				properties[key][7]= (properties[key][7]+1).wrap(0, (soundsASR[key].size-1));
				//timer[key] = Date.getDate.bootSeconds.round(1);

			});			
			if(properties[key][6] == 1, { //random
				properties[key][7]= ("snd"++((key).asString++"x"++((soundsASR[key].size.rand).asString))).asSymbol;
				properties[key][7].postln;
				a.play(properties[key][7], 
					amp: amp,
					loop: properties[key][1],
					attack: properties[key][3],
					pan: properties[key][9],
					speed: properties[key][14] * bend,
					offset: properties[key][13][0],
					out: out
				);
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
	//SEND MIDIOUT CC
	//if( properties[key][11].isNilNot, { midiOut.control(1, properties[key][11][0], properties[key][11][0]) });
	//SEND OSC
	/*
	if( properties[key][15][0] == 1, { 
		properties[key][15][1].keysValuesDo({|robot, value|
			NetAddr(ipDict.at(robot), 80).sendMsg(robot, value[0]);
			[robot, value].postln;
		});
	});
	*/
	//SEND DMX
	if( ~dmx.isNil.not, {
		if( properties[key][16] == 1, { ~dmx.fade(properties[key][16][1][0], 0.5, 'linear', 0.1)});
	});
};


// =============== N O T E   O F F ==================
stopnote= {| num, key, forcestop|
	if (num.isNil.not, {
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
			if(properties[key][8] == 0, { //shot
				if(properties[key][6] == 0, { //sequence
					//a.stop(("snd"++((key).asString++"x"++(properties[key][7].asString))).asSymbol, properties[key][4]);
					timer[key] = Date.getDate.bootSeconds.round(1);
					a.stop(("snd"++((key).asString++"x"++(((properties[key][7]-1).wrap(0, (soundsASR[key].size-1))).asString))).asSymbol, properties[key][4]);
				{ keyButs[key].states= ([[soundsASR[key][properties[key][7]].basename.removeExtension, textcolors[key.wrap(0, 12);], colors[key.wrap(0, 12);]], [soundsASR[key][properties[key][7]].basename.removeExtension, Color.black, colorsOn[key.wrap(0, 12)]] ]) }.defer;
				});
				if(properties[key][6] == 1, { //random
				a.stop(properties[key][7], properties[key][4]);
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
	//SEND MIDI OUT CC
	//if( properties[key][11].isNilNot, { midiOut.control(1, properties[key][11][0], 0) });
	//SEND OSC
	//if( properties[key][15] == 1, { a NetAddr .send(properties[key][15][1], properties[key][15][2][0]) });
	//SEND DMX
	if( ~dmx.isNil.not, {
		if( properties[key][16] == 1, { ~dmx.fade(properties[key][16][1][1], 0.5, 'linear', 0.1)});
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


//================ GUI STUFF ============

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

Button(w, Rect(400, 400, 50, 30))
.states_([["nil", Color.black, Color.grey], ["1-2", Color.yellow, Color.black],["3-4", Color.yellow, Color.black], ["5-5", Color.yellow, Color.black], ["7-8", Color.yellow, Color.black], ["9-10", Color.yellow, Color.black], ["11-12", Color.yellow, Color.black], ["test", Color.yellow, Color.black]] )
.canFocus_(false)
.value_(0)
.action_({ |v|
	output= outputs[v.value];
	sliders.do({ |it| it.defaultout_(outputs[v.value]); });
	allKnobs.do({ |it| it.defaultout_(outputs[v.value]); });
});


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

			values= [sounds, properties, knobSounds, sliderSounds, soundsASR];
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
		//values.postcs;
		sounds= values[0];
		properties= values[1];
		if(values[4].isNil.not, {soundsASR= values[4]},{
			soundsASR= ([]!numKeys).asList;
		});
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
		values= [sounds, properties, knobSounds, sliderSounds, soundsASR];
		values.writeArchive(path);
});

Button(w, Rect(250, 20, 40, 20))
.states_([["panic", Color.black, Color.grey]])
.action_({ |v|
	panic.value;
});

Button(w, Rect(290, 20, 50, 20))
.states_([["pr view", Color.white, Color.grey], ["pr view", Color.yellow, Color.grey]])
.value_(progressState)
.font_(Font("Helvetica", 10))
.action_({ |v|
	progressState= v.value;
	sliders.do({|it| it.progress(v.value) });
	allKnobs.do({|it| it.progress(v.value) });
});

Button(w, Rect(340, 20, 40, 20))
.states_([["SL bnd", Color.white, Color.grey], ["SL bnd", Color.yellow, Color.grey]])
.value_(sliderPitch)
.font_(Font("Helvetica", 10))
.action_({ |v|
	if(v.value == 1, { sliderPitch= 1 }, { sliderPitch= 0 });
});

Button(w, Rect(380, 20, 40, 20))
.states_([["KN bnd", Color.white, Color.grey], ["KN bnd", Color.yellow, Color.grey]])
.value_(knobPitch)
.font_(Font("Helvetica", 10))
.action_({ |v|
	if(v.value == 1, { knobPitch= 1 }, { knobPitch= 0 });
});

Button(w, Rect(420, 20, 40, 20))
.states_([["Ky bnd", Color.white, Color.grey], ["Ky bnd", Color.yellow, Color.grey]])
.value_(keyPitch)
.font_(Font("Helvetica", 10))
.action_({ |v|
	if(v.value == 1, { keyPitch= 1 }, { keyPitch= 0 });
});

PopUpMenu(w, Rect(300, 50, 30, 20))
.items_(["1", "2", "3", "4", "5"])
.value_(masterprop[\poly])
.action_({ arg menu;
a.overlaps= (menu.value+1);
a.overlaps.postln;
});

Button(w, Rect(330, 50, 40, 20))
.states_([["vel off", Color.black, Color.grey], ["vel on", Color.yellow, Color.grey]])
.value_(masterprop[\vel])
.action_({ |v|
	velocitystate= v.value;
});

Button(w, Rect(370, 50, 40, 20))
.canFocus_(false)
.states_([["DMX", Color.black, Color.green]])
.action_({ |v|
	// toggle dmx
});

Button(w, Rect(410, 50, 40, 20))
.canFocus_(false)
.states_([["OSC", Color.black, Color.green]])
.action_({ |v|
	touchOSC.value;
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
var window = Window.new("record",Rect(465, 636, 306, 180)).front;

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



/*
GUI.popupMenu.new(w, Rect(20, 80, 100, 30))
.items_

*/

//===== make keys/buttons ====

keyButs= numKeys.collect({ |i|
var num, size, amp, env, loop;
num= i.wrap(0, 11);

size= 130*(sizes[num]);


Button(w, Rect(470, keyHSize*((i-numKeys).abs), size, keyHSize))
.font_(GUI.font.new("Monaco", 9))
.canFocus_(false)
.states_([["", textcolors[num], colors[num]], ["", Color.black, colorsOn[i.wrap(0, 11)]] ])
.mouseDownAction_({ |view, x, y, mod|

	if ( mod == 131330, {  //shift
		CocoaDialog.getPaths({ arg paths; //load sound
		loadPreset.value(paths, i);
		},{
			"cancelled".postln;
		});
	});
	
})
.canReceiveDragHandler_(true)
.receiveDragHandler_({|view|
		var values, paths;
		paths= View.currentDrag;
loadPreset.value(paths, i);
	})
.action_({ |v|
	c.remove;
	propView.value(i);
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
		if (path.isSoundFile, {
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
		}, {errorFileMessage.value;});
	});
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



//========== make SLIDERS =====================
sliderView= HLayoutView(w, Rect(20, 540, 400, 180));
//sliderView.setProperty(\spacing,0);


sliders= slidersCC.size.collect({ |i|
	i= i+1;
	SliderLooper.new(sliderView, 0, 0, i, out: output, preferences: preferences);
});


responders1= slidersCC.collect({|it, i|

		CCResponder({
			|src,chan,num,value|
			sliders[i].setVal((value*(127.reciprocal)).round(0.001));
		}, num: it, src: midisrcindex
		);

});

//========== make KNOBS =====================
knobView1= CompositeView(w, Rect(15, 300, 380, 230));
knobView1.decorator = FlowLayout(knobView1.bounds);


allKnobs= knobsCC.size.collect({
	UC33LoopChan.new(knobView1, 0, 0, output, preferences: preferences);
});


responders2= knobsCC.collect({|it, i|

		CCResponder({
			|src,chan,num,value|
			allKnobs[i].setVal((value*(127.reciprocal)).round(0.001));
		}, num: (it), src: midisrcindex
		);
	
});



// ====== effectView ==========
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


//=========================================//
//
// ====== propView
//

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
	properties[key][9]= v.value;
})
.color_([Color.gray, Color.red, Color.white, Color.black])
.mouseDownAction_({|view, x, y, mod|
	if (mod == alt, {view.valueAction= \pan.asSpec.unmap(0); properties[key][9]= 0})
});


Button(c, Rect(30, 10, 30, 15))
.states_([["nil", Color.black, Color.grey], ["1-2", Color.yellow, Color.black],["3-4", Color.yellow, Color.black], ["5-5", Color.yellow, Color.black], ["7-8", Color.yellow, Color.black], ["9-10", Color.yellow, Color.black], ["11-12", Color.yellow, Color.black]] )
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
})
.color_([Color.grey, Color.red, Color.white, Color.black])
.mouseDownAction_({|view, x, y, mod|
	if (mod == alt, {view.valueAction= \pan.asSpec.unmap(1); properties[key][14]= 1})
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
	a.play(("snd"++((key).asString)).asSymbol, 
	amp: properties[key][0],
	pan: properties[key][9],
	loop: properties[key][1],
	attack: properties[key][3],
	speed: properties[key][14] * bend,
	offset: properties[key][13][0],
	startLoop: properties[key][13][1],
	endLoop: properties[key][13][2],
	out: output
	);
	keyButs[key].value= 1;
	time= a.length(("snd"++(key).asString).asSymbol).round(1);
	time= time*(properties[key][14].abs).reciprocal;
	fork{ time.wait; {if (b.value == 1, {b.value= 0;}) }.defer; };
	//routine to draw progress view on key
	t= fork{
		var elapsed, b, mul= 10;
		b= keyButs[key];
		(time*mul).do({|i|
			elapsed= (i+1)/(time*mul);
			w.drawFunc = {
				// set the Color
				if((i+1)==(time*mul), { Pen.fillColor = Color.red.alpha_(0.0);},
				{ Pen.fillColor = Color.red.alpha_(0.3) });
			
				Pen.addRect(
					Rect(b.bounds.left, b.bounds.top, (b.bounds.width*elapsed), b.bounds.height)
					);
				Pen.fill
			};
			{w.refresh}.defer;
			(1/mul).wait;
		});
	};
	
	},{
		a.stop(("snd"++((key).asString)).asSymbol, properties[key][4]);
		t.stop;
		w.drawFunc = {
			// set the Color
			Pen.fillColor = Color.red.alpha_(0.0);
			
			Pen.addRect(
				Rect(b.bounds.left, b.bounds.top, (b.bounds.width), b.bounds.height)
				);
			Pen.fill
		};
		keyButs[key].value= 0;
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
.states_([["L", Color.black, Color.white]])
.action_({|v| midiSendWindow.value(key) });

PopUpMenu(c, Rect(5, 155, 70, 20))
.items_(["piano", "shot", "toggle", "3 samples", "2 samples", "many", "arpeggio"])
.value_(properties[key][2])
.canFocus_(false)
.action_({ arg menu;
	properties[key][2] = menu.value;

	if(arpRoutines[key].isPlaying, {arpRoutines[key].stop});
	if (a.isPlaying(("snd"++((key).asString)).asSymbol), {
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



midiSendWindow= { |key|
	var w, ccnumSlider, ccvalSlider, ccnumSliderInit, ccvalSliderInit;

	if (properties[key][11].isNil.not, 
		{ccnumSliderInit= properties[key][11][0]; ccvalSliderInit= properties[key][11][1] }
		);
	
	w=Window.new("Send MIDI").front;
	w.view.decorator=FlowLayout(w.view.bounds);
	w.view.decorator.gap=2@2;
	Button(w, Rect(0, 0, 100, 40))
		.states_([["MIDI send OFF", Color.grey, Color.black], ["MIDI send ON", Color.green, Color.black]])
		.action_({|v| 
			if( v.value == 1, 
				{properties[key][11]= [0, 0].asList;
					ccnumSlider.visible= true;
					ccvalSlider.visible= true;
					properties[key][11][0]= ccnumSlider.value; 
					properties[key][11][1]= ccvalSlider.value },
				{properties[key][11]= nil;
					ccnumSlider.visible= false;
					ccvalSlider.visible= false;}
			);
		});
	ccnumSlider= EZSlider(w, 392@30, 
		"num",
		[0, 127, \lin, 1].asSpec,
		initVal: ccnumSliderInit, 
		numberWidth:60,
		layout:\horz)
		.setColors(Color.grey,Color.white)
		.font_(Font("Helvetica",20))
		.action_({|v|
			properties[key][11][0]= v.value;
			//midiOut.control(1, v.value, ccvalSlider.value);
		});
	ccvalSlider= EZSlider(w, 392@30, 
		"val",
		[0, 127, \lin, 1].asSpec,
		initVal: ccvalSliderInit, 
		numberWidth:60,
		layout:\horz)
		.setColors(Color.grey,Color.white)
		.font_(Font("Helvetica",20))
		.action_({|v|
			properties[key][11][1]= v.value;
			//midiOut.control(1, ccnumSlider.value, v.value);
		});
	
};

// =========== LOOP POINT EDITOR =============

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
	numKeys.do({|i|
		a.overlaps.do({
			if (a.isPlaying(("snd"++((i).asString)).asSymbol), {
				a.stop(("snd"++((i).asString)).asSymbol, properties[i][4]);
			});
		});
		//also do "snd1x1".....
	});
	
	arpRoutines.do({|it|
		if(it.isPlaying,{it.stop});
	});
	allKnobs.do({|it|
		it.setVal(0);
	});
	sliders.do({|it|
		it.setVal(0);
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
		.items_(["sequence", "random", "pingpong"])
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


/*
progressView= {|key|
	//routine to draw progress view on key
	progress[key]= fork{
		var elapsed, b, mul= 10, time= a.length(("snd"++(key).asString).asSymbol).round(1);
		b= keyViews[key];
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
			{b.refresh}.defer;
			(1/mul).wait;
		});
	};	
};

progressViewClear= {|key|
	//function to clear progress view on key
		var b;
		b= keyViews[key];

			w.drawFunc = {
				// fill with clear
				Pen.fillColor = Color.red.alpha_(0.0);
			
				Pen.addRect(
					Rect(0, 0, b.bounds.width, b.bounds.height)
					);
				Pen.fill;
			};
			{b.refresh}.defer;
};
*/


progressView= {|key|
	//routine to draw progress view on key
	progress[key]= fork{
		var elapsed, b, mul= 10, time= a.length(("snd"++(key).asString).asSymbol).round(1);
		time= time*(properties[key][14].abs).reciprocal;
		b= keyButs[key];
		(time*mul).do({|i|
			elapsed= (i+1)/(time*mul);
			w.drawFunc = {
				// set the Color
				if((i+1)==(time*mul), { Pen.fillColor = Color.red.alpha_(0.0);},
				{ Pen.fillColor = Color.red.alpha_(0.3) });
			
				Pen.addRect(
					Rect(b.bounds.left, b.bounds.top, (b.bounds.width*elapsed), b.bounds.height)
					);
				Pen.fill;
			};
			{w.refresh}.defer;
			(1/mul).wait;
		});
	};	
};


progressViewClear= {|key|
	//function to clear progress view on key
		var b;
		b= keyButs[key];

			w.drawFunc = {
				// fill with clear
				Pen.fillColor = Color.red.alpha_(0.0);
			
				Pen.addRect(
					Rect(b.bounds.left, b.bounds.top, b.bounds.width, b.bounds.height)
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

touchOSC= {
var resp1=Array.newClear(12);
var resp2=Array.newClear(12);
var resp3=Array.newClear(12);
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
			if(sounds[i].isNil.not, {
				if( msg[1] == 1, 
					{playnote.value(nil, i, i, nil)},
					{stopnote.value(i, i)}
				);
			});	
	}).add;)
});

12.do({|i|
		resp3.put(i, OSCresponderNode(nil, '/3/push'++(i+13).asString, {|t, r, msg|
			if(sounds[i+12].isNil.not, {
				//sounds[i+12].postln; msg[1].postln;
				if( msg[1] == 1, 
					{playnote.value(nil, i+12, i+12, nil)},
					{stopnote.value(i+1, i+12)}
				);
			});
	}).add;)
});

win= Window("TouchOSC", Rect(300, 300, 300, 300))
.front
.alwaysOnTop_(true);

// REMOVE RESPONDERS (don't forget)
win.onClose_({
(resp1.size).do({|i| resp1[i].remove});
(resp2.size).do({|i| resp2[i].remove});
(resp3.size).do({|i| resp3[i].remove});
});

};

// -----  bend responder

	bender = BendResponder({ |src,chan,value|
		//[src,chan,value].postln;
		//if(bendfreeze == 0, {
			value= value.linlin(0, 16383, 0.0, 2.0).round(0.001).clip(0.1, 2.0);
			if( keyPitch == 1, { a.speed_(value); });
			if( sliderPitch == 1, { sliders.do({|it| it.setPitch(value); }); });
			if( knobPitch == 1, { allKnobs.do({|it| it.setPitch(value); }); });
			bend= value;
		//});
		},
		src: midisrcindex
	);


preferencesView= {
	KeyboardPreferences.new(thisFilePath+/+keyboardName);
	};



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
	
	if(~openSamplers.values.includes(true).not, {~dmx= nil;});
	~preferencesWindows.put(\keyboardName, false);
	if(MultiTouchPad.isRunning, {MultiTouchPad.stop;});
};





//============= SAMPLER STUFF =============




//a= RedDiskInSamplerGiga(s);
a= RedCombiSampler(s, 30); //threshold of seconds to read from disk instead of ram



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



};
);




