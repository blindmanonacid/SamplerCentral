{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf600
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue191;\red0\green0\blue0;\red0\green0\blue255;
\red51\green51\blue191;\red0\green115\blue0;\red96\green96\blue96;\red191\green0\blue0;\red102\green102\blue191;
\red255\green102\blue0;}
{\*\expandedcolortbl;;\csgenericrgb\c0\c0\c75000;\csgenericrgb\c0\c0\c0;\csgenericrgb\c0\c0\c100000;
\csgenericrgb\c20000\c20000\c75000;\csgenericrgb\c0\c45000\c0;\csgenericrgb\c37500\c37500\c37500;\csgenericrgb\c75000\c0\c0;\csgenericrgb\c40000\c40000\c75000;
\csgenericrgb\c100000\c40000\c0;}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 KeyboardPreferences\cf3 \{\
	*new\{ \cf4 arg\cf3  thisFile;\
		\
\cf4 var\cf3  w, name, numberKeys, numKeysView, numFadersView, numKnobsView, numSlidersView;\
\cf4 var\cf3  knobs, learnKnobs, numberOfKnobs, knobsCCArray;\
\cf4 var\cf3  sliders, learnSliders, numberOfSliders, slidersCCArray;\
\cf4 var\cf3  startKey;\
\cf4 var\cf3  cc1, cc, noteResponder;\
\cf4 var\cf3  midi, midimenu, midimenuitems, midiDevice, midiPortName, midistring;\
\cf4 var\cf3  midichannelView, midichannel;\
\cf4 var\cf3  backgroundColor;\
\cf4 var\cf3  settings, writeSettings;\
\cf4 var\cf3  thisFilePath, settingsPath, documentPath;\
\cf4 var\cf3  knobsOK, slidersOK;\
\cf4 var\cf3  savefilePath, backupfilePath;\
\cf4 var\cf3  preferences, preferencesPath, preferencesFile, defaultPreferences;\
\cf4 var\cf3  thisFileName;\
\cf4 var\cf3  ruleFolder, routingPan, routingChannel;\
\cf4 var\cf3  outputs, defaultFolderRuleList, folderRuleList, folderNames, folderNamesView, onoffButtons, applyButtons;\
\cf4 var\cf3  c, propView;\
\cf4 var\cf3  applyStates, applyStatesDefault, onoffStates;\
\cf4 var\cf3  backup;\
\cf4 var\cf3  colorPicker;\
\cf4 var\cf3  savefilesWithPath, savefiles, loadmenu,loadPreferences;\
\cf4 var\cf3  mainoutputs, outputView;\
\cf4 var\cf3  selectionView, backgroundFolderView, selectionFunc;\
\cf4 var\cf3  ctrl, shift, alt;\
\cf4 var\cf3  prefBackground, midiPrefView;\
\cf4 var\cf3  backgroundFolderUnderView, midiInPriority, midiOutPriority, midiOutMenuitems, midiOut;\
\cf4 var\cf3  hotkeyScrollView, hotkeyView, hotkeyActionItems, excludeNotes, excludeCCnums;\
\cf4 var\cf3  learnHotkeyNote, learnHotkeyCC, learnHotkey= \cf5 false\cf3 , midiUID, mappedText, hotkeyActionMenus;\
\cf4 var\cf3  hotkeyType, hotkeyNum, hotkeyOnOff, hotkeyPrefs, mappedTextStrings, numHotkeys= 24;\
\
\cf2 Platform\cf3 .case(\
	\cf6 \\osx\cf3 ,		\{ ctrl= 262401; shift= 131330; alt= 524576; \},\
	\cf6 \\linux\cf3 ,		\{ ctrl= 262144; shift= 131072; \},\
	\cf6 \\windows\cf3 , 	\{ \cf7 "ERROR: havent tested this on Windows"\cf3 .postcs \}\
);\
\
midiInPriority= [\cf5 nil\cf3 , \cf5 nil\cf3 , \cf5 nil\cf3 ];\
midiOutPriority= [\cf5 nil\cf3 , \cf5 nil\cf3 , \cf5 nil\cf3 ];\
\
outputs= [\cf5 nil\cf3 , 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26];\
\
\cf8 //if (folderRuleList[newItem].isNil.not, \{folderRuleList.add(newItem, folderRuleList.deepCopy)\}\cf3 \
\
onoffButtons= \cf2 Array\cf3 .newClear(4); \
applyButtons= \cf2 List\cf3 .newClear(4);\
applyStatesDefault= (0!12)!4;\
folderNamesView= \cf2 Array\cf3 .newClear(4); \
defaultFolderRuleList= ([0.5, 0, 0, 0.01, 0.2, 0, 0, 3, 0, 0, \cf5 nil\cf3 , \cf5 nil\cf3 ]!4).asList;\
defaultPreferences= [\cf5 nil\cf3 , \cf5 nil\cf3 , \cf5 nil\cf3 , \cf5 nil\cf3 , \cf5 nil\cf3 , \cf5 nil\cf3 , \cf5 nil\cf3 , \cf5 nil\cf3 , 0, \cf5 nil\cf3 !4, defaultFolderRuleList, applyStatesDefault, 0!4, 0, [0, \cf5 nil\cf3 , \cf5 nil\cf3 , 0]!numHotkeys];\
\
\cf8 //, [0, nil, nil, 0]!numHotkeys\cf3 \
\
thisFilePath= thisFile.dirname.dirname;\
thisFileName= thisFile.basename;\
(\cf7 "path:"\cf3 +thisFilePath).postln;\
(\cf7 "name:"\cf3 +thisFileName).postln;\
settingsPath= (thisFilePath++\cf7 "/"\cf3 ++\cf7 "Resources/SETTINGS/"\cf3 ++(thisFileName)++\cf7 "SETUP"\cf3 ).standardizePath;\
\cf8 //documentPath= (thisFilePath++"/"++"Resources/SAMPLERS/").standardizePath;\cf3 \
preferencesPath= (thisFilePath++\cf7 "/"\cf3 ++\cf7 "Resources/PREFERENCES/"\cf3 ++thisFileName).standardizePath;\
preferencesFile= (preferencesPath++\cf7 "/"\cf3 ++thisFileName++\cf7 "_CURRENT"\cf3 ).standardizePath;\
\cf8 //savefilePath= (thisFilePath++"/"++"Resources/SAVEFILES/"++name.string).standardizePath;\cf3 \
\
if(preferencesFile.isFile, \{\
	preferences= \cf2 Object\cf3 .readArchive(preferencesFile);\
	\},\{\
	preferences= \cf2 Object\cf3 .readArchive(settingsPath);\
	\cf8 //preferences[5]= [[preferences[5].deepCopy, preferences[6].deepCopy], nil, nil];\cf3 \
	\cf8 //preferences[6]= [nil, nil, nil];\cf3 \
\});\
\
\cf8 //backwards compability\cf3 \
if (preferences.size < defaultPreferences.size, \{\
	preferences= preferences.asList;\
	defaultPreferences.do(\{ \cf4 |it, i|\cf3 \
			if (preferences[i].isNil, \{ preferences= preferences.add(it) \});\
	\});\
\});\
\
\cf8 //numKeysView.value= preferences[0].asInteger;\cf3 \
\cf8 //startKey.value= preferences[1];\cf3 \
knobsCCArray= preferences[2];\
slidersCCArray= preferences[3];\
\cf8 //name.string, = preferences[4];\cf3 \
\cf8 //midiDevice= preferences[5];\cf3 \
midiInPriority= preferences[5];\
\cf8 //midiPortName= preferences[6];\cf3 \
midiOutPriority= preferences[6];\
backgroundColor= preferences[7];\
if (preferences[8].isNil, \{midichannel= 0\}, \{midichannel= preferences[8]\}); \cf8 // ! ! ! ! !!\cf3 \
if (preferences[9].isNil, \{folderNames= \cf2 Array\cf3 .newClear(4)\}, \{folderNames= preferences[9]\});\
if (preferences[10].isNil, \{folderRuleList= defaultFolderRuleList;\},\{folderRuleList= preferences[10]\});\
if (preferences[11].isNil.not, \{applyStates= preferences[11]\}, \{applyStates= applyStatesDefault\});\
if (preferences[12].isNil.not, \{onoffStates= preferences[12]\}, \{onoffStates= 0!4\});\
if (preferences[13].isNil.not, \{mainoutputs= preferences[13]\}, \{mainoutputs= 0\});\
if (preferences[14].isNil.not, \{hotkeyPrefs= preferences[14]\}, \{hotkeyPrefs= [0, \cf5 nil\cf3 , \cf5 nil\cf3 , 0]!numHotkeys\});\
\
\cf8 //preferences.postcs;\cf3 \
\
\
\
\cf8 // ========================== PREFERENCES GUI ===============================\cf3 \
\
w= \cf2 Window\cf3 ( (preferences[4]+\cf7 "preferences"\cf3 ), \cf2 Rect\cf3 (0, 0, 1100, 650));\
\
prefBackground= \cf2 CompositeView\cf3 (w, \cf2 Rect\cf3 (10, 10, 300, 350))\
.background_(\cf2 Color\cf3 (0.5, 0.6, 0.6, 1.0));\
\
\cf2 StaticText\cf3 (prefBackground, \cf2 Rect\cf3 (0, 0, 300, 40))\
.string_(\cf7 "Preferences:"\cf3 )\
.align_(\cf6 \\center\cf3 )\
.font_(\cf2 Font\cf3 .new(\cf7 "Helvetica"\cf3 , 24));\
\
\cf8 //midi connect\cf3 \
\cf8 /*\
MIDIClient.init;\
MIDIIn.connectAll;\
*/\cf3 \
\
\cf8 //keyboard name\cf3 \
\cf2 StaticText\cf3 (prefBackground, \cf2 Rect\cf3 (10, 40, 100, 20))\
.string_(\cf7 "Name:"\cf3 );\
name= \cf2 StaticText\cf3 (prefBackground, \cf2 Rect\cf3 (50, 40, 100, 20))\
.background_(\cf2 Color\cf3 .grey)\
.align_(\cf6 \\center\cf3 )\
.font_(\cf2 Font\cf3 (\cf7 "Helvetica"\cf3 , 12))\
.string_(preferences[4]);\
\cf8 //.editable_(false);\cf3 \
\
\cf8 //number of keys\cf3 \
\cf2 StaticText\cf3 (prefBackground, \cf2 Rect\cf3 (160, 40, 100, 20))\
.string_(\cf7 "Number of keys:"\cf3 );\
numKeysView= \cf2 NumberBox\cf3 (prefBackground, \cf2 Rect\cf3 (260, 40, 30, 20))\
.value_(preferences[0].asInteger)\
.enabled_(\cf5 false\cf3 )\
.step_(12)\
.clipLo_(13)\
.clipHi_(49);\
\
\
\cf8 //number of knobs\cf3 \
\cf2 StaticText\cf3 (prefBackground, \cf2 Rect\cf3 (10, 70, 120, 20))\
.string_(\cf7 "Number of knobs:"\cf3 );\
numKnobsView= \cf2 NumberBox\cf3 (prefBackground, \cf2 Rect\cf3 (120, 70, 30, 20))\
.value_(knobsCCArray.size)\
.enabled_(\cf5 false\cf3 )\
.action_(\{\cf4 |v|\cf3  numberOfKnobs= v.value\});\
\
\cf8 //number of sliders\cf3 \
\cf2 StaticText\cf3 (prefBackground, \cf2 Rect\cf3 (10, 130, 120, 20))\
.string_(\cf7 "Number of sliders:"\cf3 );\
numSlidersView= \cf2 NumberBox\cf3 (prefBackground, \cf2 Rect\cf3 (120, 130, 30, 20))\
.value_(slidersCCArray.size)\
.enabled_(\cf5 false\cf3 )\
.action_(\{\cf4 |v|\cf3  numberOfSliders= v.value\});\
\
knobsOK= \cf2 StaticText\cf3 (prefBackground, \cf2 Rect\cf3 (260, 70, 50, 20)).string_(\cf7 ""\cf3 );\
\
\cf2 Button\cf3 (prefBackground, \cf2 Rect\cf3 (180, 70, 70, 20))\
.states_([[\cf7 "set knobs"\cf3 ], [\cf7 "ok"\cf3 ]])\
.canFocus_(\cf5 false\cf3 )\
.action_(\{\
	\cf4 |v|\cf3 \
	if (v.value == 1, \{learnKnobs.value; knobsOK.string_(\cf7 ""\cf3 ); \}, \{\
		cc1.remove; knobs.do(\{\cf4 |it|\cf3  it.remove; \}); w.refresh; \
		if(knobsCCArray.size == numberOfKnobs, \{\
			knobsOK.string_(\cf7 "OK!"\cf3 );\
			\},\{\
			knobsOK.string_(\cf7 "not enough input.."\cf3 );\
			\});\
		\});\
	\});\
\
\
learnKnobs= \{\
	\cf4 var\cf3  ccArray= [];\
	numberOfKnobs= numKnobsView.value.asInteger;\
	knobs= \cf2 Array\cf3 .newClear(numberOfKnobs);\
	\{\
	numberOfKnobs.do(\{\cf4 |it, i|\cf3 \
		knobs[i]= \cf2 Knob\cf3 (prefBackground, \cf2 Rect\cf3 ((30*i), 90, 20, 20));\
	\});\
	\}.defer;\
	\
	cc1 = \cf2 CCResponder\cf3 (\{ \cf4 |src,chan,num,value|\cf3 \
		\cf8 //[src,chan,num].postln;\cf3 \
		\
		if (ccArray.indexOf(num).isNil, \{ \
			if (ccArray.size >= numberOfKnobs, \{\cf7 "all knobs filled!"\cf3 .postln; knobsCCArray= ccArray;\}, \{\
				ccArray= ccArray.add(num);\});\
			\}, \{\
				if (ccArray.size >= numberOfKnobs, \{\cf7 "all knobs filled!"\cf3 .postln; knobsCCArray= ccArray;\});\
					\{knobs[(ccArray.indexOf(num))].value= (value/127)\}.defer;\
		\});\
		ccArray.postln;\
		\});\
\
	w.refresh;\
	\};\
\
slidersOK= \cf2 StaticText\cf3 (prefBackground, \cf2 Rect\cf3 (260, 130, 150, 20));\
\
\cf2 Button\cf3 (prefBackground, \cf2 Rect\cf3 (180, 130, 70, 20))\
.states_([[\cf7 "set sliders"\cf3 ], [\cf7 "ok"\cf3 ]])\
.canFocus_(\cf5 false\cf3 )\
.action_(\{\
	\cf4 |v|\cf3 \
	if (v.value == 1, \{learnSliders.value; slidersOK.string_(\cf7 ""\cf3 ); \}, \{\
		cc.remove; sliders.do(\{\cf4 |it|\cf3  it.remove; \}); w.refresh;\
		if(slidersCCArray.size == numberOfSliders, \{\
			slidersOK.string_(\cf7 "OK!"\cf3 );\
			\},\{\
			slidersOK.string_(\cf7 "not enough input.."\cf3 );\
			\});\
		\});\
	\});\
\
\
learnSliders= \{\
	\cf4 var\cf3  ccArray= [];\
	numberOfSliders= numSlidersView.value.asInteger;\
	sliders= \cf2 Array\cf3 .newClear(numberOfSliders);\
	\{\
	numberOfSliders.do(\{\cf4 |it, i|\cf3 \
		sliders[i]= \cf2 Slider\cf3 (prefBackground, \cf2 Rect\cf3 (10+(30*i), 150, 20, 40)).thumbSize_(10);\
	\});\
	\}.defer;\
	\
	cc = \cf2 CCResponder\cf3 (\{ \cf4 |src,chan,num,value|\cf3 \
		\cf8 //[src,chan,num].postln;\cf3 \
		\
		if (ccArray.indexOf(num).isNil, \{ \
			if (ccArray.size >= numberOfSliders, \{\cf7 "all sliders filled!"\cf3 .postln; slidersCCArray= ccArray;\}, \{\
				ccArray= ccArray.add(num);\});\
			\}, \{\
				if (ccArray.size >= numberOfSliders, \{\cf7 "all sliders filled!"\cf3 .postln; slidersCCArray= ccArray;\});\
					\{sliders[(ccArray.indexOf(num))].value= (value/127)\}.defer;\
		\});\
		ccArray.postln;\
		\});\
\
	w.refresh;\
	\};\
\
\
\cf8 //start key\cf3 \
\cf2 StaticText\cf3 (prefBackground, \cf2 Rect\cf3 (10, 200, 220, 20))\
.string_(\cf7 "Push lowest key on keyboard:"\cf3 );\
startKey= \cf2 NumberBox\cf3 (prefBackground, \cf2 Rect\cf3 (185, 200, 30, 20))\
.value_(preferences[1])\
.enabled_(\cf5 false\cf3 );\
\
\cf2 Button\cf3 (prefBackground, \cf2 Rect\cf3 (220, 200, 70, 20))\
.states_([[\cf7 "edit"\cf3 ], [\cf7 "ok"\cf3 ]])\
.action_(\{\
	\cf4 |v|\cf3 \
	if (v.value == 1, \{\
			noteResponder = \cf2 NoteOnResponder\cf3 (\{ \cf4 |src,chan,note,vel|\cf3 \
			[src,chan,note,vel].postln;\
			\{startKey.value= note\}.defer;\
		\});\
		\}, \{\
			noteResponder.remove;\
		\});\
	\});\
\
\
\
\cf2 StaticText\cf3 (prefBackground, \cf2 Rect\cf3 (10, 230, 200, 20))\
.string_(\cf7 "Main Output Channels:"\cf3 );\
outputView= \cf2 Button\cf3 (prefBackground, \cf2 Rect\cf3 (160, 230, 40, 20))\
.states_([[\cf7 "nil"\cf3 , \cf2 Color\cf3 .black, \cf2 Color\cf3 .grey], [\cf7 "1-2"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black],[\cf7 "3-4"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf7 "5-6"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf7 "7-8"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf7 "9-10"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf7 "11-12"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf7 "13-14"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf7 "15-16"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf7 "17-18"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf7 "19-20"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black] , [\cf7 "21-22"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf7 "23-24"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf7 "25-26"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black]] )\
.canFocus_(\cf5 false\cf3 )\
.value_(preferences[13])\
.action_(\{ \cf4 |v|\cf3 \
	mainoutputs= v.value;\
	preferences[13]= v.value;\
\});\
\
\cf2 StaticText\cf3 (prefBackground, \cf2 Rect\cf3 (10, 260, 200, 20))\
.string_(\cf7 "Select background color:"\cf3 );\
\cf8 //colorPicker= ColorPicker.hsvMini(w, Rect(200, 470, 50, 50), backgroundColor, \{|clr| backgroundColor= clr; \}, true);\cf3 \
\cf2 ColorPicker\cf3 .new(prefBackground, \cf2 Point\cf3 (0, 280), backgroundColor, \{\cf4 |clr|\cf3  backgroundColor= clr; \}, \cf5 true\cf3 );\
\
\
\cf8 // ====================== MIDI PREFERENCES ==========================\cf3 \
\
midiPrefView= \cf2 CompositeView\cf3 (w, \cf2 Rect\cf3 (320, 10, 240, 350))\
.background_(\cf2 Color\cf3 (0.52238805970149, 0.62686567164179, 0.65671641791045, 1.0));\
\
\cf2 StaticText\cf3 (midiPrefView, \cf2 Rect\cf3 (10, 0, 240, 40))\
.string_(\cf7 "MIDI settings:"\cf3 )\
.align_(\cf6 \\center\cf3 )\
.font_(\cf2 Font\cf3 .new(\cf7 "Helvetica"\cf3 , 24));\
\
\
\cf2 StaticText\cf3 (midiPrefView, \cf2 Rect\cf3 (10, 40, 100, 20)).string_(\cf7 "MIDI Input:"\cf3 );\
\
midistring= \cf2 StaticText\cf3 (midiPrefView, \cf2 Rect\cf3 (235, 60, 60, 20)).string_(\cf7 ""\cf3 );\
\
midi= \cf2 MIDIClient\cf3 .sources;\
\cf8 //midimenuitems= midi.size.collect(\{|i|(midi[i].asString.replace("MIDIEndPoint", "").drop(-1).drop(1)); \});\cf3 \
midimenuitems= midi.collect(\{\cf4 |it|\cf3  (it.asString.replace(\cf7 "MIDIEndPoint"\cf3 , \cf7 ""\cf3 ).drop(-1).drop(1)).tr($(,$[).tr($),$]); \});\
\
midimenuitems= [\cf7 "select midi input..."\cf3 ]++midimenuitems;\
midimenuitems.postln;\
\
\cf8 /*\
midimenu= PopUpMenu(midiPrefView, Rect(10, 70, 220, 20))\
.items_(midimenuitems)\
.action_(\{ |v|\
if (v.value > 0, \{\
	v.items[v.value].postln;\
	midiDevice= midi[v.value-1].device;\
	midiPortName= midi[v.value-1].name;\
	midistring.string_("OK").stringColor_(Color.green);\
	\});\
\});\
\
midimenu.items.do(\{|it, i| if (it.asString.contains(midiDevice), \{midimenu.value_(i)\}) \});\
if(midimenu.value == 0, \{ midistring.string_("!").stringColor_(Color.red); \});\
*/\cf3 \
\
\cf2 StaticText\cf3 (midiPrefView, \cf2 Rect\cf3 (10, 90, 120, 20)).string_(\cf7 "MIDI Channel:"\cf3 );\
midichannelView= \cf2 NumberBox\cf3 (midiPrefView, \cf2 Rect\cf3 (120, 90, 30, 20))\
.value_(midichannel)\
.action_(\{\cf4 |v|\cf3  midichannel= v.value; \})\
.step_(1)\
.clipLo_(0)\
.clipHi_(16);\
\
\cf8 // MIDI IN CONNECTION PRIORITY\cf3 \
\cf2 StaticText\cf3 (midiPrefView, \cf2 Rect\cf3 (10, 120, 220, 20))\
.string_(\cf7 "MIDI IN Connection Priority:"\cf3 )\
.align_(\cf6 \\center\cf3 )\
.background_(\cf2 Color\cf3 .grey)\
.font_(\cf2 Font\cf3 .new(\cf7 "Helvetica"\cf3 , 15));\
\
midiInPriority.do(\{\cf4 |it, i|\cf3 \
	\cf4 var\cf3  current;\
\
	\cf2 StaticText\cf3 (midiPrefView, \cf2 Rect\cf3 (10, 140+(i*30), 20, 20))\
	.string_((i+1).asString++\cf7 "."\cf3 )\
	.align_(\cf6 \\left\cf3 )\
	.font_(\cf2 Font\cf3 .new(\cf7 "Helvetica"\cf3 , 12));\
\
	current= \cf2 StaticText\cf3 (midiPrefView, \cf2 Rect\cf3 (20, 140+(i*30), 100, 20))\
	.string_(it.asString)\
	.align_(\cf6 \\center\cf3 )\
	.background_(\cf2 Color\cf3 .white)\
	.font_(\cf2 Font\cf3 .new(\cf7 "Helvetica"\cf3 , 10));	\
	\
	\cf2 PopUpMenu\cf3 (midiPrefView, \cf2 Rect\cf3 (120, 140+(i*30), 110, 20))\
	.items_(midimenuitems)\
	.action_(\{\cf4 |v|\cf3 \
		if (v.value == 0, \{\
			midiInPriority[i]= \cf5 nil\cf3 ;\
			current.string= \cf5 nil\cf3 ;\
			current.align= \cf6 \\center\cf3 ;\
			current.font= \cf2 Font\cf3 .new(\cf7 "Helvetica"\cf3 , 10);\
			\}, \{\
			midiInPriority[i]= [midi[v.value-1].device.asString, midi[v.value-1].name.asString];\
			current.string= v.items[v.value];\
			current.align= \cf6 \\center\cf3 ;\
			current.font= \cf2 Font\cf3 .new(\cf7 "Helvetica"\cf3 , 10);\
		\});\
		\});\
\
\});\
\
\cf8 // MIDI OUT CONNECTION PRIORITY\cf3 \
\
midiOut= \cf2 MIDIClient\cf3 .destinations;\
midiOutMenuitems= midiOut.collect(\{\cf4 |it|\cf3  (it.asString.replace(\cf7 "MIDIEndPoint"\cf3 , \cf7 ""\cf3 ).drop(-1).drop(1)).tr($(,$[).tr($),$]); \});\
\
midiOutMenuitems= [\cf7 "select midi input..."\cf3 ]++midiOutMenuitems;\
\
\cf2 StaticText\cf3 (midiPrefView, \cf2 Rect\cf3 (10, 240, 220, 20))\
.string_(\cf7 "MIDI OUT Connection Priority:"\cf3 )\
.align_(\cf6 \\center\cf3 )\
.background_(\cf2 Color\cf3 .grey)\
.font_(\cf2 Font\cf3 .new(\cf7 "Helvetica"\cf3 , 15));\
\
midiOutPriority.do(\{\cf4 |it, i|\cf3 \
	\cf4 var\cf3  current;\
\
	\cf2 StaticText\cf3 (midiPrefView, \cf2 Rect\cf3 (10, 260+(i*30), 20, 20))\
	.string_((i+1).asString++\cf7 "."\cf3 )\
	.align_(\cf6 \\left\cf3 )\
	.font_(\cf2 Font\cf3 .new(\cf7 "Helvetica"\cf3 , 12));\
\
	current= \cf2 StaticText\cf3 (midiPrefView, \cf2 Rect\cf3 (20, 260+(i*30), 100, 20))\
	.string_(it.asString)\
	.align_(\cf6 \\center\cf3 )\
	.background_(\cf2 Color\cf3 .white)\
	.font_(\cf2 Font\cf3 .new(\cf7 "Helvetica"\cf3 , 10));	\
	\
	\cf2 PopUpMenu\cf3 (midiPrefView, \cf2 Rect\cf3 (120, 260+(i*30), 110, 20))\
	.items_(midiOutMenuitems)\
	.action_(\{\cf4 |v|\cf3 \
		if (v.value == 0, \{\
			midiOutPriority[i]= \cf5 nil\cf3 ;\
			current.string= \cf5 nil\cf3 ;\
			current.align= \cf6 \\center\cf3 ;\
			current.font= \cf2 Font\cf3 .new(\cf7 "Helvetica"\cf3 , 10);\
			\}, \{\
			midiOutPriority[i]= [midiOut[v.value-1].device.asString, midiOut[v.value-1].name.asString];\
			current.string= v.items[v.value];\
			current.align= \cf6 \\center\cf3 ;\
			current.font= \cf2 Font\cf3 .new(\cf7 "Helvetica"\cf3 , 10);\
		\});\
		\});\
\
\});\
\
\
\cf8 // ==================================== R U L E S ==================================== //\cf3 \
\
\
backgroundFolderUnderView= \cf2 CompositeView\cf3 (w, \cf2 Rect\cf3 (570, 10, 520, 580))\
.background_(\cf2 Color\cf3 (0.52238805970149, 0.62686567164179, 0.65671641791045, 1.0));\
\
backgroundFolderView= \cf2 CompositeView\cf3 (w, \cf2 Rect\cf3 (570, 10, 520, 580))\
.background_(\cf2 Color\cf3 .white.alpha_(0));\
\
\cf2 StaticText\cf3 (backgroundFolderView, \cf2 Rect\cf3 (10, 0, 500, 40))\
.string_(\cf7 "Folder Specific Rules:"\cf3 )\
.align_(\cf6 \\center\cf3 )\
.font_(\cf2 Font\cf3 .new(\cf7 "Helvetica"\cf3 , 24));\
\
\cf2 CompositeView\cf3 (backgroundFolderView, \cf2 Rect\cf3 (145, 360, 220, 190))\
.background_(\cf2 Color\cf3 .new255(229, 229, 229));\
\
selectionFunc= \{\cf4 |i|\cf3 \
	selectionView.remove;\
	selectionView= \cf2 CompositeView\cf3 (backgroundFolderUnderView, \cf2 Rect\cf3 (0, 60+(i*70), 520, 72))\
	.background_(\cf2 Color\cf3 .new255(229, 229, 229));\
\};\
\
4.do(\{ \cf4 |i|\cf3 \
	\cf4 var\cf3  onoffValue;\
	\
	if (onoffStates[i].isNil, \{onoffValue= 0\},\{onoffValue= onoffStates[i]\});\
	\
	\cf2 StaticText\cf3 (backgroundFolderView, \cf2 Rect\cf3 (10, 60+(i*70), 500, 20))\
	.string_(\cf7 "Rule"\cf3 +(i+1).asString++\cf7 ":"\cf3 )\
	.align_(\cf6 \\center\cf3 )\
	.font_(\cf2 Font\cf3 .new(\cf7 "Helvetica"\cf3 , 16));\
	\
	folderNamesView[i]= \cf2 StaticText\cf3 (backgroundFolderView, \cf2 Rect\cf3 (10, 80+(i*70), 500, 20))\
	.align_(\cf6 \\center\cf3 )\
	.background_(\cf2 Color\cf3 .grey)\
	.string_(folderNames[i]).align_(\cf6 \\center\cf3 );\
\
\cf8 //	folderNames[i]= PopUpMenu(w, Rect(390, 80+(i*30), 80, 20))\cf3 \
\cf8 //	.items_(["--"]);\cf3 \
\
	\cf2 Button\cf3 (backgroundFolderView, \cf2 Rect\cf3 (10, 100+(i*70), 60, 20))\
	.states_([[\cf7 "folder"\cf3 ]])\
	.action_(\{\
		\cf2 CocoaDialog\cf3 .getPaths(\{ \cf4 arg\cf3  paths;\
			\cf4 var\cf3  p, pp;\
			pp= paths[0].dirname;\
			\cf8 //p= pp.copyRange(pp.size-18, pp.size-1);\cf3 \
			p= pp;\
			folderNames[i]= p;\
			\
			folderNamesView[i].string= p;			\
			folderNamesView[i].align= \cf6 \\center\cf3 ;\
			p.postln;\
			\cf8 //folderNames[i].items= [paths[0].dirname];\cf3 \
			\cf8 //clearButton.valueAction\cf3 \
		\},\{\
			\cf7 "cancelled"\cf3 .postln;\
		\});\
	\});\
	\
	\
	onoffButtons[i]= \cf2 Button\cf3 (backgroundFolderView, \cf2 Rect\cf3 (80, 100+(i*70), 30, 20))\
	.states_([[\cf7 "off"\cf3 , \cf2 Color\cf3 .black, \cf2 Color\cf3 .grey], [\cf7 "on"\cf3 , \cf2 Color\cf3 .black, \cf2 Color\cf3 .green]])\
	.value_(onoffValue)\
	.action_(\{\cf4 |v|\cf3  if (folderNames[i].isNil, \{ v.value=0 \},\{ onoffStates[i]= v.value \}); \});\
	\
	applyButtons[i]= [\cf7 "vol"\cf3 , \cf7 "loop"\cf3 , \cf7 "mnu"\cf3 , \cf7 "atk"\cf3 , \cf7 "rls"\cf3 , \cf7 "kill"\cf3 , \cf7 "-"\cf3 , \cf7 "-"\cf3 ,\cf7 "shot"\cf3 , \cf7 "pan"\cf3 , \cf7 "out"\cf3 , \cf7 "midi"\cf3 ].collect(\{\cf4 |it, ii|\cf3 \
		\cf4 var\cf3  state, enabled;\
		enabled= [\cf5 true\cf3 , \cf5 true\cf3 , \cf5 true\cf3 , \cf5 true\cf3 , \cf5 true\cf3 , \cf5 true\cf3 , \cf5 false\cf3 , \cf5 false\cf3 ,\cf5 true\cf3 , \cf5 true\cf3 , \cf5 true\cf3 , \cf5 true\cf3 ];\
		if (applyStates.isNil.not, \{state= applyStates[i][ii]\},\{state= 0\});\
		\cf2 Button\cf3 (backgroundFolderView, \cf2 Rect\cf3 (120+(ii*30), 110+(i*70), 30, 20))\
		.states_([[it, \cf2 Color\cf3 .black, \cf2 Color\cf3 .grey], [it, \cf2 Color\cf3 .black, \cf2 Color\cf3 (1.0, 0.95522388059701, 0.08955223880597, 1.0)]])\
		.enabled_(enabled[ii])\
		.canFocus_(\cf5 false\cf3 )\
		.value_(state)\
		.action_(\{\cf4 |v|\cf3  applyStates[i][ii]= v.value \});\
	\});\
	\
	\cf2 Button\cf3 (backgroundFolderView, \cf2 Rect\cf3 (120+(30*applyButtons[i].size), 110+(i*70), 30, 20)) \cf8 //edit that rule\cf3 \
	.states_([[\cf7 "edit"\cf3 , \cf2 Color\cf3 .black, \cf2 Color\cf3 .white]])\
	.action_(\{ c.remove; propView.value(i); selectionFunc.value(i) \});\
\
\});\
\
\cf8 /*\
	Button(w, Rect(450, 550, 80, 50)) //DEBUG\
	.states_([["debug!", Color.black, Color.white]])\
	.action_(\{  \
		applyStates= applyButtons.collect(\{|it, i|\
			it.collect(\{|it|\
				it.value;\
			\});\
		\});\
		applyButtons.size.postln;\
		applyStates.postln;\
	\});\
*/\cf3 	\
\
\
\
\
\cf8 // ====================== RULES PROPERITES WINDOW ===================\cf3 \
\cf8 // christ... Dictionary! NO, LIST!!!\cf3 \
\cf8 // ok so setting them is ok, but how to know which rules are actually being applied??\cf3 \
\cf8 // check all buttons when saving.!\cf3 \
\
propView= \{ \cf4 | key |\cf3 \
\cf4 var\cf3  panarr= [0, -1, 1];\
\
c= \cf2 CompositeView\cf3 (backgroundFolderView, \cf2 Rect\cf3 (145, 360, 220, 190))\
.background_(\cf2 Color\cf3 .new255(229, 229, 229));\
\cf8 //.relativeOrigin_(true);\cf3 \
\
\cf2 StaticText\cf3 (c, \cf2 Rect\cf3 (90, 0, 200, 15))\
.string_((\cf7 "Rule"\cf3 +(key+1).asString));\
\
\cf8 /*\
Button(c, Rect(20, 10, 30, 15))\
.states_([["c", Color.black, Color.grey], ["<", Color.green, Color.black],[">", Color.green, Color.black] ])\
.canFocus_(false)\
.value_(panarr.indexOf(folderRuleList[key][9]))\
.action_(\{ |v|\
	folderRuleList[key][9]= panarr[v.value];\
\});\
*/\cf3 \
\
\cf2 Knob\cf3 (c, \cf2 Rect\cf3 (20, 10, 15, 15))\
.centered_(\cf5 true\cf3 )\
.canFocus_(\cf5 false\cf3 )\
.value_(\cf6 \\pan\cf3 .asSpec.unmap(folderRuleList[key][9]))\
.value_(folderRuleList[key][9])\
.action_(\{ \cf4 |v|\cf3 \
	folderRuleList[key][9]= \cf6 \\pan\cf3 .asSpec.map(v.value);\
	\cf6 \\pan\cf3 .asSpec.map(v.value).postln;\
\})\
.color_([\cf2 Color\cf3 .gray, \cf2 Color\cf3 .red, \cf2 Color\cf3 .white, \cf2 Color\cf3 .black])\
.mouseDownAction_(\{\cf4 |view, x, y, mod|\cf3 \
	if (mod == alt, \{view.valueAction= \cf6 \\pan\cf3 .asSpec.unmap(0); folderRuleList[key][9]= 0\})\
\});\
\
\cf8 //(outputs.indexOf(folderRuleList[key][10])).postln;\cf3 \
\
\cf2 Button\cf3 (c, \cf2 Rect\cf3 (50, 10, 30, 15))\
.states_([[\cf7 "nil"\cf3 , \cf2 Color\cf3 .black, \cf2 Color\cf3 .grey], [\cf7 "1-2"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black],[\cf7 "3-4"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf7 "5-5"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf7 "7-8"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf7 "9-10"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf7 "11-12"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf7 "13-14"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf7 "15-16"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf7 "17-18"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf7 "19-20"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black] , [\cf7 "21-22"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf7 "23-24"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf7 "25-26"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black]] )\
.canFocus_(\cf5 false\cf3 )\
.value_(if (folderRuleList[key][10]==\cf5 nil\cf3 , \{ 0 \}, \{ outputs.indexOf(folderRuleList[key][10]) \}) )\
.action_(\{ \cf4 |v|\cf3 \
	folderRuleList[key][10]= outputs[v.value];\
\});\
\
\
\cf2 Slider\cf3 (c, \cf2 Rect\cf3 (20, 30, 60, 120))\
.background_(\cf2 Color\cf3 .grey)\
.canFocus_(\cf5 false\cf3 )\
.value_(folderRuleList[key][0])\
.action_(\{ \cf4 |v|\cf3 \
	folderRuleList[key][0]= v.value;\
\});\
\cf2 Button\cf3 (c, \cf2 Rect\cf3 (90, 20, 60, 20))\
.states_([[\cf7 "loop off"\cf3 , \cf2 Color\cf3 .black, \cf2 Color\cf3 .grey], [\cf7 "loop on"\cf3 , \cf2 Color\cf3 .white, \cf2 Color\cf3 .black]])\
.canFocus_(\cf5 false\cf3 )\
.value_(folderRuleList[key][1])\
.action_(\{ \cf4 |v|\cf3 \
	folderRuleList[key][1]= v.value;\
\});\
\
\cf2 Button\cf3 (c, \cf2 Rect\cf3 (150, 20, 30, 20))\
.states_([[\cf7 "|--|"\cf3 , \cf2 Color\cf3 .white, \cf2 Color\cf3 .grey]])\
.canFocus_(\cf5 false\cf3 )\
.action_(\{ \cf4 |v|\cf3 \
\
	\cf8 //\{looppointeditor.value(key)\}\cf3 \
	\cf8 //\{midiSendWindow.value(key)\}\cf3 \
\});\
\
\
\cf2 Button\cf3 (c, \cf2 Rect\cf3 (150, 45, 30, 20))\
.states_([[\cf7 "killa"\cf3 , \cf2 Color\cf3 .black, \cf2 Color\cf3 .grey], [\cf7 "killa"\cf3 , \cf2 Color\cf3 .red, \cf2 Color\cf3 .black]])\
.canFocus_(\cf5 false\cf3 )\
.value_(folderRuleList[key][5])\
.action_(\{ \cf4 |v|\cf3 \
	folderRuleList[key][5]= v.value;\
\});\
\
\cf2 Button\cf3 (c, \cf2 Rect\cf3 (180, 45, 20, 20))\
.states_([[\cf7 "sh"\cf3 , \cf2 Color\cf3 .black, \cf2 Color\cf3 .grey], [\cf7 "sh"\cf3 , \cf2 Color\cf3 .red, \cf2 Color\cf3 .black]])\
.canFocus_(\cf5 false\cf3 )\
.value_(folderRuleList[key][8])\
.action_(\{ \cf4 |v|\cf3 \
	folderRuleList[key][8]= v.value;\
	folderRuleList[key][8].postln;\
	if (v.value == 1, \{folderRuleList[key][1]= 0\});\
\});\
\
\
\cf2 Button\cf3 (c, \cf2 Rect\cf3 (90, 45, 60, 20))\
.states_([[\cf7 "|>"\cf3 , \cf2 Color\cf3 .black, \cf2 Color\cf3 .grey], [\cf7 "|>"\cf3 , \cf2 Color\cf3 .white, \cf2 Color\cf3 .black]])\
.canFocus_(\cf5 false\cf3 );\
\
\cf2 EZNumber\cf3 ( c,  	\cf8 // parent\cf3 \
	\cf2 Rect\cf3 (70, 70, 80, 20),	\cf8 // bounds\cf3 \
	\cf7 "atk"\cf3 ,	\cf8 // label\cf3 \
	[0,6,\cf6 \\lin\cf3 ,0.01, folderRuleList[key][3]].asSpec, 	\cf8 // controlSpec\cf3 \
	\{\cf4 |ez|\cf3  \
	folderRuleList[key][3]= ez.value;\
	\}, \cf8 // action\cf3 \
	labelWidth: 30,\
	numberWidth: 40,\
	unitWidth: 1\
);\
\
\cf2 EZNumber\cf3 ( c,  	\cf8 // parent\cf3 \
	\cf2 Rect\cf3 (130, 70, 80, 20),	\cf8 // bounds\cf3 \
	\cf7 "rel"\cf3 ,	\cf8 // label\cf3 \
	[0,6,\cf6 \\lin\cf3 ,0.01, folderRuleList[key][4]].asSpec, 	\cf8 // controlSpec\cf3 \
	\{\cf4 |ez|\cf3  \
	folderRuleList[key][4]= ez.value;\
	\}, \cf8 // action\cf3 \
	labelWidth: 30,\
	numberWidth: 40,\
	unitWidth: 1\
);\
\
\
\cf2 PopUpMenu\cf3 (c, \cf2 Rect\cf3 (10, 155, 80, 20))\
.items_([\cf7 "piano"\cf3 , \cf7 "shot"\cf3 , \cf7 "toggle"\cf3 ])\
.value_(folderRuleList[key][2])\
.canFocus_(\cf5 false\cf3 )\
.action_(\{ \cf4 arg\cf3  menu;\
	folderRuleList[key][2] = menu.value;\
\
\});\
\
\};\
\
\cf8 // ========================== HOTKEYS ===============================\cf3 \
\
\cf8 // put default values in defaultPreferences probably also in sampler file\cf3 \
\
midiInPriority.do(\{\cf4 |it, i|\cf3 \
	\cf4 var\cf3  midiEndPoint;\
	if (it.isNil.not and: \{midiUID.isNil\}, \{\
		midiEndPoint= \cf2 MIDIIn\cf3 .findPort(it[0], it[1]);\
		if (midiEndPoint.isNil.not, \{\
			(\cf7 "MIDI IN DEVICE:"\cf3 +it[0]).postln;\
			midiUID= midiEndPoint.uid;\
		\});\
	\});\
\});\
\
\cf8 //numHotkeys= 12;\cf3 \
mappedText= \cf5 nil\cf3 !numHotkeys;\
hotkeyActionMenus= \cf5 nil\cf3 !numHotkeys;\
hotkeyOnOff= \cf5 nil\cf3 !numHotkeys;\
mappedTextStrings= \cf7 "not mapped"\cf3 !numHotkeys;\
\
hotkeyPrefs.do(\{\cf4 |it, i|\cf3 \
	if(it[1].isNil.not and: \{it[2].isNil.not\}, \{\
		mappedTextStrings[i]= it[1]+it[2];\
	\});\
	\
	\
\});\
\
hotkeyActionItems= [\cf7 "instant record"\cf3 , \cf7 "set out to 1-2"\cf3 , \cf7 "set out to 3-4"\cf3 , \cf7 "set out to 5-6"\cf3 , \cf7 "set out to 7-8"\cf3 , \cf7 "set out to 9-10"\cf3 , \cf7 "set out to 11-12"\cf3 , \cf7 "set out to 13-14"\cf3 , \cf7 "set out to 15-16"\cf3 , \cf7 "set out to 17-18"\cf3 , \cf7 "set out to 19-20"\cf3 , \cf7 "set out to 21-22"\cf3 , \cf7 "set out to 23-24"\cf3 , \cf7 "set out to 25-26"\cf3 ];\
\
excludeNotes= ((preferences[1].asInteger)..((preferences[1].asInteger)+(preferences[0].asInteger)));\
excludeCCnums= [1]++knobsCCArray++slidersCCArray;\
\
hotkeyScrollView= \cf2 ScrollView\cf3 (w, \cf2 Rect\cf3 (10, 370, 550, 220))\
.hasBorder_(\cf5 false\cf3 );\
hotkeyView= \cf2 CompositeView\cf3 (hotkeyScrollView, \cf2 Rect\cf3 (0, 0, 530, 520))\
.background_(\cf2 Color\cf3 (0.5, 0.6, 0.59, 1.0));\
\
\cf2 StaticText\cf3 (hotkeyView, \cf2 Rect\cf3 (220, 5, 100, 20))\
.string_(\cf7 "H o t k e y s:"\cf3 )\
.align_(\cf6 \\center\cf3 )\
.background_(\cf2 Color\cf3 .grey.alpha_(0.3));\
\
numHotkeys.do(\{\cf4 |i|\cf3 \
\cf2 StaticText\cf3 (hotkeyView, \cf2 Rect\cf3 (10, 30+(i*20), 530, 16))\
.background_(\cf2 Color\cf3 .grey.alpha_(0.5))\
.string_(\cf7 "Hotkey"\cf3 +(i+1)+\cf7 ":"\cf3 );\
\
\cf2 Button\cf3 (hotkeyView, \cf2 Rect\cf3 (80, 30+(i*20), 60, 16))\
.canFocus_(\cf5 false\cf3 )\
.states_([[\cf7 "map"\cf3 ],[\cf7 "finish"\cf3 ]])\
.action_(\{\cf4 |v|\cf3 \
		if(v.value == 1, \{\
			if( learnHotkey == \cf5 false\cf3 , \{\
		learnHotkey= \cf5 true\cf3 ;\
		\cf8 //make learn responder\cf3 \
		if(midiUID.isNil.not, \{\
			\
			learnHotkeyCC= \cf2 MIDIFunc\cf3 .cc(\{\cf4 |val, num, chan|\cf3  \
			(\cf7 "learn CC"\cf3 +[val, num, chan]).postln;\
			\
			if (excludeCCnums.includes(num).not, \{\
				hotkeyType[i]= \cf6 \\control\cf3 ;\
				hotkeyNum[i]= num;\
				mappedText[i]= hotkeyType[i]+hotkeyNum[i];\
				\{v.value= 0\}.defer;\
				learnHotkeyNote.free;\
				learnHotkeyCC.free;\
			\})\
			\
			\}, srcID: midiUID); \cf8 // maybe specify channel...\cf3 \
			\
			learnHotkeyNote= \cf2 MIDIFunc\cf3 .noteOn(\{\cf4 |val, num, chan|\cf3  \
			(\cf7 "learn Note"\cf3 +[val, num, chan]).postln;\
			\
			if (excludeNotes.includes(num).not, \{\
				hotkeyType[i]= \cf6 \\noteOn\cf3 ;\
				hotkeyNum[i]= num;\
				mappedText[i]= hotkeyType[i]+hotkeyNum[i];\
				\{v.value= 0\}.defer;\
				learnHotkeyCC.free;\
				learnHotkeyNote.free;\
			\})\
			\
			\}, srcID: midiUID); \cf8 // maybe specify channel...\cf3 \
			\
		\});\
			\}, \{\
				\cf7 "only one mapping at the time!"\cf3 .postln;\
				\{v.value= 0\}.defer;\
			\}); \cf8 // endif learnhotkey false\cf3 \
	\},\{\
		\cf8 //close learn responders\cf3 \
		learnHotkeyCC.free;\
		learnHotkeyNote.free;\
		learnHotkey= \cf5 false\cf3 ;\
	\});\
\});\
\
mappedText[i]= \cf2 StaticText\cf3 (hotkeyView, \cf2 Rect\cf3 (150, 30+(i*20), 100, 20))\
.align_(\cf6 \\center\cf3 )\
.string_(mappedTextStrings[i]);\
\
\cf2 StaticText\cf3 (hotkeyView, \cf2 Rect\cf3 (260, 30+(i*20), 50, 20))\
.string_(\cf7 "Action:"\cf3 );\
\
hotkeyActionMenus= \cf2 PopUpMenu\cf3 (hotkeyView, \cf2 Rect\cf3 (300, 30+(i*20), 140, 16))\
.canFocus_(\cf5 false\cf3 )\
.items_(hotkeyActionItems)\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf0 .mouseWheelAction_(false)\cf3 \
.value_(hotkeyPrefs[i][3]);\
\
hotkeyOnOff= \cf2 Button\cf3 (hotkeyView, \cf2 Rect\cf3 (450, 30+(i*20), 60, 16))\
.canFocus_(\cf5 false\cf3 )\
.states_([[\cf7 "off"\cf3 ],[\cf7 "active"\cf3 , \cf2 Color\cf3 .black, \cf2 Color\cf3 .green]])\
.value_(hotkeyPrefs[i][0]);\
\
\});\
\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf8 // ========================== LOAD / SAVE ===============================\cf3 \
\
writeSettings= \{ \cf8 //write both setup and preferences? or have preferences override settings?\cf3 \
	\cf4 var\cf3  currentPrefs, savedText;\
	\
	\cf8 //collect info\cf3 \
	applyStates= applyButtons.collect(\{\cf4 |it, i|\cf3 \
		it.collect(\{\cf4 |it|\cf3 \
			it.value;\
		\});\
	\});\
\
	\cf8 //check paths\cf3 \
	preferencesPath.postln;\
	\cf8 //make dir for keyboard if not existing (preferencesPath++name.string), declare at top\cf3 \
	preferencesFile.postln;\
	\cf8 //(preferencesPath++name.string++"PREFS").postln;	\cf3 \
	if(preferencesPath.isFolder.not, \{preferencesPath.makeDir\});\
	\
	\cf8 //check 4 errors and SAVE\cf3 \
	if( (knobsCCArray++slidersCCArray++numKeysView.value++startKey++name).indexOf(\cf5 nil\cf3 ).isNil, \{ \
\
		currentPrefs= [numKeysView.value, startKey.value, knobsCCArray, slidersCCArray, name.string, midiInPriority, midiOutPriority, backgroundColor, midichannel, folderNames, folderRuleList, applyStates, onoffStates, mainoutputs, hotkeyPrefs];\
	\
		backup.value(preferencesFile);\
		currentPrefs.writeArchive(preferencesFile);\
\
		\{ \cf8 // confirmation text routine\cf3 \
		savedText= \cf2 StaticText\cf3 (w, \cf2 Rect\cf3 (180, 610, 150, 20)).string_(\
		\cf7 "Preferences saved!"\cf3 ).background_(\cf2 Color\cf3 .green).align_(\cf6 \\center\cf3 );\
		2.wait;\
		savedText.string= \cf7 ""\cf3 ;\
		savedText.background_(\cf2 Color\cf3 (0.0, 0.0, 0.0, 0.0));\
		\cf2 Button\cf3 (w, \cf2 Rect\cf3 (180, 610, 150, 20))\
		.states_([[\cf7 "Restart"\cf3 , \cf2 Color\cf3 .black, \cf2 Color\cf3 .green]])\
		.action_(\{\
		\cf9 thisProcess\cf3 .recompile;\
		\});\
		\}.fork(\cf2 AppClock\cf3 );\
		\
\
\
	\},\{\cf8 // Post Error Window\cf3 \
		\cf2 SCAlert\cf3 (\cf7 "some number is wrrrong"\cf3 , [\cf7 "oh!"\cf3 ]);\
	\});\
	\
\};\
\
	backup= \{\cf4 |file|\cf3 \
		\cf4 var\cf3  filename, backupname, dir;\
		dir= file.dirname;\
		filename= file.basename;\
		\
		(\cf7 "dir:"\cf3 +dir).postln;\
		(\cf7 "file:"\cf3 +file).postln;\
		\
		if (\cf2 File\cf3 .exists(file)) \{\
			backupname = filename ++ \cf7 ".backup_"\cf3  ++ \cf2 Date\cf3 .getDate.stamp;\
\
			(file).moveTo(dir, backupname);\
			(\cf7 "moved:"\cf3 +file+\cf7 "to"\cf3 +(dir++backupname)).postln;\
		\};\
	\};\
\
loadPreferences= \{\cf4 |file|\cf3 \
if(file.isFile, \{\
	preferences= \cf2 Object\cf3 .readArchive(file);\
\
	numKeysView.value= preferences[0].asInteger;\
	startKey.value= preferences[1];\
	knobsCCArray= preferences[2]; numKnobsView.value= preferences[2].size;\
	slidersCCArray= preferences[3]; numSlidersView.value= preferences[3].size;\
	\cf8 //name.string, = preferences[4];\cf3 \
	midiInPriority= preferences[5];\
	midiOutPriority= preferences[6];\
	midimenu.items.do(\{\cf4 |it, i|\cf3  if (it.contains(midiDevice), \{midimenu.value_(i)\}) \});\
	backgroundColor= preferences[7];\
	colorPicker= \cf2 ColorPicker\cf3 .hsvMini(w, \cf2 Rect\cf3 (200, 420, 50, 50), backgroundColor, \{\cf4 |clr|\cf3  backgroundColor= clr; \}, \cf5 true\cf3 );\
	if (preferences[8].isNil, \{midichannel= 1\}, \{midichannel= preferences[8]\});\
	midichannelView.value= midichannel;\
	if (preferences[9].isNil, \{folderNames= \cf2 Array\cf3 .newClear(4)\}, \{folderNames= preferences[9]\});\
	folderNamesView.do(\{\cf4 |it, i|\cf3  it.string= folderNames[i]; it.align= \cf6 \\center\cf3 ; \});\
	if (preferences[10].isNil, \{folderRuleList= defaultFolderRuleList;\},\{folderRuleList= preferences[10]\});\
	if (preferences[11].isNil.not, \{applyStates= preferences[11]\}, \{applyStates= applyStatesDefault\});\
	applyButtons.do(\{\cf4 |it, i|\cf3  it.do(\{\cf4 |itt, ii|\cf3  itt.value= applyStates[i][ii]; \}); \});\
	if (preferences[12].isNil.not, \{onoffStates= preferences[12]\}, \{onoffStates= 0!4\});\
	onoffButtons.do(\{\cf4 |it, i|\cf3  it.value= onoffStates[i]\});\
\
	\},\{ \cf7 "error reading preset file!"\cf3 .postln; \});\
\};\
\
\cf2 CompositeView\cf3 (w, \cf2 Rect\cf3 (10, 600, 1080, 40))\
.background_(\cf2 Color\cf3 (0.46268656716418, 0.47761194029851, 0.53731343283582, 1.0));\
\
\
\cf2 Button\cf3 (w, \cf2 Rect\cf3 (20, 610, 150, 20))\
.states_([[\cf7 "Save Preferences!"\cf3 , \cf2 Color\cf3 .black, \cf2 Color\cf3 (0.46268656716418, 0.86567164179104, 0.47761194029851, 1.0)]])\
.action_(\{\
	\cf4 |v|\cf3 \
	writeSettings.value;\
	savefilesWithPath= (preferencesPath++\cf7 "/*"\cf3 ).standardizePath.pathMatch;\
	savefiles= savefilesWithPath.collect(\{\cf4 |it|\cf3  it.basename\});\
	loadmenu.items= savefiles;\
	\});\
\
\
\
\cf2 StaticText\cf3 (w, \cf2 Rect\cf3 (330, 610, 180, 20))\
.string_(\cf7 "Backed up preferences:"\cf3 );\
\
savefilesWithPath= (preferencesPath++\cf7 "/*"\cf3 ).standardizePath.pathMatch;\
savefiles= savefilesWithPath.collect(\{\cf4 |it|\cf3  it.basename\});\
loadmenu= \cf2 PopUpMenu\cf3 (w, \cf2 Rect\cf3 (480, 610, 340, 20))\
.canFocus_(\cf5 false\cf3 )\
.stringColor_(\cf2 Color\cf3 .green)\
.items_( savefiles )\
.action_(\{ \cf4 |v|\cf3 \
	\cf4 var\cf3  menuitem;\
	menuitem= v.items.at(v.value);\
	\cf8 //menuitem.postln;\cf3 \
	\cf8 //savefilesWithPath[loadmenu.value].postln;\cf3 \
	\cf8 //("menu size:"+loadmenu.items.size).postln;\cf3 \
	\cf8 //("files size:"+savefiles.size).postln;\cf3 \
	\cf8 //("loadmenu fileS:"+loadmenu.items).postcs;\cf3 \
	\cf8 //("files fileS:"+savefilesWithPath).postcs;\cf3 \
\});\
\
\cf2 Button\cf3 (w, \cf2 Rect\cf3 (820, 610, 30, 20))\
.canFocus_(\cf5 false\cf3 )\
.states_([[\cf7 "L"\cf3 , \cf2 Color\cf3 .red, \cf2 Color\cf3 .black]])\
.action_(\{ \cf4 |v|\cf3 \
	(\cf7 "load preferences from:"\cf3 +savefilesWithPath[loadmenu.value]).postln;\
	loadPreferences.value(savefilesWithPath[loadmenu.value]);\
\});\
\
\
w.front;\
w.onClose= \{\
	cc1.remove; \
	cc.remove; \
	noteResponder.remove;\
	learnHotkeyCC.free;\
	learnHotkeyNote.free;\
	\cf10 ~preferencesWindows\cf3 .put(preferences[4].asSymbol, \cf5 false\cf3 );\
	\};\
\}\
\}\
\
}