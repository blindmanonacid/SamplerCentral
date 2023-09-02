{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf600
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;\red0\green0\blue255;\red51\green51\blue191;
\red191\green0\blue0;\red255\green102\blue0;\red96\green96\blue96;\red102\green102\blue191;\red0\green0\blue191;
\red0\green115\blue0;}
{\*\expandedcolortbl;;\csgenericrgb\c0\c0\c0;\csgenericrgb\c0\c0\c100000;\csgenericrgb\c20000\c20000\c75000;
\csgenericrgb\c75000\c0\c0;\csgenericrgb\c100000\c40000\c0;\csgenericrgb\c37500\c37500\c37500;\csgenericrgb\c40000\c40000\c75000;\csgenericrgb\c0\c0\c75000;
\csgenericrgb\c0\c45000\c0;}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 (\
s.waitForBoot\{\
\cf3 var\cf2  output;\
\cf3 var\cf2  w, sizes, colors, colorsOn, textcolors;\
\cf3 var\cf2  notes, on, off, a, c;\
\cf3 var\cf2  sounds, properties;\
\cf3 var\cf2  keyButs, propView;\
\cf3 var\cf2  knobView1, knobView2, knobs1to4, knobs5to8, allKnobs;\
\cf3 var\cf2  sliders, sliderView, ampspec, buffers;\
\cf3 var\cf2  knobSounds, sliderSounds;\
\cf3 var\cf2  midisrc, midisrcindex;\
\cf3 var\cf2  loadmenu, savefiles, files, backup, menuitem, wrefresh;\
\cf3 var\cf2  title;\
\cf3 var\cf2  responders1, responders2;\
\cf3 var\cf2  filesDir;\
\cf3 var\cf2  stopnote, playnote;\
\cf3 var\cf2  looppointeditor;\
\cf3 var\cf2  killothernotes, panic, velocitystate;\
\cf3 var\cf2  loadPreset;\
\cf3 var\cf2  currentPresetPath;\
\cf3 var\cf2  effectGroup, effView, revSynth;\
\cf3 var\cf2  t;\
\cf3 var\cf2  masterprop;\
\cf3 var\cf2  dirbutton;\
\cf3 var\cf2  extrasample= \cf4 false\cf2 , extrasampleView, soundsASR;\
\cf3 var\cf2  outputs, defaultProperties;\
\cf3 var\cf2  progressView, progress, progressViewClear, progressState;\
\cf3 var\cf2  timer;\
\cf3 var\cf2  space;\
\cf3 var\cf2  loadASRsound;\
\cf3 var\cf2  keyViews;\
\cf3 var\cf2  bender, bend;\
\cf3 var\cf2  speechout;\
\cf3 var\cf2  record, recordInstantly;\
\cf3 var\cf2  noteon, noteoff;\
\cf3 var\cf2  midichannel; \cf5 // remove midisendwindow\cf2 \
\cf3 var\cf2  recordingsPath;\
\cf3 var\cf2  reloadSavefiles;\
\cf3 var\cf2  errorFileMessage;\
\cf3 var\cf2  keyboardName, numKeys, startKey;\
\cf3 var\cf2  slidersCC, knobsCC;\
\cf3 var\cf2  midiDevice, midiPortName;\
\cf3 var\cf2  soundcard;\
\cf3 var\cf2  document, settings, settingsPath, thisFilePath;\
\cf3 var\cf2  windowHeight, keyHSize;\
\cf3 var\cf2  backgroundColor;\
\cf3 var\cf2  preferences, preferencesView, folderRouting;\
\cf3 var\cf2  preferencesFile, preferencesPath;\
\cf3 var\cf2  ruleFolderNames, rulesList, rulesApply, rulesOnOff;\
\cf3 var\cf2  arpRoutines, arpView;\
\cf3 var\cf2  ctrl, shift, alt;\
\cf3 var\cf2  keyPitch= 1, sliderPitch= 1, knobPitch= 1;\
\cf3 var\cf2  kaossFilesDir, fxDict;\
\cf3 var\cf2  verbose= \cf4 false\cf2 ;\
\cf3 var\cf2  touchOSC;\
\cf3 var\cf2  oscRoutines;\
\cf3 var\cf2  midiOut, sendWindow, sendWinOpen, sendWinLastTabFocus= 1, sendWinLastPos;\
\cf3 var\cf2  updatePreferenceButtons;\
\cf3 var\cf2  keyboardPressDown;\
\cf3 var\cf2  midiBut, oscBut, dmxBut, slPitchBut, knPitchBut, kyPitchBut, prViewBut;\
\cf3 var\cf2  coyoteResponders, coyoteRespondersPrevious, coyoteMidiResponders, midiRoutines;\
\cf3 var\cf2  oscLoopResponders;\
\cf3 var\cf2  midiInPriority, midiOutPriority;\
\cf3 var\cf2  keyUserViews, colorsOnUV;\
\cf3 var\cf2  previousMIDIProgMsg, panHackSynth;\
\cf3 var\cf2  robotPresetCheck, midiPresetCheck;\
\cf3 var\cf2  keyPropLabels;\
\cf3 var\cf2  builtin;\
\cf3 var\cf2  panSynth, panKnob;\
\cf3 var\cf2  noteArray;\
\cf3 var\cf2  sequencer, seqIsOpen= \cf4 false\cf2 ;\
\cf3 var\cf2  oscRecording= \cf4 false\cf2 ;\
\cf3 var\cf2  kbTransp= 0;\
\cf3 var\cf2  oscfilesDir;\
\cf3 var\cf2  loadPresetBut, outputButton, outputButtonResponders;\
\cf3 var\cf2  remoteOSCresponder;\
\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf6 ~recOSC\cf2 = \cf4 false\cf2 ;\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf5 // =============================================================================================\cf2 \
\cf5 // ======================================== SETTINGS ===========================================\cf2 \
\cf5 // =============================================================================================\cf2 \
\
outputs= [\cf4 nil\cf2 , 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26];\
noteArray= [\cf7 "(C 1)"\cf2 , \cf7 "(C# 1)"\cf2 , \cf7 "(D 1)"\cf2 , \cf7 "(D# 1)"\cf2 , \cf7 "(E 1)"\cf2 , \cf7 "(F 1)"\cf2 , \cf7 "(F# 1)"\cf2 , \cf7 "(G 1)"\cf2 , \cf7 "(G# 1)"\cf2 , \cf7 "(A 1)"\cf2 , \cf7 "(A# 1)"\cf2 , \cf7 "(B 1)"\cf2 , \cf7 "(C 2)"\cf2 , \cf7 "(C# 2)"\cf2 , \cf7 "(D 2)"\cf2 , \cf7 "(D# 2)"\cf2 , \cf7 "(E 2)"\cf2 , \cf7 "(F 2)"\cf2 , \cf7 "(F# 2)"\cf2 , \cf7 "(G 2)"\cf2 , \cf7 "(G# 2)"\cf2 , \cf7 "(A 2)"\cf2 , \cf7 "(A# 2)"\cf2 , \cf7 "(B 2)"\cf2 , \cf7 "(C 3)"\cf2 , \cf7 "(C# 3)"\cf2 , \cf7 "(D 3)"\cf2 , \cf7 "(D# 3)"\cf2 , \cf7 "(E 3)"\cf2 , \cf7 "(F 3)"\cf2 , \cf7 "(F# 3)"\cf2 , \cf7 "(G 3)"\cf2 , \cf7 "(G# 3)"\cf2 , \cf7 "(A 3)"\cf2 , \cf7 "(A# 3)"\cf2 , \cf7 "(B 3)"\cf2 , \cf7 "(C 4)"\cf2 , \cf7 "(C# 4)"\cf2 , \cf7 "(D 4)"\cf2 , \cf7 "(D# 4)"\cf2 , \cf7 "(E 4)"\cf2 , \cf7 "(F 4)"\cf2 , \cf7 "(F# 4)"\cf2 , \cf7 "(G 4)"\cf2 , \cf7 "(G# 4)"\cf2 , \cf7 "(A 4)"\cf2 , \cf7 "(A# 4)"\cf2 , \cf7 "(B 4)"\cf2 ];\
\
\cf5 //============== from settings file: ===================\cf2 \
\
thisFilePath= \cf8 thisProcess\cf2 .nowExecutingPath.standardizePath.dirname.dirname;\
\
keyboardName= \cf8 thisProcess\cf2 .nowExecutingPath.basename.drop(-4);\
document= \cf8 thisProcess\cf2 .nowExecutingPath.basename.drop(-4);\
settingsPath= (thisFilePath.standardizePath++\cf7 "/"\cf2 ++\cf7 "SETTINGS/"\cf2 ++keyboardName++\cf7 "SETUP"\cf2 );\
\cf5 //oscfilesDir= "/Users/martin/Desktop/OSCRecordings/";\cf2 \
oscfilesDir= (thisFilePath.standardizePath+/+\cf7 "OSCRecordings/"\cf2 );\
oscfilesDir.postln;\
\cf5 //settingsPath.postln;\cf2 \
\
settings= \cf9 Object\cf2 .readArchive(settingsPath);\
\cf5 //settings.postln;\cf2 \
numKeys= settings[0].asInteger;\
startKey= settings[1];\
knobsCC= settings[2];\
slidersCC= settings[3];\
\cf5 //name.string, = settings[4];\cf2 \
\cf5 //midiDevice= settings[5];\cf2 \
midiInPriority= settings[5];\
\cf5 //midiPortName= settings[6];\cf2 \
midiOutPriority= settings[6];\
backgroundColor= settings[7];\
\
\
\cf5 //Preferences, Overrides settings if exists.\cf2 \
\cf5 //folders routing preferences[] ?? folderRouting= preferences[];\cf2 \
\cf5 //sampler recordings - preferences[] ?? midichannel= preferences[];\cf2 \
\cf5 //preferences[] ?? midichannel = preferences[];\cf2 \
\cf5 // ?? do if nil\cf2 \
\
preferencesPath= (thisFilePath.standardizePath++\cf7 "/"\cf2 ++\cf7 "PREFERENCES/"\cf2 ++keyboardName);\
preferencesFile= (preferencesPath++\cf7 "/"\cf2 ++keyboardName++\cf7 "_CURRENT"\cf2 ).standardizePath;\
if (preferencesFile.isFile, \{\
	\
	preferences= \cf9 Object\cf2 .readArchive(preferencesFile);\
	\cf5 //("preferences:"+preferences).postln;\cf2 \
	numKeys= preferences[0].asInteger;\
	startKey= preferences[1];\
	knobsCC= preferences[2];\
	slidersCC= preferences[3];\
	\cf5 //name.string, = preferences[4];\cf2 \
	\cf5 //midiDevice= preferences[5];\cf2 \
	midiInPriority= preferences[5];\
	\cf5 //midiPortName= preferences[6];\cf2 \
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
\cf5 // set output to 1+2 if built in soundcard is used\cf2 \
(\cf7 "output after preferences:"\cf2 +output).postln;\
if (s.options.outDevice.contains(\cf7 "Built-in"\cf2 ), \{output= 0; builtin= \cf4 false\cf2 \}, \{builtin= \cf4 true\cf2 \});\
\
(\cf7 "MIDI IN PRIO"\cf2 +midiInPriority).postln;\
midiInPriority[0][0].class.postln;\
(\cf7 "MIDI OUT PRIO"\cf2 +midiOutPriority).postln;\
\
\cf5 /*\
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
*/\cf2 \
\
\
case \cf5 //calculate size\cf2 \
	\{ numKeys <= 37 \} \{keyHSize = 20\}\
	\{ numKeys <= 49 \} \{keyHSize = 15\}\
	\{ numKeys > 49 \} \{keyHSize = 10\};\
\
	windowHeight=  (numKeys*keyHSize).clip(600, 935);\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf9 Platform\cf2 .case(\
	\cf10 \\osx\cf2 ,		\{ ctrl= 262401; shift= 131330; alt= 524576; \},\
	\cf10 \\linux\cf2 ,		\{ ctrl= 262144; shift= 131072; \},\
	\cf10 \\windows\cf2 , 	\{ \cf7 "ERROR: havent tested this on Windows"\cf2 .postcs \}\
);\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf6 ~preferencesWindows\cf2 = \cf6 ~preferencesWindows\cf2  ?? \cf9 Dictionary\cf2 .new;\
\cf6 ~preferencesWindows\cf2 .put(keyboardName.asSymbol, \cf4 false\cf2 );\
filesDir= (\cf9 String\cf2 .scDir.dirname ++ \cf7 "/Resources/SAVEFILES/"\cf2 ++keyboardName++\cf7 "/"\cf2 );\
if(filesDir.isFolder.not, \{filesDir.makeDir\});\
recordingsPath= \cf7 "~/SamplerRecordings/"\cf2 ;\
if (recordingsPath.isFolder.not, \{ recordingsPath.makeDir \});\
if (output == \cf4 nil\cf2 , \{output= 0\});\
kaossFilesDir= (\cf9 String\cf2 .scDir.dirname ++ \cf7 "/Resources/KAOSSPADSAVES/"\cf2 );\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf5 //output= outputs[output];\cf2 \
if (midichannel == 0, \{midichannel= \cf4 nil\cf2 ;\});\
\
if (s.options.device == \cf4 nil\cf2 , \{output = 0\});\
\
\cf5 /*\
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
*/\cf2 \
\
\
\cf5 // ================ MIDI INITIALIZATION ================\cf2 \
\
\cf5 //midiInPriority= [["IAC Driver", "Bus 1"], nil, nil];\cf2 \
\cf5 //midiInPriority[0]= midiDevice;\cf2 \
\cf5 // connect midi in\cf2 \
midiInPriority.do(\{\cf3 |it, i|\cf2 \
	if (it.isNil.not and: \{midisrc.isNil\}, \{\
		\cf9 MIDIClient\cf2 .sources.do(\{ \cf3 |midiSource, i|\cf2 \
			\cf5 //("it device:"+midiSource.device.asString).postln;\cf2 \
			\cf5 //(midiSource).postln;\cf2 \
	\
			if((midiSource.device).contains(it[0]) and: \{midisrc.isNil\}, \{\
				midisrc= midiSource.uid; \
				midisrcindex= i;\
				(\cf7 "MIDI IN DEVICE:"\cf2 +it[0]).postln;\
				\cf5 //(it.uid).postln;\cf2 \
				\});\
		\});\
	\});\
\});\
\
if (midisrc.isNil.not, \{\
		\cf9 MIDIIn\cf2 .connectByUID(0, midisrc);\
	\},\{\
		\{\cf9 SCAlert\cf2 (\cf7 "No MIDI Keyboard connected"\cf2 , [\cf7 "OK!"\cf2 ]).focus(0)\}.defer(0.05);\
		midisrc= \cf4 nil\cf2 ; \
		midisrcindex= \cf4 nil\cf2 ;\
\});\
\
\
if(midisrc.isNil.not, \{\
if(\cf9 MIDIClient\cf2 .sources[midisrcindex].device.contains(\cf7 "Oxygen 49"\cf2 ), \{\
\
	outputButtonResponders= (31..39).collect(\{\cf3 |it, i|\cf2 \
		\cf9 CCResponder\cf2 (\{ \cf3 |src,chan,num,value|\cf2 \
\'a0 \'a0 	\'a0 \'a0 \cf5 //[src,chan,num,value].postln;\cf2 \
			\{outputButton.valueAction= i\}.defer;\
\'a0 \'a0 		\'a0 \'a0 \},\
		num: (it), src: midisrcindex, chan: midichannel\
	\'a0 \'a0 );\
	\});\
\
\});\
\});\
\
\cf5 /*\
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
*/\cf2 \
\
\cf5 //midisrcindex= 1;\cf2 \
\
\cf5 /*\
MIDIClient.sources.do(\{ |it, i|\
	if(it.uid== midisrc, \{midisrcindex= i\});\
	\});\
*/\cf2 \
\
\cf5 //("LE midisource: "++MIDIClient.sources.at(midisrcindex).asString).postln;\cf2 \
\
\cf5 //MIDIIn.connect(1, MIDIClient.sources.at(1));\cf2 \
\cf5 //MIDIIn.connect;\cf2 \
\
\cf5 /* \
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
*/\cf2 \
\
\cf5 //midiOutPriority= [["IAC Driver", "Bus 1"], nil, nil];\cf2 \
\cf5 // connect midi out\cf2 \
midiOutPriority.do(\{\cf3 |it, i|\cf2 \
	if (it.isNil.not and: \{midiOut.isNil\}, \{\
		if (\cf9 MIDIOut\cf2 .findPort(it[0], it[1]).isNil.not, \{\
			(\cf7 "MIDI OUT DEVICE:"\cf2 +it[0]).postln;\
			midiOut= \cf9 MIDIOut\cf2 .newByName(it[0], it[1]);\
		\});\
		\cf5 /*\
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
		*/\cf2 \
	\});\
\});\
\
\cf5 /*\
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
*/\cf2 	\
\
\cf5 //midiOut= MIDIOut.newByName("AudioFire12 (1576)", "Plug 1");\cf2 \
\cf5 //midiOut.latency= 0;\cf2 \
\
\
\
\
\cf5 // ================= DMX INITIALIZATION ===============\cf2 \
\
if (\cf6 ~dmx\cf2 .isNil, \{\
	\cf9 SerialPort\cf2 .devices.do(\{\cf3 |it|\cf2 \
		if (it.asSymbol == \cf10 '/dev/tty.usbserial-EN109012'\cf2 ,\
			\{ \cf7 "connecting dmx"\cf2 .postln;\
				\cf6 ~dmx\cf2 = \cf9 DMX\cf2 .new;\
				\cf5 //~dmx.device= EntTecDMXUSBPro.new( "/dev/tty.usbserial-EN109012" );\cf2 \
				\cf6 ~dmx\cf2 .currentCue= \cf9 DMXCue\cf2 .new; \cf5 //make into subcue....\cf2 \
				\cf5 //~dmx.setCue;\cf2 \
				(\cf7 "DMX is:"\cf2 +\cf6 ~dmx\cf2 ).postln;\
				(\cf7 "DMX current cue is:"\cf2 +\cf6 ~dmx\cf2 .currentCue).postln;\
		\});\
	\});\
\});\
\
\
\
\
\cf5 //============= SAMPLER INIT =============\cf2 \
\
\
\cf5 //a= RedDiskInSamplerGiga(s);\cf2 \
a= \cf9 RedCombiSampler\cf2 (s, 30); \cf5 //threshold of seconds to read from disk instead of ram\cf2 \
\
\
\
\
sounds= \cf9 Array\cf2 .newClear(numKeys);\
soundsASR= ([]!numKeys).asList;\
properties= numKeys.collect(\{ [0.5, 0, 0, 0.01, 0.1, 0, 0, 3, 0, 0, \cf4 nil\cf2 , [0, [0, 0], [0, 0], 0, 0.3, 0], [0.1, 0.2, 0], [0, 0, 1], 1, [0, \cf9 Dictionary\cf2 .new], [0, [\cf9 DMXSubCue\cf2 .new, \cf9 DMXSubCue\cf2 .new]] ].asList \});\
defaultProperties= numKeys.collect(\{ [0.5, 0, 0, 0.01, 0.1, 0, 0, 3, 0, 0, \cf4 nil\cf2 , [0, [0, 0], [0, 0], 0, 0.3, 0], [0.1, 0.2, 0], [0, 0, 1], 1, [0, \cf9 Dictionary\cf2 .new], [0, [\cf9 DMXSubCue\cf2 .new, \cf9 DMXSubCue\cf2 .new]] ].asList \});\
knobSounds= \cf4 nil\cf2 !knobsCC.size;\
sliderSounds= \cf4 nil\cf2 !slidersCC.size;\
masterprop= (\cf10 \\poly\cf2 : 0, \cf10 \\vel\cf2 : 0, \cf10 \\midi\cf2 : 0, \cf10 \\osc\cf2 : 0, \cf10 \\dmx\cf2 : 0, \cf10 \\slPitch\cf2 : 0, \cf10 \\knPitch\cf2 : 0, \cf10 \\kyPitch\cf2 : 1, \cf10 \\prView\cf2 : 1);\
progress= []!numKeys;\
timer = (0!numKeys).asList;\
arpRoutines= (0!numKeys);\
bend= 1;\
coyoteResponders= \cf9 Array\cf2 .newClear(numKeys);\
coyoteRespondersPrevious= \cf9 Array\cf2 .newClear(numKeys);\
coyoteMidiResponders= \cf9 Array\cf2 .newClear(numKeys);\
midiRoutines= \cf9 Array\cf2 .newClear(numKeys);\
oscRoutines= \cf9 List\cf2 .new ! numKeys;\
oscLoopResponders= \cf9 Array\cf2 .newClear(numKeys);\
keyboardPressDown= \cf4 true\cf2 !numKeys;\
\
ampspec= \cf9 ControlSpec\cf2 ( 0.001, 1.0,\cf10 \\amp\cf2 );\
\
sizes= [1, 0.7, 1, 0.7, 1, 1, 0.7, 1, 0.7, 1, 0.7, 1, ];\
\
colors= [\cf9 Color\cf2 .new255(160, 255, 160), \cf9 Color\cf2 .black, \cf9 Color\cf2 .white, \cf9 Color\cf2 .black, \cf9 Color\cf2 .white, \cf9 Color\cf2 .white, \cf9 Color\cf2 .black, \cf9 Color\cf2 .white, \cf9 Color\cf2 .black, \cf9 Color\cf2 .white, \cf9 Color\cf2 .black, \cf9 Color\cf2 .white];\
\
textcolors= [\cf9 Color\cf2 .black, \cf9 Color\cf2 .white, \cf9 Color\cf2 .black, \cf9 Color\cf2 .white, \cf9 Color\cf2 .black, \cf9 Color\cf2 .black, \cf9 Color\cf2 .white, \cf9 Color\cf2 .black, \cf9 Color\cf2 .white, \cf9 Color\cf2 .black, \cf9 Color\cf2 .white, \cf9 Color\cf2 .black];\
\
colorsOn= [\cf9 Color\cf2 .yellow.alpha_(0), \cf9 Color\cf2 .new255(255, 165, 0).alpha_(0), \cf9 Color\cf2 .yellow.alpha_(0), \cf9 Color\cf2 .new255(255, 165, 0).alpha_(0), \cf9 Color\cf2 .yellow.alpha_(0), \cf9 Color\cf2 .yellow.alpha_(0), \cf9 Color\cf2 .new255(255, 165, 0).alpha_(0), \cf9 Color\cf2 .yellow.alpha_(0), \cf9 Color\cf2 .new255(255, 165, 0).alpha_(0), \cf9 Color\cf2 .yellow.alpha_(0), \cf9 Color\cf2 .new255(255, 165, 0).alpha_(0), \cf9 Color\cf2 .yellow.alpha_(0)];\
\
colorsOnUV= [\cf9 Color\cf2 .yellow, \cf9 Color\cf2 .new255(255, 165, 0), \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .new255(255, 165, 0), \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .new255(255, 165, 0), \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .new255(255, 165, 0), \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .new255(255, 165, 0), \cf9 Color\cf2 .yellow];\
\
\
\
\cf5 // =============================================================================================\cf2 \
\cf5 // ===================================== MIDI RESPONDERS =======================================\cf2 \
\cf5 // =============================================================================================\cf2 \
\
\
\
noteon= \cf9 NoteOnResponder\cf2 (\{ \cf3 |src,chan,note,vel|\cf2 \
	\cf3 var\cf2  num, event= \cf4 nil\cf2 ;\
	\cf5 //[src,chan,note,vel].postln;\cf2 \
	note= note-startKey;\
	if(note.inRange(0, (numKeys-1)), \{\
		num= sounds[note];\
		if(verbose, \{(\cf7 "snd"\cf2 ++((note).asString)).postln;\});\
		if (velocitystate == 1, \{ vel= vel/127 \}, \{vel = \cf4 nil\cf2 \});\
		playnote.value(event, num, note, vel);\
	\},\
	\{\cf7 "key out of range"\cf2 .postln;\});\
	\},\
	midisrc, \cf5 // source\cf2 \
	midichannel \cf5 // channel\cf2 \
	);\
\
noteoff= \cf9 NoteOffResponder\cf2 (\{ \cf3 |src,chan,note,vel|\cf2 \
	\cf3 var\cf2  num;\
	\cf5 //[src,chan,note,vel].postln;\cf2 \
	note= note-startKey;\
		if(note.inRange(0, (numKeys-1)), \{\
			num= sounds[note];\
			stopnote.value(num, note);\
		\},\
		\{\cf7 "key out of range"\cf2 .postln;\});\
	\},\
	midisrc, \cf5 // source\cf2 \
	midichannel \cf5 // channel\cf2 \
	);\
	\
\
\cf5 // =============================================================================================\cf2 \
\cf5 // ======================================== NOTE ON ============================================\cf2 \
\cf5 // =============================================================================================\cf2 \
\
\cf5 //remove event\cf2 \
playnote= \{\cf3 |event, num, key, vel, id, dur|\cf2 \
	\cf3 var\cf2  amp, seq= 4, out, asrName, loopId;\
	\
	if(masterprop[\cf10 \\osc\cf2 ] == 1, \{ \
		properties[key][15][1].keysValuesDo(\{\cf3 |robot, value|\cf2 \
			\cf5 //if (value[1] == 1, \{ id= key \});\cf2 \
			if (value[1] == 1, \{ id= \cf9 UniqueID\cf2 .next; (\cf7 "id:"\cf2 +id).postln; \});\
		\});\
		if (properties[key][1]==1, \{loopId= \cf9 UniqueID\cf2 .next\});\
	\});\
\
	if (num.isNil.not, \{\
		\
		if (properties[key][10].isNil.not && builtin, \{out= properties[key][10] \}, \{\
			if (sounds[key].contains(folderRouting), \cf5 //speech\cf2 \
				\{ \cf7 "speaking"\cf2 .postln; out= speechout; \}, \{ out= output;  \});\
			\});\
		if( vel.isNil, \{amp = properties[key][0]\}, \{amp= vel\});\
		if( properties[key][5] == 1,\{\{killothernotes.value(key)\}.try\}); \cf5 //killa\cf2 \
		case\
		\{properties[key][2] == 0\} \cf5 //playback mode piano (default)\cf2 \
		\{\
			a.play((\cf7 "snd"\cf2 ++((key).asString)).asSymbol, \
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
			\cf5 //id.postln;\cf2 \
			if (progressState == 1, \{progressView.value(key)\});\
			\{ keyButs[key].value= 1; \}.defer;\
		\}\
		\{properties[key][2] == 1\} \cf5 //playback mode one shot\cf2 \
		\{a.play((\cf7 "snd"\cf2 ++((key).asString)).asSymbol, \
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
		\{properties[key][2] == 2\} \cf5 //playback mode toggle\cf2 \
		\{ \
			case \
			\{a.isPlaying((\cf7 "snd"\cf2 ++((key).asString)).asSymbol) == \cf4 false\cf2 \} \
			\{a.play((\cf7 "snd"\cf2 ++((key).asString)).asSymbol, \
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
				\cf5 //"it is not playing".postln;\cf2 \
				\{ keyButs[key].value= 1; \}.defer;\
				if (progressState == 1, \{progressView.value(key)\});\
			\}\
			\{a.isPlaying((\cf7 "snd"\cf2 ++((key).asString)).asSymbol)\}\
			\{stopnote.value(num, key, 1); \{ keyButs[key].value= 0; \}.defer; \};\
		\}\
		\{properties[key][2] == 3\} \cf5 //3 samples ASR\cf2 \
		\{ \
		a.play((\cf7 "snd"\cf2 ++((key).asString++\cf7 "a"\cf2 )).asSymbol, \cf5 //attack sound\cf2 \
				amp: amp,\
				loop: 0,\
				attack: 0.01,\
				sustain: dur,\
				pan: properties[key][9],\
				speed: properties[key][14] * bend,\
				offset: properties[key][13][0],\
				out: out\
			);	\
		a.play((\cf7 "snd"\cf2 ++((key).asString)).asSymbol, \cf5 //looped sound\cf2 \
				amp: amp,\
				loop: 1,\
				attack: properties[key][3],\
				sustain: dur,\
				pan: properties[key][9],\
				speed: properties[key][14] * bend,\
				offset: properties[key][13][0],\
				out: out\
			);\
			(\cf7 "key playnote"\cf2 +key).postln;\
			\{ keyButs[key].value= 1; \}.defer;\
		\}\
		\{properties[key][2] == 4\} \cf5 //2 samples \cf2 \
		\{ \
			if(properties[key][8] == 0, \{ \cf5 //shot\cf2 \
				a.stop((\cf7 "snd"\cf2 ++((key).asString++\cf7 "x0"\cf2 )).asSymbol, properties[key][4]);\
			\});\
			a.play((\cf7 "snd"\cf2 ++((key).asString)).asSymbol, \
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
		\{properties[key][2] == 5\} \cf5 //5 samples \cf2 \
		\{ \cf5 //"trying to play...".postln;\cf2 \
			if(properties[key][6] == 0, \{ \cf5 //sequence\cf2 \
				if ((\cf9 Date\cf2 .getDate.bootSeconds.round(1) - timer[key]) > 5, \{properties[key][7] = \cf4 nil\cf2 ;\});\
				if (properties[key][7].isNumber.not, \{properties[key][7]= 0\});\
				a.play((\cf7 "snd"\cf2 ++((key).asString++\cf7 "x"\cf2 ++(properties[key][7].asString))).asSymbol, \
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
				\{ keyButs[key].states= ([[asrName, textcolors[key.wrap(0, 12);], colors[key.wrap(0, 12);]], [asrName, \cf9 Color\cf2 .black, colorsOn[key.wrap(0, 12)]] ]); \
					\cf5 //key.deepCopy.wrap(0, 12).postln; \cf2 \
					\cf5 //key.postln; \cf2 \
					\}.defer;\
				properties[key][7]= (properties[key][7]+1).deepCopy.wrap(0, (soundsASR[key].size-1));\
				\cf5 //timer[key] = Date.getDate.bootSeconds.round(1);\cf2 \
\
			\});			\
			if(properties[key][6] == 1, \{ \cf5 //random\cf2 \
				properties[key][7]= (\cf7 "snd"\cf2 ++((key).asString++\cf7 "x"\cf2 ++((soundsASR[key].size.rand).asString))).asSymbol;\
				\cf5 //properties[key][7].postln;\cf2 \
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
			if(properties[key][6] == 2, \{ \cf5 // no reset\cf2 \
				\cf5 //if ((Date.getDate.bootSeconds.round(1) - timer[key]) > 5, \{properties[key][7] = nil;\});\cf2 \
				if (properties[key][7].isNumber.not, \{properties[key][7]= 0\});\
				a.play((\cf7 "snd"\cf2 ++((key).asString++\cf7 "x"\cf2 ++(properties[key][7].asString))).asSymbol, \
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
				\{ keyButs[key].states= ([[asrName, textcolors[key.wrap(0, 12);], colors[key.wrap(0, 12);]], [asrName, \cf9 Color\cf2 .black, colorsOn[key.wrap(0, 12)]] ]); \
					\cf5 //key.deepCopy.wrap(0, 12).postln; \cf2 \
					\cf5 //key.postln; \cf2 \
					\}.defer;\
				properties[key][7]= (properties[key][7]+1).deepCopy.wrap(0, (soundsASR[key].size-1));\
				\cf5 //timer[key] = Date.getDate.bootSeconds.round(1);\cf2 \
\
			\});		\
			\{ keyButs[key].value= 1; \}.defer;\
		\}\
		\{properties[key][2] == 6\} \cf5 //ARPEGGIO\cf2 \
		\{\
			case \
			\{arpRoutines[key].isPlaying.not\}\
			\{\
			arpRoutines[key]= \{\
			\cf3 var\cf2  length=0.3, timeToNext=0.1;\
			loop\{\
			length= properties[key][12][0];\
			timeToNext= properties[key][12][1];\
			a.play((\cf7 "snd"\cf2 ++((key).asString)).asSymbol, \
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
			a.stop((\cf7 "snd"\cf2 ++((key).asString)).asSymbol, properties[key][4]);\
			timeToNext.wait;\
			\};\
			\}.fork;\
			\{ keyButs[key].value= 1; \}.defer;\
			\}\
			\{arpRoutines[key].isPlaying\}\
			\{arpRoutines[key].stop;\
				a.stop((\cf7 "snd"\cf2 ++((key).asString)).asSymbol, properties[key][4]);\
				\{ keyButs[key].value= 0; \}.defer;\};\
		\};	\
	\});\
	\cf5 //\{ keyButs[key].value= 1; \}.defer;\cf2 \
	if( \cf6 ~logfile\cf2 .isNil.not, \{ \{\cf6 ~logfile\cf2 .write(\cf9 Date\cf2 .getDate.hourStamp.asString+(sounds[key].basename)++\cf7 "\\n"\cf2 )\}.defer; \});\
	\
	\cf5 //SEND MIDIOUT SYSEX\cf2 \
	if(masterprop[\cf10 \\midi\cf2 ] == 1, \{\
	if(midiOut.isNil.not, \{\
		if(properties[key][11][0] == 1, \{\
			\cf5 //("midiprops:"+properties[key][11]).postln;\cf2 \
				\cf5 //midiOut.control(1, properties[key][11][0], properties[key][11][1]) ;\cf2 \
				\cf5 //p.send($w, $a, 0, properties[key][11][0])\cf2 \
				case \
				\{properties[key][11][3] == 0\} \{	\cf5 // ------ play single value ------\cf2 \
					case\
					\{properties[key][11][5] == 0\} \{ \cf5 // submaster\cf2 \
						\cf5 //midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][1][0], 0x00, properties[key][11][1][1], 0x00, 0xf7]);\cf2 \
						midiOut.sysex(\cf9 ETCEonSysex\cf2 .submaster(1, properties[key][11][1][0], properties[key][11][1][1]));\
					\}\
					\{properties[key][11][5] == 1\} \{ \cf5 // macro\cf2 \
					\cf5 //midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x07, properties[key][11][1][0], 0xf7]);\cf2 \
						midiOut.sysex(\cf9 ETCEonSysex\cf2 .macro(1, properties[key][11][1][0]));\
					\}\
					\{properties[key][11][5] == 2\} \{ \cf5 // go cue\cf2 \
						midiOut.sysex(\cf9 ETCEonSysex\cf2 .goCue(1, properties[key][11][1][0], properties[key][11][1][1]));\
					\}\
					\{properties[key][11][5] == 3\} \{ \cf5 // grandmaster\cf2 \
						midiOut.sysex(\cf9 ETCEonSysex\cf2 .grandmaster(1, properties[key][11][1][1]));\
					\};\
				\}\
				\{properties[key][11][3] == 1\} \{	\cf5 // ------ play onset detection ------\cf2 \
					case\
					\{properties[key][11][5] == 0\} \{ \cf5 // submaster\cf2 \
						if(coyoteMidiResponders[key].isNil.not, \{coyoteMidiResponders[key].remove\});\
						coyoteMidiResponders[key] = \cf9 OSCresponderNode\cf2 (s.addr, \cf10 '/tr'\cf2 , \{ \cf3 arg\cf2  t, r, msg;\
							if (msg[2] == id, \{\
							\{\
							\cf5 //midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][1][0], 0x00, properties[key][11][1][1], 0x00, 0xf7]);\cf2 \
							midiOut.sysex(\cf9 ETCEonSysex\cf2 .submaster(1, properties[key][11][1][0], properties[key][11][1][1]));\
							properties[key][11][4].wait; \cf5 //duration.wait....\cf2 \
							\cf5 //midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][2][0], 0x00, properties[key][11][2][1], 0x00, 0xf7]);\cf2 \
							midiOut.sysex(\cf9 ETCEonSysex\cf2 .submaster(1, properties[key][11][2][0], properties[key][11][2][1]));\
						\}.fork;\
				\'a0 	\'a0 	\cf5 //[t, msg].postln;\cf2 \
						\});\
						\}).add;\
					\}\
					\{properties[key][11][5] == 1\} \{ \cf5 // macro\cf2 \
					\cf4 nil\cf2 \
					\}\
					\{properties[key][11][5] == 3\} \{ \cf5 // grandmaster\cf2 \
					\cf4 nil\cf2 \
					\};\
				\}\
				\
				\{properties[key][11][3] == 2\} \{	\cf5 // ------ play sequence ------\cf2 \
					\cf5 //"play midi sequence".postln;\cf2 \
					midiRoutines[key]= \cf9 Routine\cf2 \{\
						\cf3 var\cf2  values, duration, prevVal= \cf4 nil\cf2 ;\
						values= properties[key][11][1][1];\
						duration= properties[key][11][4];\
						\
						\cf5 //("values:"+values).postln;\cf2 \
						\cf5 //("duration:"+duration).postln;\cf2 \
						\
						loop\{\
							values.do(\{\cf3 |it, i|\cf2 \
\
								\cf5 //"do I get here?".postln;\cf2 \
								\cf5 //("whats is this:"+properties[key][11][1][1][1][i]).postln;\cf2 \
								\cf5 //("set value:"+(properties[key][11][1][1][1][i]*100)).postln;\cf2 \
								\cf5 // insert alternatives case here\cf2 \
								if( it != prevVal, \{\
								case\
								\{properties[key][11][5] == 0\} \{ \cf5 // submaster\cf2 \
									midiOut.sysex(\cf9 ETCEonSysex\cf2 .submaster(1, properties[key][11][1][0], it*100)); \}\
								\{properties[key][11][5] == 1\} \{ \cf5 // macro\cf2 \
									\cf4 nil\cf2 \
								\}\
								\{properties[key][11][5] == 3\} \{ \cf5 // grandmaster\cf2 \
									midiOut.sysex(\cf9 ETCEonSysex\cf2 .grandmaster(1, it*100));\
								\};\
								prevVal= it;\
								\});\
												\
								(duration/values.size).wait; \cf5 //*durationView.value\cf2 \
\
								\
								\});\
							\}\
					\}.play(\cf9 AppClock\cf2 );\
				\};\
		\});\
	\});\
	\});\
	\
	\cf5 // =========== SEND OSC ==============\cf2 \
	if(masterprop[\cf10 \\osc\cf2 ] == 1, \{\
	if( properties[key][15][0] == 1, \{\
		properties[key][15][1].keysValuesDo(\{\cf3 |robot, value|\cf2 \
			\cf5 //if (oscRecording, \{ NetAddr("localhost", NetAddr.langPort).sendMsg(~robotDict[robot][0]++value[0][0]); \});\cf2 \
			case \
			\{value[1] == 0\} \{	\cf5 // play single value\cf2 \
				(\cf7 "Note on OSC:"\cf2 +[robot, \cf6 ~robotDict\cf2 [robot][0], value[0][0]]).postln;\
				\cf9 NetAddr\cf2 (\cf6 ~ipDict\cf2 [robot][0], \cf6 ~ipDict\cf2 [robot][1]).sendMsg(\
					\cf6 ~robotDict\cf2 [robot][0]++value[0][0]);\
				if (\cf6 ~recOSC\cf2 , \{ \cf9 NetAddr\cf2 (\cf7 "localhost"\cf2 , \cf9 NetAddr\cf2 .langPort).sendMsg(\cf6 ~ipDict\cf2 [robot][0],\cf6 ~robotDict\cf2 [robot][0]++value[0][0]); \});\
			\}\
			\{value[1] == 1\} \{ \cf5 //play onset detection\cf2 \
				if(coyoteResponders[key].isNil.not, \{coyoteResponders[key].remove\});\
				coyoteResponders[key] = \cf9 OSCresponderNode\cf2 (s.addr, \cf10 '/tr'\cf2 , \{ \cf3 arg\cf2  t, r, msg;\
					(\cf7 "osc msg:"\cf2 +msg).postln; \cf5 //debug!\cf2 \
					if (msg[2]==id and: \{msg[3]!= coyoteRespondersPrevious[key]\}, \{\
						if (msg[3]==1, \{\
					(\cf7 "osc ON recieved"\cf2 +id.asString).postln;\
						\cf9 NetAddr\cf2 (\cf6 ~ipDict\cf2 [robot][0], \cf6 ~ipDict\cf2 [robot][1]).sendMsg(\cf6 ~robotDict\cf2 [robot][0]++value[0][0]);\
						\
						if (\cf6 ~recOSC\cf2 , \{ \cf9 NetAddr\cf2 (\cf7 "localhost"\cf2 , \cf9 NetAddr\cf2 .langPort).sendMsg(\cf6 ~ipDict\cf2 [robot][0],\cf6 ~robotDict\cf2 [robot][0]++value[0][0]); \});\
						\},\{\
					(\cf7 "osc OFF recieved"\cf2 +id.asString).postln;\
						\cf9 NetAddr\cf2 (\cf6 ~ipDict\cf2 [robot][0], \cf6 ~ipDict\cf2 [robot][1]).sendMsg(\cf6 ~robotDict\cf2 [robot][0]++value[0][1]);\
						if (\cf6 ~recOSC\cf2 , \{ \cf9 NetAddr\cf2 (\cf7 "localhost"\cf2 , \cf9 NetAddr\cf2 .langPort).sendMsg(\cf6 ~ipDict\cf2 [robot][0],\cf6 ~robotDict\cf2 [robot][0]++value[0][1]); \});\
						\});\
						coyoteRespondersPrevious[key]= msg[3];\
				\'a0 \'a0 	\cf5 //[t, msg].postln;\cf2 \
					\});\
				\}).add;\
			\}\
			\{value[1] == 2\} \{ \cf5 // play sequence recording\cf2 \
				oscRoutines[key].add(\cf9 OSCFileLogPlayer\cf2 .new(value[0][0], \cf9 NetAddr\cf2 (\cf6 ~ipDict\cf2 [robot][0], \cf6 ~ipDict\cf2 [robot][1])));\
				oscRoutines[key].last.play;\
				if (properties[key][1]==1, \{\
					\cf7 "making loop responder"\cf2 .postln;\
					if(oscLoopResponders[key].isNil.not, \{\
					oscLoopResponders[key]= \cf9 OSCresponderNode\cf2 (s.addr, \cf10 '/tr'\cf2 , \{ \cf3 arg\cf2  t, r, msg;\
					\cf5 //("osc loop msg:"+msg).postln; //debug!\cf2 \
					if (msg[2]==loopId, \{\
						oscRoutines[key].do(\{\cf3 |it|\cf2  it.stop \});\
						oscRoutines[key].do(\{\cf3 |it|\cf2  it.play \});\
						\});\
					\}).add;\
					\});\
				\});\
				\cf5 //("note on osc resp"+oscRoutines[key]).postln;\cf2 \
			\}\
			\{value[1] == 3\} \{	\cf5 // play single value\cf2 \
				(\cf7 "Note on ONLY OSC:"\cf2 +[robot, \cf6 ~robotDict\cf2 [robot][0], value[0][0]]).postln;\
				\cf9 NetAddr\cf2 (\cf6 ~ipDict\cf2 [robot][0], \cf6 ~ipDict\cf2 [robot][1]).sendMsg(\
					\cf6 ~robotDict\cf2 [robot][0]++value[0][0]);\
				if (\cf6 ~recOSC\cf2 , \{ \cf9 NetAddr\cf2 (\cf7 "localhost"\cf2 , \cf9 NetAddr\cf2 .langPort).sendMsg(\cf6 ~ipDict\cf2 [robot][0],\cf6 ~robotDict\cf2 [robot][0]++value[0][0]); \});\
			\}\
			\{value[1] == 4\} \{ \cf5 // send custom message\cf2 \
				\cf7 "custom note on"\cf2 .postln;\
				\cf6 ~ipDict\cf2 [robot][0].post; \cf6 ~ipDict\cf2 [robot][1].postln;\
				(value[0][0]).postln;\
				(value[0][1]).postln;\
				\cf9 NetAddr\cf2 (\cf6 ~ipDict\cf2 [robot][0], \cf6 ~ipDict\cf2 [robot][1]).sendBundle(value[0][0]);\
			\};\
		\});\
	\});\
	\});\
	\
	\cf5 //SEND DMX\cf2 \
	\cf5 //("DMX props:"+properties[key][16]).postln;\cf2 \
	if(masterprop[\cf10 \\dmx\cf2 ] == 1, \{\
	if( \cf6 ~dmx\cf2 .isNil.not, \{\
		if( properties[key][16][0] == 1, \{\
			\cf5 //("Sending DMX note ON:"+properties[key][16][1][0].data).postln;\cf2 \
			\cf5 //~dmx.fade(properties[key][16][1][0], 0.1, 'linear', 0.1);\cf2 \
			properties[key][16][1][0].data.keysValuesDo(\{\cf3 |chan, val|\cf2 \
				(\cf7 "chan:"\cf2 +chan+\cf7 "val:"\cf2 +val).postln;\
				\cf9 NetAddr\cf2 (\cf7 "127.0.0.1"\cf2 , 6666).sendMsg(\cf7 "/dmx"\cf2 +chan, val*100);\
			\});\
		\});\
	\});\
	\});\
	\
\};\
\
\
\cf5 // =============================================================================================\cf2 \
\cf5 // ======================================== NOTE OFF ===========================================\cf2 \
\cf5 // =============================================================================================\cf2 \
\
stopnote= \{\cf3 | num, key, forcestop, id|\cf2 \
	if (num.isNil.not, \{\
		\
			\cf5 //if(masterprop[\\osc] == 1, \{ id= key \}); //test\cf2 \
			\
		case\
		\{properties[key][2] == 0\} \{ \
			if(properties[key][8] == 0, \{ \cf5 //shot\cf2 \
				a.stop((\cf7 "snd"\cf2 ++((key).asString)).asSymbol, properties[key][4]);\
			\});\
			\{ keyButs[key].value= 0;\
				if (progressState == 1, \{\
					progress[key].stop; \
					progressViewClear.value(key) \
				\});\
				\}.defer; \
		\}\
		\{properties[key][2] == 3\} \{ \cf5 // 3 samples ASR\cf2 \
			a.stop((\cf7 "snd"\cf2 ++((key).asString)).asSymbol, properties[key][4]);\
			a.play((\cf7 "snd"\cf2 ++((key).asString++\cf7 "x1"\cf2 )).asSymbol, \cf5 //release sound\cf2 \
				amp: properties[key][0],\
				loop: 0,\
				out: output\
			);\
			\{ keyButs[key].value= 0; \}.defer;\
		\}\
		\{properties[key][2] == 4\} \{ \cf5 //2 samples - noteon/noteoff\cf2 \
			if(properties[key][8] == 0, \{ \cf5 //shot\cf2 \
				a.stop((\cf7 "snd"\cf2 ++((key).asString)).asSymbol, properties[key][4]);\
			\});\
			a.play((\cf7 "snd"\cf2 ++((key).asString++\cf7 "x0"\cf2 )).asSymbol, \cf5 //release sound\cf2 \
				amp: properties[key][0],\
				loop: 0,\
				out: output\
			);\
			\{ keyButs[key].value= 0; \}.defer;\
		\}\
		\{properties[key][2] == 5\} \{ \cf5 //many samples\cf2 \
			if(properties[key][8] == 0, \{ \cf5 // ---- if its not shot:\cf2 \
				if(properties[key][6] == 0, \{ \cf5 //sequence\cf2 \
					\cf5 //a.stop(("snd"++((key).asString++"x"++(properties[key][7].asString))).asSymbol, properties[key][4]);\cf2 \
					timer[key] = \cf9 Date\cf2 .getDate.bootSeconds.round(1);\
					a.stop((\cf7 "snd"\cf2 ++((key).asString++\cf7 "x"\cf2 ++(((properties[key][7]-1).wrap(0, (soundsASR[key].size-1))).asString))).asSymbol, properties[key][4]);\
				\{ keyButs[key].states= ([[soundsASR[key][properties[key][7]].basename.removeExtension, textcolors[key.wrap(0, 12);], colors[key.wrap(0, 12);]], [soundsASR[key][properties[key][7]].basename.removeExtension, \cf9 Color\cf2 .black, colorsOn[key.wrap(0, 12)]] ]) \}.defer;\
				\});\
				if(properties[key][6] == 1, \{ \cf5 //random\cf2 \
				a.stop(properties[key][7], properties[key][4]);\
				\});\
				if(properties[key][6] == 2, \{ \cf5 //sequence\cf2 \
					\cf5 //a.stop(("snd"++((key).asString++"x"++(properties[key][7].asString))).asSymbol, properties[key][4]);\cf2 \
					\cf5 //timer[key] = Date.getDate.bootSeconds.round(1);\cf2 \
					a.stop((\cf7 "snd"\cf2 ++((key).asString++\cf7 "x"\cf2 ++(((properties[key][7]-1).wrap(0, (soundsASR[key].size-1))).asString))).asSymbol, properties[key][4]);\
				\{ keyButs[key].states= ([[soundsASR[key][properties[key][7]].basename.removeExtension, textcolors[key.wrap(0, 12);], colors[key.wrap(0, 12);]], [soundsASR[key][properties[key][7]].basename.removeExtension, \cf9 Color\cf2 .black, colorsOn[key.wrap(0, 12)]] ]) \}.defer;\
				\});\
			\},\{ \cf5 // ------------------------------ if its not shot:\cf2 \
			if(properties[key][6] == 0, \{ \cf5 //sequence\cf2 \
					\cf5 //a.stop(("snd"++((key).asString++"x"++(properties[key][7].asString))).asSymbol, properties[key][4]);\cf2 \
					timer[key] = \cf9 Date\cf2 .getDate.bootSeconds.round(1);\
					\cf5 //a.stop(("snd"++((key).asString++"x"++(((properties[key][7]-1).wrap(0, (soundsASR[key].size-1))).asString))).asSymbol, properties[key][4]);\cf2 \
				\{ keyButs[key].states= ([[soundsASR[key][properties[key][7]].basename.removeExtension, textcolors[key.wrap(0, 11);], colors[key.wrap(0, 11);]], [soundsASR[key][properties[key][7]].basename.removeExtension, \cf9 Color\cf2 .black, colorsOn[key.wrap(0, 11)]] ]) \}.defer;\
				\});\
			if(properties[key][6] == 2, \{ \cf5 //sequence\cf2 \
					\cf5 //a.stop(("snd"++((key).asString++"x"++(properties[key][7].asString))).asSymbol, properties[key][4]);\cf2 \
					\cf5 //timer[key] = Date.getDate.bootSeconds.round(1);\cf2 \
					\cf5 //a.stop(("snd"++((key).asString++"x"++(((properties[key][7]-1).wrap(0, (soundsASR[key].size-1))).asString))).asSymbol, properties[key][4]);\cf2 \
				\{ keyButs[key].states= ([[soundsASR[key][properties[key][7]].basename.removeExtension, textcolors[key.wrap(0, 11);], colors[key.wrap(0, 11);]], [soundsASR[key][properties[key][7]].basename.removeExtension, \cf9 Color\cf2 .black, colorsOn[key.wrap(0, 11)]] ]) \}.defer;\
				\});\
	\
			\});\
\
			\
			\{ keyButs[key].value= 0; \}.defer;\
		\}\
		\{properties[key][2] == 6\} \cf5 //ARPEGGIO\cf2 \
		\{\
			if(properties[key][12][2]==0,\
			\{\
			arpRoutines[key].stop;\
			a.stop((\cf7 "snd"\cf2 ++((key).asString)).asSymbol, properties[key][4]);\
			\{ keyButs[key].value= 0; \}.defer;\
			\});\
			\
			\
		\};\
\
		if(forcestop.isNil.not, \{ \
			a.stop((\cf7 "snd"\cf2 ++((key).asString)).asSymbol, properties[key][4]); \
			\{ keyButs[key].value= 0; \}.defer;\
			if (progressState == 1, \{\
					progress[key].stop; \
					progressViewClear.value(key) \
			\});\
			\cf5 //"hva skjer a?".postln;\cf2 \
		\});	\
	\},\{\
		\{ keyButs[key].value= 0; \}.defer; \});\
		\
	\cf5 //SEND MIDI SYSEX\cf2 \
	\cf5 //if( properties[key][11].isNilNot, \{ midiOut.control(1, properties[key][11][0], 0) \});\cf2 \
	if(masterprop[\cf10 \\midi\cf2 ] == 1, \{\
		if(properties[key][11][0] == 1, \{\
			if(midiOut.isNil.not, \{\
				if( properties[key][11][2].isNil.not, \{ \
					\cf5 //midiOut.control(1, properties[key][11][0], properties[key][11][0]) ;\cf2 \
					\cf5 //p.send($w, $a, 0, 55)\cf2 \
					\cf5 //("sending midi on note OFF"+properties[key][11][2]).postln;\cf2 \
					\cf5 //midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][2][0], 0x00, properties[key][11][2][1], 0x00, 0xf7]);\cf2 \
				case \
				\{properties[key][11][3] == 0\} \{	\cf5 // ------ stop single value ------\cf2 \
					case\
					\{properties[key][11][5] == 0\} \{ \cf5 // submaster\cf2 \
						\cf5 //midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][2][0], 0x00, properties[key][11][2][1], 0x00, 0xf7]);\cf2 \
						midiOut.sysex(\cf9 ETCEonSysex\cf2 .submaster(1, properties[key][11][2][0], properties[key][11][2][1]));\
					\}\
					\{properties[key][11][5] == 1\} \{ \cf5 // macro\cf2 \
					\cf4 nil\cf2 \
					\}\
					\{properties[key][11][5] == 2\} \{ \cf5 // go cue\cf2 \
					\cf4 nil\cf2 \
					\}\
					\{properties[key][11][5] == 3\} \{ \cf5 // grandmaster\cf2 \
					\cf5 //midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, 0x7e, 0x03, properties[key][11][2][1], 0x00, 0xf7]);\cf2 \
					midiOut.sysex(\cf9 ETCEonSysex\cf2 .grandmaster(1, properties[key][11][2][1]));\
					\};\
				\}\
				\{properties[key][11][3] == 1\} \{	\cf5 // ------ stop onset detection ------\cf2 \
					case\
					\{properties[key][11][5] == 0\} \{ \cf5 // submaster\cf2 \
						coyoteMidiResponders[key].remove;\
						\cf5 //midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][2][0], 0x00, properties[key][11][2][1], 0x00, 0xf7]);\cf2 \
						midiOut.sysex(\cf9 ETCEonSysex\cf2 .submaster(1, properties[key][11][2][0], properties[key][11][2][1]));\
					\}\
					\{properties[key][11][5] == 1\} \{ \cf5 // macro\cf2 \
					coyoteMidiResponders[key].remove;\
					\}\
					\{properties[key][11][5] == 3\} \{ \cf5 // grandmaster\cf2 \
					coyoteMidiResponders[key].remove;\
					\cf5 //midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, 0x7e, 0x03, properties[key][11][2][1], 0x00, 0xf7]);\cf2 \
					midiOut.sysex(\cf9 ETCEonSysex\cf2 .grandmaster(1, properties[key][11][2][1]));\
					\};\
				\}\
				\
				\{properties[key][11][3] == 2\} \{	\cf5 // ------ stop sequence ------\cf2 \
					midiRoutines[key].stop;\
					\cf5 //midiOut.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][2][0], 0x00, properties[key][11][2][1], 0x00, 0xf7]);\cf2 \
					case\
					\{properties[key][11][5] == 0\} \{ \cf5 // submaster\cf2 \
						midiOut.sysex(\cf9 ETCEonSysex\cf2 .submaster(1, properties[key][11][2][0], properties[key][11][2][1])); \}\
					\{properties[key][11][5] == 3\} \{ \cf5 // grandmaster\cf2 \
					midiOut.sysex(\cf9 ETCEonSysex\cf2 .grandmaster(1, properties[key][11][2][1]));\
					\};\
				\};\
\
				\});			\
			\});\
		\});\
	\});\
	\cf5 //SEND OSC\cf2 \
	if(masterprop[\cf10 \\osc\cf2 ] == 1, \{\
		if( properties[key][15][0] == 1, \{\
			properties[key][15][1].keysValuesDo(\{\cf3 |robot, value|\cf2 \
				if( value[1] == 2, \{\
					if (properties[key][1]==1, \{ if(oscLoopResponders[key].isNil.not, \{\
						oscLoopResponders[key].remove; oscLoopResponders[key]= \cf4 nil\cf2 ; \
						\});\
					\});\
					oscRoutines[key].last.stop; oscRoutines[key].last.close; oscRoutines[key].pop;\
					\cf5 //("note on osc resp"+oscRoutines[key]).postln;\cf2 \
					\});\
				if (value[1] == 1, \{ coyoteResponders[key].remove; coyoteRespondersPrevious[key]= \cf4 nil\cf2 ; \});\
				if(value[1] == 3, \{\cf4 nil\cf2 \}, \{ \cf5 // no note off\cf2 \
				if (\cf6 ~recOSC\cf2 , \{ \cf9 NetAddr\cf2 (\cf7 "localhost"\cf2 , \cf9 NetAddr\cf2 .langPort).sendMsg(\cf6 ~ipDict\cf2 [robot][0],\cf6 ~robotDict\cf2 [robot][0]++value[0][1]); \});\
				\cf9 NetAddr\cf2 (\cf6 ~ipDict\cf2 [robot][0], \cf6 ~ipDict\cf2 [robot][1]).sendMsg(\cf6 ~robotDict\cf2 [robot][0]++value[0][1]);\
				\});\
				\cf5 //("Note off OSC:"+[robot, ~robotDict[robot][0], value[0][1]]).postln;\cf2 \
				 \cf5 //a NetAddr .send(properties[key][15][1], properties[key][15][2][0]);\cf2 \
			\});\
			\cf5 //coyoteResponders.postln;\cf2 \
		\});\
	\});\
	\cf5 //SEND DMX\cf2 \
	if(masterprop[\cf10 \\dmx\cf2 ] == 1, \{\
		if( \cf6 ~dmx\cf2 .isNil.not, \{\
			if( properties[key][16][0] == 1, \{ \
				\cf5 //~dmx.fade(properties[key][16][1][1], 0.5, 'linear', 0.1)\cf2 \
				properties[key][16][1][1].data.keysValuesDo(\{\cf3 |chan, val|\cf2 \
					(\cf7 "chan:"\cf2 +chan+\cf7 "val:"\cf2 +val).postln;\
					\cf9 NetAddr\cf2 (\cf7 "127.0.0.1"\cf2 , 6666).sendMsg(\cf7 "dmx"\cf2 , chan, val*100);\
				\});		\});\
		\});\
	\});\
\};\
\
\
\
\
\
	backup= \{\cf3 |file|\cf2 \
		\cf3 var\cf2  filename, backupname, backupdir, dir;\
		file= file.basename;\
		dir= filesDir;\
		backupdir= dir++\cf7 "backup/"\cf2 ;\
		\
		if (\cf9 File\cf2 .exists(dir++file)) \{\
			if(backupdir.isFolder.not, \{backupdir.makeDir\});\
			\
			backupname = file ++ \cf7 ".backup_"\cf2  ++ \cf9 Date\cf2 .getDate.stamp;\
			\
			(dir++file).moveTo(dir++\cf7 "backup/"\cf2 , backupname)\
\
		\};\
		\
	\};\
\
\
\cf5 // =============================================================================================\cf2 \
\cf5 // ================================= GUI - LOAD / SAVE =========================================\cf2 \
\cf5 // =============================================================================================\cf2 \
\
\
w= \cf9 Window\cf2 .new(keyboardName, \cf9 Rect\cf2 (0, 0, 610, 935));\
w.view.background_(backgroundColor);\
\
\cf5 /*\
Button.new(w, Rect(20, 20, 50, 20))\
.states_([["on", Color.black, Color.grey], ["on", Color.black, Color.green]])\
.value_(1)\
.action_(\{ | v |\
	if (v.value == 1, \
	\{on.play; off.play\}, \
	\{on.stop; off.stop\});	\
\});\
*/\cf2 \
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf9 Button\cf2 .new(w, \cf9 Rect\cf2 (20, 20, 60, 20))\
.states_([[\cf7 "setup"\cf2 , \cf9 Color\cf2 .white, \cf9 Color\cf2 .black]])\
.canFocus_(\cf4 false\cf2 )\
.action_(\{ \cf3 | v |\cf2 \
	if(\cf6 ~preferencesWindows\cf2 [keyboardName.asSymbol] == \cf4 false\cf2 , \{\
		preferencesView.value();\
		\cf6 ~preferencesWindows\cf2 .put(keyboardName.asSymbol, \cf4 true\cf2 );\
	\});\
\});\
\
\
title= \cf9 StaticText\cf2 (w, \cf9 Rect\cf2 (80, 20, 120, 20))\
.background_(\cf9 Color\cf2 .grey.alpha_(0.3));\
\
\cf9 Button\cf2 (w, \cf9 Rect\cf2 (260, 50, 30, 20))\
.states_([[\cf7 "S"\cf2 ]])\
.canFocus_(\cf4 false\cf2 )\
.action_(\{\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf5 //save preset\cf2 \
\cf3 var\cf2  w, t, saveBut;\
	w= \cf9 Window\cf2 (\cf7 "save"\cf2 , \cf9 Rect\cf2 (400, 400, 300, 100))\
	.alwaysOnTop_(\cf4 true\cf2 );\
\
	t= \cf9 TextView\cf2 (w, \cf9 Rect\cf2 (10, 10, 280, 20))\
	.focus(\cf4 true\cf2 )\
	.keyDownAction_(\{\cf3 |view, char, mod, uni, key|\cf2 \
		if(key == 36, \{ saveBut.valueAction= 1 \});\
	\});\
\
	saveBut= \cf9 Button\cf2 (w, \cf9 Rect\cf2 (10, 40, 100, 40))\
	.states_([[\cf7 "save"\cf2 ]])\
	.action_(\{\
		\cf3 var\cf2  values, path, stringSize;\
		stringSize= t.string.size;\
		if (stringSize > 0, \{\
			\
			path= filesDir++(t.string);\
			backup.value(path);\
			knobSounds= allKnobs.collect(\{ \cf3 |it, i|\cf2 \
				\{it.getValues\}.try;\
			\});\
			\
			sliderSounds= sliders.collect(\{ \cf3 |it, i|\cf2 \
				\{it.getValues\}.try;\
			\});\
\
			values= [sounds, properties, knobSounds, sliderSounds, soundsASR, masterprop];\
			values.writeArchive(path);\
			currentPresetPath= path;\
			dirbutton.doAction;\
			title.string= path.basename;\
			title.align= \cf10 \\center\cf2 ;\
			reloadSavefiles.value;\
			w.close;\
		\});\
\
		\
	\});\
	\
	\cf9 Button\cf2 (w, \cf9 Rect\cf2 (120, 40, 100, 40))\
	.states_([[\cf7 "cancel"\cf2 ]])\
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
	files= (filesDir++\cf7 "*"\cf2 ).standardizePath.pathMatch;\
	savefiles= files.addFirst(\cf7 "none"\cf2 );\
	files= files.addFirst(\cf7 "none"\cf2 );\
	savefiles= savefiles.collect(\{\cf3 |it|\cf2  it.basename\});\
	loadmenu.items= ( savefiles );\
\};\
\
\
files= (filesDir++\cf7 "*"\cf2 ).standardizePath.pathMatch;\
savefiles= files.addFirst(\cf7 "none"\cf2 );\
files= files.addFirst(\cf7 "none"\cf2 );\
savefiles= savefiles.collect(\{\cf3 |it|\cf2  it.basename\});\
\
loadmenu= \cf9 PopUpMenu\cf2 (w, \cf9 Rect\cf2 (80, 50, 120, 30))\
\cf5 //.canFocus_(false)\cf2 \
.stringColor_(\cf9 Color\cf2 .green)\
.background_(\cf9 Color\cf2 .grey.alpha_(0.5))\
.items_( savefiles )\
.keyDownAction_(\{\cf3 |view, char|\cf2 \
	if(char==$\\r, \{\
		\cf5 //"return".postln; \cf2 \
		\cf5 //view.focus_(false);\cf2 \
		\{loadPresetBut.mouseDownAction.value(\cf4 nil\cf2 , 0, 0, 0, 0, 1)\}.defer;\
		\});\
	\
	 \})\
.action_(\{ \cf3 |v|\cf2 \
	menuitem= v.items.at(v.value);\
	\cf5 //menuitem.postln;\cf2 \
	\cf5 //files[loadmenu.value].postln;\cf2 \
	\cf5 //("menu size:"+loadmenu.items.size).postln;\cf2 \
	\cf5 //("files size:"+files.size).postln;\cf2 \
	\cf5 //("loadmenu fileS:"+loadmenu.items).postcs;\cf2 \
	\cf5 //("files fileS:"+files).postcs;\cf2 \
\});\
menuitem= \cf7 "none"\cf2 ;\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf9 StaticText\cf2 (w, \cf9 Rect\cf2 (20, 50, 60, 15))\
.string_(\cf7 "Presets:"\cf2 )\
.background_(\cf9 Color\cf2 .grey.alpha_(0.5))\
.align_(\cf10 \\center\cf2 );\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf5 //.font_(Font("Monaco", 9));\cf2 \
\
dirbutton= \cf9 Button\cf2 (w, \cf9 Rect\cf2 (20, 65, 60, 15))\
.canFocus_(\cf4 false\cf2 )\
.states_([[\cf7 "saves"\cf2 ], [\cf7 "backup"\cf2 ] ])\
.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 , 9))\
.action_(\{ \cf3 |v|\cf2 \
	\cf3 var\cf2  directory;\
	if (v.value == 1, \{\
		directory= filesDir++\cf7 "backup/"\cf2 ; \
		\},\{\
		directory= filesDir;\
	\});\
	files= (directory++\cf7 "*"\cf2 ).standardizePath.pathMatch;\
	savefiles= files.addFirst(\cf7 "none"\cf2 );\
	files= files.addFirst(\cf7 "none"\cf2 );\
	savefiles= savefiles.collect(\{\cf3 |it|\cf2  it.basename\});\
	loadmenu.items= savefiles;\
\});\
\
wrefresh= \{ \{2.wait; \{w.refresh\}.defer \}.fork \};\
\
loadPresetBut= \cf9 Button\cf2 (w, \cf9 Rect\cf2 (200, 50, 30, 20))\
.canFocus_(\cf4 false\cf2 )\
.states_([[\cf7 "L"\cf2 , \cf9 Color\cf2 .red, \cf9 Color\cf2 .black]])\
.mouseDownAction_(\{ \cf3 |view, x, y, mod|\cf2 \
	if( mod.isAlt, \{\
			if (dirbutton.value == 0, \{\
				currentPresetPath= filesDir++loadmenu.item;\
			\},\{\
				currentPresetPath= filesDir++\cf7 "backup/"\cf2 ++loadmenu.item;\
\
			\});\
			currentPresetPath.removeFile;\
			reloadSavefiles.value;\
			title.string= \cf7 "none"\cf2 ;\
			title.align= \cf10 \\center\cf2 ;\
			\
	\},\{\
\
		\cf3 var\cf2  values, file, oldPropSize, shaveCheck;\
		if (menuitem == \cf7 "none"\cf2  or: \{menuitem == \cf7 "backup"\cf2 \}, \{\cf4 nil\cf2 \}, \{\
		a.free;\
		\cf5 //t.view.remove;\cf2 \
		c.remove;\
		\cf5 //("loading"+files[loadmenu.value]).postln;\cf2 \
		\cf5 //values= Object.readArchive(files[loadmenu.value]);\cf2 \
		if (dirbutton.value == 0, \{\
			currentPresetPath= filesDir++loadmenu.item;\
			(\cf7 "loading"\cf2 +(filesDir++loadmenu.item)).postln;\
			values= \cf9 Object\cf2 .readArchive((filesDir++loadmenu.item));\
		\},\{\
			currentPresetPath= filesDir++\cf7 "backup/"\cf2 ++loadmenu.item;\
			(\cf7 "loading"\cf2 +(filesDir++\cf7 "backup/"\cf2 ++loadmenu.item)).postln;\
			values= \cf9 Object\cf2 .readArchive((filesDir++\cf7 "backup/"\cf2 ++loadmenu.item));\
		\});\
		\cf5 //values.postcs;\cf2 \
		sounds= values[0];\
		properties= values[1];\
		if(values[4].isNil.not, \{soundsASR= values[4]\},\{\
			soundsASR= ([]!numKeys).asList;\
		\});\
		if (values[5].isNil.not, \{masterprop= values[5].deepCopy\});\
		updatePreferenceButtons.value;\
		\cf5 //free all previous buffers\cf2 \
		\cf5 //load new buffers\cf2 \
		numKeys.do(\{ \cf3 |i|\cf2 \
			\cf3 var\cf2  check;\
			check= sounds[i];\
			if (check.isNil.not, \{\
				if (\cf9 File\cf2 .exists(sounds[i]), \{\
			file= sounds[i].basename.replace(\cf7 ".wav"\cf2 , \cf7 ""\cf2 );\
			a.prepareForPlay((\cf7 "snd"\cf2 ++i.asString).asSymbol, sounds[i]);\
			soundsASR[i].size.do(\{ \cf3 |it, ii|\cf2 \
				if(soundsASR[i][ii].isNil.not, \{\
					a.prepareForPlay((\cf7 "snd"\cf2 ++i.asString++\cf7 "x"\cf2 ++(ii.asString)).asSymbol, soundsASR[i][ii]); (\cf7 "asr"\cf2 +ii).postln;\
				\});\
			\});\
			\{keyButs[i].states= ([[file, textcolors[i.wrap(0, 11)], colors[i.wrap(0, 11)]], [file, \cf9 Color\cf2 .black, colorsOn[i.wrap(0, 11)]] ]);\}.defer;\
				\},\{\
					(\cf7 "warning"\cf2 +sounds[i]+\cf7 "does not exist"\cf2 ).postln;\
					sounds[i]= \cf4 nil\cf2 ; \
					\{keyButs[i].states= ([[\cf7 ""\cf2 , textcolors[i.wrap(0, 11)], colors[i.wrap(0, 11)]], [\cf7 ""\cf2 , textcolors[i.wrap(0, 11)], colorsOn[i.wrap(0, 11)]]]);\}.defer;\
					\});\
				\}, \{\
			\{keyButs[i].states= ([[\cf7 ""\cf2 , textcolors[i.wrap(0, 11)], colors[i.wrap(0, 11)]], [\cf7 ""\cf2 , textcolors[i.wrap(0, 11)], colorsOn[i.wrap(0, 11)]]]);\}.defer;\
			\});\
		\});\
		allKnobs.do(\{ \cf3 |it, i|\cf2 \
			\{it.setValues(values[2][i])\}.try\
		\});\
		sliders.do(\{ \cf3 |it, i|\cf2 \
			\{it.setValues(values[3][i])\}.try\
		\});\
\
		\
		title.string= menuitem;\
		title.align= \cf10 \\center\cf2 ;\
\
		wrefresh.value;\
		\
		\cf5 // shave buggy values from previous samplers... ugh!\cf2 \
		shaveCheck= properties.collect(\{\cf3 |it|\cf2 \
			it.size;\
		\});\
		if( shaveCheck.sort.first != shaveCheck.sort.last, \{\
			if( shaveCheck.sort.last > 11, \{\
				properties.do(\{\cf3 |it|\cf2 \
					while(\
						\{it.size > 11\}, \{ it.pop; \}); \cf5 // 11\cf2 \
				\});\
			\});	\
		\});\
		\
		\
		\cf5 //backwards compability\cf2 \
		if (properties[0].size < defaultProperties.size, \{\
			\cf5 //("old properties:"+properties).postln;\cf2 \
			properties= properties.asList;\
			oldPropSize= properties[0].size.deepCopy-1;\
			defaultProperties.do(\{ \cf3 |it, i|\cf2 \
				\cf5 //("old props"+properties[i]).postln;\cf2 \
				\cf5 //("---->"+i).postln;\cf2 \
				\cf5 //var oldPropSize= properties[i].size.deepCopy-1;\cf2 \
				it.do(\{ \cf3 |itt, ii|\cf2 \
					\cf5 //ii.postln;\cf2 \
					if (ii > oldPropSize,\
					\cf5 //if (properties[i][ii].isNil,\cf2 \
						\{ properties[i]= properties[i].add(it[ii]); \});\
				\});\
				\cf5 //properties[i].postln;\cf2 \
			\});\
			\cf5 //("new properties:"+properties).postln;\cf2 \
		\});\
		\
		\cf5 /*\
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
		*/\cf2 \
		properties[0].postln;\
		\});\
		\{w.refresh\}.defer;\
		sliders[0].title.postln;\
	\});\
\});\
\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf9 Button\cf2 (w, \cf9 Rect\cf2 (230, 50, 30, 20))\
.canFocus_(\cf4 false\cf2 )\
.states_([[\cf7 "qs"\cf2 , \cf9 Color\cf2 .white, \cf9 Color\cf2 .grey]])\
.action_(\{ \cf3 |v|\cf2 \
		\cf3 var\cf2  values, path;\
		path= currentPresetPath;\
		backup.value(path);\
		knobSounds= allKnobs.collect(\{ \cf3 |it, i|\cf2 \
			\{it.getValues\}.try;\
		\});\
		sliderSounds= sliders.collect(\{ \cf3 |it, i|\cf2 \
			\{it.getValues\}.try;\
		\});\
		values= [sounds, properties, knobSounds, sliderSounds, soundsASR, masterprop];\
		values.writeArchive(path);\
\});\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf5 // =============================================================================================\cf2 \
\cf5 // ================================= GUI - PREFERENCE BUTTONS ==================================\cf2 \
\cf5 // =============================================================================================\cf2 \
\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf9 Button\cf2 (w, \cf9 Rect\cf2 (410,300, 30, 30))\
.states_([[\cf7 "SEQ"\cf2 , \cf9 Color\cf2 .black]])\
.action_(\{\cf3 |v|\cf2 \
	if(seqIsOpen, \{ \cf4 nil\cf2  \}, \{ sequencer.value; seqIsOpen= \cf4 true\cf2  \});\
	\cf5 //if (v.value==1 && panSynth.isNil, \{panSynth= Synth.tail(s, \\PanningHack)\}, \{ panSynth.free; panSynth= nil\})\cf2 \
\});\
\
\cf9 Button\cf2 (w, \cf9 Rect\cf2 (410,350, 50, 30))\
.states_([[\cf7 "remote"\cf2 , \cf9 Color\cf2 .black], [\cf7 "remote"\cf2 , \cf9 Color\cf2 .white]])\
.action_(\{\cf3 |v|\cf2 \
	touchOSC.value;\
\});\
\
panKnob= \cf9 Knob\cf2 (w, \cf9 Rect\cf2 (410, 460, 30, 30))\
.centered_(\cf4 true\cf2 )\
.canFocus_(\cf4 false\cf2 )\
.value_(\cf10 \\pan\cf2 .asSpec.unmap(0))\
.action_(\{ \cf3 |v|\cf2 \
	\cf5 //pan= (\\pan.asSpec.map(v.value));\cf2 \
	\cf5 //if(firstRun.not, \{syn.set(\\pan, \\pan.asSpec.map(v.value))\});\cf2 \
	if (panSynth.isNil.not, \{ \{panSynth.set(\cf10 \\pan\cf2 , \cf10 \\pan\cf2 .asSpec.map(v.value))\}.try \});\
\})\
.color_([\cf9 Color\cf2 .gray, \cf9 Color\cf2 .red, \cf9 Color\cf2 .white, \cf9 Color\cf2 .black])\
.mouseDownAction_(\{\cf3 |view, x, y, mod|\cf2 \
	if (mod == alt, \{view.valueAction= \cf10 \\pan\cf2 .asSpec.unmap(0);\})\
\})\
.canReceiveDragHandler_(\cf4 true\cf2 )\
.receiveDragHandler_(\{\cf3 |view|\cf2 \
	\cf3 var\cf2  drag;\
	drag= \cf9 View\cf2 .currentDrag;\
	if (drag.class == \cf9 UC33LoopChan\cf2 , \{\
		drag.setAction(\{\cf3 |v|\cf2 \{ panKnob.valueAction_(v.value)\}.defer \}, \cf7 "MAIN"\cf2 );\
	\});\
\});\
\
\
outputButton= \cf9 Button\cf2 (w, \cf9 Rect\cf2 (400, 400, 50, 30))\
.states_([[\cf7 "nil"\cf2 , \cf9 Color\cf2 .black, \cf9 Color\cf2 .grey], [\cf7 "1-2"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .black],[\cf7 "3-4"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .black], [\cf7 "5-6"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .black], [\cf7 "7-8"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .black], [\cf7 "9-10"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .black], [\cf7 "11-12"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .black], [\cf7 "13-14"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .black], [\cf7 "15-16"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .black], [\cf7 "17-18"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .black], [\cf7 "19-20"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .black], [\cf7 "21-22"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .black], [\cf7 "23-24"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .black], [\cf7 "25-26"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .black] ])\
.canFocus_(\cf4 false\cf2 )\
.value_(preferences[13])\
.action_(\{ \cf3 |v|\cf2 \
	output= outputs[v.value];\
	sliders.do(\{ \cf3 |it|\cf2  it.defaultout_(outputs[v.value]); it.reloadSampleSoft;\});\
	allKnobs.do(\{ \cf3 |it|\cf2  it.defaultout_(outputs[v.value]); it.reloadSampleSoft; \});\
\});\
\
\cf9 Button\cf2 (w, \cf9 Rect\cf2 (250, 20, 40, 20))\
.canFocus_(\cf4 false\cf2 )\
.states_([[\cf7 "panic"\cf2 , \cf9 Color\cf2 .black, \cf9 Color\cf2 .grey]])\
.action_(\{ \cf3 |v|\cf2 \
	panic.value;\
\});\
\
progressState= masterprop[\cf10 \\prView\cf2 ];\
prViewBut= \cf9 Button\cf2 (w, \cf9 Rect\cf2 (290, 20, 50, 20))\
.canFocus_(\cf4 false\cf2 )\
.states_([[\cf7 "pr view"\cf2 , \cf9 Color\cf2 .white, \cf9 Color\cf2 .grey], [\cf7 "pr view"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .grey]])\
.value_(progressState)\
.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 , 10))\
.action_(\{ \cf3 |v|\cf2 \
	progressState= v.value;\
	sliders.do(\{\cf3 |it|\cf2  it.progress(v.value) \});\
	allKnobs.do(\{\cf3 |it|\cf2  it.progress(v.value) \});\
	masterprop[\cf10 \\prView\cf2 ]= v.value;\
\});\
\
sliderPitch= masterprop[\cf10 \\slPitch\cf2 ];\
slPitchBut= \cf9 Button\cf2 (w, \cf9 Rect\cf2 (340, 20, 40, 20))\
.canFocus_(\cf4 false\cf2 )\
.states_([[\cf7 "SL bnd"\cf2 , \cf9 Color\cf2 .white, \cf9 Color\cf2 .grey], [\cf7 "SL bnd"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .grey]])\
.value_(sliderPitch)\
.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 , 10))\
.action_(\{ \cf3 |v|\cf2 \
	if(v.value == 1, \{ sliderPitch= 1 \}, \{ sliderPitch= 0 \});\
	masterprop[\cf10 \\slPitch\cf2 ]= v.value;\
\});\
\
knobPitch= masterprop[\cf10 \\knPitch\cf2 ];\
knPitchBut= \cf9 Button\cf2 (w, \cf9 Rect\cf2 (380, 20, 40, 20))\
.canFocus_(\cf4 false\cf2 )\
.states_([[\cf7 "KN bnd"\cf2 , \cf9 Color\cf2 .white, \cf9 Color\cf2 .grey], [\cf7 "KN bnd"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .grey]])\
.value_(knobPitch)\
.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 , 10))\
.action_(\{ \cf3 |v|\cf2 \
	if(v.value == 1, \{ knobPitch= 1 \}, \{ knobPitch= 0 \});\
	masterprop[\cf10 \\knPitch\cf2 ]= v.value;\
\});\
\
keyPitch= masterprop[\cf10 \\kyPitch\cf2 ];\
kyPitchBut= \cf9 Button\cf2 (w, \cf9 Rect\cf2 (420, 20, 40, 20))\
.canFocus_(\cf4 false\cf2 )\
.states_([[\cf7 "Ky bnd"\cf2 , \cf9 Color\cf2 .white, \cf9 Color\cf2 .grey], [\cf7 "Ky bnd"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .grey]])\
.value_(keyPitch)\
.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 , 10))\
.action_(\{ \cf3 |v|\cf2 \
	if(v.value == 1, \{ keyPitch= 1 \}, \{ keyPitch= 0 \});\
	masterprop[\cf10 \\kyPitch\cf2 ]= v.value;\
\});\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf5 /*\
PopUpMenu(w, Rect(300, 50, 30, 20))\
.items_(["1", "2", "3", "4", "5"])\
.value_(masterprop[\\poly])\
.action_(\{ arg menu;\
a.overlaps= (menu.value+1);\
a.overlaps.postln;\
\});\
\
*/\cf2 \
\cf5 /*\
Button(w, Rect(330, 50, 40, 20))\
.states_([["vel off", Color.black, Color.grey], ["vel on", Color.yellow, Color.grey]])\
.value_(masterprop[\\vel])\
.action_(\{ |v|\
	velocitystate= v.value;\
\});\
*/\cf2 \
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf9 Button\cf2 (w, \cf9 Rect\cf2 (290, 50, 40, 20))\
.canFocus_(\cf4 false\cf2 )\
.states_([[\cf7 "KB"\cf2 , \cf9 Color\cf2 .black, \cf9 Color\cf2 .grey], [\cf7 "KB"\cf2 , \cf9 Color\cf2 .black, \cf9 Color\cf2 .green]])\
.action_(\{ \cf3 |v|\cf2 \
	if(v.value == 1, \{\
		w.view.keyDownAction= \{\cf3 |view, char|\cf2 \
			\cf3 var\cf2  keys= [$a, $w, $s, $e, $d, $f, $t, $g, $y, $h, $u, $j, $k, $l];\
				if (char == $x, \{ if (kbTransp+24 <= numKeys, \{kbTransp= kbTransp + 12\}); \});\
				if (char == $z, \{ if (kbTransp-12 >= 0, \{kbTransp= kbTransp - 12\}); \});\
			keys.do(\{\cf3 |it, i|\cf2 \
				if(char == it, \{\
					i = kbTransp + i;\
					if( i< numKeys  and: \{ keyboardPressDown[i] \}, \{\
						(\cf7 "playnote"\cf2 +i).postln;\
						playnote.value(\cf4 nil\cf2 , sounds[i], i, \cf4 nil\cf2 );\
						keyboardPressDown[i]= \cf4 false\cf2 ;\
					\});\
				\});\
			\});\
			\};\
		w.view.keyUpAction= \{\cf3 |view, char|\cf2 \
			\cf3 var\cf2  keys= [$a, $w, $s, $e, $d, $f, $t, $g, $y, $h, $u, $j, $k, $l];\
			keys.do(\{\cf3 |it, i|\cf2 \
				if(char == it, \{\
					i= kbTransp + i;\
					if (i< numKeys, \{\
						(\cf7 "stopnote"\cf2 +i).postln;\
						stopnote.value(sounds[i], i);\
						keyboardPressDown[i]= \cf4 true\cf2 ;\
					\});\
				\});\
			\});\
		\};			\
	\}, \{\
		w.view.keyDownAction= \{\cf3 |view, char|\cf2 \
				if (char == $r, \{ record.value; \});\
				if (char == $i, \{ recordInstantly.value; \});\
			\};\
		w.view.keyUpAction= \{\};\
	\});\
\});\
\
midiBut= \cf9 Button\cf2 (w, \cf9 Rect\cf2 (340, 50, 40, 20))\
.canFocus_(\cf4 false\cf2 )\
.states_([[\cf7 "MIDI"\cf2 , \cf9 Color\cf2 .black, \cf9 Color\cf2 .grey], [\cf7 "MIDI"\cf2 , \cf9 Color\cf2 .black, \cf9 Color\cf2 .green]])\
.value_(masterprop[\cf10 \\midi\cf2 ])\
.action_(\{ \cf3 |v|\cf2 \
	\cf5 // toggle midi\cf2 \
	masterprop[\cf10 \\midi\cf2 ]= v.value;\
\});\
\
oscBut= \cf9 Button\cf2 (w, \cf9 Rect\cf2 (380, 50, 40, 20))\
.canFocus_(\cf4 false\cf2 )\
.states_([[\cf7 "OSC"\cf2 , \cf9 Color\cf2 .black, \cf9 Color\cf2 .grey], [\cf7 "OSC"\cf2 , \cf9 Color\cf2 .black, \cf9 Color\cf2 .green]])\
.value_(masterprop[\cf10 \\osc\cf2 ])\
.action_(\{ \cf3 |v|\cf2 \
	masterprop[\cf10 \\osc\cf2 ]= v.value;\
	\cf5 //touchOSC.value;\cf2 \
\});\
\
dmxBut= \cf9 Button\cf2 (w, \cf9 Rect\cf2 (420, 50, 40, 20))\
.canFocus_(\cf4 false\cf2 )\
.states_([[\cf7 "DMX"\cf2 , \cf9 Color\cf2 .black, \cf9 Color\cf2 .grey], [\cf7 "DMX"\cf2 , \cf9 Color\cf2 .black, \cf9 Color\cf2 .green]])\
.value_(masterprop[\cf10 \\dmx\cf2 ])\
.action_(\{ \cf3 |v|\cf2 \
	\cf5 // toggle dmx\cf2 \
	masterprop[\cf10 \\dmx\cf2 ]= v.value;\
\});\
\
\
\
\cf9 Button\cf2 (w, \cf9 Rect\cf2 (200, 20, 50, 20))\
.canFocus_(\cf4 false\cf2 )\
.states_([[\cf7 "rec"\cf2 , \cf9 Color\cf2 .black, \cf9 Color\cf2 (1.0, 0.2089552238806, 0.25373134328358, 1.0)]])\
.action_(\{ \cf3 |v|\cf2 \
	record.value;\
\});\
\
\
\
w.view.keyDownAction = \{\cf3 |view, char, mod, uni, key|\cf2 \
	\cf5 //[view, char, mod, uni, key].postln;\cf2 \
	if (uni == $r, \{ record.value; \});\
	if (char == $i, \{ recordInstantly.value; \});\
\};\
\
\
record= \
\{\cf3 |instant= false|\cf2 \
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf3 var\cf2  b, d, rec, stop, drag, recbut, sfpath, clockGUI;\
\cf3 var\cf2  recording= \cf4 false\cf2 ;\
\cf3 var\cf2  window = \cf9 Window\cf2 .new(\cf7 "record"\cf2 ,\cf9 Rect\cf2 (465, 636, 306, 200)).front;\
\
\cf5 //RoundButton( w, 40@40 ).states_([[ \\record, Color.red, Color.grey ],[ \\stop, Color.black, Color.red ]] );\cf2 \
\
recbut= \cf9 Button\cf2 .new(window,\cf9 Rect\cf2 (20, 10, 260, 20))\
	.states_([ [ \cf7 "rec"\cf2 , \cf9 Color\cf2 .black, \cf9 Color\cf2 .red ], [ \cf7 "stop"\cf2 , \cf9 Color\cf2 .white, \cf9 Color\cf2 .blue] ])\
	.action_\{\cf3 |v|\cf2 \
		case \
		\{v.value == 1\} \{rec.value\}\
		\{v.value == 0\} \{stop.value\};\
		\};\
drag= \cf9 DragSource\cf2 .new(window,\cf9 Rect\cf2 (20, 150, 260, 20))\
	.action_\{\cf3 |v|\cf2  \};\
	\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf9 Button\cf2 (window, \cf9 Rect\cf2 (20, 175, 260, 20))\
.states_([[\cf7 "reveal in finder"\cf2 ]])\
.action_(\{ drag.object[0].revealInFinder \});\
\
clockGUI= \cf9 ClockGUI\cf2 .new(window, \cf9 Rect\cf2 (20, 40, 260, 100));\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf5 // allocate a disk i/o buffer\cf2 \
b= \cf9 Buffer\cf2 .alloc(s, 65536, 2);\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf9 SynthDef\cf2 (\cf10 \\recordGiga\cf2 , \{\cf3 arg\cf2  bufnum, in;\
	\cf9 DiskOut\cf2 .ar(bufnum, \cf9 In\cf2 .ar(in,2));\
\}).send(s);\
\
\
\
rec= \{ \cf5 // start recording\cf2 \
	\cf5 // create an output file for this buffer, leave it open\cf2 \
	sfpath= ((recordingsPath++keyboardName ++\cf9 Date\cf2 .localtime.stamp++\cf7 ".wav"\cf2 ).standardizePath);\
	b.write(sfpath, \cf7 "wav"\cf2 , \cf7 "int16"\cf2 , 0, 0, \cf4 true\cf2 );\
	\cf9 Routine\cf2 (\{\
		s.sync;\
		d = \cf9 Synth\cf2 .tail(\cf4 nil\cf2 , \cf10 \\recordGiga\cf2 , [\cf10 \\bufnum\cf2 , b, \cf10 \\in\cf2 , output]);\
	\}).play(\cf9 AppClock\cf2 );	\
	clockGUI.reset;\
	clockGUI.play;\
	recording= \cf4 true\cf2 ;\
\};\
\
stop= \{ \cf5 // stop recording\cf2 \
	\cf9 Routine\cf2 (\{\
	d.free; b.close; b.free;\
	s.sync;\
	drag.object= [sfpath];\
	sfpath.postln;\
	sfpath.class.postln;\
	b= \cf9 Buffer\cf2 .alloc(s, 65536, 2);\
	s.sync;\
	clockGUI.pause;\
\}).play(\cf9 AppClock\cf2 );\
recording= \cf4 false\cf2 ;\
\};\
\
recbut.focus(\cf4 true\cf2 );\
\
window.onClose= \{b.close; b.free; if(recording, \{stop.value\}); \}\
\
\};\
\
\
recordInstantly= \
\{\cf3 |midiCCnum= nil|\cf2 \
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf3 var\cf2  b, d, rec, stop, drag, recbut, sfpath, clockGUI, ccResponder;\
\cf3 var\cf2  window; \
\
window = \cf9 Window\cf2 .new(\cf7 "record"\cf2 ,\cf9 Rect\cf2 (465, 336, 306, 180), border: \cf4 false\cf2 )\
.alwaysOnTop_(\cf4 true\cf2 );\
\
\cf5 //RoundButton( w, 40@40 ).states_([[ \\record, Color.red, Color.grey ],[ \\stop, Color.black, Color.red ]] );\cf2 \
\
recbut= \cf9 Button\cf2 .new(window,\cf9 Rect\cf2 (20, 10, 260, 20))\
	.states_([ [ \cf7 "rec"\cf2 , \cf9 Color\cf2 .black, \cf9 Color\cf2 .red ], [ \cf7 "stop"\cf2 , \cf9 Color\cf2 .white, \cf9 Color\cf2 .blue] ])\
	.action_\{\cf3 |v|\cf2 \
		case \
		\{v.value == 1\} \{rec.value\}\
		\{v.value == 0\} \{stop.value\};\
		\};\
\
clockGUI= \cf9 ClockGUI\cf2 .new(window, \cf9 Rect\cf2 (20, 40, 260, 100));\
\
\cf5 // allocate a disk i/o buffer\cf2 \
b= \cf9 Buffer\cf2 .alloc(s, 65536, 2);\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf9 SynthDef\cf2 (\cf10 \\recordGiga\cf2 , \{\cf3 arg\cf2  bufnum, in;\
	\cf9 DiskOut\cf2 .ar(bufnum, \cf9 In\cf2 .ar(in,2));\
\}).send(s);\
\
\
\
rec= \{ \cf5 // start recording\cf2 \
	\cf5 // create an output file for this buffer, leave it open\cf2 \
	sfpath= ((recordingsPath++keyboardName ++\cf9 Date\cf2 .localtime.stamp++\cf7 ".wav"\cf2 ).standardizePath);\
	b.write(sfpath, \cf7 "wav"\cf2 , \cf7 "int16"\cf2 , 0, 0, \cf4 true\cf2 );\
	\cf9 Routine\cf2 (\{\
		s.sync;\
		d = \cf9 Synth\cf2 .tail(\cf4 nil\cf2 , \cf10 \\recordGiga\cf2 , [\cf10 \\bufnum\cf2 , b, \cf10 \\in\cf2 , output]);\
	\}).play(\cf9 AppClock\cf2 );	\
	clockGUI.reset;\
	clockGUI.play;\
\};\
\
stop= \{ \cf5 // stop recording\cf2 \
	\cf9 Routine\cf2 (\{\
	d.free; b.close; b.free;\
	clockGUI.pause;\
	s.sync;\
	\cf5 //stopnote.value(sounds[numKeys-1], numKeys-1, nil);\cf2 \
	loadPreset.value([sfpath], numKeys-1);\
	a.isPlaying((\cf7 "snd"\cf2 ++((numKeys-1).asString)).asSymbol).postln;\
	s.sync;\
	properties[numKeys-1][0]= 1;\
	properties[numKeys-1][1]= 1;\
	properties[numKeys-1][2]= 2;\
	playnote.value(\cf4 nil\cf2 , sounds[numKeys-1], numKeys-1, \cf4 nil\cf2 );\
	window.close;\
\}).play(\cf9 AppClock\cf2 );\
\};\
\
recbut.focus(\cf4 true\cf2 );\
\
if(midiCCnum.isNil.not, \{\
ccResponder = \cf9 CCResponder\cf2 (\{ \cf3 |src,chan,num,value|\cf2 \
	\cf5 //[src,chan,num,value].postln;\cf2 \
	stop.value;\
	\},\
	midisrcindex, \cf5 //  source\cf2 \
	midichannel, \cf5 //  channel\cf2 \
	midiCCnum, \cf5 // CC number\cf2 \
	\cf4 nil\cf2  \cf5 // any value\cf2 \
);\
\});\
\
rec.value; \cf5 //START RECORDING STRAIGHT AWAY\cf2 \
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
	midiBut.value = masterprop[\cf10 \\midi\cf2 ];\
	oscBut.value = masterprop[\cf10 \\osc\cf2 ];\
	dmxBut.value= masterprop[\cf10 \\dmx\cf2 ];\
	slPitchBut.value= masterprop[\cf10 \\slPitch\cf2 ];\
	knPitchBut.value= masterprop[\cf10 \\knPitch\cf2 ];\
	kyPitchBut.value= masterprop[\cf10 \\kyPitch\cf2 ];\
	prViewBut.value= masterprop[\cf10 \\prView\cf2 ];\
	\};\
\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf5 /*\
GUI.popupMenu.new(w, Rect(20, 80, 100, 30))\
.items_\
\
*/\cf2 \
\
\cf5 // =============================================================================================\cf2 \
\cf5 // ==================================== GUI - KEYBOARD =========================================\cf2 \
\cf5 // =============================================================================================\cf2 \
\
\cf5 //progress view\cf2 \
keyUserViews= numKeys.collect(\{ \cf3 |i|\cf2 \
	\cf3 var\cf2  num, size, amp, env, loop;\
	num= i.wrap(0, 11);\
\
	size= 130*(sizes[num]);\
\
	\cf9 UserView\cf2 (w, \cf9 Rect\cf2 (470, keyHSize*((i-numKeys).abs)-10, size, keyHSize))\
	.canFocus_(\cf4 false\cf2 )\
	.background_(colorsOnUV[num]);\
\});\
\
\cf5 //key prop labels\cf2 \
keyPropLabels= numKeys.collect(\{ \cf3 |i|\cf2 \
	\cf3 var\cf2  view;\
	view= \cf9 UserView\cf2 (w, \cf9 Rect\cf2 (460, keyHSize*((i-numKeys).abs)-10, 10, 20))\
	.background_(\cf9 Color\cf2 .grey.alpha_(0.5))\
	.canFocus_(\cf4 false\cf2 );\
	\
	view.drawFunc = \{\
		\cf5 //routing\cf2 \
		if(properties[i][10].isNil.not, \{\
			\cf5 // set the Color\cf2 \
			\cf9 Pen\cf2 .color = \cf9 Color\cf2 .yellow;\
		\}, \{\
			\cf9 Pen\cf2 .color = \cf9 Color\cf2 .yellow.alpha_(0.0);\
		\});\
		\cf9 Pen\cf2 .addRect(\cf9 Rect\cf2 (6, 0, 3, 20));\
		\cf9 Pen\cf2 .perform(\cf10 \\fill\cf2 );\
		\cf5 //toggle\cf2 \
		if(properties[i][2] == 2, \{\
			\cf5 // set the Color\cf2 \
			\cf9 Pen\cf2 .color = \cf9 Color\cf2 .green;\
		\}, \{\
			\cf9 Pen\cf2 .color = \cf9 Color\cf2 .green.alpha_(0.0);\
		\});\
		\cf9 Pen\cf2 .addRect(\cf9 Rect\cf2 (0, 0, 3, 20));\
		\cf9 Pen\cf2 .perform(\cf10 \\fill\cf2 );\
	\};\
\});\
\
\cf5 //keys\cf2 \
keyButs= numKeys.collect(\{ \cf3 |i|\cf2 \
\cf3 var\cf2  num, size, amp, env, loop;\
num= i.wrap(0, 11);\
\
size= 130*(sizes[num]);\
\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf9 Button\cf2 (w, \cf9 Rect\cf2 (470, keyHSize*((i-numKeys).abs)-10, size, keyHSize))\
.font_(\cf9 GUI\cf2 .font.new(\cf7 "Monaco"\cf2 , 9))\
.canFocus_(\cf4 false\cf2 )\
.states_([[\cf7 ""\cf2 , textcolors[num], colors[num]], [\cf7 ""\cf2 , \cf9 Color\cf2 .black, colorsOn[i.wrap(0, 11)]] ])\
.mouseDownAction_(\{ \cf3 |view, x, y, mod|\cf2 \
\
	if ( mod.isShift, \{\
		\cf9 CocoaDialog\cf2 .getPaths(\{ \cf3 arg\cf2  paths; \cf5 //load sound\cf2 \
		loadPreset.value(paths, i);\
		\},\{\
			\cf7 "cancelled"\cf2 .postln;\
		\});\
	\});\
	if ( mod.isAlt, \{ \cf3 |v|\cf2 \
		\{a.freeKey((\cf7 "snd"\cf2 ++(i).asString).asSymbol);\}.try;\
		soundsASR[i].do(\{\cf3 |it, iii|\cf2 \
			if (it[iii].isNil.not, \{\
			\{a.freeKey((\cf7 "snd"\cf2 ++(i).asString++\cf7 "x"\cf2 ++(iii.asString)).asSymbol);\}.try;\
			\});\
		\});\
		soundsASR[i]= \cf4 nil\cf2 ;\
		sounds[i]= \cf4 nil\cf2 ;\
		properties[i]= defaultProperties[0].deepCopy;\
		\{keyButs[i].states= ([[\cf7 ""\cf2 , textcolors[i.wrap(0, 11)], colors[i.wrap(0, 11)]], [\cf7 ""\cf2 , textcolors[i.wrap(0, 11)], colorsOn[i.wrap(0, 11)]]]);\}.defer;\
\});\
	\
\})\
.beginDragAction_(\{ [sounds[i]] \})\
.canReceiveDragHandler_(\cf4 true\cf2 )\
.receiveDragHandler_(\{\cf3 |view, x, y|\cf2 \
	\cf3 var\cf2  values, paths;\
	[view, x, y].postln;\
	paths= \cf9 View\cf2 .currentDrag;\
	\cf5 //paths.postln;\cf2 \
	if (paths.class == \cf9 UC33LoopChan\cf2 , \{\
		paths.setAction(\{\cf3 |v|\cf2 \
			properties[i][9]= \cf10 \\pan\cf2 .asSpec.map(v.value);\
			if (a.isPlaying((\cf7 "snd"\cf2 ++((i).asString)).asSymbol), \{\
				a.set((\cf7 "snd"\cf2 ++((i).asString)).asSymbol).pan_(\cf10 \\pan\cf2 .asSpec.map(v.value)) \});\
			\}\
			, noteArray[i]);\
		\},\{\
		if(paths.isString, \{paths= [paths];\}); \cf5 // qt compatibility..\cf2 \
		loadPreset.value(paths, i);\
	\});\
\})\
.action_(\{ \cf3 |v|\cf2 \
	c.remove;\
	propView.value(i);\
	if(sendWinOpen.isNil.not, \{ \{sendWinOpen.close; 0.5.wait; sendWindow.value(i);\}.fork(\cf9 AppClock\cf2 ) \});\
	\{v.value= 0\}.defer;\
	w.refresh;\
\});\
\});\
\
loadPreset= \{\cf3 |paths, i|\cf2 \
	\cf3 var\cf2  folderName, fileName, num, midifile;\
	num= i.wrap(0, 11);\
	if (paths[0].isFolder, \cf5 //if file is a folder, load all on one key\cf2 \
			\{\
				folderName= paths[0].basename; \
				paths= (paths[0]++\cf7 "/"\cf2 ++\cf7 "*"\cf2 ); \
				paths= paths.pathMatch;\
				paths= paths.reduceToSoundFiles;\
				\{a.freeKey((\cf7 "snd"\cf2 ++(i).asString).asSymbol);\}.try;\
				soundsASR[i].do(\{\cf3 |it, iii|\cf2 \
					\{a.freeKey((\cf7 "snd"\cf2 ++(i).asString++\cf7 "x"\cf2 ++(iii.asString)).asSymbol);\}.try;\
				\});\
				soundsASR[i]= paths;\
				\cf5 //path.postln;\cf2 \
				sounds[i]= paths[0];\
				a.prepareForPlay((\cf7 "snd"\cf2 ++(i).asString).asSymbol, sounds[(i)]);\
		\
				soundsASR[i].size.do(\{ \cf3 |it, iii|\cf2 \
					if(soundsASR[i][iii].isNil.not, \{\
						a.prepareForPlay((\cf7 "snd"\cf2 ++i.asString++\cf7 "x"\cf2 ++(iii.asString)).asSymbol, soundsASR[i][iii]);\
					\});\
				\});\
				\{ keyButs[i].states= ([[folderName, textcolors[(i).wrap(0, 11);], colors[(i).wrap(0, 11);]], [folderName, \cf9 Color\cf2 .black, colorsOn[(i).wrap(0, 11)]] ]) \}.defer;\
				properties[i]= defaultProperties[0].deepCopy;\
				properties[i][2]= 5; \cf5 //set as sequence\cf2 \
				properties[i][6]= 0;\
		\},\{\
		\cf5 // if path is not folder, normal\cf2 \
	paths.do(\{ \cf3 |path, ii|\cf2 \
		fileName= path.basename.removeExtension;\
		if (path.isSoundFileOrMp3, \{\
		\{a.freeKey((\cf7 "snd"\cf2 ++(i+ii).asString).asSymbol);\}.try;\
		soundsASR[i+ii].do(\{\cf3 |it, iii|\cf2 \
			\{a.freeKey((\cf7 "snd"\cf2 ++(i+ii).asString++\cf7 "x"\cf2 ++(iii.asString)).asSymbol);\}.try;\
		\});\
		soundsASR[i+ii]= [];\
		\cf5 //path.postln;\cf2 \
		sounds[(i+ii)]= path;\
		a.prepareForPlay((\cf7 "snd"\cf2 ++(i+ii).asString).asSymbol, sounds[(i+ii)]);\
		\{ keyButs[i+ii].states= ([[path.basename.removeExtension, textcolors[(i+ii).wrap(0, 11);], colors[(i+ii).wrap(0, 11);]], [path.basename.removeExtension, \cf9 Color\cf2 .black, colorsOn[(i+ii).wrap(0, 11)]] ]) \}.defer;\
		properties[(i+ii)]= defaultProperties[0].deepCopy;\
		\cf5 //folder rules\cf2 \
		rulesOnOff.do(\{\cf3 |it, onoff_iter|\cf2 \
			if(it == 1, \{\
				\cf5 //"onoff!".postln;\cf2 \
				if (path.contains(ruleFolderNames[onoff_iter]), \{\
					\cf5 //"it contains!!".postln;\cf2 \
					rulesApply[onoff_iter].do(\{\cf3 |it, apply_iter|\cf2 \
						if(it == 1, \{\
							\cf5 //"applying properties!!".postln;\cf2 \
							properties[i+ii][apply_iter]= rulesList[onoff_iter][apply_iter];\
							\});\
					\});\
				\});\
			\});\
		\});\
		\cf5 //if (path.contains("musicloops"), \{ properties[i+ii][1]= 1; properties[i+ii][2]= 2; \});\cf2 \
		\cf5 //check for loop in filename\cf2 \
		if (fileName.last == $L, \{properties[i+ii][1]= 1;\}, \{\
			if (fileName.last.isDecDigit && \{fileName[fileName.lastIndex-1] == $L\}, 				\{properties[i+ii][1]= 1;\});\
		\});\
		if (path.hasTag(\cf7 "Loop"\cf2 ), \{ properties[i+ii][1]= 1; \});\
		\
		robotPresetCheck.value(path, i);\
		if(a.mp3[(\cf7 "snd"\cf2 ++(i).asString).asSymbol].isNil.not, \{sounds[i]= a.mp3[(\cf7 "snd"\cf2 ++(i).asString).asSymbol]\});\
		\}, \{\
			if(path.extension == \cf7 "mid"\cf2 , \{ \cf5 // if MIDI File\cf2 \
				\cf7 "loading midi file"\cf2 .postln;\
				midifile= \cf9 SimpleMIDIFile\cf2 .read(path);\
				if(\cf6 ~robotDict\cf2 [(midifile.trackName).asSymbol].notNil, \{\
					properties[i][15][0]= 1;\
					properties[i][15][1].add((midifile.trackName(0).asSymbol).deepCopy -> \cf6 ~robotDict\cf2 [midifile.trackName(0).asSymbol][2].deepCopy);\
					path.copyTo(oscfilesDir, overwrite: \cf4 true\cf2 );\
					properties[i][15][1][midifile.trackName(0).asSymbol][0][0]= oscfilesDir+/+(path.basename);\
					(oscfilesDir+/+(path.basename)).postln;\
					properties[i][15][1][midifile.trackName(0).asSymbol][0][0].postln;\
					properties[i][15][1][midifile.trackName(0).asSymbol]= [[oscfilesDir+/+(path.basename), \cf6 ~robotDict\cf2 [midifile.trackName(0).asSymbol][2][0][1]], 2, 90, 95];\
					\}, \{\cf7 "robotdict was nil"\cf2 .postln;\});\
				\}, \{\
			errorFileMessage.value;\
				\});\
			\});\
	\});\
		\});\
	\};\
\
robotPresetCheck= \{\cf3 |soundfile, key|\cf2 \
	\cf3 var\cf2  saveDirectoryOSC, saveFilesOSC, saveFilesOSCNames, loadArray, index;\
	\
	saveDirectoryOSC= (\cf9 String\cf2 .scDir.dirname ++ \cf7 "/Resources/SENDWINSAVES/OSC/"\cf2 );\
	saveFilesOSC= (saveDirectoryOSC++\cf7 "*"\cf2 ).standardizePath.pathMatch;\
	saveFilesOSCNames= saveFilesOSC.collect(\{\cf3 |it|\cf2  it.basename.asSymbol\});\
	soundfile= soundfile.basename.removeExtension.asSymbol;\
	index= saveFilesOSCNames.indexOfWildcard(soundfile);\
	\
	if(index.isNil.not, \{\
		loadArray= \cf9 Object\cf2 .readArchive(saveFilesOSC[index]);\
		properties[key][15][0]= loadArray[0];\
		properties[key][15][1]= loadArray[1];\
		\});\
	\
	\
	\};\
\
midiPresetCheck= \{\cf3 |soundfile, key|\cf2 \
	\cf3 var\cf2  saveDirectoryMIDI, saveFilesMIDI, saveFilesMIDINames, loadArray, index;\
	\
	saveDirectoryMIDI= (\cf9 String\cf2 .scDir.dirname ++ \cf7 "/Resources/SENDWINSAVES/MIDI/"\cf2 );\
	saveFilesMIDI= (saveDirectoryMIDI++\cf7 "*"\cf2 ).standardizePath.pathMatch;\
	saveFilesMIDINames= saveFilesMIDI.collect(\{\cf3 |it|\cf2  it.basename.asSymbol\});\
	soundfile= soundfile.basename.removeExtension.asSymbol;\
	index= saveFilesMIDINames.indexOfWildcard(soundfile);\
	\
	if(index.isNil.not, \{\
		loadArray= \cf9 Object\cf2 .readArchive(saveFilesMIDI[index]);\
		properties[key][11]= loadArray;\
		\});\
	\
	\
	\};\
\
errorFileMessage= \{\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf3 var\cf2  w, r;\
\
	w= \cf9 SCAlert\cf2 ( \cf7 "the file you loaded is not valid. It's either just plain wrong or mp3.."\cf2 ,[\cf7 "close.. 5"\cf2 ],[\{w.window.close; r.stop; \}] );\
	\
	\cf5 /*\
	w= Window("error", Rect(400, 400, 300, 100))\
	.background_(\
	.alwaysOnTop_("true");\
\
	StaticText(w, Rect(10, 10, 280, 20))\
	.string_("the file you loaded is not valid");\
	StaticText(w, Rect(10, 30, 280, 20))\
	.string_("either just plain wrong or mp3..");\
	w.front;\
	*/\cf2 \
	r= \{1.wait; \
	5.do(\{\cf3 |i|\cf2  \{w.buttonLabel_(0, \cf7 "close.."\cf2 +(5-i));\}.defer; 1.wait;\});\
	w.window.close;\}.fork(\cf9 AppClock\cf2 );\
\};\
\
\
\
\cf5 // =============================================================================================\cf2 \
\cf5 // ============================= GUI - SLIDERS & KNOBS =========================================\cf2 \
\cf5 // =============================================================================================\cf2 \
\
\cf5 // ============= SLIDERS ==========\cf2 \
\
sliderView= \cf9 HLayoutView\cf2 (w, \cf9 Rect\cf2 (20, 540, 415, 190));\
\cf5 //sliderView.setProperty(\\spacing,0);\cf2 \
\
\
sliders= slidersCC.size.collect(\{ \cf3 |i|\cf2 \
	i= i+1;\
	\cf9 SliderLooper\cf2 .new(sliderView, 0, 0, i, out: output, preferences: preferences);\
\});\
s.sync;\
sliders.do(\{\cf3 |it|\cf2  it.allSliders= sliders \});\
s.sync;\
responders1= slidersCC.collect(\{\cf3 |it, i|\cf2 \
\
		\cf9 CCResponder\cf2 (\{\
			\cf3 |src,chan,num,value|\cf2 \
			sliders[i].setVal((value*(127.reciprocal)).round(0.001));\
		\}, num: it, src: midisrcindex, chan: midichannel\
		);\
\
\});\
\
\cf5 // ============= KNOBS ==========\cf2 \
knobView1= \cf9 CompositeView\cf2 (w, \cf9 Rect\cf2 (15, 300, 380, 240));\
knobView1.decorator = \cf9 FlowLayout\cf2 (knobView1.bounds);\
\
\
allKnobs= knobsCC.size.collect(\{\cf3 |i|\cf2 \
	\cf9 UC33LoopChan\cf2 .new(knobView1, 0, 0, output, \cf4 nil\cf2 , preferences, properties, a, i+1);\
\});\
\
allKnobs.do(\{\cf3 |it|\cf2  it.allSliders= allKnobs \});\
\
responders2= knobsCC.collect(\{\cf3 |it, i|\cf2 \
\
		\cf9 CCResponder\cf2 (\{\
			\cf3 |src,chan,num,value|\cf2 \
			allKnobs[i].setVal((value*(127.reciprocal)).round(0.001));\
		\}, num: (it), src: midisrcindex, chan: midichannel\
		);\
	\
\});\
\
\
\
\cf5 // =============================================================================================\cf2 \
\cf5 // ================================= GUI - EFFECT VIEW =========================================\cf2 \
\cf5 // =============================================================================================\cf2 \
\
effView= \{\cf3 |storedValues|\cf2 \
\
\cf3 var\cf2  cblobs;\
\
\cf3 var\cf2  fx_synths, fx_synth_names, fx_synth_namesShort, metadata, fxMenu, fxMenuItems, paramGUIs= [];\
\cf3 var\cf2  gateControls, gates= [];\
\cf3 var\cf2  allSynths= [];\
\cf5 //var fxDir= "/Users/martin/scwork/samplerProject/fx-lib";\cf2 \
\cf3 var\cf2  fxDir= (\cf9 String\cf2 .scDir.dirname ++ \cf7 "/Resources/FXSynthDefs"\cf2 );\
\cf3 var\cf2  fxMenuSelection= 0;\
\
\
\{\
\cf5 ////////// ** FX SYNTHS LOAD ** /////////////\cf2 \
	(fxDir ++ \cf7 "/*"\cf2 ).loadPaths;\
			s.sync;\
	\cf5 //collect list of synths with fx_ in the name\cf2 \
	fx_synths=\cf9 SynthDescLib\cf2 .global.synthDescs.select\{\cf3 |def|\cf2 \
     def.name.contains(\cf7 "fx_"\cf2 );\
	\};\
\
  	fx_synth_names= fx_synths.collect(\{\cf3 |it|\cf2  it.name \});	\
 	fx_synth_namesShort= fx_synths.collect(\{\cf3 |it|\cf2  it.name.drop(3)\});\
 	\
 	allSynths= \cf4 nil\cf2 !(fx_synths.size);\
 	\
 	t= \cf9 TabbedView\cf2 (w, \cf9 Rect\cf2 (250, 75, 200, 95), fx_synth_namesShort, [\cf9 Color\cf2 .new255(158, 158, 158), \cf9 Color\cf2 .new255(148, 148, 148), \cf9 Color\cf2 .new255(138, 138, 138)])\
.followEdges_(\cf4 false\cf2 )\
.font_(\cf9 Font\cf2 (\cf7 "Monaco"\cf2 ,9)).tabHeight_(1).tabWidth_(15);\
 	\
 	fx_synth_names.do(\{\cf3 |it, i|\cf2 \
	 	\cf3 var\cf2  metadatainfo, but, guis, synth, usefulControls, scroll, view, gatebutton;\
	 	\cf3 var\cf2  currentValuesDict= \cf9 Dictionary\cf2 .new;\
	 	it= fx_synths[it.asSymbol];\
	 	currentValuesDict.put(\cf10 \\out\cf2 , output);\
	 	\cf5 //make button\cf2 \
	 	scroll= \cf9 ScrollView\cf2 (t.views[i], \cf9 Rect\cf2 (0, 0, 200, 80))\
	 	.hasHorizontalScroller_(\cf4 false\cf2 );\
	 	\cf5 //.hasBorder_(true);\cf2 \
	 	view= \cf9 CompositeView\cf2 (scroll, \cf9 Rect\cf2 (0, 0, 190, 150));\
	 	but= \cf9 Button\cf2 (view, \cf9 Rect\cf2 (0, 5, 15, 15))\
		.states_([[\cf7 "x"\cf2 ], [\cf7 "x"\cf2 , \cf9 Color\cf2 .black, \cf9 Color\cf2 .green]])\
		.value_(0)\
		.canFocus_(\cf4 false\cf2 )\
		.action_(\{\cf3 |v|\cf2  \
			if (v.value == 1,\
			\{ allSynths[i]= \cf9 Synth\cf2 .tail(effectGroup, it.name.asSymbol, currentValuesDict.asKeyValuePairs);\
					allSynths[i].isRunning= \cf4 true\cf2 ;\
					fxMenuItems[i]= fxMenuItems[i]+\cf7 "*"\cf2 ;\
					fxMenu.items= fxMenuItems;\
					\{fxMenu.value= fxMenuSelection\}.defer;\
				\},\{ \
					allSynths[i].free;\
					fxMenuItems[i]= fxMenuItems[i].drop(-2);\
					fxMenu.items= fxMenuItems;\
					\{fxMenu.value= fxMenuSelection\}.defer;\
				\});\
		\});\
		\
		usefulControls= it.controls.reject(\{\cf3 |itt|\cf2 \
			\cf3 var\cf2  name= itt.name.asSymbol;\
			\cf3 var\cf2  avoidList= [\cf10 \\out\cf2 , \cf10 \\in\cf2 , \cf10 \\gate\cf2 , \cf10 \\recrun\cf2 ];\
			avoidList.indexOf(name).isNil.not\
		\});\
		\
		gateControls= it.controls.detect(\{\cf3 |itt|\cf2 \
			\cf3 var\cf2  name= itt.name.asSymbol;\
			name == \cf10 \\gate\cf2 \
		\});\
		\
		\cf5 //if(gateControls.class != Array, \{gateControls= [gateControls]; \});\cf2 \
		\
		\cf5 //usefulControls.postln;\cf2 \
		\cf5 //usefulControls.class.postln;\cf2 \
\
	 	guis= usefulControls.collect(\{\cf3 |itt, ii|\cf2 \
		 		\cf3 var\cf2  name= itt.name.asSymbol;\
		 		\cf3 var\cf2  spec;\
		 		currentValuesDict.put(name, itt.defaultValue);\
		 		spec= it.metadata[\cf10 \\specs\cf2 ][name];\
				\cf9 EZSlider\cf2 (view,  	\cf5 // parent\cf2 \
				\cf9 Rect\cf2 (10, 5+(15*ii), 180, 15),\
				name,	\cf5 // label\cf2 \
				spec, \cf5 // controlSpec\cf2 \
				\{\cf3 |ez|\cf2  if (but.value == 1, \{allSynths[i].set(name, ez.value)\});\
					currentValuesDict.put(name, ez.value);\
					\cf5 //("setting"+name+":"+currentValuesDict[name].asString).postln;\cf2 \
				\}, \cf5 // action\cf2 \
				itt.defaultValue, \cf5 // init value, set from A DICTIONARY\cf2 \
				labelWidth: 40\
				).setColors(\
					\cf4 nil\cf2 , \cf5 //string backgr\cf2 \
					\cf9 Color\cf2 .white, \cf5 //string\cf2 \
					\cf9 Color\cf2 (0.298, 0.298, 0.298, 1.0), \cf5 //slider backgr\cf2 \
					\cf9 Color\cf2 .grey, \cf5 //num backgr\cf2 \
					\cf9 Color\cf2 .white, \cf5 //num clr\cf2 \
					\cf4 nil\cf2 ,\
					\cf4 nil\cf2 ,\
					\cf9 Color\cf2 (0.298, 0.776, 1.0, 1.0) \cf5 //knob clr\cf2 \
					);\
		\});\
		\
		if(gateControls.isNil.not, \{\
		 	gatebutton= \cf9 Button\cf2 (view, \cf9 Rect\cf2 (10, 5+(15*guis.size), 160, 15))\
		 	.states_([[\cf7 "gate"\cf2 ],[\cf7 "gate"\cf2 , \cf9 Color\cf2 .black, \cf9 Color\cf2 .yellow]])\
		 	.action_(\{\cf3 |v|\cf2  allSynths[i].set(\cf10 \\gate\cf2 , v.value) \})\
		 	.value_(gateControls.defaultValue); 	\
			gates= gates.add(gatebutton);\
		\});\
\
 		paramGUIs= paramGUIs++but++guis;\
 		\
 		view.bounds_(\cf9 Rect\cf2 (0, 0, 190, 40+(guis.size*15)));\
 	\
 		\cf5 //fxDict.put(it.name.asSymbol, currentValuesDict);\cf2 \
	 \});\
	\cf5 //paramGUIs.postln;\cf2 \
	\cf5 //fx_synth_names.postln;\cf2 \
	\cf5 //fx_synth_names.asArray.postln;\cf2 \
	\
	fxMenuItems= fx_synth_namesShort.asArray;\
	\
	fxMenu= \cf9 PopUpMenu\cf2 (w, \cf9 Rect\cf2 (250, 75, 100, 15))\
	.items_(fxMenuItems)\
	.background_(\cf9 Color\cf2 .white)\
	.canFocus_(\cf4 false\cf2 )\
	.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 , 10))\
	.action_(\{\cf3 |v|\cf2  t.focus(v.value); fxMenuSelection= v.value \});\
	\cf9 Button\cf2 (w, \cf9 Rect\cf2 (350, 75, 30, 15))\
	.canFocus_(\cf4 false\cf2 )\
	.states_([[\cf7 "<<"\cf2 , \cf9 Color\cf2 (0.298, 0.776, 1.0, 1.0), \cf9 Color\cf2 (0.298, 0.298, 0.298, 1.0)]])\
	.action_(\{\cf3 |v|\cf2  \{fxMenu.valueAction= (fxMenu.value-1).wrap(0, (fxMenu.items.size-1)) \}.defer; \});\
	\cf9 Button\cf2 (w, \cf9 Rect\cf2 (380, 75, 30, 15))\
	.canFocus_(\cf4 false\cf2 )\
	.states_([[\cf7 ">>"\cf2 , \cf9 Color\cf2 (0.298, 0.776, 1.0, 1.0), \cf9 Color\cf2 (0.298, 0.298, 0.298, 1.0)]])\
	.action_(\{\cf3 |v|\cf2  \{fxMenu.valueAction= (fxMenu.value+1).wrap(0, (fxMenu.items.size-1)) \}.defer; \});	\
	\cf9 Button\cf2 (w, \cf9 Rect\cf2 (410, 75, 35, 15))\
	.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 , 10))\
	.canFocus_(\cf4 false\cf2 )\
	.states_([[\cf7 "allOff"\cf2 , \cf9 Color\cf2 .red, \cf9 Color\cf2 (0.298, 0.298, 0.298, 1.0)]])\
	.action_(\{\cf3 |v|\cf2 \
		allSynths.do(\{\cf3 |it|\cf2 \
			if(it.isNil.not,\{\
				if(it.isRunning, \{it.free;\});\
			\});\
		\});\
		paramGUIs.do(\{\cf3 |it|\cf2 \
			if(it.class == \cf9 SCButton\cf2 , \{ \{it.valueAction= 0\}.defer; \});\
		\});\
		\});	\
	\
	\
\
\
\cf5 /*\
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
*/\cf2 \
\
t.view.addAction(\{\
	allSynths.do(\{\cf3 |it|\cf2 \
		if(it.isNil.not,\{\
			if(it.isRunning, \{it.free;\});\
		\});\
	\});\
\}, \cf10 \\onClose\cf2 );\
\
\cf5 /*\
r\{\
	1.wait;\
	if (masterprop[\\revon] == 1, \{ \{revOn.valueAction= 1\}.defer; \});\
	if (masterprop[\\eon] == 1, \{ \{echoOn.valueAction= 1\}.defer; \});\
\}.play(AppClock);\
*/\cf2 \
\
\
\cf5 //paramGUIs.postln;\cf2 \
\cf5 //gates.postln;\cf2 \
\
cblobs= \cf9 Colorblobs2\cf2 .new(w, \cf9 Rect\cf2 (250, 170, 200, 105), paramGUIs, kaossFilesDir, gates)\
\
\cf5 /*	, pressAction: \{ \{ sliders.do(\{|it| it.pause \}) \}.defer; \}, \
	releaseAction: \{  \{ sliders.do(\{|it| it.unpause \}) \}.defer; \} \
	);\
*/\cf2 \
	 \}.fork(\cf9 AppClock\cf2 );\
\};\
\
effView.value;\
\
\
\cf5 // =============================================================================================\cf2 \
\cf5 // ============================= GUI - PROP VIEW ===============================================\cf2 \
\cf5 // =============================================================================================\cf2 \
\
propView= \{ \cf3 | key |\cf2 \
\cf3 var\cf2  t, panarr= [0, -1, 1], directionBut, rateKnob;\
\
c= \cf9 CompositeView\cf2 (w, \cf9 Rect\cf2 (20, 100, 220, 190))\
.background_(\cf9 Color\cf2 .new255(229, 229, 229));\
\cf5 //.relativeOrigin_(true);\cf2 \
\
if (sounds[key].isNil.not, \{\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf9 StaticText\cf2 (c, \cf9 Rect\cf2 (90, 0, 200, 15))\
.string_(sounds[key].basename.removeExtension);\
\},\{\
\cf9 StaticText\cf2 (c, \cf9 Rect\cf2 (90, 0, 200, 15))\
.string_(\cf7 "no soundfile on key"\cf2 );\
\});\
\
\cf9 Knob\cf2 (c, \cf9 Rect\cf2 (10, 10, 15, 15))\
.centered_(\cf4 true\cf2 )\
.canFocus_(\cf4 false\cf2 )\
.value_(\cf10 \\pan\cf2 .asSpec.unmap(properties[key][9]))\
.action_(\{ \cf3 |v|\cf2 \
	properties[key][9]= \cf10 \\pan\cf2 .asSpec.map(v.value);\
	if (a.isPlaying((\cf7 "snd"\cf2 ++((key).asString)).asSymbol), \{\
				a.set((\cf7 "snd"\cf2 ++((key).asString)).asSymbol).pan_(\cf10 \\pan\cf2 .asSpec.map(v.value)) \});\
	\cf5 //\\pan.asSpec.map(v.value).postln;\cf2 \
\})\
.color_([\cf9 Color\cf2 .gray, \cf9 Color\cf2 .red, \cf9 Color\cf2 .white, \cf9 Color\cf2 .black])\
.mouseDownAction_(\{\cf3 |view, x, y, mod|\cf2 \
	if (mod == alt, \{view.valueAction= \cf10 \\pan\cf2 .asSpec.unmap(0); properties[key][9]= 0\})\
\});\
\
\
\cf9 Button\cf2 (c, \cf9 Rect\cf2 (30, 10, 30, 15))\
.states_([[\cf7 "nil"\cf2 , \cf9 Color\cf2 .black, \cf9 Color\cf2 .grey], [\cf7 "1-2"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .black],[\cf7 "3-4"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .black], [\cf7 "5-6"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .black], [\cf7 "7-8"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .black], [\cf7 "9-10"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .black], [\cf7 "11-12"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .black], [\cf7 "13-14"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .black], [\cf7 "15-16"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .black], [\cf7 "17-18"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .black], [\cf7 "19-20"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .black], [\cf7 "21-22"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .black], [\cf7 "23-24"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .black], [\cf7 "25-26"\cf2 , \cf9 Color\cf2 .yellow, \cf9 Color\cf2 .black] ] )\
.canFocus_(\cf4 false\cf2 )\
.value_(if (properties[key][10]==\cf4 nil\cf2 , \{ 0 \}, \{ outputs.indexOf(properties[key][10]) \}) )\
.action_(\{ \cf3 |v|\cf2 \
	properties[key][10]= outputs[v.value];\
\});\
\
\
\cf9 Slider\cf2 (c, \cf9 Rect\cf2 (10, 30, 50, 120))\
.background_(\cf9 Color\cf2 .grey)\
.canFocus_(\cf4 false\cf2 )\
.value_(properties[key][0])\
.action_(\{ \cf3 |v|\cf2 \
	properties[key][0]= v.value;\
	if (a.isPlaying((\cf7 "snd"\cf2 ++((key).asString)).asSymbol), \{\
		a.set((\cf7 "snd"\cf2 ++((key).asString)).asSymbol).amp_(v.value) \});\
	\
\});\
\cf9 Button\cf2 (c, \cf9 Rect\cf2 (70, 20, 60, 20))\
.states_([[\cf7 "loop off"\cf2 , \cf9 Color\cf2 .black, \cf9 Color\cf2 .grey], [\cf7 "loop on"\cf2 , \cf9 Color\cf2 .white, \cf9 Color\cf2 .black]])\
.canFocus_(\cf4 false\cf2 )\
.value_(properties[key][1])\
.action_(\{ \cf3 |v|\cf2 \
	properties[key][1]= v.value;\
\});\
\
\cf9 Button\cf2 (c, \cf9 Rect\cf2 (130, 20, 30, 20))\
.states_([[\cf7 "|--|"\cf2 , \cf9 Color\cf2 .white, \cf9 Color\cf2 .grey]])\
.canFocus_(\cf4 false\cf2 )\
.action_(\{ \cf3 |v|\cf2 \
	if(sounds[key].isNil, \{\cf7 "no sound loaded"\cf2 .postln\},\
	\{looppointeditor.value(key)\}\
	);\
\});\
\
\cf9 Button\cf2 (c, \cf9 Rect\cf2 (160, 20, 20, 20))\
.states_([[\cf7 "rm"\cf2 , \cf9 Color\cf2 .black, \cf9 Color\cf2 .grey]])\
.canFocus_(\cf4 false\cf2 )\
.action_(\{ \cf3 |v|\cf2 \
	\{a.freeKey((\cf7 "snd"\cf2 ++(key).asString).asSymbol);\}.try;\
	soundsASR[key].do(\{\cf3 |it, iii|\cf2 \
		if (it[iii].isNil.not, \{\
		\{a.freeKey((\cf7 "snd"\cf2 ++(key).asString++\cf7 "x"\cf2 ++(iii.asString)).asSymbol);\}.try;\
		\cf5 //it[iii]= nil;\cf2 \
		\});\
	\});\
	soundsASR[key]= \cf4 nil\cf2 ;\
	sounds[key]= \cf4 nil\cf2 ;\
	properties[key]= defaultProperties[0].deepCopy;\
	\{keyButs[key].states= ([[\cf7 ""\cf2 , textcolors[key.wrap(0, 11)], colors[key.wrap(0, 11)]], [\cf7 ""\cf2 , textcolors[key.wrap(0, 11)], colorsOn[key.wrap(0, 11)]]]);\}.defer;\
\});\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf5 //("prop 14:"+properties[key][14]).postln;\cf2 \
\
rateKnob= \cf9 Knob\cf2 (c, \cf9 Rect\cf2 (185, 20, 20, 20)) \cf5 //speed / rate\cf2 \
.centered_(\cf4 true\cf2 )\
.canFocus_(\cf4 false\cf2 )\
.value_(\cf10 \\pan\cf2 .asSpec.unmap(properties[key][14]))\
.action_(\{ \cf3 |v|\cf2 \
	\cf5 //\\pan.asSpec.map(v.value).postln;\cf2 \
	properties[key][14]= \cf10 \\pan\cf2 .asSpec.map(v.value);\
	if(\cf10 \\pan\cf2 .asSpec.map(v.value).isPositive, \
		\{directionBut.value= 0; properties[key][13][0]= 0\}, \
		\{directionBut.value= 1; properties[key][13][0]= 1\});\
	if (a.isPlaying((\cf7 "snd"\cf2 ++((key).asString)).asSymbol), \{\
		a.set((\cf7 "snd"\cf2 ++((key).asString)).asSymbol).speed_(\cf10 \\pan\cf2 .asSpec.map(v.value)) \});\
\
\})\
.color_([\cf9 Color\cf2 .grey, \cf9 Color\cf2 .red, \cf9 Color\cf2 .white, \cf9 Color\cf2 .black])\
.mouseDownAction_(\{\cf3 |view, x, y, mod|\cf2 \
	if (mod == alt, \{view.valueAction= \cf10 \\pan\cf2 .asSpec.unmap(1); properties[key][14]= 1\})\
\})\
.canReceiveDragHandler_(\cf4 true\cf2 )\
.receiveDragHandler_(\{\cf3 |view|\cf2 \
	\cf3 var\cf2  drag;\
	drag= \cf9 View\cf2 .currentDrag;\
	if (drag.class == \cf9 UC33LoopChan\cf2 , \{\
		drag.setAction(\{\cf3 |v|\cf2 \{ rateKnob.valueAction_(v.value)\}.defer \}, \cf7 "rate"\cf2 +noteArray[key]);\
	\});\
\});\
\
\
\
directionBut= \cf9 Button\cf2 (c, \cf9 Rect\cf2 (180, 45, 30, 20))\
.states_([[\cf7 ">>"\cf2 , \cf9 Color\cf2 .green, \cf9 Color\cf2 .white], [\cf7 "<<"\cf2 , \cf9 Color\cf2 .red, \cf9 Color\cf2 .white]])\
.canFocus_(\cf4 false\cf2 )\
.action_(\{ \cf3 |v|\cf2 \
	if(v.value == 1, \{\
		rateKnob.valueAction= \cf10 \\pan\cf2 .asSpec.unmap(\cf10 \\pan\cf2 .asSpec.map(rateKnob.value).neg)\
		\},\{\
		rateKnob.valueAction= \cf10 \\pan\cf2 .asSpec.unmap(\cf10 \\pan\cf2 .asSpec.map(rateKnob.value).abs)\
		\});\
\});\
if(properties[key][14].isNegative, \{directionBut.value= 1\});\
\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf9 Button\cf2 (c, \cf9 Rect\cf2 (130, 45, 30, 20))\
.states_([[\cf7 "killa"\cf2 , \cf9 Color\cf2 .black, \cf9 Color\cf2 .grey], [\cf7 "killa"\cf2 , \cf9 Color\cf2 .red, \cf9 Color\cf2 .black]])\
.canFocus_(\cf4 false\cf2 )\
.value_(properties[key][5])\
.action_(\{ \cf3 |v|\cf2 \
	properties[key][5]= v.value;\
\});\
\
\cf9 Button\cf2 (c, \cf9 Rect\cf2 (160, 45, 20, 20))\
.states_([[\cf7 "sh"\cf2 , \cf9 Color\cf2 .black, \cf9 Color\cf2 .grey], [\cf7 "sh"\cf2 , \cf9 Color\cf2 .red, \cf9 Color\cf2 .black]])\
.canFocus_(\cf4 false\cf2 )\
.value_(properties[key][8])\
.action_(\{ \cf3 |v|\cf2 \
	properties[key][8]= v.value;\
	if (v.value == 1, \{properties[key][1]= 0\});\
\});\
\
\
\cf9 Button\cf2 (c, \cf9 Rect\cf2 (70, 45, 60, 20))\
.states_([[\cf7 "|>"\cf2 , \cf9 Color\cf2 .black, \cf9 Color\cf2 .grey], [\cf7 "|>"\cf2 , \cf9 Color\cf2 .white, \cf9 Color\cf2 .black]])\
.canFocus_(\cf4 false\cf2 )\
.value_(if (a.isPlaying((\cf7 "snd"\cf2 ++((key).asString)).asSymbol), \{1\}, \{0\}) )\
.action_(\{ \cf3 |v|\cf2 \
	\cf3 var\cf2  b= keyButs[key], time;\
	if (v.value == 1, \{\
		playnote.value(\cf4 nil\cf2 , sounds[key], key, \cf4 nil\cf2 );\
	\},\{\
		stopnote.value(sounds[key], key);\
	\});\
	if( \cf6 ~logfile\cf2 .isNil.not, \{ \{\cf6 ~logfile\cf2 .write(\cf9 Date\cf2 .getDate.hourStamp.asString+(sounds[key].basename)++\cf7 "\\n"\cf2 )\}.defer; \});\
\});\
\
\cf9 EZNumber\cf2 ( c,  	\cf5 // parent\cf2 \
	\cf9 Rect\cf2 (50, 70, 80, 20),	\cf5 // bounds\cf2 \
	\cf7 "atk"\cf2 ,	\cf5 // label\cf2 \
	[0,6,\cf10 \\lin\cf2 ,0.01, properties[key][3]].asSpec, 	\cf5 // controlSpec\cf2 \
	\{\cf3 |ez|\cf2  \
	properties[key][3]= ez.value;\
	\}, \cf5 // action\cf2 \
	labelWidth: 30,\
	numberWidth: 40,\
	unitWidth: 1\
);\
\
\cf9 EZNumber\cf2 ( c,  	\cf5 // parent\cf2 \
	\cf9 Rect\cf2 (110, 70, 80, 20),	\cf5 // bounds\cf2 \
	\cf7 "rel"\cf2 ,	\cf5 // label\cf2 \
	[0,6,\cf10 \\lin\cf2 ,0.01, properties[key][4]].asSpec, 	\cf5 // controlSpec\cf2 \
	\{\cf3 |ez|\cf2  \
	properties[key][4]= ez.value;\
	\}, \cf5 // action\cf2 \
	labelWidth: 30,\
	numberWidth: 40,\
	unitWidth: 1\
);\
\
\cf9 Button\cf2 (c, \cf9 Rect\cf2 (190, 70, 20, 20))\
.canFocus_(\cf4 false\cf2 )\
.states_([[\cf7 "S"\cf2 , \cf9 Color\cf2 .white, \cf9 Color\cf2 .green]])\
.action_(\{\cf3 |v|\cf2  sendWindow.value(key) \});\
\
\cf9 PopUpMenu\cf2 (c, \cf9 Rect\cf2 (5, 155, 70, 20))\
.items_([\cf7 "piano"\cf2 , \cf7 "shot"\cf2 , \cf7 "toggle"\cf2 , \cf7 "3 samples"\cf2 , \cf7 "2 samples"\cf2 , \cf7 "many"\cf2 , \cf7 "arpeggio"\cf2 ])\
.value_(properties[key][2])\
.canFocus_(\cf4 false\cf2 )\
.action_(\{ \cf3 arg\cf2  menu;\
	properties[key][2] = menu.value;\
\
	if(arpRoutines[key].isPlaying, \{arpRoutines[key].stop\});\
	if (a.isPlaying((\cf7 "snd"\cf2 ++((key).asString)).asSymbol) and: \{menu.value != 2\}, \{\
		a.stop((\cf7 "snd"\cf2 ++((key).asString)).asSymbol, properties[key][4]);\
		\{ keyButs[key].value= 0 \}.defer;\
		if (progressState == 1, \{\
			progress[key].stop; \
			progressViewClear.value(key);\
		\});\
	\});\
\
	if( menu.value == 3, \{\
		extrasampleView.value(key, soundsASR[key]);\
		extrasample= \cf4 true\cf2 ;\
	\});\
	if( menu.value == 4, \{\
		extrasampleView.value(key, soundsASR[key]);\
		extrasample= \cf4 true\cf2 ;\
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
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf5 // =============================================================================================\cf2 \
\cf5 // ====================================== SEND WINDOW ==========================================\cf2 \
\cf5 // =============================================================================================\cf2 \
\
sendWindow= \{\cf3 |key = 0|\cf2 \
\cf5 //var properties= ([0.5, 0, 0, 0.01, 0.2, 0, 0, 3, 0, 0, nil, nil, [0.1, 0.2, 0], [0, 0, 1], 1, nil, nil]!36).asList, midiOut;\cf2 \
\cf3 var\cf2  testCue, testCue2;\
\
\cf3 var\cf2  w, t, tabNames;\
\cf3 var\cf2  midiNoteOnSlider, midiNoteOnValSlider, midiNoteOffSlider, midiNoteOffValSlider, testMIDI= \cf4 false\cf2 ;\
\cf3 var\cf2  midiView, makeNewMidiView, midiSendBut;\
\cf3 var\cf2  oscTab, oscOnOffBut, loadOscTab, oscTypeMenu;\
\cf3 var\cf2  oscfiles, oscsavefiles,oscloadmenu, oscmenuitem;\
\cf3 var\cf2  curOscRecName, curOscRec;\
\cf3 var\cf2  robotMenu, makeNewOscTab;\
\cf3 var\cf2  recOSC;\
\cf3 var\cf2  durationView, waitStringView, setWaitString, envView;\
\cf3 var\cf2  dmxOnOffBut, dmxNoteOnChannel, dmxNoteOnSliders, dmxNoteOnView;\
\cf3 var\cf2  dmxNoteOnViewAdd, dmxNoteOnViewSelect;\
\cf3 var\cf2  dmxNoteOnScroll, dmxNoteOnLayout, updateDmxNoteOnView;\
\cf3 var\cf2  dmxNoteOffChannel, dmxNoteOffSliders, dmxNoteOffView;\
\cf3 var\cf2  dmxNoteOffViewAdd, dmxNoteOffViewSelect;\
\cf3 var\cf2  dmxNoteOffScroll, dmxNoteOffLayout, updateDmxNoteOffView;\
\cf3 var\cf2  testDMX= \cf4 false\cf2 , addBlack= \cf4 true\cf2 ;\
\
\cf3 var\cf2  saveFilesMIDI, loadMenuMIDI, loadMenuItemMIDI, saveDirectoryMIDI;\
\cf3 var\cf2  saveFilesOSC, loadMenuOSC, loadMenuItemOSC, saveDirectoryOSC;\
\cf3 var\cf2  saveFilesDMX, loadMenuDMX, loadMenuItemDMX, saveDirectoryDMX;\
\cf3 var\cf2  verbose= \cf4 true\cf2 ;\
\cf3 var\cf2  oscPlotter;\
\
\
if(sendWinOpen.isNil.not, \{sendWinOpen.close; \});\
if(sendWinLastTabFocus.isNil, \{sendWinLastTabFocus= 1\});\
\
\cf5 //midi default\cf2 \
if (properties[key][11].isNil, \{\
	properties[key][11]= [0, [0, 0], [0, 0]];\
	\});\
\
\
\cf5 //osc default\cf2 \
if (properties[key][15].isNil, \{properties[key][15]= [0, \cf9 Dictionary\cf2 .new]\});\
\cf5 //osc test\cf2 \
\cf5 //properties[key][15]= [1, (\\robot1: [127, 0, 7.456])]; // noteon/off\cf2 \
\cf5 //properties[key][15]= [1, (\\robot1: [[[0.0, 0.5], [0.1, 0.8]], 0, 7.456])]; //sequence\cf2 \
\
\
\cf5 //dmx default\cf2 \
if (properties[key][16].isNil, \{properties[key][16]= [0, [\cf9 DMXSubCue\cf2 .new, \cf9 DMXSubCue\cf2 .new]];\});\
\cf5 //dmx test\cf2 \
\
\cf5 //testCue= DMXSubCue.new;\cf2 \
\cf5 //testCue2= DMXSubCue.new;\cf2 \
\cf5 //[0, 1, 2, 10, 56, 34, 26, 73].do(\{|it, i| testCue.put(it, i*0.1) \});\cf2 \
\cf5 //[0, 1, 2, 10, 56, 34, 26, 73].do(\{|it, i| testCue2.put(it, 0) \});\cf2 \
\cf5 //properties[key][16]= [0, [testCue, testCue2]];\cf2 \
\
\cf5 /*\
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
*/\cf2 \
\
\
if (sendWinLastPos.isNil, \{\
	w= \cf9 Window\cf2 (\cf7 "send:"\cf2 +key+(noteArray[key]), \cf9 Rect\cf2 (0, 0, 400, 750));\
\},\{\
	w= \cf9 Window\cf2 (\cf7 "send:"\cf2 +key+(noteArray[key]), \cf9 Rect\cf2 (sendWinLastPos[0], sendWinLastPos[1], 400, 750));\
\});\
sendWinOpen= w;\
tabNames= [\cf7 "MIDI"\cf2 , \cf7 "OSC"\cf2 , \cf7 "DMX"\cf2 ];\
\
t= \cf9 TabbedView\cf2 (w, \cf9 Rect\cf2 (0, 0, 400, 750), tabNames, [\cf9 Color\cf2 .new255(158, 158, 158), \cf9 Color\cf2 .new255(148, 148, 148), \cf9 Color\cf2 .new255(138, 138, 138)]);\
\
\cf5 // =================================================\cf2 \
\cf5 // =================== M I D I =====================\cf2 \
\cf5 // =================================================\cf2 \
\
	\cf5 //t.views[0].decorator=FlowLayout(w.view.bounds);\cf2 \
	\cf5 //t.views[0].decorator.gap=2@2;\cf2 \
	\
	midiSendBut= \cf9 Button\cf2 (t.views[0], \cf9 Rect\cf2 (4, 4, 100, 30))\
	.canFocus_(\cf4 false\cf2 )\
	.states_([[\cf7 "MIDI send OFF"\cf2 , \cf9 Color\cf2 .grey, \cf9 Color\cf2 .black], [\cf7 "MIDI send ON"\cf2 , \cf9 Color\cf2 .green, \cf9 Color\cf2 .black]])\
	.value_(properties[key][11][0])\
		.action_(\{\cf3 |v|\cf2 \
			properties[key][11][0]= v.value;\
		\});\
	\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf9 Button\cf2 (t.views[0], \cf9 Rect\cf2 (106, 4, 40, 20))\
.canFocus_(\cf4 false\cf2 )\
.states_([[\cf7 "test"\cf2 , \cf9 Color\cf2 .white, \cf9 Color\cf2 .black], [\cf7 "test"\cf2 , \cf9 Color\cf2 .green, \cf9 Color\cf2 .black]])\
.action_(\{\cf3 |v|\cf2 \
	if(v.value == 1, \{testMIDI= \cf4 true\cf2 ; if(midiOut.isNil, \{\cf7 "midiOUT not connected!"\cf2 .postln;\}); \}, \
		\{testMIDI= \cf4 false\cf2 ;\
			if(midiOut.isNil.not, \{\
				midiOut.sysex(\cf9 Int8Array\cf2 [0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][2][0], 0x00, properties[key][11][2][1], 0x00, 0xf7]);\
			\});\
		\});\
\});\
\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf5 // ============  MIDI Load Save Menu  ============\cf2 \
\
saveDirectoryMIDI= (\cf9 String\cf2 .scDir.dirname ++ \cf7 "/Resources/SENDWINSAVES/MIDI/"\cf2 );\
\
		saveFilesMIDI= (saveDirectoryMIDI++\cf7 "*"\cf2 ).standardizePath.pathMatch;\
		\cf5 //saveDirectory.postln;\cf2 \
		\cf5 //saveFiles.postln;\cf2 \
		\cf9 StaticText\cf2 (t.views[0], \cf9 Rect\cf2 (148, 4, 60, 30)).string_(\cf7 "save/load:"\cf2 ).align_(\cf10 \\left\cf2 );\
		loadMenuMIDI= \cf9 PopUpMenu\cf2 (t.views[0], \cf9 Rect\cf2 (210, 4, 100, 20)) \cf5 // -----\cf2 \
		.items_(saveFilesMIDI.collect(\{\cf3 |it|\cf2  it.basename\}))\
		.canFocus_(\cf4 false\cf2 )\
		.background_(\cf9 Color\cf2 .white)\
		.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 , 10))\
		.action_(\{\cf3 |v|\cf2 \
			loadMenuItemMIDI= v.items.at(v.value);\
			if(verbose, \{\
			loadMenuItemMIDI.postln; \
			saveFilesMIDI[loadMenuMIDI.value].postln;\
			\});\
		\});\
		\cf5 //load preset\cf2 \
		\cf9 Button\cf2 (t.views[0], \cf9 Rect\cf2 (312, 4, 20, 20)) \cf5 // ------\cf2 \
		.states_([[\cf7 "L"\cf2 , \cf9 Color\cf2 .red, \cf9 Color\cf2 .black]])\
		.canFocus_(\cf4 false\cf2 )\
		.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 , 10))\
		.action_(\{ \
			if (loadMenuItemMIDI.isNil.not, \{ \
				\cf5 //this.load(saveFilesMIDI[loadMenuMIDI.value])\cf2 \
				\cf5 //("before load:"+properties[key][11]).postln;\cf2 \
				properties[key][11]= \cf9 Object\cf2 .readArchive(saveFilesMIDI[loadMenuMIDI.value]);\
				\cf5 //remove view\cf2 \
				midiView.remove;\
				\cf5 //add view\cf2 \
				midiView= \cf9 CompositeView\cf2 (t.views[0], \cf9 Rect\cf2 (4, 36, 400, 400));\
				makeNewMidiView.value;\
				\{midiSendBut.value= 1\}.defer;\
				\cf5 /*\
				midiView= CompositeView(t.views[0], Rect(4, 36, 400, 400));\
				\{ midiNoteOnSlider.value= properties[key][11][1][0] \}.defer;\
				\{ midiNoteOnValSlider.value= properties[key][11][1][1] \}.defer;\
				\{ midiNoteOffSlider.value= properties[key][11][2][0] \}.defer;\
				\{ midiNoteOffValSlider.value= properties[key][11][2][1] \}.defer;\
				*/\cf2 \
				\cf5 //("after load:"+properties[key][11]).postln;\cf2 \
			\});\
		\});\
		\cf9 Button\cf2 (t.views[0], \cf9 Rect\cf2 (334, 4, 30, 20))\
		.states_([[\cf7 "qs"\cf2 ]])\
		.canFocus_(\cf4 false\cf2 )\
		.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 , 12))\
		.action_(\{ \
			\cf5 //this.save(saveDirectoryMIDI+/+saveFilesMIDI[loadMenuMIDI.value]) \cf2 \
			properties[key][11].writeArchive(saveFilesMIDI[loadMenuMIDI.value]);\
		\});\
		\cf9 Button\cf2 (t.views[0], \cf9 Rect\cf2 (366, 4, 20, 20))\
		.states_([[\cf7 "s"\cf2 ]])\
		.canFocus_(\cf4 false\cf2 )\
		.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 , 12))\
		.action_(\{\
			\cf5 //save preset\cf2 \
			\cf3 var\cf2  w, t, name, saveBut;\
				w= \cf9 Window\cf2 (\cf7 "save"\cf2 , \cf9 Rect\cf2 (400, 400, 230, 100), border: \cf4 false\cf2 )\
				.background_(\cf9 Color\cf2 .black)\
				.alwaysOnTop_(\cf4 true\cf2 );\
	\
				t= \cf9 TextView\cf2 (w, \cf9 Rect\cf2 (10, 10, 210, 20))\
				.focus(\cf4 true\cf2 )\
				.keyDownAction_(\{\cf3 |view, char, mod, uni, key|\cf2 \
					if(key == 36, \{ \{saveBut.valueAction= 1\}.defer; \});\
				\});\
				\
				saveBut= \cf9 Button\cf2 (w, \cf9 Rect\cf2 (10, 40, 100, 40))\
				.states_([[\cf7 "save"\cf2 ]])\
				.action_(\{\
					\cf3 var\cf2  values, path, stringSize;\
					stringSize= t.string.size;\
					if (stringSize > 0, \{\
						name= t.string;\
						path= saveDirectoryMIDI+/+(name);\
						\cf5 //this.save(path);\cf2 \
						(\cf7 "saving this:"\cf2 +properties[key][11]).postln;\
						properties[key][11].writeArchive(path);\
						\cf5 //currentSaveFile= path;\cf2 \
						saveFilesMIDI= (saveDirectoryMIDI++\cf7 "*"\cf2 ).standardizePath.pathMatch;\
						\{loadMenuMIDI.items= saveFilesMIDI.collect(\{\cf3 |it|\cf2  it.basename.asSymbol\});\}.defer;\
						loadMenuMIDI.value= loadMenuMIDI.items.indexOf(name.asSymbol);\
						w.close;\
					\});\
				\});\
				\cf9 Button\cf2 (w, \cf9 Rect\cf2 (120, 40, 100, 40))\
				.states_([[\cf7 "cancel"\cf2 ]])\
				.action_(\{\
					w.close;\
				\});\
				w.front;\
		\});\
	\
	midiView= \cf9 CompositeView\cf2 (t.views[0], \cf9 Rect\cf2 (4, 36, 400, 400)).background_(\cf9 Color\cf2 .new255(158, 158, 158));\
	midiView.decorator=\cf9 FlowLayout\cf2 (w.view.bounds);\
	midiView.decorator.gap=2@2;\
	\
\
makeNewMidiView= \{\cf3 |seq= false|\cf2 \
	\cf3 var\cf2  durationView, waitStringView, setWaitString, envView;\
	\
	midiView.decorator=\cf9 FlowLayout\cf2 (w.view.bounds);\
	midiView.decorator.gap=2@2;\
\
	\cf9 PopUpMenu\cf2 (midiView, 150@20)\
	.items_([\cf7 "single value"\cf2 , \cf7 "onset detect"\cf2 , \cf7 "sequencer"\cf2 ])\
	.value_(properties[key][11][3])\
	.background_(\cf9 Color\cf2 .white)\
	.canFocus_(\cf4 false\cf2 )\
	.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 , 15))\
	.action_(\{\cf3 |v|\cf2 \
		\cf3 var\cf2  val;\
		val= v.value;\
		properties[key][11][3]= v.value;\
		case\
		\{v.value == 0\} \{\
			properties[key][11][3]= v.value.deepCopy;\
			\cf5 //remove view\cf2 \
			midiView.remove;\
			\cf5 //add view\cf2 \
			midiView= \cf9 CompositeView\cf2 (t.views[0], \cf9 Rect\cf2 (4, 36, 400, 400));\
			properties[key][11][1]= [1, 0]; \cf5 //noteon\cf2 \
			properties[key][11][2]= [1, 0]; \cf5 //noteoff\cf2 \
			properties[key][11][3]= 0; \cf5 //type (0 = single)\cf2 \
			properties[key][11][4]= 0.3; \cf5 //duration\cf2 \
			\cf5 //properties[key][11][5]= 1; //midimsgType *change*\cf2 \
			makeNewMidiView.value;\
			\}\
		\{v.value == 1\} \{\
			properties[key][11][3]= v.value.deepCopy;\
			\cf5 //remove view\cf2 \
			midiView.remove;\
			\cf5 //add view\cf2 \
			midiView= \cf9 CompositeView\cf2 (t.views[0], \cf9 Rect\cf2 (4, 36, 400, 400));\
			properties[key][11][1]= [1, 0]; \cf5 //noteon\cf2 \
			properties[key][11][2]= [1, 0]; \cf5 //noteoff\cf2 \
			properties[key][11][3]= 1; \cf5 //type (1 = onset)\cf2 \
			properties[key][11][4]= 0.3; \cf5 //duration\cf2 \
			\cf5 //properties[key][11][5]= 1; //midimsgType *change*\cf2 \
			makeNewMidiView.value;\
			\}\
		\{v.value == 2\} \{ \cf5 // make sequencer\cf2 \
			properties[key][11][3]= v.value.deepCopy;\
			\cf5 //remove view\cf2 \
			midiView.remove;\
			\cf5 //add view\cf2 \
			midiView= \cf9 CompositeView\cf2 (t.views[0], \cf9 Rect\cf2 (4, 36, 400, 400));\
			\cf5 //properties[key][11][1]= [1, [[0.0, 0.5], [0.1, 0.8]]]; //noteon\cf2 \
			properties[key][11][1]= [1, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]; \cf5 //noteon\cf2 \
			properties[key][11][2]= [1, 0]; \cf5 //noteoff\cf2 \
			properties[key][11][3]= 2; \cf5 //type (2 = seq)\cf2 \
			properties[key][11][4]= a.length((\cf7 "snd"\cf2 ++(key).asString).asSymbol); \cf5 //duration\cf2 \
			\cf5 //properties[key][11][5]= 1;  //midimsgType *change*\cf2 \
			\cf5 //properties[key][11][1]= [[1, [[0.0, 0.5], [0.1, 0.8]]] [1, 0], 2, a.length(("snd"++(key).asString).asSymbol), 95];\cf2 \
			(\cf7 "sound length:"\cf2 +a.length((\cf7 "snd"\cf2 ++(key).asString).asSymbol)).postln;\
			\cf5 //properties[key][15][1][label][1]= [[0.0, 0.5], [0.1, 0.8]];\cf2 \
			(\cf7 "making seq with these props:"\cf2 +properties[key][11]).postln;\
			makeNewMidiView.value(\cf4 true\cf2 );\
			\};\
	\});\
	\
	\cf9 PopUpMenu\cf2 (midiView, 150@20)\
	.items_([\cf7 "submaster"\cf2 , \cf7 "macro"\cf2 , \cf7 "go cue"\cf2 , \cf7 "grandmaster"\cf2 ])\
	.value_(properties[key][11][5])\
	.background_(\cf9 Color\cf2 .white)\
	.canFocus_(\cf4 false\cf2 )\
	.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 , 12))\
	.action_(\{\cf3 |v|\cf2 \
		\cf3 var\cf2  val;\
		val= v.value;\
		properties[key][11][5]= v.value;\
		\cf5 /*\
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
			*/\cf2 \
	\});\
	\
	\cf9 StaticText\cf2 (midiView, \cf9 Rect\cf2 (0, 0, 400, 30)).string_(\cf7 "NOTE ON:"\cf2 ).align_(\cf10 \\center\cf2 );\
	\
	if(properties[key][11][3] == 2, \{\
		\cf5 //"making seq".postln; \cf2 \
	(\cf7 "chek dis val:"\cf2 +properties[key][11][1][0]).postln;\
	midiNoteOnSlider= \cf9 EZSlider\cf2 (midiView, 392@30, \
		\cf7 "subm"\cf2 ,\
		[0, 300, \cf10 \\lin\cf2 , 1].asSpec,\
		initVal: properties[key][11][1][0], \
		numberWidth:60,\
		layout:\cf10 \\horz\cf2 )\
		.setColors(\cf9 Color\cf2 .grey,\cf9 Color\cf2 .white)\
		.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 ,20))\
		.action_(\{\cf3 |v|\cf2 \
			properties[key][11][1][0]= v.value;\
			properties[key][11][2][0]= v.value;\
			midiNoteOffSlider.value= v.value;\
		\});\
		\
	if (properties[key][11][4].isNil, \{properties[key][11][4]= 4\}); \cf5 //set duration if not set\cf2 \
	\
	\cf9 StaticText\cf2 (midiView, 55@20).string_(\cf7 "Duration:"\cf2 );\
	durationView= \cf9 NumberBox\cf2 (midiView, 70@20)\
	.value_(properties[key][11][4])\
	.action_(\{\cf3 |v|\cf2 \
		properties[key][11][4]= v.value;\
		setWaitString.value(envView);\
		\});\
	\cf9 StaticText\cf2 (midiView, 30@20).string_(\cf7 "sec"\cf2 );\
	\
	\cf7 "prop:"\cf2 .post; properties[key][11][1][1].postln;\
	if (properties[key][11][1][1].size < 3, \{\
		properties[key][11][1][1]= [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];\
		\});\
	\
envView = \cf9 MultiSliderView\cf2 (midiView, \cf9 Rect\cf2 (0, 0, 390, 200))\
	.value_(properties[key][11][1][1])\
	.gap_(0)\
	.indexThumbSize_(390/21)\
	.action_(\{ \cf3 |v|\cf2   \
		properties[key][11][1][1]= v.value;\
		\});\
\
\
\cf5 /*\
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
*/\cf2 \
\
\
		\}, \{\
			\cf5 //"NOT making seq!".postln;\cf2 \
			\
	\cf5 //StaticText(midiView, Rect(0, 0, 300, 30)).string_("NOTE ON:").align_(\\center);\cf2 \
	midiNoteOnSlider= \cf9 EZSlider\cf2 (midiView, 392@30, \
		\cf7 "subm"\cf2 ,\
		[0, 300, \cf10 \\lin\cf2 , 1].asSpec,\
		initVal: properties[key][11][1][0], \
		numberWidth:60,\
		layout:\cf10 \\horz\cf2 )\
		.setColors(\cf9 Color\cf2 .grey,\cf9 Color\cf2 .white)\
		.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 ,20))\
		.action_(\{\cf3 |v|\cf2 \
			properties[key][11][1][0]= v.value;\
			properties[key][11][2][0]= v.value;\
			midiNoteOffSlider.value= v.value;\
		\});\
	midiNoteOnValSlider= \cf9 EZSlider\cf2 (midiView, 392@30, \
		\cf7 "val"\cf2 ,\
		[0, 100, \cf10 \\lin\cf2 , 1].asSpec,\
		initVal: properties[key][11][1][1], \
		numberWidth:60,\
		layout:\cf10 \\horz\cf2 )\
		.setColors(\cf9 Color\cf2 .grey,\cf9 Color\cf2 .white)\
		.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 ,20))\
		.action_(\{\cf3 |v|\cf2 \
			properties[key][11][1][1]= v.value;\
			if(testMIDI, \{\
				if(midiOut.isNil.not, \{\
					midiOut.sysex(\cf9 Int8Array\cf2 [0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][1][0], 0x00, properties[key][11][1][1], 0x00, 0xf7]);\
				\});\
			\});\
		\});\
\
\
	\
		\});\
\
		\
	\cf9 StaticText\cf2 (midiView, \cf9 Rect\cf2 (0, 0, 300, 30)).string_(\cf7 "NOTE OFF:"\cf2 ).align_(\cf10 \\center\cf2 );\
	midiNoteOffSlider= \cf9 EZSlider\cf2 (midiView, 392@30, \
		\cf7 "subm"\cf2 ,\
		[0, 300, \cf10 \\lin\cf2 , 1].asSpec,\
		initVal: properties[key][11][2][0], \
		numberWidth:60,\
		layout:\cf10 \\horz\cf2 )\
		.setColors(\cf9 Color\cf2 .grey,\cf9 Color\cf2 .white)\
		.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 ,20))\
		.action_(\{\cf3 |v|\cf2 \
			properties[key][11][2][0]= v.value;\
		\});\
	midiNoteOffValSlider= \cf9 EZSlider\cf2 (midiView, 392@30, \
		\cf7 "val"\cf2 ,\
		[0, 100, \cf10 \\lin\cf2 , 1].asSpec,\
		initVal: properties[key][11][2][1], \
		numberWidth:60,\
		layout:\cf10 \\horz\cf2 )\
		.setColors(\cf9 Color\cf2 .grey,\cf9 Color\cf2 .white)\
		.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 ,20))\
		.action_(\{\cf3 |v|\cf2 \
			properties[key][11][2][1]= v.value;\
			if(testMIDI, \{\
				if(midiOut.isNil.not, \{\
					midiOut.sysex(\cf9 Int8Array\cf2 [0xf0, 0x7f, 0x01,  0x02, 0x01,  0x06, properties[key][11][2][0], 0x00, properties[key][11][2][1], 0x00, 0xf7]);\
				\});\
			\});\
		\});\
		\
	if(properties[key][11][3] == 1, \{\
		\cf9 StaticText\cf2 (midiView, \cf9 Rect\cf2 (0, 0, 70, 30))\
		.string_(\cf7 "Duration:"\cf2 );\
		\cf9 NumberBox\cf2 (midiView, \cf9 Rect\cf2 (0, 0, 100, 20))\
		.value_(properties[key][11][4])\
		.action_(\{\cf3 |v|\cf2  properties[key][11][4]= v.value \})\
		.clipLo_(0)\
		.clipHi_(1.5);\
	\});\
\
	\};\
	\
	makeNewMidiView.value;\
\
		\
\cf5 // ======== O S C =======\cf2 \
\
\cf5 // button to choose which host to send to\cf2 \
\cf5 //	when pressed check if handshake has been made if not make handshake\cf2 \
\cf5 //	use NetAddr, stored in Dict (its only sending so dont need much OSCfuncs)\cf2 \
\
\cf5 // for noteon and noteoff:\cf2 \
\
\cf5 // menu with relative options of \\symbols - commands\cf2 \
\cf5 // direct value or ramp to (fork?)\cf2 \
\
\
	t.views[1].decorator=\cf9 FlowLayout\cf2 (w.view.bounds);\
	t.views[1].decorator.gap=2@2;\
	\
	oscOnOffBut= \cf9 Button\cf2 (t.views[1], \cf9 Rect\cf2 (0, 0, 100, 30))\
	.canFocus_(\cf4 false\cf2 )\
	.states_([[\cf7 "OSC send OFF"\cf2 , \cf9 Color\cf2 .grey, \cf9 Color\cf2 .black], [\cf7 "OSC send ON"\cf2 , \cf9 Color\cf2 .green, \cf9 Color\cf2 .black]])\
	.value_(properties[key][15][0])\
	.action_(\{\cf3 |v|\cf2  \
		properties[key][15][0]= v.value;\
	\});\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf9 Button\cf2 (t.views[1], \cf9 Rect\cf2 (0, 0, 30, 30))\
.states_([[\cf7 "-"\cf2 ]])\
.canFocus_(\cf4 false\cf2 )\
.action_(\{\
	if (oscTab.views.size > 0, \{\
			properties[key][15][1].removeAt(oscTab.labels[oscTab.activeTab].asSymbol);\
			oscTab.removeAt(oscTab.activeTab);\
		\});\
\});\
\cf9 Button\cf2 (t.views[1], \cf9 Rect\cf2 (0, 0, 30, 30))\
.states_([[\cf7 "+"\cf2 ]])\
.canFocus_(\cf4 false\cf2 )\
.action_(\{\
	if(oscTab.labels.indexOfEqual(robotMenu.item.asString).isNil, \{\
		oscTab.add(robotMenu.item);\
		properties[key][15][1].add(robotMenu.item.deepCopy -> \cf6 ~robotDict\cf2 [robotMenu.item][2].deepCopy);\
		makeNewOscTab.value(oscTab.labels.size-1, robotMenu.item);\
	\}, \{\cf7 "Allready a Tab for this Robot!!"\cf2 .postln;\});\
\});\
robotMenu= \cf9 PopUpMenu\cf2 (t.views[1], \cf9 Rect\cf2 (0, 0, 100, 30))\
.items_(\cf6 ~robotDict\cf2 .keys.asArray.sort)\
.background_(\cf9 Color\cf2 .white)\
.canFocus_(\cf4 false\cf2 )\
.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 , 15));\
\
\cf9 Button\cf2 (t.views[1], \cf9 Rect\cf2 (0, 0, 80, 30))\
	.canFocus_(\cf4 false\cf2 )\
	.states_([[\cf7 "Rec OSC"\cf2 , \cf9 Color\cf2 .red, \cf9 Color\cf2 .black]])\
	.action_(\{\cf3 |v|\cf2  \
		recOSC.value;\
	\});\
\
t.views[1].decorator.nextLine;\
\
\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf5 // ============  OSC Load Save Menu  ============\cf2 \
\
saveDirectoryOSC= (\cf9 String\cf2 .scDir.dirname ++ \cf7 "/Resources/SENDWINSAVES/OSC/"\cf2 );\
\cf5 //saveDirectoryOSC= "/Users/martin/scwork/samplerProject/Sampler \\Central.app/Contents/Resources/SENDWINSAVES/OSC/";\cf2 \
\
		saveFilesOSC= (saveDirectoryOSC++\cf7 "*"\cf2 ).standardizePath.pathMatch;\
		\cf5 //saveDirectory.postln;\cf2 \
		\cf5 //saveFiles.postln;\cf2 \
		\cf9 StaticText\cf2 (t.views[1], 58@30).string_(\cf7 "save/load:"\cf2 ).align_(\cf10 \\left\cf2 );\
		loadMenuOSC= \cf9 PopUpMenu\cf2 (t.views[1], 100@20) \cf5 // -----\cf2 \
		.items_(saveFilesOSC.collect(\{\cf3 |it|\cf2  it.basename\}))\
		.canFocus_(\cf4 false\cf2 )\
		.background_(\cf9 Color\cf2 .white)\
		.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 , 10))\
		.action_(\{\cf3 |v|\cf2 \
			loadMenuItemOSC= v.items.at(v.value);\
			if(verbose, \{\
			loadMenuItemOSC.postln; \
			saveFilesOSC[loadMenuOSC.value].postln;\
			\});\
		\});\
		\cf5 //load preset\cf2 \
		\cf9 Button\cf2 (t.views[1], 20@20) \cf5 // ------\cf2 \
		.states_([[\cf7 "L"\cf2 , \cf9 Color\cf2 .red, \cf9 Color\cf2 .black]])\
		.canFocus_(\cf4 false\cf2 )\
		.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 , 10))\
		.action_(\{\
			\cf3 var\cf2  loadArray;\
			if (loadMenuItemOSC.isNil.not, \{ \
				\cf5 //this.load(saveFilesOSC[loadMenuOSC.value])\cf2 \
				\cf5 //("before load:"+properties[key][11]).postln;\cf2 \
				loadArray= \cf9 Object\cf2 .readArchive(saveFilesOSC[loadMenuOSC.value]);\
				properties[key][15][0]= loadArray[0];\
				oscOnOffBut.value= properties[key][15][0];\
				\cf5 // remove all tabs and properties\cf2 \
				(oscTab.views.size).do(\{\cf3 |it|\cf2 \
					\cf5 //properties[key][15][1].removeAt(oscTab[it].asSymbol);\cf2 \
					\cf5 // maybe properties[key][15][1]= Dictionary.new;\cf2 \
					oscTab.removeAt(it);\
				\});\
				properties[key][15][1]= loadArray[1].postln;\
				\
				properties[key][15][1].keysValuesDo(\{\cf3 |name, value, i|\cf2 \
					\cf3 var\cf2  seq= \cf4 false\cf2 ;\
					oscTab.add(name);\
					\cf5 //("checkit:"+properties[key][15][1][name][0]).postln;\cf2 \
					if(value[1] == 2, \{ seq= \cf4 true\cf2 \});\
					makeNewOscTab.value(i, name, seq); \cf5 //|i, label, seq= false|\cf2 \
				\});\
				\
				(\cf7 "after load:"\cf2 +properties[key][15]).postln;\
			\});\
		\});\
		\cf9 Button\cf2 (t.views[1], 30@20)\
		.states_([[\cf7 "qs"\cf2 ]])\
		.canFocus_(\cf4 false\cf2 )\
		.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 , 12))\
		.action_(\{ \
			\cf5 //this.save(saveDirectoryOSC+/+saveFilesOSC[loadMenuOSC.value]) \cf2 \
			properties[key][11].writeArchive(saveDirectoryOSC+/+saveFilesOSC[loadMenuOSC.value]);\
		\});\
		\cf9 Button\cf2 (t.views[1], 20@20)\
		.states_([[\cf7 "s"\cf2 ]])\
		.canFocus_(\cf4 false\cf2 )\
		.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 , 12))\
		.action_(\{\
			\cf5 //save preset\cf2 \
			\cf3 var\cf2  w, t, name, saveBut;\
				w= \cf9 Window\cf2 (\cf7 "save"\cf2 , \cf9 Rect\cf2 (400, 400, 230, 100), border: \cf4 false\cf2 )\
				.background_(\cf9 Color\cf2 .black)\
				.alwaysOnTop_(\cf4 true\cf2 );\
	\
				t= \cf9 TextView\cf2 (w, \cf9 Rect\cf2 (10, 10, 210, 20))\
				.focus(\cf4 true\cf2 )\
				.keyDownAction_(\{\cf3 |view, char, mod, uni, key|\cf2 \
					if(key == 36, \{ \{saveBut.valueAction= 1\}.defer; \});\
				\});\
				\
				saveBut= \cf9 Button\cf2 (w, \cf9 Rect\cf2 (10, 40, 100, 40))\
				.states_([[\cf7 "save"\cf2 ]])\
				.action_(\{\
					\cf3 var\cf2  values, path, stringSize;\
					stringSize= t.string.size;\
					if (stringSize > 0, \{\
						name= t.string;\
						path= saveDirectoryOSC+/+(name);\
						\cf5 //this.save(path);\cf2 \
						(\cf7 "saving this:"\cf2 +properties[key][15]).postln;\
						properties[key][15].writeArchive(path);\
						\cf5 //currentSaveFile= path;\cf2 \
						saveFilesOSC= (saveDirectoryOSC++\cf7 "*"\cf2 ).standardizePath.pathMatch;\
						\{loadMenuOSC.items= saveFilesOSC.collect(\{\cf3 |it|\cf2  it.basename.asSymbol\});\}.defer;\
						loadMenuOSC.value= loadMenuOSC.items.indexOf(name.asSymbol);\
						w.close;\
					\});\
				\});\
				\cf9 Button\cf2 (w, \cf9 Rect\cf2 (120, 40, 100, 40))\
				.states_([[\cf7 "cancel"\cf2 ]])\
				.action_(\{\
					w.close;\
				\});\
				w.front;\
		\});\
