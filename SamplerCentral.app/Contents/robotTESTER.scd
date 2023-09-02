{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf600
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;\red0\green0\blue255;\red51\green51\blue191;
\red255\green102\blue0;\red0\green0\blue191;\red96\green96\blue96;\red191\green0\blue0;\red0\green115\blue0;
}
{\*\expandedcolortbl;;\csgenericrgb\c0\c0\c0;\csgenericrgb\c0\c0\c100000;\csgenericrgb\c20000\c20000\c75000;
\csgenericrgb\c100000\c40000\c0;\csgenericrgb\c0\c0\c75000;\csgenericrgb\c37500\c37500\c37500;\csgenericrgb\c75000\c0\c0;\csgenericrgb\c0\c45000\c0;
}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 \
(\
\cf3 var\cf2  n, gpResponder, w, sliderRT, joyHSlider, eyeVal= 0, eyeValPrev= 0, mouthVal= 0, mouthValPrev= 0;\
\cf3 var\cf2  moveVal= 0, moveValPrev= 0, buttonView, butX, butY, butA, butB, butOffsetH, butOffsetV;\
\cf3 var\cf2  numb, butsValPrev= 0, butGUIArray, butL1, butR1, sliderLT;\
\cf3 var\cf2  dpadOffsetH, dpadOffsetV, upBut, downBut, leftBut, rightBut, dpadValPrev, dpadGUIArray;\
\cf3 var\cf2  joyVSlider;\
\cf3 var\cf2  ltValPrev, rtValPrev, j2hValPrev, j2vValPrev;\
\cf3 var\cf2  robotNames, inputNames, controlNames, robotMenus, robotMenuMain, dict, activeRobots;\
\cf3 var\cf2  minButs, maxButs, ctrlMenus, sendButs, lastVals;\
\cf3 var\cf2  joyL, joyR, j1hValPrev, j1vValPrev;\
\cf3 var\cf2  presetMenu, controlNamesSymbols, netAddrs, verbose= 0, ableton, enableton;\
\cf3 var\cf2  ccVals, m, controlNamesCheck, localmachine, lastCCVals, abletonResponders;\
\
numb= \cf4 nil\cf2 !14;\
\
enableton= \cf4 false\cf2 ;\
\
\cf5 ~robotTesterOpen\cf2 = \cf4 true\cf2 ;\
\
w= \cf6 Window\cf2 (\cf7 "RobotTESTER"\cf2 , \cf6 Rect\cf2 (\cf6 Window\cf2 .screenBounds.width, \cf6 Window\cf2 .screenBounds.height, 440, 720)).alwaysOnTop_(\cf4 true\cf2 ).front;\
\
\
\
butL1= \cf6 Button\cf2 (w, \cf6 Rect\cf2 (70, 10, 90, 20))\
.canFocus_(\cf4 false\cf2 )\
.states_([[ \cf7 "LB"\cf2 , \cf6 Color\cf2 .white, \cf6 Color\cf2 .grey ],  [\cf7 "LB"\cf2 , \cf6 Color\cf2 .black, \cf6 Color\cf2 .white]] );\
\
butR1= \cf6 Button\cf2 (w, \cf6 Rect\cf2 (280, 10, 90, 20))\
.canFocus_(\cf4 false\cf2 )\
.states_([[ \cf7 "RB"\cf2 , \cf6 Color\cf2 .white, \cf6 Color\cf2 .grey ],  [\cf7 "RB"\cf2 , \cf6 Color\cf2 .black, \cf6 Color\cf2 .white]] );\
\
\cf8 // ======= DPAD\cf2 \
\
dpadOffsetH= 90;\
dpadOffsetV= 138;\
\
leftBut= \cf6 RoundButton\cf2 ( w, \cf6 Rect\cf2 (0+dpadOffsetH, 30+dpadOffsetV, 30, 30 ))\
.canFocus_(\cf4 false\cf2 )\
.states_([[ \cf9 \\back\cf2 , \cf6 Color\cf2 .white(0.5), \cf6 Color\cf2 .grey ],  [\cf9 \\back\cf2 , \cf6 Color\cf2 .black(0.5), \cf6 Color\cf2 .white(0.6) ]] )\
.action_(\{ \cf7 "left was hit"\cf2 .postln \});\
\
upBut= \cf6 RoundButton\cf2 ( w, \cf6 Rect\cf2 (30+dpadOffsetH, 0+dpadOffsetV, 30, 30 ))\
.canFocus_(\cf4 false\cf2 )\
.states_([[ \cf9 \\up\cf2 , \cf6 Color\cf2 .white(0.5), \cf6 Color\cf2 .grey ], [ \cf9 \\up\cf2 , \cf6 Color\cf2 .black(0.5), \cf6 Color\cf2 .white(0.6) ]] )\
.action_(\{ \cf7 "up was hit"\cf2 .postln \});\
\
downBut= \cf6 RoundButton\cf2 ( w, \cf6 Rect\cf2 (30+dpadOffsetH, 60+dpadOffsetV, 30, 30 ))\
.canFocus_(\cf4 false\cf2 )\
.states_([[ \cf9 \\down\cf2 , \cf6 Color\cf2 .white(0.5), \cf6 Color\cf2 .grey ], [ \cf9 \\down\cf2 , \cf6 Color\cf2 .black(0.5), \cf6 Color\cf2 .white(0.6) ]] )\
.action_(\{ \cf7 "down was hit"\cf2 .postln \});\
\
rightBut= \cf6 RoundButton\cf2 ( w, \cf6 Rect\cf2 (60+dpadOffsetH, 30+dpadOffsetV, 30, 30 ))\
.canFocus_(\cf4 false\cf2 )\
.states_([[ \cf9 \\play\cf2 , \cf6 Color\cf2 .white(0.5), \cf6 Color\cf2 .grey ], [\cf9 \\play\cf2 , \cf6 Color\cf2 .black(0.5), \cf6 Color\cf2 .white(0.6) ]] )\
.action_(\{ \cf7 "right was hit"\cf2 .postln \});\
\
dpadGUIArray= [ upBut, downBut, leftBut, rightBut ];\
\
\cf8 // ======== BUTTONS\cf2 \
\
\cf8 //buttonView= CompositeView(w, Rect(0, 0, 100, 100));\cf2 \
butOffsetH= 280;\
butOffsetV= 40;\
\
butX= \cf6 RoundButton\cf2 ( w, \cf6 Rect\cf2 (0+butOffsetH, 30+butOffsetV, 30, 30 ))\
.canFocus_(\cf4 false\cf2 )\
.states_([[ \cf7 "X"\cf2 , \cf6 Color\cf2 .white(0.5), \cf6 Color\cf2 .blue(0.6) ],  [\cf7 "X"\cf2 , \cf6 Color\cf2 .black(0.5), \cf6 Color\cf2 .white(0.6) ]] )\
.action_(\{ \cf7 "X was hit"\cf2 .postln \});\
\
butY= \cf6 RoundButton\cf2 ( w, \cf6 Rect\cf2 (30+butOffsetH, 0+butOffsetV, 30, 30 ))\
.canFocus_(\cf4 false\cf2 )\
.states_([[ \cf7 "Y"\cf2 , \cf6 Color\cf2 .white(0.5), \cf6 Color\cf2 .new255(255, 165, 0) ], [\cf7 "Y"\cf2 , \cf6 Color\cf2 .black(0.5), \cf6 Color\cf2 .white(0.6) ]] )\
.action_(\{ \cf7 "Y was hit"\cf2 .postln \});\
\
butA= \cf6 RoundButton\cf2 ( w, \cf6 Rect\cf2 (30+butOffsetH, 60+butOffsetV, 30, 30 ))\
.canFocus_(\cf4 false\cf2 )\
.states_([[ \cf7 "A"\cf2 , \cf6 Color\cf2 .white(0.5), \cf6 Color\cf2 .green(0.6) ], [\cf7 "A"\cf2 , \cf6 Color\cf2 .black(0.5), \cf6 Color\cf2 .white(0.6) ]] )\
.action_(\{ \cf7 "A was hit"\cf2 .postln \});\
\
butB= \cf6 RoundButton\cf2 ( w, \cf6 Rect\cf2 (60+butOffsetH, 30+butOffsetV, 30, 30 ))\
.canFocus_(\cf4 false\cf2 )\
.states_([[ \cf7 "B"\cf2 , \cf6 Color\cf2 .white(0.5), \cf6 Color\cf2 .red(0.6) ], [\cf7 "B"\cf2 , \cf6 Color\cf2 .black(0.5), \cf6 Color\cf2 .white(0.6) ]] )\
.action_(\{ \cf7 "B was hit"\cf2 .postln \});\
\
\cf8 //Button(buttonView, Rect(20, 20, 30, 20));\cf2 \
butGUIArray= [butA, butB, butX, butY, butL1, butR1];\
\
\cf8 //start HIDtoOSC\cf2 \
((\cf6 String\cf2 .scDir+/+\cf7 "./HIDtoOSC"\cf2 ).shellQuote++\cf7 " --vid 1118 --pid 654"\cf2 ).unixCmd(\{\cf7 "HIDtoOSC is closed"\cf2 .postln; \{if (w.isClosed.not, \{ \cf6 StaticText\cf2 (w, \cf6 Rect\cf2 (170, 20, 100, 100)).string_(\cf7 "controller not connected. close window, connect controller and open again."\cf2 ).background_(\cf6 Color\cf2 .grey); \}); \}.defer(1);\}, \cf4 true\cf2 );\
\
\cf8 //Init MIDI\cf2 \
m= \cf6 MIDIOut\cf2 .newByName(\cf7 "IAC Driver"\cf2 , \cf7 "IAC Bus 1"\cf2 , \cf4 false\cf2 );\
\{ m.latency= 0; \}.try;\
\
\
\cf8 //(String.scDir+/+"./HIDtoOSC").isFile\cf2 \
\
n= \cf6 NetAddr\cf2 (\cf5 ~ipDict\cf2 [\cf9 \\headBot\cf2 ][0], \cf5 ~ipDict\cf2 [\cf9 \\headBot\cf2 ][1]);\
\cf8 //ableton= NetAddr(~ipDict[\\ableton][0], ~ipDict[\\ableton][1]);\cf2 \
localmachine= \cf6 NetAddr\cf2 (\cf7 "127.0.0.1"\cf2 , \cf4 nil\cf2 );\
\
\cf6 StaticText\cf2 (w, \cf6 Rect\cf2 (20, 60, 30, 20)).string_(\cf7 "LT"\cf2 ).align_(\cf9 \\center\cf2 );\
sliderLT= \cf6 Slider\cf2 (w, \cf6 Rect\cf2 (20, 0, 30, 150)).value_(1)\
.background_(\cf6 Color\cf2 .grey.alpha_(0))\
.canFocus_(\cf4 false\cf2 );\
\
\cf8 /*\
StaticText(w, Rect(30, 150, 150, 30)).string_("L Joystick").align_(\\center);\
Slider(w, Rect(30, 150, 150, 30)).value_(0.5)\
.background_(Color.grey.alpha_(0))\
.knobColor_(Color.blue.alpha_(0.5))\
.enabled_(false)\
.canFocus_(false);\
*/\cf2 \
\
\
\
\cf6 StaticText\cf2 (w, \cf6 Rect\cf2 (390, 60, 30, 20)).string_(\cf7 "RT"\cf2 ).align_(\cf9 \\center\cf2 );\
\
sliderRT= \cf6 Slider\cf2 (w, \cf6 Rect\cf2 (390, 0, 30, 150)).value_(1)\
.background_(\cf6 Color\cf2 .grey.alpha_(0))\
.canFocus_(\cf4 false\cf2 );\
\
\cf6 StaticText\cf2 (w, \cf6 Rect\cf2 (70, 110, 90, 20)).string_(\cf7 "joyLX"\cf2 ).align_(\cf9 \\center\cf2 );\
\cf6 StaticText\cf2 (w, \cf6 Rect\cf2 (75, 40, 10, 90)).string_(\cf7 "j o y L Y"\cf2 ).align_(\cf9 \\center\cf2 );\
\
joyL= \cf6 Slider2D\cf2 (w, \cf6 Rect\cf2 (70, 40, 90, 90))\
.x_(0.5).y_(0.5)\
.background_(\cf6 Color\cf2 .grey.alpha_(0.5))\
.knobColor_(\cf6 Color\cf2 .blue.alpha_(0.5))\
.canFocus_(\cf4 false\cf2 );\
\
\cf6 StaticText\cf2 (w, \cf6 Rect\cf2 (260, 210, 90, 20)).string_(\cf7 "joyRX"\cf2 ).align_(\cf9 \\center\cf2 );\
\cf6 StaticText\cf2 (w, \cf6 Rect\cf2 (265, 140, 10, 90)).string_(\cf7 "j o y R Y"\cf2 ).align_(\cf9 \\center\cf2 );\
\
joyR= \cf6 Slider2D\cf2 (w, \cf6 Rect\cf2 (260, 140, 90, 90))\
.x_(0.5).y_(0.5)\
.background_(\cf6 Color\cf2 .grey.alpha_(0.5))\
.knobColor_(\cf6 Color\cf2 .blue.alpha_(0.5))\
.canFocus_(\cf4 false\cf2 );\
\
\cf8 /*\
StaticText(w, Rect(220, 150, 150, 30)).string_("J o y  X").align_(\\center);\
joyHSlider= Slider(w, Rect(220, 150, 150, 30)).value_(0.5)\
.background_(Color.grey.alpha_(0))\
.knobColor_(Color.blue.alpha_(0.5))\
.canFocus_(false);\
\
StaticText(w, Rect(200, 20, 10, 150)).string_("J o y  Y");\
joyVSlider= Slider(w, Rect(190, 20, 30, 150)).value_(0.5)\
.background_(Color.grey.alpha_(0))\
.knobColor_(Color.blue.alpha_(0.5))\
.canFocus_(false);\
*/\cf2 \
\
\
robotNames= \cf5 ~ipDict\cf2 .keys.asArray.sort;\
\
inputNames= [\cf9 \\joyLX\cf2 , \cf9 \\joyLY\cf2 , \cf9 \\joyRX\cf2 , \cf9 \\joyRY\cf2 , \cf9 \\LT\cf2 , \cf9 \\RT\cf2 , \cf9 \\A\cf2 , \cf9 \\B\cf2 , \cf9 \\X\cf2 , \cf9 \\Y\cf2 , \cf9 \\LB\cf2 , \cf9 \\RB\cf2 , \cf9 \\up\cf2 , \cf9 \\down\cf2 , \cf9 \\left\cf2 , \cf9 \\right\cf2 ];\
\
controlNames= [\cf7 "SR1"\cf2 , \cf7 "SR2"\cf2 , \cf7 "SR3"\cf2 , \cf7 "SR4"\cf2 , \cf7 "SR5"\cf2 , \cf7 "SR6"\cf2 , \cf7 "ST1"\cf2 , \cf7 "ST2"\cf2 , \cf7 "PS1"\cf2 , \cf7 "PS2"\cf2 , \cf7 "RL1"\cf2 , \cf7 "RL2"\cf2 , \cf7 "RL3"\cf2 , \cf7 "RL4"\cf2 , \cf7 "RL5"\cf2 , \cf7 "RL6"\cf2 , \cf7 "RL7"\cf2 , \cf7 "RL8"\cf2 ];\
\
controlNamesSymbols= [\cf9 \\SR1\cf2 , \cf9 \\SR2\cf2 , \cf9 \\SR3\cf2 , \cf9 \\SR4\cf2 , \cf9 \\SR5\cf2 , \cf9 \\SR6\cf2 , \cf9 \\ST1\cf2 , \cf9 \\ST2\cf2 , \cf9 \\PS1\cf2 , \cf9 \\PS2\cf2 , \cf9 \\RL1\cf2 , \cf9 \\RL2\cf2 , \cf9 \\RL3\cf2 , \cf9 \\RL4\cf2 , \cf9 \\RL5\cf2 , \cf9 \\RL6\cf2 , \cf9 \\RL7\cf2 , \cf9 \\RL8\cf2 ];\
\
controlNamesCheck= [\cf9 '/SR1'\cf2 , \cf9 '/SR2'\cf2 , \cf9 '/SR3'\cf2 , \cf9 '/SR4'\cf2 , \cf9 '/SR5'\cf2 , \cf9 '/SR6'\cf2 , \cf9 '/ST1'\cf2 , \cf9 '/ST2'\cf2 , \cf9 '/PS1'\cf2 , \cf9 '/PS2'\cf2 , \cf9 '/RL1'\cf2 , \cf9 '/RL2'\cf2 , \cf9 '/RL3'\cf2 , \cf9 '/RL4'\cf2 , \cf9 '/RL5'\cf2 , \cf9 '/RL6'\cf2 , \cf9 '/RL7'\cf2 , \cf9 '/RL8'\cf2 ];\
\
minButs= \cf4 nil\cf2 !(inputNames.size);\
maxButs= \cf4 nil\cf2 !(inputNames.size);\
ctrlMenus= \cf4 nil\cf2 !(inputNames.size);\
sendButs= \cf4 nil\cf2 !(inputNames.size);\
lastVals= \cf4 nil\cf2 !(inputNames.size);\
robotMenus= \cf4 nil\cf2 !(inputNames.size);\
ccVals= \cf4 nil\cf2 !(inputNames.size);\
\
lastCCVals= ();\
\
controlNamesCheck.do(\{\cf3 |it|\cf2 \
	lastCCVals.put(it, 0);\
\});\
\
netAddrs= ();\
\
dict= ();\
\
inputNames.do(\{ \cf3 |it|\cf2 \
	dict.put(it, [\cf4 nil\cf2 , 0, 0, 0, \cf7 "SR1"\cf2 , 0, [\cf7 "172.16.1.150"\cf2 , 8888], \cf9 \\circleBot\cf2 , 21]);\
\cf8 // [ (0)slider/buttn,   (1)last value,    (2)min,    (3)max,    (4)servo, (5)on/off, (6) [ip, port], (7) robotname,  (8) cc num for midi]\cf2 \
	netAddrs.put(it, \cf6 NetAddr\cf2 (\cf7 "172.16.1.150"\cf2 , 8888) );\
\});\
\
\
presetMenu= \cf6 PresetMenuGUI\cf2 (w, 10, 650, \cf6 String\cf2 .scDir++\cf7 "/ROBOTTESTERPRESETS/"\cf2 , \
\{ \cf8 // SAVEACTION\cf2 \
		[dict];\
	\},\{ \cf3 |values|\cf2  \cf8 // LOADACTION\cf2 \
		\cf3 var\cf2  menuItemsAsSymbols;\
		dict= values[0].deepCopy;\
		\cf8 //activeRobot= values[1].deepCopy;\cf2 \
		\{robotMenuMain.value= robotMenuMain.items.indexOf(values[1]) \}.defer;\
		inputNames.do(\{\cf3 |it, i|\cf2 \
			\{ minButs[i].value= dict[it][2]; \}.defer;\
			\{ maxButs[i].value= dict[it][3]; \}.defer;\
			\{ ctrlMenus[i].value= controlNamesSymbols.indexOf(dict[it][4].asSymbol); \}.defer;\
			\{ sendButs[i].value= dict[it][5]; \}.defer;\
			\{ robotMenus[i].valueAction= robotNames.indexOf(dict[it][7]) \}.defer;\
			netAddrs.do(\{\cf3 |n|\cf2  \{n.disconnect\}.try; n= \cf6 NetAddr\cf2 (dict[it][6][0], dict[it][6][1]) \});\
		\});\
	\}\
);\
\
\cf6 Button\cf2 (w, \cf6 Rect\cf2 (260, 650, 120, 20))\
.states_([[\cf7 "post values"\cf2 , \cf6 Color\cf2 .grey, \cf6 Color\cf2 .black], [\cf7 "post values"\cf2 , \cf6 Color\cf2 .green, \cf6 Color\cf2 .black]])\
.canFocus_(\cf4 false\cf2 )\
.value_(0)\
.action_(\{\cf3 |v|\cf2 \
	verbose= v.value;\
\});\
\
\cf6 Button\cf2 (w, \cf6 Rect\cf2 (260, 680, 120, 30))\
.states_([[\cf7 "Rec with Ableton"\cf2 , \cf6 Color\cf2 .grey, \cf6 Color\cf2 .black], [\cf7 "Stop Rec Ableton"\cf2 , \cf6 Color\cf2 .red, \cf6 Color\cf2 .black]])\
.canFocus_(\cf4 false\cf2 )\
.value_(0)\
.action_(\{\cf3 |v|\cf2 \
	if (v.value == 1, \{ \
		enableton= \cf4 true\cf2 ;\
		\cf8 // osc responder on\cf2 \
		\cf8 //OSCdef(\\ableton).enable;\cf2 \
		abletonResponders.do(\{\cf3 |it|\cf2  it.enable; \});\
	\}, \{ \
		enableton= \cf4 false\cf2 ;\
		\cf8 // osc responder off\cf2 \
		\cf8 //OSCdef(\\ableton).disable;\cf2 \
		abletonResponders.do(\{\cf3 |it|\cf2  it.disable; \});\
	\});\
\});\
\
\cf6 Button\cf2 (w, \cf6 Rect\cf2 (10, 240, 420, 15))\
.states_([[\cf7 "hide detailed settings"\cf2 ], [\cf7 "show detailed settings"\cf2 ]])\
.canFocus_(\cf4 false\cf2 )\
.action_(\{\cf3 |v|\cf2 \
	if(v.value== 1, \{\
		w.setInnerExtent(400, 260);\
		\}, \{\
		w.setInnerExtent(400, 720);\
	\});\
\});\
\
\cf6 StaticText\cf2 (w, \cf6 Rect\cf2 (10, 260, 420, 20)).string_(\cf7 "Input:"\cf2 ).background_(\cf6 Color\cf2 .grey.alpha_(0.5));\
\cf6 StaticText\cf2 (w, \cf6 Rect\cf2 (60, 260, 30, 20)).string_(\cf7 "Min:"\cf2 );\
\cf6 StaticText\cf2 (w, \cf6 Rect\cf2 (100, 260, 30, 20)).string_(\cf7 "Max:"\cf2 );\
\cf6 StaticText\cf2 (w, \cf6 Rect\cf2 (140, 260, 60, 20)).string_(\cf7 "Control:"\cf2 );\
\cf6 StaticText\cf2 (w, \cf6 Rect\cf2 (205, 260, 60, 20)).string_(\cf7 "Send:"\cf2 );\
\cf6 StaticText\cf2 (w, \cf6 Rect\cf2 (240, 260, 60, 20)).string_(\cf7 "Value:"\cf2 );\
\cf8 //StaticText(w, Rect(10, 270, 60, 20)).string_("Robot:");\cf2 \
robotMenuMain= \cf6 PopUpMenu\cf2 (w, \cf6 Rect\cf2 (280, 262, 110, 15))\
.items_(robotNames)\
.canFocus_(\cf4 false\cf2 )\
.action_(\{\cf3 |menu|\cf2  \
	n= \cf6 NetAddr\cf2 (\cf5 ~ipDict\cf2 [menu.item][0], \cf5 ~ipDict\cf2 [menu.item][1]);\
	\cf8 //netAddrs.do(\{|it| it[0]= [menu.item][0]; it[1]= [menu.item][1]; \});\cf2 \
	\{ robotMenus.do(\{\cf3 |it|\cf2  it.valueAction= menu.value \}); \}.defer;\
	\cf8 //activeRobot= menu.item;\cf2 \
\});\
\cf6 StaticText\cf2 (w, \cf6 Rect\cf2 (400, 260, 40, 20)).string_(\cf7 "CC:"\cf2 );\
\
\cf8 //activeRobot= robotMenuMain.item;\cf2 \
\
inputNames.do(\{\cf3 |it, i|\cf2 \
	\cf6 StaticText\cf2 (w, \cf6 Rect\cf2 (10, 280+(i*22), 420, 20))\
	.string_(it.asString)\
	.background_(\cf6 Color\cf2 .grey.alpha_(0.2));\
\
	minButs[i]= \cf6 NumberBox\cf2 (w, \cf6 Rect\cf2 (60, 280+(i*22), 30, 20))\
	\cf8 //.canFocus_(false)\cf2 \
	.clipLo_(0)\
	.clipHi_(255)\
	.value_(0)\
	.action_(\{\cf3 |v|\cf2  dict[it][2]= v.value \});\
	\
	maxButs[i]= \cf6 NumberBox\cf2 (w, \cf6 Rect\cf2 (100, 280+(i*22), 30, 20))\
	\cf8 //.canFocus_(false)\cf2 \
	.clipLo_(0)\
	.clipHi_(255)\
	.value_(0)\
	.action_(\{\cf3 |v|\cf2  dict[it][3]= v.value \});\
	\
	ctrlMenus[i]= \cf6 PopUpMenu\cf2 (w, \cf6 Rect\cf2 (140, 280+(i*22), 60, 20))\
	.items_(controlNames)\
	.action_(\{\cf3 |menu|\cf2  dict[it][4]= menu.item \});\
	\
	sendButs[i]= \cf6 Button\cf2 (w, \cf6 Rect\cf2 (210, 280+(i*22), 20, 20))\
	.states_([[\cf7 "S"\cf2 , \cf6 Color\cf2 .black, \cf6 Color\cf2 .white], [\cf7 "S"\cf2 , \cf6 Color\cf2 .black, \cf6 Color\cf2 .green]])\
	.canFocus_(\cf4 false\cf2 )\
	.value_(0)\
	.action_(\{\cf3 |v|\cf2  dict[it][5]= v.value \});\
	\
	lastVals[i]= \cf6 NumberBox\cf2 (w, \cf6 Rect\cf2 (240, 280+(i*22), 30, 20))\
	\cf8 //.canFocus_(false)\cf2 \
	.value_(0)\
	.action_(\{\cf3 |v|\cf2 \
		netAddrs[it].sendMsg(dict[it][4]++(v.value));\
	\});\
	\
	robotMenus[i]= \cf6 PopUpMenu\cf2 (w, \cf6 Rect\cf2 (280, 282+(i*22), 110, 15))\
	.items_(robotNames)\
	.canFocus_(\cf4 false\cf2 )\
	.action_(\{\cf3 |menu|\cf2  \
		\cf8 //n= NetAddr(~ipDict[menu.item][0], ~ipDict[menu.item][1]);\cf2 \
		\cf8 //activeRobot= menu.item;\cf2 \
		dict[it][6]= [ \cf5 ~ipDict\cf2 [menu.item][0], \cf5 ~ipDict\cf2 [menu.item][1] ];\
		\{netAddrs[it].disconnect\}.try;\
		netAddrs[it]= \cf6 NetAddr\cf2 (\cf5 ~ipDict\cf2 [menu.item][0], \cf5 ~ipDict\cf2 [menu.item][1]);\
		dict[it][7]= menu.item;\
	\});\
	\
	ccVals[i]= \cf6 NumberBox\cf2 (w, \cf6 Rect\cf2 (400, 280+(i*22), 30, 20))\
	\cf8 //.canFocus_(false)\cf2 \
	.clipLo_(0)\
	.clipHi_(127)\
	.value_(dict[it][8])\
	.action_(\{\cf3 |v|\cf2 \
		dict[it][8]= v.value;\
	\});\
\});\
\
\
gpResponder = \cf6 OSCFunc\cf2 (\{ \cf3 arg\cf2  msg, time, addr, recvPort;\
	\cf3 var\cf2  r2, l2, j2h, j2v, butsVal, butArray, dpadVal, dpadArray;\
	\cf3 var\cf2  j2hVal, j2vVal, ltVal, rtVal;\
	\cf3 var\cf2  j2hValSend, j2vValSend, ltValSend, rtValSend;\
	\cf3 var\cf2  j1hVal, j1vVal, j1hValSend, j1vValSend;\
	\cf8 //msg.postln;\cf2 \
	\cf8 //msg[3][13].postln;\cf2 \
	\
	dpadVal= msg[3][2];\
\
	butsVal= msg[3][3];\
\
	if(msg[3][4].isPositive, \
		\{ltVal= msg[3][4].linlin(0, 127, 0.0, 0.5)\}, \
		\{ltVal= msg[3][4].linlin(-127, -1, 0.5, 1.0)\}\
	);\
	\
	if(msg[3][5].isPositive, \
		\{rtVal= msg[3][5].linlin(0, 127, 0.0, 0.5)\}, \
		\{rtVal= msg[3][5].linlin(-127, -1, 0.5, 1.0)\}\
	);\
	\
	j2hVal= msg[3][11].linlin(-128, 127, 0.0, 1.0);\
	j2vVal= msg[3][13].linlin(-128, 127, 1.0, 0.0);\
	\
	j1hVal= msg[3][7].linlin(-128, 127, 0.0, 1.0);\
	j1vVal= msg[3][9].linlin(-128, 127, 1.0, 0.0);\
	\
	\cf8 //[msg[3][5], msg[3][11]].postln;\cf2 \
	\cf8 //j2hVal= j2h.linlin(0, 1, 100, 130).asInt;\cf2 \
	\cf8 //mouthVal= r2.linlin(0, 1, 131, 100).asInt;\cf2 \
	\
	\cf8 //if(eyeVal != eyeValPrev, \{ n.sendMsg("SR1"++eyeVal) \});\cf2 \
	\cf8 //if(mouthVal != mouthValPrev, \{n.sendMsg("SR2"++mouthVal) \});\cf2 \
	\
	if( dpadValPrev != dpadVal, \{\
		dpadArray= switch (dpadVal)\
		\{ 0 \}	\{ [0, 0, 0, 0] \} \cf8 // all off (up, down, left, right)\cf2 \
		\{ 1 \}	\{ [1, 0, 0, 0] \} \cf8 // up\cf2 \
		\{ 2 \}	\{ [0, 1, 0, 0] \} \cf8 // down\cf2 \
		\{ 4 \}	\{ [0, 0, 1, 0] \} \cf8 // left\cf2 \
		\{ 8 \}	\{ [0, 0, 0, 1] \} \cf8 // right\cf2 \
		\{ 5 \}	\{ [1, 0, 1, 0] \} \cf8 // up + left\cf2 \
		\{ 9 \}	\{ [1, 0, 0, 1] \} \cf8 // up + right \cf2 \
		\{ 6 \}	\{ [0, 1, 1, 0] \} \cf8 // left + down\cf2 \
		\{ 10 \}	\{ [0, 1, 0, 1] \}; \cf8 // right + down\cf2 \
\
		dpadArray.do(\{\cf3 |it, i|\cf2  \{ dpadGUIArray[i].value= it\}.defer; \});\
		\
		\cf8 // Send OSC\cf2 \
		[\cf9 \\up\cf2 , \cf9 \\down\cf2 , \cf9 \\left\cf2 , \cf9 \\right\cf2 ].do(\{\cf3 |it, i|\cf2 \
			\cf3 var\cf2  msg;\
			if (dict[it][5] == 1, \{\
				if (dpadArray[i] != dict[it][1], \{\
					if (dpadArray[i] == 0, \{\
						msg= dict[it][4]++dict[it][2];\
						if(enableton, \{ \
							m.control(1, dict[it][8], (msg/127)*100); \
							\},\{\
							netAddrs[it].sendMsg(msg);\
						\});\
						\{ lastVals[i+12].value= dict[it][2] \}.defer;\
						\},\{\
						msg= dict[it][4]++dict[it][3];\
						if(enableton, \{ \
							m.control(1, dict[it][8], (msg/127)*100); \
							\},\{\
							netAddrs[it].sendMsg(msg);\
						\});\
						\{ lastVals[i+12].value= dict[it][3] \}.defer;\
					\});\
				if( verbose == 1, \{ [it, msg, dict[it][7]].postln; \});\
				dict[it][1]= dpadArray[i];\
				\cf8 //\{ lastVals[i+12].value= dict[it][2] \}.defer;\cf2 \
				\});\
			\});\
		\});\
		\
		dpadValPrev= dpadVal;\
	\});\
	\
	if( butsValPrev != butsVal, \{\
	\
	butArray= switch (butsVal)\
		\{ 0 \}	 \{ [0, 0, 0, 0, 0, 0] \} \cf8 //all off (A, B, X, Y, LB, RB)\cf2 \
		\{ 16 \}	 \{ [1, 0, 0, 0, 0, 0] \} \cf8 // A\cf2 \
		\{ 32 \}	 \{ [0, 1, 0, 0, 0, 0] \} \cf8 // B\cf2 \
		\{ 64 \}	 \{ [0, 0, 1, 0, 0, 0] \} \cf8 // X\cf2 \
		\{ -128 \}	 \{ [0, 0, 0, 1, 0, 0] \} \cf8 // Y\cf2 \
		\{ 48 \}	 \{ [1, 1, 0, 0, 0, 0] \} \cf8 // A+B\cf2 \
		\{ 112 \}	 \{ [1, 1, 1, 0, 0, 0] \} \cf8 //A+B+X\cf2 \
		\{ -16 \}	 \{ [1, 1, 1, 1, 0, 0] \} \cf8 //A+B+X+Y\cf2 \
		\{ 80 \}	 \{ [1, 0, 1, 0, 0, 0] \} \cf8 //A+X\cf2 \
		\{ -48 \}	 \{ [1, 0, 1, 1, 0, 0] \} \cf8 //A+X+Y\cf2 \
		\{ -80 \}	 \{ [1, 1, 0, 1, 0, 0] \} \cf8 //A+B+Y\cf2 \
		\{ -112 \}	 \{ [1, 0, 0, 1, 0, 0] \} \cf8 //A+Y\cf2 \
		\{ 96 \}	 \{ [0, 1, 1, 0, 0, 0] \} \cf8 //B+X\cf2 \
		\{ -96 \}	 \{ [0, 1, 0, 1, 0, 0] \} \cf8 //B+Y\cf2 \
		\{ -32 \}	 \{ [0, 1, 1, 1, 0, 0] \} \cf8 //B+X+Y\cf2 \
		\{ -64 \}	 \{ [0, 0, 1, 1, 0, 0] \} \cf8 //X+Y\cf2 \
		\{ 1 \}	 \{ [0, 0, 0, 0, 1, 0] \} \cf8 // ===== L1 (A, B, X, Y, L1, L2)\cf2 \
		\{ 17 \}	 \{ [1, 0, 0, 0, 1, 0] \} \cf8 // A\cf2 \
		\{ 33 \}	 \{ [0, 1, 0, 0, 1, 0] \} \cf8 // B\cf2 \
		\{ 65 \}	 \{ [0, 0, 1, 0, 1, 0] \} \cf8 // X\cf2 \
		\{ -127 \}	 \{ [0, 0, 0, 1, 1, 0] \} \cf8 // Y\cf2 \
		\{ 49 \}	 \{ [1, 1, 0, 0, 1, 0] \} \cf8 // A+B\cf2 \
		\{ 111 \}	 \{ [1, 1, 1, 0, 1, 0] \} \cf8 //A+B+X\cf2 \
		\{ -15 \}	 \{ [1, 1, 1, 1, 1, 0] \} \cf8 //A+B+X+Y\cf2 \
		\{ 81 \}	 \{ [1, 0, 1, 0, 1, 0] \} \cf8 //A+X\cf2 \
		\{ -47 \}	 \{ [1, 0, 1, 1, 1, 0] \} \cf8 //A+X+Y\cf2 \
		\{ -79 \}	 \{ [1, 1, 0, 1, 1, 0] \} \cf8 //A+B+Y\cf2 \
		\{ -111 \}	 \{ [1, 0, 0, 1, 1, 0] \} \cf8 //A+Y\cf2 \
		\{ 97 \}	 \{ [0, 1, 1, 0, 1, 0] \} \cf8 //B+X\cf2 \
		\{ -95 \}	 \{ [0, 1, 0, 1, 1, 0] \} \cf8 //B+Y\cf2 \
		\{ -31 \}	 \{ [0, 1, 1, 1, 1, 0] \} \cf8 //B+X+Y\cf2 \
		\{ -63 \}	 \{ [0, 0, 1, 1, 1, 0] \} \cf8 //X+Y\cf2 \
		\{ 2 \}	 \{ [0, 0, 0, 0, 0, 1] \} \cf8 // ==== L2 (A, B, X, Y, L1, L2)\cf2 \
		\{ 18 \}	 \{ [1, 0, 0, 0, 0, 1] \} \cf8 // A\cf2 \
		\{ 34 \}	 \{ [0, 1, 0, 0, 0, 1] \} \cf8 // B\cf2 \
		\{ 66 \}	 \{ [0, 0, 1, 0, 0, 1] \} \cf8 // X\cf2 \
		\{ -126 \}	 \{ [0, 0, 0, 1, 0, 1] \} \cf8 // Y\cf2 \
		\{ 50 \}	 \{ [1, 1, 0, 0, 0, 1] \} \cf8 // A+B\cf2 \
		\{ 114 \}	 \{ [1, 1, 1, 0, 0, 1] \} \cf8 //A+B+X\cf2 \
		\{ -14 \}	 \{ [1, 1, 1, 1, 0, 1] \} \cf8 //A+B+X+Y\cf2 \
		\{ 82 \}	 \{ [1, 0, 1, 0, 0, 1] \} \cf8 //A+X\cf2 \
		\{ -46 \}	 \{ [1, 0, 1, 1, 0, 1] \} \cf8 //A+X+Y\cf2 \
		\{ -78 \}	 \{ [1, 1, 0, 1, 0, 1] \} \cf8 //A+B+Y\cf2 \
		\{ -110 \}	 \{ [1, 0, 0, 1, 0, 1] \} \cf8 //A+Y\cf2 \
		\{ 98 \}	 \{ [0, 1, 1, 0, 0, 1] \} \cf8 //B+X\cf2 \
		\{ -94 \}	 \{ [0, 1, 0, 1, 0, 1] \} \cf8 //B+Y\cf2 \
		\{ -30 \}	 \{ [0, 1, 1, 1, 0, 1] \} \cf8 //B+X+Y\cf2 \
		\{ -62 \}	 \{ [0, 0, 1, 1, 0, 1] \} \cf8 //X+Y\cf2 \
		\{ 3 \}	 \{ [0, 0, 0, 0, 1, 1] \} \cf8 // === L1+L2 (A, B, X, Y, L1, L2)\cf2 \
		\{ 19 \}	 \{ [1, 0, 0, 0, 1, 1] \} \cf8 // A\cf2 \
		\{ 35 \}	 \{ [0, 1, 0, 0, 1, 1] \} \cf8 // B\cf2 \
		\{ 67 \}	 \{ [0, 0, 1, 0, 1, 1] \} \cf8 // X\cf2 \
		\{ -125 \}	 \{ [0, 0, 0, 1, 1, 1] \} \cf8 // Y\cf2 \
		\{ 51 \}	 \{ [1, 1, 0, 0, 1, 1] \} \cf8 // A+B\cf2 \
		\{ 115 \}	 \{ [1, 1, 1, 0, 1, 1] \} \cf8 //A+B+X\cf2 \
		\{ -13 \}	 \{ [1, 1, 1, 1, 1, 1] \} \cf8 //A+B+X+Y\cf2 \
		\{ 83 \}	 \{ [1, 0, 1, 0, 1, 1] \} \cf8 //A+X\cf2 \
		\{ -45 \}	 \{ [1, 0, 1, 1, 1, 1] \} \cf8 //A+X+Y\cf2 \
		\{ -77 \}	 \{ [1, 1, 0, 1, 1, 1] \} \cf8 //A+B+Y\cf2 \
		\{ -109 \}	 \{ [1, 0, 0, 1, 1, 1] \} \cf8 //A+Y\cf2 \
		\{ 99 \}	 \{ [0, 1, 1, 0, 1, 1] \} \cf8 //B+X\cf2 \
		\{ -93 \}	 \{ [0, 1, 0, 1, 1, 1] \} \cf8 //B+Y\cf2 \
		\{ -29 \}	 \{ [0, 1, 1, 1, 1, 1] \} \cf8 //B+X+Y\cf2 \
		\{ -61 \}	 \{ [0, 0, 1, 1, 1, 1] \}; \cf8 //X+Y\cf2 \
		\
		\cf8 //butArray.postln;\cf2 \
		\
		\cf8 //n.sendMsg("SR3"++([0, 10, 30, 50, 80, 100, 127][butArray.sum]));\cf2 \
		\
		butArray.do(\{\cf3 |it, i|\cf2  \cf8 // (A, B, X, Y, LB, RB)\cf2 \
			\{butGUIArray[i].value= it\}.defer;		\
		\});\
		\
		\cf8 // Send OSC\cf2 \
		[\cf9 \\A\cf2 , \cf9 \\B\cf2 , \cf9 \\X\cf2 , \cf9 \\Y\cf2 , \cf9 \\LB\cf2 , \cf9 \\RB\cf2 ].do(\{\cf3 |it, i|\cf2 	\
			\cf3 var\cf2  msg;\
			if (dict[it][5] == 1, \{\
				if (butArray[i] != dict[it][1], \{\
					if (butArray[i] == 0, \{\
						msg= dict[it][4]++dict[it][2];\
						if(enableton, \{ \
							m.control(1, dict[it][8], (msg/127)*100); \
							\},\{\
							netAddrs[it].sendMsg(msg);\
						\});\
						\{ lastVals[i+6].value= dict[it][2] \}.defer;\
						\},\{\
						msg= dict[it][4]++dict[it][3];\
						if(enableton, \{ \
							m.control(1, dict[it][8], (msg/127)*100); \
							\},\{\
							netAddrs[it].sendMsg(msg);\
						\});\
						\{ lastVals[i+6].value= dict[it][3] \}.defer;\
					\});\
				if (verbose == 1, \{ [it, msg, dict[it][7]].postln; \});\
				dict[it][1]= butArray[i];\
				\});\
			\});\
		\});\
		\
		butsValPrev= butsVal;\
		\
	\});\
	\
	\cf8 // Send OSC\cf2 \
	\
	\cf8 // LT\cf2 \
	if (ltVal != ltValPrev, \{\
		\{ sliderLT.value= (ltVal-1).abs \}.defer;\
		ltValSend= ltVal.linlin(0, 1, dict[\cf9 \\LT\cf2 ][2], dict[\cf9 \\LT\cf2 ][3]).asInt;\
		if (dict[\cf9 \\LT\cf2 ][5] == 1, \{\
			if(enableton, \{ \
							m.control(1, dict[\cf9 \\LT\cf2 ][8], (ltValSend/127)*100); \
							\},\{\
							netAddrs[\cf9 \\LT\cf2 ].sendMsg(dict[\cf9 \\LT\cf2 ][4]++ltValSend);\
			\});\
			if( verbose == 1, \{ [\cf9 \\LT\cf2 , (dict[\cf9 \\LT\cf2 ][4]++ltValSend), dict[\cf9 \\LT\cf2 ][7]].postln; \});\
			\{ lastVals[4].value= ltValSend \}.defer;\
		\});\
	\});\
	\cf8 // RT\cf2 \
	if (rtVal != rtValPrev, \{\
		\{ sliderRT.value= (rtVal-1).abs \}.defer;\
		rtValSend= rtVal.linlin(0, 1, dict[\cf9 \\RT\cf2 ][2], dict[\cf9 \\RT\cf2 ][3]).asInt;\
		if (dict[\cf9 \\RT\cf2 ][5] == 1, \{\
			if(enableton, \{ \
							m.control(1, dict[\cf9 \\RT\cf2 ][8], (rtValSend/127)*100); \
							\},\{\
							netAddrs[\cf9 \\RT\cf2 ].sendMsg(dict[\cf9 \\RT\cf2 ][4]++rtValSend);\
			\});\
			if( verbose == 1, \{ [\cf9 \\RT\cf2 , (dict[\cf9 \\RT\cf2 ][4]++rtValSend), dict[\cf9 \\RT\cf2 ][7]].postln; \});\
			\{ lastVals[5].value= rtValSend \}.defer;\
		\});\
	\});\
	\cf8 // joyLX\cf2 \
	if (j1hVal != j1hValPrev, \{\
		\{ joyL.x= j1hVal \}.defer;\
		j1hValSend= j1hVal.linlin(0, 1, dict[\cf9 \\joyLX\cf2 ][2], dict[\cf9 \\joyLX\cf2 ][3]).asInt;\
		if (dict[\cf9 \\joyLX\cf2 ][5] == 1, \{\
			if(enableton, \{ \
				m.control(1, dict[\cf9 \\joyLX\cf2 ][8], (j1hValSend/127)*100); \
				\},\{\
				netAddrs[\cf9 \\joyLX\cf2 ].sendMsg(dict[\cf9 \\joyLX\cf2 ][4]++j1hValSend);\
			\});\
			if( verbose == 1, \{ [\cf9 \\joyLX\cf2 , (dict[\cf9 \\joyLX\cf2 ][4]++j1hValSend), dict[\cf9 \\joyLX\cf2 ][7]].postln; \});\
			\{ lastVals[0].value= j1hValSend \}.defer;\
		\});\
	\});\
	\cf8 //joyLY\cf2 \
	if (j1vVal != j1vValPrev, \{\
		\{ joyL.y= j1vVal \}.defer; \
		j1vValSend= j1vVal.linlin(0, 1, dict[\cf9 \\joyLY\cf2 ][2], dict[\cf9 \\joyLY\cf2 ][3]).asInt;\
		if (dict[\cf9 \\joyLY\cf2 ][5] == 1, \{\
			if(enableton, \{ \
				m.control(1, dict[\cf9 \\joyLY\cf2 ][8], (j1vValSend/127)*100); \
				\},\{\
				netAddrs[\cf9 \\joyLY\cf2 ].sendMsg(dict[\cf9 \\joyLY\cf2 ][4]++j1vValSend);\
			\});\
			if( verbose == 1, \{ [\cf9 \\joyLY\cf2 , (dict[\cf9 \\joyLY\cf2 ][4]++j1vValSend), dict[\cf9 \\joyLY\cf2 ][7]].postln; \});\
			\{ lastVals[1].value= j1vValSend \}.defer;\
		\});\
	\});\
	\cf8 // joyRX\cf2 \
	if (j2hVal != j2hValPrev, \{\
		\{ joyR.x= j2hVal \}.defer;\
		j2hValSend= j2hVal.linlin(0, 1, dict[\cf9 \\joyRX\cf2 ][2], dict[\cf9 \\joyRX\cf2 ][3]).asInt;\
		if (dict[\cf9 \\joyRX\cf2 ][5] == 1, \{\
			if(enableton, \{ \
				m.control(1, dict[\cf9 \\joyRX\cf2 ][8], (j2hValSend/127)*100); \
				\},\{\
				netAddrs[\cf9 \\joyRX\cf2 ].sendMsg(dict[\cf9 \\joyRX\cf2 ][4]++j2hValSend);\
			\});\
			if( verbose == 1, \{ [\cf9 \\joyRX\cf2 , (dict[\cf9 \\joyRX\cf2 ][4]++j2hValSend), dict[\cf9 \\joyRX\cf2 ][7]].postln; \});\
			\{ lastVals[2].value= j2hValSend \}.defer;\
		\});\
	\});\
	\cf8 //joyRY\cf2 \
	if (j2vVal != j2vValPrev, \{\
		\{ joyR.y= j2vVal \}.defer; \
		j2vValSend= j2vVal.linlin(0, 1, dict[\cf9 \\joyRY\cf2 ][2], dict[\cf9 \\joyRY\cf2 ][3]).asInt;\
		if (dict[\cf9 \\joyRY\cf2 ][5] == 1, \{\
			if(enableton, \{ \
				m.control(1, dict[\cf9 \\joyRY\cf2 ][8], (j2vValSend/127)*100); \
				\},\{\
				netAddrs[\cf9 \\joyRY\cf2 ].sendMsg(dict[\cf9 \\joyRY\cf2 ][4]++j2vValSend);\
			\});\
			if( verbose == 1, \{ [\cf9 \\joyRY\cf2 , (dict[\cf9 \\joyRY\cf2 ][4]++j2vValSend), dict[\cf9 \\joyRY\cf2 ][7]].postln; \});\
			\{ lastVals[3].value= j2vValSend \}.defer;\
		\});\
	\});\
	\
	ltValPrev= ltVal;\
	rtValPrev= rtVal;\
	j1hValPrev= j1hVal;\
	j1vValPrev= j1vVal;\
	j2hValPrev= j2hVal;\
	j2vValPrev= j2vVal;\
		\
	\
\}, \cf9 '/hid'\cf2 ); \cf8 // create the OSCresponderNode\cf2 \
\
abletonResponders= controlNamesCheck.collect(\{\cf3 |it, i|\cf2 \
	\
\cf6 OSCdef\cf2 ((\cf7 "ableton"\cf2 ++(it)).asSymbol, \{\cf3 |msg, time, addr, recvPort|\cf2 \
	\cf3 var\cf2  val, servo;\
	servo= msg[0];\
	\cf8 //if(controlNamesCheck.includes(servo), \{ \cf2 \
	\
	\cf8 //val= (msg[1]*127).floor(0.1);\cf2 \
	val= ((((msg[1]/1.27)*127)*100)/127).round;\
	\
	if(val != lastCCVals[servo], \{\
		\
		n.sendMsg(servo++((val).asString));\
		\cf8 /*\
		if (~recOSC, \{\
		NetAddr("localhost", NetAddr.langPort).sendMsg(names[it][5][0], it++((val+3).asString)); \
		 \});\
		 */\cf2 \
\
	lastCCVals[servo]= val;\
	if(verbose==1, \{ (servo++((val).asString)).postln; \});\
	\});\
	\
	\cf8 //\});\cf2 \
	\
	\}, it, localmachine);\
\});	\
\
abletonResponders.do(\{\cf3 |it|\cf2  it.disable; \});\
\
w.onClose= \{\
gpResponder.free; \'a0 \'a0\cf8 // remove the OSCresponderNode when you are done.\cf2 \
\cf5 ~robotTesterOpen\cf2 = \cf4 false\cf2 ;\
\cf7 "killall HIDtoOSC"\cf2 .unixCmd; \cf8 //stop HIDtoOSC on close\cf2 \
netAddrs.do(\{\cf3 |it|\cf2  \{ it.disconnect\}.try; \});\
n.disconnect;\
m.disconnect;\
localmachine.disconnect;\
abletonResponders.do(\{\cf3 |it|\cf2  it.free; \});\
\};\
)\
\
\
\cf8 //EOF\cf2 \
\
}