{\rtf1\ansi\ansicpg1252\cocoartf1265\cocoasubrtf210
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue255;\red51\green51\blue191;\red191\green0\blue0;
\red255\green102\blue0;\red96\green96\blue96;\red102\green102\blue191;\red0\green0\blue191;\red0\green115\blue0;
}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf0 \
\
(\
s.waitForBoot\{\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf2 var\cf0  output;\
\cf2 var\cf0  w, sizes, colors, colorsOn, textcolors;\
\cf2 var\cf0  notes, on, off, a, c;\
\cf2 var\cf0  sounds, properties;\
\cf2 var\cf0  keyButs, propView;\
\cf2 var\cf0  knobView1, knobView2, knobs1to4, knobs5to8, allKnobs;\
\cf2 var\cf0  sliders, sliderView, ampspec, buffers;\
\cf2 var\cf0  knobSounds, sliderSounds;\
\cf2 var\cf0  midisrc, midisrcindex;\
\cf2 var\cf0  loadmenu, savefiles, files, backup, menuitem, wrefresh;\
\cf2 var\cf0  title;\
\cf2 var\cf0  responders1, responders2;\
\cf2 var\cf0  filesDir;\
\cf2 var\cf0  stopnote, playnote;\
\cf2 var\cf0  looppointeditor;\
\cf2 var\cf0  killothernotes, panic, velocitystate;\
\cf2 var\cf0  loadPreset;\
\cf2 var\cf0  currentPresetPath;\
\cf2 var\cf0  effectGroup, effView, revSynth;\
\cf2 var\cf0  t;\
\cf2 var\cf0  masterprop;\
\cf2 var\cf0  dirbutton;\
\cf2 var\cf0  extrasample= \cf3 false\cf0 , extrasampleView, soundsASR;\
\cf2 var\cf0  outputs, defaultProperties;\
\cf2 var\cf0  progressView, progress, progressViewClear, progressState;\
\cf2 var\cf0  timer;\
\cf2 var\cf0  space;\
\cf2 var\cf0  loadASRsound;\
\cf2 var\cf0  keyViews;\
\cf2 var\cf0  bender, bend;\
\cf2 var\cf0  speechout;\
\cf2 var\cf0  record, recordInstantly;\
\cf2 var\cf0  noteon, noteoff;\
\cf2 var\cf0  midichannel; \cf4 // remove midisendwindow\cf0 \
\cf2 var\cf0  recordingsPath;\
\cf2 var\cf0  reloadSavefiles;\
\cf2 var\cf0  errorFileMessage;\
\cf2 var\cf0  keyboardName, numKeys, startKey;\
\cf2 var\cf0  slidersCC, knobsCC;\
\cf2 var\cf0  midiDevice, midiPortName;\
\cf2 var\cf0  soundcard;\
\cf2 var\cf0  document, settings, settingsPath, thisFilePath;\
\cf2 var\cf0  windowHeight, keyHSize;\
\cf2 var\cf0  backgroundColor;\
\cf2 var\cf0  preferences, preferencesView, folderRouting;\
\cf2 var\cf0  preferencesFile, preferencesPath;\
\cf2 var\cf0  ruleFolderNames, rulesList, rulesApply, rulesOnOff;\
\cf2 var\cf0  arpRoutines, arpView;\
\cf2 var\cf0  ctrl, shift, alt;\
\cf2 var\cf0  keyPitch= 1, sliderPitch= 1, knobPitch= 1;\
\cf2 var\cf0  kaossFilesDir, fxDict;\
\cf2 var\cf0  verbose= \cf3 false\cf0 ;\
\cf2 var\cf0  touchOSC;\
\cf2 var\cf0  oscRoutines;\
\cf2 var\cf0  midiOut, sendWindow, sendWinOpen, sendWinLastTabFocus= 1, sendWinLastPos;\
\cf2 var\cf0  updatePreferenceButtons;\
\cf2 var\cf0  keyboardPressDown;\
\cf2 var\cf0  midiBut, oscBut, dmxBut, slPitchBut, knPitchBut, kyPitchBut, prViewBut;\
\cf2 var\cf0  coyoteResponders, coyoteRespondersPrevious, coyoteMidiResponders, midiRoutines;\
\cf2 var\cf0  oscLoopResponders;\
\cf2 var\cf0  midiInPriority, midiOutPriority;\
\cf2 var\cf0  keyUserViews, colorsOnUV;\
\cf2 var\cf0  previousMIDIProgMsg, panHackSynth;\
\cf2 var\cf0  robotPresetCheck, midiPresetCheck;\
\cf2 var\cf0  keyPropLabels;\
\cf2 var\cf0  builtin;\
\cf2 var\cf0  panSynth, panKnob;\
\cf2 var\cf0  noteArray;\
\cf2 var\cf0  sequencer, seqIsOpen= \cf3 false\cf0 ;\
\cf2 var\cf0  oscRecording= \cf3 false\cf0 ;\
\cf2 var\cf0  kbTransp= 0;\
\cf2 var\cf0  oscfilesDir;\
\cf2 var\cf0  loadPresetBut, outputButton, outputButtonResponders;\
\
\
\cf5 ~recOSC\cf0 = \cf3 false\cf0 ;\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf4 // =============================================================================================\cf0 \
\cf4 // ======================================== SETTINGS ===========================================\cf0 \
\cf4 // =============================================================================================\cf0 \
\
outputs= [\cf3 nil\cf0 , 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26];\
noteArray= [\cf6 "(C 1)"\cf0 , \cf6 "(C# 1)"\cf0 , \cf6 "(D 1)"\cf0 , \cf6 "(D# 1)"\cf0 , \cf6 "(E 1)"\cf0 , \cf6 "(F 1)"\cf0 , \cf6 "(F# 1)"\cf0 , \cf6 "(G 1)"\cf0 , \cf6 "(G# 1)"\cf0 , \cf6 "(A 1)"\cf0 , \cf6 "(A# 1)"\cf0 , \cf6 "(B 1)"\cf0 , \cf6 "(C 2)"\cf0 , \cf6 "(C# 2)"\cf0 , \cf6 "(D 2)"\cf0 , \cf6 "(D# 2)"\cf0 , \cf6 "(E 2)"\cf0 , \cf6 "(F 2)"\cf0 , \cf6 "(F# 2)"\cf0 , \cf6 "(G 2)"\cf0 , \cf6 "(G# 2)"\cf0 , \cf6 "(A 2)"\cf0 , \cf6 "(A# 2)"\cf0 , \cf6 "(B 2)"\cf0 , \cf6 "(C 3)"\cf0 , \cf6 "(C# 3)"\cf0 , \cf6 "(D 3)"\cf0 , \cf6 "(D# 3)"\cf0 , \cf6 "(E 3)"\cf0 , \cf6 "(F 3)"\cf0 , \cf6 "(F# 3)"\cf0 , \cf6 "(G 3)"\cf0 , \cf6 "(G# 3)"\cf0 , \cf6 "(A 3)"\cf0 , \cf6 "(A# 3)"\cf0 , \cf6 "(B 3)"\cf0 , \cf6 "(C 4)"\cf0 , \cf6 "(C# 4)"\cf0 , \cf6 "(D 4)"\cf0 , \cf6 "(D# 4)"\cf0 , \cf6 "(E 4)"\cf0 , \cf6 "(F 4)"\cf0 , \cf6 "(F# 4)"\cf0 , \cf6 "(G 4)"\cf0 , \cf6 "(G# 4)"\cf0 , \cf6 "(A 4)"\cf0 , \cf6 "(A# 4)"\cf0 , \cf6 "(B 4)"\cf0 ];\
\
\cf4 //============== from settings file: ===================\cf0 \
\
thisFilePath= \cf7 thisProcess\cf0 .nowExecutingPath.standardizePath.dirname.dirname;\
\
keyboardName= \cf7 thisProcess\cf0 .nowExecutingPath.basename.drop(-4);\
document= \cf7 thisProcess\cf0 .nowExecutingPath.basename.drop(-4);\
settingsPath= (thisFilePath.standardizePath++\cf6 "/"\cf0 ++\cf6 "SETTINGS/"\cf0 ++keyboardName++\cf6 "SETUP"\cf0 );\
\cf4 //oscfilesDir= "/Users/martin/Desktop/OSCRecordings/";\cf0 \
oscfilesDir= (thisFilePath.standardizePath+/+\cf6 "OSCRecordings/"\cf0 );\
\
\cf4 //settingsPath.postln;\cf0 \
\
settings= \cf8 Object\cf0 .readArchive(settingsPath);\
\cf4 //settings.postln;\cf0 \
numKeys= settings[0].asInteger;\
startKey= settings[1];\
knobsCC= settings[2];\
slidersCC= settings[3];\
\cf4 //name.string, = settings[4];\cf0 \
\cf4 //midiDevice= settings[5];\cf0 \
midiInPriority= settings[5];\
\cf4 //midiPortName= settings[6];\cf0 \
midiOutPriority= settings[6];\
backgroundColor= settings[7];\
\
\
\cf4 //Preferences, Overrides settings if exists.\cf0 \
\cf4 //folders routing preferences[] ?? folderRouting= preferences[];\cf0 \
\cf4 //sampler recordings - preferences[] ?? midichannel= preferences[];\cf0 \
\cf4 //preferences[] ?? midichannel = preferences[];\cf0 \
\cf4 // ?? do if nil\cf0 \
\
preferencesPath= (thisFilePath.standardizePath++\cf6 "/"\cf0 ++\cf6 "PREFERENCES/"\cf0 ++keyboardName);\
preferencesFile= (preferencesPath++\cf6 "/"\cf0 ++keyboardName++\cf6 "_CURRENT"\cf0 ).standardizePath;\
if (preferencesFile.isFile, \{\
	\
	preferences= \cf8 Object\cf0 .readArchive(preferencesFile);\
	\cf4 //("preferences:"+preferences).postln;\cf0 \
	numKeys= preferences[0].asInteger;\
	startKey= preferences[1];\
	knobsCC= preferences[2];\
	slidersCC= preferences[3];\
	\cf4 //name.string, = preferences[4];\cf0 \
	\cf4 //midiDevice= preferences[5];\cf0 \
	midiInPriority= preferences[5];\
	\cf4 //midiPortName= preferences[6];\cf0 \
	midiOutPriority= preferences[6];\
	backgroundColor= preferences[7];\
	midichannel= preferences[8];\
	ruleFolderNames= preferences[9];\
	rulesList= preferences[10];\
	rulesApply= preferences[11];\
	rulesOnOff= preferences[12];\
	output= outputs[preferences[13]];\
\});\
\
progressState= 1;\
\
\cf4 // set output to 1+2 if built in soundcard is used\cf0 \
(\cf6 "output after preferences:"\cf0 +output).postln;\
if (s.options.outDevice.contains(\cf6 "Built-in"\cf0 ), \{output= 0; builtin= \cf3 false\cf0 \}, \{builtin= \cf3 true\cf0 \});\
\
(\cf6 "MIDI IN PRIO"\cf0 +midiInPriority).postln;\
midiInPriority[0][0].class.postln;\
(\cf6 "MIDI OUT PRIO"\cf0 +midiOutPriority).postln;\
\
\cf4 /*\
// test witout settingsfile\
keyboardName= Document.current.path.basename.drop(-4);//settings[0]; //name also in dir etc\
numKeys = 25;\
startKey= 36;\
slidersCC = [74, 71, 91, 93, 73, 72, 5, 84, 7];\
knobsCC= [75, 76, 92, 95, 10, 77, 78, 79];\
midichannel= 1;\
midiDevice= "Oxygen 49";\
midiPortName= "Oxygen 49";\
//soundcard\
//settingsPath = \
backgroundColor= Color.grey;\
*/\cf0 \
\
\
case \cf4 //calculate size\cf0 \
	\{ numKeys <= 37 \} \{keyHSize = 20\}\
	\{ numKeys <= 49 \} \{keyHSize = 15\}\
	\{ numKeys > 49 \} \{keyHSize = 10\};\
\
	windowHeight=  (numKeys*keyHSize).clip(600, 935);\
\
\cf8 Platform\cf0 .case(\
	\cf9 \\osx\cf0 ,		\{ ctrl= 262401; shift= 131330; alt= 524576; \},\
	\cf9 \\linux\cf0 ,		\{ ctrl= 262144; shift= 131072; \},\
	\cf9 \\windows\cf0 , 	\{ \cf6 "ERROR: havent tested this on Windows"\cf0 .postcs \}\
);\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf5 ~preferencesWindows\cf0 = \cf5 ~preferencesWindows\cf0  ?? \cf8 Dictionary\cf0 .new;\
\cf5 ~preferencesWindows\cf0 .put(keyboardName.asSymbol, \cf3 false\cf0 );\
filesDir= (\cf8 String\cf0 .scDir.dirname ++ \cf6 "/Resources/SAVEFILES/"\cf0 ++keyboardName++\cf6 "/"\cf0 );\
if(filesDir.isFolder.not, \{filesDir.makeDir\});\
recordingsPath= \cf6 "~/SamplerRecordings/"\cf0 ;\
if (recordingsPath.isFolder.not, \{ recordingsPath.makeDir \});\
if (output == \cf3 nil\cf0 , \{output= 0\});\
kaossFilesDir= (\cf8 String\cf0 .scDir.dirname ++ \cf6 "/Resources/KAOSSPADSAVES/"\cf0 );\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf4 //output= outputs[output];\cf0 \
if (midichannel == 0, \{midichannel= \cf3 nil\cf0 ;\});\
\
if (s.options.device == \cf3 nil\cf0 , \{output = 0\});\
\
\cf4 /*\
~ipDict= (\
	\\fatBot: ["172.16.3.177", 8888],  \
	\\circleBot: ["172.16.3.178", 8888],\
	\\updownBot: ["172.16.3.180", 8888],\
	\\headBot: ["172.16.3.179", 8888],\
	\\servo: ["172.16.3.200", 8888],\
	\\servoMouth: ["172.16.3.200", 8888],\
	\\relay8_1: ["172.16.3.200", 8888],\
	\\relay8_2: ["172.16.3.200", 8888],\
	\\relay8_3: ["172.16.3.200", 8888],\
	\\relay8_4: ["172.16.3.200", 8888],\
	\\relay8_5: ["172.16.3.200", 8888],\
	\\relay8_6: ["172.16.3.200", 8888],\
	\\relay8_7: ["172.16.3.200", 8888],\
	\\relay8_8: ["172.16.3.200", 8888],\
	\\wifi: ["172.16.1.6", 8888],\
	\\wifiMouth: ["172.16.1.6", 8888]\
	);\
~robotDict= ( // label, controlSpec, initValues ([on, off], type, duration) // dur up 4 grabs!\
	\\fatBot: [\\SR1, [0, 127, \\lin, 1].asSpec, [[127, 95], 0, 0.3]], \
	\\circleBot: [\\SR1, [0, 127, \\lin, 1].asSpec, [[100, 95], 0, 0.3]], \
	\\updownBot: [\\SR1, [0, 127, \\lin, 1].asSpec, [[127, 95], 0, 0.3]],\
	\\headBot: [\\SR1, [0, 127, \\lin, 1].asSpec, [[127, 90], 0, 0.3]],\
	\\servo: [\\SR1, [0, 127, \\lin, 1].asSpec, [[127, 65], 0, 0.3]],\
	\\servoMouth: [\\SR2, [0, 127, \\lin, 1].asSpec, [[80, 127], 0, 0.3]],\
	\\relay8_1: [\\RL1, [0, 1, \\lin, 1].asSpec, [[0, 1], 0, 0.3]],\
	\\relay8_2: [\\RL2, [0, 1, \\lin, 1].asSpec, [[0, 1], 0, 0.3]],\
	\\relay8_3: [\\RL3, [0, 1, \\lin, 1].asSpec, [[0, 1], 0, 0.3]],\
	\\relay8_4: [\\RL4, [0, 1, \\lin, 1].asSpec, [[0, 1], 0, 0.3]],\
	\\relay8_5: [\\RL5, [0, 1, \\lin, 1].asSpec, [[0, 1], 0, 0.3]],\
	\\relay8_6: [\\RL6, [0, 1, \\lin, 1].asSpec, [[0, 1], 0, 0.3]],\
	\\relay8_7: [\\RL7, [0, 1, \\lin, 1].asSpec, [[0, 1], 0, 0.3]],\
	\\relay8_8: [\\RL8, [0, 1, \\lin, 1].asSpec, [[0, 1], 0, 0.3]],\
	\\wifi: [\\SR1, [0, 127, \\lin, 1].asSpec, [[80, 64], 0, 0.3]],\
	\\wifiMouth: [\\SR2, [0, 127, \\lin, 1].asSpec, [[30, 64], 0, 0.3]],\
	);\
*/\cf0 \
\
\
\cf4 // ================ MIDI INITIALIZATION ================\cf0 \
\
\cf4 //midiInPriority= [["IAC Driver", "Bus 1"], nil, nil];\cf0 \
\cf4 //midiInPriority[0]= midiDevice;\cf0 \
\cf4 // connect midi in\cf0 \
midiInPriority.do(\{\cf2 |it, i|\cf0 \
	if (it.isNil.not and: \{midisrc.isNil\}, \{\
		\cf8 MIDIClient\cf0 .sources.do(\{ \cf2 |midiSource, i|\cf0 \
			\cf4 //("it device:"+midiSource.device.asString).postln;\cf0 \
			\cf4 //(midiSource).postln;\cf0 \
	\
			if((midiSource.device).contains(it[0]) and: \{midisrc.isNil\}, \{\
				midisrc= midiSource.uid; \
				midisrcindex= i;\
				(\cf6 "MIDI IN DEVICE:"\cf0 +it[0]).postln;\
				\cf4 //(it.uid).postln;\cf0 \
				\});\
		\});\
	\});\
\});\
\
if (midisrc.isNil.not, \{\
		\cf8 MIDIIn\cf0 .connectByUID(0, midisrc);\
	\},\{\
		\{\cf8 SCAlert\cf0 (\cf6 "No MIDI Keyboard connected"\cf0 , [\cf6 "OK!"\cf0 ]).focus(0)\}.defer(0.05);\
		midisrc= \cf3 nil\cf0 ; \
		midisrcindex= \cf3 nil\cf0 ;\
\});\
\
\
if(midisrc.isNil.not, \{\
if(\cf8 MIDIClient\cf0 .sources[midisrcindex].device.contains(\cf6 "Oxygen 49"\cf0 ), \{\
\
	outputButtonResponders= (31..39).collect(\{\cf2 |it, i|\cf0 \
		\cf8 CCResponder\cf0 (\{ \cf2 |src,chan,num,value|\cf0 \
\'a0 \'a0 	\'a0 \'a0 \cf4 //[src,chan,num,value].postln;\cf0 \
			\{outputButton.valueAction= i\}.defer;\
\'a0 \'a0 		\'a0 \'a0 \},\
		num: (it), src: midisrcindex, chan: midichannel\
	\'a0 \'a0 );\
	\});\
\
\});\
\});\
\
\cf4 /*\
// commented out 4 march 2013\
MIDIClient.sources.do(\{ |it, i|\
	("it device:"+it.device.asString).postln;\
	(midiDevice).postln;\
	\
	if((it.device).contains(midiDevice), \{\
		midisrc= it.uid; \
		midisrcindex= i;\
		"found midi source with DO!".postln;\
		//(it.uid).postln;\
		\});\
	\});\
\
\{ midisrc= (MIDIIn.findPort(midiDevice, midiPortName).uid) \}.try;\
*/\cf0 \
\
\cf4 //midisrcindex= 1;\cf0 \
\
\cf4 /*\
MIDIClient.sources.do(\{ |it, i|\
	if(it.uid== midisrc, \{midisrcindex= i\});\
	\});\
*/\cf0 \
\
\cf4 //("LE midisource: "++MIDIClient.sources.at(midisrcindex).asString).postln;\cf0 \
\
\cf4 //MIDIIn.connect(1, MIDIClient.sources.at(1));\cf0 \
\cf4 //MIDIIn.connect;\cf0 \
\
\cf4 /* \
// commented out 4 march 2013\
if (midisrc.isNil.not, \{\
		MIDIIn.connectByUID(0, midisrc);\
	\},\{\
		SCAlert("No MIDI Keyboard connected", ["OK!"]);\
		midisrc= nil; \
		midisrcindex= nil;\
\});\
\
("MIDI source:"+midisrc.asString).postln;\
("MIDI src index:"+midisrcindex.asString).postln;\
*/\cf0 \
\
\cf4 //midiOutPriority= [["IAC Driver", "Bus 1"], nil, nil];\cf0 \
\cf4 // connect midi out\cf0 \
midiOutPriority.do(\{\cf2 |it, i|\cf0 \
	if (it.isNil.not and: \{midiOut.isNil\}, \{\
		if (\cf8 MIDIOut\cf0 .findPort(it[0], it[1]).isNil.not, \{\
			(\cf6 "MIDI OUT DEVICE:"\cf0 +it[0]).postln;\
			midiOut= \cf8 MIDIOut\cf0 .newByName(it[0], it[1]);\
		\});\
		\cf4 /*\
		MIDIClient.destinations.do(\{ |midiDestination, i|\
			//("MIDI OUT device:"+midiDestination.device.asString).postln;\
			//(it).postln;\
\
			if((midiDestination.device.asString).contains(it[0]), \{\
				//midiDestination.device.postln; midiDestination.port.postln;\
				midiOut= MIDIOut.newByName(it[0], it[1]);\
				midiOut.latency= 0;\
				"found midi DESTINATION and connected!".postln;\
				//(it.uid).postln;\
			\});\
		\});\
		*/\cf0 \
	\});\
\});\
\
\cf4 /*\
MIDIClient.destinations.do(\{ |it, i|\
	//("MIDI OUT device:"+it.device.asString).postln;\
	//(midiDevice).postln;\
	\
	if((it.device).contains(midiDevice), \{\
		//it.device.postln; it.port.postln;\
		midiOut= MIDIOut.newByName("AudioFire12 (1576)", "Plug 1");\
		midiOut.latency= 0;\
		"found midi DESTINATION and connected!".postln;\
		//(it.uid).postln;\
		\});\
	\});\
\
*/\cf0 	\
\
\cf4 //midiOut= MIDIOut.newByName("AudioFire12 (1576)", "Plug 1");\cf0 \
\cf4 //midiOut.latency= 0;\cf0 \
\
\
\
\
\cf4 // ================= DMX INITIALIZATION ===============\cf0 \
\
if (\cf5 ~dmx\cf0 .isNil, \{\
	\cf8 SerialPort\cf0 .devices.do(\{\cf2 |it|\cf0 \
		if (it.asSymbol == \cf9 '/dev/tty.usbserial-EN109012'\cf0 ,\
			\{ \cf6 "connecting dmx"\cf0 .postln;\
				\cf5 ~dmx\cf0 = \cf8 DMX\cf0 .new;\
				\cf4 //~dmx.device= EntTecDMXUSBPro.new( "/dev/tty.usbserial-EN109012" );\cf0 \
				\cf5 ~dmx\cf0 .currentCue= \cf8 DMXCue\cf0 .new; \cf4 //make into subcue....\cf0 \
				\cf4 //~dmx.setCue;\cf0 \
				(\cf6 "DMX is:"\cf0 +\cf5 ~dmx\cf0 ).postln;\
				(\cf6 "DMX current cue is:"\cf0 +\cf5 ~dmx\cf0 .currentCue).postln;\
		\});\
	\});\
\});\
\
\
\
\
\cf4 //============= SAMPLER INIT =============\cf0 \
\
\
\cf4 //a= RedDiskInSamplerGiga(s);\cf0 \
a= \cf8 RedCombiSampler\cf0 (s, 30); \cf4 //threshold of seconds to read from disk instead of ram\cf0 \
\
\
\
\
sounds= \cf8 Array\cf0 .newClear(numKeys);\
soundsASR= ([]!numKeys).asList;\
properties= numKeys.collect(\{ [0.5, 0, 0, 0.01, 0.1, 0, 0, 3, 0, 0, \cf3 nil\cf0 , [0, [0, 0], [0, 0], 0, 0.3, 0], [0.1, 0.2, 0], [0, 0, 1], 1, [0, \cf8 Dictionary\cf0 .new], [0, [\cf8 DMXSubCue\cf0 .new, \cf8 DMXSubCue\cf0 .new]] ].asList \});\
defaultProperties= numKeys.collect(\{ [0.5, 0, 0, 0.01, 0.1, 0, 0, 3, 0, 0, \cf3 nil\cf0 , [0, [0, 0], [0, 0], 0, 0.3, 0], [0.1, 0.2, 0], [0, 0, 1], 1, [0, \cf8 Dictionary\cf0 .new], [0, [\cf8 DMXSubCue\cf0 .new, \cf8 DMXSubCue\cf0 .new]] ].asList \});\
knobSounds= \cf3 nil\cf0 !8;\
sliderSounds= \cf3 nil\cf0 !8;\
masterprop= (\cf9 \\poly\cf0 : 0, \cf9 \\vel\cf0 : 0, \cf9 \\midi\cf0 : 0, \cf9 \\osc\cf0 : 0, \cf9 \\dmx\cf0 : 0, \cf9 \\slPitch\cf0 : 0, \cf9 \\knPitch\cf0 : 0, \cf9 \\kyPitch\cf0 : 1, \cf9 \\prView\cf0 : 1);\
progress= []!numKeys;\
timer = (0!numKeys).asList;\
arpRoutines= (0!numKeys);\
bend= 1;\
coyoteResponders= \cf8 Array\cf0 .newClear(numKeys);\
coyoteRespondersPrevious= \cf8 Array\cf0 .newClear(numKeys);\
coyoteMidiResponders= \cf8 Array\cf0 .newClear(numKeys);\
midiRoutines= \cf8 Array\cf0 .newClear(numKeys);\
oscRoutines= \cf8 List\cf0 .new ! numKeys;\
oscLoopResponders= \cf8 Array\cf0 .newClear(numKeys);\
keyboardPressDown= \cf3 true\cf0 !numKeys;\
\
ampspec= \cf8 ControlSpec\cf0 ( 0.001, 1.0,\cf9 \\amp\cf0 );\
\
sizes= [1, 0.7, 1, 0.7, 1, 1, 0.7, 1, 0.7, 1, 0.7, 1, ];\
\
colors= [\cf8 Color\cf0 .new255(160, 255, 160), \cf8 Color\cf0 .black, \cf8 Color\cf0 .white, \cf8 Color\cf0 .black, \cf8 Color\cf0 .white, \cf8 Color\cf0 .white, \cf8 Color\cf0 .black, \cf8 Color\cf0 .white, \cf8 Color\cf0 .black, \cf8 Color\cf0 .white, \cf8 Color\cf0 .black, \cf8 Color\cf0 .white];\
\
textcolors= [\cf8 Color\cf0 .black, \cf8 Color\cf0 .white, \cf8 Color\cf0 .black, \cf8 Color\cf0 .white, \cf8 Color\cf0 .black, \cf8 Color\cf0 .black, \cf8 Color\cf0 .white, \cf8 Color\cf0 .black, \cf8 Color\cf0 .white, \cf8 Color\cf0 .black, \cf8 Color\cf0 .white, \cf8 Color\cf0 .black];\
\
colorsOn= [\cf8 Color\cf0 .yellow.alpha_(0), \cf8 Color\cf0 .new255(255, 165, 0).alpha_(0), \cf8 Color\cf0 .yellow.alpha_(0), \cf8 Color\cf0 .new255(255, 165, 0).alpha_(0), \cf8 Color\cf0 .yellow.alpha_(0), \cf8 Color\cf0 .yellow.alpha_(0), \cf8 Color\cf0 .new255(255, 165, 0).alpha_(0), \cf8 Color\cf0 .yellow.alpha_(0), \cf8 Color\cf0 .new255(255, 165, 0).alpha_(0), \cf8 Color\cf0 .yellow.alpha_(0), \cf8 Color\cf0 .new255(255, 165, 0).alpha_(0), \cf8 Color\cf0 .yellow.alpha_(0)];\
\
colorsOnUV= [\cf8 Color\cf0 .yellow, \cf8 Color\cf0 .new255(255, 165, 0), \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .new255(255, 165, 0), \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .new255(255, 165, 0), \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .new255(255, 165, 0), \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .new255(255, 165, 0), \cf8 Color\cf0 .yellow];\
\
\
\
\cf4 // =============================================================================================\cf0 \
\cf4 // ===================================== MIDI RESPONDERS =======================================\cf0 \
\cf4 // =============================================================================================\cf0 \
\
\
\
noteon= \cf8 NoteOnResponder\cf0 (\{ \cf2 |src,chan,note,vel|\cf0 \
	\cf2 var\cf0  num, event= \cf3 nil\cf0 ;\
	\cf4 //[src,chan,note,vel].postln;\cf0 \
	note= note-startKey;\
	if(note.inRange(0, (numKeys-1)), \{\
		num= sounds[note];\
		if(verbose, \{(\cf6 "snd"\cf0 ++((note).asString)).postln;\});\
		if (velocitystate == 1, \{ vel= vel/127 \}, \{vel = \cf3 nil\cf0 \});\
		playnote.value(event, num, note, vel);\
	\},\
	\{\cf6 "key out of range"\cf0 .postln;\});\
	\},\
	midisrc, \cf4 // source\cf0 \
	midichannel \cf4 // channel\cf0 \
	);\
\
noteoff= \cf8 NoteOffResponder\cf0 (\{ \cf2 |src,chan,note,vel|\cf0 \
	\cf2 var\cf0  num;\
	\cf4 //[src,chan,note,vel].postln;\cf0 \
	note= note-startKey;\
		if(note.inRange(0, (numKeys-1)), \{\
			num= sounds[note];\
			stopnote.value(num, note);\
		\},\
		\{\cf6 "key out of range"\cf0 .postln;\});\
	\},\
	midisrc, \cf4 // source\cf0 \
	midichannel \cf4 // channel\cf0 \
	);\
	\
\
\cf4 // =============================================================================================\cf0 \
\cf4 // ======================================== NOTE ON ============================================\cf0 \
\cf4 // =============================================================================================\cf0 \
\
\cf4 //remove event\cf0 \
playnote= \{\cf2 |event, num, key, vel, id, dur|\cf0 \
	\cf2 var\cf0  amp, seq= 4, out, asrName, loopId;\
	\
	if(masterprop[\cf9 \\osc\cf0 ] == 1, \{ \
		properties[key][15][1].keysValuesDo(\{\cf2 |robot, value|\cf0 \
			\cf4 //if (value[1] == 1, \{ id= key \});\cf0 \
			if (value[1] == 1, \{ id= \cf8 UniqueID\cf0 .next; (\cf6 "id:"\cf0 +id).postln; \});\
		\});\
		if (properties[key][1]==1, \{loopId= \cf8 UniqueID\cf0 .next\});\
	\});\
\
	if (num.isNil.not, \{\
		\
		if (properties[key][10].isNil.not && builtin, \{out= properties[key][10] \}, \{\
			if (sounds[key].contains(folderRouting), \cf4 //speech\cf0 \
				\{ \cf6 "speaking"\cf0 .postln; out= speechout; \}, \{ out= output;  \});\
			\});\
		if( vel.isNil, \{amp = properties[key][0]\}, \{amp= vel\});\
		if( properties[key][5] == 1,\{\{killothernotes.value(key)\}.try\}); \cf4 //killa\cf0 \
		case\
		\{properties[key][2] == 0\} \cf4 //playback mode piano (default)\cf0 \
		\{\
			a.play((\cf6 "snd"\cf0 ++((key).asString)).asSymbol, \
				amp: amp,\
				loop: properties[key][1],\
				attack: properties[key][3],\
				sustain: dur,\
				pan: properties[key][9],\
				speed: properties[key][14] * bend,\
				offset: properties[key][13][0],\
				startLoop: properties[key][13][1],\
				endLoop: properties[key][13][2],\
				id: id,\
				loopId: loopId,\
				out: out\
			);\
			\cf4 //id.postln;\cf0 \
			if (progressState == 1, \{progressView.value(key)\});\
			\{ keyButs[key].value= 1; \}.defer;\
		\}\
		\{properties[key][2] == 1\} \cf4 //playback mode one shot\cf0 \
		\{a.play((\cf6 "snd"\cf0 ++((key).asString)).asSymbol, \
				amp: amp,\
				loop: 0,\
				attack: properties[key][3],\
				sustain: dur,\
				pan: properties[key][9],\
				speed: properties[key][14] * bend,\
				offset: properties[key][13][0],\
				out: out\
			);\
		\{ keyButs[key].value= 1; \}.defer;\
		\}\
		\{properties[key][2] == 2\} \cf4 //playback mode toggle\cf0 \
		\{ \
			case \
			\{a.isPlaying((\cf6 "snd"\cf0 ++((key).asString)).asSymbol) == \cf3 false\cf0 \} \
			\{a.play((\cf6 "snd"\cf0 ++((key).asString)).asSymbol, \
				amp: amp,\
				loop: properties[key][1],\
				attack: properties[key][3],\
				sustain: dur,\
				pan: properties[key][9],\
				speed: properties[key][14] * bend,\
				offset: properties[key][13][0],\
				startLoop: properties[key][13][1],\
				endLoop: properties[key][13][2],\
				id: id,\
				loopId: loopId,\
				out: out );\
				\cf4 //"it is not playing".postln;\cf0 \
				\{ keyButs[key].value= 1; \}.defer;\
				if (progressState == 1, \{progressView.value(key)\});\
			\}\
			\{a.isPlaying((\cf6 "snd"\cf0 ++((key).asString)).asSymbol)\}\
			\{stopnote.value(num, key, 1); \{ keyButs[key].value= 0; \}.defer; \};\
		\}\
		\{properties[key][2] == 3\} \cf4 //3 samples ASR\cf0 \
		\{ \
		a.play((\cf6 "snd"\cf0 ++((key).asString++\cf6 "a"\cf0 )).asSymbol, \cf4 //attack sound\cf0 \
				amp: amp,\
				loop: 0,\
				attack: 0.01,\
				sustain: dur,\
				pan: properties[key][9],\
				speed: properties[key][14] * bend,\
				offset: properties[key][13][0],\
				out: out\
			);	\
		a.play((\cf6 "snd"\cf0 ++((key).asString)).asSymbol, \cf4 //looped sound\cf0 \
				amp: amp,\
				loop: 1,\
				attack: properties[key][3],\
				sustain: dur,\
				pan: properties[key][9],\
				speed: properties[key][14] * bend,\
				offset: properties[key][13][0],\
				out: out\
			);\
			(\cf6 "key playnote"\cf0 +key).postln;\
			\{ keyButs[key].value= 1; \}.defer;\
		\}\
		\{properties[key][2] == 4\} \cf4 //2 samples \cf0 \
		\{ \
			if(properties[key][8] == 0, \{ \cf4 //shot\cf0 \
				a.stop((\cf6 "snd"\cf0 ++((key).asString++\cf6 "x0"\cf0 )).asSymbol, properties[key][4]);\
			\});\
			a.play((\cf6 "snd"\cf0 ++((key).asString)).asSymbol, \
				amp: amp,\
				loop: properties[key][1],\
				attack: properties[key][3],\
				sustain: dur,\
				pan: properties[key][9],\
				speed: properties[key][14] * bend,\
				offset: properties[key][13][0],\
				out: out\
			);\
			\{ keyButs[key].value= 1; \}.defer;\
		\}\
		\{properties[key][2] == 5\} \cf4 //5 samples \cf0 \
		\{ \cf4 //"trying to play...".postln;\cf0 \
			if(properties[key][6] == 0, \{ \cf4 //sequence\cf0 \
				if ((\cf8 Date\cf0 .getDate.bootSeconds.round(1) - timer[key]) > 5, \{properties[key][7] = \cf3 nil\cf0 ;\});\
				if (properties[key][7].isNumber.not, \{properties[key][7]= 0\});\
				a.play((\cf6 "snd"\cf0 ++((key).asString++\cf6 "x"\cf0 ++(properties[key][7].asString))).asSymbol, \
				amp: amp,\
				loop: properties[key][1],\
				attack: properties[key][3],\
				sustain: dur,\
				pan: properties[key][9],\
				speed: properties[key][14] * bend,\
				offset: properties[key][13][0],\
				out: out\
				);\
				asrName= soundsASR[key][properties[key][7]].basename.removeExtension;\
				\{ keyButs[key].states= ([[asrName, textcolors[key.wrap(0, 12);], colors[key.wrap(0, 12);]], [asrName, \cf8 Color\cf0 .black, colorsOn[key.wrap(0, 12)]] ]); \
					\cf4 //key.deepCopy.wrap(0, 12).postln; \cf0 \
					\cf4 //key.postln; \cf0 \
					\}.defer;\
				properties[key][7]= (properties[key][7]+1).deepCopy.wrap(0, (soundsASR[key].size-1));\
				\cf4 //timer[key] = Date.getDate.bootSeconds.round(1);\cf0 \
\
			\});			\
			if(properties[key][6] == 1, \{ \cf4 //random\cf0 \
				properties[key][7]= (\cf6 "snd"\cf0 ++((key).asString++\cf6 "x"\cf0 ++((soundsASR[key].size.rand).asString))).asSymbol;\
				\cf4 //properties[key][7].postln;\cf0 \
				a.play(properties[key][7], \
					amp: amp,\
					loop: properties[key][1],\
					attack: properties[key][3],\
					sustain: dur,\
					pan: properties[key][9],\
					speed: properties[key][14] * bend,\
					offset: properties[key][13][0],\
					out: out\
				);\
			\});\
			if(properties[key][6] == 2, \{ \cf4 // no reset\cf0 \
				\cf4 //if ((Date.getDate.bootSeconds.round(1) - timer[key]) > 5, \{properties[key][7] = nil;\});\cf0 \
				if (properties[key][7].isNumber.not, \{properties[key][7]= 0\});\
				a.play((\cf6 "snd"\cf0 ++((key).asString++\cf6 "x"\cf0 ++(properties[key][7].asString))).asSymbol, \
				amp: amp,\
				loop: properties[key][1],\
				attack: properties[key][3],\
				sustain: dur,\
				pan: properties[key][9],\
				speed: properties[key][14] * bend,\
				offset: properties[key][13][0],\
				out: out\
				);\
				asrName= soundsASR[key][properties[key][7]].basename.removeExtension;\
				\{ keyButs[key].states= ([[asrName, textcolors[key.wrap(0, 12);], colors[key.wrap(0, 12);]], [asrName, \cf8 Color\cf0 .black, colorsOn[key.wrap(0, 12)]] ]); \
					\cf4 //key.deepCopy.wrap(0, 12).postln; \cf0 \
					\cf4 //key.postln; \cf0 \
					\}.defer;\
				properties[key][7]= (properties[key][7]+1).deepCopy.wrap(0, (soundsASR[key].size-1));\
				\cf4 //timer[key] = Date.getDate.bootSeconds.round(1);\cf0 \
\
			\});		\
			\{ keyButs[key].value= 1; \}.defer;\
		\}\
		\{properties[key][2] == 6\} \cf4 //ARPEGGIO\cf0 \
		\{\
			case \
			\{arpRoutines[key].isPlaying.not\}\
			\{\
			arpRoutines[key]= \{\
			\cf2 var\cf0  length=0.3, timeToNext=0.1;\
			loop\{\
			length= properties[key][12][0];\
			timeToNext= properties[key][12][1];\
			a.play((\cf6 "snd"\cf0 ++((key).asString)).asSymbol, \
			amp: amp,\
			loop: 0,\
			attack: properties[key][3],\
			sustain: dur,\
			pan: properties[key][9],\
			speed: properties[key][14] * bend,\
			offset: properties[key][13][0],\
			out: out\
			);\
			length.wait;\
			a.stop((\cf6 "snd"\cf0 ++((key).asString)).asSymbol, properties[key][4]);\
			timeToNext.wait;\
			\};\
			\}.fork;\
			\{ keyButs[key].value= 1; \}.defer;\
			\}\
			\{arpRoutines[key].isPlaying\}\
			\{arpRoutines[key].stop;\
				a.stop((\cf6 "snd"\cf0 ++((key).asString)).asSymbol, properties[key][4]);\
				\{ keyButs[key].value= 0; \}.defer;\};\
		\};	\
	\});\
	\cf4 //\{ keyButs[key].value= 1; \}.defer;\cf0 \
	if( \cf5 ~logfile\cf0 .isNil.not, \{ \{\cf5 ~logfile\cf0 .write(\cf8 Date\cf0 .getDate.hourStamp.asString+(sounds[key].basename)++\cf6 "\\n"\cf0 )\}.defer; \});\
	\
	\cf4 //SEND MIDIOUT SYSEX\cf0 \
	if(masterprop[\cf9 \\midi\cf0 ] == 1, \{\
	if(midiOut.isNil.not, \{\
		if(properties[key][11][0] == 1, \{\
			\cf4 //("midiprops:"+properties[key][11]).postln;\cf0 \
				\cf4 //midiOut.control(1, properties[key][11][0], properties[key][11][1]) ;\cf0 \
				\cf4 //p.send($w, $a, 0, properties[key][11][0])\cf0 \
				case \
				\{properties[key][11][3] == 0\} \{	\cf4 // ------ play single value ------\cf0 \
					case\
					\{properties[key][11][5] == 0\} \{ \cf4 // submaster\cf0 \
						\cf4 //midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][1][0], 0x00, properties[key][11][1][1], 0x00, 0xf7]);\cf0 \
						midiOut.sysex(\cf8 ETCEonSysex\cf0 .submaster(1, properties[key][11][1][0], properties[key][11][1][1]));\
					\}\
					\{properties[key][11][5] == 1\} \{ \cf4 // macro\cf0 \
					\cf4 //midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x07, properties[key][11][1][0], 0xf7]);\cf0 \
						midiOut.sysex(\cf8 ETCEonSysex\cf0 .macro(1, properties[key][11][1][0]));\
					\}\
					\{properties[key][11][5] == 2\} \{ \cf4 // go cue\cf0 \
						midiOut.sysex(\cf8 ETCEonSysex\cf0 .goCue(1, properties[key][11][1][0], properties[key][11][1][1]));\
					\}\
					\{properties[key][11][5] == 3\} \{ \cf4 // grandmaster\cf0 \
						midiOut.sysex(\cf8 ETCEonSysex\cf0 .grandmaster(1, properties[key][11][1][1]));\
					\};\
				\}\
				\{properties[key][11][3] == 1\} \{	\cf4 // ------ play onset detection ------\cf0 \
					case\
					\{properties[key][11][5] == 0\} \{ \cf4 // submaster\cf0 \
						if(coyoteMidiResponders[key].isNil.not, \{coyoteMidiResponders[key].remove\});\
						coyoteMidiResponders[key] = \cf8 OSCresponderNode\cf0 (s.addr, \cf9 '/tr'\cf0 , \{ \cf2 arg\cf0  t, r, msg;\
							if (msg[2] == id, \{\
							\{\
							\cf4 //midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][1][0], 0x00, properties[key][11][1][1], 0x00, 0xf7]);\cf0 \
							midiOut.sysex(\cf8 ETCEonSysex\cf0 .submaster(1, properties[key][11][1][0], properties[key][11][1][1]));\
							properties[key][11][4].wait; \cf4 //duration.wait....\cf0 \
							\cf4 //midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][2][0], 0x00, properties[key][11][2][1], 0x00, 0xf7]);\cf0 \
							midiOut.sysex(\cf8 ETCEonSysex\cf0 .submaster(1, properties[key][11][2][0], properties[key][11][2][1]));\
						\}.fork;\
				\'a0 	\'a0 	\cf4 //[t, msg].postln;\cf0 \
						\});\
						\}).add;\
					\}\
					\{properties[key][11][5] == 1\} \{ \cf4 // macro\cf0 \
					\cf3 nil\cf0 \
					\}\
					\{properties[key][11][5] == 3\} \{ \cf4 // grandmaster\cf0 \
					\cf3 nil\cf0 \
					\};\
				\}\
				\
				\{properties[key][11][3] == 2\} \{	\cf4 // ------ play sequence ------\cf0 \
					\cf4 //"play midi sequence".postln;\cf0 \
					midiRoutines[key]= \cf8 Routine\cf0 \{\
						\cf2 var\cf0  values, duration, prevVal= \cf3 nil\cf0 ;\
						values= properties[key][11][1][1];\
						duration= properties[key][11][4];\
						\
						\cf4 //("values:"+values).postln;\cf0 \
						\cf4 //("duration:"+duration).postln;\cf0 \
						\
						loop\{\
							values.do(\{\cf2 |it, i|\cf0 \
\
								\cf4 //"do I get here?".postln;\cf0 \
								\cf4 //("whats is this:"+properties[key][11][1][1][1][i]).postln;\cf0 \
								\cf4 //("set value:"+(properties[key][11][1][1][1][i]*100)).postln;\cf0 \
								\cf4 // insert alternatives case here\cf0 \
								if( it != prevVal, \{\
								case\
								\{properties[key][11][5] == 0\} \{ \cf4 // submaster\cf0 \
									midiOut.sysex(\cf8 ETCEonSysex\cf0 .submaster(1, properties[key][11][1][0], it*100)); \}\
								\{properties[key][11][5] == 1\} \{ \cf4 // macro\cf0 \
									\cf3 nil\cf0 \
								\}\
								\{properties[key][11][5] == 3\} \{ \cf4 // grandmaster\cf0 \
									midiOut.sysex(\cf8 ETCEonSysex\cf0 .grandmaster(1, it*100));\
								\};\
								prevVal= it;\
								\});\
												\
								(duration/values.size).wait; \cf4 //*durationView.value\cf0 \
\
								\
								\});\
							\}\
					\}.play(\cf8 AppClock\cf0 );\
				\};\
		\});\
	\});\
	\});\
	\
	\cf4 // =========== SEND OSC ==============\cf0 \
	if(masterprop[\cf9 \\osc\cf0 ] == 1, \{\
	if( properties[key][15][0] == 1, \{\
		properties[key][15][1].keysValuesDo(\{\cf2 |robot, value|\cf0 \
			\cf4 //if (oscRecording, \{ NetAddr("localhost", NetAddr.langPort).sendMsg(~robotDict[robot][0]++value[0][0]); \});\cf0 \
			case \
			\{value[1] == 0\} \{	\cf4 // play single value\cf0 \
				(\cf6 "Note on OSC:"\cf0 +[robot, \cf5 ~robotDict\cf0 [robot][0], value[0][0]]).postln;\
				\cf8 NetAddr\cf0 (\cf5 ~ipDict\cf0 [robot][0], \cf5 ~ipDict\cf0 [robot][1]).sendMsg(\
					\cf5 ~robotDict\cf0 [robot][0]++value[0][0]);\
				if (\cf5 ~recOSC\cf0 , \{ \cf8 NetAddr\cf0 (\cf6 "localhost"\cf0 , \cf8 NetAddr\cf0 .langPort).sendMsg(\cf5 ~ipDict\cf0 [robot][0],\cf5 ~robotDict\cf0 [robot][0]++value[0][0]); \});\
			\}\
			\{value[1] == 1\} \{ \cf4 //play onset detection\cf0 \
				if(coyoteResponders[key].isNil.not, \{coyoteResponders[key].remove\});\
				coyoteResponders[key] = \cf8 OSCresponderNode\cf0 (s.addr, \cf9 '/tr'\cf0 , \{ \cf2 arg\cf0  t, r, msg;\
					(\cf6 "osc msg:"\cf0 +msg).postln; \cf4 //debug!\cf0 \
					if (msg[2]==id and: \{msg[3]!= coyoteRespondersPrevious[key]\}, \{\
						if (msg[3]==1, \{\
					(\cf6 "osc ON recieved"\cf0 +id.asString).postln;\
						\cf8 NetAddr\cf0 (\cf5 ~ipDict\cf0 [robot][0], \cf5 ~ipDict\cf0 [robot][1]).sendMsg(\cf5 ~robotDict\cf0 [robot][0]++value[0][0]);\
						\
						if (\cf5 ~recOSC\cf0 , \{ \cf8 NetAddr\cf0 (\cf6 "localhost"\cf0 , \cf8 NetAddr\cf0 .langPort).sendMsg(\cf5 ~ipDict\cf0 [robot][0],\cf5 ~robotDict\cf0 [robot][0]++value[0][0]); \});\
						\},\{\
					(\cf6 "osc OFF recieved"\cf0 +id.asString).postln;\
						\cf8 NetAddr\cf0 (\cf5 ~ipDict\cf0 [robot][0], \cf5 ~ipDict\cf0 [robot][1]).sendMsg(\cf5 ~robotDict\cf0 [robot][0]++value[0][1]);\
						if (\cf5 ~recOSC\cf0 , \{ \cf8 NetAddr\cf0 (\cf6 "localhost"\cf0 , \cf8 NetAddr\cf0 .langPort).sendMsg(\cf5 ~ipDict\cf0 [robot][0],\cf5 ~robotDict\cf0 [robot][0]++value[0][1]); \});\
						\});\
						coyoteRespondersPrevious[key]= msg[3];\
				\'a0 \'a0 	\cf4 //[t, msg].postln;\cf0 \
					\});\
				\}).add;\
			\}\
			\{value[1] == 2\} \{ \cf4 // play sequence recording\cf0 \
				oscRoutines[key].add(\cf8 OSCFileLogPlayer\cf0 .new(value[0][0], \cf8 NetAddr\cf0 (\cf5 ~ipDict\cf0 [robot][0], \cf5 ~ipDict\cf0 [robot][1])));\
				oscRoutines[key].last.play;\
				if (properties[key][1]==1, \{\
					\cf6 "making loop responder"\cf0 .postln;\
					if(oscLoopResponders[key].isNil.not, \{\
					oscLoopResponders[key]= \cf8 OSCresponderNode\cf0 (s.addr, \cf9 '/tr'\cf0 , \{ \cf2 arg\cf0  t, r, msg;\
					\cf4 //("osc loop msg:"+msg).postln; //debug!\cf0 \
					if (msg[2]==loopId, \{\
						oscRoutines[key].do(\{\cf2 |it|\cf0  it.stop \});\
						oscRoutines[key].do(\{\cf2 |it|\cf0  it.play \});\
						\});\
					\}).add;\
					\});\
				\});\
				\cf4 //("note on osc resp"+oscRoutines[key]).postln;\cf0 \
			\}\
			\{value[1] == 4\} \{ \cf4 // send custom message\cf0 \
				\cf6 "custom note on"\cf0 .postln;\
				\cf5 ~ipDict\cf0 [robot][0].post; \cf5 ~ipDict\cf0 [robot][1].postln;\
				(value[0][0]).postln;\
				(value[0][1]).postln;\
				\cf8 NetAddr\cf0 (\cf5 ~ipDict\cf0 [robot][0], \cf5 ~ipDict\cf0 [robot][1]).sendBundle(value[0][0]);\
			\};\
		\});\
	\});\
	\});\
	\
	\cf4 //SEND DMX\cf0 \
	\cf4 //("DMX props:"+properties[key][16]).postln;\cf0 \
	if(masterprop[\cf9 \\dmx\cf0 ] == 1, \{\
	if( \cf5 ~dmx\cf0 .isNil.not, \{\
		if( properties[key][16][0] == 1, \{\
			\cf4 //("Sending DMX note ON:"+properties[key][16][1][0].data).postln;\cf0 \
			\cf4 //~dmx.fade(properties[key][16][1][0], 0.1, 'linear', 0.1);\cf0 \
			properties[key][16][1][0].data.keysValuesDo(\{\cf2 |chan, val|\cf0 \
				(\cf6 "chan:"\cf0 +chan+\cf6 "val:"\cf0 +val).postln;\
				\cf8 NetAddr\cf0 (\cf6 "127.0.0.1"\cf0 , 6666).sendMsg(\cf6 "/dmx"\cf0 +chan, val*100);\
			\});\
		\});\
	\});\
	\});\
	\
\};\
\
\
\cf4 // =============================================================================================\cf0 \
\cf4 // ======================================== NOTE OFF ===========================================\cf0 \
\cf4 // =============================================================================================\cf0 \
\
stopnote= \{\cf2 | num, key, forcestop, id|\cf0 \
	if (num.isNil.not, \{\
		\
			\cf4 //if(masterprop[\\osc] == 1, \{ id= key \}); //test\cf0 \
			\
		case\
		\{properties[key][2] == 0\} \{ \
			if(properties[key][8] == 0, \{ \cf4 //shot\cf0 \
				a.stop((\cf6 "snd"\cf0 ++((key).asString)).asSymbol, properties[key][4]);\
			\});\
			\{ keyButs[key].value= 0;\
				if (progressState == 1, \{\
					progress[key].stop; \
					progressViewClear.value(key) \
				\});\
				\}.defer; \
		\}\
		\{properties[key][2] == 3\} \{ \cf4 // 3 samples ASR\cf0 \
			a.stop((\cf6 "snd"\cf0 ++((key).asString)).asSymbol, properties[key][4]);\
			a.play((\cf6 "snd"\cf0 ++((key).asString++\cf6 "x1"\cf0 )).asSymbol, \cf4 //release sound\cf0 \
				amp: properties[key][0],\
				loop: 0,\
				out: output\
			);\
			\{ keyButs[key].value= 0; \}.defer;\
		\}\
		\{properties[key][2] == 4\} \{ \cf4 //2 samples - noteon/noteoff\cf0 \
			if(properties[key][8] == 0, \{ \cf4 //shot\cf0 \
				a.stop((\cf6 "snd"\cf0 ++((key).asString)).asSymbol, properties[key][4]);\
			\});\
			a.play((\cf6 "snd"\cf0 ++((key).asString++\cf6 "x0"\cf0 )).asSymbol, \cf4 //release sound\cf0 \
				amp: properties[key][0],\
				loop: 0,\
				out: output\
			);\
			\{ keyButs[key].value= 0; \}.defer;\
		\}\
		\{properties[key][2] == 5\} \{ \cf4 //many samples\cf0 \
			if(properties[key][8] == 0, \{ \cf4 // ---- if its not shot:\cf0 \
				if(properties[key][6] == 0, \{ \cf4 //sequence\cf0 \
					\cf4 //a.stop(("snd"++((key).asString++"x"++(properties[key][7].asString))).asSymbol, properties[key][4]);\cf0 \
					timer[key] = \cf8 Date\cf0 .getDate.bootSeconds.round(1);\
					a.stop((\cf6 "snd"\cf0 ++((key).asString++\cf6 "x"\cf0 ++(((properties[key][7]-1).wrap(0, (soundsASR[key].size-1))).asString))).asSymbol, properties[key][4]);\
				\{ keyButs[key].states= ([[soundsASR[key][properties[key][7]].basename.removeExtension, textcolors[key.wrap(0, 12);], colors[key.wrap(0, 12);]], [soundsASR[key][properties[key][7]].basename.removeExtension, \cf8 Color\cf0 .black, colorsOn[key.wrap(0, 12)]] ]) \}.defer;\
				\});\
				if(properties[key][6] == 1, \{ \cf4 //random\cf0 \
				a.stop(properties[key][7], properties[key][4]);\
				\});\
				if(properties[key][6] == 2, \{ \cf4 //sequence\cf0 \
					\cf4 //a.stop(("snd"++((key).asString++"x"++(properties[key][7].asString))).asSymbol, properties[key][4]);\cf0 \
					\cf4 //timer[key] = Date.getDate.bootSeconds.round(1);\cf0 \
					a.stop((\cf6 "snd"\cf0 ++((key).asString++\cf6 "x"\cf0 ++(((properties[key][7]-1).wrap(0, (soundsASR[key].size-1))).asString))).asSymbol, properties[key][4]);\
				\{ keyButs[key].states= ([[soundsASR[key][properties[key][7]].basename.removeExtension, textcolors[key.wrap(0, 12);], colors[key.wrap(0, 12);]], [soundsASR[key][properties[key][7]].basename.removeExtension, \cf8 Color\cf0 .black, colorsOn[key.wrap(0, 12)]] ]) \}.defer;\
				\});\
			\},\{ \cf4 // ------------------------------ if its not shot:\cf0 \
			if(properties[key][6] == 0, \{ \cf4 //sequence\cf0 \
					\cf4 //a.stop(("snd"++((key).asString++"x"++(properties[key][7].asString))).asSymbol, properties[key][4]);\cf0 \
					timer[key] = \cf8 Date\cf0 .getDate.bootSeconds.round(1);\
					\cf4 //a.stop(("snd"++((key).asString++"x"++(((properties[key][7]-1).wrap(0, (soundsASR[key].size-1))).asString))).asSymbol, properties[key][4]);\cf0 \
				\{ keyButs[key].states= ([[soundsASR[key][properties[key][7]].basename.removeExtension, textcolors[key.wrap(0, 11);], colors[key.wrap(0, 11);]], [soundsASR[key][properties[key][7]].basename.removeExtension, \cf8 Color\cf0 .black, colorsOn[key.wrap(0, 11)]] ]) \}.defer;\
				\});\
			if(properties[key][6] == 2, \{ \cf4 //sequence\cf0 \
					\cf4 //a.stop(("snd"++((key).asString++"x"++(properties[key][7].asString))).asSymbol, properties[key][4]);\cf0 \
					\cf4 //timer[key] = Date.getDate.bootSeconds.round(1);\cf0 \
					\cf4 //a.stop(("snd"++((key).asString++"x"++(((properties[key][7]-1).wrap(0, (soundsASR[key].size-1))).asString))).asSymbol, properties[key][4]);\cf0 \
				\{ keyButs[key].states= ([[soundsASR[key][properties[key][7]].basename.removeExtension, textcolors[key.wrap(0, 11);], colors[key.wrap(0, 11);]], [soundsASR[key][properties[key][7]].basename.removeExtension, \cf8 Color\cf0 .black, colorsOn[key.wrap(0, 11)]] ]) \}.defer;\
				\});\
	\
			\});\
\
			\
			\{ keyButs[key].value= 0; \}.defer;\
		\}\
		\{properties[key][2] == 6\} \cf4 //ARPEGGIO\cf0 \
		\{\
			if(properties[key][12][2]==0,\
			\{\
			arpRoutines[key].stop;\
			a.stop((\cf6 "snd"\cf0 ++((key).asString)).asSymbol, properties[key][4]);\
			\{ keyButs[key].value= 0; \}.defer;\
			\});\
			\
			\
		\};\
\
		if(forcestop.isNil.not, \{ \
			a.stop((\cf6 "snd"\cf0 ++((key).asString)).asSymbol, properties[key][4]); \
			\{ keyButs[key].value= 0; \}.defer;\
			if (progressState == 1, \{\
					progress[key].stop; \
					progressViewClear.value(key) \
			\});\
			\cf4 //"hva skjer a?".postln;\cf0 \
		\});	\
	\},\{\
		\{ keyButs[key].value= 0; \}.defer; \});\
		\
	\cf4 //SEND MIDI SYSEX\cf0 \
	\cf4 //if( properties[key][11].isNilNot, \{ midiOut.control(1, properties[key][11][0], 0) \});\cf0 \
	if(masterprop[\cf9 \\midi\cf0 ] == 1, \{\
		if(properties[key][11][0] == 1, \{\
			if(midiOut.isNil.not, \{\
				if( properties[key][11][2].isNil.not, \{ \
					\cf4 //midiOut.control(1, properties[key][11][0], properties[key][11][0]) ;\cf0 \
					\cf4 //p.send($w, $a, 0, 55)\cf0 \
					\cf4 //("sending midi on note OFF"+properties[key][11][2]).postln;\cf0 \
					\cf4 //midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][2][0], 0x00, properties[key][11][2][1], 0x00, 0xf7]);\cf0 \
				case \
				\{properties[key][11][3] == 0\} \{	\cf4 // ------ stop single value ------\cf0 \
					case\
					\{properties[key][11][5] == 0\} \{ \cf4 // submaster\cf0 \
						\cf4 //midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][2][0], 0x00, properties[key][11][2][1], 0x00, 0xf7]);\cf0 \
						midiOut.sysex(\cf8 ETCEonSysex\cf0 .submaster(1, properties[key][11][2][0], properties[key][11][2][1]));\
					\}\
					\{properties[key][11][5] == 1\} \{ \cf4 // macro\cf0 \
					\cf3 nil\cf0 \
					\}\
					\{properties[key][11][5] == 2\} \{ \cf4 // go cue\cf0 \
					\cf3 nil\cf0 \
					\}\
					\{properties[key][11][5] == 3\} \{ \cf4 // grandmaster\cf0 \
					\cf4 //midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, 0x7e, 0x03, properties[key][11][2][1], 0x00, 0xf7]);\cf0 \
					midiOut.sysex(\cf8 ETCEonSysex\cf0 .grandmaster(1, properties[key][11][2][1]));\
					\};\
				\}\
				\{properties[key][11][3] == 1\} \{	\cf4 // ------ stop onset detection ------\cf0 \
					case\
					\{properties[key][11][5] == 0\} \{ \cf4 // submaster\cf0 \
						coyoteMidiResponders[key].remove;\
						\cf4 //midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][2][0], 0x00, properties[key][11][2][1], 0x00, 0xf7]);\cf0 \
						midiOut.sysex(\cf8 ETCEonSysex\cf0 .submaster(1, properties[key][11][2][0], properties[key][11][2][1]));\
					\}\
					\{properties[key][11][5] == 1\} \{ \cf4 // macro\cf0 \
					coyoteMidiResponders[key].remove;\
					\}\
					\{properties[key][11][5] == 3\} \{ \cf4 // grandmaster\cf0 \
					coyoteMidiResponders[key].remove;\
					\cf4 //midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, 0x7e, 0x03, properties[key][11][2][1], 0x00, 0xf7]);\cf0 \
					midiOut.sysex(\cf8 ETCEonSysex\cf0 .grandmaster(1, properties[key][11][2][1]));\
					\};\
				\}\
				\
				\{properties[key][11][3] == 2\} \{	\cf4 // ------ stop sequence ------\cf0 \
					midiRoutines[key].stop;\
					\cf4 //midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][2][0], 0x00, properties[key][11][2][1], 0x00, 0xf7]);\cf0 \
					case\
					\{properties[key][11][5] == 0\} \{ \cf4 // submaster\cf0 \
						midiOut.sysex(\cf8 ETCEonSysex\cf0 .submaster(1, properties[key][11][2][0], properties[key][11][2][1])); \}\
					\{properties[key][11][5] == 3\} \{ \cf4 // grandmaster\cf0 \
					midiOut.sysex(\cf8 ETCEonSysex\cf0 .grandmaster(1, properties[key][11][2][1]));\
					\};\
				\};\
\
				\});			\
			\});\
		\});\
	\});\
	\cf4 //SEND OSC\cf0 \
	if(masterprop[\cf9 \\osc\cf0 ] == 1, \{\
		if( properties[key][15][0] == 1, \{\
			properties[key][15][1].keysValuesDo(\{\cf2 |robot, value|\cf0 \
				if( value[1] == 2, \{\
					if (properties[key][1]==1, \{ if(oscLoopResponders[key].isNil.not, \{\
						oscLoopResponders[key].remove; oscLoopResponders[key]= \cf3 nil\cf0 ; \
						\});\
					\});\
					oscRoutines[key].last.stop; oscRoutines[key].last.close; oscRoutines[key].pop;\
					\cf4 //("note on osc resp"+oscRoutines[key]).postln;\cf0 \
					\});\
				if (value[1] == 1, \{ coyoteResponders[key].remove; coyoteRespondersPrevious[key]= \cf3 nil\cf0 ; \});\
				if(value[1] == 3, \{\cf3 nil\cf0 \}, \{ \cf4 // no note off\cf0 \
				if (\cf5 ~recOSC\cf0 , \{ \cf8 NetAddr\cf0 (\cf6 "localhost"\cf0 , \cf8 NetAddr\cf0 .langPort).sendMsg(\cf5 ~ipDict\cf0 [robot][0],\cf5 ~robotDict\cf0 [robot][0]++value[0][1]); \});\
				\cf8 NetAddr\cf0 (\cf5 ~ipDict\cf0 [robot][0], \cf5 ~ipDict\cf0 [robot][1]).sendMsg(\cf5 ~robotDict\cf0 [robot][0]++value[0][1]);\
				\});\
				\cf4 //("Note off OSC:"+[robot, ~robotDict[robot][0], value[0][1]]).postln;\cf0 \
				 \cf4 //a NetAddr .send(properties[key][15][1], properties[key][15][2][0]);\cf0 \
			\});\
			\cf4 //coyoteResponders.postln;\cf0 \
		\});\
	\});\
	\cf4 //SEND DMX\cf0 \
	if(masterprop[\cf9 \\dmx\cf0 ] == 1, \{\
		if( \cf5 ~dmx\cf0 .isNil.not, \{\
			if( properties[key][16][0] == 1, \{ \
				\cf4 //~dmx.fade(properties[key][16][1][1], 0.5, 'linear', 0.1)\cf0 \
				properties[key][16][1][1].data.keysValuesDo(\{\cf2 |chan, val|\cf0 \
					(\cf6 "chan:"\cf0 +chan+\cf6 "val:"\cf0 +val).postln;\
					\cf8 NetAddr\cf0 (\cf6 "127.0.0.1"\cf0 , 6666).sendMsg(\cf6 "dmx"\cf0 , chan, val*100);\
				\});		\});\
		\});\
	\});\
\};\
\
\
\
\
\
	backup= \{\cf2 |file|\cf0 \
		\cf2 var\cf0  filename, backupname, backupdir, dir;\
		file= file.basename;\
		dir= filesDir;\
		backupdir= dir++\cf6 "backup/"\cf0 ;\
		\
		if (\cf8 File\cf0 .exists(dir++file)) \{\
			if(backupdir.isFolder.not, \{backupdir.makeDir\});\
			\
			backupname = file ++ \cf6 ".backup_"\cf0  ++ \cf8 Date\cf0 .getDate.stamp;\
			\
			(dir++file).moveTo(dir++\cf6 "backup/"\cf0 , backupname)\
\
		\};\
		\
	\};\
\
\
\cf4 // =============================================================================================\cf0 \
\cf4 // ================================= GUI - LOAD / SAVE =========================================\cf0 \
\cf4 // =============================================================================================\cf0 \
\
\
w= \cf8 Window\cf0 .new(keyboardName, \cf8 Rect\cf0 (0, 0, 610, 935));\
w.view.background_(backgroundColor);\
\
\cf4 /*\
Button.new(w, Rect(20, 20, 50, 20))\
.states_([["on", Color.black, Color.grey], ["on", Color.black, Color.green]])\
.value_(1)\
.action_(\{ | v |\
	if (v.value == 1, \
	\{on.play; off.play\}, \
	\{on.stop; off.stop\});	\
\});\
*/\cf0 \
\
\cf8 Button\cf0 .new(w, \cf8 Rect\cf0 (20, 20, 60, 20))\
.states_([[\cf6 "setup"\cf0 , \cf8 Color\cf0 .white, \cf8 Color\cf0 .black]])\
.canFocus_(\cf3 false\cf0 )\
.action_(\{ \cf2 | v |\cf0 \
	if(\cf5 ~preferencesWindows\cf0 [keyboardName.asSymbol] == \cf3 false\cf0 , \{\
		preferencesView.value();\
		\cf5 ~preferencesWindows\cf0 .put(keyboardName.asSymbol, \cf3 true\cf0 );\
	\});\
\});\
\
\
title= \cf8 StaticText\cf0 (w, \cf8 Rect\cf0 (80, 20, 120, 20))\
.background_(\cf8 Color\cf0 .grey.alpha_(0.3));\
\
\cf8 Button\cf0 (w, \cf8 Rect\cf0 (260, 50, 30, 20))\
.states_([[\cf6 "S"\cf0 ]])\
.canFocus_(\cf3 false\cf0 )\
.action_(\{\
\cf4 //save preset\cf0 \
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf2 var\cf0  w, t, saveBut;\
	w= \cf8 Window\cf0 (\cf6 "save"\cf0 , \cf8 Rect\cf0 (400, 400, 300, 100))\
	.alwaysOnTop_(\cf3 true\cf0 );\
\
	t= \cf8 TextView\cf0 (w, \cf8 Rect\cf0 (10, 10, 280, 20))\
	.focus(\cf3 true\cf0 )\
	.keyDownAction_(\{\cf2 |view, char, mod, uni, key|\cf0 \
		if(key == 36, \{ saveBut.valueAction= 1 \});\
	\});\
\
	saveBut= \cf8 Button\cf0 (w, \cf8 Rect\cf0 (10, 40, 100, 40))\
	.states_([[\cf6 "save"\cf0 ]])\
	.action_(\{\
		\cf2 var\cf0  values, path, stringSize;\
		stringSize= t.string.size;\
		if (stringSize > 0, \{\
			\
			path= filesDir++(t.string);\
			backup.value(path);\
			knobSounds= allKnobs.collect(\{ \cf2 |it, i|\cf0 \
				\{it.getValues\}.try;\
			\});\
			\
			sliderSounds= sliders.collect(\{ \cf2 |it, i|\cf0 \
				\{it.getValues\}.try;\
			\});\
\
			values= [sounds, properties, knobSounds, sliderSounds, soundsASR, masterprop];\
			values.writeArchive(path);\
			currentPresetPath= path;\
			dirbutton.doAction;\
			title.string= path.basename;\
			title.align= \cf9 \\center\cf0 ;\
			reloadSavefiles.value;\
			w.close;\
		\});\
\
		\
	\});\
	\
	\cf8 Button\cf0 (w, \cf8 Rect\cf0 (120, 40, 100, 40))\
	.states_([[\cf6 "cancel"\cf0 ]])\
	.action_(\{\
		w.close;\
	\});\
\
	w.front;\
\
\});\
\
\
\
reloadSavefiles= \{\
	files= (filesDir++\cf6 "*"\cf0 ).standardizePath.pathMatch;\
	savefiles= files.addFirst(\cf6 "none"\cf0 );\
	files= files.addFirst(\cf6 "none"\cf0 );\
	savefiles= savefiles.collect(\{\cf2 |it|\cf0  it.basename\});\
	loadmenu.items= ( savefiles );\
\};\
\
\
files= (filesDir++\cf6 "*"\cf0 ).standardizePath.pathMatch;\
savefiles= files.addFirst(\cf6 "none"\cf0 );\
files= files.addFirst(\cf6 "none"\cf0 );\
savefiles= savefiles.collect(\{\cf2 |it|\cf0  it.basename\});\
\
loadmenu= \cf8 PopUpMenu\cf0 (w, \cf8 Rect\cf0 (80, 50, 120, 30))\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf4 //.canFocus_(false)\cf0 \
.stringColor_(\cf8 Color\cf0 .green)\
.background_(\cf8 Color\cf0 .grey.alpha_(0.5))\
.items_( savefiles )\
.keyDownAction_(\{\cf2 |view, char|\cf0 \
	if(char==$\\r, \{\
		\cf4 //"return".postln; \cf0 \
		\cf4 //m.focus(false);\cf0 \
		\{loadPresetBut.mouseDownAction.value(\cf3 nil\cf0 , 0, 0, 0, 0, 1)\}.defer;\
		\});\
	\
	 \})\
.action_(\{ \cf2 |v|\cf0 \
	menuitem= v.items.at(v.value);\
	\cf4 //menuitem.postln;\cf0 \
	\cf4 //files[loadmenu.value].postln;\cf0 \
	\cf4 //("menu size:"+loadmenu.items.size).postln;\cf0 \
	\cf4 //("files size:"+files.size).postln;\cf0 \
	\cf4 //("loadmenu fileS:"+loadmenu.items).postcs;\cf0 \
	\cf4 //("files fileS:"+files).postcs;\cf0 \
\});\
menuitem= \cf6 "none"\cf0 ;\
\
\cf8 StaticText\cf0 (w, \cf8 Rect\cf0 (20, 50, 60, 15))\
.string_(\cf6 "Presets:"\cf0 )\
.background_(\cf8 Color\cf0 .grey.alpha_(0.5))\
.align_(\cf9 \\center\cf0 );\
\cf4 //.font_(Font("Monaco", 9));\cf0 \
\
dirbutton= \cf8 Button\cf0 (w, \cf8 Rect\cf0 (20, 65, 60, 15))\
.canFocus_(\cf3 false\cf0 )\
.states_([[\cf6 "saves"\cf0 ], [\cf6 "backup"\cf0 ] ])\
.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 , 9))\
.action_(\{ \cf2 |v|\cf0 \
	\cf2 var\cf0  directory;\
	if (v.value == 1, \{\
		directory= filesDir++\cf6 "backup/"\cf0 ; \
		\},\{\
		directory= filesDir;\
	\});\
	files= (directory++\cf6 "*"\cf0 ).standardizePath.pathMatch;\
	savefiles= files.addFirst(\cf6 "none"\cf0 );\
	files= files.addFirst(\cf6 "none"\cf0 );\
	savefiles= savefiles.collect(\{\cf2 |it|\cf0  it.basename\});\
	loadmenu.items= savefiles;\
\});\
\
wrefresh= \{ \{2.wait; \{w.refresh\}.defer \}.fork \};\
\
loadPresetBut= \cf8 Button\cf0 (w, \cf8 Rect\cf0 (200, 50, 30, 20))\
.canFocus_(\cf3 false\cf0 )\
.states_([[\cf6 "L"\cf0 , \cf8 Color\cf0 .red, \cf8 Color\cf0 .black]])\
.mouseDownAction_(\{ \cf2 |view, x, y, mod|\cf0 \
	if( mod.isAlt, \{\
			if (dirbutton.value == 0, \{\
				currentPresetPath= filesDir++loadmenu.item;\
			\},\{\
				currentPresetPath= filesDir++\cf6 "backup/"\cf0 ++loadmenu.item;\
\
			\});\
			currentPresetPath.removeFile;\
			reloadSavefiles.value;\
			title.string= \cf6 "none"\cf0 ;\
			title.align= \cf9 \\center\cf0 ;\
			\
	\},\{\
\
		\cf2 var\cf0  values, file, oldPropSize, shaveCheck;\
		if (menuitem == \cf6 "none"\cf0  or: \{menuitem == \cf6 "backup"\cf0 \}, \{\cf3 nil\cf0 \}, \{\
		a.free;\
		\cf4 //t.view.remove;\cf0 \
		c.remove;\
		\cf4 //("loading"+files[loadmenu.value]).postln;\cf0 \
		\cf4 //values= Object.readArchive(files[loadmenu.value]);\cf0 \
		if (dirbutton.value == 0, \{\
			currentPresetPath= filesDir++loadmenu.item;\
			(\cf6 "loading"\cf0 +(filesDir++loadmenu.item)).postln;\
			values= \cf8 Object\cf0 .readArchive((filesDir++loadmenu.item));\
		\},\{\
			currentPresetPath= filesDir++\cf6 "backup/"\cf0 ++loadmenu.item;\
			(\cf6 "loading"\cf0 +(filesDir++\cf6 "backup/"\cf0 ++loadmenu.item)).postln;\
			values= \cf8 Object\cf0 .readArchive((filesDir++\cf6 "backup/"\cf0 ++loadmenu.item));\
		\});\
		\cf4 //values.postcs;\cf0 \
		sounds= values[0];\
		properties= values[1];\
		if(values[4].isNil.not, \{soundsASR= values[4]\},\{\
			soundsASR= ([]!numKeys).asList;\
		\});\
		if (values[5].isNil.not, \{masterprop= values[5].deepCopy\});\
		updatePreferenceButtons.value;\
		\cf4 //free all previous buffers\cf0 \
		\cf4 //load new buffers\cf0 \
		numKeys.do(\{ \cf2 |i|\cf0 \
			\cf2 var\cf0  check;\
			check= sounds[i];\
			if (check.isNil.not, \{\
				if (\cf8 File\cf0 .exists(sounds[i]), \{\
			file= sounds[i].basename.replace(\cf6 ".wav"\cf0 , \cf6 ""\cf0 );\
			a.prepareForPlay((\cf6 "snd"\cf0 ++i.asString).asSymbol, sounds[i]);\
			soundsASR[i].size.do(\{ \cf2 |it, ii|\cf0 \
				if(soundsASR[i][ii].isNil.not, \{\
					a.prepareForPlay((\cf6 "snd"\cf0 ++i.asString++\cf6 "x"\cf0 ++(ii.asString)).asSymbol, soundsASR[i][ii]); (\cf6 "asr"\cf0 +ii).postln;\
				\});\
			\});\
			\{keyButs[i].states= ([[file, textcolors[i.wrap(0, 11)], colors[i.wrap(0, 11)]], [file, \cf8 Color\cf0 .black, colorsOn[i.wrap(0, 11)]] ]);\}.defer;\
				\},\{\
					(\cf6 "warning"\cf0 +sounds[i]+\cf6 "does not exist"\cf0 ).postln;\
					sounds[i]= \cf3 nil\cf0 ; \
					\{keyButs[i].states= ([[\cf6 ""\cf0 , textcolors[i.wrap(0, 11)], colors[i.wrap(0, 11)]], [\cf6 ""\cf0 , textcolors[i.wrap(0, 11)], colorsOn[i.wrap(0, 11)]]]);\}.defer;\
					\});\
				\}, \{\
			\{keyButs[i].states= ([[\cf6 ""\cf0 , textcolors[i.wrap(0, 11)], colors[i.wrap(0, 11)]], [\cf6 ""\cf0 , textcolors[i.wrap(0, 11)], colorsOn[i.wrap(0, 11)]]]);\}.defer;\
			\});\
		\});\
		allKnobs.do(\{ \cf2 |it, i|\cf0 \
			\{it.setValues(values[2][i])\}.try\
		\});\
		sliders.do(\{ \cf2 |it, i|\cf0 \
			\{it.setValues(values[3][i])\}.try\
		\});\
\
		\
		title.string= menuitem;\
		title.align= \cf9 \\center\cf0 ;\
\
		wrefresh.value;\
		\
		\cf4 // shave buggy values from previous samplers... ugh!\cf0 \
		shaveCheck= properties.collect(\{\cf2 |it|\cf0 \
			it.size;\
		\});\
		if( shaveCheck.sort.first != shaveCheck.sort.last, \{\
			if( shaveCheck.sort.last > 11, \{\
				properties.do(\{\cf2 |it|\cf0 \
					while(\
						\{it.size > 11\}, \{ it.pop; \}); \cf4 // 11\cf0 \
				\});\
			\});	\
		\});\
		\
		\
		\cf4 //backwards compability\cf0 \
		if (properties[0].size < defaultProperties.size, \{\
			\cf4 //("old properties:"+properties).postln;\cf0 \
			properties= properties.asList;\
			oldPropSize= properties[0].size.deepCopy-1;\
			defaultProperties.do(\{ \cf2 |it, i|\cf0 \
				\cf4 //("old props"+properties[i]).postln;\cf0 \
				\cf4 //("---->"+i).postln;\cf0 \
				\cf4 //var oldPropSize= properties[i].size.deepCopy-1;\cf0 \
				it.do(\{ \cf2 |itt, ii|\cf0 \
					\cf4 //ii.postln;\cf0 \
					if (ii > oldPropSize,\
					\cf4 //if (properties[i][ii].isNil,\cf0 \
						\{ properties[i]= properties[i].add(it[ii]); \});\
				\});\
				\cf4 //properties[i].postln;\cf0 \
			\});\
			\cf4 //("new properties:"+properties).postln;\cf0 \
		\});\
		\
		\cf4 /*\
		if(properties[0][2].isNil, \{\
			properties= properties.asList;\
			"everything backwards1!!".postln;\
			properties.do(\{|it, i|\
				properties[i]= properties[i].add(0); //adding playback mode\
				properties[i]= properties[i].add(0.01); //adding attack\
				properties[i]= properties[i].add(0.2); //adding release\
				properties[i]= properties[i].add(0); //adding killer\
				properties[i]= properties[i].add(0); //adding \
				properties[i]= properties[i].add(3); //adding \
				properties[i]= properties[i].add(0); //adding \
			\});\
		\});\
		if(properties[0][6].isNil, \{\
			properties= properties.asList;\
			"everything backwards1!!".postln;\
			properties.do(\{|it, i|\
				properties[i]= properties[i].add(0); //adding \
				properties[i]= properties[i].add(3); //adding \
				properties[i]= properties[i].add(0); //adding\
			\});\
		\});\
		*/\cf0 \
		properties[0].postln;\
		\});\
		\{w.refresh\}.defer;\
		sliders[0].title.postln;\
	\});\
\});\
\
\
\cf8 Button\cf0 (w, \cf8 Rect\cf0 (230, 50, 30, 20))\
.canFocus_(\cf3 false\cf0 )\
.states_([[\cf6 "qs"\cf0 , \cf8 Color\cf0 .white, \cf8 Color\cf0 .grey]])\
.action_(\{ \cf2 |v|\cf0 \
		\cf2 var\cf0  values, path;\
		path= currentPresetPath;\
		backup.value(path);\
		knobSounds= allKnobs.collect(\{ \cf2 |it, i|\cf0 \
			\{it.getValues\}.try;\
		\});\
		sliderSounds= sliders.collect(\{ \cf2 |it, i|\cf0 \
			\{it.getValues\}.try;\
		\});\
		values= [sounds, properties, knobSounds, sliderSounds, soundsASR, masterprop];\
		values.writeArchive(path);\
\});\
\
\cf4 // =============================================================================================\cf0 \
\cf4 // ================================= GUI - PREFERENCE BUTTONS ==================================\cf0 \
\cf4 // =============================================================================================\cf0 \
\
\
\cf8 Button\cf0 (w, \cf8 Rect\cf0 (410,300, 30, 30))\
.states_([[\cf6 "x"\cf0 , \cf8 Color\cf0 .green], [\cf6 "x"\cf0 , \cf8 Color\cf0 .black]])\
.action_(\{\cf2 |v|\cf0 \
	if(seqIsOpen, \{ \cf3 nil\cf0  \}, \{ sequencer.value; seqIsOpen= \cf3 true\cf0  \});\
	\cf4 //if (v.value==1 && panSynth.isNil, \{panSynth= Synth.tail(s, \\PanningHack)\}, \{ panSynth.free; panSynth= nil\})\cf0 \
\});\
\
\cf8 Button\cf0 (w, \cf8 Rect\cf0 (410,350, 50, 30))\
.states_([[\cf6 "remote"\cf0 , \cf8 Color\cf0 .black], [\cf6 "remote"\cf0 , \cf8 Color\cf0 .white]])\
.action_(\{\cf2 |v|\cf0 \
	touchOSC.value;\
\});\
\
panKnob= \cf8 Knob\cf0 (w, \cf8 Rect\cf0 (410, 460, 30, 30))\
.centered_(\cf3 true\cf0 )\
.canFocus_(\cf3 false\cf0 )\
.value_(\cf9 \\pan\cf0 .asSpec.unmap(0))\
.action_(\{ \cf2 |v|\cf0 \
	\cf4 //pan= (\\pan.asSpec.map(v.value));\cf0 \
	\cf4 //if(firstRun.not, \{syn.set(\\pan, \\pan.asSpec.map(v.value))\});\cf0 \
	if (panSynth.isNil.not, \{ \{panSynth.set(\cf9 \\pan\cf0 , \cf9 \\pan\cf0 .asSpec.map(v.value))\}.try \});\
\})\
.color_([\cf8 Color\cf0 .gray, \cf8 Color\cf0 .red, \cf8 Color\cf0 .white, \cf8 Color\cf0 .black])\
.mouseDownAction_(\{\cf2 |view, x, y, mod|\cf0 \
	if (mod == alt, \{view.valueAction= \cf9 \\pan\cf0 .asSpec.unmap(0);\})\
\})\
.canReceiveDragHandler_(\cf3 true\cf0 )\
.receiveDragHandler_(\{\cf2 |view|\cf0 \
	\cf2 var\cf0  drag;\
	drag= \cf8 View\cf0 .currentDrag;\
	if (drag.class == \cf8 UC33LoopChan\cf0 , \{\
		drag.setAction(\{\cf2 |v|\cf0 \{ panKnob.valueAction_(v.value)\}.defer \}, \cf6 "MAIN"\cf0 );\
	\});\
\});\
\
\
outputButton= \cf8 Button\cf0 (w, \cf8 Rect\cf0 (400, 400, 50, 30))\
.states_([[\cf6 "nil"\cf0 , \cf8 Color\cf0 .black, \cf8 Color\cf0 .grey], [\cf6 "1-2"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .black],[\cf6 "3-4"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .black], [\cf6 "5-6"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .black], [\cf6 "7-8"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .black], [\cf6 "9-10"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .black], [\cf6 "11-12"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .black], [\cf6 "13-14"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .black], [\cf6 "15-16"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .black], [\cf6 "17-18"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .black], [\cf6 "19-20"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .black], [\cf6 "21-22"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .black], [\cf6 "23-24"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .black], [\cf6 "25-26"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .black] ])\
.canFocus_(\cf3 false\cf0 )\
.value_(preferences[13])\
.action_(\{ \cf2 |v|\cf0 \
	output= outputs[v.value];\
	sliders.do(\{ \cf2 |it|\cf0  it.defaultout_(outputs[v.value]); it.reloadSampleSoft;\});\
	allKnobs.do(\{ \cf2 |it|\cf0  it.defaultout_(outputs[v.value]); it.reloadSampleSoft; \});\
\});\
\
\cf8 Button\cf0 (w, \cf8 Rect\cf0 (250, 20, 40, 20))\
.canFocus_(\cf3 false\cf0 )\
.states_([[\cf6 "panic"\cf0 , \cf8 Color\cf0 .black, \cf8 Color\cf0 .grey]])\
.action_(\{ \cf2 |v|\cf0 \
	panic.value;\
\});\
\
progressState= masterprop[\cf9 \\prView\cf0 ];\
prViewBut= \cf8 Button\cf0 (w, \cf8 Rect\cf0 (290, 20, 50, 20))\
.canFocus_(\cf3 false\cf0 )\
.states_([[\cf6 "pr view"\cf0 , \cf8 Color\cf0 .white, \cf8 Color\cf0 .grey], [\cf6 "pr view"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .grey]])\
.value_(progressState)\
.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 , 10))\
.action_(\{ \cf2 |v|\cf0 \
	progressState= v.value;\
	sliders.do(\{\cf2 |it|\cf0  it.progress(v.value) \});\
	allKnobs.do(\{\cf2 |it|\cf0  it.progress(v.value) \});\
	masterprop[\cf9 \\prView\cf0 ]= v.value;\
\});\
\
sliderPitch= masterprop[\cf9 \\slPitch\cf0 ];\
slPitchBut= \cf8 Button\cf0 (w, \cf8 Rect\cf0 (340, 20, 40, 20))\
.canFocus_(\cf3 false\cf0 )\
.states_([[\cf6 "SL bnd"\cf0 , \cf8 Color\cf0 .white, \cf8 Color\cf0 .grey], [\cf6 "SL bnd"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .grey]])\
.value_(sliderPitch)\
.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 , 10))\
.action_(\{ \cf2 |v|\cf0 \
	if(v.value == 1, \{ sliderPitch= 1 \}, \{ sliderPitch= 0 \});\
	masterprop[\cf9 \\slPitch\cf0 ]= v.value;\
\});\
\
knobPitch= masterprop[\cf9 \\knPitch\cf0 ];\
knPitchBut= \cf8 Button\cf0 (w, \cf8 Rect\cf0 (380, 20, 40, 20))\
.canFocus_(\cf3 false\cf0 )\
.states_([[\cf6 "KN bnd"\cf0 , \cf8 Color\cf0 .white, \cf8 Color\cf0 .grey], [\cf6 "KN bnd"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .grey]])\
.value_(knobPitch)\
.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 , 10))\
.action_(\{ \cf2 |v|\cf0 \
	if(v.value == 1, \{ knobPitch= 1 \}, \{ knobPitch= 0 \});\
	masterprop[\cf9 \\knPitch\cf0 ]= v.value;\
\});\
\
keyPitch= masterprop[\cf9 \\kyPitch\cf0 ];\
kyPitchBut= \cf8 Button\cf0 (w, \cf8 Rect\cf0 (420, 20, 40, 20))\
.canFocus_(\cf3 false\cf0 )\
.states_([[\cf6 "Ky bnd"\cf0 , \cf8 Color\cf0 .white, \cf8 Color\cf0 .grey], [\cf6 "Ky bnd"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .grey]])\
.value_(keyPitch)\
.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 , 10))\
.action_(\{ \cf2 |v|\cf0 \
	if(v.value == 1, \{ keyPitch= 1 \}, \{ keyPitch= 0 \});\
	masterprop[\cf9 \\kyPitch\cf0 ]= v.value;\
\});\
\
\cf4 /*\
PopUpMenu(w, Rect(300, 50, 30, 20))\
.items_(["1", "2", "3", "4", "5"])\
.value_(masterprop[\\poly])\
.action_(\{ arg menu;\
a.overlaps= (menu.value+1);\
a.overlaps.postln;\
\});\
\
*/\cf0 \
\cf4 /*\
Button(w, Rect(330, 50, 40, 20))\
.states_([["vel off", Color.black, Color.grey], ["vel on", Color.yellow, Color.grey]])\
.value_(masterprop[\\vel])\
.action_(\{ |v|\
	velocitystate= v.value;\
\});\
*/\cf0 \
\
\cf8 Button\cf0 (w, \cf8 Rect\cf0 (290, 50, 40, 20))\
.canFocus_(\cf3 false\cf0 )\
.states_([[\cf6 "KB"\cf0 , \cf8 Color\cf0 .black, \cf8 Color\cf0 .grey], [\cf6 "KB"\cf0 , \cf8 Color\cf0 .black, \cf8 Color\cf0 .green]])\
.action_(\{ \cf2 |v|\cf0 \
	if(v.value == 1, \{\
		w.view.keyDownAction= \{\cf2 |view, char|\cf0 \
			\cf2 var\cf0  keys= [$a, $w, $s, $e, $d, $f, $t, $g, $y, $h, $u, $j, $k, $l];\
				if (char == $x, \{ if (kbTransp+24 <= numKeys, \{kbTransp= kbTransp + 12\}); \});\
				if (char == $z, \{ if (kbTransp-12 >= 0, \{kbTransp= kbTransp - 12\}); \});\
			keys.do(\{\cf2 |it, i|\cf0 \
				if(char == it, \{\
					i = kbTransp + i;\
					if( i< numKeys  and: \{ keyboardPressDown[i] \}, \{\
						(\cf6 "playnote"\cf0 +i).postln;\
						playnote.value(\cf3 nil\cf0 , sounds[i], i, \cf3 nil\cf0 );\
						keyboardPressDown[i]= \cf3 false\cf0 ;\
					\});\
				\});\
			\});\
			\};\
		w.view.keyUpAction= \{\cf2 |view, char|\cf0 \
			\cf2 var\cf0  keys= [$a, $w, $s, $e, $d, $f, $t, $g, $y, $h, $u, $j, $k, $l];\
			keys.do(\{\cf2 |it, i|\cf0 \
				if(char == it, \{\
					i= kbTransp + i;\
					if (i< numKeys, \{\
						(\cf6 "stopnote"\cf0 +i).postln;\
						stopnote.value(sounds[i], i);\
						keyboardPressDown[i]= \cf3 true\cf0 ;\
					\});\
				\});\
			\});\
		\};			\
	\}, \{\
		w.view.keyDownAction= \{\cf2 |view, char|\cf0 \
				if (char == $r, \{ record.value; \});\
				if (char == $i, \{ recordInstantly.value; \});\
			\};\
		w.view.keyUpAction= \{\};\
	\});\
\});\
\
midiBut= \cf8 Button\cf0 (w, \cf8 Rect\cf0 (340, 50, 40, 20))\
.canFocus_(\cf3 false\cf0 )\
.states_([[\cf6 "MIDI"\cf0 , \cf8 Color\cf0 .black, \cf8 Color\cf0 .grey], [\cf6 "MIDI"\cf0 , \cf8 Color\cf0 .black, \cf8 Color\cf0 .green]])\
.value_(masterprop[\cf9 \\midi\cf0 ])\
.action_(\{ \cf2 |v|\cf0 \
	\cf4 // toggle midi\cf0 \
	masterprop[\cf9 \\midi\cf0 ]= v.value;\
\});\
\
oscBut= \cf8 Button\cf0 (w, \cf8 Rect\cf0 (380, 50, 40, 20))\
.canFocus_(\cf3 false\cf0 )\
.states_([[\cf6 "OSC"\cf0 , \cf8 Color\cf0 .black, \cf8 Color\cf0 .grey], [\cf6 "OSC"\cf0 , \cf8 Color\cf0 .black, \cf8 Color\cf0 .green]])\
.value_(masterprop[\cf9 \\osc\cf0 ])\
.action_(\{ \cf2 |v|\cf0 \
	masterprop[\cf9 \\osc\cf0 ]= v.value;\
	\cf4 //touchOSC.value;\cf0 \
\});\
\
dmxBut= \cf8 Button\cf0 (w, \cf8 Rect\cf0 (420, 50, 40, 20))\
.canFocus_(\cf3 false\cf0 )\
.states_([[\cf6 "DMX"\cf0 , \cf8 Color\cf0 .black, \cf8 Color\cf0 .grey], [\cf6 "DMX"\cf0 , \cf8 Color\cf0 .black, \cf8 Color\cf0 .green]])\
.value_(masterprop[\cf9 \\dmx\cf0 ])\
.action_(\{ \cf2 |v|\cf0 \
	\cf4 // toggle dmx\cf0 \
	masterprop[\cf9 \\dmx\cf0 ]= v.value;\
\});\
\
\
\
\cf8 Button\cf0 (w, \cf8 Rect\cf0 (200, 20, 50, 20))\
.canFocus_(\cf3 false\cf0 )\
.states_([[\cf6 "rec"\cf0 , \cf8 Color\cf0 .black, \cf8 Color\cf0 (1.0, 0.2089552238806, 0.25373134328358, 1.0)]])\
.action_(\{ \cf2 |v|\cf0 \
	record.value;\
\});\
\
\
\
w.view.keyDownAction = \{\cf2 |view, char, mod, uni, key|\cf0 \
	\cf4 //[view, char, mod, uni, key].postln;\cf0 \
	if (uni == $r, \{ record.value; \});\
	if (char == $i, \{ recordInstantly.value; \});\
\};\
\
\
record= \
\{\cf2 |instant= false|\cf0 \
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf2 var\cf0  b, d, rec, stop, drag, recbut, sfpath, clockGUI;\
\cf2 var\cf0  recording= \cf3 false\cf0 ;\
\cf2 var\cf0  window = \cf8 Window\cf0 .new(\cf6 "record"\cf0 ,\cf8 Rect\cf0 (465, 636, 306, 200)).front;\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf4 //RoundButton( w, 40@40 ).states_([[ \\record, Color.red, Color.grey ],[ \\stop, Color.black, Color.red ]] );\cf0 \
\
recbut= \cf8 Button\cf0 .new(window,\cf8 Rect\cf0 (20, 10, 260, 20))\
	.states_([ [ \cf6 "rec"\cf0 , \cf8 Color\cf0 .black, \cf8 Color\cf0 .red ], [ \cf6 "stop"\cf0 , \cf8 Color\cf0 .white, \cf8 Color\cf0 .blue] ])\
	.action_\{\cf2 |v|\cf0 \
		case \
		\{v.value == 1\} \{rec.value\}\
		\{v.value == 0\} \{stop.value\};\
		\};\
drag= \cf8 DragSource\cf0 .new(window,\cf8 Rect\cf0 (20, 150, 260, 20))\
	.action_\{\cf2 |v|\cf0  \};\
	\
\cf8 Button\cf0 (window, \cf8 Rect\cf0 (20, 175, 260, 20))\
.states_([[\cf6 "reveal in finder"\cf0 ]])\
.action_(\{ drag.object[0].revealInFinder \});\
\
clockGUI= \cf8 ClockGUI\cf0 .new(window, \cf8 Rect\cf0 (20, 40, 260, 100));\
\
\cf4 // allocate a disk i/o buffer\cf0 \
b= \cf8 Buffer\cf0 .alloc(s, 65536, 2);\
\
\cf8 SynthDef\cf0 (\cf9 \\recordGiga\cf0 , \{\cf2 arg\cf0  bufnum, in;\
	\cf8 DiskOut\cf0 .ar(bufnum, \cf8 In\cf0 .ar(in,2));\
\}).send(s);\
\
\
\
rec= \{ \cf4 // start recording\cf0 \
	\cf4 // create an output file for this buffer, leave it open\cf0 \
	sfpath= ((recordingsPath++keyboardName ++\cf8 Date\cf0 .localtime.stamp++\cf6 ".wav"\cf0 ).standardizePath);\
	b.write(sfpath, \cf6 "wav"\cf0 , \cf6 "int16"\cf0 , 0, 0, \cf3 true\cf0 );\
	\cf8 Routine\cf0 (\{\
		s.sync;\
		d = \cf8 Synth\cf0 .tail(\cf3 nil\cf0 , \cf9 \\recordGiga\cf0 , [\cf9 \\bufnum\cf0 , b, \cf9 \\in\cf0 , output]);\
	\}).play(\cf8 AppClock\cf0 );	\
	clockGUI.reset;\
	clockGUI.play;\
	recording= \cf3 true\cf0 ;\
\};\
\
stop= \{ \cf4 // stop recording\cf0 \
	\cf8 Routine\cf0 (\{\
	d.free; b.close; b.free;\
	s.sync;\
	drag.object= [sfpath];\
	sfpath.postln;\
	sfpath.class.postln;\
	b= \cf8 Buffer\cf0 .alloc(s, 65536, 2);\
	s.sync;\
	clockGUI.pause;\
\}).play(\cf8 AppClock\cf0 );\
recording= \cf3 false\cf0 ;\
\};\
\
recbut.focus(\cf3 true\cf0 );\
\
window.onClose= \{b.close; b.free; if(recording, \{stop.value\}); \}\
\
\};\
\
\
recordInstantly= \
\{\cf2 |midiCCnum= nil|\cf0 \
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf2 var\cf0  b, d, rec, stop, drag, recbut, sfpath, clockGUI, ccResponder;\
\cf2 var\cf0  window; \
\
window = \cf8 Window\cf0 .new(\cf6 "record"\cf0 ,\cf8 Rect\cf0 (465, 336, 306, 180), border: \cf3 false\cf0 )\
.alwaysOnTop_(\cf3 true\cf0 );\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf4 //RoundButton( w, 40@40 ).states_([[ \\record, Color.red, Color.grey ],[ \\stop, Color.black, Color.red ]] );\cf0 \
\
recbut= \cf8 Button\cf0 .new(window,\cf8 Rect\cf0 (20, 10, 260, 20))\
	.states_([ [ \cf6 "rec"\cf0 , \cf8 Color\cf0 .black, \cf8 Color\cf0 .red ], [ \cf6 "stop"\cf0 , \cf8 Color\cf0 .white, \cf8 Color\cf0 .blue] ])\
	.action_\{\cf2 |v|\cf0 \
		case \
		\{v.value == 1\} \{rec.value\}\
		\{v.value == 0\} \{stop.value\};\
		\};\
\
clockGUI= \cf8 ClockGUI\cf0 .new(window, \cf8 Rect\cf0 (20, 40, 260, 100));\
\
\cf4 // allocate a disk i/o buffer\cf0 \
b= \cf8 Buffer\cf0 .alloc(s, 65536, 2);\
\
\cf8 SynthDef\cf0 (\cf9 \\recordGiga\cf0 , \{\cf2 arg\cf0  bufnum, in;\
	\cf8 DiskOut\cf0 .ar(bufnum, \cf8 In\cf0 .ar(in,2));\
\}).send(s);\
\
\
\
rec= \{ \cf4 // start recording\cf0 \
	\cf4 // create an output file for this buffer, leave it open\cf0 \
	sfpath= ((recordingsPath++keyboardName ++\cf8 Date\cf0 .localtime.stamp++\cf6 ".wav"\cf0 ).standardizePath);\
	b.write(sfpath, \cf6 "wav"\cf0 , \cf6 "int16"\cf0 , 0, 0, \cf3 true\cf0 );\
	\cf8 Routine\cf0 (\{\
		s.sync;\
		d = \cf8 Synth\cf0 .tail(\cf3 nil\cf0 , \cf9 \\recordGiga\cf0 , [\cf9 \\bufnum\cf0 , b, \cf9 \\in\cf0 , output]);\
	\}).play(\cf8 AppClock\cf0 );	\
	clockGUI.reset;\
	clockGUI.play;\
\};\
\
stop= \{ \cf4 // stop recording\cf0 \
	\cf8 Routine\cf0 (\{\
	d.free; b.close; b.free;\
	clockGUI.pause;\
	s.sync;\
	\cf4 //stopnote.value(sounds[numKeys-1], numKeys-1, nil);\cf0 \
	loadPreset.value([sfpath], numKeys-1);\
	a.isPlaying((\cf6 "snd"\cf0 ++((numKeys-1).asString)).asSymbol).postln;\
	s.sync;\
	properties[numKeys-1][0]= 1;\
	properties[numKeys-1][1]= 1;\
	properties[numKeys-1][2]= 2;\
	playnote.value(\cf3 nil\cf0 , sounds[numKeys-1], numKeys-1, \cf3 nil\cf0 );\
	window.close;\
\}).play(\cf8 AppClock\cf0 );\
\};\
\
recbut.focus(\cf3 true\cf0 );\
\
if(midiCCnum.isNil.not, \{\
ccResponder = \cf8 CCResponder\cf0 (\{ \cf2 |src,chan,num,value|\cf0 \
	\cf4 //[src,chan,num,value].postln;\cf0 \
	stop.value;\
	\},\
	midisrcindex, \cf4 //  source\cf0 \
	midichannel, \cf4 //  channel\cf0 \
	midiCCnum, \cf4 // CC number\cf0 \
	\cf3 nil\cf0  \cf4 // any value\cf0 \
);\
\});\
\
rec.value; \cf4 //START RECORDING STRAIGHT AWAY\cf0 \
\{recbut.value= 1; \}.defer;\
\
window.onClose= \{\
\
	if(c.isNil.not, \{ccResponder.remove;\});\
	\
	\};\
	\
	window.front;\
\
\};\
\
\
updatePreferenceButtons = \{\
	midiBut.value = masterprop[\cf9 \\midi\cf0 ];\
	oscBut.value = masterprop[\cf9 \\osc\cf0 ];\
	dmxBut.value= masterprop[\cf9 \\dmx\cf0 ];\
	slPitchBut.value= masterprop[\cf9 \\slPitch\cf0 ];\
	knPitchBut.value= masterprop[\cf9 \\knPitch\cf0 ];\
	kyPitchBut.value= masterprop[\cf9 \\kyPitch\cf0 ];\
	prViewBut.value= masterprop[\cf9 \\prView\cf0 ];\
	\};\
\
\
\cf4 /*\
GUI.popupMenu.new(w, Rect(20, 80, 100, 30))\
.items_\
\
*/\cf0 \
\
\cf4 // =============================================================================================\cf0 \
\cf4 // ==================================== GUI - KEYBOARD =========================================\cf0 \
\cf4 // =============================================================================================\cf0 \
\
\cf4 //progress view\cf0 \
keyUserViews= numKeys.collect(\{ \cf2 |i|\cf0 \
	\cf2 var\cf0  num, size, amp, env, loop;\
	num= i.wrap(0, 11);\
\
	size= 130*(sizes[num]);\
\
	\cf8 UserView\cf0 (w, \cf8 Rect\cf0 (470, keyHSize*((i-numKeys).abs)-10, size, keyHSize))\
	.canFocus_(\cf3 false\cf0 )\
	.background_(colorsOnUV[num]);\
\});\
\
\cf4 //key prop labels\cf0 \
keyPropLabels= numKeys.collect(\{ \cf2 |i|\cf0 \
	\cf2 var\cf0  view;\
	view= \cf8 UserView\cf0 (w, \cf8 Rect\cf0 (460, keyHSize*((i-numKeys).abs)-10, 10, 20))\
	.background_(\cf8 Color\cf0 .grey.alpha_(0.5))\
	.canFocus_(\cf3 false\cf0 );\
	\
	view.drawFunc = \{\
		\cf4 //routing\cf0 \
		if(properties[i][10].isNil.not, \{\
			\cf4 // set the Color\cf0 \
			\cf8 Pen\cf0 .color = \cf8 Color\cf0 .yellow;\
		\}, \{\
			\cf8 Pen\cf0 .color = \cf8 Color\cf0 .yellow.alpha_(0.0);\
		\});\
		\cf8 Pen\cf0 .addRect(\cf8 Rect\cf0 (6, 0, 3, 20));\
		\cf8 Pen\cf0 .perform(\cf9 \\fill\cf0 );\
		\cf4 //toggle\cf0 \
		if(properties[i][2] == 2, \{\
			\cf4 // set the Color\cf0 \
			\cf8 Pen\cf0 .color = \cf8 Color\cf0 .green;\
		\}, \{\
			\cf8 Pen\cf0 .color = \cf8 Color\cf0 .green.alpha_(0.0);\
		\});\
		\cf8 Pen\cf0 .addRect(\cf8 Rect\cf0 (0, 0, 3, 20));\
		\cf8 Pen\cf0 .perform(\cf9 \\fill\cf0 );\
	\};\
\});\
\
\cf4 //keys\cf0 \
keyButs= numKeys.collect(\{ \cf2 |i|\cf0 \
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf2 var\cf0  num, size, amp, env, loop;\
num= i.wrap(0, 11);\
\
size= 130*(sizes[num]);\
\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf8 Button\cf0 (w, \cf8 Rect\cf0 (470, keyHSize*((i-numKeys).abs)-10, size, keyHSize))\
.font_(\cf8 GUI\cf0 .font.new(\cf6 "Monaco"\cf0 , 9))\
.canFocus_(\cf3 false\cf0 )\
.states_([[\cf6 ""\cf0 , textcolors[num], colors[num]], [\cf6 ""\cf0 , \cf8 Color\cf0 .black, colorsOn[i.wrap(0, 11)]] ])\
.mouseDownAction_(\{ \cf2 |view, x, y, mod|\cf0 \
\
	if ( mod.isShift, \{\
		\cf8 CocoaDialog\cf0 .getPaths(\{ \cf2 arg\cf0  paths; \cf4 //load sound\cf0 \
		loadPreset.value(paths, i);\
		\},\{\
			\cf6 "cancelled"\cf0 .postln;\
		\});\
	\});\
	if ( mod.isAlt, \{ \cf2 |v|\cf0 \
		\{a.freeKey((\cf6 "snd"\cf0 ++(i).asString).asSymbol);\}.try;\
		soundsASR[i].do(\{\cf2 |it, iii|\cf0 \
			if (it[iii].isNil.not, \{\
			\{a.freeKey((\cf6 "snd"\cf0 ++(i).asString++\cf6 "x"\cf0 ++(iii.asString)).asSymbol);\}.try;\
			\});\
		\});\
		soundsASR[i]= \cf3 nil\cf0 ;\
		sounds[i]= \cf3 nil\cf0 ;\
		properties[i]= defaultProperties[0].deepCopy;\
		\{keyButs[i].states= ([[\cf6 ""\cf0 , textcolors[i.wrap(0, 11)], colors[i.wrap(0, 11)]], [\cf6 ""\cf0 , textcolors[i.wrap(0, 11)], colorsOn[i.wrap(0, 11)]]]);\}.defer;\
\});\
	\
\})\
.beginDragAction_(\{ [sounds[i]] \})\
.canReceiveDragHandler_(\cf3 true\cf0 )\
.receiveDragHandler_(\{\cf2 |view, x, y|\cf0 \
	\cf2 var\cf0  values, paths;\
	[view, x, y].postln;\
	paths= \cf8 View\cf0 .currentDrag;\
	\cf4 //paths.postln;\cf0 \
	if (paths.class == \cf8 UC33LoopChan\cf0 , \{\
		paths.setAction(\{\cf2 |v|\cf0 \
			properties[i][9]= \cf9 \\pan\cf0 .asSpec.map(v.value);\
			if (a.isPlaying((\cf6 "snd"\cf0 ++((i).asString)).asSymbol), \{\
				a.set((\cf6 "snd"\cf0 ++((i).asString)).asSymbol).pan_(\cf9 \\pan\cf0 .asSpec.map(v.value)) \});\
			\}\
			, noteArray[i]);\
		\},\{\
		if(paths.isString, \{paths= [paths];\}); \cf4 // qt compatibility..\cf0 \
		loadPreset.value(paths, i);\
	\});\
\})\
.action_(\{ \cf2 |v|\cf0 \
	c.remove;\
	propView.value(i);\
	if(sendWinOpen.isNil.not, \{ \{sendWinOpen.close; 0.5.wait; sendWindow.value(i);\}.fork(\cf8 AppClock\cf0 ) \});\
	\{v.value= 0\}.defer;\
	w.refresh;\
\});\
\});\
\
loadPreset= \{\cf2 |paths, i|\cf0 \
	\cf2 var\cf0  folderName, fileName, num, midifile;\
	num= i.wrap(0, 11);\
	if (paths[0].isFolder, \cf4 //if file is a folder, load all on one key\cf0 \
			\{\
				folderName= paths[0].basename; \
				paths= (paths[0]++\cf6 "/"\cf0 ++\cf6 "*"\cf0 ); \
				paths= paths.pathMatch;\
				paths= paths.reduceToSoundFiles;\
				\{a.freeKey((\cf6 "snd"\cf0 ++(i).asString).asSymbol);\}.try;\
				soundsASR[i].do(\{\cf2 |it, iii|\cf0 \
					\{a.freeKey((\cf6 "snd"\cf0 ++(i).asString++\cf6 "x"\cf0 ++(iii.asString)).asSymbol);\}.try;\
				\});\
				soundsASR[i]= paths;\
				\cf4 //path.postln;\cf0 \
				sounds[i]= paths[0];\
				a.prepareForPlay((\cf6 "snd"\cf0 ++(i).asString).asSymbol, sounds[(i)]);\
		\
				soundsASR[i].size.do(\{ \cf2 |it, iii|\cf0 \
					if(soundsASR[i][iii].isNil.not, \{\
						a.prepareForPlay((\cf6 "snd"\cf0 ++i.asString++\cf6 "x"\cf0 ++(iii.asString)).asSymbol, soundsASR[i][iii]);\
					\});\
				\});\
				\{ keyButs[i].states= ([[folderName, textcolors[(i).wrap(0, 11);], colors[(i).wrap(0, 11);]], [folderName, \cf8 Color\cf0 .black, colorsOn[(i).wrap(0, 11)]] ]) \}.defer;\
				properties[i]= defaultProperties[0].deepCopy;\
				properties[i][2]= 5; \cf4 //set as sequence\cf0 \
				properties[i][6]= 0;\
		\},\{\
		\cf4 // if path is not folder, normal\cf0 \
	paths.do(\{ \cf2 |path, ii|\cf0 \
		fileName= path.basename.removeExtension;\
		if (path.isSoundFileOrMp3, \{\
		\{a.freeKey((\cf6 "snd"\cf0 ++(i+ii).asString).asSymbol);\}.try;\
		soundsASR[i+ii].do(\{\cf2 |it, iii|\cf0 \
			\{a.freeKey((\cf6 "snd"\cf0 ++(i+ii).asString++\cf6 "x"\cf0 ++(iii.asString)).asSymbol);\}.try;\
		\});\
		soundsASR[i+ii]= [];\
		\cf4 //path.postln;\cf0 \
		sounds[(i+ii)]= path;\
		a.prepareForPlay((\cf6 "snd"\cf0 ++(i+ii).asString).asSymbol, sounds[(i+ii)]);\
		\{ keyButs[i+ii].states= ([[path.basename.removeExtension, textcolors[(i+ii).wrap(0, 11);], colors[(i+ii).wrap(0, 11);]], [path.basename.removeExtension, \cf8 Color\cf0 .black, colorsOn[(i+ii).wrap(0, 11)]] ]) \}.defer;\
		properties[(i+ii)]= defaultProperties[0].deepCopy;\
		\cf4 //folder rules\cf0 \
		rulesOnOff.do(\{\cf2 |it, onoff_iter|\cf0 \
			if(it == 1, \{\
				\cf4 //"onoff!".postln;\cf0 \
				if (path.contains(ruleFolderNames[onoff_iter]), \{\
					\cf4 //"it contains!!".postln;\cf0 \
					rulesApply[onoff_iter].do(\{\cf2 |it, apply_iter|\cf0 \
						if(it == 1, \{\
							\cf4 //"applying properties!!".postln;\cf0 \
							properties[i+ii][apply_iter]= rulesList[onoff_iter][apply_iter];\
							\});\
					\});\
				\});\
			\});\
		\});\
		\cf4 //if (path.contains("musicloops"), \{ properties[i+ii][1]= 1; properties[i+ii][2]= 2; \});\cf0 \
		\cf4 //check for loop in filename\cf0 \
		if (fileName.last == $L, \{properties[i+ii][1]= 1;\}, \{\
			if (fileName.last.isDecDigit && \{fileName[fileName.lastIndex-1] == $L\}, 				\{properties[i+ii][1]= 1;\});\
		\});\
		if (path.hasTag(\cf6 "Loop"\cf0 ), \{ properties[i+ii][1]= 1; \});\
		\
		robotPresetCheck.value(path, i);\
		if(a.mp3[(\cf6 "snd"\cf0 ++(i).asString).asSymbol].isNil.not, \{sounds[i]= a.mp3[(\cf6 "snd"\cf0 ++(i).asString).asSymbol]\});\
		\}, \{\
			if(path.extension == \cf6 "mid"\cf0 , \{ \cf4 // if MIDI File\cf0 \
				\cf6 "loading midi file"\cf0 .postln;\
				midifile= \cf8 SimpleMIDIFile\cf0 .read(path);\
				if(\cf5 ~robotDict\cf0 [(midifile.trackName).asSymbol].notNil, \{\
					properties[i][15][0]= 1;\
					properties[i][15][1].add((midifile.trackName(0).asSymbol).deepCopy -> \cf5 ~robotDict\cf0 [midifile.trackName(0).asSymbol][2].deepCopy);\
					path.copyTo(oscfilesDir, overwrite: \cf3 true\cf0 );\
					properties[i][15][1][midifile.trackName(0).asSymbol][0][0]= oscfilesDir+/+(path.basename);\
					(oscfilesDir+/+(path.basename)).postln;\
					properties[i][15][1][midifile.trackName(0).asSymbol][0][0].postln;\
					properties[i][15][1][midifile.trackName(0).asSymbol]= [[oscfilesDir+/+(path.basename), \cf5 ~robotDict\cf0 [midifile.trackName(0).asSymbol][2][0][1]], 2, 90, 95];\
					\});\
				\}, \{\
			errorFileMessage.value;\
				\});\
			\});\
	\});\
		\});\
	\};\
\
robotPresetCheck= \{\cf2 |soundfile, key|\cf0 \
	\cf2 var\cf0  saveDirectoryOSC, saveFilesOSC, saveFilesOSCNames, loadArray, index;\
	\
	saveDirectoryOSC= (\cf8 String\cf0 .scDir.dirname ++ \cf6 "/Resources/SENDWINSAVES/OSC/"\cf0 );\
	saveFilesOSC= (saveDirectoryOSC++\cf6 "*"\cf0 ).standardizePath.pathMatch;\
	saveFilesOSCNames= saveFilesOSC.collect(\{\cf2 |it|\cf0  it.basename.asSymbol\});\
	soundfile= soundfile.basename.removeExtension.asSymbol;\
	index= saveFilesOSCNames.indexOfWildcard(soundfile);\
	\
	if(index.isNil.not, \{\
		loadArray= \cf8 Object\cf0 .readArchive(saveFilesOSC[index]);\
		properties[key][15][0]= loadArray[0];\
		properties[key][15][1]= loadArray[1];\
		\});\
	\
	\
	\};\
\
midiPresetCheck= \{\cf2 |soundfile, key|\cf0 \
	\cf2 var\cf0  saveDirectoryMIDI, saveFilesMIDI, saveFilesMIDINames, loadArray, index;\
	\
	saveDirectoryMIDI= (\cf8 String\cf0 .scDir.dirname ++ \cf6 "/Resources/SENDWINSAVES/MIDI/"\cf0 );\
	saveFilesMIDI= (saveDirectoryMIDI++\cf6 "*"\cf0 ).standardizePath.pathMatch;\
	saveFilesMIDINames= saveFilesMIDI.collect(\{\cf2 |it|\cf0  it.basename.asSymbol\});\
	soundfile= soundfile.basename.removeExtension.asSymbol;\
	index= saveFilesMIDINames.indexOfWildcard(soundfile);\
	\
	if(index.isNil.not, \{\
		loadArray= \cf8 Object\cf0 .readArchive(saveFilesMIDI[index]);\
		properties[key][11]= loadArray;\
		\});\
	\
	\
	\};\
\
errorFileMessage= \{\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf2 var\cf0  w, r;\
\
	w= \cf8 SCAlert\cf0 ( \cf6 "the file you loaded is not valid. It's either just plain wrong or mp3.."\cf0 ,[\cf6 "close.. 5"\cf0 ],[\{w.window.close; r.stop; \}] );\
	\
	\cf4 /*\
	w= Window("error", Rect(400, 400, 300, 100))\
	.background_(\
	.alwaysOnTop_("true");\
\
	StaticText(w, Rect(10, 10, 280, 20))\
	.string_("the file you loaded is not valid");\
	StaticText(w, Rect(10, 30, 280, 20))\
	.string_("either just plain wrong or mp3..");\
	w.front;\
	*/\cf0 \
	r= \{1.wait; \
	5.do(\{\cf2 |i|\cf0  \{w.buttonLabel_(0, \cf6 "close.."\cf0 +(5-i));\}.defer; 1.wait;\});\
	w.window.close;\}.fork(\cf8 AppClock\cf0 );\
\};\
\
\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf4 // =============================================================================================\cf0 \
\cf4 // ============================= GUI - SLIDERS & KNOBS =========================================\cf0 \
\cf4 // =============================================================================================\cf0 \
\
\cf4 // ============= SLIDERS ==========\cf0 \
\
sliderView= \cf8 HLayoutView\cf0 (w, \cf8 Rect\cf0 (20, 540, 415, 190));\
\cf4 //sliderView.setProperty(\\spacing,0);\cf0 \
\
\
sliders= slidersCC.size.collect(\{ \cf2 |i|\cf0 \
	i= i+1;\
	\cf8 SliderLooper\cf0 .new(sliderView, 0, 0, i, out: output, preferences: preferences);\
\});\
\
sliders.do(\{\cf2 |it|\cf0  it.allSliders= sliders \});\
\
responders1= slidersCC.collect(\{\cf2 |it, i|\cf0 \
\
		\cf8 CCResponder\cf0 (\{\
			\cf2 |src,chan,num,value|\cf0 \
			sliders[i].setVal((value*(127.reciprocal)).round(0.001));\
		\}, num: it, src: midisrcindex, chan: midichannel\
		);\
\
\});\
\
\cf4 // ============= KNOBS ==========\cf0 \
knobView1= \cf8 CompositeView\cf0 (w, \cf8 Rect\cf0 (15, 300, 380, 240));\
knobView1.decorator = \cf8 FlowLayout\cf0 (knobView1.bounds);\
\
\
allKnobs= knobsCC.size.collect(\{\cf2 |i|\cf0 \
	\cf8 UC33LoopChan\cf0 .new(knobView1, 0, 0, output, \cf3 nil\cf0 , preferences, properties, a, i+1);\
\});\
\
allKnobs.do(\{\cf2 |it|\cf0  it.allSliders= allKnobs \});\
\
responders2= knobsCC.collect(\{\cf2 |it, i|\cf0 \
\
		\cf8 CCResponder\cf0 (\{\
			\cf2 |src,chan,num,value|\cf0 \
			allKnobs[i].setVal((value*(127.reciprocal)).round(0.001));\
		\}, num: (it), src: midisrcindex, chan: midichannel\
		);\
	\
\});\
\
\
\
\cf4 // =============================================================================================\cf0 \
\cf4 // ================================= GUI - EFFECT VIEW =========================================\cf0 \
\cf4 // =============================================================================================\cf0 \
\
effView= \{\cf2 |storedValues|\cf0 \
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf2 var\cf0  cblobs;\
\
\cf2 var\cf0  fx_synths, fx_synth_names, fx_synth_namesShort, metadata, fxMenu, fxMenuItems, paramGUIs= [];\
\cf2 var\cf0  gateControls, gates= [];\
\cf2 var\cf0  allSynths= [];\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf4 //var fxDir= "/Users/martin/scwork/samplerProject/fx-lib";\cf0 \
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf2 var\cf0  fxDir= (\cf8 String\cf0 .scDir.dirname ++ \cf6 "/Resources/FXSynthDefs"\cf0 );\
\
\
\{\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf4 ////////// ** FX SYNTHS LOAD ** /////////////\cf0 \
	(fxDir ++ \cf6 "/*"\cf0 ).loadPaths;\
			s.sync;\
	\cf4 //collect list of synths with fx_ in the name\cf0 \
	fx_synths=\cf8 SynthDescLib\cf0 .global.synthDescs.select\{\cf2 |def|\cf0 \
     def.name.contains(\cf6 "fx_"\cf0 );\
	\};\
\
  	fx_synth_names= fx_synths.collect(\{\cf2 |it|\cf0  it.name \});	\
 	fx_synth_namesShort= fx_synths.collect(\{\cf2 |it|\cf0  it.name.drop(3)\});\
 	\
 	allSynths= \cf3 nil\cf0 !(fx_synths.size);\
 	\
 	t= \cf8 TabbedView\cf0 (w, \cf8 Rect\cf0 (250, 75, 200, 95), fx_synth_namesShort, [\cf8 Color\cf0 .new255(158, 158, 158), \cf8 Color\cf0 .new255(148, 148, 148), \cf8 Color\cf0 .new255(138, 138, 138)])\
.followEdges_(\cf3 false\cf0 )\
.font_(\cf8 Font\cf0 (\cf6 "Monaco"\cf0 ,9)).tabHeight_(1).tabWidth_(15);\
 	\
 	fx_synth_names.do(\{\cf2 |it, i|\cf0 \
	 	\cf2 var\cf0  metadatainfo, but, guis, synth, usefulControls, scroll, view, gatebutton;\
	 	\cf2 var\cf0  currentValuesDict= \cf8 Dictionary\cf0 .new;\
	 	it= fx_synths[it.asSymbol];\
	 	currentValuesDict.put(\cf9 \\out\cf0 , output);\
	 	\cf4 //make button\cf0 \
	 	scroll= \cf8 ScrollView\cf0 (t.views[i], \cf8 Rect\cf0 (0, 0, 200, 80))\
	 	.hasHorizontalScroller_(\cf3 false\cf0 );\
	 	\cf4 //.hasBorder_(true);\cf0 \
	 	view= \cf8 CompositeView\cf0 (scroll, \cf8 Rect\cf0 (0, 0, 190, 150));\
	 	but= \cf8 Button\cf0 (view, \cf8 Rect\cf0 (5, 5, 15, 15))\
		.states_([[\cf6 "x"\cf0 ], [\cf6 "x"\cf0 , \cf8 Color\cf0 .black, \cf8 Color\cf0 .green]])\
		.value_(0)\
		.canFocus_(\cf3 false\cf0 )\
		.action_(\{\cf2 |v|\cf0  \
			if (v.value == 1,\
			\{ allSynths[i]= \cf8 Synth\cf0 .tail(effectGroup, it.name.asSymbol, currentValuesDict.asKeyValuePairs);\
					allSynths[i].isRunning= \cf3 true\cf0 ;\
					fxMenuItems[i]= fxMenuItems[i]+\cf6 "*"\cf0 ;\
					fxMenu.items= fxMenuItems;\
				\},\{ \
					allSynths[i].free;\
					fxMenuItems[i]= fxMenuItems[i].drop(-2);\
					fxMenu.items= fxMenuItems; \
				\});\
		\});\
		\
		usefulControls= it.controls.reject(\{\cf2 |itt|\cf0 \
			\cf2 var\cf0  name= itt.name.asSymbol;\
			\cf2 var\cf0  avoidList= [\cf9 \\out\cf0 , \cf9 \\in\cf0 , \cf9 \\gate\cf0 , \cf9 \\recrun\cf0 ];\
			avoidList.indexOf(name).isNil.not\
		\});\
		\
		gateControls= it.controls.detect(\{\cf2 |itt|\cf0 \
			\cf2 var\cf0  name= itt.name.asSymbol;\
			name == \cf9 \\gate\cf0 \
		\});\
		\
		\cf4 //if(gateControls.class != Array, \{gateControls= [gateControls]; \});\cf0 \
		\
		\cf4 //usefulControls.postln;\cf0 \
		\cf4 //usefulControls.class.postln;\cf0 \
\
	 	guis= usefulControls.collect(\{\cf2 |itt, ii|\cf0 \
		 		\cf2 var\cf0  name= itt.name.asSymbol;\
		 		\cf2 var\cf0  spec;\
		 		currentValuesDict.put(name, itt.defaultValue);\
		 		spec= it.metadata[\cf9 \\specs\cf0 ][name];\
				\cf8 EZSlider\cf0 (view,  	\cf4 // parent\cf0 \
				\cf8 Rect\cf0 (10, 5+(15*ii), 180, 15),\
				name,	\cf4 // label\cf0 \
				spec, \cf4 // controlSpec\cf0 \
				\{\cf2 |ez|\cf0  if (but.value == 1, \{allSynths[i].set(name, ez.value)\});\
					currentValuesDict.put(name, ez.value);\
					\cf4 //("setting"+name+":"+currentValuesDict[name].asString).postln;\cf0 \
				\}, \cf4 // action\cf0 \
				itt.defaultValue, \cf4 // init value, set from A DICTIONARY\cf0 \
				labelWidth: 40\
				).setColors(\
					\cf3 nil\cf0 , \cf4 //string backgr\cf0 \
					\cf8 Color\cf0 .white, \cf4 //string\cf0 \
					\cf8 Color\cf0 (0.298, 0.298, 0.298, 1.0), \cf4 //slider backgr\cf0 \
					\cf8 Color\cf0 .grey, \cf4 //num backgr\cf0 \
					\cf8 Color\cf0 .white, \cf4 //num clr\cf0 \
					\cf3 nil\cf0 ,\
					\cf3 nil\cf0 ,\
					\cf8 Color\cf0 (0.298, 0.776, 1.0, 1.0) \cf4 //knob clr\cf0 \
					);\
		\});\
		\
		if(gateControls.isNil.not, \{\
		 	gatebutton= \cf8 Button\cf0 (view, \cf8 Rect\cf0 (10, 5+(15*guis.size), 160, 15))\
		 	.states_([[\cf6 "gate"\cf0 ],[\cf6 "gate"\cf0 , \cf8 Color\cf0 .black, \cf8 Color\cf0 .yellow]])\
		 	.action_(\{\cf2 |v|\cf0  allSynths[i].set(\cf9 \\gate\cf0 , v.value) \})\
		 	.value_(gateControls.defaultValue); 	\
			gates= gates.add(gatebutton);\
		\});\
\
 		paramGUIs= paramGUIs++but++guis;\
 		\
 		view.bounds_(\cf8 Rect\cf0 (0, 0, 190, 40+(guis.size*15)));\
 	\
 		\cf4 //fxDict.put(it.name.asSymbol, currentValuesDict);\cf0 \
	 \});\
	\cf4 //paramGUIs.postln;\cf0 \
	\cf4 //fx_synth_names.postln;\cf0 \
	\cf4 //fx_synth_names.asArray.postln;\cf0 \
	\
	fxMenuItems= fx_synth_namesShort.asArray;\
	\
	fxMenu= \cf8 PopUpMenu\cf0 (w, \cf8 Rect\cf0 (250, 75, 100, 15))\
	.items_(fxMenuItems)\
	.background_(\cf8 Color\cf0 .white)\
	.canFocus_(\cf3 false\cf0 )\
	.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 , 10))\
	.action_(\{\cf2 |v|\cf0  t.focus(v.value)\});\
	\cf8 Button\cf0 (w, \cf8 Rect\cf0 (350, 75, 30, 15))\
	.canFocus_(\cf3 false\cf0 )\
	.states_([[\cf6 "<<"\cf0 , \cf8 Color\cf0 (0.298, 0.776, 1.0, 1.0), \cf8 Color\cf0 (0.298, 0.298, 0.298, 1.0)]])\
	.action_(\{\cf2 |v|\cf0  \{fxMenu.valueAction= (fxMenu.value-1).wrap(0, (fxMenu.items.size-1)) \}.defer; \});\
	\cf8 Button\cf0 (w, \cf8 Rect\cf0 (380, 75, 30, 15))\
	.canFocus_(\cf3 false\cf0 )\
	.states_([[\cf6 ">>"\cf0 , \cf8 Color\cf0 (0.298, 0.776, 1.0, 1.0), \cf8 Color\cf0 (0.298, 0.298, 0.298, 1.0)]])\
	.action_(\{\cf2 |v|\cf0  \{fxMenu.valueAction= (fxMenu.value+1).wrap(0, (fxMenu.items.size-1)) \}.defer; \});	\
	\cf8 Button\cf0 (w, \cf8 Rect\cf0 (410, 75, 35, 15))\
	.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 , 10))\
	.canFocus_(\cf3 false\cf0 )\
	.states_([[\cf6 "allOff"\cf0 , \cf8 Color\cf0 .red, \cf8 Color\cf0 (0.298, 0.298, 0.298, 1.0)]])\
	.action_(\{\cf2 |v|\cf0 \
		allSynths.do(\{\cf2 |it|\cf0 \
			if(it.isNil.not,\{\
				if(it.isRunning, \{it.free;\});\
			\});\
		\});\
		paramGUIs.do(\{\cf2 |it|\cf0 \
			if(it.class == \cf8 SCButton\cf0 , \{ \{it.valueAction= 0\}.defer; \});\
		\});\
		\});	\
	\
	\
\
\
\cf4 /*\
(ezrev++ezecho).do(\{|it, i|\
	it.sliderView.canReceiveDragHandler= (true);\
	it.sliderView.receiveDragHandler= (\{|view|\
		var drag, actfunc;\
		actfunc= \{|v| \{view.value= v.value\}.defer \};\
		View.currentDrag.knob1.action = view.action;\
		View.currentDrag.knob1.addAction(actfunc);\
		View.currentDrag.setValues([nil]);\
		View.currentDrag.title.string = ("CC"++it.labelView.string);\
		drag= View.currentDrag;\
		view.onClose= \{\
			drag.setDefaultAction;\
			drag.setValues([nil]);\
			drag.knob1.removeAction(actfunc);\
			"yaya".postln;\
		\};\
\})\
\});\
*/\cf0 \
\
t.view.addAction(\{\
	allSynths.do(\{\cf2 |it|\cf0 \
		if(it.isNil.not,\{\
			if(it.isRunning, \{it.free;\});\
		\});\
	\});\
\}, \cf9 \\onClose\cf0 );\
\
\cf4 /*\
r\{\
	1.wait;\
	if (masterprop[\\revon] == 1, \{ \{revOn.valueAction= 1\}.defer; \});\
	if (masterprop[\\eon] == 1, \{ \{echoOn.valueAction= 1\}.defer; \});\
\}.play(AppClock);\
*/\cf0 \
\
\
\cf4 //paramGUIs.postln;\cf0 \
\cf4 //gates.postln;\cf0 \
\
cblobs= \cf8 Colorblobs2\cf0 .new(w, \cf8 Rect\cf0 (250, 170, 200, 105), paramGUIs, kaossFilesDir, gates)\
\
\cf4 /*	, pressAction: \{ \{ sliders.do(\{|it| it.pause \}) \}.defer; \}, \
	releaseAction: \{  \{ sliders.do(\{|it| it.unpause \}) \}.defer; \} \
	);\
*/\cf0 \
	 \}.fork(\cf8 AppClock\cf0 );\
\};\
\
effView.value;\
\
\
\cf4 // =============================================================================================\cf0 \
\cf4 // ============================= GUI - PROP VIEW ===============================================\cf0 \
\cf4 // =============================================================================================\cf0 \
\
propView= \{ \cf2 | key |\cf0 \
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf2 var\cf0  t, panarr= [0, -1, 1], directionBut, rateKnob;\
\
c= \cf8 CompositeView\cf0 (w, \cf8 Rect\cf0 (20, 100, 220, 190))\
.background_(\cf8 Color\cf0 .new255(229, 229, 229));\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf4 //.relativeOrigin_(true);\cf0 \
\
if (sounds[key].isNil.not, \{\
\cf8 StaticText\cf0 (c, \cf8 Rect\cf0 (90, 0, 200, 15))\
.string_(sounds[key].basename.removeExtension);\
\},\{\
\cf8 StaticText\cf0 (c, \cf8 Rect\cf0 (90, 0, 200, 15))\
.string_(\cf6 "no soundfile on key"\cf0 );\
\});\
\
\cf8 Knob\cf0 (c, \cf8 Rect\cf0 (10, 10, 15, 15))\
.centered_(\cf3 true\cf0 )\
.canFocus_(\cf3 false\cf0 )\
.value_(\cf9 \\pan\cf0 .asSpec.unmap(properties[key][9]))\
.action_(\{ \cf2 |v|\cf0 \
	properties[key][9]= \cf9 \\pan\cf0 .asSpec.map(v.value);\
	if (a.isPlaying((\cf6 "snd"\cf0 ++((key).asString)).asSymbol), \{\
				a.set((\cf6 "snd"\cf0 ++((key).asString)).asSymbol).pan_(\cf9 \\pan\cf0 .asSpec.map(v.value)) \});\
	\cf4 //\\pan.asSpec.map(v.value).postln;\cf0 \
\})\
.color_([\cf8 Color\cf0 .gray, \cf8 Color\cf0 .red, \cf8 Color\cf0 .white, \cf8 Color\cf0 .black])\
.mouseDownAction_(\{\cf2 |view, x, y, mod|\cf0 \
	if (mod == alt, \{view.valueAction= \cf9 \\pan\cf0 .asSpec.unmap(0); properties[key][9]= 0\})\
\});\
\
\
\cf8 Button\cf0 (c, \cf8 Rect\cf0 (30, 10, 30, 15))\
.states_([[\cf6 "nil"\cf0 , \cf8 Color\cf0 .black, \cf8 Color\cf0 .grey], [\cf6 "1-2"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .black],[\cf6 "3-4"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .black], [\cf6 "5-6"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .black], [\cf6 "7-8"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .black], [\cf6 "9-10"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .black], [\cf6 "11-12"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .black], [\cf6 "13-14"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .black], [\cf6 "15-16"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .black], [\cf6 "17-18"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .black], [\cf6 "19-20"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .black], [\cf6 "21-22"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .black], [\cf6 "23-24"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .black], [\cf6 "25-26"\cf0 , \cf8 Color\cf0 .yellow, \cf8 Color\cf0 .black] ] )\
.canFocus_(\cf3 false\cf0 )\
.value_(if (properties[key][10]==\cf3 nil\cf0 , \{ 0 \}, \{ outputs.indexOf(properties[key][10]) \}) )\
.action_(\{ \cf2 |v|\cf0 \
	properties[key][10]= outputs[v.value];\
\});\
\
\
\cf8 Slider\cf0 (c, \cf8 Rect\cf0 (10, 30, 50, 120))\
.background_(\cf8 Color\cf0 .grey)\
.canFocus_(\cf3 false\cf0 )\
.value_(properties[key][0])\
.action_(\{ \cf2 |v|\cf0 \
	properties[key][0]= v.value;\
	if (a.isPlaying((\cf6 "snd"\cf0 ++((key).asString)).asSymbol), \{\
		a.set((\cf6 "snd"\cf0 ++((key).asString)).asSymbol).amp_(v.value) \});\
	\
\});\
\cf8 Button\cf0 (c, \cf8 Rect\cf0 (70, 20, 60, 20))\
.states_([[\cf6 "loop off"\cf0 , \cf8 Color\cf0 .black, \cf8 Color\cf0 .grey], [\cf6 "loop on"\cf0 , \cf8 Color\cf0 .white, \cf8 Color\cf0 .black]])\
.canFocus_(\cf3 false\cf0 )\
.value_(properties[key][1])\
.action_(\{ \cf2 |v|\cf0 \
	properties[key][1]= v.value;\
\});\
\
\cf8 Button\cf0 (c, \cf8 Rect\cf0 (130, 20, 30, 20))\
.states_([[\cf6 "|--|"\cf0 , \cf8 Color\cf0 .white, \cf8 Color\cf0 .grey]])\
.canFocus_(\cf3 false\cf0 )\
.action_(\{ \cf2 |v|\cf0 \
	if(sounds[key].isNil, \{\cf6 "no sound loaded"\cf0 .postln\},\
	\{looppointeditor.value(key)\}\
	);\
\});\
\
\cf8 Button\cf0 (c, \cf8 Rect\cf0 (160, 20, 20, 20))\
.states_([[\cf6 "rm"\cf0 , \cf8 Color\cf0 .black, \cf8 Color\cf0 .grey]])\
.canFocus_(\cf3 false\cf0 )\
.action_(\{ \cf2 |v|\cf0 \
	\{a.freeKey((\cf6 "snd"\cf0 ++(key).asString).asSymbol);\}.try;\
	soundsASR[key].do(\{\cf2 |it, iii|\cf0 \
		if (it[iii].isNil.not, \{\
		\{a.freeKey((\cf6 "snd"\cf0 ++(key).asString++\cf6 "x"\cf0 ++(iii.asString)).asSymbol);\}.try;\
		\cf4 //it[iii]= nil;\cf0 \
		\});\
	\});\
	soundsASR[key]= \cf3 nil\cf0 ;\
	sounds[key]= \cf3 nil\cf0 ;\
	properties[key]= defaultProperties[0].deepCopy;\
	\{keyButs[key].states= ([[\cf6 ""\cf0 , textcolors[key.wrap(0, 11)], colors[key.wrap(0, 11)]], [\cf6 ""\cf0 , textcolors[key.wrap(0, 11)], colorsOn[key.wrap(0, 11)]]]);\}.defer;\
\});\
\
\cf4 //("prop 14:"+properties[key][14]).postln;\cf0 \
\
rateKnob= \cf8 Knob\cf0 (c, \cf8 Rect\cf0 (185, 20, 20, 20)) \cf4 //speed / rate\cf0 \
.centered_(\cf3 true\cf0 )\
.canFocus_(\cf3 false\cf0 )\
.value_(\cf9 \\pan\cf0 .asSpec.unmap(properties[key][14]))\
.action_(\{ \cf2 |v|\cf0 \
	\cf4 //\\pan.asSpec.map(v.value).postln;\cf0 \
	properties[key][14]= \cf9 \\pan\cf0 .asSpec.map(v.value);\
	if(\cf9 \\pan\cf0 .asSpec.map(v.value).isPositive, \
		\{directionBut.value= 0; properties[key][13][0]= 0\}, \
		\{directionBut.value= 1; properties[key][13][0]= 1\});\
	if (a.isPlaying((\cf6 "snd"\cf0 ++((key).asString)).asSymbol), \{\
		a.set((\cf6 "snd"\cf0 ++((key).asString)).asSymbol).speed_(\cf9 \\pan\cf0 .asSpec.map(v.value)) \});\
\
\})\
.color_([\cf8 Color\cf0 .grey, \cf8 Color\cf0 .red, \cf8 Color\cf0 .white, \cf8 Color\cf0 .black])\
.mouseDownAction_(\{\cf2 |view, x, y, mod|\cf0 \
	if (mod == alt, \{view.valueAction= \cf9 \\pan\cf0 .asSpec.unmap(1); properties[key][14]= 1\})\
\})\
.canReceiveDragHandler_(\cf3 true\cf0 )\
.receiveDragHandler_(\{\cf2 |view|\cf0 \
	\cf2 var\cf0  drag;\
	drag= \cf8 View\cf0 .currentDrag;\
	if (drag.class == \cf8 UC33LoopChan\cf0 , \{\
		drag.setAction(\{\cf2 |v|\cf0 \{ rateKnob.valueAction_(v.value)\}.defer \}, \cf6 "rate"\cf0 +noteArray[key]);\
	\});\
\});\
\
\
\
directionBut= \cf8 Button\cf0 (c, \cf8 Rect\cf0 (180, 45, 30, 20))\
.states_([[\cf6 ">>"\cf0 , \cf8 Color\cf0 .green, \cf8 Color\cf0 .white], [\cf6 "<<"\cf0 , \cf8 Color\cf0 .red, \cf8 Color\cf0 .white]])\
.canFocus_(\cf3 false\cf0 )\
.action_(\{ \cf2 |v|\cf0 \
	if(v.value == 1, \{\
		rateKnob.valueAction= \cf9 \\pan\cf0 .asSpec.unmap(\cf9 \\pan\cf0 .asSpec.map(rateKnob.value).neg)\
		\},\{\
		rateKnob.valueAction= \cf9 \\pan\cf0 .asSpec.unmap(\cf9 \\pan\cf0 .asSpec.map(rateKnob.value).abs)\
		\});\
\});\
if(properties[key][14].isNegative, \{directionBut.value= 1\});\
\
\
\cf8 Button\cf0 (c, \cf8 Rect\cf0 (130, 45, 30, 20))\
.states_([[\cf6 "killa"\cf0 , \cf8 Color\cf0 .black, \cf8 Color\cf0 .grey], [\cf6 "killa"\cf0 , \cf8 Color\cf0 .red, \cf8 Color\cf0 .black]])\
.canFocus_(\cf3 false\cf0 )\
.value_(properties[key][5])\
.action_(\{ \cf2 |v|\cf0 \
	properties[key][5]= v.value;\
\});\
\
\cf8 Button\cf0 (c, \cf8 Rect\cf0 (160, 45, 20, 20))\
.states_([[\cf6 "sh"\cf0 , \cf8 Color\cf0 .black, \cf8 Color\cf0 .grey], [\cf6 "sh"\cf0 , \cf8 Color\cf0 .red, \cf8 Color\cf0 .black]])\
.canFocus_(\cf3 false\cf0 )\
.value_(properties[key][8])\
.action_(\{ \cf2 |v|\cf0 \
	properties[key][8]= v.value;\
	if (v.value == 1, \{properties[key][1]= 0\});\
\});\
\
\
\cf8 Button\cf0 (c, \cf8 Rect\cf0 (70, 45, 60, 20))\
.states_([[\cf6 "|>"\cf0 , \cf8 Color\cf0 .black, \cf8 Color\cf0 .grey], [\cf6 "|>"\cf0 , \cf8 Color\cf0 .white, \cf8 Color\cf0 .black]])\
.canFocus_(\cf3 false\cf0 )\
.value_(if (a.isPlaying((\cf6 "snd"\cf0 ++((key).asString)).asSymbol), \{1\}, \{0\}) )\
.action_(\{ \cf2 |v|\cf0 \
	\cf2 var\cf0  b= keyButs[key], time;\
	if (v.value == 1, \{\
		playnote.value(\cf3 nil\cf0 , sounds[key], key, \cf3 nil\cf0 );\
	\},\{\
		stopnote.value(sounds[key], key);\
	\});\
	if( \cf5 ~logfile\cf0 .isNil.not, \{ \{\cf5 ~logfile\cf0 .write(\cf8 Date\cf0 .getDate.hourStamp.asString+(sounds[key].basename)++\cf6 "\\n"\cf0 )\}.defer; \});\
\});\
\
\cf8 EZNumber\cf0 ( c,  	\cf4 // parent\cf0 \
	\cf8 Rect\cf0 (50, 70, 80, 20),	\cf4 // bounds\cf0 \
	\cf6 "atk"\cf0 ,	\cf4 // label\cf0 \
	[0,6,\cf9 \\lin\cf0 ,0.01, properties[key][3]].asSpec, 	\cf4 // controlSpec\cf0 \
	\{\cf2 |ez|\cf0  \
	properties[key][3]= ez.value;\
	\}, \cf4 // action\cf0 \
	labelWidth: 30,\
	numberWidth: 40,\
	unitWidth: 1\
);\
\
\cf8 EZNumber\cf0 ( c,  	\cf4 // parent\cf0 \
	\cf8 Rect\cf0 (110, 70, 80, 20),	\cf4 // bounds\cf0 \
	\cf6 "rel"\cf0 ,	\cf4 // label\cf0 \
	[0,6,\cf9 \\lin\cf0 ,0.01, properties[key][4]].asSpec, 	\cf4 // controlSpec\cf0 \
	\{\cf2 |ez|\cf0  \
	properties[key][4]= ez.value;\
	\}, \cf4 // action\cf0 \
	labelWidth: 30,\
	numberWidth: 40,\
	unitWidth: 1\
);\
\
\cf8 Button\cf0 (c, \cf8 Rect\cf0 (190, 70, 20, 20))\
.canFocus_(\cf3 false\cf0 )\
.states_([[\cf6 "S"\cf0 , \cf8 Color\cf0 .white, \cf8 Color\cf0 .green]])\
.action_(\{\cf2 |v|\cf0  sendWindow.value(key) \});\
\
\cf8 PopUpMenu\cf0 (c, \cf8 Rect\cf0 (5, 155, 70, 20))\
.items_([\cf6 "piano"\cf0 , \cf6 "shot"\cf0 , \cf6 "toggle"\cf0 , \cf6 "3 samples"\cf0 , \cf6 "2 samples"\cf0 , \cf6 "many"\cf0 , \cf6 "arpeggio"\cf0 ])\
.value_(properties[key][2])\
.canFocus_(\cf3 false\cf0 )\
.action_(\{ \cf2 arg\cf0  menu;\
	properties[key][2] = menu.value;\
\
	if(arpRoutines[key].isPlaying, \{arpRoutines[key].stop\});\
	if (a.isPlaying((\cf6 "snd"\cf0 ++((key).asString)).asSymbol) and: \{menu.value != 2\}, \{\
		a.stop((\cf6 "snd"\cf0 ++((key).asString)).asSymbol, properties[key][4]);\
		\{ keyButs[key].value= 0 \}.defer;\
		if (progressState == 1, \{\
			progress[key].stop; \
			progressViewClear.value(key);\
		\});\
	\});\
\
	if( menu.value == 3, \{\
		extrasampleView.value(key, soundsASR[key]);\
		extrasample= \cf3 true\cf0 ;\
	\});\
	if( menu.value == 4, \{\
		extrasampleView.value(key, soundsASR[key]);\
		extrasample= \cf3 true\cf0 ;\
			\
	\});\
	if( menu.value == 5, \{\
		extrasampleView.value(key, soundsASR[key]);\
	\});\
	if( menu.value == 6, \{\
		arpView.value(key);\
	\});\
\});\
\
if(properties[key][2] == 3, \{ extrasampleView.value(key, soundsASR[key]) \});\
if(properties[key][2] == 4, \{ extrasampleView.value(key, soundsASR[key]) \});\
if(properties[key][2] == 5, \{ extrasampleView.value(key, soundsASR[key]) \});\
if(properties[key][2] == 6, \{ arpView.value(key) \});\
\
\};\
\
\cf4 // =============================================================================================\cf0 \
\cf4 // ====================================== SEND WINDOW ==========================================\cf0 \
\cf4 // =============================================================================================\cf0 \
\
sendWindow= \{\cf2 |key = 0|\cf0 \
\cf4 //var properties= ([0.5, 0, 0, 0.01, 0.2, 0, 0, 3, 0, 0, nil, nil, [0.1, 0.2, 0], [0, 0, 1], 1, nil, nil]!36).asList, midiOut;\cf0 \
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf2 var\cf0  testCue, testCue2;\
\
\cf2 var\cf0  w, t, tabNames;\
\cf2 var\cf0  midiNoteOnSlider, midiNoteOnValSlider, midiNoteOffSlider, midiNoteOffValSlider, testMIDI= \cf3 false\cf0 ;\
\cf2 var\cf0  midiView, makeNewMidiView, midiSendBut;\
\cf2 var\cf0  oscTab, oscOnOffBut, loadOscTab, oscTypeMenu;\
\cf2 var\cf0  oscfiles, oscsavefiles,oscloadmenu, oscmenuitem;\
\cf2 var\cf0  curOscRecName, curOscRec;\
\cf2 var\cf0  robotMenu, makeNewOscTab;\
\cf2 var\cf0  recOSC;\
\cf2 var\cf0  durationView, waitStringView, setWaitString, envView;\
\cf2 var\cf0  dmxOnOffBut, dmxNoteOnChannel, dmxNoteOnSliders, dmxNoteOnView;\
\cf2 var\cf0  dmxNoteOnViewAdd, dmxNoteOnViewSelect;\
\cf2 var\cf0  dmxNoteOnScroll, dmxNoteOnLayout, updateDmxNoteOnView;\
\cf2 var\cf0  dmxNoteOffChannel, dmxNoteOffSliders, dmxNoteOffView;\
\cf2 var\cf0  dmxNoteOffViewAdd, dmxNoteOffViewSelect;\
\cf2 var\cf0  dmxNoteOffScroll, dmxNoteOffLayout, updateDmxNoteOffView;\
\cf2 var\cf0  testDMX= \cf3 false\cf0 , addBlack= \cf3 true\cf0 ;\
\
\cf2 var\cf0  saveFilesMIDI, loadMenuMIDI, loadMenuItemMIDI, saveDirectoryMIDI;\
\cf2 var\cf0  saveFilesOSC, loadMenuOSC, loadMenuItemOSC, saveDirectoryOSC;\
\cf2 var\cf0  saveFilesDMX, loadMenuDMX, loadMenuItemDMX, saveDirectoryDMX;\
\cf2 var\cf0  verbose= \cf3 true\cf0 ;\
\cf2 var\cf0  oscPlotter;\
\
\
if(sendWinOpen.isNil.not, \{sendWinOpen.close; \});\
if(sendWinLastTabFocus.isNil, \{sendWinLastTabFocus= 1\});\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf4 //midi default\cf0 \
if (properties[key][11].isNil, \{\
	properties[key][11]= [0, [0, 0], [0, 0]];\
	\});\
\
\
\cf4 //osc default\cf0 \
if (properties[key][15].isNil, \{properties[key][15]= [0, \cf8 Dictionary\cf0 .new]\});\
\cf4 //osc test\cf0 \
\cf4 //properties[key][15]= [1, (\\robot1: [127, 0, 7.456])]; // noteon/off\cf0 \
\cf4 //properties[key][15]= [1, (\\robot1: [[[0.0, 0.5], [0.1, 0.8]], 0, 7.456])]; //sequence\cf0 \
\
\
\cf4 //dmx default\cf0 \
if (properties[key][16].isNil, \{properties[key][16]= [0, [\cf8 DMXSubCue\cf0 .new, \cf8 DMXSubCue\cf0 .new]];\});\
\cf4 //dmx test\cf0 \
\
\cf4 //testCue= DMXSubCue.new;\cf0 \
\cf4 //testCue2= DMXSubCue.new;\cf0 \
\cf4 //[0, 1, 2, 10, 56, 34, 26, 73].do(\{|it, i| testCue.put(it, i*0.1) \});\cf0 \
\cf4 //[0, 1, 2, 10, 56, 34, 26, 73].do(\{|it, i| testCue2.put(it, 0) \});\cf0 \
\cf4 //properties[key][16]= [0, [testCue, testCue2]];\cf0 \
\
\cf4 /*\
if (~dmx.isNil, \{\
	SerialPort.devices.do(\{|it|\
		if (it.asSymbol == '/dev/tty.usbserial-EN109012',\
			\{ "connecting dmx".postln;\
				~dmx= DMX.new;\
				~enttec= EntTecDMXUSBPro.new( "/dev/tty.usbserial-EN109012" );\
				~dmx.device= ~enttec;\
				~dmx.currentCue= DMXCue.new; //make into subcue....\
				~dmx.setCue;\
		\});\
	\});\
\});\
*/\cf0 \
\
\
if (sendWinLastPos.isNil, \{\
	w= \cf8 Window\cf0 (\cf6 "send:"\cf0 +key+(noteArray[key]), \cf8 Rect\cf0 (0, 0, 400, 750));\
\},\{\
	w= \cf8 Window\cf0 (\cf6 "send:"\cf0 +key+(noteArray[key]), \cf8 Rect\cf0 (sendWinLastPos[0], sendWinLastPos[1], 400, 750));\
\});\
sendWinOpen= w;\
tabNames= [\cf6 "MIDI"\cf0 , \cf6 "OSC"\cf0 , \cf6 "DMX"\cf0 ];\
\
t= \cf8 TabbedView\cf0 (w, \cf8 Rect\cf0 (0, 0, 400, 750), tabNames, [\cf8 Color\cf0 .new255(158, 158, 158), \cf8 Color\cf0 .new255(148, 148, 148), \cf8 Color\cf0 .new255(138, 138, 138)]);\
\
\cf4 // =================================================\cf0 \
\cf4 // =================== M I D I =====================\cf0 \
\cf4 // =================================================\cf0 \
\
	\cf4 //t.views[0].decorator=FlowLayout(w.view.bounds);\cf0 \
	\cf4 //t.views[0].decorator.gap=2@2;\cf0 \
	\
	midiSendBut= \cf8 Button\cf0 (t.views[0], \cf8 Rect\cf0 (4, 4, 100, 30))\
	.canFocus_(\cf3 false\cf0 )\
	.states_([[\cf6 "MIDI send OFF"\cf0 , \cf8 Color\cf0 .grey, \cf8 Color\cf0 .black], [\cf6 "MIDI send ON"\cf0 , \cf8 Color\cf0 .green, \cf8 Color\cf0 .black]])\
	.value_(properties[key][11][0])\
		.action_(\{\cf2 |v|\cf0 \
			properties[key][11][0]= v.value;\
		\});\
	\
\cf8 Button\cf0 (t.views[0], \cf8 Rect\cf0 (106, 4, 40, 20))\
.canFocus_(\cf3 false\cf0 )\
.states_([[\cf6 "test"\cf0 , \cf8 Color\cf0 .white, \cf8 Color\cf0 .black], [\cf6 "test"\cf0 , \cf8 Color\cf0 .green, \cf8 Color\cf0 .black]])\
.action_(\{\cf2 |v|\cf0 \
	if(v.value == 1, \{testMIDI= \cf3 true\cf0 ; if(midiOut.isNil, \{\cf6 "midiOUT not connected!"\cf0 .postln;\}); \}, \
		\{testMIDI= \cf3 false\cf0 ;\
			if(midiOut.isNil.not, \{\
				midiOut.sysex(\cf8 Int8Array\cf0 [0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][2][0], 0x00, properties[key][11][2][1], 0x00, 0xf7]);\
			\});\
		\});\
\});\
\
\
\cf4 // ============  MIDI Load Save Menu  ============\cf0 \
\
saveDirectoryMIDI= (\cf8 String\cf0 .scDir.dirname ++ \cf6 "/Resources/SENDWINSAVES/MIDI/"\cf0 );\
\
		saveFilesMIDI= (saveDirectoryMIDI++\cf6 "*"\cf0 ).standardizePath.pathMatch;\
		\cf4 //saveDirectory.postln;\cf0 \
		\cf4 //saveFiles.postln;\cf0 \
		\cf8 StaticText\cf0 (t.views[0], \cf8 Rect\cf0 (148, 4, 60, 30)).string_(\cf6 "save/load:"\cf0 ).align_(\cf9 \\left\cf0 );\
		loadMenuMIDI= \cf8 PopUpMenu\cf0 (t.views[0], \cf8 Rect\cf0 (210, 4, 100, 20)) \cf4 // -----\cf0 \
		.items_(saveFilesMIDI.collect(\{\cf2 |it|\cf0  it.basename\}))\
		.canFocus_(\cf3 false\cf0 )\
		.background_(\cf8 Color\cf0 .white)\
		.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 , 10))\
		.action_(\{\cf2 |v|\cf0 \
			loadMenuItemMIDI= v.items.at(v.value);\
			if(verbose, \{\
			loadMenuItemMIDI.postln; \
			saveFilesMIDI[loadMenuMIDI.value].postln;\
			\});\
		\});\
		\cf4 //load preset\cf0 \
		\cf8 Button\cf0 (t.views[0], \cf8 Rect\cf0 (312, 4, 20, 20)) \cf4 // ------\cf0 \
		.states_([[\cf6 "L"\cf0 , \cf8 Color\cf0 .red, \cf8 Color\cf0 .black]])\
		.canFocus_(\cf3 false\cf0 )\
		.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 , 10))\
		.action_(\{ \
			if (loadMenuItemMIDI.isNil.not, \{ \
				\cf4 //this.load(saveFilesMIDI[loadMenuMIDI.value])\cf0 \
				\cf4 //("before load:"+properties[key][11]).postln;\cf0 \
				properties[key][11]= \cf8 Object\cf0 .readArchive(saveFilesMIDI[loadMenuMIDI.value]);\
				\cf4 //remove view\cf0 \
				midiView.remove;\
				\cf4 //add view\cf0 \
				midiView= \cf8 CompositeView\cf0 (t.views[0], \cf8 Rect\cf0 (4, 36, 400, 400));\
				makeNewMidiView.value;\
				\{midiSendBut.value= 1\}.defer;\
				\cf4 /*\
				midiView= CompositeView(t.views[0], Rect(4, 36, 400, 400));\
				\{ midiNoteOnSlider.value= properties[key][11][1][0] \}.defer;\
				\{ midiNoteOnValSlider.value= properties[key][11][1][1] \}.defer;\
				\{ midiNoteOffSlider.value= properties[key][11][2][0] \}.defer;\
				\{ midiNoteOffValSlider.value= properties[key][11][2][1] \}.defer;\
				*/\cf0 \
				\cf4 //("after load:"+properties[key][11]).postln;\cf0 \
			\});\
		\});\
		\cf8 Button\cf0 (t.views[0], \cf8 Rect\cf0 (334, 4, 30, 20))\
		.states_([[\cf6 "qs"\cf0 ]])\
		.canFocus_(\cf3 false\cf0 )\
		.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 , 12))\
		.action_(\{ \
			\cf4 //this.save(saveDirectoryMIDI+/+saveFilesMIDI[loadMenuMIDI.value]) \cf0 \
			properties[key][11].writeArchive(saveFilesMIDI[loadMenuMIDI.value]);\
		\});\
		\cf8 Button\cf0 (t.views[0], \cf8 Rect\cf0 (366, 4, 20, 20))\
		.states_([[\cf6 "s"\cf0 ]])\
		.canFocus_(\cf3 false\cf0 )\
		.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 , 12))\
		.action_(\{\
			\cf4 //save preset\cf0 \
			\cf2 var\cf0  w, t, name, saveBut;\
				w= \cf8 Window\cf0 (\cf6 "save"\cf0 , \cf8 Rect\cf0 (400, 400, 230, 100), border: \cf3 false\cf0 )\
				.background_(\cf8 Color\cf0 .black)\
				.alwaysOnTop_(\cf3 true\cf0 );\
	\
				t= \cf8 TextView\cf0 (w, \cf8 Rect\cf0 (10, 10, 210, 20))\
				.focus(\cf3 true\cf0 )\
				.keyDownAction_(\{\cf2 |view, char, mod, uni, key|\cf0 \
					if(key == 36, \{ \{saveBut.valueAction= 1\}.defer; \});\
				\});\
				\
				saveBut= \cf8 Button\cf0 (w, \cf8 Rect\cf0 (10, 40, 100, 40))\
				.states_([[\cf6 "save"\cf0 ]])\
				.action_(\{\
					\cf2 var\cf0  values, path, stringSize;\
					stringSize= t.string.size;\
					if (stringSize > 0, \{\
						name= t.string;\
						path= saveDirectoryMIDI+/+(name);\
						\cf4 //this.save(path);\cf0 \
						(\cf6 "saving this:"\cf0 +properties[key][11]).postln;\
						properties[key][11].writeArchive(path);\
						\cf4 //currentSaveFile= path;\cf0 \
						saveFilesMIDI= (saveDirectoryMIDI++\cf6 "*"\cf0 ).standardizePath.pathMatch;\
						\{loadMenuMIDI.items= saveFilesMIDI.collect(\{\cf2 |it|\cf0  it.basename.asSymbol\});\}.defer;\
						loadMenuMIDI.value= loadMenuMIDI.items.indexOf(name.asSymbol);\
						w.close;\
					\});\
				\});\
				\cf8 Button\cf0 (w, \cf8 Rect\cf0 (120, 40, 100, 40))\
				.states_([[\cf6 "cancel"\cf0 ]])\
				.action_(\{\
					w.close;\
				\});\
				w.front;\
		\});\
	\
	midiView= \cf8 CompositeView\cf0 (t.views[0], \cf8 Rect\cf0 (4, 36, 400, 400)).background_(\cf8 Color\cf0 .new255(158, 158, 158));\
	midiView.decorator=\cf8 FlowLayout\cf0 (w.view.bounds);\
	midiView.decorator.gap=2@2;\
	\