\
\
oscTab= \cf9 TabbedView\cf2 (t.views[1], \cf9 Rect\cf2 (0, 0, 400, 400), properties[key][15][1].keys, [\cf9 Color\cf2 .new255(158, 158, 158)]);\
\
properties[key][15][1].keysValuesDo(\{\cf3 |name, value, i|\cf2 \
	\cf3 var\cf2  seq= \cf4 false\cf2 ;\
	\cf3 var\cf2  durationView, waitStringView, setWaitString, envView;\
	\cf3 var\cf2  oscloadmenu, oscmenuitem, curOscRecName;\
	\
	if(value[1] == 2, \{ seq= \cf4 true\cf2 \});\
	\
	oscTab.views[i].decorator=\cf9 FlowLayout\cf2 (w.view.bounds);\
	oscTab.views[i].decorator.gap=2@2;\
	\
	oscTypeMenu= \cf9 PopUpMenu\cf2 (oscTab.views[i], 150@20)\
	.items_([\cf7 "single value"\cf2 , \cf7 "onset detect"\cf2 , \cf7 "sequencer"\cf2 , \cf7 "note on only"\cf2 , \cf7 "custom message"\cf2 ])\
	.background_(\cf9 Color\cf2 .white)\
	.canFocus_(\cf4 false\cf2 )\
	.value_(properties[key][15][1][name][1])\
	.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 , 15))\
	.action_(\{\cf3 |v|\cf2 \
		properties[key][15][1][name][1]= v.value.deepCopy;\
		case\
		\{v.value == 0\} \{\
			\cf5 //remove view\cf2 \
			oscTab.removeAt(oscTab.activeTab);\
			\cf5 //add view\cf2 \
			oscTab.add(name);\
			properties[key][15][1][name]= \cf6 ~robotDict\cf2 [name][2].deepCopy;\
			makeNewOscTab.value(oscTab.labels.size-1, name, \cf4 false\cf2 );\
			oscTab.focus(oscTab.labels.size-1);\
			\}\
		\{v.value == 1\} \{\
			properties[key][15][1][name]= \cf6 ~robotDict\cf2 [name][2].deepCopy;\
			properties[key][15][1][name][1]= v.value;\
			\cf5 //remove view\cf2 \
			oscTab.removeAt(oscTab.activeTab);\
			\cf5 //add view\cf2 \
			oscTab.add(name);\
			makeNewOscTab.value(oscTab.labels.size-1, name, \cf4 false\cf2 );\
			oscTab.focus(oscTab.labels.size-1);\
			\}\
		\{v.value == 2\} \{\
			\cf5 //remove view\cf2 \
			oscTab.removeAt(oscTab.activeTab);\
			\cf5 //add view\cf2 \
			oscTab.add(name);\
			properties[key][15][1][name]= [[\cf7 "none"\cf2 , 90], 2, a.length((\cf7 "snd"\cf2 ++(key).asString).asSymbol), 95];\
			(\cf7 "sound length:"\cf2 +a.length((\cf7 "snd"\cf2 ++(key).asString).asSymbol)).postln;\
			\cf5 //("making seq with these props:"+properties[key][15][1][name]).postln;\cf2 \
			makeNewOscTab.value(oscTab.labels.size-1, name, \cf4 true\cf2 );\
			oscTab.focus(oscTab.labels.size-1);\
			\}\
		\{v.value == 3\} \{\
			\cf5 //remove view\cf2 \
			oscTab.removeAt(oscTab.activeTab);\
			\cf5 //add view\cf2 \
			oscTab.add(name);\
			properties[key][15][1][name]= \cf6 ~robotDict\cf2 [name][2].deepCopy;\
			properties[key][15][1][name][1]= v.value;\
			makeNewOscTab.value(oscTab.labels.size-1, name, \cf4 false\cf2 );\
			oscTab.focus(oscTab.labels.size-1);\
			\}\
		\{v.value == 4\} \{\
			\cf5 //remove view\cf2 \
			oscTab.removeAt(oscTab.activeTab);\
			\cf5 //add view\cf2 \
			oscTab.add(name);\
			properties[key][15][1][name]= \cf6 ~robotDict\cf2 [name][2].deepCopy;\
			properties[key][15][1][name][1]= v.value;\
			makeNewOscTab.value(oscTab.labels.size-1, name, \cf4 false\cf2 );\
			oscTab.focus(oscTab.labels.size-1);\
			\}\
			;\
	\});\
	\
	\cf9 StaticText\cf2 (oscTab.views[i], \cf9 Rect\cf2 (0, 0, 400, 30)).string_(\cf7 "NOTE ON:"\cf2 ).align_(\cf10 \\center\cf2 );\
	\
	if(seq, \{\
		\cf5 //"making seq".postln; value[0].postln;\cf2 \
\
	\
	\
\cf5 //oscfilesDir= "/Users/martin/Desktop/OSCRecordings/";\cf2 \
oscfiles= (oscfilesDir++\cf7 "*"\cf2 ).standardizePath.pathMatch;\
oscsavefiles= oscfiles.addFirst(\cf7 "none"\cf2 );\
oscfiles= oscfiles.addFirst(\cf7 "none"\cf2 );\
oscsavefiles= oscsavefiles.collect(\{\cf3 |it|\cf2  it.basename\});\
oscloadmenu= \cf9 PopUpMenu\cf2 (oscTab.views[i], 300@40)\
.canFocus_(\cf4 true\cf2 )\
.stringColor_(\cf9 Color\cf2 .green)\
.background_(\cf9 Color\cf2 .red.alpha_(0.5))\
.items_( oscsavefiles )\
.action_(\{ \cf3 |v|\cf2 \
	oscmenuitem= v.items.at(v.value);\
	\cf5 //menuitem.postln;\cf2 \
	\cf5 //files[loadmenu.value].postln;\cf2 \
	\cf5 //("menu size:"+loadmenu.items.size).postln;\cf2 \
	\cf5 //("files size:"+files.size).postln;\cf2 \
	\cf5 //("loadmenu fileS:"+loadmenu.items).postcs;\cf2 \
	\cf5 //("files fileS:"+files).postcs;\cf2 \
\})\
.canReceiveDragHandler_(\cf4 true\cf2 )\
.receiveDragHandler_(\{\cf3 |view|\cf2 \
	\cf9 View\cf2 .currentDrag.postln;\
	\cf9 View\cf2 .currentDrag.copyTo(oscfilesDir, overwrite: \cf4 true\cf2 );\
	curOscRec= oscfilesDir+/+(\cf9 View\cf2 .currentDrag.basename);\
	properties[key][15][1][name][0][0]= curOscRec;\
	curOscRecName.string= curOscRec.basename;\
\});\
oscmenuitem= properties[key][15][1][name][0][0];\
	\
	\cf5 //list of recordings\cf2 \
\
	\
	\cf5 //button sets recording\cf2 \
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf9 Button\cf2 (oscTab.views[i], 40@30).states_([[\cf7 "L"\cf2 , \cf9 Color\cf2 .red, \cf9 Color\cf2 .black]])\
.action_(\{\
	if (oscmenuitem == \cf7 "none"\cf2 , \{\cf4 nil\cf2 \}, \{\
		\cf5 //("loading"+files[loadmenu.value]).postln;\cf2 \
		\cf5 //values= Object.readArchive(files[loadmenu.value]);\cf2 \
		curOscRec= oscfilesDir++oscloadmenu.item;\
		curOscRecName.string= oscloadmenu.item;\
		properties[key][15][1][name][0][0]= curOscRec;\
		\
		\})\
\})\
.canReceiveDragHandler_(\cf4 true\cf2 )\
.receiveDragHandler_(\{\cf3 |view|\cf2 \
	\cf9 View\cf2 .currentDrag.postln;\
	\cf9 View\cf2 .currentDrag.copyTo(oscfilesDir, overwrite: \cf4 true\cf2 );\
	curOscRec= oscfilesDir+/+(\cf9 View\cf2 .currentDrag.basename);\
	properties[key][15][1][name][0][0]= curOscRec;\
	curOscRecName.string= curOscRec.basename;\
\});\
	properties[key][15][1][name][0][0].basename.postln;\
	\cf5 //text display current recording to play\cf2 \
curOscRecName= \cf9 StaticText\cf2 (oscTab.views[i], 300@40).string_(\cf7 "none"\cf2 );\
	if (properties[key][15][1][name][0][0].isNil.not, \{\
		curOscRecName.string= (properties[key][15][1][name][0][0].basename);\
		\});\
\
		\}, \{\
			\cf5 //"NOT making seq!".postln;\cf2 \
	\cf9 EZSlider\cf2 (oscTab.views[i], 392@30, \
		name, \cf5 // label\cf2 \
		\cf6 ~robotDict\cf2 [name][1], \cf5 // control spec\cf2 \
		initVal: value[0][0], \
		numberWidth:60,\
		layout:\cf10 \\horz\cf2 )\
		.setColors(\cf9 Color\cf2 .grey,\cf9 Color\cf2 .white)\
		.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 ,20))\
		.action_(\{\cf3 |v|\cf2 \
			properties[key][15][1][name][0][0]= v.value;\
		\});\
