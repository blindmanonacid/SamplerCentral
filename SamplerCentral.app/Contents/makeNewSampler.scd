{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf600
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;\red0\green0\blue255;\red255\green102\blue0;
\red51\green51\blue191;\red102\green102\blue191;\red96\green96\blue96;\red191\green0\blue0;\red0\green0\blue191;
}
{\*\expandedcolortbl;;\csgenericrgb\c0\c0\c0;\csgenericrgb\c0\c0\c100000;\csgenericrgb\c100000\c40000\c0;
\csgenericrgb\c20000\c20000\c75000;\csgenericrgb\c40000\c40000\c75000;\csgenericrgb\c37500\c37500\c37500;\csgenericrgb\c75000\c0\c0;\csgenericrgb\c0\c0\c75000;
}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 (\
\cf3 var\cf2  w, name, numberKeys, numKeysView, numFadersView, numKnobsView, numSlidersView;\
\cf3 var\cf2  knobs, learnKnobs, numberOfKnobs, knobsCCArray;\
\cf3 var\cf2  sliders, learnSliders, numberOfSliders, slidersCCArray;\
\cf3 var\cf2  startKey;\
\cf3 var\cf2  c, cc, noteResponder;\
\cf3 var\cf2  midi, midimenu, midimenuitems, midiDevice, midiPortName, midistring;\
\cf3 var\cf2  backgroundColor;\
\cf3 var\cf2  settings, writeSettings;\
\cf3 var\cf2  thisFilePath, settingsPath, documentPath;\
\cf3 var\cf2  preferencesPath;\
\cf3 var\cf2  knobsOK, slidersOK;\
\cf3 var\cf2  savefilePath, backupfilePath;\
\
\cf4 ~makeNewWindowOpen\cf2 = \cf5 true\cf2 ;\
\
thisFilePath= (\cf6 thisProcess\cf2 .nowExecutingPath.standardizePath).dirname.standardizePath;\
settingsPath= (thisFilePath++\cf7 "/"\cf2 ++\cf7 "Resources/SETTINGS/"\cf2 ).standardizePath;\
documentPath= (thisFilePath++\cf7 "/"\cf2 ++\cf7 "Resources/SAMPLERS/"\cf2 ).standardizePath;\
\cf8 //savefilePath= (thisFilePath++"/"++"Resources/SAVEFILES/"++name.string).standardizePath;\cf2 \
backupfilePath= (savefilePath++\cf7 "/_backup"\cf2 );\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf2 backgroundColor= Color.new(0, 0, 1);\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf2 \
\
\cf8 //[1, 2, 3].writeArchive(settingsPath++"uouo1");\cf2 \
\cf8 //[1, 2, 3].writeArchive("/Users/martin/scwork/samplerProject/Sampler Central.app/Contents/Resources/SETTINGS/"++"uouo");\cf2 \
\
\cf8 //settingsPath= Document.current.path.dirname++"/"++"Resources/SETTINGS/";\cf2 \
\cf8 //documentPath= Document.current.path.dirname++"/"++"Resources/SAMPLERS/";\cf2 \
\
w= \cf9 Window\cf2 (\cf7 "setup new keyboard"\cf2 , \cf9 Rect\cf2 (0, 0, 400, 560));\
\
\cf8 //midi connect\cf2 \
\cf9 MIDIClient\cf2 .init;\
\cf9 MIDIIn\cf2 .connectAll;\
\
\cf9 CompositeView\cf2 (w, \cf9 Rect\cf2 (10, 10, w.bounds.width-20, w.bounds.height-20))\
.background_(\cf9 Color\cf2 (0.76119402985075, 0.76119402985075, 0.76119402985075, 1.0));\
\
\cf8 //keyboard name\cf2 \
\cf9 StaticText\cf2 (w, \cf9 Rect\cf2 (20, 50, 100, 20))\
.string_(\cf7 "Name:"\cf2 );\
name= \cf9 TextView\cf2 (w, \cf9 Rect\cf2 (120, 50, 100, 20))\
.font_(\cf9 Font\cf2 (\cf7 "Helvetica"\cf2 , 12));\
\
\cf8 //number of keys\cf2 \
\cf9 StaticText\cf2 (w, \cf9 Rect\cf2 (20, 80, 100, 20))\
.string_(\cf7 "Number of keys:"\cf2 );\
numKeysView= \cf9 NumberBox\cf2 (w, \cf9 Rect\cf2 (120, 80, 30, 20))\
.step_(12)\
.clipLo_(13)\
.clipHi_(49);\
\
\
\cf8 //number of knobs\cf2 \
\cf9 StaticText\cf2 (w, \cf9 Rect\cf2 (20, 110, 100, 20))\
.string_(\cf7 "Number of knobs:"\cf2 );\
numKnobsView= \cf9 NumberBox\cf2 (w, \cf9 Rect\cf2 (120, 110, 30, 20)).action_(\{\cf3 |v|\cf2  numberOfKnobs= v.value\});\
\
\cf8 //number of sliders\cf2 \
\cf9 StaticText\cf2 (w, \cf9 Rect\cf2 (20, 140, 100, 20))\
.string_(\cf7 "Number of sliders:"\cf2 );\
numSlidersView= \cf9 NumberBox\cf2 (w, \cf9 Rect\cf2 (120, 140, 30, 20)).action_(\{\cf3 |v|\cf2  numberOfSliders= v.value\});\
\
knobsOK= \cf9 StaticText\cf2 (w, \cf9 Rect\cf2 (100, 170, 150, 20)).string_(\cf7 ""\cf2 );\
\
\cf9 Button\cf2 (w, \cf9 Rect\cf2 (20, 170, 70, 20))\
.states_([[\cf7 "set knobs"\cf2 ], [\cf7 "ok"\cf2 ]])\
.action_(\{\
	\cf3 |v|\cf2 \
	if (v.value == 1, \{learnKnobs.value; knobsOK.string_(\cf7 ""\cf2 ); \}, \{\
		c.remove; knobs.do(\{\cf3 |it|\cf2  it.remove; \}); w.refresh; \
		if(knobsCCArray.size == numberOfKnobs, \{\
			knobsOK.string_(\cf7 "OK!"\cf2 );\
			\},\{\
			knobsOK.string_(\cf7 "not enough input.."\cf2 );\
			\});\
		\});\
	\});\
\
\
learnKnobs= \{\
	\cf3 var\cf2  ccArray= [];\
	numberOfKnobs= numKnobsView.value.asInteger;\
	knobs= \cf9 Array\cf2 .newClear(numberOfKnobs);\
	\{\
	numberOfKnobs.do(\{\cf3 |it, i|\cf2 \
		knobs[i]= \cf9 Knob\cf2 (w, \cf9 Rect\cf2 (10+(30*i), 200, 20, 20));\
	\});\
	\}.defer;\
	\
	c = \cf9 CCResponder\cf2 (\{ \cf3 |src,chan,num,value|\cf2 \
		\cf8 //[src,chan,num].postln;\cf2 \
		\
		if (ccArray.indexOf(num).isNil, \{ \
			if (ccArray.size >= numberOfKnobs, \{\cf7 "all knobs filled!"\cf2 .postln; knobsCCArray= ccArray;\}, \{\
				ccArray= ccArray.add(num);\});\
			\}, \{\
				if (ccArray.size >= numberOfKnobs, \{\cf7 "all knobs filled!"\cf2 .postln; knobsCCArray= ccArray;\});\
					\{knobs[(ccArray.indexOf(num))].value= (value/127)\}.defer;\
		\});\
		ccArray.postln;\
		\});\
\
	w.refresh;\
	\};\
\
slidersOK= \cf9 StaticText\cf2 (w, \cf9 Rect\cf2 (100, 230, 150, 20));\
\
\cf9 Button\cf2 (w, \cf9 Rect\cf2 (20, 230, 70, 20))\
.states_([[\cf7 "set sliders"\cf2 ], [\cf7 "ok"\cf2 ]])\
.action_(\{\
	\cf3 |v|\cf2 \
	if (v.value == 1, \{learnSliders.value; slidersOK.string_(\cf7 ""\cf2 ); \}, \{\
		cc.remove; sliders.do(\{\cf3 |it|\cf2  it.remove; \}); w.refresh;\
		if(slidersCCArray.size == numberOfSliders, \{\
			slidersOK.string_(\cf7 "OK!"\cf2 );\
			\},\{\
			slidersOK.string_(\cf7 "not enough input.."\cf2 );\
			\});\
		\});\
	\});\
\
\
learnSliders= \{\
	\cf3 var\cf2  ccArray= [];\
	numberOfSliders= numSlidersView.value.asInteger;\
	sliders= \cf9 Array\cf2 .newClear(numberOfSliders);\
	\{\
	numberOfSliders.do(\{\cf3 |it, i|\cf2 \
		sliders[i]= \cf9 Slider\cf2 (w, \cf9 Rect\cf2 (20+(30*i), 260, 20, 40));\
	\});\
	\}.defer;\
	\
	cc = \cf9 CCResponder\cf2 (\{ \cf3 |src,chan,num,value|\cf2 \
		\cf8 //[src,chan,num].postln;\cf2 \
		\
		if (ccArray.indexOf(num).isNil, \{ \
			if (ccArray.size >= numberOfSliders, \{\cf7 "all sliders filled!"\cf2 .postln; slidersCCArray= ccArray;\}, \{\
				ccArray= ccArray.add(num);\});\
			\}, \{\
				if (ccArray.size >= numberOfSliders, \{\cf7 "all sliders filled!"\cf2 .postln; slidersCCArray= ccArray;\});\
					\{sliders[(ccArray.indexOf(num))].value= (value/127)\}.defer;\
		\});\
		ccArray.postln;\
		\});\
\
	w.refresh;\
	\};\
\
\
\cf8 //start key\cf2 \
\cf9 StaticText\cf2 (w, \cf9 Rect\cf2 (20, 310, 220, 20))\
.string_(\cf7 "Push lowest key on keyboard:"\cf2 );\
startKey= \cf9 NumberBox\cf2 (w, \cf9 Rect\cf2 (190, 310, 30, 20))\
.action_(\{\
	\cf3 |v|\cf2 \
	\
\});\
\
\cf9 Button\cf2 (w, \cf9 Rect\cf2 (230, 310, 70, 20))\
.states_([[\cf7 "edit"\cf2 ], [\cf7 "ok"\cf2 ]])\
.action_(\{\
	\cf3 |v|\cf2 \
	if (v.value == 1, \{\
			noteResponder = \cf9 NoteOnResponder\cf2 (\{ \cf3 |src,chan,note,vel|\cf2 \
			[src,chan,note,vel].postln;\
			\{startKey.value= note\}.defer;\
		\});\
		\}, \{\
			noteResponder.remove;\
		\});\
	\});\
\
\cf9 StaticText\cf2 (w, \cf9 Rect\cf2 (20, 340, 100, 20)).string_(\cf7 "MIDI Input:"\cf2 );\
\
midistring= \cf9 StaticText\cf2 (w, \cf9 Rect\cf2 (250, 360, 60, 20)).string_(\cf7 ""\cf2 );\
\
midi= \cf9 MIDIClient\cf2 .sources;\
\cf8 //midimenuitems= midi.size.collect(\{|i|midi[i].asString.replace("MIDIEndPoint", "").drop(-1).drop(1); \});\cf2 \
midimenuitems= midi.collect(\{\cf3 |it|\cf2  (it.asString.replace(\cf7 "MIDIEndPoint"\cf2 , \cf7 ""\cf2 ).drop(-1).drop(1)).tr($(,$[).tr($),$]); \});\
\
midimenuitems= [\cf7 "select midi input..."\cf2 ]++midimenuitems;\
midimenuitems.postln;\
\cf9 PopUpMenu\cf2 (w, \cf9 Rect\cf2 (20, 360, 220, 20))\
.items_(midimenuitems)\
.action_(\{ \cf3 |v|\cf2 \
if (v.value > 0, \{\
	v.items[v.value].postln;\
	midiDevice= midi[v.value-1].device.postln;\
	midiPortName= midi[v.value-1].name.postln;\
	midistring.string_(\cf7 "OK"\cf2 ).stringColor_(\cf9 Color\cf2 .green);\
	\},\{\
		midistring.string_(\cf7 "!"\cf2 ).stringColor_(\cf9 Color\cf2 .red);\
	\});\
\});\
\
if(midimenu.value == 0, \{ midistring.string_(\cf7 "!"\cf2 ).stringColor_(\cf9 Color\cf2 .red); \});\
\
\
\
\cf9 StaticText\cf2 (w, \cf9 Rect\cf2 (20, 390, 200, 20))\
.string_(\cf7 "Select background color:"\cf2 );\
\cf8 //ColorPicker.hsvMini(w, Rect(200, 390, 50, 50), Color.blue, \{|clr| backgroundColor= clr; \}, true);\cf2 \
\cf9 ColorPicker\cf2 .new(w, \cf9 Point\cf2 (10, 410), \cf9 Color\cf2 .blue, \{\cf3 |clr|\cf2  backgroundColor= clr; \}, \cf5 true\cf2 );\
\
\
\
writeSettings= \{\
	\cf3 var\cf2  preferences, knobsSave, slidersSave;\
	(settingsPath++name.string++\cf7 "SETUP"\cf2 ;).postln;\
	\
	savefilePath= (thisFilePath+/+\cf7 "Resources/SAVEFILES/"\cf2 ++name.string).standardizePath;\
	backupfilePath= (savefilePath++\cf7 "/_backup"\cf2 );\
	preferencesPath= (thisFilePath+/+\cf7 "Resources/PREFERENCES/"\cf2 ++name.string).standardizePath;\
	\
	\
	\cf8 //if( (knobsCCArray++slidersCCArray++numKeysView.value++startKey++name).indexOf(nil).isNil, \{\cf2 \
	if( [numKeysView.value, startKey, name].indexOf(\cf5 nil\cf2 ).isNil, \{\
	savefilePath.makeDir;\
	backupfilePath.makeDir;\
	preferencesPath.makeDir;\
\
	settings= [numKeysView.value, startKey.value, knobsCCArray, slidersCCArray, name.string, [[midiDevice, midiPortName], \cf5 nil\cf2 , \cf5 nil\cf2 ], [\cf5 nil\cf2 , \cf5 nil\cf2 , \cf5 nil\cf2 ], backgroundColor];\
	settings.writeArchive(settingsPath++name.string++\cf7 "SETUP"\cf2 ; );\
	\
	preferences= [numKeysView.value, startKey.value, knobsCCArray, slidersCCArray, name.string, [[midiDevice, midiPortName], \cf5 nil\cf2 , \cf5 nil\cf2 ], [\cf5 nil\cf2 , \cf5 nil\cf2 , \cf5 nil\cf2 ], backgroundColor, 0, \cf5 nil\cf2 !4, ([0.5, 0, 0, 0.01, 0.2, 0, 0, 3, 0, 0, \cf5 nil\cf2 , \cf5 nil\cf2 ]!4).asList, ((0!12)!4), 0!4, 0];\
	preferences.writeArchive(preferencesPath+/+name.string++\cf7 "_CURRENT"\cf2 ; );\
\
	\
	\cf8 //copy template with new name\cf2 \
	(thisFilePath++\cf7 "/samplerTemplate.scd"\cf2 ).copyTo(documentPath, name.string++\cf7 ".scd"\cf2 );\
	\cf9 StaticText\cf2 (w, \cf9 Rect\cf2 (20, 530, 360, 25)).string_(\
	\cf7 "OK! Make sure you dont have any unsaved samplers running and push Restart"\cf2 ).background_(\cf9 Color\cf2 .green);\
\
	\cf9 Button\cf2 (w, \cf9 Rect\cf2 (180, 500, 150, 20))\
	.states_([[\cf7 "Restart"\cf2 , \cf9 Color\cf2 .black, \cf9 Color\cf2 .green]])\
	.action_(\{\
	\cf6 thisProcess\cf2 .recompile;\
	\});\
	\
	\},\{\
		\cf8 //SCAlert\cf2 \
		\cf9 SCAlert\cf2 (\cf7 "some setting is missing"\cf2 , [\cf7 "OK!"\cf2 ]); \cf8 //maybe alert window!\cf2 \
	\});\
\
\};\
	\
\
\cf9 Button\cf2 (w, \cf9 Rect\cf2 (20, 500, 150, 20))\
.states_([[\cf7 "Save New Sampler!"\cf2 , \cf9 Color\cf2 .black, \cf9 Color\cf2 .green]])\
.action_(\{\
	\cf3 |v|\cf2 \
	writeSettings.value;\
	\});\
	\
\
\
\
w.front;\
w.onClose= \{\
	c.remove; \
	cc.remove; \
	noteResponder.remove;\
	\cf4 ~makeNewWindowOpen\cf2 = \cf5 false\cf2 ;\
	\};\
)\
\
\cf8 /*\
w.bounds\
a= [[23, 2],[]] // for folders with files to be routed specifically\
a[1][222]\
\
MIDIClient.sources.detectIndex(\{ |device| device.uid == nil\})\
MIDIIn.findPort("Oxygen 49", "Oxygen 49").uid\
*/\cf2 \
\
\cf8 /*\
find directory of app\
sense if its the first time it is run, make setup, or... have setup/install file???\
	maybe even cooler, make an install app that makes the app! copies itself and then adds settings, icon\
	or adds new keyboard to side menu.... YES. THROUGH MENU ITEM ON TOP\
make my own save dialog so you cant save outside the dir\
	change dirs, and go to backup\
	\
	reverse playback?\
	\
*/\cf2 \
\
}