\
makeNewMidiView= \{\cf2 |seq= false|\cf0 \
	\cf2 var\cf0  durationView, waitStringView, setWaitString, envView;\
	\
	midiView.decorator=\cf8 FlowLayout\cf0 (w.view.bounds);\
	midiView.decorator.gap=2@2;\
\
	\cf8 PopUpMenu\cf0 (midiView, 150@20)\
	.items_([\cf6 "single value"\cf0 , \cf6 "onset detect"\cf0 , \cf6 "sequencer"\cf0 ])\
	.value_(properties[key][11][3])\
	.background_(\cf8 Color\cf0 .white)\
	.canFocus_(\cf3 false\cf0 )\
	.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 , 15))\
	.action_(\{\cf2 |v|\cf0 \
		\cf2 var\cf0  val;\
		val= v.value;\
		properties[key][11][3]= v.value;\
		case\
		\{v.value == 0\} \{\
			properties[key][11][3]= v.value.deepCopy;\
			\cf4 //remove view\cf0 \
			midiView.remove;\
			\cf4 //add view\cf0 \
			midiView= \cf8 CompositeView\cf0 (t.views[0], \cf8 Rect\cf0 (4, 36, 400, 400));\
			properties[key][11][1]= [1, 0]; \cf4 //noteon\cf0 \
			properties[key][11][2]= [1, 0]; \cf4 //noteoff\cf0 \
			properties[key][11][3]= 0; \cf4 //type (0 = single)\cf0 \
			properties[key][11][4]= 0.3; \cf4 //duration\cf0 \
			\cf4 //properties[key][11][5]= 1; //midimsgType *change*\cf0 \
			makeNewMidiView.value;\
			\}\
		\{v.value == 1\} \{\
			properties[key][11][3]= v.value.deepCopy;\
			\cf4 //remove view\cf0 \
			midiView.remove;\
			\cf4 //add view\cf0 \
			midiView= \cf8 CompositeView\cf0 (t.views[0], \cf8 Rect\cf0 (4, 36, 400, 400));\
			properties[key][11][1]= [1, 0]; \cf4 //noteon\cf0 \
			properties[key][11][2]= [1, 0]; \cf4 //noteoff\cf0 \
			properties[key][11][3]= 1; \cf4 //type (1 = onset)\cf0 \
			properties[key][11][4]= 0.3; \cf4 //duration\cf0 \
			\cf4 //properties[key][11][5]= 1; //midimsgType *change*\cf0 \
			makeNewMidiView.value;\
			\}\
		\{v.value == 2\} \{ \cf4 // make sequencer\cf0 \
			properties[key][11][3]= v.value.deepCopy;\
			\cf4 //remove view\cf0 \
			midiView.remove;\
			\cf4 //add view\cf0 \
			midiView= \cf8 CompositeView\cf0 (t.views[0], \cf8 Rect\cf0 (4, 36, 400, 400));\
			\cf4 //properties[key][11][1]= [1, [[0.0, 0.5], [0.1, 0.8]]]; //noteon\cf0 \
			properties[key][11][1]= [1, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]; \cf4 //noteon\cf0 \
			properties[key][11][2]= [1, 0]; \cf4 //noteoff\cf0 \
			properties[key][11][3]= 2; \cf4 //type (2 = seq)\cf0 \
			properties[key][11][4]= a.length((\cf6 "snd"\cf0 ++(key).asString).asSymbol); \cf4 //duration\cf0 \
			\cf4 //properties[key][11][5]= 1;  //midimsgType *change*\cf0 \
			\cf4 //properties[key][11][1]= [[1, [[0.0, 0.5], [0.1, 0.8]]] [1, 0], 2, a.length(("snd"++(key).asString).asSymbol), 95];\cf0 \
			(\cf6 "sound length:"\cf0 +a.length((\cf6 "snd"\cf0 ++(key).asString).asSymbol)).postln;\
			\cf4 //properties[key][15][1][label][1]= [[0.0, 0.5], [0.1, 0.8]];\cf0 \
			(\cf6 "making seq with these props:"\cf0 +properties[key][11]).postln;\
			makeNewMidiView.value(\cf3 true\cf0 );\
			\};\
	\});\
	\
	\cf8 PopUpMenu\cf0 (midiView, 150@20)\
	.items_([\cf6 "submaster"\cf0 , \cf6 "macro"\cf0 , \cf6 "go cue"\cf0 , \cf6 "grandmaster"\cf0 ])\
	.value_(properties[key][11][5])\
	.background_(\cf8 Color\cf0 .white)\
	.canFocus_(\cf3 false\cf0 )\
	.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 , 12))\
	.action_(\{\cf2 |v|\cf0 \
		\cf2 var\cf0  val;\
		val= v.value;\
		properties[key][11][5]= v.value;\
		\cf4 /*\
		case\
		\{v.value == 0\} \{\
			properties[key][11][5]= v.value;\
			\
			//remove view\
			midiView.remove;\
			//add view\
			midiView= CompositeView(t.views[0], Rect(4, 36, 400, 400));\
			properties[key][11][1]= [1, 0]; //noteon\
			properties[key][11][2]= [1, 0]; //noteoff\
			properties[key][11][3]= 0; //type (0 = single)\
			properties[key][11][4]= 0.3; //duration\
			properties[key][11][5]= 1; //midimsgType *change*\
			makeNewMidiView.value;\
			\
			\}\
		\{v.value == 1\} \{\
			properties[key][11][5]= v.value;\
			\
			//remove view\
			midiView.remove;\
			//add view\
			midiView= CompositeView(t.views[0], Rect(4, 36, 400, 400));\
			properties[key][11][1]= [1, 0]; //noteon\
			properties[key][11][2]= [1, 0]; //noteoff\
			properties[key][11][3]= 1; //type (1 = onset)\
			properties[key][11][4]= 0.3; //duration\
			properties[key][11][5]= 1; //midimsgType *change*\
			makeNewMidiView.value;\
			\}\
		\{v.value == 2\} \{ // make sequencer\
			properties[key][11][3]= v.value;\
			//remove view\
			midiView.remove;\
			//add view\
			midiView= CompositeView(t.views[0], Rect(4, 36, 400, 400));\
			properties[key][11][1]= [1, [[0.0, 0.5], [0.1, 0.8]]]; //noteon\
			properties[key][11][2]= [1, 0]; //noteoff\
			properties[key][11][3]= 2; //type (2 = seq)\
			properties[key][11][4]= a.length(("snd"++(key).asString).asSymbol); //duration\
			properties[key][11][5]= 1;  //midimsgType *change*\
			//properties[key][11][1]= [[1, [[0.0, 0.5], [0.1, 0.8]]] [1, 0], 2, a.length(("snd"++(key).asString).asSymbol), 95];\
			("sound length:"+a.length(("snd"++(key).asString).asSymbol)).postln;\
			//properties[key][15][1][label][1]= [[0.0, 0.5], [0.1, 0.8]];\
			("making seq with these props:"+properties[key][11][1]).postln;\
			makeNewMidiView.value(true);\
			\};\
			*/\cf0 \
	\});\
	\
	\cf8 StaticText\cf0 (midiView, \cf8 Rect\cf0 (0, 0, 400, 30)).string_(\cf6 "NOTE ON:"\cf0 ).align_(\cf9 \\center\cf0 );\
	\
	if(properties[key][11][3] == 2, \{\
		\cf4 //"making seq".postln; \cf0 \
	(\cf6 "chek dis val:"\cf0 +properties[key][11][1][0]).postln;\
	midiNoteOnSlider= \cf8 EZSlider\cf0 (midiView, 392@30, \
		\cf6 "subm"\cf0 ,\
		[0, 300, \cf9 \\lin\cf0 , 1].asSpec,\
		initVal: properties[key][11][1][0], \
		numberWidth:60,\
		layout:\cf9 \\horz\cf0 )\
		.setColors(\cf8 Color\cf0 .grey,\cf8 Color\cf0 .white)\
		.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 ,20))\
		.action_(\{\cf2 |v|\cf0 \
			properties[key][11][1][0]= v.value;\
			properties[key][11][2][0]= v.value;\
			midiNoteOffSlider.value= v.value;\
		\});\
		\
	if (properties[key][11][4].isNil, \{properties[key][11][4]= 4\}); \cf4 //set duration if not set\cf0 \
	\
	\cf8 StaticText\cf0 (midiView, 55@20).string_(\cf6 "Duration:"\cf0 );\
	durationView= \cf8 NumberBox\cf0 (midiView, 70@20)\
	.value_(properties[key][11][4])\
	.action_(\{\cf2 |v|\cf0 \
		properties[key][11][4]= v.value;\
		setWaitString.value(envView);\
		\});\
	\cf8 StaticText\cf0 (midiView, 30@20).string_(\cf6 "sec"\cf0 );\
	\
	\cf6 "prop:"\cf0 .post; properties[key][11][1][1].postln;\
	if (properties[key][11][1][1].size < 3, \{\
		properties[key][11][1][1]= [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];\
		\});\
	\