\
	\});\
	\
	\cf5 // checking for note on only\cf2 \
	if (properties[key][15][1][name][1] != 3, \{\
		\cf9 StaticText\cf2 (oscTab.views[i], \cf9 Rect\cf2 (0, 0, 400, 30)).string_(\cf7 "NOTE OFF:"\cf2 ).align_(\cf10 \\center\cf2 );\
		\cf9 EZSlider\cf2 (oscTab.views[i], 392@30, \
			name, \cf5 // label\cf2 \
			\cf6 ~robotDict\cf2 [name][1], \cf5 // control spec\cf2 \
			initVal: properties[key][15][1][name][0][1], \cf5 // init value \cf2 \
			numberWidth:60,\
			layout:\cf10 \\horz\cf2 )\
			.setColors(\cf9 Color\cf2 .grey,\cf9 Color\cf2 .white)\
			.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 ,20))\
			.action_(\{\cf3 |v|\cf2 \
					properties[key][15][1][name][0][1]= v.value;\
			\});\
	\});\
	\
\
\});\
\
makeNewOscTab= \{\cf3 |i, label, seq= false|\cf2 \
	\cf3 var\cf2  durationView, waitStringView, setWaitString, envView;\
	\cf3 var\cf2  oscloadmenu, oscmenuitem, curOscRecName;\
	\
	oscTab.views[i].decorator=\cf9 FlowLayout\cf2 (w.view.bounds);\
	oscTab.views[i].decorator.gap=2@2;\
\
	oscTypeMenu= \cf9 PopUpMenu\cf2 (oscTab.views[i], 150@20)\
	.items_([\cf7 "single value"\cf2 , \cf7 "onset detect"\cf2 , \cf7 "sequencer"\cf2 , \cf7 "note on only"\cf2 , \cf7 "custom"\cf2 ])\
	.value_(properties[key][15][1][label][1])\
	.background_(\cf9 Color\cf2 .white)\
	.canFocus_(\cf4 false\cf2 )\
	.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 , 15))\
	.action_(\{\cf3 |v|\cf2 \
		\cf3 var\cf2  val;\
		val= v.value;\
		properties[key][15][1][label][1]= v.value;\
		case\
		\{v.value == 0\} \{ \cf5 // single value\cf2 \
			\cf5 //remove view\cf2 \
			oscTab.removeAt(oscTab.activeTab);\
			\cf5 //add view\cf2 \
			oscTab.add(label);\
			properties[key][15][1][label]= \cf6 ~robotDict\cf2 [label][2].deepCopy;\
			\cf5 //properties[key][15][1][label][1]= 0;\cf2 \
			makeNewOscTab.value(oscTab.labels.size-1, label, \cf4 false\cf2 );\
			oscTab.focus(oscTab.labels.size-1);\
			\}\
		\{v.value == 1\} \{ \cf5 // onset detection (coyote)\cf2 \
			properties[key][15][1][label]= \cf6 ~robotDict\cf2 [label][2].deepCopy;\
			properties[key][15][1][label][1]= v.value.deepCopy;\
			\cf5 //remove view\cf2 \
			oscTab.removeAt(oscTab.activeTab);\
			\cf5 //add view\cf2 \
			oscTab.add(label);\
			makeNewOscTab.value(oscTab.labels.size-1, label, \cf4 false\cf2 );\
			oscTab.focus(oscTab.labels.size-1);\
			\}\
		\{v.value == 2\} \{ \cf5 // play osc recording (sequencer)\cf2 \
			\cf5 //remove view\cf2 \
			oscTab.removeAt(oscTab.activeTab);\
			\cf5 //add view\cf2 \
			oscTab.add(label);\
			properties[key][15][1][label]= [[\cf7 "none"\cf2 , \cf6 ~robotDict\cf2 [label][2][0][1]], 2, 90, 95];\
			(\cf7 "sound length:"\cf2 +a.length((\cf7 "snd"\cf2 ++(key).asString).asSymbol)).postln;\
			\cf5 //properties[key][15][1][label][1]= [[0.0, 0.5], [0.1, 0.8]];\cf2 \
			\cf5 //("making seq with these props:"+properties[key][15][1][label]).postln;\cf2 \
			makeNewOscTab.value(oscTab.labels.size-1, label, \cf4 true\cf2 );\
			oscTab.focus(oscTab.labels.size-1);\
			\}\
		\{v.value == 3\} \{ \cf5 // noteon only\cf2 \
			\cf5 //remove view\cf2 \
			oscTab.removeAt(oscTab.activeTab);\
			\cf5 //add view\cf2 \
			oscTab.add(label);\
			properties[key][15][1][label]= \cf6 ~robotDict\cf2 [label][2].deepCopy;\
			properties[key][15][1][label][1]= 3;\
			makeNewOscTab.value(oscTab.labels.size-1, label, \cf4 false\cf2 );\
			oscTab.focus(oscTab.labels.size-1);\
			\}\
		\{v.value == 4\} \{ \cf5 // custom message\cf2 \
			\cf5 //remove view\cf2 \
			oscTab.removeAt(oscTab.activeTab);\
			\cf5 //add view\cf2 \
			oscTab.add(label);\
			properties[key][15][1][label]= \cf6 ~robotDict\cf2 [label][2].deepCopy;\
			properties[key][15][1][label][1]= v.value.deepCopy;\
			makeNewOscTab.value(oscTab.labels.size-1, label, \cf4 false\cf2 );\
			oscTab.focus(oscTab.labels.size-1);\
			\};\
	\});\
	\
	\cf9 StaticText\cf2 (oscTab.views[i], \cf9 Rect\cf2 (0, 0, 400, 30)).string_(\cf7 "NOTE ON:"\cf2 ).align_(\cf10 \\center\cf2 );\
	\
	if(seq, \{\
		\cf5 //"making seq".postln;\cf2 \
		\
		\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf5 //oscfilesDir= "/Users/martin/Desktop/OSCRecordings/";\cf2 \
oscfiles= (oscfilesDir++\cf7 "*"\cf2 ).standardizePath.pathMatch;\
oscsavefiles= oscfiles.addFirst(\cf7 "none"\cf2 );\
oscfiles= oscfiles.addFirst(\cf7 "none"\cf2 );\
oscsavefiles= oscsavefiles.collect(\{\cf3 |it|\cf2  it.basename\});\
oscloadmenu= \cf9 PopUpMenu\cf2 (oscTab.views[i], 300@40)\
.canFocus_(\cf4 false\cf2 )\
.stringColor_(\cf9 Color\cf2 .green)\
.background_(\cf9 Color\cf2 .red.alpha_(0.5))\
.items_( oscsavefiles )\
.action_(\{ \cf3 |v|\cf2 \
	oscmenuitem= v.items.at(v.value);\
	oscmenuitem.postln;\
	oscfiles[oscloadmenu.value].postln;\
	\cf5 //("menu size:"+loadmenu.items.size).postln;\cf2 \
	\cf5 //("files size:"+files.size).postln;\cf2 \
	\cf5 //("loadmenu fileS:"+loadmenu.items).postcs;\cf2 \
	\cf5 //("files fileS:"+files).postcs;\cf2 \
\})\
.canReceiveDragHandler_(\cf4 true\cf2 )\
.receiveDragHandler_(\{\cf3 |view|\cf2 \
	\cf9 View\cf2 .currentDrag.postln;\
	\cf9 View\cf2 .currentDrag.copyTo(oscfilesDir, overwrite: \cf4 true\cf2 );\
	curOscRec= oscfilesDir+/+(\cf9 View\cf2 .currentDrag.basename);\
	properties[key][15][1][label][0][0]= curOscRec;\
	curOscRecName.string= curOscRec.basename;\
\});\
oscmenuitem= properties[key][15][1][label][0][0];\
	\
	\cf5 //list of recordings\cf2 \
\
	\
	\cf5 //button sets recording\cf2 \
	\cf9 Button\cf2 (oscTab.views[i], 40@30).states_([[\cf7 "L"\cf2 , \cf9 Color\cf2 .red, \cf9 Color\cf2 .black]])\
	.action_(\{\
	if (oscmenuitem == \cf7 "none"\cf2 , \{\cf4 nil\cf2 \}, \{\
		\cf5 //("loading"+files[loadmenu.value]).postln;\cf2 \
		\cf5 //values= Object.readArchive(files[loadmenu.value]);\cf2 \
		curOscRec= oscfilesDir++oscloadmenu.item;\
		curOscRecName.string= oscloadmenu.item;\
		properties[key][15][1][label][0][0]= curOscRec;\
		\
		\})\
	\});\
	\cf5 //text display current recording to play\cf2 \
	curOscRecName= \cf9 StaticText\cf2 (oscTab.views[i], 300@40).string_(\cf7 "none"\cf2 );\
	if (properties[key][15][1][label][0][0].isNil.not, \{\
		curOscRecName.string= (properties[key][15][1][label][0][0].basename);\
		\});\
	\
	\cf9 Button\cf2 (oscTab.views[i], 120@20).states_([[\cf7 "open in editor"\cf2 ]])\
	.action_(\{\
	if (oscmenuitem == \cf7 "none"\cf2 , \{\cf4 nil\cf2 \}, \{\
		\cf5 //("loading"+files[loadmenu.value]).postln;\cf2 \
		\cf5 //values= Object.readArchive(files[loadmenu.value]);\cf2 \
		curOscRec= oscfilesDir++oscloadmenu.item;\
		curOscRecName.string= oscloadmenu.item;\
		oscPlotter= \cf9 OSCFileLogPlotter\cf2 .new(curOscRec, \cf9 NetAddr\cf2 (\cf6 ~ipDict\cf2 [label][0],\cf6 ~ipDict\cf2 [label][1]));\
		oscPlotter.loadSoundFile(sounds[key]);\
		\
		\})\
	\});\
	\
	\cf9 Button\cf2 (oscTab.views[i], 120@20).states_([[\cf7 "reveal in finder"\cf2 ]])\
	.action_(\{\
	if (oscmenuitem == \cf7 "none"\cf2 , \{\cf4 nil\cf2 \}, \{\
		\cf5 //("loading"+files[loadmenu.value]).postln;\cf2 \
		\cf5 //values= Object.readArchive(files[loadmenu.value]);\cf2 \
		curOscRec= oscfilesDir++oscloadmenu.item;\
		curOscRecName.string= oscloadmenu.item;\
		curOscRec.revealInFinder;\
		\})\
	\});\
\
\}, \{\
			\cf5 //"NOT making seq!".postln;\cf2 \
	if(properties[key][15][1][label][1] == 4, \{ \cf5 // custom message note on\cf2 \
		\cf9 TextField\cf2 (oscTab.views[i], 392@30)\
		.string_(properties[key][15][1][label][0][0])\
		.action_(\{\cf3 |v|\cf2  properties[key][15][1][label][0][0]= v.value; \});\
		\
	\},\{ \cf5 //normal note on single value note on\cf2 \
		\cf9 EZSlider\cf2 (oscTab.views[i], 392@30, \
			\cf6 ~robotDict\cf2 [label.asSymbol][0], \cf5 // label\cf2 \
			\cf6 ~robotDict\cf2 [label.asSymbol][1], \cf5 // control spec\cf2 \
			initVal: \cf6 ~robotDict\cf2 [label.asSymbol][2][0][0], \
			numberWidth:60,\
			layout:\cf10 \\horz\cf2 )\
			.setColors(\cf9 Color\cf2 .grey,\cf9 Color\cf2 .white)\
			.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 ,20))\
			.action_(\{\cf3 |v|\cf2 \
				properties[key][15][1][label][0][0]= v.value;\
			\});\
		\});\
	\
		\});\
