{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf600
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;\red0\green0\blue255;\red51\green51\blue191;
\red255\green102\blue0;\red0\green0\blue191;\red96\green96\blue96;\red191\green0\blue0;\red0\green115\blue0;
}
{\*\expandedcolortbl;;\csgenericrgb\c0\c0\c0;\csgenericrgb\c0\c0\c100000;\csgenericrgb\c20000\c20000\c75000;
\csgenericrgb\c100000\c40000\c0;\csgenericrgb\c0\c0\c75000;\csgenericrgb\c37500\c37500\c37500;\csgenericrgb\c75000\c0\c0;\csgenericrgb\c0\c45000\c0;
}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 (\
\cf3 var\cf2  m;\
\cf3 var\cf2  lastTouched, learn= \cf4 false\cf2 ;\
\cf3 var\cf2  setupView;\
\cf3 var\cf2  midi, midistring, midimenuitems, midimenu, midiIn, currentMidi, midiUID, midisrcindex;\
\cf3 var\cf2  midiSelect, inputString, learnResponder, savePath;\
\cf3 var\cf2  midiDeviceName, midiDevicePort;\
\
\
\cf5 ~mixerWindow\cf2 = \cf6 Window\cf2 (\cf7 "MIXER"\cf2 , \cf6 Rect\cf2 (0, 0, 85*\cf5 ~mixerChans\cf2 .size, 370)).front;\
\
\cf8 //~mixerWindow.view.decorator=FlowLayout(~mixerWindow.view.bounds);\cf2 \
\
\cf8 //~mixerChans.add(keyboardName -> [panSynth, panKnob, volumeSlider]);\cf2 \
\cf8 //~mixerMap.put(num, [ key, \\pan or \\vol ]);\cf2 \
\cf8 //~chanStrip ( \\key, \\pan or \\vol )\cf2 \
\
\cf8 //what order do they come? a way to set this? Dictionary\cf2 \
\
savePath= \cf6 String\cf2 .scDir++\cf7 "/MIXERSAVES/mixersave"\cf2 ;\
\
\cf5 ~chanStrip\cf2 = \cf6 MultiLevelIdentityDictionary\cf2 .new;\
if (\cf5 ~mixerMap\cf2 .isNil, \{ \cf5 ~mixerMap\cf2 = (); \});\
\
\cf5 ~mixerChans\cf2 .keysValuesDo(\{\cf3 |key, val, i|\cf2 \
	\cf8 // PAN KNOB\cf2 \
	\cf5 ~chanStrip\cf2 .put(key, \cf9 \\pan\cf2 , \cf4 nil\cf2 );\
	\cf5 ~chanStrip\cf2 [key][\cf9 \\pan\cf2 ]= \cf6 Knob\cf2 (\cf5 ~mixerWindow\cf2 , \cf6 Rect\cf2 (5+(85*(\cf5 ~mixerChans\cf2 .size-1)), 0, 75, 50));\
	\cf5 ~chanStrip\cf2 [key][\cf9 \\pan\cf2 ].centered= \cf4 true\cf2 ;\
	\cf8 //g.action= \{|v| val.set(\\pan, (v.value*2)-1); ((v.value*2)-1).postln\};\cf2 \
	\cf5 ~chanStrip\cf2 [key][\cf9 \\pan\cf2 ].action= \{\cf3 |v|\cf2  \
		val[0].set(\cf9 \\pan\cf2 , (v.value*2)-1);\
		\{ val[1].value= v.value \}.defer;\
		lastTouched= [key, \cf9 \\pan\cf2 , v];\
		\cf8 //((v.value*2)-1).postln;\cf2 \
		\};\
	\cf5 ~chanStrip\cf2 [key][\cf9 \\pan\cf2 ].value= 0.5;\
\
	\cf8 // VOL SLIDER\cf2 \
	\cf5 ~chanStrip\cf2 .put(key, \cf9 \\vol\cf2 , \cf4 nil\cf2 );\
	\cf5 ~chanStrip\cf2 [key][\cf9 \\vol\cf2 ]=\cf6 EZSlider\cf2 (\cf5 ~mixerWindow\cf2 , \cf6 Rect\cf2 (5+(85*(\cf5 ~mixerChans\cf2 .size-1)), 50, 75, 280), \
		key, \cf8 //name\cf2 \
		\cf4 nil\cf2 ,\
		unitWidth:0, \
		numberWidth:60,\
		layout:\cf9 \\vert\cf2 );\
		\
	\cf5 ~chanStrip\cf2 [key][\cf9 \\vol\cf2 ].setColors(\cf6 Color\cf2 .grey,\cf6 Color\cf2 .white, \cf6 Color\cf2 .grey(0.7),\cf6 Color\cf2 .grey, \cf6 Color\cf2 .white, \cf6 Color\cf2 .yellow,\cf4 nil\cf2 ,\cf4 nil\cf2 , \cf6 Color\cf2 .grey(0.7));\
	\cf5 ~chanStrip\cf2 [key][\cf9 \\vol\cf2 ].font_(\cf6 Font\cf2 (\cf7 "Helvetica"\cf2 ,10));\
	\cf5 ~chanStrip\cf2 [key][\cf9 \\vol\cf2 ].action= \{\cf3 |v|\cf2  \
		val[0].set(\cf9 \\amp\cf2 , v.value);\
		\{ val[2].value= v.value \}.defer;\
		lastTouched= [key, \cf9 \\vol\cf2 , v];\
		\cf8 //v.value.postln;\cf2 \
		\};\
	\cf5 ~chanStrip\cf2 [key][\cf9 \\vol\cf2 ].value= 1;\
\});\
\
\cf6 Button\cf2 (\cf5 ~mixerWindow\cf2 , \cf6 Rect\cf2 (5, 335, 75, 10))\
.canFocus_(\cf4 false\cf2 )\
.states_([[\cf7 "setup"\cf2 , \cf6 Color\cf2 .white, \cf6 Color\cf2 .black], [\cf7 "finish"\cf2 , \cf6 Color\cf2 .white, \cf6 Color\cf2 .black]])\
.font_(\cf6 Font\cf2 .new(\cf7 "Helvetica"\cf2 , 10))\
.action_(\{\cf3 |v|\cf2 \
		if(v.value== 1, \{\
		if (\cf5 ~mixerWindow\cf2 .view.bounds.width < 500, \{ \
			\cf5 ~mixerWindow\cf2 .setInnerExtent(500, 370); \});\
		setupView= \cf6 CompositeView\cf2 (\cf5 ~mixerWindow\cf2 , \cf6 Rect\cf2 (85, 335, 400, 20)).background_(\cf6 Color\cf2 .blue.alpha_(0.2));\
		\
		\cf6 StaticText\cf2 (setupView, \cf6 Rect\cf2 (0, 0, 100, 20)).string_(\cf7 "Midi:"\cf2 );\
\
midi= \cf6 MIDIClient\cf2 .sources;\
midimenuitems= midi.collect(\{\cf3 |it|\cf2  (it.asString.replace(\cf7 "MIDIEndPoint"\cf2 , \cf7 ""\cf2 ).drop(-1).drop(1)).tr($(,$[).tr($),$]); \});\
\
midimenuitems= [\cf7 "select midi input..."\cf2 ]++midimenuitems;\
midimenuitems.postln;\
\
midimenu= \cf6 PopUpMenu\cf2 (setupView, \cf6 Rect\cf2 (40, 0, 200, 20))\
.items_(midimenuitems)\
.canFocus_(\cf4 false\cf2 )\
.action_(\{\cf3 |v|\cf2 \
	if (v.value == 0, \{\
			midiIn= \cf4 nil\cf2 ;\
			currentMidi.string= \cf7 "no input"\cf2 ;\
			\}, \{\
			midiIn= [midi[v.value-1].device.asString, midi[v.value-1].name.asString];\
			midiSelect.value(midiIn[0], midiIn[1]);\
			midiUID.postln;\
			currentMidi.string= v.items[v.value];\
			midiIn.postln;\
		\});\
\}); \
\
currentMidi= \cf6 StaticText\cf2 (setupView, \cf6 Rect\cf2 (245, 0, 100, 20))\
		.string_(\cf7 "no input"\cf2 )\
		.align_(\cf9 \\center\cf2 )\
		.font_(\cf6 Font\cf2 .new(\cf7 "Helvetica"\cf2 , 10))\
		.background_(\cf6 Color\cf2 .grey.alpha_(0.3));\
		\
\cf6 Button\cf2 (setupView, \cf6 Rect\cf2 (350, 0, 40, 20))\
.canFocus_(\cf4 false\cf2 )\
.states_([[\cf7 "learn"\cf2 , \cf6 Color\cf2 .green, \cf6 Color\cf2 .black], [\cf7 "stop"\cf2 , \cf6 Color\cf2 .black, \cf6 Color\cf2 .red]])\
.action_(\{\cf3 |v|\cf2 \
	if(v.value == 1, \{\
		learn= \cf4 true\cf2 ;\
		\cf8 //make learn responder\cf2 \
		if(midiUID.isNil.not, \{\
			\cf5 ~mixerResponder\cf2 .free;\
			\cf6 MIDIIn\cf2 .connectByUID(0, midiUID);\
			learnResponder= \cf6 MIDIFunc\cf2 .cc(\{\cf3 |val, num, chan|\cf2  \
			[val, num, chan].postln;\
			if (lastTouched.isNil.not, \{ \
				\{lastTouched[2].value= (val/127);\}.defer;\
				\cf8 // put values in dict\cf2 \
				\cf5 ~mixerMap\cf2 .put(num, [ lastTouched[0], lastTouched[1] ]);\
				\cf8 //~mixerMap.put(num, [ key, \\pan or \\vol ]);\cf2 \
				\cf8 //\cf2 \
			\});\
			\}, srcID: midiUID); \cf8 // maybe specify channel...\cf2 \
		\});\
	\},\{\
		\cf8 //close learn responder and save\cf2 \
		learnResponder.free;\
		\cf6 MIDIIn\cf2 .disconnectByUID(0, midiUID);\
		\cf6 StaticText\cf2 (\cf5 ~mixerWindow\cf2 , \cf6 Rect\cf2 (100, 100, 200, 80))\
		.string_(\cf7 "Restart SamplerCentral for changes to have effect"\cf2 )\
		.background_(\cf6 Color\cf2 .green);\
		[midiDeviceName, midiDevicePort, midiUID, \cf5 ~mixerMap\cf2 ].writeArchive(savePath);\
	\});\
\});\
\
\cf8 // ====== END IF\cf2 \
		\}, \{\
		\cf5 ~mixerWindow\cf2 .setInnerExtent(85*\cf5 ~mixerChans\cf2 .size, 370);\
		setupView.remove;\
	\});\
	\
\});\
\
if (\cf5 ~mixerController\cf2 .isNil, \{\
inputString= \cf6 StaticText\cf2 (\cf5 ~mixerWindow\cf2 , \cf6 Rect\cf2 (5, 350, 75, 10))\
.string_(\cf7 "no input"\cf2 )\
.font_(\cf6 Font\cf2 .new(\cf7 "Helvetica"\cf2 , 10))\
.background_(\cf6 Color\cf2 .red.alpha_(0.3));\
\},\{\
inputString= \cf6 StaticText\cf2 (\cf5 ~mixerWindow\cf2 , \cf6 Rect\cf2 (5, 350, 75, 10))\
.string_(\cf5 ~mixerController\cf2 )\
.font_(\cf6 Font\cf2 .new(\cf7 "Helvetica"\cf2 , 10))\
.background_(\cf6 Color\cf2 .green.alpha_(0.3));	\
\});\
\
\
\
midiSelect= \{\cf3 |midiName, midiPort|\cf2 \
\cf6 MIDIClient\cf2 .sources.do(\{ \cf3 |midiSource, i|\cf2 \
			\cf8 //("it device:"+midiSource.device.asString).postln;\cf2 \
			\cf8 //(midiSource).postln;\cf2 \
			\
			if((midiSource.device).contains(midiName) and: \{(midiSource.name).contains(midiPort) \}, \{\
				midiUID= midiSource.uid; \
				midisrcindex= i;\
				midiUID.postln;\
				i.postln;\
				midiSource.name.postln;\
				midiDeviceName= midiName;\
				midiDevicePort= midiPort;\
				(\cf7 "MIDI IN DEVICE:"\cf2 +midiName+midiPort).postln;\
				\cf8 //(it.uid).postln;\cf2 \
				\});\
\});\
\};\
\
\
\cf5 ~mixerOpen\cf2 = \cf4 true\cf2 ;\
\
\cf8 //midi binding\cf2 \
\
\cf8 //m= MIDIIn\cf2 \
\
\cf8 // MIDIFunc.cc(\{\}, cc number, chan uid);\cf2 \
\
\cf8 // save in global preferences\cf2 \
\
\cf5 ~mixerWindow\cf2 .onClose= \{\
	\cf5 ~mixerOpen\cf2 = \cf4 false\cf2 \};\
)}