envView = \cf8 MultiSliderView\cf0 (midiView, \cf8 Rect\cf0 (0, 0, 390, 200))\
	.value_(properties[key][11][1][1])\
	.gap_(0)\
	.indexThumbSize_(390/21)\
	.action_(\{ \cf2 |v|\cf0   \
		properties[key][11][1][1]= v.value;\
		\});\
\
\
\cf4 /*\
envView = EnvelopeView(midiView, Rect(0, 0, 400, 200))\
	.drawLines_(true)\
	.selectionColor_(Color.red)\
	.drawRects_(true)\
	.resize_(5)\
	.step_(0.005)\
	.background_(Color.white)\
	.gridOn_(true)\
	.grid_((1/durationView.value)@0)\
	.action_(\{arg view;\
		setWaitString.value(view);\
		view.value[1].do(\{|it, i|\
			view.setString(i, it.asString);\
		\});\
		properties[key][11][1][1]= view.value;\
	//[view.index, view.value].postln\
	\})\
	.thumbSize_(15)\
	.thumbWidth_(30)\
	.fillColor_(Color.green)\
	.value_(\
	properties[key][11][1][1]\
	//[[0.0, 0.1, 0.5, 1.0],[0.1,1.0,0.8,0.0]]\
	)\
	.mouseDownAction_(\{|view, x, y, mod, button, click|\
		if(click == 2, \{\
			y= ((y / view.bounds.height)-1).abs;\
			x= x / view.bounds.width;\
			view.addValue(x, y);\
		\});\
		setWaitString.value(view);\
	\})\
	.mouseUpAction_(\{|view, x, y, mod, button, click|\
		setWaitString.value(view);\
		view.value[1].do(\{|it, i|\
			view.setString(i, it.asString);\
		\});\
		//view.value.postln;\
	\});\
	\
	\
waitStringView= StaticText(midiView, 400@20).resize_(5);\
\
setWaitString= \{|view|\
var a;\
a= view.value[0].collect(\{|it, i|\
	case\
	\{i == 0\} \{ (i.asString++"wait:"++((view.value[0][i+1]-view.value[0][i])*durationView.value).round(0.01)) \}\
	\{i == (view.value[0].size-1)\} \{ "end +"+(((view.value[0][i]-1).abs*durationView.value).round(0.01)) \}\
	\{i > 0\} \{ (i.asString++"wait:"++((view.value[0][i+1]-view.value[0][i])*durationView.value).round(0.01)) \}\
\
	\});\
waitStringView.string=  (a.asString);\
\};\
\
setWaitString.value(envView);\
*/\cf0 \
\
\
		\}, \{\
			\cf4 //"NOT making seq!".postln;\cf0 \
			\
	\cf4 //StaticText(midiView, Rect(0, 0, 300, 30)).string_("NOTE ON:").align_(\\center);\cf0 \
	midiNoteOnSlider= \cf8 EZSlider\cf0 (midiView, 392@30, \
		\cf6 "subm"\cf0 ,\
		[0, 300, \cf9 \\lin\cf0 , 1].asSpec,\
		initVal: properties[key][11][1][0], \
		numberWidth:60,\
		layout:\cf9 \\horz\cf0 )\
		.setColors(\cf8 Color\cf0 .grey,\cf8 Color\cf0 .white)\
		.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 ,20))\
		.action_(\{\cf2 |v|\cf0 \
			properties[key][11][1][0]= v.value;\
			properties[key][11][2][0]= v.value;\
			midiNoteOffSlider.value= v.value;\
		\});\
	midiNoteOnValSlider= \cf8 EZSlider\cf0 (midiView, 392@30, \
		\cf6 "val"\cf0 ,\
		[0, 100, \cf9 \\lin\cf0 , 1].asSpec,\
		initVal: properties[key][11][1][1], \
		numberWidth:60,\
		layout:\cf9 \\horz\cf0 )\
		.setColors(\cf8 Color\cf0 .grey,\cf8 Color\cf0 .white)\
		.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 ,20))\
		.action_(\{\cf2 |v|\cf0 \
			properties[key][11][1][1]= v.value;\
			if(testMIDI, \{\
				if(midiOut.isNil.not, \{\
					midiOut.sysex(\cf8 Int8Array\cf0 [0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][1][0], 0x00, properties[key][11][1][1], 0x00, 0xf7]);\
				\});\
			\});\
		\});\