\
	\cf9 StaticText\cf2 (oscTab.views[i], \cf9 Rect\cf2 (0, 0, 400, 30)).string_(\cf7 "NOTE OFF:"\cf2 ).align_(\cf10 \\center\cf2 );\
	\
	if(properties[key][15][1][label][1] == 4, \{ \cf5 // custom message note off\cf2 \
		\cf9 TextField\cf2 (oscTab.views[i], 392@30)\
		.string_(properties[key][15][1][label][0][1])\
		.action_(\{\cf3 |v|\cf2  properties[key][15][1][label][0][1]= v.value; \});\
		\
	\},\{ \
		if (properties[key][15][1][label][1] != 3, \{\
		\cf5 //normal note on single value note off\cf2 \
		\cf9 EZSlider\cf2 (oscTab.views[i], 392@30, \
			\cf6 ~robotDict\cf2 [label.asSymbol][0], \cf5 // label\cf2 \
			\cf6 ~robotDict\cf2 [label.asSymbol][1], \cf5 // control spec\cf2 \
			initVal: properties[key][15][1][label][0][1], \cf5 // init value\cf2 \
			numberWidth:60,\
			layout:\cf10 \\horz\cf2 )\
			.setColors(\cf9 Color\cf2 .grey,\cf9 Color\cf2 .white)\
			.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 ,20))\
			.action_(\{\cf3 |v|\cf2 \
				properties[key][15][1][label][0][1]= v.value;\
			\});\
		\});\
	\});\
		\
	if(properties[key][15][1][label][1] == 1, \{\
		\cf9 StaticText\cf2 (oscTab.views[i], \cf9 Rect\cf2 (0, 0, 70, 30))\
		.string_(\cf7 "Duration:"\cf2 );\
		\cf9 NumberBox\cf2 (oscTab.views[i], \cf9 Rect\cf2 (0, 0, 100, 20))\
		.value_(properties[key][15][1][label][2])\
		.action_(\{\cf3 |v|\cf2  properties[key][15][1][label][2]= v.value \})\
		.clipLo_(0)\
		.clipHi_(1.5);\
	\});\
