{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf600
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red191\green0\blue0;\red0\green0\blue0;\red0\green0\blue255;
\red0\green0\blue191;\red255\green102\blue0;\red51\green51\blue191;\red0\green115\blue0;\red96\green96\blue96;
}
{\*\expandedcolortbl;;\csgenericrgb\c75000\c0\c0;\csgenericrgb\c0\c0\c0;\csgenericrgb\c0\c0\c100000;
\csgenericrgb\c0\c0\c75000;\csgenericrgb\c100000\c40000\c0;\csgenericrgb\c20000\c20000\c75000;\csgenericrgb\c0\c45000\c0;\csgenericrgb\c37500\c37500\c37500;
}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 // ========================\cf3 \
\cf2 // MENUUU\cf3 \
\cf2 // ========================\cf3 \
\
(\
\cf4 var\cf3  w, c, wb, nameList, actionList, homeDir, soundcardMenu;\
\cf4 var\cf3  samplerFiles, buttonColors, buttonColorsNeg;\
\cf4 var\cf3  winHeight;\
\cf4 var\cf3  soundcardOuts, soundcardOrder;\
\cf4 var\cf3  preferences, defaultPreferences, preferencesFile;\
\cf4 var\cf3  card;\
\cf4 var\cf3  midiDict, oscDict, midi2oscRespArr;\
\cf4 var\cf3  metronomeResp;\
\cf4 var\cf3  mixerSavefile, mixerSave, mixerUID;\
\
\cf2 //GUI.cocoa;\cf3 \
\cf5 GUI\cf3 .qt;\
\
\cf2 // if having trouble with too many open files:\cf3 \
\cf2 //"ulimit -u".unixCmd\cf3 \
\
s= \cf5 Server\cf3 .internal;\
\
\cf6 ~recOSC\cf3 = \cf7 false\cf3 ;\
\cf6 ~openSamplers\cf3 = \cf5 Dictionary\cf3 .new;\
\cf6 ~globalPreferencesOpen\cf3 = \cf7 false\cf3 ;\
\cf6 ~makeNewWindowOpen\cf3 = \cf7 false\cf3 ;\
\cf6 ~ableton2oscOpen\cf3 = \cf7 false\cf3 ;\
\cf6 ~joy2oscOpen\cf3 = \cf7 false\cf3 ;\
\cf6 ~mixerChans\cf3 = \cf5 Dictionary\cf3 .new;\
\cf6 ~mixerOpen\cf3 = \cf7 false\cf3 ;\
\cf6 ~conductorOpen\cf3 = \cf7 false\cf3 ;\
\cf6 ~clockOpen\cf3 = \cf7 false\cf3 ;\
\cf6 ~robotHeadWiFiOpen\cf3 = \cf7 false\cf3 ;\
\cf6 ~robotHildeOpen\cf3 = \cf7 false\cf3 ;\
\cf6 ~robotTesterOpen\cf3  = \cf7 false\cf3 ;\
\
\cf6 ~ipDict\cf3 = \cf5 Dictionary\cf3 .newFrom( \cf5 List\cf3 [\
	\cf8 \\fatBot\cf3 , [\cf9 "172.16.3.177"\cf3 , 8888],  \
	\cf8 \\circleBot\cf3 , [\cf9 "172.16.1.178"\cf3 , 8888],\
	\cf8 \\updownBot\cf3 , [\cf9 "172.16.1.180"\cf3 , 8888],\
	\cf8 \\updownEyes\cf3 , [\cf9 "172.16.1.180"\cf3 , 8888],\
	\cf8 \\updownMove\cf3 , [\cf9 "172.16.1.180"\cf3 , 8888],\
	\cf8 \\headBot\cf3 , [\cf9 "172.16.1.179"\cf3 , 8888],\
	\cf8 \\headBotEyes\cf3 , [\cf9 "172.16.1.179"\cf3 , 8888],\
	\cf8 \\headBotMouth\cf3 , [\cf9 "172.16.1.179"\cf3 , 8888],\
	\cf8 \\headBotMove\cf3 , [\cf9 "172.16.1.179"\cf3 , 8888],\
	\cf8 \\servo\cf3 , [\cf9 "172.16.1.200"\cf3 , 8888],\
	\cf8 \\servoMouth\cf3 , [\cf9 "172.16.1.200"\cf3 , 8888],\
	\cf8 \\relay8_1\cf3 , [\cf9 "172.16.1.200"\cf3 , 8888],\
	\cf8 \\relay8_2\cf3 , [\cf9 "172.16.1.200"\cf3 , 8888],\
	\cf8 \\relay8_3\cf3 , [\cf9 "172.16.1.200"\cf3 , 8888],\
	\cf8 \\relay8_4\cf3 , [\cf9 "172.16.1.200"\cf3 , 8888],\
	\cf8 \\relay8_5\cf3 , [\cf9 "172.16.1.200"\cf3 , 8888],\
	\cf8 \\relay8_6\cf3 , [\cf9 "172.16.1.200"\cf3 , 8888],\
	\cf8 \\relay8_7\cf3 , [\cf9 "172.16.1.200"\cf3 , 8888],\
	\cf8 \\relay8_8\cf3 , [\cf9 "172.16.1.200"\cf3 , 8888],\
	\cf8 \\wifi\cf3 , [\cf9 "172.16.1.6"\cf3 , 8888],\
	\cf8 \\wifiMouth\cf3 , [\cf9 "172.16.1.6"\cf3 , 8888],\
	\cf8 \\first\cf3 , [\cf9 "172.16.1.150"\cf3 , 8888],\
	\cf8 \\firstEyes\cf3 , [\cf9 "172.16.1.150"\cf3 , 8888],\
	\cf8 \\firstMouth\cf3 , [\cf9 "172.16.1.150"\cf3 , 8888],\
	\cf8 \\head2\cf3 , [\cf9 "172.16.1.151"\cf3 , 8888],\
	\cf8 \\head2Eyes\cf3 , [\cf9 "172.16.1.151"\cf3 , 8888],\
	\cf8 \\head2Mouth\cf3 , [\cf9 "172.16.1.151"\cf3 , 8888],\
	\cf8 \\head3\cf3 , [\cf9 "172.16.1.152"\cf3 , 8888],\
	\cf8 \\head3Eyes\cf3 , [\cf9 "172.16.1.152"\cf3 , 8888],\
	\cf8 \\head3Mouth\cf3 , [\cf9 "172.16.1.152"\cf3 , 8888],\
	\cf8 \\head4\cf3 , [\cf9 "172.16.1.153"\cf3 , 8888],\
	\cf8 \\head4Eyes\cf3 , [\cf9 "172.16.1.153"\cf3 , 8888],\
	\cf8 \\head4Mouth\cf3 , [\cf9 "172.16.1.153"\cf3 , 8888],\
	\cf8 \\sparkHead\cf3 , [\cf9 "172.16.1.3"\cf3 , 8888],\
	\cf8 \\sparkEyes\cf3 , [\cf9 "172.16.1.3"\cf3 , 8888],\
	\cf8 \\sparkMouth\cf3 , [\cf9 "172.16.1.3"\cf3 , 8888],\
	\cf8 \\sparkHome\cf3 , [\cf9 "172.16.1.3"\cf3 , 8888],\
	\cf8 \\max\cf3 , [\cf9 "127.0.0.1"\cf3 , 6666],\
	\cf8 \\mega\cf3 , [\cf9 "172.16.1.176"\cf3 , 8888],\
	\cf8 \\conductor\cf3 , [\cf9 "172.16.1.160"\cf3 , 8888],\
	\cf8 \\conductorRCV\cf3 , [\cf9 "172.16.1.160"\cf3 , 57120],\
	\cf8 \\clock\cf3 , [\cf9 "172.16.1.162"\cf3 , 8888],\
	\cf8 \\clock2\cf3 , [\cf9 "172.16.1.162"\cf3 , 8888],\
	\cf8 \\clockSR1\cf3 , [\cf9 "172.16.1.162"\cf3 , 8888],\
	\cf8 \\clockSR2\cf3 , [\cf9 "172.16.1.162"\cf3 , 8888],\
	\cf8 \\clockST1\cf3 , [\cf9 "172.16.1.162"\cf3 , 8888],\
	\cf8 \\clockST2\cf3 , [\cf9 "172.16.1.162"\cf3 , 8888]\
	]\
	);\
\
\cf6 ~robotDict\cf3 = ( \cf2 // label, controlSpec, initValues ([on, off], type, duration) // dur up 4 grabs!\cf3 \
	\cf8 \\fatBot\cf3 : [\cf8 \\SR1\cf3 , [0, 127, \cf8 \\lin\cf3 , 1].asSpec, [[127, 95], 0, 0.3]], \
	\cf8 \\circleBot\cf3 : [\cf8 \\SR1\cf3 , [0, 127, \cf8 \\lin\cf3 , 1].asSpec, [[100, 95], 0, 0.3]],\
	\cf8 \\conductor\cf3 : [\cf8 \\SR1\cf3 , [0, 127, \cf8 \\lin\cf3 , 1].asSpec, [[80, 100], 0, 0.3]],\
	\cf8 \\clock\cf3 : [\cf8 \\ST1\cf3 , [0, 500, \cf8 \\lin\cf3 , 1].asSpec, [[100, 0], 0, 0.3]],\
	\cf8 \\clock2\cf3 : [\cf8 \\ST2\cf3 , [0, 500, \cf8 \\lin\cf3 , 1].asSpec, [[100, 0], 0, 0.3]],\
	\cf8 \\clockSR1\cf3 : [\cf8 \\SR1\cf3 , [0, 2000, \cf8 \\lin\cf3 , 1].asSpec, [[100, 0], 0, 0.3]],\
	\cf8 \\clockSR2\cf3 : [\cf8 \\SR2\cf3 , [0, 2000, \cf8 \\lin\cf3 , 1].asSpec, [[100, 0], 0, 0.3]],\
	\cf8 \\clockST1\cf3 : [\cf8 \\ST1\cf3 , [0, 33, \cf8 \\lin\cf3 , 1].asSpec, [[100, 0], 0, 0.3]],\
	\cf8 \\clockST2\cf3 : [\cf8 \\ST2\cf3 , [0, 66, \cf8 \\lin\cf3 , 1].asSpec, [[100, 0], 0, 0.3]],\
	\cf8 \\updownBot\cf3 : [\cf8 \\SR2\cf3 , [0, 127, \cf8 \\lin\cf3 , 1].asSpec, [[127, 125], 0, 0.3]],\
	\cf8 \\updownEyes\cf3 : [\cf8 \\SR1\cf3 , [0, 127, \cf8 \\lin\cf3 , 1].asSpec, [[127, 95], 0, 0.3]],\
	\cf8 \\updownMove\cf3 : [\cf8 \\SR3\cf3 , [0, 127, \cf8 \\lin\cf3 , 1].asSpec, [[127, 100], 0, 0.3]],\
	\cf8 \\headBot\cf3 : [\cf8 \\SR2\cf3 , [0, 127, \cf8 \\lin\cf3 , 1].asSpec, [[127, 125], 0, 0.3]],\
	\cf8 \\headBotMove\cf3 : [\cf8 \\SR3\cf3 , [0, 127, \cf8 \\lin\cf3 , 1].asSpec, [[95, 95], 0, 0.3]],\
	\cf8 \\headBotMouth\cf3 : [\cf8 \\SR2\cf3 , [0, 127, \cf8 \\lin\cf3 , 1].asSpec, [[130, 125], 0, 0.3]],\
	\cf8 \\headBotEyes\cf3 : [\cf8 \\SR2\cf3 , [0, 127, \cf8 \\lin\cf3 , 1].asSpec, [[130, 125], 0, 0.3]],\
	\cf8 \\servo\cf3 : [\cf8 \\SR1\cf3 , [0, 127, \cf8 \\lin\cf3 , 1].asSpec, [[127, 65], 0, 0.3]],\
	\cf8 \\servoMouth\cf3 : [\cf8 \\SR2\cf3 , [0, 127, \cf8 \\lin\cf3 , 1].asSpec, [[80, 127], 0, 0.3]],\
	\cf8 \\relay8_1\cf3 : [\cf8 \\RL1\cf3 , [0, 1, \cf8 \\lin\cf3 , 1].asSpec, [[0, 1], 0, 0.3]],\
	\cf8 \\relay8_2\cf3 : [\cf8 \\RL2\cf3 , [0, 1, \cf8 \\lin\cf3 , 1].asSpec, [[0, 1], 0, 0.3]],\
	\cf8 \\relay8_3\cf3 : [\cf8 \\RL3\cf3 , [0, 1, \cf8 \\lin\cf3 , 1].asSpec, [[0, 1], 0, 0.3]],\
	\cf8 \\relay8_4\cf3 : [\cf8 \\RL4\cf3 , [0, 1, \cf8 \\lin\cf3 , 1].asSpec, [[0, 1], 0, 0.3]],\
	\cf8 \\relay8_5\cf3 : [\cf8 \\RL5\cf3 , [0, 1, \cf8 \\lin\cf3 , 1].asSpec, [[0, 1], 0, 0.3]],\
	\cf8 \\relay8_6\cf3 : [\cf8 \\RL6\cf3 , [0, 1, \cf8 \\lin\cf3 , 1].asSpec, [[0, 1], 0, 0.3]],\
	\cf8 \\relay8_7\cf3 : [\cf8 \\RL7\cf3 , [0, 1, \cf8 \\lin\cf3 , 1].asSpec, [[0, 1], 0, 0.3]],\
	\cf8 \\relay8_8\cf3 : [\cf8 \\RL8\cf3 , [0, 1, \cf8 \\lin\cf3 , 1].asSpec, [[0, 1], 0, 0.3]],\
	\cf8 \\wifi\cf3 : [\cf8 \\SR2\cf3 , [0, 180, \cf8 \\lin\cf3 , 1].asSpec, [[80, 64], 0, 0.3]],\
	\cf8 \\wifiMouth\cf3 : [\cf8 \\SR2\cf3 , [0, 180, \cf8 \\lin\cf3 , 1].asSpec, [[100, 130], 0, 0.3]],\
	\cf8 \\firstEyes\cf3 : [\cf8 \\SR1\cf3 , [0, 180, \cf8 \\lin\cf3 , 1].asSpec, [[130, 90], 0, 0.3]],\
	\cf8 \\firstMouth\cf3 : [\cf8 \\SR2\cf3 , [0, 180, \cf8 \\lin\cf3 , 1].asSpec, [[100, 130], 0, 0.3]],\
	\cf8 \\head2\cf3 : [\cf8 \\SR2\cf3 , [0, 180, \cf8 \\lin\cf3 , 1].asSpec, [[100, 130], 0, 0.3]],\
	\cf8 \\head2Eyes\cf3 : [\cf8 \\SR1\cf3 , [0, 180, \cf8 \\lin\cf3 , 1].asSpec, [[130, 90], 0, 0.3]],\
	\cf8 \\head2Mouth\cf3 : [\cf8 \\SR2\cf3 , [0, 180, \cf8 \\lin\cf3 , 1].asSpec, [[100, 130], 0, 0.3]],\
	\cf8 \\head3\cf3 : [\cf8 \\SR2\cf3 , [0, 180, \cf8 \\lin\cf3 , 1].asSpec, [[130, 130], 0, 0.3]],\
	\cf8 \\head3Eyes\cf3 : [\cf8 \\SR1\cf3 , [0, 180, \cf8 \\lin\cf3 , 1].asSpec, [[130, 90], 0, 0.3]],\
	\cf8 \\head3Mouth\cf3 : [\cf8 \\SR2\cf3 , [0, 180, \cf8 \\lin\cf3 , 1].asSpec, [[100, 130], 0, 0.3]],\
	\cf8 \\head4\cf3 : [\cf8 \\SR2\cf3 , [0, 180, \cf8 \\lin\cf3 , 1].asSpec, [[130, 130], 0, 0.3]],\
	\cf8 \\head4Eyes\cf3 : [\cf8 \\SR1\cf3 , [0, 180, \cf8 \\lin\cf3 , 1].asSpec, [[130, 90], 0, 0.3]],\
	\cf8 \\head4Mouth\cf3 : [\cf8 \\SR2\cf3 , [0, 180, \cf8 \\lin\cf3 , 1].asSpec, [[100, 130], 0, 0.3]],\
	\cf8 \\sparkHead\cf3 : [\cf8 \\SR2\cf3 , [0, 180, \cf8 \\lin\cf3 , 1].asSpec, [[100, 130], 0, 0.3]],\
	\cf8 \\sparkEyes\cf3 : [\cf8 \\SR1\cf3 , [0, 180, \cf8 \\lin\cf3 , 1].asSpec, [[100, 90], 0, 0.3]],\
	\cf8 \\sparkMouth\cf3 : [\cf8 \\SR2\cf3 , [0, 180, \cf8 \\lin\cf3 , 1].asSpec, [[100, 130], 0, 0.3]],\
	\cf8 \\sparkHome\cf3 : [\cf8 \\SR1\cf3 , [0, 180, \cf8 \\lin\cf3 , 1].asSpec, [[100, 130], 0, 0.3]],\
	\cf8 \\max\cf3 : [\cf9 "/dmx"\cf3 , [0, 180, \cf8 \\lin\cf3 , 1].asSpec, [[100, 130], 0, 0.3]],\
	\cf8 \\mega\cf3 : [\cf8 \\SR1\cf3 , [0, 180, \cf8 \\lin\cf3 , 1].asSpec, [[100, 130], 0, 0.3]],\
	\cf8 \\megaEyes\cf3 : [\cf8 \\SR1\cf3 , [0, 180, \cf8 \\lin\cf3 , 1].asSpec, [[100, 130], 0, 0.3]],\
	\cf8 \\megaMouth\cf3 : [\cf8 \\SR2\cf3 , [0, 180, \cf8 \\lin\cf3 , 1].asSpec, [[100, 130], 0, 0.3]]\
	);\
\
midiDict= \cf5 Dictionary\cf3 .new;\
midiDict.putPairs([21, \cf9 "SR1"\cf3 , 22, \cf9 "SR2"\cf3 , 23, \cf9 "SR3"\cf3 , 24, \cf9 "SR4"\cf3 , 25, \cf9 "SR5"\cf3 , 26, \cf9 "SR6"\cf3 , 27, \cf9 "SR7"\cf3 , 28, \cf9 "SR8"\cf3 , 29, \cf9 "SR9"\cf3 , 30, \cf9 "BRK"\cf3 , 41, \cf9 "RL1"\cf3 , 42, \cf9 "RL2"\cf3 , 43, \cf9 "RL3"\cf3 , 44, \cf9 "RL4"\cf3 , 45, \cf9 "RL5"\cf3 , 46, \cf9 "RL6"\cf3 , 47, \cf9 "RL7"\cf3 , 48, \cf9 "RL8"\cf3 , 49, \cf9 "RL9"\cf3 ]);\
oscDict= \cf5 Dictionary\cf3 .new;\
oscDict.putPairs([1, \cf8 \\updownBot\cf3 , 2, \cf8 \\head2\cf3 , 3, \cf8 \\head3\cf3 , 4, \cf8 \\head4\cf3 , 5, \cf8 \\head5\cf3 , 6, \cf8 \\sparkHead\cf3 , 7, \cf8 \\circleBot\cf3 , 8, \cf8 \\headBot\cf3 ]);\
\
midi2oscRespArr= \cf5 List\cf3 .new;\
\
preferencesFile = \cf5 String\cf3 .scDir++\cf9 "/PREFERENCES/globalPreferences"\cf3 ;\
defaultPreferences= [\cf7 nil\cf3 !4, 12, 0, 44100, 1024, 65536, \cf7 nil\cf3 !4, \cf7 nil\cf3 , \cf7 nil\cf3 , \cf7 nil\cf3 ];\
\
if( preferencesFile.isFile, \
	\{ preferences= \cf5 Object\cf3 .readArchive(preferencesFile); \}, \
	\{ preferences= defaultPreferences \}\
);\
\
soundcardOrder= preferences[0];\
\
soundcardOuts= \cf5 ServerOptions\cf3 .outDevices;\
\
samplerFiles= (\cf5 String\cf3 .scDir+/+\cf9 "SAMPLERS/*"\cf3 ).pathMatch;\
\
\cf6 ~samplerNames\cf3 = samplerFiles.collect(\{\cf4 |it|\cf3  it.basename.removeExtension\});\
\
\cf6 ~openSamplers\cf3 = \cf5 Dictionary\cf3 .new;\
\cf6 ~samplerNames\cf3 .do(\{\cf4 |it|\cf3 \
	\cf6 ~openSamplers\cf3 .put(it.asSymbol, \cf7 true\cf3 );\
\});\
\
\cf2 // ================ MIXER ===============\cf3 \
\
mixerSavefile= \cf5 String\cf3 .scDir++\cf9 "/MIXERSAVES/mixersave"\cf3 ;\
\
if(mixerSavefile.isFile, \{ \
	mixerSave= \cf5 Object\cf3 .readArchive(mixerSavefile); \
	mixerUID= mixerSave[2];\
	\cf6 ~mixerMap\cf3 = mixerSave[3];\
	if (\cf5 MIDIIn\cf3 .findPort(mixerSave[0], mixerSave[1]).isNil.not, \{\
		\
		\cf5 MIDIIn\cf3 .connectByUID(0, mixerUID);\
		\cf6 ~mixerController\cf3 = (mixerSave[0]+mixerSave[1]);\
		\
		\cf6 ~mixerResponder\cf3 = \cf5 MIDIFunc\cf3 .cc(\{\cf4 |val, num, chan|\cf3 \
			if (\cf6 ~mixerMap\cf3 [num].isNil.not, \{\
				if (\cf6 ~mixerChans\cf3 [\cf6 ~mixerMap\cf3 [num][0]].isNil.not, \{ \cf2 // set keyboard\cf3 \
				\
				if (\cf6 ~mixerMap\cf3 [num][1] == \cf8 \\pan\cf3 , \{\
					\cf6 ~mixerChans\cf3 [\cf6 ~mixerMap\cf3 [num][0]][0].set(\cf6 ~mixerMap\cf3 [num][1], (val/127)); \cf2 // synth\cf3 \
					\{ \cf6 ~mixerChans\cf3 [\cf6 ~mixerMap\cf3 [num][0]][1].value= (val/127) \}.defer;\
				\});\
				if (\cf6 ~mixerMap\cf3 [num][1] == \cf8 \\vol\cf3 , \{\
					\cf6 ~mixerChans\cf3 [\cf6 ~mixerMap\cf3 [num][0]][0].set(\cf8 \\amp\cf3 , (val/127)); \cf2 // synth\cf3 \
					\{ \cf6 ~mixerChans\cf3 [\cf6 ~mixerMap\cf3 [num][0]][2].value= (val/127) \}.defer;\
				\});\
				\
				\});\
				\
				if (\cf6 ~mixerOpen\cf3  == \cf7 true\cf3 , \{\
					\cf2 //~mixerMap[num][0].postln;\cf3 \
					\cf2 //~chanStrip.postln;\cf3 \
					\cf2 //~chanStrip[~mixerMap[num][0]].postln;\cf3 \
					\
					\{ \cf6 ~chanStrip\cf3 [\cf6 ~mixerMap\cf3 [num][0]][\cf6 ~mixerMap\cf3 [num][1]].value= (val/127) \}.defer;\
				\});\
			\});\
\
			\}, srcID: mixerUID); \cf2 // maybe specify channel...\cf3 \
		\});\
\});\
\
\
\cf2 // ================== GUI =====================\cf3 \
\
winHeight= (15*samplerFiles.size)+295;\
\
w= \cf5 Window\cf3 (\cf9 ""\cf3 , \cf5 Rect\cf3 (\cf5 Window\cf3 .screenBounds.width-100, 675, 100, winHeight));\
wb= w.bounds;\
c= \cf5 VLayoutView\cf3 (w, \cf5 Rect\cf3 (0, 30, wb.width, wb.height-30));\
\
\cf5 StaticText\cf3 (w, \cf5 Rect\cf3 (0, 10, 100, 15))\
.string_(\cf9 "SAMPLERS"\cf3 )\
.font_(\cf5 Font\cf3 (\cf9 "Helvetica"\cf3 , 15))\
.align_(\cf8 \\center\cf3 );\
\
nameList= \cf6 ~samplerNames\cf3 ;\
actionList= samplerFiles;\
\
\cf2 //get background colors\cf3 \
buttonColors= \cf6 ~samplerNames\cf3 .collect(\{\cf4 |it|\cf3 \
	\cf4 var\cf3  file, prefs, color;\
	file= \cf5 String\cf3 .scDir++\cf9 "/PREFERENCES/"\cf3 ++it++\cf9 "/"\cf3 ++it++\cf9 "_CURRENT"\cf3 ;\
	if(file.isFile, \{\
		prefs= \cf5 Object\cf3 .readArchive(file);\
		color= prefs[7];\
	\}, \{\
		color= \cf5 Color\cf3 .white;	\
	\});\
	\
\});\
\
\cf2 /*\
buttonColorsNeg= buttonColors.collect(\{|it|\
	Color(it.red.neg+1, it.green.neg+1, it.blue.neg+1, 1.0);\
\});\
\
\
buttonColorsNeg= buttonColors.collect(\{|it|\
	var r, g, b;\
	if(it.red < 0.5, \{r= 1\}, \{r= 0\});\
	if(it.green < 0.5, \{g= 1\}, \{g= 0\});\
	if(it.blue < 0.5, \{b= 1\}, \{b= 0\});\
	Color(r, g, b, 1.0);\
\});\
*/\cf3 \
\
buttonColorsNeg= buttonColors.collect(\{\cf4 |it|\cf3 \
	if((it.red+it.green+it.blue) < 1.5,  \{\cf5 Color\cf3 .white\}, \{\cf5 Color\cf3 .black\});\
\});\
\
nameList.size.do(\{ \cf4 |i|\cf3 \
	\cf5 Button\cf3 (c, 50@15)\
	.states_([[nameList[i], buttonColorsNeg[i], buttonColors[i]]])\
	.canFocus_(\cf7 false\cf3 )\
	.action_(\{\
		if(\cf6 ~openSamplers\cf3 [\cf6 ~samplerNames\cf3 [i].asSymbol], \{actionList[i].load; \cf6 ~openSamplers\cf3 [\cf6 ~samplerNames\cf3 [i].asSymbol]= \cf7 false\cf3  \})\
	\})\
	.mouseDownAction_(\{ \cf4 |view, x, y, mod|\cf3 \
			if (mod.isShift, \{ \cf5 Document\cf3 .open(actionList[i]); \});\
		\})\
\});\
\
\cf5 StaticText\cf3 (c, \cf5 Rect\cf3 (0, 0, 50, 10))\
.string_(\cf9 "s o u n d c a r d"\cf3 )\
.font_(\cf5 Font\cf3 (\cf9 "Helvetica"\cf3 , 10))\
.align_(\cf8 \\center\cf3 );\
\
soundcardMenu= \cf5 PopUpMenu\cf3 (c, (\cf5 Rect\cf3 (0, 0, 50, 20)))\
.canFocus_(\cf7 false\cf3 )\
.items_(soundcardOuts)\
.value_(0)\
.action_(\{ \cf4 |v|\cf3 \
	s.options.outDevice= soundcardOuts[v.value]\
	\});\
\
\cf5 Button\cf3 (c, 50@15)\
	.states_([[\cf9 "MAKE NEW"\cf3 , \cf5 Color\cf3 .white,\cf5 Color\cf3 .grey]])\
	.canFocus_(\cf7 false\cf3 )\
	.action_(\{\
	if( \cf6 ~makeNewWindowOpen\cf3  == \cf7 false\cf3 , \{\
	((\cf5 String\cf3 .scDir).dirname++\cf9 "/makeNewSampler.scd"\cf3 ).standardizePath.load;\
	\});\
	\});\
\
\cf5 Button\cf3 (c, 50@15)\
	.states_([[\cf9 "global setup"\cf3 , \cf5 Color\cf3 .white,\cf5 Color\cf3 .black]])\
	.canFocus_(\cf7 false\cf3 )\
	.action_(\{\
	if( \cf6 ~globalPreferencesOpen\cf3  == \cf7 false\cf3 , \{\
	((\cf5 String\cf3 .scDir).dirname++\cf9 "/globalPreferencesWindow.scd"\cf3 ).standardizePath.load;\
	\});\
	\});\
	\
\cf5 Button\cf3 (c, 50@15)\
.states_([ [ \cf9 "mixer"\cf3 , \cf5 Color\cf3 .black, \cf5 Color\cf3 .green ] ])\
.canFocus_(\cf7 false\cf3 )\
.action_(\{\cf4 |v|\cf3 \
	if(\cf6 ~mixerOpen\cf3 == \cf7 false\cf3 , \{\
		if(\cf6 ~openSamplers\cf3 .values.includes(\cf7 false\cf3 ), \{\
			((\cf5 String\cf3 .scDir).dirname++\cf9 "/mixer.scd"\cf3 ).standardizePath.load;\
		\});\
	\},\{\
	\cf6 ~mixerWindow\cf3 .front;	\
	\});\
\});\
\
\cf5 Button\cf3 (c, 50@15)\
	.states_([[\cf9 "Rec OSC"\cf3 , \cf5 Color\cf3 .black,\cf5 Color\cf3 .red]])\
	.canFocus_(\cf7 false\cf3 )\
	.action_(\{\
	((\cf5 String\cf3 .scDir).dirname++\cf9 "/OSCRecGUI.scd"\cf3 ).standardizePath.load;\
	\});\
\
\cf5 Button\cf3 (c, 50@15)\
	.states_([[\cf9 "re-init midi"\cf3 , \cf5 Color\cf3 .blue,\cf5 Color\cf3 .grey]])\
	.canFocus_(\cf7 false\cf3 )\
	.action_(\{ \cf5 MIDIClient\cf3 .init; \});\
\
\cf2 /*\
Button(c, 50@15)\
.states_([ [ "recAbleton", Color.black, Color.yellow ] ])\
.canFocus_(false)\
.action_(\{|v|\
	if(~ableton2oscOpen== false, \{\
		((String.scDir).dirname++"/ableton2osc.scd").standardizePath.load;\
	\});\
\});\
\
Button(c, 50@15)\
.states_([ [ "recJoystick", Color.black, Color.yellow ] ])\
.canFocus_(false)\
.action_(\{|v|\
	if(~joy2oscOpen== false, \{\
		((String.scDir).dirname++"/joy2osc2.scd").standardizePath.load;\
	\});\
\});\
\
*/\cf3 \
\
\cf5 Button\cf3 (c, 50@15)\
	.states_([[\cf9 "qlab2osc off"\cf3 , \cf5 Color\cf3 .white,\cf5 Color\cf3 .grey], [\cf9 "qlab2osc on"\cf3 , \cf5 Color\cf3 .white,\cf5 Color\cf3 .green]])\
	.canFocus_(\cf7 false\cf3 )\
	.action_(\{ \cf4 |v|\cf3 \
		if(v.value==1, \{\
			\cf5 MIDIClient\cf3 .sources.do(\{\cf4 |it, i|\cf3 \
				\cf4 var\cf3  busNum, uid, resp;\
				if(it.name.contains(\cf9 "IAC"\cf3 ), \{\
					uid= it.uid;\
					busNum= it.name.last.asString.asInteger;\
					[oscDict[busNum], uid, \cf6 ~ipDict\cf3 [oscDict[busNum]]].postln;\
					resp= \cf5 MIDIFunc\cf3 .cc(\{\cf4 |val, cc, chan|\cf3 \
						if(midiDict[cc].notNil, \{\
							\cf5 NetAddr\cf3 (\cf6 ~ipDict\cf3 [oscDict[busNum]][0], \cf6 ~ipDict\cf3 [oscDict[busNum]][1] ).sendMsg(midiDict[cc]++((val/100)*127).floor);\
							\cf2 //[val, cc, chan].postln;\cf3 \
							\cf2 //(midiDict[cc]++((val/100)*127).floor).postln;\cf3 \
							\});\
					\}, srcID: uid );\
				midi2oscRespArr.add(resp);\
				\cf5 MIDIIn\cf3 .connectByUID(0, uid);\
				\});\
			\});\
			midi2oscRespArr.postln;\
			\}, \{\
			midi2oscRespArr.do(\{\cf4 |it|\cf3  it.free \});\
				\
		\});\
	\});\
\
\cf5 Button\cf3 (c, 50@15)\
	.states_([[\cf9 "conductor arm"\cf3 , \cf5 Color\cf3 .white,\cf5 Color\cf3 .grey]])\
	.canFocus_(\cf7 false\cf3 )\
	.action_(\{ \cf4 |v|\cf3 \
			if(\cf6 ~conductorOpen\cf3  == \cf7 false\cf3 , \{ (\cf5 String\cf3 .scDir.dirname+/+\cf9 "conductor.scd"\cf3 ).load; \
			\cf6 ~conductorOpen\cf3 = \cf7 true\cf3 ;\
			\});\
\});				\
\
\cf5 Button\cf3 (c, 50@15)\
	.states_([[\cf9 "Clock"\cf3 , \cf5 Color\cf3 .white,\cf5 Color\cf3 .grey]])\
	.canFocus_(\cf7 false\cf3 )\
	.action_(\{ \cf4 |v|\cf3 \
\
			if(\cf6 ~clockOpen\cf3  == \cf7 false\cf3 , \{ (\cf5 String\cf3 .scDir.dirname+/+\cf9 "Clock.scd"\cf3 ).load; \
				\cf6 ~clockOpen\cf3 = \cf7 true\cf3 ;\
			\});\
\});\
\
\cf5 Button\cf3 (c, 50@15)\
	.states_([[\cf9 "RobotHeadWiFi"\cf3 , \cf5 Color\cf3 .white,\cf5 Color\cf3 .grey]])\
	.canFocus_(\cf7 false\cf3 )\
	.action_(\{ \cf4 |v|\cf3 \
		if(\cf6 ~robotTesterOpen\cf3  == \cf7 false\cf3 , \{\
			if(\cf6 ~robotHeadWiFiOpen\cf3  == \cf7 false\cf3 , \{\
				if(\cf6 ~robotHildeOpen\cf3  == \cf7 false\cf3 , \{\
					(\cf5 String\cf3 .scDir.dirname+/+\cf9 "robotHeadWiFi.scd"\cf3 ).load;\
					\cf6 ~robotHeadWiFiOpen\cf3 = \cf7 true\cf3 ;\
				\});\
			\});\
		\});\
\});\
\
\cf5 Button\cf3 (c, 50@15)\
	.states_([[\cf9 "RobotHILDE"\cf3 , \cf5 Color\cf3 .white,\cf5 Color\cf3 .grey]])\
	.canFocus_(\cf7 false\cf3 )\
	.action_(\{ \cf4 |v|\cf3 \
		if(\cf6 ~robotTesterOpen\cf3  == \cf7 false\cf3 , \{\
			if(\cf6 ~robotHeadWiFiOpen\cf3  == \cf7 false\cf3 , \{\
				if(\cf6 ~robotHildeOpen\cf3  == \cf7 false\cf3 , \{\
					(\cf5 String\cf3 .scDir.dirname+/+\cf9 "robotHILDE.scd"\cf3 ).load;\
					\cf6 ~robotHildeOpen\cf3 = \cf7 true\cf3 ;\
				\});\
			\});\
		\});\
\});\
\
\cf5 Button\cf3 (c, 50@15)\
	.states_([[\cf9 "RobotTESTER"\cf3 , \cf5 Color\cf3 .white,\cf5 Color\cf3 .grey]])\
	.canFocus_(\cf7 false\cf3 )\
	.action_(\{ \cf4 |v|\cf3 \
\
			if(\cf6 ~robotTesterOpen\cf3  == \cf7 false\cf3 , \{\
				if(\cf6 ~robotHildeOpen\cf3  == \cf7 false\cf3 , \{\
					if(\cf6 ~robotHildeOpen\cf3  == \cf7 false\cf3 , \{\
						(\cf5 String\cf3 .scDir.dirname+/+\cf9 "robotTESTER.scd"\cf3 ).load;\
						\cf6 ~robotTesterOpen\cf3 = \cf7 true\cf3 ;\
					\});\
				\});\
			\});\
\});\
\
\cf5 Button\cf3 (c, 50@15)\
	.states_([[\cf9 "kill all sound"\cf3 , \cf5 Color\cf3 .red,\cf5 Color\cf3 .grey]])\
	.canFocus_(\cf7 false\cf3 )\
	.action_(\{ \cf5 Server\cf3 .killAll; \});\
	\
\cf5 Button\cf3 (c, 50@15)\
	.states_([[\cf9 "H E L P"\cf3 , \cf5 Color\cf3 .black,\cf5 Color\cf3 .white]])\
	.canFocus_(\cf7 false\cf3 )\
	.action_(\{ (\cf5 String\cf3 .scDir+/+\cf9 "Help2/Help.rtf"\cf3 ).openDocument; \});\
\
\cf5 DragSink\cf3 (c, 50@40)\
	.canFocus_(\cf7 false\cf3 )\
	.string_(\cf9 "post tags"\cf3 )\
	.align_(\cf8 \\center\cf3 )\
	\cf2 //.canReceiveDragHandler_(\{ true \});\cf3 \
	.receiveDragHandler_(\{ \cf4 arg\cf3  v;\
		\cf5 View\cf3 .currentDrag.value.class.postln;\
		\cf5 View\cf3 .currentDrag.value.postln;\
		(\cf9 "Tags for file"\cf3 +\cf5 View\cf3 .currentDrag.value.basename++\cf9 ":"\cf3 ).postln;\
\'a0 \'a0 \'a0	\cf5 View\cf3 .currentDrag.value.getTags.postln;\
\});\
\
\{\
soundcardOrder.size.do(\{\cf4 |it, i|\cf3 \
	\cf4 var\cf3  check;\
	i= ((soundcardOrder.size-1) - i);\
\
	check= soundcardOuts.detect(\{\cf4 |it|\cf3 \
		it == soundcardOrder[i]\
	\});\
	if (check.isNil.not, \{card= check\});\
\});\
\
if (card.isNil.not, \{soundcardMenu.value= soundcardMenu.items.indexOf(card); s.options.outDevice= card\},\{ s.options.device= \cf7 nil\cf3 ; \});\
\}.value;\
\
w.view.keyDownAction= \{\cf4 |view, char, mod|\cf3 \
\cf2 //[view, char, mod, char.class].postln;\cf3 \
case \
	\{char === $l\} \{ s.tryPerform(\cf8 \\meter\cf3 ) \}\
	\{char === $p\} \{ \cf5 Document\cf3 .open(\cf5 String\cf3 .scDir.dirname+/+\cf9 "loadMenu.sc"\cf3 ) \};\
\};\
\
w.front;\
\cf2 //MIDIClient.init;\cf3 \
\
\cf2 //s.options.memSize= preferences[5];\cf3 \
s.options.memSize= 256 * 1024; \cf2 // 256 mb\cf3 \
s.options.numOutputBusChannels= preferences[1];\
s.options.numInputBusChannels= preferences[2];\
s.options.sampleRate= preferences[3];\
s.options.hardwareBufferSize= preferences[4];\
\
(\cf9 "num outts:"\cf3 +preferences[1]).postln;\
\
\cf2 //LAUNCH SAMPLER AT STARTUP\cf3 \
preferences[6].do(\{\cf4 |it, i|\cf3 \
	\{\
		if(it.isNil.not && \{it.isFile\}, \{\
			samplerFiles.do(\{ \cf4 |sf|\cf3 \
				if(sf == it, \{\
					it.load; \cf6 ~openSamplers\cf3 [(it.basename.removeExtension).asSymbol]= \cf7 false\cf3 ; 1.wait; \});\
			\});\
		\});\
	\}.fork(\cf5 AppClock\cf3 );\
\});\
\
\
if(\cf9 "/Users/martin/scwork/samplerProject/autoBackup"\cf3 .isFolder, \{\
	\cf5 AutoBackup\cf3 .backupFolder= \cf9 "/Users/martin/scwork/samplerProject/autoBackup/"\cf3 ;\
	\cf5 AutoBackup\cf3 .start;\
	\});\
	\
w.onClose = \{\
	if (\cf6 ~mixerResponder\cf3 .isNil.not, \{ \cf6 ~mixerResponder\cf3 .free; \cf5 MIDIIn\cf3 .disconnectByUID(0, mixerUID); \})\
\};\
\
)\
\
}