\
\
	\
		\});\
\
		\
	\cf8 StaticText\cf0 (midiView, \cf8 Rect\cf0 (0, 0, 300, 30)).string_(\cf6 "NOTE OFF:"\cf0 ).align_(\cf9 \\center\cf0 );\
	midiNoteOffSlider= \cf8 EZSlider\cf0 (midiView, 392@30, \
		\cf6 "subm"\cf0 ,\
		[0, 300, \cf9 \\lin\cf0 , 1].asSpec,\
		initVal: properties[key][11][2][0], \
		numberWidth:60,\
		layout:\cf9 \\horz\cf0 )\
		.setColors(\cf8 Color\cf0 .grey,\cf8 Color\cf0 .white)\
		.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 ,20))\
		.action_(\{\cf2 |v|\cf0 \
			properties[key][11][2][0]= v.value;\
		\});\
	midiNoteOffValSlider= \cf8 EZSlider\cf0 (midiView, 392@30, \
		\cf6 "val"\cf0 ,\
		[0, 100, \cf9 \\lin\cf0 , 1].asSpec,\
		initVal: properties[key][11][2][1], \
		numberWidth:60,\
		layout:\cf9 \\horz\cf0 )\
		.setColors(\cf8 Color\cf0 .grey,\cf8 Color\cf0 .white)\
		.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 ,20))\
		.action_(\{\cf2 |v|\cf0 \
			properties[key][11][2][1]= v.value;\
			if(testMIDI, \{\
				if(midiOut.isNil.not, \{\
					midiOut.sysex(\cf8 Int8Array\cf0 [0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][2][0], 0x00, properties[key][11][2][1], 0x00, 0xf7]);\
				\});\
			\});\
		\});\
		\
	if(properties[key][11][3] == 1, \{\
		\cf8 StaticText\cf0 (midiView, \cf8 Rect\cf0 (0, 0, 70, 30))\
		.string_(\cf6 "Duration:"\cf0 );\
		\cf8 NumberBox\cf0 (midiView, \cf8 Rect\cf0 (0, 0, 100, 20))\
		.value_(properties[key][11][4])\
		.action_(\{\cf2 |v|\cf0  properties[key][11][4]= v.value \})\
		.clipLo_(0)\
		.clipHi_(1.5);\
	\});\