\
	\};\
\
\
\cf5 // record OSC GUI\cf2 \
recOSC= \{\
\
\cf3 var\cf2  w, win, recbut, rec, stop, timelog, oscplayer, n, playbut, play, stopplay;\
\cf3 var\cf2  clockGUI, recPath, recFolder;\
\cf3 var\cf2  ipText, portText, nameText;\
\
recPath= oscfilesDir+/+\cf7 "robotOSCTest/"\cf2 ;\
recFolder= oscfilesDir;\
\
win= \cf9 Window\cf2 (\cf7 "Record OSC"\cf2 , \cf9 Rect\cf2 (0, 0, 270, 300));\
w= \cf9 CompositeView\cf2 (win, \cf9 Rect\cf2 (0, 0, 270, 300));\
w.decorator = \cf9 FlowLayout\cf2 (w.bounds);\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf9 StaticText\cf2 (w, \cf9 Rect\cf2 (10, 10, 50, 20)).string_(\cf7 "name:"\cf2 );\
nameText= \cf9 TextField\cf2 (w, \cf9 Rect\cf2 (10, 10, 200, 20))\
.string_(\cf7 "RobotOSCTest"\cf2 );\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf5 //.action_(\{arg field; recPath= (recFolder++field.value) \});\cf2 \
\
w.decorator.nextLine;\
w.decorator.nextLine;\
w.decorator.nextLine;\
\
recbut= \cf9 Button\cf2 .new(w,\cf9 Rect\cf2 (20, 10, 260, 40))\
	.states_([ [ \cf7 "rec"\cf2 , \cf9 Color\cf2 .black, \cf9 Color\cf2 .red ], [ \cf7 "stop"\cf2 , \cf9 Color\cf2 .white, \cf9 Color\cf2 .blue] ])\
	.action_\{\cf3 |v|\cf2 \
		case \
		\{v.value == 1\} \{rec.value\}\
		\{v.value == 0\} \{stop.value\};\
		\};\
\
rec= \{\
	oscRecording= \cf4 true\cf2 ;\
	recPath= recFolder++nameText.string;\
	recPath.postln;\
	\
	timelog= \cf9 OSCFileLog\cf2 .new( recPath );\
	\cf5 //n = NetAddr.new( "localhost", NetAddr.langPort );\cf2 \
	\
	clockGUI.reset;\
	clockGUI.play;\
	\cf5 /*\
	Task(\{ 5.do\{\
		n.sendMsg("SR1120");\
		2.0.rand.min(0.8).wait;\
		n.sendMsg("SR190");\
		2.0.rand.min(0.8).wait;\
	\}\}).play;\
	*/\cf2 \
	\};\
	\
stop= \{\
	oscRecording= \cf4 false\cf2 ;\
	timelog.close;\
	clockGUI.pause;\
	\};\
\
clockGUI= \cf9 ClockGUI\cf2 .new(w, \cf9 Rect\cf2 (20, 40, 260, 100));\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf9 StaticText\cf2 (w, \cf9 Rect\cf2 (10, 10, 50, 20)).string_(\cf7 "send to:"\cf2 );\
ipText= \cf9 TextField\cf2 (w, \cf9 Rect\cf2 (10, 10, 100, 20)).string_(\cf7 "172.16.3.179"\cf2 );\
\cf9 StaticText\cf2 (w, \cf9 Rect\cf2 (10, 10, 30, 20)).string_(\cf7 "port:"\cf2 );\
portText= \cf9 TextField\cf2 (w, \cf9 Rect\cf2 (10, 10, 50, 20)).string_(\cf7 "8888"\cf2 );\
\cf9 Button\cf2 (w, \cf9 Rect\cf2 (10, 10, 50, 20)).states_([[\cf7 "set"\cf2 ]])\
.action_(\{\
	n = \cf9 NetAddr\cf2 .new(ipText.string, portText.string.interpret);\
	\});\
\
playbut= \cf9 Button\cf2 .new(w,\cf9 Rect\cf2 (20, 10, 260, 40))\
	.states_([ [ \cf7 "play"\cf2 , \cf9 Color\cf2 .black, \cf9 Color\cf2 .grey ], [ \cf7 "stop"\cf2 , \cf9 Color\cf2 .white, \cf9 Color\cf2 .green] ])\
	.action_\{\cf3 |v|\cf2 \
		case \
		\{v.value == 1\} \{play.value\}\
		\{v.value == 0\} \{stopplay.value\};\
		\};\
\
play= \{\
	n = \cf9 NetAddr\cf2 .new(\cf7 "172.16.3.179"\cf2 , 8888);\
	\cf5 //n = NetAddr.new( "localhost", NetAddr.langPort );\cf2 \
	\cf9 OSCFunc\cf2 .trace( \cf4 true\cf2  );\
	oscplayer = \cf9 OSCFileLogPlayer\cf2 .new(timelog.timelogfile.pathDir, n, \{ playbut.valueAction= 0 \} );\
	oscplayer.play;\
	\};\
\
stopplay= \{\
	oscplayer.stop;\
	oscplayer.close;\
	\cf9 OSCFunc\cf2 .trace( \cf4 false\cf2  );\
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
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf5 // =============== D M X ==================\cf2 \
\
	t.views[2].decorator=\cf9 FlowLayout\cf2 (w.view.bounds);\
	t.views[2].decorator.gap=2@2;\
\
\
	dmxOnOffBut= \cf9 Button\cf2 (t.views[2], \cf9 Rect\cf2 (0, 0, 60, 20))\
	.canFocus_(\cf4 false\cf2 )\
	.states_([[\cf7 "DMX OFF"\cf2 , \cf9 Color\cf2 .grey, \cf9 Color\cf2 .black], [\cf7 "DMX ON"\cf2 , \cf9 Color\cf2 .green, \cf9 Color\cf2 .black]])\
	.value_(properties[key][16][0])\
	.action_(\{\cf3 |v|\cf2  \
		properties[key][16][0]= v.value;\
	\});\
	\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf9 Button\cf2 (t.views[2], \cf9 Rect\cf2 (0, 0, 60, 20))\
.canFocus_(\cf4 false\cf2 )\
.states_([[\cf7 "rcv Dump"\cf2 , \cf9 Color\cf2 .white, \cf9 Color\cf2 .black], [\cf7 "rcv Dump"\cf2 , \cf9 Color\cf2 .green, \cf9 Color\cf2 .black]])\
.action_(\{\cf3 |v|\cf2 \
	if(v.value == 1, \{\
		\cf5 //somehow receive dmx\cf2 \
		\}, \{\
		\cf5 // stop that somehow\cf2 \
		\});\
\});\
\
\cf9 Button\cf2 (t.views[2], \cf9 Rect\cf2 (0, 0, 30, 20))\
.canFocus_(\cf4 false\cf2 )\
.states_([[\cf7 "tst"\cf2 , \cf9 Color\cf2 .white, \cf9 Color\cf2 .black], [\cf7 "tst"\cf2 , \cf9 Color\cf2 .green, \cf9 Color\cf2 .black]])\
.action_(\{\cf3 |v|\cf2 \
	if(v.value == 1, \{testDMX= \cf4 true\cf2 \}, \{testDMX= \cf4 false\cf2 \});\
\});\
\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf5 // ============  DMX Load Save Menu  ============\cf2 \
\
saveDirectoryDMX= (\cf9 String\cf2 .scDir.dirname ++ \cf7 "/Resources/SENDWINSAVES/DMX/"\cf2 );\
\cf5 //saveDirectoryDMX= "/Users/martin/scwork/samplerProject/Sampler \\Central.app/Contents/Resources/SENDWINSAVES/DMX/";\cf2 \
\
		saveFilesDMX= (saveDirectoryDMX++\cf7 "*"\cf2 ).standardizePath.pathMatch;\
		\cf5 //saveDirectory.postln;\cf2 \
		\cf5 //saveFiles.postln;\cf2 \
		\cf9 StaticText\cf2 (t.views[2], 58@30).string_(\cf7 "save/load:"\cf2 ).align_(\cf10 \\left\cf2 );\
		loadMenuDMX= \cf9 PopUpMenu\cf2 (t.views[2], 100@20) \cf5 // -----\cf2 \
		.items_(saveFilesDMX.collect(\{\cf3 |it|\cf2  it.basename\}))\
		.canFocus_(\cf4 false\cf2 )\
		.background_(\cf9 Color\cf2 .white)\
		.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 , 10))\
		.action_(\{\cf3 |v|\cf2 \
			loadMenuItemDMX= v.items.at(v.value);\
			if(verbose, \{\
			\cf5 //loadMenuItemDMX.postln; \cf2 \
			\cf5 //saveFilesDMX[loadMenuDMX.value].postln;\cf2 \
			\});\
		\});\
		\cf5 //load preset\cf2 \
		\cf9 Button\cf2 (t.views[2], 20@20) \cf5 // ------\cf2 \
		.states_([[\cf7 "L"\cf2 , \cf9 Color\cf2 .red, \cf9 Color\cf2 .black]])\
		.canFocus_(\cf4 false\cf2 )\
		.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 , 10))\
		.action_(\{ \
			\cf3 var\cf2  loadArray;\
			if (loadMenuItemDMX.isNil.not, \{ \
				\cf5 //this.load(saveFilesDMX[loadMenuDMX.value])\cf2 \
				\cf5 //("before load:"+properties[key][16]).postln;\cf2 \
				loadArray= \cf9 Object\cf2 .readArchive(saveFilesDMX[loadMenuDMX.value]);\
				\cf5 //saveFilesDMX[loadMenuDMX.value].postln;\cf2 \
				\cf5 //("loadArray:"+loadArray).postln;\cf2 \
				properties[key][16][0]= loadArray[0];\
				dmxOnOffBut.value= properties[key][16][0];\
				properties[key][16][1][0]= \cf9 DMXSubCue\cf2 .new;\
				properties[key][16][1][1]= \cf9 DMXSubCue\cf2 .new;\
				loadArray[1][0][0].do(\{\cf3 |it, i|\cf2  properties[key][16][1][0].put(it, loadArray[1][0][1][i]) \});\
				loadArray[1][1][0].do(\{\cf3 |it, i|\cf2  properties[key][16][1][1].put(it, loadArray[1][1][1][i]) \});\
				\
				\cf5 //("after load:"+properties[key][16]).postln;\cf2 \
				updateDmxNoteOnView.value;\
				updateDmxNoteOffView.value;\
				\
			\});\
		\});\
		\cf9 Button\cf2 (t.views[2], 30@20)\
		.states_([[\cf7 "qs"\cf2 ]])\
		.canFocus_(\cf4 false\cf2 )\
		.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 , 12))\
		.action_(\{\
			\cf3 var\cf2  noteOnChans, noteOnVal, noteOffChans, noteOffVals, saveArray;\
			\cf5 //this.save(saveDirectoryDMX+/+saveFilesDMX[loadMenuDMX.value]) \cf2 \
			\cf5 //noteOnChans= properties[key][16][1][0].data.indices.collect(\{|it| it\})\cf2 \
			saveArray= [properties[key][16][0], [[properties[key][16][1][0].data.indices, properties[key][16][1][0].data], [properties[key][16][1][1].data.indices, properties[key][16][1][1].data]]];\
			\cf5 //saveArray= [properties[key][16][0], [properties[key][16][1][0].indices, properties[key][16][1][0].data, properties[key][16][1][1].indices, properties[key][16][1][1].data ]]\cf2 \
			saveArray.writeArchive(saveDirectoryDMX+/+saveFilesDMX[loadMenuDMX.value]);\
		\});\
		\cf9 Button\cf2 (t.views[2], 20@20)\
		.states_([[\cf7 "s"\cf2 ]])\
		.canFocus_(\cf4 false\cf2 )\
		.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 , 12))\
		.action_(\{\
			\cf5 //save preset\cf2 \
			\cf3 var\cf2  w, t, name, saveBut;\
				w= \cf9 Window\cf2 (\cf7 "save"\cf2 , \cf9 Rect\cf2 (400, 400, 230, 100), border: \cf4 false\cf2 )\
				.background_(\cf9 Color\cf2 .black)\
				.alwaysOnTop_(\cf4 true\cf2 );\
	\
				t= \cf9 TextView\cf2 (w, \cf9 Rect\cf2 (10, 10, 210, 20))\
				.focus(\cf4 true\cf2 )\
				.keyDownAction_(\{\cf3 |view, char, mod, uni, key|\cf2 \
					if(key == 36, \{ \{saveBut.valueAction= 1\}.defer; \});\
				\});\
				\
				saveBut= \cf9 Button\cf2 (w, \cf9 Rect\cf2 (10, 40, 100, 40))\
				.states_([[\cf7 "save"\cf2 ]])\
				.action_(\{\
					\cf3 var\cf2  values, path, stringSize;\
					\cf3 var\cf2  saveArray;\
					\
					stringSize= t.string.size;\
					if (stringSize > 0, \{\
						name= t.string;\
						path= saveDirectoryDMX+/+(name);\
						saveArray= [properties[key][16][0], [[properties[key][16][1][0].data.indices, properties[key][16][1][0].data.asArray], [properties[key][16][1][1].data.indices, properties[key][16][1][1].data.asArray]]];\
						\cf5 //this.save(path);\cf2 \
						\cf5 //("saving this:"+saveArray).postln;\cf2 \
						saveArray.writeArchive(path);\
						\cf5 //currentSaveFile= path;\cf2 \
						saveFilesDMX= (saveDirectoryDMX++\cf7 "*"\cf2 ).standardizePath.pathMatch;\
						\{loadMenuDMX.items= saveFilesDMX.collect(\{\cf3 |it|\cf2  it.basename.asSymbol\});\}.defer;\
						loadMenuDMX.value= loadMenuDMX.items.indexOf(name.asSymbol);\
						w.close;\
					\});\
				\});\
				\cf9 Button\cf2 (w, \cf9 Rect\cf2 (120, 40, 100, 40))\
				.states_([[\cf7 "cancel"\cf2 ]])\
				.action_(\{\
					w.close;\
				\});\
				w.front;\
		\});\
		\
