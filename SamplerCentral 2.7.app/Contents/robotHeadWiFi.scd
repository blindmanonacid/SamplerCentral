{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf600
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;\red0\green0\blue255;\red255\green102\blue0;
\red51\green51\blue191;\red0\green0\blue191;\red96\green96\blue96;\red191\green0\blue0;\red0\green115\blue0;
}
{\*\expandedcolortbl;;\csgenericrgb\c0\c0\c0;\csgenericrgb\c0\c0\c100000;\csgenericrgb\c100000\c40000\c0;
\csgenericrgb\c20000\c20000\c75000;\csgenericrgb\c0\c0\c75000;\csgenericrgb\c37500\c37500\c37500;\csgenericrgb\c75000\c0\c0;\csgenericrgb\c0\c45000\c0;
}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 \
(\
\cf3 var\cf2  n, gpResponder, w, mouthSlider, eyeSlider, eyeVal= 0, eyeValPrev= 0, mouthVal= 0, mouthValPrev= 0;\
\cf3 var\cf2  moveVal= 0, moveValPrev= 0, buttonView, butX, butY, butA, butB, butOffsetH, butOffsetV;\
\cf3 var\cf2  numb, butsValPrev= 0, butGUIArray, butL1, butR1, sliderL2;\
\cf4 \
~robotHeadWiFiOpen\cf2 = \cf5 true\cf2 ;\
\
w= \cf6 Window\cf2 (\cf7 "RobotHEAD-WIFI"\cf2 , \cf6 Rect\cf2 (\cf6 Window\cf2 .screenBounds.width, \cf6 Window\cf2 .screenBounds.height, 400, 200)).alwaysOnTop_(\cf5 true\cf2 ).front;\
\
butL1= \cf6 Button\cf2 (w, \cf6 Rect\cf2 (80, 20, 60, 20))\
.canFocus_(\cf5 false\cf2 )\
.states_([[ \cf7 "L1"\cf2 , \cf6 Color\cf2 .white, \cf6 Color\cf2 .grey ],  [\cf7 "L1"\cf2 , \cf6 Color\cf2 .black, \cf6 Color\cf2 .white]] );\
\
butR1= \cf6 Button\cf2 (w, \cf6 Rect\cf2 (280, 20, 60, 20))\
.canFocus_(\cf5 false\cf2 )\
.states_([[ \cf7 "R1"\cf2 , \cf6 Color\cf2 .white, \cf6 Color\cf2 .grey ],  [\cf7 "R1"\cf2 , \cf6 Color\cf2 .black, \cf6 Color\cf2 .white]] );\
\
\
\cf8 //buttonView= CompositeView(w, Rect(0, 0, 100, 100));\cf2 \
butOffsetH= 220;\
butOffsetV= 40;\
\
butX= \cf6 RoundButton\cf2 ( w, \cf6 Rect\cf2 (0+butOffsetH, 30+butOffsetV, 30, 30 ))\
.canFocus_(\cf5 false\cf2 )\
.states_([[ \cf7 "X"\cf2 , \cf6 Color\cf2 .white(0.5), \cf6 Color\cf2 .blue(0.6) ],  [\cf7 "X"\cf2 , \cf6 Color\cf2 .black(0.5), \cf6 Color\cf2 .white(0.6) ]] )\
.action_(\{ \cf7 "was hit"\cf2 .postln \});\
\
butY= \cf6 RoundButton\cf2 ( w, \cf6 Rect\cf2 (30+butOffsetH, 0+butOffsetV, 30, 30 ))\
.canFocus_(\cf5 false\cf2 )\
.states_([[ \cf7 "Y"\cf2 , \cf6 Color\cf2 .white(0.5), \cf6 Color\cf2 .new255(255, 165, 0) ], [\cf7 "Y"\cf2 , \cf6 Color\cf2 .black(0.5), \cf6 Color\cf2 .white(0.6) ]] )\
.action_(\{ \cf7 "was hit"\cf2 .postln \});\
\
butA= \cf6 RoundButton\cf2 ( w, \cf6 Rect\cf2 (30+butOffsetH, 60+butOffsetV, 30, 30 ))\
.canFocus_(\cf5 false\cf2 )\
.states_([[ \cf7 "A"\cf2 , \cf6 Color\cf2 .white(0.5), \cf6 Color\cf2 .green(0.6) ], [\cf7 "A"\cf2 , \cf6 Color\cf2 .black(0.5), \cf6 Color\cf2 .white(0.6) ]] )\
.action_(\{ \cf7 "was hit"\cf2 .postln \});\
\
butB= \cf6 RoundButton\cf2 ( w, \cf6 Rect\cf2 (60+butOffsetH, 30+butOffsetV, 30, 30 ))\
.canFocus_(\cf5 false\cf2 )\
.states_([[ \cf7 "B"\cf2 , \cf6 Color\cf2 .white(0.5), \cf6 Color\cf2 .red(0.6) ], [\cf7 "B"\cf2 , \cf6 Color\cf2 .black(0.5), \cf6 Color\cf2 .white(0.6) ]] )\
.action_(\{ \cf7 "was hit"\cf2 .postln \});\
\
\cf8 //Button(buttonView, Rect(20, 20, 30, 20));\cf2 \
butGUIArray= [butA, butB, butX, butY, butL1, butR1];\
\
\
\cf8 //start HIDtoOSC\cf2 \
((\cf6 String\cf2 .scDir+/+\cf7 "./HIDtoOSC"\cf2 ).shellQuote++\cf7 " --vid 1118 --pid 654"\cf2 ).unixCmd(\{\cf7 "HIDtoOSC is closed"\cf2 .postln; \{if (w.isClosed.not, \{ \cf6 StaticText\cf2 (w, \cf6 Rect\cf2 (150, 20, 100, 100)).string_(\cf7 "controller not connected. close window, connect controller and open again."\cf2 ).background_(\cf6 Color\cf2 .grey); \}); \}.defer(1);\}, \cf5 true\cf2 );\
\
\
\cf8 //(String.scDir+/+"./HIDtoOSC").isFile\cf2 \
\
n= \cf6 NetAddr\cf2 (\cf4 ~ipDict\cf2 [\cf9 \\sparkHead\cf2 ][0], \cf4 ~ipDict\cf2 [\cf9 \\sparkHead\cf2 ][1]);\
\
sliderL2= \cf6 Slider\cf2 (w, \cf6 Rect\cf2 (20, 0, 30, 150)).value_(1)\
.canFocus_(\cf5 false\cf2 );\
\
\cf6 Slider\cf2 (w, \cf6 Rect\cf2 (30, 150, 150, 30)).value_(0.5)\
.enabled_(\cf5 false\cf2 )\
.canFocus_(\cf5 false\cf2 );\
\
mouthSlider= \cf6 Slider\cf2 (w, \cf6 Rect\cf2 (350, 0, 30, 150)).value_(1)\
.canFocus_(\cf5 false\cf2 );\
\
eyeSlider= \cf6 Slider\cf2 (w, \cf6 Rect\cf2 (220, 150, 150, 30)).value_(0.5)\
.canFocus_(\cf5 false\cf2 );\
\
gpResponder = \cf6 OSCFunc\cf2 (\{ \cf3 arg\cf2  msg, time, addr, recvPort;\
	\cf3 var\cf2  r2, l2, j2h, butsVal, butArray;\
	\
	butsVal= msg[3][3];\
	\
	if(msg[3][5].isPositive, \
		\{r2= msg[3][5].linlin(0, 127, 0.0, 0.5)\}, \
		\{r2= msg[3][5].linlin(-127, -1, 0.5, 1.0)\}\
	);\
	if(msg[3][4].isPositive, \
		\{l2= msg[3][4].linlin(0, 127, 0.0, 0.5)\}, \
		\{l2= msg[3][4].linlin(-127, -1, 0.5, 1.0)\}\
	);\
	j2h= msg[3][11].linlin(-128, 127, 0.0, 1.0);\
	\cf8 //[r2, j2h].postln;\cf2 \
	\{mouthSlider.value= (r2-1).abs\}.defer;\
	\{eyeSlider.value= j2h\}.defer;\
	\{sliderL2.value= (l2-1).abs\}.defer;\
	\cf8 //[msg[3][5], msg[3][11]].postln;\cf2 \
	eyeVal= j2h.linlin(0, 1, 50, 120).asInt;\
	mouthVal= r2.linlin(0, 1, 140, 90).asInt;\
	if(eyeVal != eyeValPrev, \{ n.sendMsg(\cf7 "SR1"\cf2 ++eyeVal) \});\
	if(mouthVal != mouthValPrev, \{n.sendMsg(\cf7 "SR2"\cf2 ++mouthVal) \});\
	eyeValPrev= eyeVal;\
	mouthValPrev= mouthVal;\
	\
	if( butsValPrev != butsVal, \{\
	\
	butArray= switch (butsVal)\
		\{ 0 \}	 \{ [0, 0, 0, 0, 0, 0] \} \cf8 //all off (A, B, X, Y, L1, L2)\cf2 \
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
		butArray.postln;\
		\
		\cf8 //n.sendMsg("SR3"++([0, 10, 30, 50, 80, 100, 127][butArray.sum]));\cf2 \
		\
		butArray.do(\{\cf3 |it, i|\cf2  \{butGUIArray[i].value= it\}.defer; \});\
		\
		butsValPrev= butsVal;\
	\});\
	\
	\}, \cf9 '/hid'\cf2 ); \cf8 // create the OSCresponderNode\cf2 \
\
w.onClose= \{\
gpResponder.free; \'a0 \'a0\cf8 // remove the OSCresponderNode when you are done.\cf2 \
\cf4 ~robotHeadWiFiOpen\cf2 = \cf5 false\cf2 ;\
\cf7 "killall HIDtoOSC"\cf2 .unixCmd; \cf8 //stop HIDtoOSC on close\cf2 \
n.disconnect;\
\};\
)\
\
\
\cf8 //EOF\cf2 \
\
}