\
	\};\
	\
	makeNewMidiView.value;\
\
		\
\cf4 // ======== O S C =======\cf0 \
\
\cf4 // button to choose which host to send to\cf0 \
\cf4 //	when pressed check if handshake has been made if not make handshake\cf0 \
\cf4 //	use NetAddr, stored in Dict (its only sending so dont need much OSCfuncs)\cf0 \
\
\cf4 // for noteon and noteoff:\cf0 \
\
\cf4 // menu with relative options of \\symbols - commands\cf0 \
\cf4 // direct value or ramp to (fork?)\cf0 \
\
\
	t.views[1].decorator=\cf8 FlowLayout\cf0 (w.view.bounds);\
	t.views[1].decorator.gap=2@2;\
	\
	oscOnOffBut= \cf8 Button\cf0 (t.views[1], \cf8 Rect\cf0 (0, 0, 100, 30))\
	.canFocus_(\cf3 false\cf0 )\
	.states_([[\cf6 "OSC send OFF"\cf0 , \cf8 Color\cf0 .grey, \cf8 Color\cf0 .black], [\cf6 "OSC send ON"\cf0 , \cf8 Color\cf0 .green, \cf8 Color\cf0 .black]])\
	.value_(properties[key][15][0])\
	.action_(\{\cf2 |v|\cf0  \
		properties[key][15][0]= v.value;\
	\});\