t.views[2].decorator.nextLine;\
\
\
	\cf9 StaticText\cf2 (t.views[2], \cf9 Rect\cf2 (0, 0, 400, 30)).string_(\cf7 "NOTE ON:"\cf2 ).align_(\cf10 \\center\cf2 );\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf9 Button\cf2 (t.views[2], \cf9 Rect\cf2 (0, 0, 30, 20))\
.states_([[\cf7 "-"\cf2 ]])\
.canFocus_(\cf4 false\cf2 )\
.action_(\{\
	if (dmxNoteOnSliders.size > 0, \{\
			properties[key][16][1][0].data.removeAtSlot(dmxNoteOnViewSelect.value);\
			dmxNoteOnViewSelect.value= 0;\
			dmxNoteOnViewSelect.clipHi= (properties[key][16][1][0].data.size-1);\
			updateDmxNoteOnView.value;\
		\});\
	\cf5 //also remove noteoff\cf2 \
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
dmxNoteOnViewSelect= \cf9 NumberBox\cf2 (t.views[2], \cf9 Rect\cf2 (0, 0, 30, 20))\
		.value_(0)\
		.step_(1)\
		.scroll_step_(1)\
		.clipLo_(0)\
		.clipHi_(\
			\{properties[key][16][1][0].data.size -1\}.try;\
		)\
		.action_(\{\cf3 |v|\cf2  \
			\{ dmxNoteOnSliders[v.value].sliderView.focus \}.defer;\
			dmxNoteOffViewSelect.value= v.value;\
		\});\
\
\
\cf9 Button\cf2 (t.views[2], \cf9 Rect\cf2 (0, 0, 30, 20))\
.states_([[\cf7 "+"\cf2 ]])\
.canFocus_(\cf4 false\cf2 )\
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
	\}, \{\cf7 "Allready a Fader for this Channel!!"\cf2 .postln;\});\
