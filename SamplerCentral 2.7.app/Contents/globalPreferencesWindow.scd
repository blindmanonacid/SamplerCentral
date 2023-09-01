{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf600
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;\red0\green0\blue255;\red255\green102\blue0;
\red51\green51\blue191;\red0\green0\blue191;\red96\green96\blue96;\red0\green115\blue0;\red191\green0\blue0;
\red102\green102\blue191;}
{\*\expandedcolortbl;;\csgenericrgb\c0\c0\c0;\csgenericrgb\c0\c0\c100000;\csgenericrgb\c100000\c40000\c0;
\csgenericrgb\c20000\c20000\c75000;\csgenericrgb\c0\c0\c75000;\csgenericrgb\c37500\c37500\c37500;\csgenericrgb\c0\c45000\c0;\csgenericrgb\c75000\c0\c0;
\csgenericrgb\c40000\c40000\c75000;}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 \
(\
\cf3 var\cf2  w, c;\
\cf3 var\cf2  soundcardOrder;\
\cf3 var\cf2  file, preferences, defaultPreferences;\
\cf3 var\cf2  writeSettings;\
\cf3 var\cf2  outputBusChannelView, inputBusChannelView, samplerateItems, samplerateView;\
\cf3 var\cf2  bufferSizeItems, bufferSizeView, memorySizeItems, memorySizeView;\
\cf3 var\cf2  deleteMenu, samplerFiles, samplerNames;\
\cf3 var\cf2  deleteSampler, launchSamplers;\
\
\cf4 ~globalPreferencesOpen\cf2 = \cf5 true\cf2 ;\
\
file = \cf6 String\cf2 .scDir++\cf7 "/PREFERENCES/globalPreferences"\cf2 ;\
defaultPreferences= [\cf5 nil\cf2 !4, 12, 0, 44100, 1024, 65536, \cf5 nil\cf2 !4, \cf5 nil\cf2 , \cf5 nil\cf2 , \cf5 nil\cf2 ];\
\
if( file.isFile, \{ preferences= \cf6 Object\cf2 .readArchive(file); \}, \{ preferences= defaultPreferences \});\
\
soundcardOrder= preferences[0];\
launchSamplers= preferences[6];\
\
w= \cf6 Window\cf2 (\cf7 "Global Sampler Central Settings"\cf2 , \cf6 Rect\cf2 (400, 400, 400, 580));\
\
c= \cf6 CompositeView\cf2 (w, \cf6 Rect\cf2 (10, 10, 380, 560))\
.background_(\cf6 Color\cf2 (0.5, 0.6, 0.6, 1.0));\
\
\cf6 StaticText\cf2 (w, \cf6 Rect\cf2 (10, 10, 380, 40))\
.string_(\cf7 "Global Preferences:"\cf2 )\
.align_(\cf8 \\center\cf2 )\
.font_(\cf6 Font\cf2 .new(\cf7 "Helvetica"\cf2 , 24));\
\
\cf9 // SOUND CARD CONNECTION PRIORITY\cf2 \
\cf6 StaticText\cf2 (c, \cf6 Rect\cf2 (10, 40, 360, 20))\
.string_(\cf7 "Sound Card Connection Priority:"\cf2 )\
.align_(\cf8 \\center\cf2 )\
.background_(\cf6 Color\cf2 .grey)\
.font_(\cf6 Font\cf2 .new(\cf7 "Helvetica"\cf2 , 15));\
\
soundcardOrder.do(\{\cf3 |it, i|\cf2 \
	\cf3 var\cf2  current;\
\
	\cf6 StaticText\cf2 (c, \cf6 Rect\cf2 (20, 70+(i*30), 60, 20))\
	.string_((i+1).asString++\cf7 ". Priority:"\cf2 )\
	.align_(\cf8 \\left\cf2 )\
	.font_(\cf6 Font\cf2 .new(\cf7 "Helvetica"\cf2 , 12));\
\
	current= \cf6 StaticText\cf2 (c, \cf6 Rect\cf2 (80, 70+(i*30), 130, 20))\
	.string_(it.asString)\
	.align_(\cf8 \\center\cf2 )\
	.background_(\cf6 Color\cf2 .white)\
	.font_(\cf6 Font\cf2 .new(\cf7 "Helvetica"\cf2 , 10));	\
	\
	\cf6 PopUpMenu\cf2 (c, \cf6 Rect\cf2 (210, 70+(i*30), 150, 20))\
	.items_(\cf6 ServerOptions\cf2 .outDevices)\
	.action_(\{\cf3 |v|\cf2  \
		soundcardOrder[i]= v.items[v.value];\
		current.string= v.items[v.value];\
		current.align= \cf8 \\center\cf2 ;\
		current.font= \cf6 Font\cf2 .new(\cf7 "Helvetica"\cf2 , 10);\
		\});\
\
\});\
\
\cf9 // AUDIO SETTINGS\cf2 \
\cf6 StaticText\cf2 (c, \cf6 Rect\cf2 (10, 190, 210, 20))\
.string_(\cf7 "Audio Settings:"\cf2 )\
.align_(\cf8 \\center\cf2 )\
.background_(\cf6 Color\cf2 .grey)\
.font_(\cf6 Font\cf2 .new(\cf7 "Helvetica"\cf2 , 15));\
\
\cf9 //Output Bus Channels\cf2 \
\cf6 StaticText\cf2 (c, \cf6 Rect\cf2 (20, 220, 180, 20))\
.string_(\cf7 "Output Bus Channels:"\cf2 )\
.align_(\cf8 \\left\cf2 )\
.font_(\cf6 Font\cf2 .new(\cf7 "Helvetica"\cf2 , 12));\
\
outputBusChannelView= \cf6 NumberBox\cf2 (w, \cf6 Rect\cf2 (150, 230, 30, 20))\
.value_(preferences[1].asInteger)\
.action_(\{\cf3 |v|\cf2  preferences[1]= v.value \})\
.step_(1)\
.clipLo_(2)\
.clipHi_(50);\
\
\cf9 //Input Bus Channels\cf2 \
\cf6 StaticText\cf2 (c, \cf6 Rect\cf2 (20, 250, 180, 20))\
.string_(\cf7 "Input Bus Channels:"\cf2 )\
.align_(\cf8 \\left\cf2 )\
.font_(\cf6 Font\cf2 .new(\cf7 "Helvetica"\cf2 , 12));\
\
inputBusChannelView= \cf6 NumberBox\cf2 (w, \cf6 Rect\cf2 (150, 260, 30, 20))\
.value_(preferences[2].asInteger)\
.action_(\{\cf3 |v|\cf2  preferences[2]= v.value \})\
.step_(1)\
.clipLo_(1)\
.clipHi_(50);\
\
\cf9 //Sample Rate\cf2 \
\cf6 StaticText\cf2 (c, \cf6 Rect\cf2 (20, 280, 180, 20))\
.string_(\cf7 "Sample Rate:"\cf2 )\
.align_(\cf8 \\left\cf2 )\
.font_(\cf6 Font\cf2 .new(\cf7 "Helvetica"\cf2 , 12));\
\
samplerateItems= [\\22050, \\44100, \\48000, \\96000];\
samplerateView= \cf6 PopUpMenu\cf2 (w, \cf6 Rect\cf2 (120, 290, 100, 20))\
.items_(samplerateItems)\
.value_(samplerateItems.indexOf(preferences[3].asSymbol))\
.action_(\{\cf3 |v|\cf2  preferences[3]= v.item.asInteger\});\
\
\cf9 //HW Buffer Size\cf2 \
\cf6 StaticText\cf2 (c, \cf6 Rect\cf2 (20, 310, 180, 20))\
.string_(\cf7 "HW Buffer Size:"\cf2 )\
.align_(\cf8 \\left\cf2 )\
.font_(\cf6 Font\cf2 .new(\cf7 "Helvetica"\cf2 , 12));\
\
bufferSizeItems= [\\512,\\1024, \\2048, \\4096];\
bufferSizeView= \cf6 PopUpMenu\cf2 (w, \cf6 Rect\cf2 (120, 320, 100, 20))\
.items_(bufferSizeItems)\
.value_(bufferSizeItems.indexOf(preferences[4].asSymbol))\
.action_(\{\cf3 |v|\cf2  preferences[4]= v.item.asInteger\});\
\
\cf9 //HW Memory Size\cf2 \
\cf6 StaticText\cf2 (c, \cf6 Rect\cf2 (20, 340, 180, 20))\
.string_(\cf7 "Memory Size:"\cf2 )\
.align_(\cf8 \\left\cf2 )\
.font_(\cf6 Font\cf2 .new(\cf7 "Helvetica"\cf2 , 12));\
\
memorySizeItems= [\\65536];\
memorySizeView= \cf6 PopUpMenu\cf2 (w, \cf6 Rect\cf2 (120, 350, 100, 20))\
.items_(memorySizeItems)\
.value_(memorySizeItems.indexOf(preferences[5].asSymbol))\
.action_(\{\cf3 |v|\cf2  preferences[5]= v.item.asInteger\});\
\
\
\
\cf9 // DELETE SAMPLER\cf2 \
\cf6 StaticText\cf2 (c, \cf6 Rect\cf2 (225, 190, 145, 20))\
.string_(\cf7 "Delete Sampler:"\cf2 )\
.align_(\cf8 \\center\cf2 )\
.background_(\cf6 Color\cf2 .grey)\
.font_(\cf6 Font\cf2 .new(\cf7 "Helvetica"\cf2 , 15));\
\
samplerFiles= (\cf6 String\cf2 .scDir++\cf7 "/"\cf2 ++\cf7 "SAMPLERS/*"\cf2 ).pathMatch;\
samplerNames= samplerFiles.collect(\{\cf3 |it|\cf2  it.basename.removeExtension\});\
\
\
deleteMenu= \cf6 ListView\cf2 (c,\cf6 Rect\cf2 (230,240,130,120));\
deleteMenu.items = samplerNames;\
\
\cf6 Button\cf2 (c, \cf6 Rect\cf2 (230, 220, 130, 18))\
.states_([[\cf7 "delete selected"\cf2 , \cf6 Color\cf2 .red, \cf6 Color\cf2 .black]])\
.action_(\{ deleteSampler.value(deleteMenu.item); \});\
\
\cf9 // LAUNCH SAMPLERS AT STARTUP\cf2 \
\cf6 StaticText\cf2 (c, \cf6 Rect\cf2 (10, 370, 360, 20))\
.string_(\cf7 "Launch Sampler at Startup:"\cf2 )\
.align_(\cf8 \\center\cf2 )\
.background_(\cf6 Color\cf2 .grey)\
.font_(\cf6 Font\cf2 .new(\cf7 "Helvetica"\cf2 , 15));\
\
launchSamplers.do(\{\cf3 |it, i|\cf2 \
	\cf3 var\cf2  current;\
\
	\cf6 StaticText\cf2 (c, \cf6 Rect\cf2 (20, 400+(i*30), 60, 20))\
	.string_((i+1).asString++\cf7 ". Launch:"\cf2 )\
	.align_(\cf8 \\left\cf2 )\
	.font_(\cf6 Font\cf2 .new(\cf7 "Helvetica"\cf2 , 12));\
\
	current= \cf6 StaticText\cf2 (c, \cf6 Rect\cf2 (80, 400+(i*30), 130, 20))\
	\cf9 //.string_(samplerNames[i].asString)\cf2 \
	.align_(\cf8 \\center\cf2 )\
	.background_(\cf6 Color\cf2 .white)\
	.font_(\cf6 Font\cf2 .new(\cf7 "Helvetica"\cf2 , 10));\
	if(it.isNil.not, \{current.string= (it.basename.removeExtension)\});\
	\
	\cf6 PopUpMenu\cf2 (c, \cf6 Rect\cf2 (210, 400+(i*30), 130, 20))\
	.items_(samplerNames)\
	.action_(\{\cf3 |v|\cf2 \
		launchSamplers[i]= samplerFiles[v.value];\
		current.string= v.items[v.value];\
		current.align= \cf8 \\center\cf2 ;\
		current.font= \cf6 Font\cf2 .new(\cf7 "Helvetica"\cf2 , 10);\
		\});\
	\cf6 Button\cf2 (c, \cf6 Rect\cf2 (340, 400+(i*30), 20, 20))\
	.states_([[\cf7 "rm"\cf2 , \cf6 Color\cf2 .red, \cf6 Color\cf2 .black]])\
	.action_(\{\
		launchSamplers[i]= \cf5 nil\cf2 ;\
		\{ current.string_(\cf7 ""\cf2 ) \}.defer;\
		\});\
\
\});\
\
deleteSampler= \{\cf3 |name|\cf2 \
	\cf3 var\cf2  alert, samplerFile, savefilePath, settingsFile, prefPath, nameDate;\
	\
	nameDate= name++\cf7 "_"\cf2 ++\cf6 Date\cf2 .getDate.stamp;\
	samplerFile= \cf6 String\cf2 .scDir+/+\cf7 "SAMPLERS/"\cf2 ++name++\cf7 ".scd"\cf2 ;\
	savefilePath= \cf6 String\cf2 .scDir+/+\cf7 "SAVEFILES/"\cf2 ++name;\
	settingsFile= \cf6 String\cf2 .scDir+/+\cf7 "SETTINGS/"\cf2 ++name++\cf7 "SETUP"\cf2 ;\
	prefPath= \cf6 String\cf2 .scDir+/+\cf7 "PREFERENCES/"\cf2 ++name;\
	\
	alert = \cf6 SCAlert\cf2 ( (\cf7 "Permanently delete"\cf2 +name+\cf7 "???"\cf2 ), [\cf7 "cancel"\cf2 , \cf7 "DO IT!"\cf2 ] );\
	\cf9 //a.buttonClosesWindow_( false );\cf2 \
	alert.actions_( [ \
		\{ alert.window.close \}, \cf9 // cancel closes the window\cf2 \
		\{ \
		\
		(\cf6 String\cf2 .scDir+/+\cf7 "DELETED/"\cf2 ++nameDate++\cf7 "/SAVEFILES"\cf2 ).makeDir;\
		(\cf6 String\cf2 .scDir+/+\cf7 "DELETED/"\cf2 ++nameDate++\cf7 "/PREFERENCES"\cf2 ).makeDir;\
		\
		samplerFile.moveTo(\cf6 String\cf2 .scDir+/+\cf7 "DELETED/"\cf2 ++nameDate, name);\
		savefilePath.moveTo(\cf6 String\cf2 .scDir+/+\cf7 "DELETED/"\cf2 ++nameDate++\cf7 "/SAVEFILES"\cf2 , name);\
		settingsFile.moveTo(\cf6 String\cf2 .scDir+/+\cf7 "DELETED/"\cf2 ++nameDate, name++\cf7 "SETUP"\cf2 );\
		prefPath.moveTo(\cf6 String\cf2 .scDir+/+\cf7 "DELETED/"\cf2 ++nameDate++\cf7 "/PREFERENCES"\cf2 , name);\
\
		samplerNames.removeAt(deleteMenu.value);\
		deleteMenu.items = samplerNames;\
		\} ] );\
	\};\
\
\
writeSettings= \{ \cf9 //write both setup and preferences? or have preferences override settings?\cf2 \
	\cf3 var\cf2  currentPrefs, savedText;\
\
		preferences[0]= soundcardOrder;\
		preferences[6]= launchSamplers;\
\
		currentPrefs= preferences;\
	\
		currentPrefs.writeArchive(file);\
\
		\{ \cf9 // confirmation text routine\cf2 \
		savedText= \cf6 StaticText\cf2 (w, \cf6 Rect\cf2 (200, 540, 150, 20))\
		.string_(\cf7 "Preferences saved!"\cf2 ).background_(\cf6 Color\cf2 .green).align_(\cf8 \\center\cf2 );\
		2.wait;\
		savedText.string= \cf7 ""\cf2 ;\
		savedText.background_(\cf6 Color\cf2 (0.0, 0.0, 0.0, 0.0));\
		\cf6 Button\cf2 (w, \cf6 Rect\cf2 (200, 540, 150, 20))\
		.states_([[\cf7 "Restart"\cf2 , \cf6 Color\cf2 .black, \cf6 Color\cf2 .green]])\
		.action_(\{\
		\cf10 thisProcess\cf2 .recompile;\
		\});\
		\}.fork(\cf6 AppClock\cf2 );\
	\
\};\
\
\
\cf6 Button\cf2 (w, \cf6 Rect\cf2 (30, 540, 150, 20))\
.states_([[\cf7 "Save Preferences!"\cf2 , \cf6 Color\cf2 .black, \cf6 Color\cf2 (0.46268656716418, 0.86567164179104, 0.47761194029851, 1.0)]])\
.action_(\{\
	\cf3 |v|\cf2 \
	writeSettings.value;\
	\});\
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf6 Button\cf2 (w, \cf6 Rect\cf2 (200, 540, 150, 20))\
.states_([[\cf7 "Update / merge"\cf2 , \cf6 Color\cf2 .black, \cf6 Color\cf2 .red]])\
.action_(\{\
	\cf3 |v|\cf2 \
	(\cf6 String\cf2 .scDir.dirname+/+\cf7 "Update.scd"\cf2 ).load;\
	\});\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf2 \
w.onClose= \{\
	\cf4 ~globalPreferencesOpen\cf2 = \cf5 false\cf2 ;\
	\};\
\
w.front;\
)}