\
\cf8 Button\cf0 (t.views[1], \cf8 Rect\cf0 (0, 0, 30, 30))\
.states_([[\cf6 "-"\cf0 ]])\
.canFocus_(\cf3 false\cf0 )\
.action_(\{\
	if (oscTab.views.size > 0, \{\
			properties[key][15][1].removeAt(oscTab.labels[oscTab.activeTab].asSymbol);\
			oscTab.removeAt(oscTab.activeTab);\
		\});\
\});\
\cf8 Button\cf0 (t.views[1], \cf8 Rect\cf0 (0, 0, 30, 30))\
.states_([[\cf6 "+"\cf0 ]])\
.canFocus_(\cf3 false\cf0 )\
.action_(\{\
	if(oscTab.labels.indexOfEqual(robotMenu.item.asString).isNil, \{\
		oscTab.add(robotMenu.item);\
		properties[key][15][1].add(robotMenu.item.deepCopy -> \cf5 ~robotDict\cf0 [robotMenu.item][2].deepCopy);\
		makeNewOscTab.value(oscTab.labels.size-1, robotMenu.item);\
	\}, \{\cf6 "Allready a Tab for this Robot!!"\cf0 .postln;\});\
\});\
robotMenu= \cf8 PopUpMenu\cf0 (t.views[1], \cf8 Rect\cf0 (0, 0, 100, 30))\
.items_(\cf5 ~robotDict\cf0 .keys.asArray.sort)\
.background_(\cf8 Color\cf0 .white)\
.canFocus_(\cf3 false\cf0 )\
.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 , 15));\
\
\cf8 Button\cf0 (t.views[1], \cf8 Rect\cf0 (0, 0, 80, 30))\
	.canFocus_(\cf3 false\cf0 )\
	.states_([[\cf6 "Rec OSC"\cf0 , \cf8 Color\cf0 .red, \cf8 Color\cf0 .black]])\
	.action_(\{\cf2 |v|\cf0  \
		recOSC.value;\
	\});\
\
t.views[1].decorator.nextLine;\
\
\
\
\cf4 // ============  OSC Load Save Menu  ============\cf0 \
\
saveDirectoryOSC= (\cf8 String\cf0 .scDir.dirname ++ \cf6 "/Resources/SENDWINSAVES/OSC/"\cf0 );\
\cf4 //saveDirectoryOSC= "/Users/martin/scwork/samplerProject/Sampler \\Central.app/Contents/Resources/SENDWINSAVES/OSC/";\cf0 \
\
		saveFilesOSC= (saveDirectoryOSC++\cf6 "*"\cf0 ).standardizePath.pathMatch;\
		\cf4 //saveDirectory.postln;\cf0 \
		\cf4 //saveFiles.postln;\cf0 \
		\cf8 StaticText\cf0 (t.views[1], 58@30).string_(\cf6 "save/load:"\cf0 ).align_(\cf9 \\left\cf0 );\
		loadMenuOSC= \cf8 PopUpMenu\cf0 (t.views[1], 100@20) \cf4 // -----\cf0 \
		.items_(saveFilesOSC.collect(\{\cf2 |it|\cf0  it.basename\}))\
		.canFocus_(\cf3 false\cf0 )\
		.background_(\cf8 Color\cf0 .white)\
		.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 , 10))\
		.action_(\{\cf2 |v|\cf0 \
			loadMenuItemOSC= v.items.at(v.value);\
			if(verbose, \{\
			loadMenuItemOSC.postln; \
			saveFilesOSC[loadMenuOSC.value].postln;\
			\});\
		\});\
		\cf4 //load preset\cf0 \
		\cf8 Button\cf0 (t.views[1], 20@20) \cf4 // ------\cf0 \
		.states_([[\cf6 "L"\cf0 , \cf8 Color\cf0 .red, \cf8 Color\cf0 .black]])\
		.canFocus_(\cf3 false\cf0 )\
		.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 , 10))\
		.action_(\{\
			\cf2 var\cf0  loadArray;\
			if (loadMenuItemOSC.isNil.not, \{ \
				\cf4 //this.load(saveFilesOSC[loadMenuOSC.value])\cf0 \
				\cf4 //("before load:"+properties[key][11]).postln;\cf0 \
				loadArray= \cf8 Object\cf0 .readArchive(saveFilesOSC[loadMenuOSC.value]);\
				properties[key][15][0]= loadArray[0];\
				oscOnOffBut.value= properties[key][15][0];\
				\cf4 // remove all tabs and properties\cf0 \
				(oscTab.views.size).do(\{\cf2 |it|\cf0 \
					\cf4 //properties[key][15][1].removeAt(oscTab[it].asSymbol);\cf0 \
					\cf4 // maybe properties[key][15][1]= Dictionary.new;\cf0 \
					oscTab.removeAt(it);\
				\});\
				properties[key][15][1]= loadArray[1].postln;\
				\
				properties[key][15][1].keysValuesDo(\{\cf2 |name, value, i|\cf0 \
					\cf2 var\cf0  seq= \cf3 false\cf0 ;\
					oscTab.add(name);\
					\cf4 //("checkit:"+properties[key][15][1][name][0]).postln;\cf0 \
					if(value[1] == 2, \{ seq= \cf3 true\cf0 \});\
					makeNewOscTab.value(i, name, seq); \cf4 //|i, label, seq= false|\cf0 \
				\});\
				\
				(\cf6 "after load:"\cf0 +properties[key][15]).postln;\
			\});\
		\});\
		\cf8 Button\cf0 (t.views[1], 30@20)\
		.states_([[\cf6 "qs"\cf0 ]])\
		.canFocus_(\cf3 false\cf0 )\
		.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 , 12))\
		.action_(\{ \
			\cf4 //this.save(saveDirectoryOSC+/+saveFilesOSC[loadMenuOSC.value]) \cf0 \
			properties[key][11].writeArchive(saveDirectoryOSC+/+saveFilesOSC[loadMenuOSC.value]);\
		\});\
		\cf8 Button\cf0 (t.views[1], 20@20)\
		.states_([[\cf6 "s"\cf0 ]])\
		.canFocus_(\cf3 false\cf0 )\
		.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 , 12))\
		.action_(\{\
			\cf4 //save preset\cf0 \
			\cf2 var\cf0  w, t, name, saveBut;\
				w= \cf8 Window\cf0 (\cf6 "save"\cf0 , \cf8 Rect\cf0 (400, 400, 230, 100), border: \cf3 false\cf0 )\
				.background_(\cf8 Color\cf0 .black)\
				.alwaysOnTop_(\cf3 true\cf0 );\
	\
				t= \cf8 TextView\cf0 (w, \cf8 Rect\cf0 (10, 10, 210, 20))\
				.focus(\cf3 true\cf0 )\
				.keyDownAction_(\{\cf2 |view, char, mod, uni, key|\cf0 \
					if(key == 36, \{ \{saveBut.valueAction= 1\}.defer; \});\
				\});\
				\
				saveBut= \cf8 Button\cf0 (w, \cf8 Rect\cf0 (10, 40, 100, 40))\
				.states_([[\cf6 "save"\cf0 ]])\
				.action_(\{\
					\cf2 var\cf0  values, path, stringSize;\
					stringSize= t.string.size;\
					if (stringSize > 0, \{\
						name= t.string;\
						path= saveDirectoryOSC+/+(name);\
						\cf4 //this.save(path);\cf0 \
						(\cf6 "saving this:"\cf0 +properties[key][15]).postln;\
						properties[key][15].writeArchive(path);\
						\cf4 //currentSaveFile= path;\cf0 \
						saveFilesOSC= (saveDirectoryOSC++\cf6 "*"\cf0 ).standardizePath.pathMatch;\
						\{loadMenuOSC.items= saveFilesOSC.collect(\{\cf2 |it|\cf0  it.basename.asSymbol\});\}.defer;\
						loadMenuOSC.value= loadMenuOSC.items.indexOf(name.asSymbol);\
						w.close;\
					\});\
				\});\
				\cf8 Button\cf0 (w, \cf8 Rect\cf0 (120, 40, 100, 40))\
				.states_([[\cf6 "cancel"\cf0 ]])\
				.action_(\{\
					w.close;\
				\});\
				w.front;\
		\});\
\
\
oscTab= \cf8 TabbedView\cf0 (t.views[1], \cf8 Rect\cf0 (0, 0, 400, 400), properties[key][15][1].keys, [\cf8 Color\cf0 .new255(158, 158, 158)]);\
\
properties[key][15][1].keysValuesDo(\{\cf2 |name, value, i|\cf0 \
	\cf2 var\cf0  seq= \cf3 false\cf0 ;\
	\cf2 var\cf0  durationView, waitStringView, setWaitString, envView;\
	\cf2 var\cf0  oscloadmenu, oscmenuitem, curOscRecName;\
	\
	if(value[1] == 2, \{ seq= \cf3 true\cf0 \});\
	\
	oscTab.views[i].decorator=\cf8 FlowLayout\cf0 (w.view.bounds);\
	oscTab.views[i].decorator.gap=2@2;\
	\
	oscTypeMenu= \cf8 PopUpMenu\cf0 (oscTab.views[i], 150@20)\
	.items_([\cf6 "single value"\cf0 , \cf6 "onset detect"\cf0 , \cf6 "sequencer"\cf0 , \cf6 "note on only"\cf0 , \cf6 "custom message"\cf0 ])\
	.background_(\cf8 Color\cf0 .white)\
	.canFocus_(\cf3 false\cf0 )\
	.value_(properties[key][15][1][name][1])\
	.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 , 15))\
	.action_(\{\cf2 |v|\cf0 \
		properties[key][15][1][name][1]= v.value.deepCopy;\
		case\
		\{v.value == 0\} \{\
			\cf4 //remove view\cf0 \
			oscTab.removeAt(oscTab.activeTab);\
			\cf4 //add view\cf0 \
			oscTab.add(name);\
			properties[key][15][1][name]= \cf5 ~robotDict\cf0 [name][2].deepCopy;\
			makeNewOscTab.value(oscTab.labels.size-1, name, \cf3 false\cf0 );\
			oscTab.focus(oscTab.labels.size-1);\
			\}\
		\{v.value == 1\} \{\
			properties[key][15][1][name]= \cf5 ~robotDict\cf0 [name][2].deepCopy;\
			properties[key][15][1][name][1]= v.value;\
			\cf4 //remove view\cf0 \
			oscTab.removeAt(oscTab.activeTab);\
			\cf4 //add view\cf0 \
			oscTab.add(name);\
			makeNewOscTab.value(oscTab.labels.size-1, name, \cf3 false\cf0 );\
			oscTab.focus(oscTab.labels.size-1);\
			\}\
		\{v.value == 2\} \{\
			\cf4 //remove view\cf0 \
			oscTab.removeAt(oscTab.activeTab);\
			\cf4 //add view\cf0 \
			oscTab.add(name);\
			properties[key][15][1][name]= [[\cf6 "none"\cf0 , 90], 2, a.length((\cf6 "snd"\cf0 ++(key).asString).asSymbol), 95];\
			(\cf6 "sound length:"\cf0 +a.length((\cf6 "snd"\cf0 ++(key).asString).asSymbol)).postln;\
			\cf4 //("making seq with these props:"+properties[key][15][1][name]).postln;\cf0 \
			makeNewOscTab.value(oscTab.labels.size-1, name, \cf3 true\cf0 );\
			oscTab.focus(oscTab.labels.size-1);\
			\}\
		\{v.value == 3\} \{\
			\cf4 //remove view\cf0 \
			oscTab.removeAt(oscTab.activeTab);\
			\cf4 //add view\cf0 \
			oscTab.add(name);\
			properties[key][15][1][name]= \cf5 ~robotDict\cf0 [name][2].deepCopy;\
			properties[key][15][1][name][1]= v.value;\
			makeNewOscTab.value(oscTab.labels.size-1, name, \cf3 false\cf0 );\
			oscTab.focus(oscTab.labels.size-1);\
			\}\
		\{v.value == 4\} \{\
			\cf4 //remove view\cf0 \
			oscTab.removeAt(oscTab.activeTab);\
			\cf4 //add view\cf0 \
			oscTab.add(name);\
			properties[key][15][1][name]= \cf5 ~robotDict\cf0 [name][2].deepCopy;\
			properties[key][15][1][name][1]= v.value;\
			makeNewOscTab.value(oscTab.labels.size-1, name, \cf3 false\cf0 );\
			oscTab.focus(oscTab.labels.size-1);\
			\}\
			;\
	\});\
	\
	\cf8 StaticText\cf0 (oscTab.views[i], \cf8 Rect\cf0 (0, 0, 400, 30)).string_(\cf6 "NOTE ON:"\cf0 ).align_(\cf9 \\center\cf0 );\
	\
	if(seq, \{\
		\cf4 //"making seq".postln; value[0].postln;\cf0 \
\
	\
	\
\cf4 //oscfilesDir= "/Users/martin/Desktop/OSCRecordings/";\cf0 \
oscfiles= (oscfilesDir++\cf6 "*"\cf0 ).standardizePath.pathMatch;\
oscsavefiles= oscfiles.addFirst(\cf6 "none"\cf0 );\
oscfiles= oscfiles.addFirst(\cf6 "none"\cf0 );\
oscsavefiles= oscsavefiles.collect(\{\cf2 |it|\cf0  it.basename\});\
oscloadmenu= \cf8 PopUpMenu\cf0 (oscTab.views[i], 300@40)\
.canFocus_(\cf3 true\cf0 )\
.stringColor_(\cf8 Color\cf0 .green)\
.background_(\cf8 Color\cf0 .red.alpha_(0.5))\
.items_( oscsavefiles )\
.action_(\{ \cf2 |v|\cf0 \
	oscmenuitem= v.items.at(v.value);\
	\cf4 //menuitem.postln;\cf0 \
	\cf4 //files[loadmenu.value].postln;\cf0 \
	\cf4 //("menu size:"+loadmenu.items.size).postln;\cf0 \
	\cf4 //("files size:"+files.size).postln;\cf0 \
	\cf4 //("loadmenu fileS:"+loadmenu.items).postcs;\cf0 \
	\cf4 //("files fileS:"+files).postcs;\cf0 \
\})\
.canReceiveDragHandler_(\cf3 true\cf0 )\
.receiveDragHandler_(\{\cf2 |view|\cf0 \
	\cf8 View\cf0 .currentDrag.postln;\
	\cf8 View\cf0 .currentDrag.copyTo(oscfilesDir, overwrite: \cf3 true\cf0 );\
	curOscRec= oscfilesDir+/+(\cf8 View\cf0 .currentDrag.basename);\
	properties[key][15][1][name][0][0]= curOscRec;\
	curOscRecName.string= curOscRec.basename;\
\});\
oscmenuitem= properties[key][15][1][name][0][0];\
	\
	\cf4 //list of recordings\cf0 \
\
	\
	\cf4 //button sets recording\cf0 \
\cf8 Button\cf0 (oscTab.views[i], 40@30).states_([[\cf6 "L"\cf0 , \cf8 Color\cf0 .red, \cf8 Color\cf0 .black]])\
.action_(\{\
	if (oscmenuitem == \cf6 "none"\cf0 , \{\cf3 nil\cf0 \}, \{\
		\cf4 //("loading"+files[loadmenu.value]).postln;\cf0 \
		\cf4 //values= Object.readArchive(files[loadmenu.value]);\cf0 \
		curOscRec= oscfilesDir++oscloadmenu.item;\
		curOscRecName.string= oscloadmenu.item;\
		properties[key][15][1][name][0][0]= curOscRec;\
		\
		\})\
\})\
.canReceiveDragHandler_(\cf3 true\cf0 )\
.receiveDragHandler_(\{\cf2 |view|\cf0 \
	\cf8 View\cf0 .currentDrag.postln;\
	\cf8 View\cf0 .currentDrag.copyTo(oscfilesDir, overwrite: \cf3 true\cf0 );\
	curOscRec= oscfilesDir+/+(\cf8 View\cf0 .currentDrag.basename);\
	properties[key][15][1][name][0][0]= curOscRec;\
	curOscRecName.string= curOscRec.basename;\
\});\
	properties[key][15][1][name][0][0].basename.postln;\
	\cf4 //text display current recording to play\cf0 \
curOscRecName= \cf8 StaticText\cf0 (oscTab.views[i], 300@40).string_(\cf6 "none"\cf0 );\
	if (properties[key][15][1][name][0][0].isNil.not, \{\
		curOscRecName.string= (properties[key][15][1][name][0][0].basename);\
		\});\
\
		\}, \{\
			\cf4 //"NOT making seq!".postln;\cf0 \
	\cf8 EZSlider\cf0 (oscTab.views[i], 392@30, \
		name, \cf4 // label\cf0 \
		\cf5 ~robotDict\cf0 [name][1], \cf4 // control spec\cf0 \
		initVal: value[0][0], \
		numberWidth:60,\
		layout:\cf9 \\horz\cf0 )\
		.setColors(\cf8 Color\cf0 .grey,\cf8 Color\cf0 .white)\
		.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 ,20))\
		.action_(\{\cf2 |v|\cf0 \
			properties[key][15][1][name][0][0]= v.value;\
		\});\
\
	\});\
		\
	\cf8 StaticText\cf0 (oscTab.views[i], \cf8 Rect\cf0 (0, 0, 300, 30)).string_(\cf6 "NOTE OFF:"\cf0 ).align_(\cf9 \\center\cf0 );\
	\cf8 EZSlider\cf0 (oscTab.views[i], 392@30, \
		name, \cf4 // label\cf0 \
		\cf5 ~robotDict\cf0 [name][1], \cf4 // control spec\cf0 \
		initVal: properties[key][15][1][name][0][1], \cf4 // init value \cf0 \
		numberWidth:60,\
		layout:\cf9 \\horz\cf0 )\
		.setColors(\cf8 Color\cf0 .grey,\cf8 Color\cf0 .white)\
		.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 ,20))\
		.action_(\{\cf2 |v|\cf0 \
				properties[key][15][1][name][0][1]= v.value;\
		\});\
		\
	\
\
\});\
\
makeNewOscTab= \{\cf2 |i, label, seq= false|\cf0 \
	\cf2 var\cf0  durationView, waitStringView, setWaitString, envView;\
	\cf2 var\cf0  oscloadmenu, oscmenuitem, curOscRecName;\
	\
	oscTab.views[i].decorator=\cf8 FlowLayout\cf0 (w.view.bounds);\
	oscTab.views[i].decorator.gap=2@2;\
\
	oscTypeMenu= \cf8 PopUpMenu\cf0 (oscTab.views[i], 150@20)\
	.items_([\cf6 "single value"\cf0 , \cf6 "onset detect"\cf0 , \cf6 "sequencer"\cf0 , \cf6 "note on only"\cf0 , \cf6 "custom"\cf0 ])\
	.value_(properties[key][15][1][label][1])\
	.background_(\cf8 Color\cf0 .white)\
	.canFocus_(\cf3 false\cf0 )\
	.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 , 15))\
	.action_(\{\cf2 |v|\cf0 \
		\cf2 var\cf0  val;\
		val= v.value;\
		properties[key][15][1][label][1]= v.value;\
		case\
		\{v.value == 0\} \{ \cf4 // single value\cf0 \
			\cf4 //remove view\cf0 \
			oscTab.removeAt(oscTab.activeTab);\
			\cf4 //add view\cf0 \
			oscTab.add(label);\
			properties[key][15][1][label]= \cf5 ~robotDict\cf0 [label][2].deepCopy;\
			\cf4 //properties[key][15][1][label][1]= 0;\cf0 \
			makeNewOscTab.value(oscTab.labels.size-1, label, \cf3 false\cf0 );\
			oscTab.focus(oscTab.labels.size-1);\
			\}\
		\{v.value == 1\} \{ \cf4 // onset detection (coyote)\cf0 \
			properties[key][15][1][label]= \cf5 ~robotDict\cf0 [label][2].deepCopy;\
			properties[key][15][1][label][1]= v.value.deepCopy;\
			\cf4 //remove view\cf0 \
			oscTab.removeAt(oscTab.activeTab);\
			\cf4 //add view\cf0 \
			oscTab.add(label);\
			makeNewOscTab.value(oscTab.labels.size-1, label, \cf3 false\cf0 );\
			oscTab.focus(oscTab.labels.size-1);\
			\}\
		\{v.value == 2\} \{ \cf4 // play osc recording (sequencer)\cf0 \
			\cf4 //remove view\cf0 \
			oscTab.removeAt(oscTab.activeTab);\
			\cf4 //add view\cf0 \
			oscTab.add(label);\
			properties[key][15][1][label]= [[\cf6 "none"\cf0 , \cf5 ~robotDict\cf0 [label][2][0][1]], 2, 90, 95];\
			(\cf6 "sound length:"\cf0 +a.length((\cf6 "snd"\cf0 ++(key).asString).asSymbol)).postln;\
			\cf4 //properties[key][15][1][label][1]= [[0.0, 0.5], [0.1, 0.8]];\cf0 \
			\cf4 //("making seq with these props:"+properties[key][15][1][label]).postln;\cf0 \
			makeNewOscTab.value(oscTab.labels.size-1, label, \cf3 true\cf0 );\
			oscTab.focus(oscTab.labels.size-1);\
			\}\
		\{v.value == 3\} \{ \cf4 // noteon only\cf0 \
			\cf4 //remove view\cf0 \
			oscTab.removeAt(oscTab.activeTab);\
			\cf4 //add view\cf0 \
			oscTab.add(label);\
			properties[key][15][1][label]= \cf5 ~robotDict\cf0 [label][2].deepCopy;\
			\cf4 //properties[key][15][1][label][1]= 0;\cf0 \
			makeNewOscTab.value(oscTab.labels.size-1, label, \cf3 false\cf0 );\
			oscTab.focus(oscTab.labels.size-1);\
			\}\
		\{v.value == 4\} \{ \cf4 // custom message\cf0 \
			\cf4 //remove view\cf0 \
			oscTab.removeAt(oscTab.activeTab);\
			\cf4 //add view\cf0 \
			oscTab.add(label);\
			properties[key][15][1][label]= \cf5 ~robotDict\cf0 [label][2].deepCopy;\
			properties[key][15][1][label][1]= v.value.deepCopy;\
			makeNewOscTab.value(oscTab.labels.size-1, label, \cf3 false\cf0 );\
			oscTab.focus(oscTab.labels.size-1);\
			\};\
	\});\
	\
	\cf8 StaticText\cf0 (oscTab.views[i], \cf8 Rect\cf0 (0, 0, 400, 30)).string_(\cf6 "NOTE ON:"\cf0 ).align_(\cf9 \\center\cf0 );\
	\
	if(seq, \{\
		\cf4 //"making seq".postln;\cf0 \
		\
		\
\cf4 //oscfilesDir= "/Users/martin/Desktop/OSCRecordings/";\cf0 \
oscfiles= (oscfilesDir++\cf6 "*"\cf0 ).standardizePath.pathMatch;\
oscsavefiles= oscfiles.addFirst(\cf6 "none"\cf0 );\
oscfiles= oscfiles.addFirst(\cf6 "none"\cf0 );\
oscsavefiles= oscsavefiles.collect(\{\cf2 |it|\cf0  it.basename\});\
oscloadmenu= \cf8 PopUpMenu\cf0 (oscTab.views[i], 300@40)\
.canFocus_(\cf3 false\cf0 )\
.stringColor_(\cf8 Color\cf0 .green)\
.background_(\cf8 Color\cf0 .red.alpha_(0.5))\
.items_( oscsavefiles )\
.action_(\{ \cf2 |v|\cf0 \
	oscmenuitem= v.items.at(v.value);\
	oscmenuitem.postln;\
	oscfiles[oscloadmenu.value].postln;\
	\cf4 //("menu size:"+loadmenu.items.size).postln;\cf0 \
	\cf4 //("files size:"+files.size).postln;\cf0 \
	\cf4 //("loadmenu fileS:"+loadmenu.items).postcs;\cf0 \
	\cf4 //("files fileS:"+files).postcs;\cf0 \
\})\
.canReceiveDragHandler_(\cf3 true\cf0 )\
.receiveDragHandler_(\{\cf2 |view|\cf0 \
	\cf8 View\cf0 .currentDrag.postln;\
	\cf8 View\cf0 .currentDrag.copyTo(oscfilesDir, overwrite: \cf3 true\cf0 );\
	curOscRec= oscfilesDir+/+(\cf8 View\cf0 .currentDrag.basename);\
	properties[key][15][1][label][0][0]= curOscRec;\
	curOscRecName.string= curOscRec.basename;\
\});\
oscmenuitem= properties[key][15][1][label][0][0];\
	\
	\cf4 //list of recordings\cf0 \
\
	\
	\cf4 //button sets recording\cf0 \
	\cf8 Button\cf0 (oscTab.views[i], 40@30).states_([[\cf6 "L"\cf0 , \cf8 Color\cf0 .red, \cf8 Color\cf0 .black]])\
	.action_(\{\
	if (oscmenuitem == \cf6 "none"\cf0 , \{\cf3 nil\cf0 \}, \{\
		\cf4 //("loading"+files[loadmenu.value]).postln;\cf0 \
		\cf4 //values= Object.readArchive(files[loadmenu.value]);\cf0 \
		curOscRec= oscfilesDir++oscloadmenu.item;\
		curOscRecName.string= oscloadmenu.item;\
		properties[key][15][1][label][0][0]= curOscRec;\
		\
		\})\
	\});\
	\cf4 //text display current recording to play\cf0 \
	curOscRecName= \cf8 StaticText\cf0 (oscTab.views[i], 300@40).string_(\cf6 "none"\cf0 );\
	if (properties[key][15][1][label][0][0].isNil.not, \{\
		curOscRecName.string= (properties[key][15][1][label][0][0].basename);\
		\});\
	\
	\cf8 Button\cf0 (oscTab.views[i], 120@20).states_([[\cf6 "open in editor"\cf0 ]])\
	.action_(\{\
	if (oscmenuitem == \cf6 "none"\cf0 , \{\cf3 nil\cf0 \}, \{\
		\cf4 //("loading"+files[loadmenu.value]).postln;\cf0 \
		\cf4 //values= Object.readArchive(files[loadmenu.value]);\cf0 \
		curOscRec= oscfilesDir++oscloadmenu.item;\
		curOscRecName.string= oscloadmenu.item;\
		oscPlotter= \cf8 OSCFileLogPlotter\cf0 .new(curOscRec, \cf8 NetAddr\cf0 (\cf5 ~ipDict\cf0 [label][0],\cf5 ~ipDict\cf0 [label][1]));\
		oscPlotter.loadSoundFile(sounds[key]);\
		\
		\})\
	\});\
	\
	\cf8 Button\cf0 (oscTab.views[i], 120@20).states_([[\cf6 "reveal in finder"\cf0 ]])\
	.action_(\{\
	if (oscmenuitem == \cf6 "none"\cf0 , \{\cf3 nil\cf0 \}, \{\
		\cf4 //("loading"+files[loadmenu.value]).postln;\cf0 \
		\cf4 //values= Object.readArchive(files[loadmenu.value]);\cf0 \
		curOscRec= oscfilesDir++oscloadmenu.item;\
		curOscRecName.string= oscloadmenu.item;\
		curOscRec.revealInFinder;\
		\})\
	\});\
\
\}, \{\
			\cf4 //"NOT making seq!".postln;\cf0 \
	if(properties[key][15][1][label][1] == 4, \{ \cf4 // custom message note on\cf0 \
		\cf8 TextField\cf0 (oscTab.views[i], 392@30)\
		.string_(properties[key][15][1][label][0][0])\
		.action_(\{\cf2 |v|\cf0  properties[key][15][1][label][0][0]= v.value; \});\
		\
	\},\{ \cf4 //normal note on single value note on\cf0 \
		\cf8 EZSlider\cf0 (oscTab.views[i], 392@30, \
			\cf5 ~robotDict\cf0 [label.asSymbol][0], \cf4 // label\cf0 \
			\cf5 ~robotDict\cf0 [label.asSymbol][1], \cf4 // control spec\cf0 \
			initVal: \cf5 ~robotDict\cf0 [label.asSymbol][2][0][0], \
			numberWidth:60,\
			layout:\cf9 \\horz\cf0 )\
			.setColors(\cf8 Color\cf0 .grey,\cf8 Color\cf0 .white)\
			.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 ,20))\
			.action_(\{\cf2 |v|\cf0 \
				properties[key][15][1][label][0][0]= v.value;\
			\});\
		\});\
	\
		\});\
\
	\cf8 StaticText\cf0 (oscTab.views[i], \cf8 Rect\cf0 (0, 0, 300, 30)).string_(\cf6 "NOTE OFF:"\cf0 ).align_(\cf9 \\center\cf0 );\
	\
	if(properties[key][15][1][label][1] == 4, \{ \cf4 // custom message note off\cf0 \
		\cf8 TextField\cf0 (oscTab.views[i], 392@30)\
		.string_(properties[key][15][1][label][0][1])\
		.action_(\{\cf2 |v|\cf0  properties[key][15][1][label][0][1]= v.value; \});\
		\
	\},\{ \cf4 //normal note on single value note off\cf0 \
	\cf8 EZSlider\cf0 (oscTab.views[i], 392@30, \
		\cf5 ~robotDict\cf0 [label.asSymbol][0], \cf4 // label\cf0 \
		\cf5 ~robotDict\cf0 [label.asSymbol][1], \cf4 // control spec\cf0 \
		initVal: properties[key][15][1][label][0][1], \cf4 // init value\cf0 \
		numberWidth:60,\
		layout:\cf9 \\horz\cf0 )\
		.setColors(\cf8 Color\cf0 .grey,\cf8 Color\cf0 .white)\
		.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 ,20))\
		.action_(\{\cf2 |v|\cf0 \
			properties[key][15][1][label][0][1]= v.value;\
		\});\
	\});\
		\
	if(properties[key][15][1][label][1] == 1, \{\
		\cf8 StaticText\cf0 (oscTab.views[i], \cf8 Rect\cf0 (0, 0, 70, 30))\
		.string_(\cf6 "Duration:"\cf0 );\
		\cf8 NumberBox\cf0 (oscTab.views[i], \cf8 Rect\cf0 (0, 0, 100, 20))\
		.value_(properties[key][15][1][label][2])\
		.action_(\{\cf2 |v|\cf0  properties[key][15][1][label][2]= v.value \})\
		.clipLo_(0)\
		.clipHi_(1.5);\
	\});\
\
	\};\
\
\
\cf4 // record OSC GUI\cf0 \
recOSC= \{\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf2 var\cf0  w, win, recbut, rec, stop, timelog, oscplayer, n, playbut, play, stopplay;\
\cf2 var\cf0  clockGUI, recPath, recFolder;\
\cf2 var\cf0  ipText, portText, nameText;\
\
recPath= oscfilesDir+/+\cf6 "robotOSCTest/"\cf0 ;\
recFolder= oscfilesDir;\
\
win= \cf8 Window\cf0 (\cf6 "Record OSC"\cf0 , \cf8 Rect\cf0 (0, 0, 270, 300));\
w= \cf8 CompositeView\cf0 (win, \cf8 Rect\cf0 (0, 0, 270, 300));\
w.decorator = \cf8 FlowLayout\cf0 (w.bounds);\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf8 StaticText\cf0 (w, \cf8 Rect\cf0 (10, 10, 50, 20)).string_(\cf6 "name:"\cf0 );\
nameText= \cf8 TextField\cf0 (w, \cf8 Rect\cf0 (10, 10, 200, 20))\
.string_(\cf6 "RobotOSCTest"\cf0 );\
\cf4 //.action_(\{arg field; recPath= (recFolder++field.value) \});\cf0 \
\
w.decorator.nextLine;\
w.decorator.nextLine;\
w.decorator.nextLine;\
\
recbut= \cf8 Button\cf0 .new(w,\cf8 Rect\cf0 (20, 10, 260, 40))\
	.states_([ [ \cf6 "rec"\cf0 , \cf8 Color\cf0 .black, \cf8 Color\cf0 .red ], [ \cf6 "stop"\cf0 , \cf8 Color\cf0 .white, \cf8 Color\cf0 .blue] ])\
	.action_\{\cf2 |v|\cf0 \
		case \
		\{v.value == 1\} \{rec.value\}\
		\{v.value == 0\} \{stop.value\};\
		\};\
\
rec= \{\
	oscRecording= \cf3 true\cf0 ;\
	recPath= recFolder++nameText.string;\
	recPath.postln;\
	\
	timelog= \cf8 OSCFileLog\cf0 .new( recPath );\
	\cf4 //n = NetAddr.new( "localhost", NetAddr.langPort );\cf0 \
	\
	clockGUI.reset;\
	clockGUI.play;\
	\cf4 /*\
	Task(\{ 5.do\{\
		n.sendMsg("SR1120");\
		2.0.rand.min(0.8).wait;\
		n.sendMsg("SR190");\
		2.0.rand.min(0.8).wait;\
	\}\}).play;\
	*/\cf0 \
	\};\
	\
stop= \{\
	oscRecording= \cf3 false\cf0 ;\
	timelog.close;\
	clockGUI.pause;\
	\};\
\
clockGUI= \cf8 ClockGUI\cf0 .new(w, \cf8 Rect\cf0 (20, 40, 260, 100));\
\
\cf8 StaticText\cf0 (w, \cf8 Rect\cf0 (10, 10, 50, 20)).string_(\cf6 "send to:"\cf0 );\
ipText= \cf8 TextField\cf0 (w, \cf8 Rect\cf0 (10, 10, 100, 20)).string_(\cf6 "172.16.3.179"\cf0 );\
\cf8 StaticText\cf0 (w, \cf8 Rect\cf0 (10, 10, 30, 20)).string_(\cf6 "port:"\cf0 );\
portText= \cf8 TextField\cf0 (w, \cf8 Rect\cf0 (10, 10, 50, 20)).string_(\cf6 "8888"\cf0 );\
\cf8 Button\cf0 (w, \cf8 Rect\cf0 (10, 10, 50, 20)).states_([[\cf6 "set"\cf0 ]])\
.action_(\{\
	n = \cf8 NetAddr\cf0 .new(ipText.string, portText.string.interpret);\
	\});\
\
playbut= \cf8 Button\cf0 .new(w,\cf8 Rect\cf0 (20, 10, 260, 40))\
	.states_([ [ \cf6 "play"\cf0 , \cf8 Color\cf0 .black, \cf8 Color\cf0 .grey ], [ \cf6 "stop"\cf0 , \cf8 Color\cf0 .white, \cf8 Color\cf0 .green] ])\
	.action_\{\cf2 |v|\cf0 \
		case \
		\{v.value == 1\} \{play.value\}\
		\{v.value == 0\} \{stopplay.value\};\
		\};\
\
play= \{\
	n = \cf8 NetAddr\cf0 .new(\cf6 "172.16.3.179"\cf0 , 8888);\
	\cf4 //n = NetAddr.new( "localhost", NetAddr.langPort );\cf0 \
	\cf8 OSCFunc\cf0 .trace( \cf3 true\cf0  );\
	oscplayer = \cf8 OSCFileLogPlayer\cf0 .new(timelog.timelogfile.pathDir, n, \{ playbut.valueAction= 0 \} );\
	oscplayer.play;\
	\};\
\
stopplay= \{\
	oscplayer.stop;\
	oscplayer.close;\
	\cf8 OSCFunc\cf0 .trace( \cf3 false\cf0  );\
	\};\
win.front;\
	\
	\
	\
	\};\
\
\
\
\
\
\cf4 // =============== D M X ==================\cf0 \
\
	t.views[2].decorator=\cf8 FlowLayout\cf0 (w.view.bounds);\
	t.views[2].decorator.gap=2@2;\