\});\
\
\
dmxNoteOnViewAdd= \cf9 NumberBox\cf2 (t.views[2], \cf9 Rect\cf2 (0, 0, 30, 20))\
		.value_(0)\
		.step_(1)\
		.scroll_step_(1)\
		.clipLo_(0)\
		.clipHi_(512);\
\
\
\cf9 Button\cf2 (t.views[2], \cf9 Rect\cf2 (0, 0, 60, 20))\
.canFocus_(\cf4 false\cf2 )\
.states_([[\cf7 "add BLK"\cf2 , \cf9 Color\cf2 .white, \cf9 Color\cf2 .black], [\cf7 "add BLK"\cf2 , \cf9 Color\cf2 .green, \cf9 Color\cf2 .black]])\
.value_(1)\
.action_(\{\cf3 |v|\cf2 \
	if(v.value == 1, \{addBlack= \cf4 true\cf2 \}, \{addBlack= \cf4 false\cf2 \});\
\});\
\
\
t.views[2].decorator.nextLine;\
\
dmxNoteOnScroll= \cf9 ScrollView\cf2 (t.views[2], 400@300);\
dmxNoteOnScroll.hasVerticalScroller= \cf4 false\cf2 ;\
dmxNoteOnScroll.hasHorizontalScroller= \cf4 true\cf2 ;\
\
\
dmxNoteOnLayout= \cf9 CompositeView\cf2 (dmxNoteOnScroll, 800@300).decorator_(\cf9 FlowLayout\cf2 (w.view.bounds));\
\
\
if( properties[key][16][1][0].data.size > 0, \{\
dmxNoteOnView= properties[key][16][1][0].data.indices.collect(\{\cf3 |it, i|\cf2 \
		\cf9 CompositeView\cf2 (dmxNoteOnLayout, \cf9 Rect\cf2 (0, 0, 30, 300));\
\});\
\
dmxNoteOnChannel= properties[key][16][1][0].data.indices.collect(\{\cf3 |it, i|\cf2 \
		\cf9 NumberBox\cf2 (dmxNoteOnView[i], 30@20)\
		.value_(it)\
		\cf5 //.background_(white)\cf2 \
		.step_(1)\
		.clipLo_(0)\
		.clipHi_(512)\
		.action_(\{\cf3 |v|\cf2 \
			properties[key][16][1][0].put(v.value, dmxNoteOnSliders[i].value);\
		\});\
\});\
\
dmxNoteOnSliders= properties[key][16][1][0].data.indices.collect(\{\cf3 |it, i|\cf2 \
		\cf9 EZSlider\cf2 (dmxNoteOnView[i], \cf9 Rect\cf2 (0, 20, 30, 260), \
		\cf4 nil\cf2 , \cf5 // label\cf2 \
		[0.0, 1.0, \cf10 \\lin\cf2 , 0.01].asSpec, \cf5 // control spec\cf2 \
		initVal: properties[key][16][1][0].at(properties[key][16][1][0].data.indices[i]), \
		numberWidth:20,\
		layout:\cf10 \\vert\cf2 )\
		.setColors(\cf9 Color\cf2 .grey,\cf9 Color\cf2 .white)\
		.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 ,10))\
\});\
\
\
dmxNoteOnSliders.do(\{ \cf3 |it, i|\cf2 \
		dmxNoteOnSliders[i].sliderView.mouseUpAction= (\{\
			properties[key][16][1][0].put(dmxNoteOnChannel[i].value, dmxNoteOnSliders[i].value);\
			\cf5 //~dmx.postln;\cf2 \
			\cf5 //properties[key][16][1][0].postln;\cf2 \
			\cf5 //properties[key][16][1][0].data.postln;\cf2 \
			if(testDMX, \{ \cf6 ~dmx\cf2 .fade(properties[key][16][1][0], 0.1, \cf10 'linear'\cf2 , 0.1) \});\
		\});\
		dmxNoteOnSliders[i].numberView.mouseUpAction= (\{\
			properties[key][16][1][0].put(dmxNoteOnChannel[i].value, dmxNoteOnSliders[i].value);\
			if(testDMX, \{ \cf6 ~dmx\cf2 .fade(properties[key][16][1][0], 0.1, \cf10 'linear'\cf2 , 0.1) \});\
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
	dmxNoteOnLayout= \cf9 CompositeView\cf2 (dmxNoteOnScroll, 800@300).decorator_(\cf9 FlowLayout\cf2 (w.view.bounds));\
	\
	dmxNoteOnView= properties[key][16][1][0].data.indices.collect(\{\cf3 |it, i|\cf2 \
			\cf9 CompositeView\cf2 (dmxNoteOnLayout, \cf9 Rect\cf2 (0, 0, 30, 300));\
	\});\
	\
	dmxNoteOnChannel= properties[key][16][1][0].data.indices.collect(\{\cf3 |it, i|\cf2 \
			\cf9 NumberBox\cf2 (dmxNoteOnView[i], 30@20)\
			.value_(it)\
			\cf5 //.background_(white)\cf2 \
			.step_(1)\
			.clipLo_(0)\
			.clipHi_(512)\
			.action_(\{\cf3 |v|\cf2 \
				properties[key][16][1][0].put(v.value, dmxNoteOnSliders[i].value);\
			\});\
	\});\
\
	\cf5 //properties[key][16][1][0].at(properties[key][16][1][0].data.indices[i]).postln;	\cf2 \
\
	dmxNoteOnSliders= properties[key][16][1][0].data.indices.collect(\{\cf3 |it, i|\cf2 \
		\cf9 EZSlider\cf2 (dmxNoteOnView[i], \cf9 Rect\cf2 (0, 20, 30, 260), \
		\cf4 nil\cf2 , \cf5 // label\cf2 \
		[0.0, 1.0, \cf10 \\lin\cf2 , 0.01].asSpec, \cf5 // control spec\cf2 \
		initVal: properties[key][16][1][0].at(it), \
		numberWidth:20,\
		layout:\cf10 \\vert\cf2 )\
		.setColors(\cf9 Color\cf2 .grey,\cf9 Color\cf2 .white)\
		.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 ,10))\
	\});\
	\
\
	dmxNoteOnSliders.do(\{ \cf3 |it, i|\cf2 \
		dmxNoteOnSliders[i].sliderView.mouseUpAction= (\{\
			properties[key][16][1][0].put(dmxNoteOnChannel[i].value, dmxNoteOnSliders[i].value);\
			if(testDMX, \{ \cf6 ~dmx\cf2 .fade(properties[key][16][1][0], 0.1, \cf10 'linear'\cf2 , 0.1) \});\
		\});\
		dmxNoteOnSliders[i].numberView.mouseUpAction= (\{\
			properties[key][16][1][0].put(dmxNoteOnChannel[i].value, dmxNoteOnSliders[i].value);\
			if(testDMX, \{ \cf6 ~dmx\cf2 .fade(properties[key][16][1][0], 0.1, \cf10 'linear'\cf2 , 0.1) \});\
		\});\
	\});\
	\}.fork(\cf9 AppClock\cf2 );\
\};\
\
\
\cf9 StaticText\cf2 (t.views[2], \cf9 Rect\cf2 (0, 0, 400, 30)).string_(\cf7 "NOTE OFF:"\cf2 ).align_(\cf10 \\center\cf2 );\
\
t.views[2].decorator.nextLine;\
\
\cf9 Button\cf2 (t.views[2], \cf9 Rect\cf2 (0, 0, 30, 20))\
.states_([[\cf7 "-"\cf2 ]])\
.canFocus_(\cf4 false\cf2 )\
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
dmxNoteOffViewSelect= \cf9 NumberBox\cf2 (t.views[2], \cf9 Rect\cf2 (0, 0, 30, 20))\
		.value_(0)\
		.step_(1)\
		.scroll_step_(1)\
		.clipLo_(0)\
		.clipHi_( \{properties[key][16][1][1].data.size -1\}.try )\
		.action_(\{\cf3 |v|\cf2  dmxNoteOffSliders[v.value].sliderView.focus; \});\
\
\cf9 Button\cf2 (t.views[2], \cf9 Rect\cf2 (0, 0, 30, 20))\
.states_([[\cf7 "+"\cf2 ]])\
.canFocus_(\cf4 false\cf2 )\
.action_(\{\
	if(properties[key][16][1][1].data.indices.includes(dmxNoteOffViewAdd.value.asInteger).not, \{\
		properties[key][16][1][1].put(dmxNoteOffViewAdd.value, 0);\
		dmxNoteOffViewSelect.clipHi= (properties[key][16][1][1].data.size -1);\
		updateDmxNoteOffView.value;\
	\}, \{\cf7 "Allready a Fader for this Channel!!"\cf2 .postln;\});\
\});\
\
\
dmxNoteOffViewAdd= \cf9 NumberBox\cf2 (t.views[2], \cf9 Rect\cf2 (0, 0, 30, 20))\
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
dmxNoteOffScroll= \cf9 ScrollView\cf2 (t.views[2], 400@300);\
dmxNoteOffScroll.hasVerticalScroller= \cf4 false\cf2 ;\
dmxNoteOffScroll.hasHorizontalScroller= \cf4 true\cf2 ;\
\
dmxNoteOffLayout= \cf9 CompositeView\cf2 (dmxNoteOffScroll, 800@300).decorator_(\cf9 FlowLayout\cf2 (w.view.bounds));\
\
if( properties[key][16][1][0].data.size > 0, \{\
dmxNoteOffView= properties[key][16][1][1].data.indices.collect(\{\cf3 |it, i|\cf2 \
		\cf9 CompositeView\cf2 (dmxNoteOffLayout, \cf9 Rect\cf2 (0, 0, 30, 300));\
\});\
\
dmxNoteOffChannel= properties[key][16][1][1].data.indices.collect(\{\cf3 |it, i|\cf2 \
		\cf9 NumberBox\cf2 (dmxNoteOffView[i], 30@20)\
		.value_(it)\
		\cf5 //.background_(white)\cf2 \
		.step_(1)\
		.clipLo_(0)\
		.clipHi_(512)\
		.action_(\{\cf3 |v|\cf2 \
			properties[key][16][1][1].put(v.value, dmxNoteOffSliders[i].value);\
		\});\
\});\
\
dmxNoteOffSliders= properties[key][16][1][1].data.indices.collect(\{\cf3 |it, i|\cf2 \
		\cf9 EZSlider\cf2 (dmxNoteOffView[i], \cf9 Rect\cf2 (0, 20, 30, 260), \
		\cf4 nil\cf2 , \cf5 // label\cf2 \
		[0.0, 1.0, \cf10 \\lin\cf2 , 0.01].asSpec, \cf5 // control spec\cf2 \
		initVal: properties[key][16][1][1].at(properties[key][16][1][1].data.indices[i]), \
		numberWidth:20,\
		layout:\cf10 \\vert\cf2 )\
		.setColors(\cf9 Color\cf2 .grey,\cf9 Color\cf2 .white)\
		.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 ,10))\
\});\
\
\
dmxNoteOffSliders.do(\{ \cf3 |it, i|\cf2 \
		dmxNoteOffSliders[i].sliderView.mouseUpAction= (\{\
			properties[key][16][1][1].put(dmxNoteOffChannel[i].value, dmxNoteOffSliders[i].value);\
			if(testDMX, \{ \cf6 ~dmx\cf2 .fade(properties[key][16][1][1], 0.5, \cf10 'linear'\cf2 , 0.1) \});\
		\});\
		dmxNoteOffSliders[i].numberView.mouseUpAction= (\{\
			properties[key][16][1][1].put(dmxNoteOffChannel[i].value, dmxNoteOffSliders[i].value);\
			if(testDMX, \{ \cf6 ~dmx\cf2 .fade(properties[key][16][1][1], 0.5, \cf10 'linear'\cf2 , 0.1) \});\
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
	dmxNoteOffLayout= \cf9 CompositeView\cf2 (dmxNoteOffScroll, 800@300).decorator_(\cf9 FlowLayout\cf2 (w.view.bounds));\
	\
	dmxNoteOffView= properties[key][16][1][1].data.indices.collect(\{\cf3 |it, i|\cf2 \
			\cf9 CompositeView\cf2 (dmxNoteOffLayout, \cf9 Rect\cf2 (0, 0, 30, 300));\
	\});\
	\
	dmxNoteOffChannel= properties[key][16][1][1].data.indices.collect(\{\cf3 |it, i|\cf2 \
			\cf9 NumberBox\cf2 (dmxNoteOffView[i], 30@20)\
			.value_(it)\
			\cf5 //.background_(white)\cf2 \
			.step_(1)\
			.clipLo_(0)\
			.clipHi_(512)\
			.action_(\{\cf3 |v|\cf2 \
				properties[key][16][1][1].put(v.value, dmxNoteOffSliders[i].value);\
			\});\
	\});\
\
	\cf5 //properties[key][16][1][1].at(properties[key][16][1][1].data.indices[i]).postln;	\cf2 \
\
	dmxNoteOffSliders= properties[key][16][1][1].data.indices.collect(\{\cf3 |it, i|\cf2 \
		\cf9 EZSlider\cf2 (dmxNoteOffView[i], \cf9 Rect\cf2 (0, 20, 30, 260), \
		\cf4 nil\cf2 , \cf5 // label\cf2 \
		[0.0, 1.0, \cf10 \\lin\cf2 , 0.01].asSpec, \cf5 // control spec\cf2 \
		initVal: properties[key][16][1][1].at(it), \
		numberWidth:20,\
		layout:\cf10 \\vert\cf2 )\
		.setColors(\cf9 Color\cf2 .grey,\cf9 Color\cf2 .white)\
		.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 ,10))\
	\});\
	\
\
	dmxNoteOffSliders.do(\{ \cf3 |it, i|\cf2 \
		dmxNoteOffSliders[i].sliderView.mouseUpAction= (\{\
			properties[key][16][1][1].put(dmxNoteOffChannel[i].value, dmxNoteOffSliders[i].value);\
			if(testDMX, \{ \cf6 ~dmx\cf2 .fade(properties[key][16][1][1], 0.5, \cf10 'linear'\cf2 , 0.1) \});\
		\});\
		dmxNoteOffSliders[i].numberView.mouseUpAction= (\{\
			properties[key][16][1][1].put(dmxNoteOffChannel[i].value, dmxNoteOffSliders[i].value);\
			if(testDMX, \{ \cf6 ~dmx\cf2 .fade(properties[key][16][1][1], 0.5, \cf10 'linear'\cf2 , 0.1) \});\
		\});\
	\});\
	\}.fork(\cf9 AppClock\cf2 );\
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
	sendWinOpen= \cf4 nil\cf2 ;\
	\cf5 //~dmx = nil;\cf2 \
	\cf5 //\{~dmx.close; \}.try;\cf2 \
	\cf5 //\{~enttec.close; \}.try;\cf2 \
	\cf5 //sendWinLastTabFocus= t.activeTab;\cf2 \
	\cf5 //sendWinLastPos= [w.bounds.left, w.bounds.top];\cf2 \
	(\cf7 "last focused tab:"\cf2 +sendWinLastTabFocus);\
	 \};\
\
\};\
\
\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf5 // =============================================================================================\cf2 \
\cf5 // =================================== LOOP POINT EDITOR =======================================\cf2 \
\cf5 // =============================================================================================\cf2 \
\
looppointeditor= \{ \cf3 |key|\cf2 \
	\cf3 var\cf2  w, sfView, f, frames;\
		w = \cf9 Window\cf2 .new(\cf7 "set loop position"\cf2 , \cf9 Rect\cf2 (200, 200, 850, 190));\
		sfView = \cf9 SoundFileView\cf2 .new(w, \cf9 Rect\cf2 (20,20, 800, 100))\
		\cf5 //.gridResolution\cf2 \
		.canFocus_(\cf4 false\cf2 )\
		.gridColor_(\cf9 Color\cf2 .grey)\
		.timeCursorOn_(\cf4 false\cf2 )\
		.waveColors_([\cf9 Color\cf2 .red, \cf9 Color\cf2 .red])\
		.background_(\cf9 Color\cf2 (0.298, 0.298, 0.298, 1.0))\
		;\
		sfView.setSelectionColor(0, \cf9 Color\cf2 .white);\
		f = \cf9 SoundFile\cf2 .new;\
		f.openRead(sounds[key]);\
		frames= f.numFrames;\
		sfView.soundfile = f;\
		sfView.read(0, f.numFrames);\
		sfView.mouseUpAction= \{\
			\cf3 var\cf2  start, end;\
			start= sfView.selectionStart(0)/frames;\
			end= sfView.selectionSize(0)/frames + start;\
			[start, end].postln;\
			properties[key][13][1]= start;\
			properties[key][13][2]= end;\
			if(a.isPlaying((\cf7 "snd"\cf2 ++((key).asString)).asSymbol), \{\
			a.set((\cf7 "snd"\cf2 ++((key).asString)).asSymbol).startLoop_(start);\
			a.set((\cf7 "snd"\cf2 ++((key).asString)).asSymbol).endLoop_(end);\
			\});\
		\};\
		\
		if(properties[key][13].isNil.not, \{\
			sfView.setSelectionStart(0, properties[key][13][1]*frames);\
			sfView.setSelectionSize(0, (properties[key][13][2]*frames) - (properties[key][13][1]*frames));\
		\});\
		\
		\
		\cf9 Button\cf2 (w, \cf9 Rect\cf2 (825, 20, 20, 20))\
		.states_([[\cf7 "+"\cf2 ]])\
		.canFocus_(\cf4 false\cf2 )\
		.action_(\{ sfView.zoom(0.8).refresh \});\
		\
		\cf9 Button\cf2 (w, \cf9 Rect\cf2 (825, 40, 20, 20))\
		.states_([[\cf7 "-"\cf2 ]])\
		.canFocus_(\cf4 false\cf2 )\
		.action_(\{ sfView.zoom(1.2) \});\
		\
		\cf9 Button\cf2 (w, \cf9 Rect\cf2 (825, 60, 20, 20))\
		.states_([[\cf7 "0"\cf2 ]])\
		.canFocus_(\cf4 false\cf2 )\
		.action_(\{ sfView.zoomAllOut \});\
\
		\cf9 Button\cf2 (w, \cf9 Rect\cf2 (825, 90, 20, 20))\
		.states_([[\cf7 "rm"\cf2 , \cf9 Color\cf2 .red, \cf9 Color\cf2 .black]])\
		.canFocus_(\cf4 false\cf2 )\
		.action_(\{ \
			sfView.zoomAllOut;\
			properties[key][13][1]= 0;\
			properties[key][13][2]= 1;\
			sfView.setSelectionStart(0, properties[key][13][1]*frames);\
			sfView.setSelectionSize(0, properties[key][13][2]*frames);\
			sfView.mouseUpAction.value;\
		\});		\
		\
		\cf5 //move the selected part		\cf2 \
		\cf9 Slider\cf2 (w, \cf9 Rect\cf2 (20, 125, 800, 30))\
		.canFocus_(\cf4 false\cf2 )\
		.background_(\cf9 Color\cf2 (0.298, 0.298, 0.298, 1.0))\
		.knobColor_(\cf9 Color\cf2 (0.298, 0.776, 1.0, 1.0))\
		.action_(\{\cf3 |v|\cf2 \
			\cf3 var\cf2  start, end;\
			start= v.value;\
			properties[key][13][1]= start;\
			sfView.setSelectionStart(0, properties[key][13][1]*frames);\
			end= sfView.selectionSize(0)/frames + start;\
			[start, end].postln;\
			properties[key][13][2]= end;\
			if(a.isPlaying((\cf7 "snd"\cf2 ++((key).asString)).asSymbol), \{\
			a.set((\cf7 "snd"\cf2 ++((key).asString)).asSymbol).startLoop_(start);\
			a.set((\cf7 "snd"\cf2 ++((key).asString)).asSymbol).endLoop_(end);\
			\});\
		\})\
		.canReceiveDragHandler_(\cf4 true\cf2 )\
		.receiveDragHandler_(\{\cf3 |view|\cf2 \
			\cf3 var\cf2  drag;\
			drag= \cf9 View\cf2 .currentDrag;\
			if (drag.class == \cf9 UC33LoopChan\cf2 , \{\
			drag.setAction(\{\cf3 |v|\cf2 \{ view.valueAction_(v.value)\}.defer \}, \cf7 "scr"\cf2 +noteArray[key]);\
			view.onClose_(\{\});\
			\});\
		\});\
		\
		\cf5 //scroll the zoomed part\cf2 \
		\cf9 Slider\cf2 (w, \cf9 Rect\cf2 (20, 155, 800, 30))\
		.canFocus_(\cf4 false\cf2 )\
		.background_(\cf9 Color\cf2 (0.298, 0.298, 0.298, 1.0))\
		.knobColor_(\cf9 Color\cf2 (0.298, 0.776, 1.0, 1.0))\
		.action_(\{\cf3 |v|\cf2 \
			sfView.scrollTo(v.value);\
		\});\
		sfView.focus(\cf4 true\cf2 );\
		w.front;\
		w.onClose= \{\
			f.close;\
			\};\
	\};\
	\