\
\
	dmxOnOffBut= \cf8 Button\cf0 (t.views[2], \cf8 Rect\cf0 (0, 0, 60, 20))\
	.canFocus_(\cf3 false\cf0 )\
	.states_([[\cf6 "DMX OFF"\cf0 , \cf8 Color\cf0 .grey, \cf8 Color\cf0 .black], [\cf6 "DMX ON"\cf0 , \cf8 Color\cf0 .green, \cf8 Color\cf0 .black]])\
	.value_(properties[key][16][0])\
	.action_(\{\cf2 |v|\cf0  \
		properties[key][16][0]= v.value;\
	\});\
	\
\cf8 Button\cf0 (t.views[2], \cf8 Rect\cf0 (0, 0, 60, 20))\
.canFocus_(\cf3 false\cf0 )\
.states_([[\cf6 "rcv Dump"\cf0 , \cf8 Color\cf0 .white, \cf8 Color\cf0 .black], [\cf6 "rcv Dump"\cf0 , \cf8 Color\cf0 .green, \cf8 Color\cf0 .black]])\
.action_(\{\cf2 |v|\cf0 \
	if(v.value == 1, \{\
		\cf4 //somehow receive dmx\cf0 \
		\}, \{\
		\cf4 // stop that somehow\cf0 \
		\});\
\});\
\
\cf8 Button\cf0 (t.views[2], \cf8 Rect\cf0 (0, 0, 30, 20))\
.canFocus_(\cf3 false\cf0 )\
.states_([[\cf6 "tst"\cf0 , \cf8 Color\cf0 .white, \cf8 Color\cf0 .black], [\cf6 "tst"\cf0 , \cf8 Color\cf0 .green, \cf8 Color\cf0 .black]])\
.action_(\{\cf2 |v|\cf0 \
	if(v.value == 1, \{testDMX= \cf3 true\cf0 \}, \{testDMX= \cf3 false\cf0 \});\
\});\
\
\
\cf4 // ============  DMX Load Save Menu  ============\cf0 \
\
saveDirectoryDMX= (\cf8 String\cf0 .scDir.dirname ++ \cf6 "/Resources/SENDWINSAVES/DMX/"\cf0 );\
\cf4 //saveDirectoryDMX= "/Users/martin/scwork/samplerProject/Sampler \\Central.app/Contents/Resources/SENDWINSAVES/DMX/";\cf0 \
\
		saveFilesDMX= (saveDirectoryDMX++\cf6 "*"\cf0 ).standardizePath.pathMatch;\
		\cf4 //saveDirectory.postln;\cf0 \
		\cf4 //saveFiles.postln;\cf0 \
		\cf8 StaticText\cf0 (t.views[2], 58@30).string_(\cf6 "save/load:"\cf0 ).align_(\cf9 \\left\cf0 );\
		loadMenuDMX= \cf8 PopUpMenu\cf0 (t.views[2], 100@20) \cf4 // -----\cf0 \
		.items_(saveFilesDMX.collect(\{\cf2 |it|\cf0  it.basename\}))\
		.canFocus_(\cf3 false\cf0 )\
		.background_(\cf8 Color\cf0 .white)\
		.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 , 10))\
		.action_(\{\cf2 |v|\cf0 \
			loadMenuItemDMX= v.items.at(v.value);\
			if(verbose, \{\
			\cf4 //loadMenuItemDMX.postln; \cf0 \
			\cf4 //saveFilesDMX[loadMenuDMX.value].postln;\cf0 \
			\});\
		\});\
		\cf4 //load preset\cf0 \
		\cf8 Button\cf0 (t.views[2], 20@20) \cf4 // ------\cf0 \
		.states_([[\cf6 "L"\cf0 , \cf8 Color\cf0 .red, \cf8 Color\cf0 .black]])\
		.canFocus_(\cf3 false\cf0 )\
		.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 , 10))\
		.action_(\{ \
			\cf2 var\cf0  loadArray;\
			if (loadMenuItemDMX.isNil.not, \{ \
				\cf4 //this.load(saveFilesDMX[loadMenuDMX.value])\cf0 \
				\cf4 //("before load:"+properties[key][16]).postln;\cf0 \
				loadArray= \cf8 Object\cf0 .readArchive(saveFilesDMX[loadMenuDMX.value]);\
				\cf4 //saveFilesDMX[loadMenuDMX.value].postln;\cf0 \
				\cf4 //("loadArray:"+loadArray).postln;\cf0 \
				properties[key][16][0]= loadArray[0];\
				dmxOnOffBut.value= properties[key][16][0];\
				properties[key][16][1][0]= \cf8 DMXSubCue\cf0 .new;\
				properties[key][16][1][1]= \cf8 DMXSubCue\cf0 .new;\
				loadArray[1][0][0].do(\{\cf2 |it, i|\cf0  properties[key][16][1][0].put(it, loadArray[1][0][1][i]) \});\
				loadArray[1][1][0].do(\{\cf2 |it, i|\cf0  properties[key][16][1][1].put(it, loadArray[1][1][1][i]) \});\
				\
				\cf4 //("after load:"+properties[key][16]).postln;\cf0 \
				updateDmxNoteOnView.value;\
				updateDmxNoteOffView.value;\
				\
			\});\
		\});\
		\cf8 Button\cf0 (t.views[2], 30@20)\
		.states_([[\cf6 "qs"\cf0 ]])\
		.canFocus_(\cf3 false\cf0 )\
		.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 , 12))\
		.action_(\{\
			\cf2 var\cf0  noteOnChans, noteOnVal, noteOffChans, noteOffVals, saveArray;\
			\cf4 //this.save(saveDirectoryDMX+/+saveFilesDMX[loadMenuDMX.value]) \cf0 \
			\cf4 //noteOnChans= properties[key][16][1][0].data.indices.collect(\{|it| it\})\cf0 \
			saveArray= [properties[key][16][0], [[properties[key][16][1][0].data.indices, properties[key][16][1][0].data], [properties[key][16][1][1].data.indices, properties[key][16][1][1].data]]];\
			\cf4 //saveArray= [properties[key][16][0], [properties[key][16][1][0].indices, properties[key][16][1][0].data, properties[key][16][1][1].indices, properties[key][16][1][1].data ]]\cf0 \
			saveArray.writeArchive(saveDirectoryDMX+/+saveFilesDMX[loadMenuDMX.value]);\
		\});\
		\cf8 Button\cf0 (t.views[2], 20@20)\
		.states_([[\cf6 "s"\cf0 ]])\
		.canFocus_(\cf3 false\cf0 )\
		.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 , 12))\
		.action_(\{\
			\cf4 //save preset\cf0 \
			\cf2 var\cf0  w, t, name, saveBut;\
				w= \cf8 Window\cf0 (\cf6 "save"\cf0 , \cf8 Rect\cf0 (400, 400, 230, 100), border: \cf3 false\cf0 )\
				.background_(\cf8 Color\cf0 .black)\
				.alwaysOnTop_(\cf3 true\cf0 );\
	\
				t= \cf8 TextView\cf0 (w, \cf8 Rect\cf0 (10, 10, 210, 20))\
				.focus(\cf3 true\cf0 )\
				.keyDownAction_(\{\cf2 |view, char, mod, uni, key|\cf0 \
					if(key == 36, \{ \{saveBut.valueAction= 1\}.defer; \});\
				\});\
				\
				saveBut= \cf8 Button\cf0 (w, \cf8 Rect\cf0 (10, 40, 100, 40))\
				.states_([[\cf6 "save"\cf0 ]])\
				.action_(\{\
					\cf2 var\cf0  values, path, stringSize;\
					\cf2 var\cf0  saveArray;\
					\
					stringSize= t.string.size;\
					if (stringSize > 0, \{\
						name= t.string;\
						path= saveDirectoryDMX+/+(name);\
						saveArray= [properties[key][16][0], [[properties[key][16][1][0].data.indices, properties[key][16][1][0].data.asArray], [properties[key][16][1][1].data.indices, properties[key][16][1][1].data.asArray]]];\
						\cf4 //this.save(path);\cf0 \
						\cf4 //("saving this:"+saveArray).postln;\cf0 \
						saveArray.writeArchive(path);\
						\cf4 //currentSaveFile= path;\cf0 \
						saveFilesDMX= (saveDirectoryDMX++\cf6 "*"\cf0 ).standardizePath.pathMatch;\
						\{loadMenuDMX.items= saveFilesDMX.collect(\{\cf2 |it|\cf0  it.basename.asSymbol\});\}.defer;\
						loadMenuDMX.value= loadMenuDMX.items.indexOf(name.asSymbol);\
						w.close;\
					\});\
				\});\
				\cf8 Button\cf0 (w, \cf8 Rect\cf0 (120, 40, 100, 40))\
				.states_([[\cf6 "cancel"\cf0 ]])\
				.action_(\{\
					w.close;\
				\});\
				w.front;\
		\});\
		\
t.views[2].decorator.nextLine;\
\
\
	\cf8 StaticText\cf0 (t.views[2], \cf8 Rect\cf0 (0, 0, 400, 30)).string_(\cf6 "NOTE ON:"\cf0 ).align_(\cf9 \\center\cf0 );\
\
\cf8 Button\cf0 (t.views[2], \cf8 Rect\cf0 (0, 0, 30, 20))\
.states_([[\cf6 "-"\cf0 ]])\
.canFocus_(\cf3 false\cf0 )\
.action_(\{\
	if (dmxNoteOnSliders.size > 0, \{\
			properties[key][16][1][0].data.removeAtSlot(dmxNoteOnViewSelect.value);\
			dmxNoteOnViewSelect.value= 0;\
			dmxNoteOnViewSelect.clipHi= (properties[key][16][1][0].data.size-1);\
			updateDmxNoteOnView.value;\
		\});\
	\cf4 //also remove noteoff\cf0 \
	if(addBlack, \{\
		if (dmxNoteOffSliders.size > 0, \{\
			properties[key][16][1][1].data.removeAtSlot(dmxNoteOffViewSelect.value);\
			dmxNoteOffViewSelect.value= 0;\
			dmxNoteOffViewSelect.clipHi= (properties[key][16][1][1].data.size-1);\
			updateDmxNoteOffView.value;\
		\});\
	\});\
\});\
\
\
dmxNoteOnViewSelect= \cf8 NumberBox\cf0 (t.views[2], \cf8 Rect\cf0 (0, 0, 30, 20))\
		.value_(0)\
		.step_(1)\
		.scroll_step_(1)\
		.clipLo_(0)\
		.clipHi_(\
			\{properties[key][16][1][0].data.size -1\}.try;\
		)\
		.action_(\{\cf2 |v|\cf0  \
			\{ dmxNoteOnSliders[v.value].sliderView.focus \}.defer;\
			dmxNoteOffViewSelect.value= v.value;\
		\});\
\
\
\cf8 Button\cf0 (t.views[2], \cf8 Rect\cf0 (0, 0, 30, 20))\
.states_([[\cf6 "+"\cf0 ]])\
.canFocus_(\cf3 false\cf0 )\
.action_(\{\
	if(properties[key][16][1][0].data.indices.includes(dmxNoteOnViewAdd.value.asInteger).not, \{\
		properties[key][16][1][0].put(dmxNoteOnViewAdd.value, 0);\
		dmxNoteOnViewSelect.clipHi= (properties[key][16][1][0].data.size -1);\
		updateDmxNoteOnView.value;\
		if(addBlack, \{\
			properties[key][16][1][1].put(dmxNoteOnViewAdd.value, 0);\
			dmxNoteOffViewSelect.clipHi= (properties[key][16][1][1].data.size -1);\
			updateDmxNoteOffView.value;		\
		\});\
	\}, \{\cf6 "Allready a Fader for this Channel!!"\cf0 .postln;\});\
\});\
\
\
dmxNoteOnViewAdd= \cf8 NumberBox\cf0 (t.views[2], \cf8 Rect\cf0 (0, 0, 30, 20))\
		.value_(0)\
		.step_(1)\
		.scroll_step_(1)\
		.clipLo_(0)\
		.clipHi_(512);\
\
\
\cf8 Button\cf0 (t.views[2], \cf8 Rect\cf0 (0, 0, 60, 20))\
.canFocus_(\cf3 false\cf0 )\
.states_([[\cf6 "add BLK"\cf0 , \cf8 Color\cf0 .white, \cf8 Color\cf0 .black], [\cf6 "add BLK"\cf0 , \cf8 Color\cf0 .green, \cf8 Color\cf0 .black]])\
.value_(1)\
.action_(\{\cf2 |v|\cf0 \
	if(v.value == 1, \{addBlack= \cf3 true\cf0 \}, \{addBlack= \cf3 false\cf0 \});\
\});\
\
\
t.views[2].decorator.nextLine;\
\
dmxNoteOnScroll= \cf8 ScrollView\cf0 (t.views[2], 400@300);\
dmxNoteOnScroll.hasVerticalScroller= \cf3 false\cf0 ;\
dmxNoteOnScroll.hasHorizontalScroller= \cf3 true\cf0 ;\
\
\
dmxNoteOnLayout= \cf8 CompositeView\cf0 (dmxNoteOnScroll, 800@300).decorator_(\cf8 FlowLayout\cf0 (w.view.bounds));\
\
\
if( properties[key][16][1][0].data.size > 0, \{\
dmxNoteOnView= properties[key][16][1][0].data.indices.collect(\{\cf2 |it, i|\cf0 \
		\cf8 CompositeView\cf0 (dmxNoteOnLayout, \cf8 Rect\cf0 (0, 0, 30, 300));\
\});\
\
dmxNoteOnChannel= properties[key][16][1][0].data.indices.collect(\{\cf2 |it, i|\cf0 \
		\cf8 NumberBox\cf0 (dmxNoteOnView[i], 30@20)\
		.value_(it)\
		\cf4 //.background_(white)\cf0 \
		.step_(1)\
		.clipLo_(0)\
		.clipHi_(512)\
		.action_(\{\cf2 |v|\cf0 \
			properties[key][16][1][0].put(v.value, dmxNoteOnSliders[i].value);\
		\});\
\});\
\
dmxNoteOnSliders= properties[key][16][1][0].data.indices.collect(\{\cf2 |it, i|\cf0 \
		\cf8 EZSlider\cf0 (dmxNoteOnView[i], \cf8 Rect\cf0 (0, 20, 30, 260), \
		\cf3 nil\cf0 , \cf4 // label\cf0 \
		[0.0, 1.0, \cf9 \\lin\cf0 , 0.01].asSpec, \cf4 // control spec\cf0 \
		initVal: properties[key][16][1][0].at(properties[key][16][1][0].data.indices[i]), \
		numberWidth:20,\
		layout:\cf9 \\vert\cf0 )\
		.setColors(\cf8 Color\cf0 .grey,\cf8 Color\cf0 .white)\
		.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 ,10))\
\});\
\
\
dmxNoteOnSliders.do(\{ \cf2 |it, i|\cf0 \
		dmxNoteOnSliders[i].sliderView.mouseUpAction= (\{\
			properties[key][16][1][0].put(dmxNoteOnChannel[i].value, dmxNoteOnSliders[i].value);\
			\cf4 //~dmx.postln;\cf0 \
			\cf4 //properties[key][16][1][0].postln;\cf0 \
			\cf4 //properties[key][16][1][0].data.postln;\cf0 \
			if(testDMX, \{ \cf5 ~dmx\cf0 .fade(properties[key][16][1][0], 0.1, \cf9 'linear'\cf0 , 0.1) \});\
		\});\
		dmxNoteOnSliders[i].numberView.mouseUpAction= (\{\
			properties[key][16][1][0].put(dmxNoteOnChannel[i].value, dmxNoteOnSliders[i].value);\
			if(testDMX, \{ \cf5 ~dmx\cf0 .fade(properties[key][16][1][0], 0.1, \cf9 'linear'\cf0 , 0.1) \});\
		\});\
\});\
\
\});\
\
\
updateDmxNoteOnView= \{\
\
	\{\
	dmxNoteOnLayout.remove;\
	\
	dmxNoteOnLayout= \cf8 CompositeView\cf0 (dmxNoteOnScroll, 800@300).decorator_(\cf8 FlowLayout\cf0 (w.view.bounds));\
	\
	dmxNoteOnView= properties[key][16][1][0].data.indices.collect(\{\cf2 |it, i|\cf0 \
			\cf8 CompositeView\cf0 (dmxNoteOnLayout, \cf8 Rect\cf0 (0, 0, 30, 300));\
	\});\
	\
	dmxNoteOnChannel= properties[key][16][1][0].data.indices.collect(\{\cf2 |it, i|\cf0 \
			\cf8 NumberBox\cf0 (dmxNoteOnView[i], 30@20)\
			.value_(it)\
			\cf4 //.background_(white)\cf0 \
			.step_(1)\
			.clipLo_(0)\
			.clipHi_(512)\
			.action_(\{\cf2 |v|\cf0 \
				properties[key][16][1][0].put(v.value, dmxNoteOnSliders[i].value);\
			\});\
	\});\
\
	\cf4 //properties[key][16][1][0].at(properties[key][16][1][0].data.indices[i]).postln;	\cf0 \
\
	dmxNoteOnSliders= properties[key][16][1][0].data.indices.collect(\{\cf2 |it, i|\cf0 \
		\cf8 EZSlider\cf0 (dmxNoteOnView[i], \cf8 Rect\cf0 (0, 20, 30, 260), \
		\cf3 nil\cf0 , \cf4 // label\cf0 \
		[0.0, 1.0, \cf9 \\lin\cf0 , 0.01].asSpec, \cf4 // control spec\cf0 \
		initVal: properties[key][16][1][0].at(it), \
		numberWidth:20,\
		layout:\cf9 \\vert\cf0 )\
		.setColors(\cf8 Color\cf0 .grey,\cf8 Color\cf0 .white)\
		.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 ,10))\
	\});\
	\
\
	dmxNoteOnSliders.do(\{ \cf2 |it, i|\cf0 \
		dmxNoteOnSliders[i].sliderView.mouseUpAction= (\{\
			properties[key][16][1][0].put(dmxNoteOnChannel[i].value, dmxNoteOnSliders[i].value);\
			if(testDMX, \{ \cf5 ~dmx\cf0 .fade(properties[key][16][1][0], 0.1, \cf9 'linear'\cf0 , 0.1) \});\
		\});\
		dmxNoteOnSliders[i].numberView.mouseUpAction= (\{\
			properties[key][16][1][0].put(dmxNoteOnChannel[i].value, dmxNoteOnSliders[i].value);\
			if(testDMX, \{ \cf5 ~dmx\cf0 .fade(properties[key][16][1][0], 0.1, \cf9 'linear'\cf0 , 0.1) \});\
		\});\
	\});\
	\}.fork(\cf8 AppClock\cf0 );\
\};\
\
\
\cf8 StaticText\cf0 (t.views[2], \cf8 Rect\cf0 (0, 0, 400, 30)).string_(\cf6 "NOTE OFF:"\cf0 ).align_(\cf9 \\center\cf0 );\
\
t.views[2].decorator.nextLine;\
\
\cf8 Button\cf0 (t.views[2], \cf8 Rect\cf0 (0, 0, 30, 20))\
.states_([[\cf6 "-"\cf0 ]])\
.canFocus_(\cf3 false\cf0 )\
.action_(\{\
	if (dmxNoteOffSliders.size > 0, \{\
			properties[key][16][1][1].data.removeAtSlot(dmxNoteOffViewSelect.value);\
			dmxNoteOffViewSelect.value= 0;\
			dmxNoteOffViewSelect.clipHi= (properties[key][16][1][1].data.size-1);\
			updateDmxNoteOffView.value;\
		\});\
\});\
\
\
dmxNoteOffViewSelect= \cf8 NumberBox\cf0 (t.views[2], \cf8 Rect\cf0 (0, 0, 30, 20))\
		.value_(0)\
		.step_(1)\
		.scroll_step_(1)\
		.clipLo_(0)\
		.clipHi_( \{properties[key][16][1][1].data.size -1\}.try )\
		.action_(\{\cf2 |v|\cf0  dmxNoteOffSliders[v.value].sliderView.focus; \});\
\
\cf8 Button\cf0 (t.views[2], \cf8 Rect\cf0 (0, 0, 30, 20))\
.states_([[\cf6 "+"\cf0 ]])\
.canFocus_(\cf3 false\cf0 )\
.action_(\{\
	if(properties[key][16][1][1].data.indices.includes(dmxNoteOffViewAdd.value.asInteger).not, \{\
		properties[key][16][1][1].put(dmxNoteOffViewAdd.value, 0);\
		dmxNoteOffViewSelect.clipHi= (properties[key][16][1][1].data.size -1);\
		updateDmxNoteOffView.value;\
	\}, \{\cf6 "Allready a Fader for this Channel!!"\cf0 .postln;\});\
\});\
\
\
dmxNoteOffViewAdd= \cf8 NumberBox\cf0 (t.views[2], \cf8 Rect\cf0 (0, 0, 30, 20))\
		.value_(0)\
		.step_(1)\
		.scroll_step_(1)\
		.clipLo_(0)\
		.clipHi_(512);\
		\
\
\
t.views[2].decorator.nextLine;\
\
dmxNoteOffScroll= \cf8 ScrollView\cf0 (t.views[2], 400@300);\
dmxNoteOffScroll.hasVerticalScroller= \cf3 false\cf0 ;\
dmxNoteOffScroll.hasHorizontalScroller= \cf3 true\cf0 ;\
\
dmxNoteOffLayout= \cf8 CompositeView\cf0 (dmxNoteOffScroll, 800@300).decorator_(\cf8 FlowLayout\cf0 (w.view.bounds));\
\
if( properties[key][16][1][0].data.size > 0, \{\
dmxNoteOffView= properties[key][16][1][1].data.indices.collect(\{\cf2 |it, i|\cf0 \
		\cf8 CompositeView\cf0 (dmxNoteOffLayout, \cf8 Rect\cf0 (0, 0, 30, 300));\
\});\
\
dmxNoteOffChannel= properties[key][16][1][1].data.indices.collect(\{\cf2 |it, i|\cf0 \
		\cf8 NumberBox\cf0 (dmxNoteOffView[i], 30@20)\
		.value_(it)\
		\cf4 //.background_(white)\cf0 \
		.step_(1)\
		.clipLo_(0)\
		.clipHi_(512)\
		.action_(\{\cf2 |v|\cf0 \
			properties[key][16][1][1].put(v.value, dmxNoteOffSliders[i].value);\
		\});\
\});\
\
dmxNoteOffSliders= properties[key][16][1][1].data.indices.collect(\{\cf2 |it, i|\cf0 \
		\cf8 EZSlider\cf0 (dmxNoteOffView[i], \cf8 Rect\cf0 (0, 20, 30, 260), \
		\cf3 nil\cf0 , \cf4 // label\cf0 \
		[0.0, 1.0, \cf9 \\lin\cf0 , 0.01].asSpec, \cf4 // control spec\cf0 \
		initVal: properties[key][16][1][1].at(properties[key][16][1][1].data.indices[i]), \
		numberWidth:20,\
		layout:\cf9 \\vert\cf0 )\
		.setColors(\cf8 Color\cf0 .grey,\cf8 Color\cf0 .white)\
		.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 ,10))\
\});\
\
\
dmxNoteOffSliders.do(\{ \cf2 |it, i|\cf0 \
		dmxNoteOffSliders[i].sliderView.mouseUpAction= (\{\
			properties[key][16][1][1].put(dmxNoteOffChannel[i].value, dmxNoteOffSliders[i].value);\
			if(testDMX, \{ \cf5 ~dmx\cf0 .fade(properties[key][16][1][1], 0.5, \cf9 'linear'\cf0 , 0.1) \});\
		\});\
		dmxNoteOffSliders[i].numberView.mouseUpAction= (\{\
			properties[key][16][1][1].put(dmxNoteOffChannel[i].value, dmxNoteOffSliders[i].value);\
			if(testDMX, \{ \cf5 ~dmx\cf0 .fade(properties[key][16][1][1], 0.5, \cf9 'linear'\cf0 , 0.1) \});\
		\});\
\});\
\});\
\
\
\
updateDmxNoteOffView= \{\
\
	\{\
	dmxNoteOffLayout.remove;\
	\
	dmxNoteOffLayout= \cf8 CompositeView\cf0 (dmxNoteOffScroll, 800@300).decorator_(\cf8 FlowLayout\cf0 (w.view.bounds));\
	\
	dmxNoteOffView= properties[key][16][1][1].data.indices.collect(\{\cf2 |it, i|\cf0 \
			\cf8 CompositeView\cf0 (dmxNoteOffLayout, \cf8 Rect\cf0 (0, 0, 30, 300));\
	\});\
	\
	dmxNoteOffChannel= properties[key][16][1][1].data.indices.collect(\{\cf2 |it, i|\cf0 \
			\cf8 NumberBox\cf0 (dmxNoteOffView[i], 30@20)\
			.value_(it)\
			\cf4 //.background_(white)\cf0 \
			.step_(1)\
			.clipLo_(0)\
			.clipHi_(512)\
			.action_(\{\cf2 |v|\cf0 \
				properties[key][16][1][1].put(v.value, dmxNoteOffSliders[i].value);\
			\});\
	\});\
\
	\cf4 //properties[key][16][1][1].at(properties[key][16][1][1].data.indices[i]).postln;	\cf0 \
\
	dmxNoteOffSliders= properties[key][16][1][1].data.indices.collect(\{\cf2 |it, i|\cf0 \
		\cf8 EZSlider\cf0 (dmxNoteOffView[i], \cf8 Rect\cf0 (0, 20, 30, 260), \
		\cf3 nil\cf0 , \cf4 // label\cf0 \
		[0.0, 1.0, \cf9 \\lin\cf0 , 0.01].asSpec, \cf4 // control spec\cf0 \
		initVal: properties[key][16][1][1].at(it), \
		numberWidth:20,\
		layout:\cf9 \\vert\cf0 )\
		.setColors(\cf8 Color\cf0 .grey,\cf8 Color\cf0 .white)\
		.font_(\cf8 Font\cf0 (\cf6 "Helvetica"\cf0 ,10))\
	\});\
	\
\
	dmxNoteOffSliders.do(\{ \cf2 |it, i|\cf0 \
		dmxNoteOffSliders[i].sliderView.mouseUpAction= (\{\
			properties[key][16][1][1].put(dmxNoteOffChannel[i].value, dmxNoteOffSliders[i].value);\
			if(testDMX, \{ \cf5 ~dmx\cf0 .fade(properties[key][16][1][1], 0.5, \cf9 'linear'\cf0 , 0.1) \});\
		\});\
		dmxNoteOffSliders[i].numberView.mouseUpAction= (\{\
			properties[key][16][1][1].put(dmxNoteOffChannel[i].value, dmxNoteOffSliders[i].value);\
			if(testDMX, \{ \cf5 ~dmx\cf0 .fade(properties[key][16][1][1], 0.5, \cf9 'linear'\cf0 , 0.1) \});\
		\});\
	\});\
	\}.fork(\cf8 AppClock\cf0 );\
\};\
\
\
t.focus(sendWinLastTabFocus);\
\
w.front;\
\
w.view.onMove = \{\
	t.activeTab.postln;\
	sendWinLastTabFocus= t.activeTab;\
	sendWinLastPos= [w.bounds.left, w.bounds.top];\
\};\
\
w.onClose = \{ \
	sendWinOpen= \cf3 nil\cf0 ;\
	\cf4 //~dmx = nil;\cf0 \
	\cf4 //\{~dmx.close; \}.try;\cf0 \
	\cf4 //\{~enttec.close; \}.try;\cf0 \
	\cf4 //sendWinLastTabFocus= t.activeTab;\cf0 \
	\cf4 //sendWinLastPos= [w.bounds.left, w.bounds.top];\cf0 \
	(\cf6 "last focused tab:"\cf0 +sendWinLastTabFocus);\
	 \};\
\
\};\
\
\
\
\cf4 // =============================================================================================\cf0 \
\cf4 // =================================== LOOP POINT EDITOR =======================================\cf0 \
\cf4 // =============================================================================================\cf0 \
\
looppointeditor= \{ \cf2 |key|\cf0 \
	\cf2 var\cf0  w, sfView, f, frames;\
		w = \cf8 Window\cf0 .new(\cf6 "set loop position"\cf0 , \cf8 Rect\cf0 (200, 200, 850, 160));\
		sfView = \cf8 SoundFileView\cf0 .new(w, \cf8 Rect\cf0 (20,20, 800, 100))\
		\cf4 //.gridResolution\cf0 \
		.canFocus_(\cf3 false\cf0 )\
		.gridColor_(\cf8 Color\cf0 .grey)\
		.timeCursorOn_(\cf3 false\cf0 )\
		.waveColors_([\cf8 Color\cf0 .red, \cf8 Color\cf0 .red])\
		.background_(\cf8 Color\cf0 (0.298, 0.298, 0.298, 1.0))\
		;\
		sfView.setSelectionColor(0, \cf8 Color\cf0 .white);\
		f = \cf8 SoundFile\cf0 .new;\
		f.openRead(sounds[key]);\
		frames= f.numFrames;\
		sfView.soundfile = f;\
		sfView.read(0, f.numFrames);\
		sfView.mouseUpAction= \{\
			\cf2 var\cf0  start, end;\
			start= sfView.selectionStart(0)/frames;\
			end= sfView.selectionSize(0)/frames + start;\
			[start, end].postln;\
			properties[key][13][1]= start;\
			properties[key][13][2]= end;\
			if(a.isPlaying((\cf6 "snd"\cf0 ++((key).asString)).asSymbol), \{\
			a.set((\cf6 "snd"\cf0 ++((key).asString)).asSymbol).startLoop_(start);\
			a.set((\cf6 "snd"\cf0 ++((key).asString)).asSymbol).endLoop_(end);\
			\});\
		\};\
		\
		if(properties[key][13].isNil.not, \{\
			sfView.setSelectionStart(0, properties[key][13][1]*frames);\
			sfView.setSelectionSize(0, (properties[key][13][2]*frames) - (properties[key][13][1]*frames));\
		\});\
		\
		\
		\cf8 Button\cf0 (w, \cf8 Rect\cf0 (825, 20, 20, 20))\
		.states_([[\cf6 "+"\cf0 ]])\
		.canFocus_(\cf3 false\cf0 )\
		.action_(\{ sfView.zoom(0.8).refresh \});\
		\
		\cf8 Button\cf0 (w, \cf8 Rect\cf0 (825, 40, 20, 20))\
		.states_([[\cf6 "-"\cf0 ]])\
		.canFocus_(\cf3 false\cf0 )\
		.action_(\{ sfView.zoom(1.2) \});\
		\
		\cf8 Button\cf0 (w, \cf8 Rect\cf0 (825, 60, 20, 20))\
		.states_([[\cf6 "0"\cf0 ]])\
		.canFocus_(\cf3 false\cf0 )\
		.action_(\{ sfView.zoomAllOut \});\
\
		\cf8 Button\cf0 (w, \cf8 Rect\cf0 (825, 90, 20, 20))\
		.states_([[\cf6 "rm"\cf0 , \cf8 Color\cf0 .red, \cf8 Color\cf0 .black]])\
		.canFocus_(\cf3 false\cf0 )\
		.action_(\{ \
			sfView.zoomAllOut;\
			properties[key][13][1]= 0;\
			properties[key][13][2]= 1;\
			sfView.setSelectionStart(0, properties[key][13][1]*frames);\
			sfView.setSelectionSize(0, properties[key][13][2]*frames);\
		\});		\
		\
		\
		\cf8 Slider\cf0 (w, \cf8 Rect\cf0 (20, 125, 800, 30))\
		.canFocus_(\cf3 false\cf0 )\
		.background_(\cf8 Color\cf0 (0.298, 0.298, 0.298, 1.0))\
		.knobColor_(\cf8 Color\cf0 (0.298, 0.776, 1.0, 1.0))\
		.action_(\{\cf2 |v|\cf0 \
			sfView.scrollTo(v.value);\
		\});\
		sfView.focus(\cf3 true\cf0 );\
		w.front;\
	\};\
	\