killothernotes= \{ \cf3 |key|\cf2 \
	numKeys.do(\{\cf3 |i|\cf2 \
	if(i == key, \{\cf4 nil\cf2 \},\{ \cf5 //all other keys than key\cf2 \
		if (a.isPlaying((\cf7 "snd"\cf2 ++((i).asString)).asSymbol), \{\
			a.stop((\cf7 "snd"\cf2 ++((i).asString)).asSymbol, properties[i][4]);\
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
	\cf5 /*\
	numKeys.do(\{|i|\
		a.overlaps.do(\{\
			if (a.isPlaying(("snd"++((i).asString)).asSymbol), \{\
				a.stop(("snd"++((i).asString)).asSymbol, properties[i][4]);\
			\});\
		\});\
		//also do "snd1x1".....\
		// a.flush(0);\
	\});\
	*/\cf2 \
	 a.flush(0);\
	\
	arpRoutines.do(\{\cf3 |it|\cf2 \
		if(it.isPlaying,\{it.stop\});\
	\});\
	allKnobs.do(\{\cf3 |it|\cf2 \
		it.setVal(0);\
	\});\
	sliders.do(\{\cf3 |it|\cf2 \
		it.setVal(0);\
	\});\
	coyoteResponders.do(\{\cf3 |it|\cf2 \
		if(it.isNil.not, \{it.remove\});\
	\});\
\};\
\
arpView= \{\cf3 |i|\cf2 \
	\cf3 var\cf2  v, h, lenghtKnob, spaceKnob;\
	\cf5 //var loadASRsound;\cf2 \
	\cf5 //h= ScrollView(c, Rect(90, 100, 120, 80));\cf2 \
	h= \cf9 CompositeView\cf2 (c, \cf9 Rect\cf2 (90, 100, 120, 90))\
	.background_(\cf9 Color\cf2 .new255(229, 229, 229));\
	\
	lenghtKnob= \cf9 EZKnob\cf2 (	h,  	\cf5 // parent\cf2 \
		\cf9 Rect\cf2 (10, 0, 40, 70),	\cf5 // bounds\cf2 \
		\cf7 " length "\cf2 ,	\cf5 // label\cf2 \
		\cf10 \\rq\cf2 , 	\cf5 // controlSpec\cf2 \
		\{\cf3 |ez|\cf2  properties[i][12][0]= ez.value \}, \cf5 // action\cf2 \
		properties[i][12][0] \cf5 //init value\cf2 \
	);\
	lenghtKnob.setColors(\cf9 Color\cf2 .grey,\cf9 Color\cf2 .white);\
	\
	spaceKnob = \cf9 EZKnob\cf2 (	h,  	\cf5 // parent\cf2 \
		\cf9 Rect\cf2 (70, 0, 40, 70),	\cf5 // bounds\cf2 \
		\cf7 " space "\cf2 ,	\cf5 // label\cf2 \
		\cf10 \\delay\cf2 , 	\cf5 // controlSpec\cf2 \
		\{\cf3 |ez|\cf2  properties[i][12][1]= ez.value \}, \cf5 // action\cf2 \
		properties[i][12][1] \cf5 //init value\cf2 \
	);\
	spaceKnob.setColors(\cf9 Color\cf2 .grey,\cf9 Color\cf2 .white);\
	\
	\cf9 Button\cf2 (h, \cf9 Rect\cf2 (10, 70, 100, 18))\
	.states_([[\cf7 "toggle (hold)"\cf2 , \cf9 Color\cf2 .white, \cf9 Color\cf2 .black],[\cf7 "toggle (hold)"\cf2 , \cf9 Color\cf2 .green, \cf9 Color\cf2 .black]])\
	.value_(properties[i][12][2])\
	.action_(\{\cf3 |v|\cf2  properties[i][12][2]= v.value \});\
	\
\};\
\
\
extrasampleView= \{\cf3 |i, sam|\cf2 \
	\cf3 var\cf2  v, h, sambut;\
	\cf5 //var loadASRsound;\cf2 \
	h= \cf9 ScrollView\cf2 (c, \cf9 Rect\cf2 (90, 100, 120, 80));\
	\cf5 //h= VLayoutView(c, Rect(90, 100, 120, 90)).background_(Color.new255(229, 229, 229)).spacing_(2);\cf2 \
\
	\cf5 //h= VLayoutView(v, Rect(0, 0, 110, 140));\cf2 \
	\cf5 //properties[i][6].postln;\cf2 \
	if (properties[i][2] == 5, \{\
		\cf9 PopUpMenu\cf2 (h, \cf9 Rect\cf2 (0, 0, 100, 15))\
		.canFocus_(\cf4 false\cf2 )\
		.items_([\cf7 "sequence"\cf2 , \cf7 "random"\cf2 , \cf7 "no reset"\cf2 ])\
		.value_(properties[i][6])\
		.action_(\{\cf3 |menu|\cf2 \
			properties[i][6]= menu.value;\
		\});\
	\});\
\
	sambut= (sam.size+1).collect(\{\cf3 |ii|\cf2 \
	\cf9 Button\cf2 (h, \cf9 Rect\cf2 (0, 20+(15*ii), 100, 15))\
	.font_(\cf9 GUI\cf2 .font.new(\cf7 "Monaco"\cf2 , 9))\
	.canFocus_(\cf4 false\cf2 )\
	.states_([[\cf7 ""\cf2 , textcolors[0], colors[0]]])\
	.mouseDownAction_(\{ \cf3 |view, x, y, mod|\cf2 \
	\
		if ( mod.isShift, \{  \cf5 //shift\cf2 \
			\cf9 Dialog\cf2 .getPaths(\{ \cf3 arg\cf2  paths; \cf5 //load sound\cf2 \
			loadASRsound.value(paths, i, ii, view);\
			\cf5 /*\
			if (paths[0].isString, \{\
			\{a.freeKey(("snd"++i.asString++letters[ii]).asSymbol);\}.try;\
			paths[0].postln;\
			a.prepareForPlay(("snd"++i.asString++letters[ii]).asSymbol, paths[0]);\
			soundsASR[i][ii]= paths[0]; // where to store?????\
			view.states= ([[paths[0].basename.replace(".wav", ""), textcolors[0], colors[0]]]);\
			\});\
			*/\cf2 \
			\},\{\
				\cf7 "cancelled"\cf2 .postln;\
			\});\
		\});\
		\
	\})\
	.canReceiveDragHandler_(\cf4 true\cf2 )\
	.receiveDragHandler_(\{\cf3 |view|\cf2 \
			\cf3 var\cf2  paths;\
			paths= \cf9 View\cf2 .currentDrag;\
			loadASRsound.value(paths, i, ii, view);\
			\cf5 /*\
			if (paths[0].isString, \{\
			\{a.freeKey(("snd"++i.asString++letters[ii]).asSymbol);\}.try;\
			paths[0].postln;\
			ii.postln;\
			("snd"++i.asString++letters[ii]).asSymbol.postln;\
			a.prepareForPlay(("snd"++i.asString++letters[ii]).asSymbol, paths[0]);\
			soundsASR[i][ii]= paths[0]; // where to store?????\
			view.states= ([[paths[0].basename.replace(".wav", ""), textcolors[0], colors[0]]]);\
			\}, \{paths[0].postln;"ERROR: you cant drag that here".postln;\});\
			*/\cf2 \
	\})\
\cf5 /*	.action_(\{|v|\
		a.play(("snd"++((i).asString++"a")).asSymbol, //attack sound\
				amp: 0.5,\
				loop: 0,\
				attack: 0.01,\
				out: output\
		);\
	\})\
	*/\cf2 \
	;\
\
	\});\
	\
	\cf5 //sam.postln;\cf2 \
\
	sam.size.do(\{\cf3 |i|\cf2 \
	if (sam[i].isNil.not, \{ \
		\{sambut[i].states= ([[sam[i].basename.removeExtension, textcolors[0], colors	[0]]]);\}.defer \});\
	\});\
\
\};\
\
\
\
\
progressView= \{\cf3 |key|\cf2 \
	\cf5 //routine to draw progress view on key\cf2 \
	progress[key]= \{\
		\cf3 var\cf2  elapsed, b, mul= 10, time= a.length((\cf7 "snd"\cf2 ++(key).asString).asSymbol).round(1);\
		time= time*(properties[key][14].abs).reciprocal;\
		b= keyUserViews[key];\
		(time*mul).do(\{\cf3 |i|\cf2 \
			elapsed= (i+1)/(time*mul);\
			b.drawFunc = \{\
				\cf5 // set the Color\cf2 \
				if((i+1)==(time*mul), \{ \cf9 Pen\cf2 .fillColor = \cf9 Color\cf2 .red.alpha_(0.0);\},\
				\{ \cf9 Pen\cf2 .fillColor = \cf9 Color\cf2 .red.alpha_(0.3) \});\
			\
				\cf9 Pen\cf2 .addRect(\
					\cf9 Rect\cf2 (0, 0, (b.bounds.width*elapsed), b.bounds.height)\
					);\
				\cf9 Pen\cf2 .fill;\
			\};\
			\{w.refresh\}.defer;\
			(1/mul).wait;\
		\});\
	\}.fork(\cf9 AppClock\cf2 );	\
\};\
\
\
progressViewClear= \{\cf3 |key|\cf2 \
	\cf5 //function to clear progress view on key\cf2 \
		\cf3 var\cf2  b;\
		b= keyUserViews[key];\
\
			b.drawFunc = \{\
				\cf5 // fill with clear\cf2 \
				\cf9 Pen\cf2 .fillColor = \cf9 Color\cf2 .red.alpha_(0.0);\
			\
				\cf9 Pen\cf2 .addRect(\
					\cf9 Rect\cf2 (0, 0, b.bounds.width, b.bounds.height)\
					);\
				\cf9 Pen\cf2 .fill;\
			\};\
			\{ keyButs[key].value= 0; \}.defer\
			\{w.refresh\}.defer;\
\};\
\
\
\
loadASRsound= \{\cf3 |paths, i, num, view|\cf2 \
	paths.do(\{ \cf3 |path, ii|\cf2 \
		if (path.isString, \{\
			\cf5 //"loadASR:".postln; [i, ii, num].postln;\cf2 \
		\{a.freeKey((\cf7 "snd"\cf2 ++i.asString++\cf7 "x"\cf2 ++((num+ii).asString)).asSymbol);\}.try;\
		\cf5 //path.postln;\cf2 \
		a.prepareForPlay((\cf7 "snd"\cf2 ++i.asString++\cf7 "x"\cf2 ++((num+ii).asString)).asSymbol, path);\
		if (soundsASR[i][num+ii].isNil, \{soundsASR[i]= soundsASR[i].add(path)\}, \{soundsASR[i][num+ii]= path \});\
		\cf5 /*\
		\{sambut[num+ii].states= ([[path.basename.replace(".wav", ""), textcolors[0], colors[0]]])\}.defer;\
		*/\cf2 \
		\});\
	\});\
	properties[i][7]= soundsASR[i].size-1;\
	\cf5 //maybe \cf2 \
	\{c.remove; propView.value(i)\}.defer;\
	\};\
\
\
\cf5 // ======================== TOUCH OSC INTERFACE ================\cf2 \
touchOSC= \{\
\cf3 var\cf2  resp1=\cf9 Array\cf2 .newClear(12);\
\cf3 var\cf2  resp2=\cf9 Array\cf2 .newClear(37);\
\cf5 //var resp3=Array.newClear(12);\cf2 \
\cf5 //var resp4=Array.newClear(12);\cf2 \
\cf3 var\cf2  resp5=\cf9 Array\cf2 .newClear(12);\
\cf3 var\cf2  win;\
	\
9.do(\{\cf3 |i|\cf2 \
	resp1.put(i, \cf9 OSCresponderNode\cf2 (\cf4 nil\cf2 , \cf10 '/1/fader'\cf2 ++(i+1).asString, \{\cf3 |t, r, msg|\cf2 \
			\{sliders[i].setVal((msg[1]).round(0.001))\}.defer;	\
			\}).add;);	\
	resp1.put(i, \cf9 OSCresponderNode\cf2 (\cf4 nil\cf2 , \cf10 '/1/rotary'\cf2 ++(i+1).asString, \{\cf3 |t, r, msg|\cf2 \
			\{sliders[i].setPan((msg[1]).round(0.001))\}.defer;	\
			\}).add;);	\
\});\
\
8.do(\{\cf3 |i|\cf2 \
	resp5.put(i, \cf9 OSCresponderNode\cf2 (\cf4 nil\cf2 , \cf10 '/1/knob'\cf2 ++(i+1).asString, \{\cf3 |t, r, msg|\cf2 \
			\{allKnobs[i].setVal((msg[1]).round(0.001))\}.defer;\
			\
			\}).add;);	\
	resp5.put(i, \cf9 OSCresponderNode\cf2 (\cf4 nil\cf2 , \cf10 '/1/knobpan'\cf2 ++(i+1).asString, \{\cf3 |t, r, msg|\cf2 \
			\{allKnobs[i].setPan((msg[1]).round(0.001))\}.defer;	\
			\}).add;);	\
\});\
\
37.do(\{\cf3 |i|\cf2 \
		resp2.put(i, \cf9 OSCresponderNode\cf2 (\cf4 nil\cf2 , \cf10 '/2/push'\cf2 ++(i+1).asString, \{\cf3 |t, r, msg|\cf2 \
			\cf5 //if(sounds[i+1].isNil.not, \{\cf2 \
				if( msg[1] == 1, \
					\{playnote.value(\cf4 nil\cf2 , i, i, \cf4 nil\cf2 )\},\
					\{stopnote.value(i, i)\}\
				);\
			\cf5 //\});	\cf2 \
	\}).add;)\
\});\
\cf5 /*\
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
*/\cf2 \
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf9 OSCdef\cf2 (\cf10 \\pingResp\cf2 , \{\cf3 |msg, time, addr, recvPort|\cf2 \
	\cf5 //var n= NetAddr("android-186c303cd60796d", recvPort);\cf2 \
	\cf3 var\cf2  n= \cf9 NetAddr\cf2 (addr.ip, recvPort);\
	\
	\{\
	sliders.do(\{\cf3 |it, i|\cf2 \
		\cf3 var\cf2  name;\
		if(it.title.string.isNil, \{name= \cf7 " "\cf2 \}, \{name= it.title.string \});\
		n.sendMsg(\cf10 '/1/label'\cf2 ++(i+1).asSymbol, name); 0.1.wait; \
		\cf5 //('/1/label'++(i+1).asSymbol + name).postln;\cf2 \
		\});\
	allKnobs.do(\{\cf3 |it, i|\cf2 \
		\cf3 var\cf2  name;\
		if(it.title.string.isNil, \{name= \cf7 " "\cf2 \}, \{name= it.title.string \});\
		n.sendMsg(\cf10 '/1/knoblabel'\cf2 ++(i+1).asSymbol, name); 0.1.wait; \
		\cf5 //('/1/label'++(i+1).asSymbol + name).postln;\cf2 \
		\});\
	sounds.do(\{\cf3 |it, i|\cf2 \
		\cf3 var\cf2  name;\
		if( i < 36, \{\
		if(it.isNil, \{name= \cf7 " "\cf2 \}, \{name= it.basename.removeExtension\});\
		n.sendMsg(\cf10 '/2/label'\cf2 ++(i+1).asSymbol, name); 0.1.wait;\
		\cf5 //('/2/label'++(i+1).asSymbol + name).postln;\cf2 \
		\});\
	\});\
	\}.fork(\cf9 AppClock\cf2 );\
	n.free;\
	\cf5 //("pung"+time+addr.ip+recvPort).postln;\cf2 \
	\}, \cf10 '/ping'\cf2 , \cf4 nil\cf2 );\
\
win= \cf9 Window\cf2 (\cf7 "TouchOSC"\cf2 , \cf9 Rect\cf2 (300, 300, 300, 300))\
.front\
.alwaysOnTop_(\cf4 true\cf2 );\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf5 // REMOVE RESPONDERS (don't forget)\cf2 \
win.onClose= \{\
resp1.do(\{\cf3 |it|\cf2  it.remove\});\
resp2.do(\{\cf3 |it|\cf2  it.remove\});\
\cf5 //resp3.do(\{|it| it.remove\});\cf2 \
\cf5 //resp4.do(\{|it| it.remove\});\cf2 \
resp5.do(\{\cf3 |it|\cf2  it.remove\});\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf9 OSCdef\cf2 (\cf10 \\pingResp\cf2 ).free;\
\};\
\
\};\
\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf5 // ========================= SEQUENCER =========================\cf2 \
sequencer= \{\
	\
\cf3 var\cf2  w, topGrid, gridArray, clockArray, meter, freq;\
\cf3 var\cf2  columns= 16;\
\cf3 var\cf2  boxHeight= 16, boxSpace= 3, topSpace= 50;\
\cf3 var\cf2  length, mute, muteButtons;\
\cf3 var\cf2  randomize, names;\
\cf3 var\cf2  playBut, stopBut, recBut;\
\cf3 var\cf2  t, beat= 1, recSeq, recSeqNoteOn, tapTempoGUI, tapTempoView;\
\cf5 //to remove\cf2 \
\cf3 var\cf2  samples;\
\cf3 var\cf2  colors;\
colors= [\cf9 Color\cf2 .new255(160, 255, 160).alpha_(0.5), \cf9 Color\cf2 .black, \cf9 Color\cf2 .white, \cf9 Color\cf2 .black, \cf9 Color\cf2 .white, \cf9 Color\cf2 .white, \cf9 Color\cf2 .black, \cf9 Color\cf2 .white, \cf9 Color\cf2 .black, \cf9 Color\cf2 .white, \cf9 Color\cf2 .black, \cf9 Color\cf2 .white];\
\
mute= 0!numKeys;\
\
w = \cf9 Window\cf2 .new(\cf7 "Step sequencer"\cf2 , \cf9 Rect\cf2 (10, 500, 800, 760)).front;\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf9 Button\cf2 (w, \cf9 Rect\cf2 (0, 0, 40, 40))\
.states_([[\cf7 "A"\cf2 ],[\cf7 "V"\cf2 ]])\
.action_(\{\cf3 |v|\cf2  if (v.value == 1, \{ w.setInnerExtent(\cf4 nil\cf2 , 50) \}, \{ w.setInnerExtent(\cf4 nil\cf2 , 760) \}) \});\
\
randomize= \cf9 Button\cf2 (w, \cf9 Rect\cf2 (60, 0, 50, 20))\
.canFocus_(\cf4 false\cf2 )\
.states_([[\cf7 "randomize"\cf2 ]])\
.action_(\{\
		numKeys.do(\{\cf3 |i|\cf2 \
10.do(\{gridArray[i].setState_(columns.rand, 0, [0, 0, 0, 0, 1].choose);\}); \cf5 // column, row, state\cf2 \
	\});\
\});\
\
\cf9 EZSlider\cf2 (w,  	\
	\cf9 Rect\cf2 (120, 0, 180, boxHeight),\
	\cf7 "tempo"\cf2 ,	\cf5 // label\cf2 \
	[50, 250, \cf10 \\lin\cf2 , 1, 120, \cf7 "tempo"\cf2 ].asSpec, \cf5 // controlSpec\cf2 \
	\{\cf3 |ez|\cf2  t.clock.tempo_(ez.value/30) \}, \cf5 // action\cf2 \
	120, \cf5 // init value, set from A DICTIONARY\cf2 \
	labelWidth: 30,\
	numberWidth: 30\
	).setColors(\
		\cf4 nil\cf2 , \cf5 //string backgr\cf2 \
		\cf9 Color\cf2 .white, \cf5 //string\cf2 \
		\cf9 Color\cf2 (0.298, 0.298, 0.298, 1.0), \cf5 //slider backgr\cf2 \
		\cf9 Color\cf2 .grey, \cf5 //num backgr\cf2 \
		\cf9 Color\cf2 .white, \cf5 //num clr\cf2 \
		\cf4 nil\cf2 ,\
		\cf4 nil\cf2 ,\
		\cf9 Color\cf2 (0.298, 0.776, 1.0, 1.0) \cf5 //knob clr\cf2 \
);\
\
playBut = \cf9 RoundButton\cf2 ( w, \cf9 Rect\cf2 (310, 0, 50, 20) )\
.states_([[ \cf10 \\play\cf2  ], [\cf10 \\pause\cf2 ]] )\
.action_(\{\cf3 |v|\cf2  if(v.value == 1, \{t.play\}, \{t.pause\}) \});\
\
stopBut = \cf9 RoundButton\cf2 ( w, \cf9 Rect\cf2 (360, 0, 30, 20) )\
.states_([[ \cf10 \\stop\cf2  ]] )\
.action_(\{ t.stop; t.reset; playBut.value= 0; \});\
\
recBut = \cf9 RoundButton\cf2 ( w, \cf9 Rect\cf2 (390, 0, 30, 20) )\
.states_([[ \cf10 \\record\cf2 , \cf9 Color\cf2 .black ],[\cf10 \\record\cf2 , \cf9 Color\cf2 .red]] )\
.action_(\{ if (v.value==1, \{recSeq.value \}, \{ recSeqNoteOn.remove; \}); \});\
\
topGrid = \cf9 BoxGrid\cf2 .new(w, bounds: \cf9 Rect\cf2 (160, 25, 360, boxHeight), columns: columns, rows: 1)\
.setFillMode_(\cf4 true\cf2 )\
.setFillColor_(\cf9 Color\cf2 .red)\
	.setBackgrDrawFunc_(\{\
		16.do(\{\cf3 arg\cf2  i;\
			if((i==0)||(i==4)||(i==8)||(i==12)||(i==16),\{\
			\cf9 GUI\cf2 .pen.fillColor = \cf9 Color\cf2 .new255(60, 60, 60).alpha_(0.5);\
			\},\{\
			\cf9 GUI\cf2 .pen.fillColor = \cf9 Color\cf2 .new255(255, 255, 255).alpha_(0.5);\
			\});\
			\cf9 GUI\cf2 .pen.fillRect(\cf9 Rect\cf2 (1+(i*(360/columns)), 0, 360/columns, 240));\
		\})\
	\});\
\
gridArray = \cf9 Array\cf2 .fill(numKeys, \{\cf3 arg\cf2  i;\
	\cf9 BoxGrid\cf2 .new(w, bounds: \cf9 Rect\cf2 (160, (boxHeight+boxSpace)*((i-numKeys).abs)+topSpace-(boxHeight+boxSpace), 360, boxHeight), columns: columns, rows: 1)\
	.setFillMode_(\cf4 true\cf2 )\
	.setFillColor_(\cf9 Color\cf2 .green)\
	.setBackgrColor_(colors[i.wrap(0, 11)])\
	.setBackgrDrawFunc_(\{\
		16.do(\{\cf3 arg\cf2  i;\
			if((i==0)||(i==4)||(i==8)||(i==12)||(i==16),\{\
			\cf9 GUI\cf2 .pen.fillColor = \cf9 Color\cf2 .new255(60, 60, 60).alpha_(0.5);\
			\},\{\
			\cf9 GUI\cf2 .pen.fillColor = \cf9 Color\cf2 .new255(255, 255, 255).alpha_(0.5);\
			\});\
			\cf9 GUI\cf2 .pen.fillRect(\cf9 Rect\cf2 (1+(i*(360/16)), 0, 360/16, 240));\
		\})\
	\});\
\});\
\
\cf9 EZSlider\cf2 (w, \cf5 // master duration\cf2 \
	\cf9 Rect\cf2 (540, 25, 180, boxHeight),\
				\cf7 "dur"\cf2 ,	\cf5 // label\cf2 \
				\cf4 nil\cf2 , \cf5 // controlSpec\cf2 \
				\{\cf3 |ez|\cf2  length.do(\{\cf3 |it|\cf2  \{it.valueAction= ez.value\}.defer; \});\
				\}, \cf5 // action\cf2 \
				0.3, \cf5 // init value, set from A DICTIONARY\cf2 \
				labelWidth: 30,\
				numberWidth: 25\
				).setColors(\
					\cf4 nil\cf2 , \cf5 //string backgr\cf2 \
					\cf9 Color\cf2 .white, \cf5 //string\cf2 \
					\cf9 Color\cf2 (0.298, 0.298, 0.298, 1.0), \cf5 //slider backgr\cf2 \
					\cf9 Color\cf2 .grey, \cf5 //num backgr\cf2 \
					\cf9 Color\cf2 .white, \cf5 //num clr\cf2 \
					\cf4 nil\cf2 ,\
					\cf4 nil\cf2 ,\
					\cf9 Color\cf2 .red \cf5 //knob clr\cf2 \
					);\
\
length = \cf9 Array\cf2 .fill(numKeys, \{\cf3 arg\cf2  i;\
	\cf9 EZSlider\cf2 (w,  	\cf5 // parent\cf2 \
				\cf9 Rect\cf2 (540, (boxHeight+boxSpace)*((i-numKeys).abs)+topSpace-(boxHeight+boxSpace), 180, boxHeight),\
				\cf7 "dur"\cf2 ,	\cf5 // label\cf2 \
				\cf4 nil\cf2 , \cf5 // controlSpec\cf2 \
				\{\cf3 |ez|\cf2  \cf4 nil\cf2 \
				\}, \cf5 // action\cf2 \
				0.3, \cf5 // init value, set from A DICTIONARY\cf2 \
				labelWidth: 30,\
				numberWidth: 25\
				).setColors(\
					\cf4 nil\cf2 , \cf5 //string backgr\cf2 \
					\cf9 Color\cf2 .white, \cf5 //string\cf2 \
					\cf9 Color\cf2 (0.298, 0.298, 0.298, 1.0), \cf5 //slider backgr\cf2 \
					\cf9 Color\cf2 .grey, \cf5 //num backgr\cf2 \
					\cf9 Color\cf2 .white, \cf5 //num clr\cf2 \
					\cf4 nil\cf2 ,\
					\cf4 nil\cf2 ,\
					\cf9 Color\cf2 (0.298, 0.776, 1.0, 1.0) \cf5 //knob clr\cf2 \
					);\
\});\
\
muteButtons = \cf9 Array\cf2 .fill(numKeys, \{\cf3 arg\cf2  i;\
	\cf9 Button\cf2 (w, \cf9 Rect\cf2 (520, (boxHeight+boxSpace)*((i-numKeys).abs)+topSpace-(boxHeight+boxSpace), 20, 20))\
	.states_([[\cf7 "m"\cf2 , \cf9 Color\cf2 .black, \cf9 Color\cf2 .grey], [\cf7 "m"\cf2 , \cf9 Color\cf2 .black, \cf9 Color\cf2 .red]])\
	.action_(\{\cf3 |v|\cf2  mute[i]= v.value \})\
	.value_(0);\
\});\
\
names= \cf9 Array\cf2 .fill(numKeys, \{\cf3 arg\cf2  i;\
	if(sounds[i].isNil.not, \{\
	\cf9 StaticText\cf2 (w, \cf9 Rect\cf2 (10, (boxHeight+boxSpace)*((i-numKeys).abs)+topSpace-(boxHeight+boxSpace), 150, 20))\
	.string_(sounds[i].basename.removeExtension)\
	\});\
\});\
\
\
t= \cf9 Task\cf2 (\{\
	\cf4 inf\cf2 .do(\{\cf3 |i|\cf2 \
		beat= i%columns;\
\{topGrid.setState_( i%columns, 0, 1)\}.defer;\
\{topGrid.setState_( i%columns, 0, 0)\}.defer(\cf8 thisThread\cf2 .clock.beatDur);\
\
numKeys.do(\{\cf3 arg\cf2  ii;\
if(gridArray[ii].getState(i%16, 0) == 1, \{\
	if(mute[ii].value==0 && sounds[ii].isNil.not, \{\
		\cf5 //playnote.value(nil, ii, ii, nil, nil, length[ii].value);\cf2 \
		playnote.value(\cf4 nil\cf2 , ii, ii, \cf4 nil\cf2 , \cf4 nil\cf2 );\
		\{stopnote.value(ii, ii)\}.defer(length[ii].value);\
	\cf5 //a.play(ii.asSymbol, 0.01, 0, length[ii].value);\cf2 \
	\});\
\});\
\});\
1.wait;\
	\});\
\}, \cf9 TempoClock\cf2 (4));\
\
tapTempoView= \cf9 CompositeView\cf2 (w, \cf9 Rect\cf2 (430, 0, 230, 20));\
tapTempoGUI= \cf9 RedTapTempoGUI\cf2 (t.clock, 4, 3, s, tapTempoView);\
\
recSeq= \{\
	recSeqNoteOn= \cf9 NoteOnResponder\cf2 (\{ \cf3 |src,chan,note,vel|\cf2 \
	\cf3 var\cf2  num, event= \cf4 nil\cf2 ;\
	\cf5 //[src,chan,note,vel].postln;\cf2 \
	note= note-startKey;\
	if(note.inRange(0, (numKeys-1)), \{\
		gridArray[num].setState_(0, beat-1, 1);\
	\},\
	\{\cf7 "key out of range"\cf2 .postln;\});\
	\},\
	midisrc, \cf5 // source\cf2 \
	midichannel \cf5 // channel\cf2 \
	);\
	\
	\};\
\
\
prViewBut.valueAction= 0;\
\
w.onClose = \{tapTempoGUI.close; t.stop; seqIsOpen= \cf4 false\cf2 ; \{recSeqNoteOn.remove\}.try; \};\
\};\
\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf5 // ------- preferences view (setup)\cf2 \
\
preferencesView= \{\
	\cf9 KeyboardPreferences\cf2 .new(thisFilePath+/+keyboardName);\
	\};\
\
\
\
\cf5 // -----  bend responder\cf2 \
\
	bender = \cf9 BendResponder\cf2 (\{ \cf3 |src,chan,value|\cf2 \
		\cf5 //[src,chan,value].postln;\cf2 \
		\cf5 //if(bendfreeze == 0, \{\cf2 \
			value= value.linlin(0, 16383, 0.0, 2.0).round(0.001).clip(0.1, 2.0);\
			if( masterprop[\cf10 \\kyPitch\cf2 ] == 1, \{ a.speed_(value); \
				oscRoutines.do(\{\cf3 |it|\cf2  if(it.size > 0, \{\
					it.do(\{\cf3 |oscplayer|\cf2  oscplayer.clock.tempo_(value); \});\
					\}); \});\
				\});\
			if( masterprop[\cf10 \\slPitch\cf2 ] == 1, \{ sliders.do(\{\cf3 |it|\cf2  it.setPitch(value); \}); \});\
			if( masterprop[\cf10 \\knPitch\cf2 ] == 1, \{ allKnobs.do(\{\cf3 |it|\cf2  it.setPitch(value); \}); \});\
			bend= value;\
		\cf5 //\});\cf2 \
		\},\
		src: midisrcindex\
	);\
\
\cf5 // -----  mod wheel responder\cf2 \
\cf5 /*\
\
modwheel = CCResponder(\{ |src,chan,num, value|\
		//[src,chan,value].postln;\
\
			value= value.linlin(0, 127, 0.0, 1.0).round(0.001);\
			if( masterprop[\\kyPitch] == 1, \{ a.speed_(value); \
				oscRoutines.do(\{|it| if(it.size > 0, \{\
					it.do(\{|oscplayer| oscplayer.clock.tempo_(value); \});\
					\}); \});\
				\});\
			if( masterprop[\\slPitch] == 1, \{ sliders.do(\{|it| it.setPitch(value); \}); \});\
			if( masterprop[\\knPitch] == 1, \{ allKnobs.do(\{|it| it.setPitch(value); \}); \});\
			bend= value;\
		//\});\
		\},\
		src: midisrcindex; chan:0; num:1; \
	);\
\
*/\cf2 \
\
\
\
\cf5 // ----- prog change responder\cf2 \
\cf5 /*\
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
*/\cf2 \
\
\
\
remoteOSCresponder= \cf9 OSCresponderNode\cf2 (\cf4 nil\cf2 , keyboardName.asSymbol, \{ \cf3 |t, r, msg|\cf2 \
\cf3 var\cf2  num= msg[2], value= msg[3];\
switch (msg[1]) \
	\{\cf10 \\noteon\cf2 \} \{ \
		if(num.inRange(0, (numKeys-1)), \{\
			playnote.value(\cf4 nil\cf2 , sounds[num], num, \cf4 nil\cf2 );\
		\});\
		\}\
	\{\cf10 \\noteoff\cf2 \} \{\
		if(num.inRange(0, (numKeys-1)), \{\
			stopnote.value(sounds[num], num); \
		\});\
		\}\
	\
	\{\cf10 \\knob\cf2 \} \{\
		if(num.inRange(0, (knobsCC.size-1)), \{\
			allKnobs[num].setVal((value*(127.reciprocal)).round(0.001));\
		\});\
		\}\
	\{\cf10 \\slider\cf2 \} \{\
		if(num.inRange(0, (slidersCC.size-1)), \{\
			sliders[num].setVal((value*(127.reciprocal)).round(0.001));\
		\});\
		\};\
\}).add;\
\
\
\
\cf5 // =========== ON CLOSE ==================\cf2 \
\
w.front;\
\
w.onClose= \{\
	\cf6 ~openSamplers\cf2 [keyboardName.asSymbol]= \cf4 true\cf2 ;\
	\cf6 ~mixerChans\cf2 .removeAt(keyboardName);\
	a.free;\
	\{on.stop; off.stop\}.try;\
	\cf9 MIDIIn\cf2 .disconnectByUID(0, midisrc);\
	responders1.size.do(\{\cf3 |i|\cf2  responders1[i].remove\});\
	responders2.size.do(\{\cf3 |i|\cf2  responders2[i].remove\});\
	effectGroup.free;\
	bender.remove;\
	\
	noteon.remove;\
	noteoff.remove;\
	\
	if(p.isNil.not, \{p.close\}); \cf5 // close arduino REMOVE !\cf2 \
	\
	if(sendWinOpen.isNil.not, \{sendWinOpen.close\});\
	\
	if(\cf6 ~openSamplers\cf2 .values.includes(\cf4 true\cf2 ).not, \{\cf6 ~dmx\cf2 = \cf4 nil\cf2 ;\}); \cf5 // dmx to nil. enough?\cf2 \
	\cf6 ~preferencesWindows\cf2 .put(\cf10 \\keyboardName\cf2 , \cf4 false\cf2 );\
	if(\cf9 MultiTouchPad\cf2 .isRunning, \{\cf9 MultiTouchPad\cf2 .stop;\});\
	\{panSynth.free\}.try;\
	\
	if (outputButtonResponders.isNil.not, \{outputButtonResponders.do(\{\cf3 |it|\cf2  it.free\}); \});\
	remoteOSCresponder.remove;\
\};\
\
\
\
\
\cf5 //============== SYNTHDEFS ==================\cf2 \
\
	\cf9 SynthDef\cf2 (\cf10 \\gpLooperMono\cf2 , \{\
		\cf3 arg\cf2  bufnum=0, a= 0.01, s=1, r=0.1, rate= 1, amp=1, gate= 1, pan= 0, out= 0;\
		\cf3 var\cf2  env, signal;\
		env= \cf9 EnvGen\cf2 .kr(\cf9 Env\cf2 .asr(a, s, r), gate, doneAction:2);\
		signal= \cf9 PlayBuf\cf2 .ar(1, bufnum, rate * \cf9 BufRateScale\cf2 .kr(bufnum), loop:1)*amp;\
		\cf9 Out\cf2 .ar(out, \cf9 Pan2\cf2 .ar(signal * env, pan))\
	\}).send(s);\
	\
	\cf9 SynthDef\cf2 (\cf10 \\gpLooperStereo\cf2 , \{\
		\cf3 arg\cf2  bufnum=0, a= 0.01, s=1, r=0.1, rate= 1, amp=1, gate= 1, pan= 0, out= 0;\
		\cf3 var\cf2  env, signal;\
		env= \cf9 EnvGen\cf2 .kr(\cf9 Env\cf2 .asr(a, s, r), gate, doneAction:2);\
		signal= \cf9 PlayBuf\cf2 .ar(2, bufnum, rate * \cf9 BufRateScale\cf2 .kr(bufnum), loop:1)*amp;\
		\cf9 Out\cf2 .ar(out, \cf9 Balance2\cf2 .ar(signal[0], signal[1], pan) * env)\
	\}).send(s);\
	\
	\cf9 SynthDef\cf2 (\cf10 \\diskinMono\cf2 , \{ \cf3 arg\cf2  bufnum = 0, out= 0, a= 0.01, s=1, r=0.1, rate= 1, amp=1, gate= 1, pan= 0, synthID= 33;\
		\cf3 var\cf2  signal, env;\
		env= \cf9 EnvGen\cf2 .kr(\cf9 Env\cf2 .asr(a, s, r), gate, doneAction:2);\
		signal= \cf9 VDiskIn\cf2 .ar(1, bufnum, rate* \cf9 BufRateScale\cf2 .kr(bufnum), 1, synthID) * amp;\
		\cf9 Out\cf2 .ar(out, \cf9 Pan2\cf2 .ar(signal * env, pan));\
	\}).send(s);\
	\
	\cf9 SynthDef\cf2 (\cf10 \\diskinStereo\cf2 , \{ \cf3 arg\cf2  bufnum = 0, out= 0, a= 0.01, s=1, r=0.1, rate= 1, amp=1, gate= 1, pan= 0, synthID= 3;\
		\cf3 var\cf2  signal, env;\
		env= \cf9 EnvGen\cf2 .kr(\cf9 Env\cf2 .asr(a, s, r), gate, doneAction:2);\
		signal= \cf9 VDiskIn\cf2 .ar(2, bufnum, rate* \cf9 BufRateScale\cf2 .kr(bufnum), 1, synthID) * amp;\
		\cf9 Out\cf2 .ar(out, \cf9 Balance2\cf2 .ar(signal[0], signal[1], pan) * env);\
	\}).send(s);\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf9 SynthDef\cf2 (\cf10 \\FreeVerb2x2\cf2 , \{\cf3 |out= 0, mix = 0.25, room = 0.15, damp = 0.5, amp = 1.0|\cf2 \
	\cf3 var\cf2  signal;\
	signal = \cf9 In\cf2 .ar(out, 2);\
	\cf9 ReplaceOut\cf2 .ar(out,\
		\cf9 FreeVerb2\cf2 .ar( \cf5 // FreeVerb2 - true stereo UGen\cf2 \
			signal[0], \cf5 // Left channel\cf2 \
			signal[1], \cf5 // Right Channel\cf2 \
			mix, room, damp, amp)); \cf5 // same params as FreeVerb 1 chn version\cf2 \
\}).add;\
\
\cf9 SynthDef\cf2 (\cf10 \\panningHack\cf2 , \{\cf3 |out= 0, amp = 1.0, pan= 0|\cf2 \
	\cf3 var\cf2  signal;\
	signal = \cf9 In\cf2 .ar(out, 2);\
	\cf9 ReplaceOut\cf2 .ar(out, \cf9 Balance2\cf2 .ar(signal[0], signal[1], pan)*amp);\
\}).add;\
\
\
s.sync;\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf5 // Start some synths\cf2 \
\cf5 /*\
if (properties[key][10].isNil.not && builtin, \{out= properties[key][10] \}, \{\
			if (sounds[key].contains(folderRouting), //speech\
				\{ "speaking".postln; out= speechout; \}, \{ out= output;  \});\
			\});\
			*/\cf2 \
panSynth= \cf9 Synth\cf2 .tail(s, \cf10 \\panningHack\cf2 , [\cf10 \\out\cf2 , 0]);\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf6 ~mixerChans\cf2 .add(keyboardName -> panSynth);\
\
\
\};\
);\
\
\
\
\
}