killothernotes= \{ \cf2 |key|\cf0 \
	numKeys.do(\{\cf2 |i|\cf0 \
	if(i == key, \{\cf3 nil\cf0 \},\{ \cf4 //all other keys than key\cf0 \
		if (a.isPlaying((\cf6 "snd"\cf0 ++((i).asString)).asSymbol), \{\
			a.stop((\cf6 "snd"\cf0 ++((i).asString)).asSymbol, properties[i][4]);\
			\{ keyButs[i].value= 0 \}.defer;\
			if (progressState == 1, \{\
				progress[i].stop; \
				progressViewClear.value(i);\
			\});\
		\});\
		if(arpRoutines[i].isPlaying, \{arpRoutines[i].stop\});\
	\});\
	\})\
\};\
\
panic= \{\
	\cf4 /*\
	numKeys.do(\{|i|\
		a.overlaps.do(\{\
			if (a.isPlaying(("snd"++((i).asString)).asSymbol), \{\
				a.stop(("snd"++((i).asString)).asSymbol, properties[i][4]);\
			\});\
		\});\
		//also do "snd1x1".....\
		// a.flush(0);\
	\});\
	*/\cf0 \
	 a.flush(0);\
	\
	arpRoutines.do(\{\cf2 |it|\cf0 \
		if(it.isPlaying,\{it.stop\});\
	\});\
	allKnobs.do(\{\cf2 |it|\cf0 \
		it.setVal(0);\
	\});\
	sliders.do(\{\cf2 |it|\cf0 \
		it.setVal(0);\
	\});\
	coyoteResponders.do(\{\cf2 |it|\cf0 \
		if(it.isNil.not, \{it.remove\});\
	\});\
\};\
\
arpView= \{\cf2 |i|\cf0 \
	\cf2 var\cf0  v, h, lenghtKnob, spaceKnob;\
	\cf4 //var loadASRsound;\cf0 \
	\cf4 //h= ScrollView(c, Rect(90, 100, 120, 80));\cf0 \
	h= \cf8 CompositeView\cf0 (c, \cf8 Rect\cf0 (90, 100, 120, 90))\
	.background_(\cf8 Color\cf0 .new255(229, 229, 229));\
	\
	lenghtKnob= \cf8 EZKnob\cf0 (	h,  	\cf4 // parent\cf0 \
		\cf8 Rect\cf0 (10, 0, 40, 70),	\cf4 // bounds\cf0 \
		\cf6 " length "\cf0 ,	\cf4 // label\cf0 \
		\cf9 \\rq\cf0 , 	\cf4 // controlSpec\cf0 \
		\{\cf2 |ez|\cf0  properties[i][12][0]= ez.value \}, \cf4 // action\cf0 \
		properties[i][12][0] \cf4 //init value\cf0 \
	);\
	lenghtKnob.setColors(\cf8 Color\cf0 .grey,\cf8 Color\cf0 .white);\
	\
	spaceKnob = \cf8 EZKnob\cf0 (	h,  	\cf4 // parent\cf0 \
		\cf8 Rect\cf0 (70, 0, 40, 70),	\cf4 // bounds\cf0 \
		\cf6 " space "\cf0 ,	\cf4 // label\cf0 \
		\cf9 \\delay\cf0 , 	\cf4 // controlSpec\cf0 \
		\{\cf2 |ez|\cf0  properties[i][12][1]= ez.value \}, \cf4 // action\cf0 \
		properties[i][12][1] \cf4 //init value\cf0 \
	);\
	spaceKnob.setColors(\cf8 Color\cf0 .grey,\cf8 Color\cf0 .white);\
	\
	\cf8 Button\cf0 (h, \cf8 Rect\cf0 (10, 70, 100, 18))\
	.states_([[\cf6 "toggle (hold)"\cf0 , \cf8 Color\cf0 .white, \cf8 Color\cf0 .black],[\cf6 "toggle (hold)"\cf0 , \cf8 Color\cf0 .green, \cf8 Color\cf0 .black]])\
	.value_(properties[i][12][2])\
	.action_(\{\cf2 |v|\cf0  properties[i][12][2]= v.value \});\
	\
\};\
\
\
extrasampleView= \{\cf2 |i, sam|\cf0 \
	\cf2 var\cf0  v, h, sambut;\
	\cf4 //var loadASRsound;\cf0 \
	h= \cf8 ScrollView\cf0 (c, \cf8 Rect\cf0 (90, 100, 120, 80));\
	\cf4 //h= VLayoutView(c, Rect(90, 100, 120, 90)).background_(Color.new255(229, 229, 229)).spacing_(2);\cf0 \
\
	\cf4 //h= VLayoutView(v, Rect(0, 0, 110, 140));\cf0 \
	\cf4 //properties[i][6].postln;\cf0 \
	if (properties[i][2] == 5, \{\
		\cf8 PopUpMenu\cf0 (h, \cf8 Rect\cf0 (0, 0, 100, 15))\
		.canFocus_(\cf3 false\cf0 )\
		.items_([\cf6 "sequence"\cf0 , \cf6 "random"\cf0 , \cf6 "no reset"\cf0 ])\
		.value_(properties[i][6])\
		.action_(\{\cf2 |menu|\cf0 \
			properties[i][6]= menu.value;\
		\});\
	\});\
\
	sambut= (sam.size+1).collect(\{\cf2 |ii|\cf0 \
	\cf8 Button\cf0 (h, \cf8 Rect\cf0 (0, 20+(15*ii), 100, 15))\
	.font_(\cf8 GUI\cf0 .font.new(\cf6 "Monaco"\cf0 , 9))\
	.canFocus_(\cf3 false\cf0 )\
	.states_([[\cf6 ""\cf0 , textcolors[0], colors[0]]])\
	.mouseDownAction_(\{ \cf2 |view, x, y, mod|\cf0 \
	\
		if ( mod.isShift, \{  \cf4 //shift\cf0 \
			\cf8 Dialog\cf0 .getPaths(\{ \cf2 arg\cf0  paths; \cf4 //load sound\cf0 \
			loadASRsound.value(paths, i, ii, view);\
			\cf4 /*\
			if (paths[0].isString, \{\
			\{a.freeKey(("snd"++i.asString++letters[ii]).asSymbol);\}.try;\
			paths[0].postln;\
			a.prepareForPlay(("snd"++i.asString++letters[ii]).asSymbol, paths[0]);\
			soundsASR[i][ii]= paths[0]; // where to store?????\
			view.states= ([[paths[0].basename.replace(".wav", ""), textcolors[0], colors[0]]]);\
			\});\
			*/\cf0 \
			\},\{\
				\cf6 "cancelled"\cf0 .postln;\
			\});\
		\});\
		\
	\})\
	.canReceiveDragHandler_(\cf3 true\cf0 )\
	.receiveDragHandler_(\{\cf2 |view|\cf0 \
			\cf2 var\cf0  paths;\
			paths= \cf8 View\cf0 .currentDrag;\
			loadASRsound.value(paths, i, ii, view);\
			\cf4 /*\
			if (paths[0].isString, \{\
			\{a.freeKey(("snd"++i.asString++letters[ii]).asSymbol);\}.try;\
			paths[0].postln;\
			ii.postln;\
			("snd"++i.asString++letters[ii]).asSymbol.postln;\
			a.prepareForPlay(("snd"++i.asString++letters[ii]).asSymbol, paths[0]);\
			soundsASR[i][ii]= paths[0]; // where to store?????\
			view.states= ([[paths[0].basename.replace(".wav", ""), textcolors[0], colors[0]]]);\
			\}, \{paths[0].postln;"ERROR: you cant drag that here".postln;\});\
			*/\cf0 \
	\})\
\cf4 /*	.action_(\{|v|\
		a.play(("snd"++((i).asString++"a")).asSymbol, //attack sound\
				amp: 0.5,\
				loop: 0,\
				attack: 0.01,\
				out: output\
		);\
	\})\
	*/\cf0 \
	;\
\
	\});\
	\
	\cf4 //sam.postln;\cf0 \
\
	sam.size.do(\{\cf2 |i|\cf0 \
	if (sam[i].isNil.not, \{ \
		\{sambut[i].states= ([[sam[i].basename.removeExtension, textcolors[0], colors	[0]]]);\}.defer \});\
	\});\
\
\};\
\
\
\
\
progressView= \{\cf2 |key|\cf0 \
	\cf4 //routine to draw progress view on key\cf0 \
	progress[key]= \{\
		\cf2 var\cf0  elapsed, b, mul= 10, time= a.length((\cf6 "snd"\cf0 ++(key).asString).asSymbol).round(1);\
		time= time*(properties[key][14].abs).reciprocal;\
		b= keyUserViews[key];\
		(time*mul).do(\{\cf2 |i|\cf0 \
			elapsed= (i+1)/(time*mul);\
			b.drawFunc = \{\
				\cf4 // set the Color\cf0 \
				if((i+1)==(time*mul), \{ \cf8 Pen\cf0 .fillColor = \cf8 Color\cf0 .red.alpha_(0.0);\},\
				\{ \cf8 Pen\cf0 .fillColor = \cf8 Color\cf0 .red.alpha_(0.3) \});\
			\
				\cf8 Pen\cf0 .addRect(\
					\cf8 Rect\cf0 (0, 0, (b.bounds.width*elapsed), b.bounds.height)\
					);\
				\cf8 Pen\cf0 .fill;\
			\};\
			\{w.refresh\}.defer;\
			(1/mul).wait;\
		\});\
	\}.fork(\cf8 AppClock\cf0 );	\
\};\
\
\
progressViewClear= \{\cf2 |key|\cf0 \
	\cf4 //function to clear progress view on key\cf0 \
		\cf2 var\cf0  b;\
		b= keyUserViews[key];\
\
			b.drawFunc = \{\
				\cf4 // fill with clear\cf0 \
				\cf8 Pen\cf0 .fillColor = \cf8 Color\cf0 .red.alpha_(0.0);\
			\
				\cf8 Pen\cf0 .addRect(\
					\cf8 Rect\cf0 (0, 0, b.bounds.width, b.bounds.height)\
					);\
				\cf8 Pen\cf0 .fill;\
			\};\
			\{ keyButs[key].value= 0; \}.defer\
			\{w.refresh\}.defer;\
\};\
\
\
\
loadASRsound= \{\cf2 |paths, i, num, view|\cf0 \
	paths.do(\{ \cf2 |path, ii|\cf0 \
		if (path.isString, \{\
			\cf4 //"loadASR:".postln; [i, ii, num].postln;\cf0 \
		\{a.freeKey((\cf6 "snd"\cf0 ++i.asString++\cf6 "x"\cf0 ++((num+ii).asString)).asSymbol);\}.try;\
		\cf4 //path.postln;\cf0 \
		a.prepareForPlay((\cf6 "snd"\cf0 ++i.asString++\cf6 "x"\cf0 ++((num+ii).asString)).asSymbol, path);\
		if (soundsASR[i][num+ii].isNil, \{soundsASR[i]= soundsASR[i].add(path)\}, \{soundsASR[i][num+ii]= path \});\
		\cf4 /*\
		\{sambut[num+ii].states= ([[path.basename.replace(".wav", ""), textcolors[0], colors[0]]])\}.defer;\
		*/\cf0 \
		\});\
	\});\
	properties[i][7]= soundsASR[i].size-1;\
	\cf4 //maybe \cf0 \
	\{c.remove; propView.value(i)\}.defer;\
	\};\
\
\
\cf4 // ======================== TOUCH OSC INTERFACE ================\cf0 \
touchOSC= \{\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf2 var\cf0  resp1=\cf8 Array\cf0 .newClear(12);\
\cf2 var\cf0  resp2=\cf8 Array\cf0 .newClear(37);\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf4 //var resp3=Array.newClear(12);\cf0 \
\cf4 //var resp4=Array.newClear(12);\cf0 \
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf2 var\cf0  resp5=\cf8 Array\cf0 .newClear(12);\
\cf2 var\cf0  win;\
	\
9.do(\{\cf2 |i|\cf0 \
	resp1.put(i, \cf8 OSCresponderNode\cf0 (\cf3 nil\cf0 , \cf9 '/1/fader'\cf0 ++(i+1).asString, \{\cf2 |t, r, msg|\cf0 \
			\{sliders[i].setVal((msg[1]).round(0.001))\}.defer;	\
			\}).add;);	\
	resp1.put(i, \cf8 OSCresponderNode\cf0 (\cf3 nil\cf0 , \cf9 '/1/rotary'\cf0 ++(i+1).asString, \{\cf2 |t, r, msg|\cf0 \
			\{sliders[i].setPan((msg[1]).round(0.001))\}.defer;	\
			\}).add;);	\
\});\
\
8.do(\{\cf2 |i|\cf0 \
	resp5.put(i, \cf8 OSCresponderNode\cf0 (\cf3 nil\cf0 , \cf9 '/1/knob'\cf0 ++(i+1).asString, \{\cf2 |t, r, msg|\cf0 \
			\{allKnobs[i].setVal((msg[1]).round(0.001))\}.defer;\
			\
			\}).add;);	\
	resp5.put(i, \cf8 OSCresponderNode\cf0 (\cf3 nil\cf0 , \cf9 '/1/knobpan'\cf0 ++(i+1).asString, \{\cf2 |t, r, msg|\cf0 \
			\{allKnobs[i].setPan((msg[1]).round(0.001))\}.defer;	\
			\}).add;);	\
\});\
\
37.do(\{\cf2 |i|\cf0 \
		resp2.put(i, \cf8 OSCresponderNode\cf0 (\cf3 nil\cf0 , \cf9 '/2/push'\cf0 ++(i+1).asString, \{\cf2 |t, r, msg|\cf0 \
			\cf4 //if(sounds[i+1].isNil.not, \{\cf0 \
				if( msg[1] == 1, \
					\{playnote.value(\cf3 nil\cf0 , i, i, \cf3 nil\cf0 )\},\
					\{stopnote.value(i, i)\}\
				);\
			\cf4 //\});	\cf0 \
	\}).add;)\
\});\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf4 /*\
12.do(\{|i|\
		resp3.put(i, OSCresponderNode(nil, '/2/push'++(i+13).asString, \{|t, r, msg|\
			if(sounds[i+1].isNil.not, \{\
				//sounds[i+12].postln; msg[1].postln;\
				if( msg[1] == 1, \
					\{playnote.value(nil, i+12, i+12, nil)\},\
					\{stopnote.value(i+1, i+12)\}\
				);\
			\});\
	\}).add;)\
\});\
\
12.do(\{|i|\
		resp4.put(i, OSCresponderNode(nil, '/2/push'++(i+25).asString, \{|t, r, msg|\
			if(sounds[i+1].isNil.not, \{\
				//sounds[i+12].postln; msg[1].postln;\
				if( msg[1] == 1, \
					\{playnote.value(nil, i+24, i+24, nil)\},\
					\{stopnote.value(i+1, i+24)\}\
				);\
			\});\
	\}).add;)\
\});\
*/\cf0 \
\
\cf8 OSCdef\cf0 (\cf9 \\pingResp\cf0 , \{\cf2 |msg, time, addr, recvPort|\cf0 \
	\cf4 //var n= NetAddr("android-186c303cd60796d", recvPort);\cf0 \
	\cf2 var\cf0  n= \cf8 NetAddr\cf0 (addr.ip, recvPort);\
	\
	\{\
	sliders.do(\{\cf2 |it, i|\cf0 \
		\cf2 var\cf0  name;\
		if(it.title.string.isNil, \{name= \cf6 " "\cf0 \}, \{name= it.title.string \});\
		n.sendMsg(\cf9 '/1/label'\cf0 ++(i+1).asSymbol, name); 0.1.wait; \
		\cf4 //('/1/label'++(i+1).asSymbol + name).postln;\cf0 \
		\});\
	allKnobs.do(\{\cf2 |it, i|\cf0 \
		\cf2 var\cf0  name;\
		if(it.title.string.isNil, \{name= \cf6 " "\cf0 \}, \{name= it.title.string \});\
		n.sendMsg(\cf9 '/1/knoblabel'\cf0 ++(i+1).asSymbol, name); 0.1.wait; \
		\cf4 //('/1/label'++(i+1).asSymbol + name).postln;\cf0 \
		\});\
	sounds.do(\{\cf2 |it, i|\cf0 \
		\cf2 var\cf0  name;\
		if( i < 36, \{\
		if(it.isNil, \{name= \cf6 " "\cf0 \}, \{name= it.basename.removeExtension\});\
		n.sendMsg(\cf9 '/2/label'\cf0 ++(i+1).asSymbol, name); 0.1.wait;\
		\cf4 //('/2/label'++(i+1).asSymbol + name).postln;\cf0 \
		\});\
	\});\
	\}.fork(\cf8 AppClock\cf0 );\
	n.free;\
	\cf4 //("pung"+time+addr.ip+recvPort).postln;\cf0 \
	\}, \cf9 '/ping'\cf0 , \cf3 nil\cf0 );\
\
win= \cf8 Window\cf0 (\cf6 "TouchOSC"\cf0 , \cf8 Rect\cf0 (300, 300, 300, 300))\
.front\
.alwaysOnTop_(\cf3 true\cf0 );\
\
\cf4 // REMOVE RESPONDERS (don't forget)\cf0 \
win.onClose= \{\
resp1.do(\{\cf2 |it|\cf0  it.remove\});\
resp2.do(\{\cf2 |it|\cf0  it.remove\});\
\cf4 //resp3.do(\{|it| it.remove\});\cf0 \
\cf4 //resp4.do(\{|it| it.remove\});\cf0 \
resp5.do(\{\cf2 |it|\cf0  it.remove\});\
\
\cf8 OSCdef\cf0 (\cf9 \\pingResp\cf0 ).free;\
\};\
\
\};\
\
\
\cf4 // ========================= SEQUENCER =========================\cf0 \
sequencer= \{\
	\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf2 var\cf0  w, topGrid, gridArray, clockArray, meter, freq;\
\cf2 var\cf0  columns= 16;\
\cf2 var\cf0  boxHeight= 16, boxSpace= 3, topSpace= 50;\
\cf2 var\cf0  length, mute, muteButtons;\
\cf2 var\cf0  randomize, names;\
\cf2 var\cf0  playBut, stopBut, recBut;\
\cf2 var\cf0  t, beat= 1, recSeq, recSeqNoteOn, tapTempoGUI, tapTempoView;\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf4 //to remove\cf0 \
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf2 var\cf0  samples;\
\cf2 var\cf0  colors;\
colors= [\cf8 Color\cf0 .new255(160, 255, 160).alpha_(0.5), \cf8 Color\cf0 .black, \cf8 Color\cf0 .white, \cf8 Color\cf0 .black, \cf8 Color\cf0 .white, \cf8 Color\cf0 .white, \cf8 Color\cf0 .black, \cf8 Color\cf0 .white, \cf8 Color\cf0 .black, \cf8 Color\cf0 .white, \cf8 Color\cf0 .black, \cf8 Color\cf0 .white];\
\
mute= 0!numKeys;\
\
w = \cf8 Window\cf0 .new(\cf6 "Step sequencer"\cf0 , \cf8 Rect\cf0 (10, 500, 800, 760)).front;\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf8 Button\cf0 (w, \cf8 Rect\cf0 (0, 0, 40, 40))\
.states_([[\cf6 "A"\cf0 ],[\cf6 "V"\cf0 ]])\
.action_(\{\cf2 |v|\cf0  if (v.value == 1, \{ w.setInnerExtent(\cf3 nil\cf0 , 50) \}, \{ w.setInnerExtent(\cf3 nil\cf0 , 760) \}) \});\
\
randomize= \cf8 Button\cf0 (w, \cf8 Rect\cf0 (60, 0, 50, 20))\
.canFocus_(\cf3 false\cf0 )\
.states_([[\cf6 "randomize"\cf0 ]])\
.action_(\{\
		numKeys.do(\{\cf2 |i|\cf0 \
10.do(\{gridArray[i].setState_(columns.rand, 0, [0, 0, 0, 0, 1].choose);\}); \cf4 // column, row, state\cf0 \
	\});\
\});\
\
\cf8 EZSlider\cf0 (w,  	\
	\cf8 Rect\cf0 (120, 0, 180, boxHeight),\
	\cf6 "tempo"\cf0 ,	\cf4 // label\cf0 \
	[50, 250, \cf9 \\lin\cf0 , 1, 120, \cf6 "tempo"\cf0 ].asSpec, \cf4 // controlSpec\cf0 \
	\{\cf2 |ez|\cf0  t.clock.tempo_(ez.value/30) \}, \cf4 // action\cf0 \
	120, \cf4 // init value, set from A DICTIONARY\cf0 \
	labelWidth: 30,\
	numberWidth: 30\
	).setColors(\
		\cf3 nil\cf0 , \cf4 //string backgr\cf0 \
		\cf8 Color\cf0 .white, \cf4 //string\cf0 \
		\cf8 Color\cf0 (0.298, 0.298, 0.298, 1.0), \cf4 //slider backgr\cf0 \
		\cf8 Color\cf0 .grey, \cf4 //num backgr\cf0 \
		\cf8 Color\cf0 .white, \cf4 //num clr\cf0 \
		\cf3 nil\cf0 ,\
		\cf3 nil\cf0 ,\
		\cf8 Color\cf0 (0.298, 0.776, 1.0, 1.0) \cf4 //knob clr\cf0 \
);\
\
playBut = \cf8 RoundButton\cf0 ( w, \cf8 Rect\cf0 (310, 0, 50, 20) )\
.states_([[ \cf9 \\play\cf0  ], [\cf9 \\pause\cf0 ]] )\
.action_(\{\cf2 |v|\cf0  if(v.value == 1, \{t.play\}, \{t.pause\}) \});\
\
stopBut = \cf8 RoundButton\cf0 ( w, \cf8 Rect\cf0 (360, 0, 30, 20) )\
.states_([[ \cf9 \\stop\cf0  ]] )\
.action_(\{ t.stop; t.reset; playBut.value= 0; \});\
\
recBut = \cf8 RoundButton\cf0 ( w, \cf8 Rect\cf0 (390, 0, 30, 20) )\
.states_([[ \cf9 \\record\cf0 , \cf8 Color\cf0 .black ],[\cf9 \\record\cf0 , \cf8 Color\cf0 .red]] )\
.action_(\{ if (v.value==1, \{recSeq.value \}, \{ recSeqNoteOn.remove; \}); \});\
\
topGrid = \cf8 BoxGrid\cf0 .new(w, bounds: \cf8 Rect\cf0 (60, 25, 360, boxHeight), columns: columns, rows: 1)\
.setFillMode_(\cf3 true\cf0 )\
.setFillColor_(\cf8 Color\cf0 .red)\
	.setBackgrDrawFunc_(\{\
		16.do(\{\cf2 arg\cf0  i;\
			if((i==0)||(i==4)||(i==8)||(i==12)||(i==16),\{\
			\cf8 GUI\cf0 .pen.fillColor = \cf8 Color\cf0 .new255(60, 60, 60).alpha_(0.5);\
			\},\{\
			\cf8 GUI\cf0 .pen.fillColor = \cf8 Color\cf0 .new255(255, 255, 255).alpha_(0.5);\
			\});\
			\cf8 GUI\cf0 .pen.fillRect(\cf8 Rect\cf0 (1+(i*(360/columns)), 0, 360/columns, 240));\
		\})\
	\});\
\
gridArray = \cf8 Array\cf0 .fill(numKeys, \{\cf2 arg\cf0  i;\
	\cf8 BoxGrid\cf0 .new(w, bounds: \cf8 Rect\cf0 (60, (boxHeight+boxSpace)*((i-numKeys).abs)+topSpace-(boxHeight+boxSpace), 360, boxHeight), columns: columns, rows: 1)\
	.setFillMode_(\cf3 true\cf0 )\
	.setFillColor_(\cf8 Color\cf0 .green)\
	.setBackgrColor_(colors[i.wrap(0, 11)])\
	.setBackgrDrawFunc_(\{\
		16.do(\{\cf2 arg\cf0  i;\
			if((i==0)||(i==4)||(i==8)||(i==12)||(i==16),\{\
			\cf8 GUI\cf0 .pen.fillColor = \cf8 Color\cf0 .new255(60, 60, 60).alpha_(0.5);\
			\},\{\
			\cf8 GUI\cf0 .pen.fillColor = \cf8 Color\cf0 .new255(255, 255, 255).alpha_(0.5);\
			\});\
			\cf8 GUI\cf0 .pen.fillRect(\cf8 Rect\cf0 (1+(i*(360/16)), 0, 360/16, 240));\
		\})\
	\});\
\});\
\
\cf8 EZSlider\cf0 (w, \cf4 // master duration\cf0 \
	\cf8 Rect\cf0 (440, 25, 180, boxHeight),\
				\cf6 "dur"\cf0 ,	\cf4 // label\cf0 \
				\cf3 nil\cf0 , \cf4 // controlSpec\cf0 \
				\{\cf2 |ez|\cf0  length.do(\{\cf2 |it|\cf0  \{it.valueAction= ez.value\}.defer; \});\
				\}, \cf4 // action\cf0 \
				0.3, \cf4 // init value, set from A DICTIONARY\cf0 \
				labelWidth: 30,\
				numberWidth: 25\
				).setColors(\
					\cf3 nil\cf0 , \cf4 //string backgr\cf0 \
					\cf8 Color\cf0 .white, \cf4 //string\cf0 \
					\cf8 Color\cf0 (0.298, 0.298, 0.298, 1.0), \cf4 //slider backgr\cf0 \
					\cf8 Color\cf0 .grey, \cf4 //num backgr\cf0 \
					\cf8 Color\cf0 .white, \cf4 //num clr\cf0 \
					\cf3 nil\cf0 ,\
					\cf3 nil\cf0 ,\
					\cf8 Color\cf0 .red \cf4 //knob clr\cf0 \
					);\
\
length = \cf8 Array\cf0 .fill(numKeys, \{\cf2 arg\cf0  i;\
	\cf8 EZSlider\cf0 (w,  	\cf4 // parent\cf0 \
				\cf8 Rect\cf0 (440, (boxHeight+boxSpace)*((i-numKeys).abs)+topSpace-(boxHeight+boxSpace), 180, boxHeight),\
				\cf6 "dur"\cf0 ,	\cf4 // label\cf0 \
				\cf3 nil\cf0 , \cf4 // controlSpec\cf0 \
				\{\cf2 |ez|\cf0  \cf3 nil\cf0 \
				\}, \cf4 // action\cf0 \
				0.3, \cf4 // init value, set from A DICTIONARY\cf0 \
				labelWidth: 30,\
				numberWidth: 25\
				).setColors(\
					\cf3 nil\cf0 , \cf4 //string backgr\cf0 \
					\cf8 Color\cf0 .white, \cf4 //string\cf0 \
					\cf8 Color\cf0 (0.298, 0.298, 0.298, 1.0), \cf4 //slider backgr\cf0 \
					\cf8 Color\cf0 .grey, \cf4 //num backgr\cf0 \
					\cf8 Color\cf0 .white, \cf4 //num clr\cf0 \
					\cf3 nil\cf0 ,\
					\cf3 nil\cf0 ,\
					\cf8 Color\cf0 (0.298, 0.776, 1.0, 1.0) \cf4 //knob clr\cf0 \
					);\
\});\
\
muteButtons = \cf8 Array\cf0 .fill(numKeys, \{\cf2 arg\cf0  i;\
	\cf8 Button\cf0 (w, \cf8 Rect\cf0 (420, (boxHeight+boxSpace)*((i-numKeys).abs)+topSpace-(boxHeight+boxSpace), 20, 20))\
	.states_([[\cf6 "m"\cf0 , \cf8 Color\cf0 .black, \cf8 Color\cf0 .grey], [\cf6 "m"\cf0 , \cf8 Color\cf0 .black, \cf8 Color\cf0 .red]])\
	.action_(\{\cf2 |v|\cf0  mute[i]= v.value \})\
	.value_(0);\
\});\
\
names= \cf8 Array\cf0 .fill(numKeys, \{\cf2 arg\cf0  i;\
	if(sounds[i].isNil.not, \{\
	\cf8 StaticText\cf0 (w, \cf8 Rect\cf0 (10, (boxHeight+boxSpace)*((i-numKeys).abs)+topSpace-(boxHeight+boxSpace), 50, 20))\
	.string_(sounds[i].basename.removeExtension)\
	\});\
\});\
\
\
t= \cf8 Task\cf0 (\{\
	\cf3 inf\cf0 .do(\{\cf2 |i|\cf0 \
		beat= i%columns;\
\{topGrid.setState_( i%columns, 0, 1)\}.defer;\
\{topGrid.setState_( i%columns, 0, 0)\}.defer(\cf7 thisThread\cf0 .clock.beatDur);\
\
numKeys.do(\{\cf2 arg\cf0  ii;\
if(gridArray[ii].getState(i%16, 0) == 1, \{\
	if(mute[ii].value==0 && sounds[ii].isNil.not, \{\
		\cf4 //playnote.value(nil, ii, ii, nil, nil, length[ii].value);\cf0 \
		playnote.value(\cf3 nil\cf0 , ii, ii, \cf3 nil\cf0 , \cf3 nil\cf0 );\
		\{stopnote.value(ii, ii)\}.defer(length[ii].value);\
	\cf4 //a.play(ii.asSymbol, 0.01, 0, length[ii].value);\cf0 \
	\});\
\});\
\});\
1.wait;\
	\});\
\}, \cf8 TempoClock\cf0 (4));\
\
tapTempoView= \cf8 CompositeView\cf0 (w, \cf8 Rect\cf0 (430, 0, 230, 20));\
tapTempoGUI= \cf8 RedTapTempoGUI\cf0 (t.clock, 4, 3, s, tapTempoView);\
\
recSeq= \{\
	recSeqNoteOn= \cf8 NoteOnResponder\cf0 (\{ \cf2 |src,chan,note,vel|\cf0 \
	\cf2 var\cf0  num, event= \cf3 nil\cf0 ;\
	\cf4 //[src,chan,note,vel].postln;\cf0 \
	note= note-startKey;\
	if(note.inRange(0, (numKeys-1)), \{\
		gridArray[num].seState_(0, beat-1, 1);\
	\},\
	\{\cf6 "key out of range"\cf0 .postln;\});\
	\},\
	midisrc, \cf4 // source\cf0 \
	midichannel \cf4 // channel\cf0 \
	);\
	\
	\};\
\
\
prViewBut.valueAction= 0;\
\
w.onClose = \{tapTempoGUI.close; t.stop; seqIsOpen= \cf3 false\cf0 ; \{recSeqNoteOn.remove\}.try; \};\
\};\
\
\
\cf4 // ------- preferences view (setup)\cf0 \
\
preferencesView= \{\
	\cf8 KeyboardPreferences\cf0 .new(thisFilePath+/+keyboardName);\
	\};\
\
\
\
\cf4 // -----  bend responder\cf0 \
\
	bender = \cf8 BendResponder\cf0 (\{ \cf2 |src,chan,value|\cf0 \
		\cf4 //[src,chan,value].postln;\cf0 \
		\cf4 //if(bendfreeze == 0, \{\cf0 \
			value= value.linlin(0, 16383, 0.0, 2.0).round(0.001).clip(0.1, 2.0);\
			if( masterprop[\cf9 \\kyPitch\cf0 ] == 1, \{ a.speed_(value); \
				oscRoutines.do(\{\cf2 |it|\cf0  if(it.size > 0, \{\
					it.do(\{\cf2 |oscplayer|\cf0  oscplayer.clock.tempo_(value); \});\
					\}); \});\
				\});\
			if( masterprop[\cf9 \\slPitch\cf0 ] == 1, \{ sliders.do(\{\cf2 |it|\cf0  it.setPitch(value); \}); \});\
			if( masterprop[\cf9 \\knPitch\cf0 ] == 1, \{ allKnobs.do(\{\cf2 |it|\cf0  it.setPitch(value); \}); \});\
			bend= value;\
		\cf4 //\});\cf0 \
		\},\
		src: midisrcindex\
	);\
\
\
\
\cf4 // ----- prog change responder\cf0 \
\cf4 /*\
MIDIFunc.program(\{arg value, channel, srcID; \
	args.postln;\
	if( args[0] > previousMIDIProgMsg, \
		\{routingButton.valueAction= 5;\
			if(panHackSynth.isNil or: \{panHackSynth.isPlaying.not\}, \{\
				panHackSynth= Synth.tail(s, \\panHackSynth); panHackSynth.isPlaying_(true) \})\
			\}, // route outputs to balcony and pan with hack\
		\{routingButton.valueAction= 0;\
			if(panHackSynth.isNil.not and: \{panHackSynth.isPlaying\}, \{panHackSynth.free; panHackSynth.isPlaying_(false) \})\
			\} // route outputs back to normal\
	)\
	\
	\},\
	nil,\
	midichannel,\
	src: midisrcindex\
	);\
*/\cf0 \
\
\cf4 // =========== ON CLOSE ==================\cf0 \
\
w.front;\
\
w.onClose= \{\
	\cf5 ~openSamplers\cf0 [keyboardName.asSymbol]= \cf3 true\cf0 ;\
	\cf5 ~mixerChans\cf0 .removeAt(keyboardName);\
	a.free;\
	\{on.stop; off.stop\}.try;\
	\cf8 MIDIIn\cf0 .disconnectByUID(0, midisrc);\
	responders1.size.do(\{\cf2 |i|\cf0  responders1[i].remove\});\
	responders2.size.do(\{\cf2 |i|\cf0  responders2[i].remove\});\
	effectGroup.free;\
	bender.remove;\
	\
	noteon.remove;\
	noteoff.remove;\
	\
	if(p.isNil.not, \{p.close\}); \cf4 // close arduino REMOVE !\cf0 \
	\
	if(sendWinOpen.isNil.not, \{sendWinOpen.close\});\
	\
	if(\cf5 ~openSamplers\cf0 .values.includes(\cf3 true\cf0 ).not, \{\cf5 ~dmx\cf0 = \cf3 nil\cf0 ;\}); \cf4 // dmx to nil. enough?\cf0 \
	\cf5 ~preferencesWindows\cf0 .put(\cf9 \\keyboardName\cf0 , \cf3 false\cf0 );\
	if(\cf8 MultiTouchPad\cf0 .isRunning, \{\cf8 MultiTouchPad\cf0 .stop;\});\
	\{panSynth.free\}.try;\
	\
	if (outputButtonResponders.isNil.not, \{outputButtonResponders.do(\{\cf2 |it|\cf0  it.free\}); \});\
\};\
\
\
\
\
\cf4 //============== SYNTHDEFS ==================\cf0 \
\
	\cf8 SynthDef\cf0 (\cf9 \\gpLooperMono\cf0 , \{\
		\cf2 arg\cf0  bufnum=0, a= 0.01, s=1, r=0.1, rate= 1, amp=1, gate= 1, pan= 0, out= 0;\
		\cf2 var\cf0  env, signal;\
		env= \cf8 EnvGen\cf0 .kr(\cf8 Env\cf0 .asr(a, s, r), gate, doneAction:2);\
		signal= \cf8 PlayBuf\cf0 .ar(1, bufnum, rate, loop:1)*amp;\
		\cf8 Out\cf0 .ar(out, \cf8 Pan2\cf0 .ar(signal * env, pan))\
	\}).send(s);\
	\
	\cf8 SynthDef\cf0 (\cf9 \\gpLooperStereo\cf0 , \{\
		\cf2 arg\cf0  bufnum=0, a= 0.01, s=1, r=0.1, rate= 1, amp=1, gate= 1, pan= 0, out= 0;\
		\cf2 var\cf0  env, signal;\
		env= \cf8 EnvGen\cf0 .kr(\cf8 Env\cf0 .asr(a, s, r), gate, doneAction:2);\
		signal= \cf8 PlayBuf\cf0 .ar(2, bufnum, rate, loop:1)*amp;\
		\cf8 Out\cf0 .ar(out, \cf8 Balance2\cf0 .ar(signal[0], signal[1], pan) * env)\
	\}).send(s);\
	\
	\cf8 SynthDef\cf0 (\cf9 \\diskinMono\cf0 , \{ \cf2 arg\cf0  bufnum = 0, out= 0, a= 0.01, s=1, r=0.1, rate= 1, amp=1, gate= 1, pan= 0, synthID= 33;\
		\cf2 var\cf0  signal, env;\
		env= \cf8 EnvGen\cf0 .kr(\cf8 Env\cf0 .asr(a, s, r), gate, doneAction:2);\
		signal= \cf8 VDiskIn\cf0 .ar(1, bufnum, rate, 1, synthID) * amp;\
		\cf8 Out\cf0 .ar(out, \cf8 Pan2\cf0 .ar(signal * env, pan));\
	\}).send(s);\
	\
	\cf8 SynthDef\cf0 (\cf9 \\diskinStereo\cf0 , \{ \cf2 arg\cf0  bufnum = 0, out= 0, a= 0.01, s=1, r=0.1, rate= 1, amp=1, gate= 1, pan= 0, synthID= 3;\
		\cf2 var\cf0  signal, env;\
		env= \cf8 EnvGen\cf0 .kr(\cf8 Env\cf0 .asr(a, s, r), gate, doneAction:2);\
		signal= \cf8 VDiskIn\cf0 .ar(2, bufnum, rate, 1, synthID) * amp;\
		\cf8 Out\cf0 .ar(out, \cf8 Balance2\cf0 .ar(signal[0], signal[1], pan) * env);\
	\}).send(s);\
\
\cf8 SynthDef\cf0 (\cf9 \\FreeVerb2x2\cf0 , \{\cf2 |out= 0, mix = 0.25, room = 0.15, damp = 0.5, amp = 1.0|\cf0 \
	\cf2 var\cf0  signal;\
	signal = \cf8 In\cf0 .ar(out, 2);\
	\cf8 ReplaceOut\cf0 .ar(out,\
		\cf8 FreeVerb2\cf0 .ar( \cf4 // FreeVerb2 - true stereo UGen\cf0 \
			signal[0], \cf4 // Left channel\cf0 \
			signal[1], \cf4 // Right Channel\cf0 \
			mix, room, damp, amp)); \cf4 // same params as FreeVerb 1 chn version\cf0 \
\}).add;\
\
\cf8 SynthDef\cf0 (\cf9 \\panningHack\cf0 , \{\cf2 |out= 0, amp = 1.0, pan= 0|\cf0 \
	\cf2 var\cf0  signal;\
	signal = \cf8 In\cf0 .ar(out, 2);\
	\cf8 ReplaceOut\cf0 .ar(out, \cf8 Balance2\cf0 .ar(signal[0], signal[1], pan)*amp);\
\}).add;\
\
\
s.sync;\
\
\cf4 // Start some synths\cf0 \
\cf4 /*\
if (properties[key][10].isNil.not && builtin, \{out= properties[key][10] \}, \{\
			if (sounds[key].contains(folderRouting), //speech\
				\{ "speaking".postln; out= speechout; \}, \{ out= output;  \});\
			\});\
			*/\cf0 \
panSynth= \cf8 Synth\cf0 .tail(s, \cf9 \\panningHack\cf0 , [\cf9 \\out\cf0 , 0]);\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf5 ~mixerChans\cf0 .add(keyboardName -> panSynth);\
\
\
\};\
);\
\
\
\
\
}