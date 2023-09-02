{\rtf1\ansi\ansicpg1252\cocoartf1265\cocoasubrtf210
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red191\green0\blue0;\red0\green0\blue0;\red0\green0\blue191;
\red0\green0\blue255;\red96\green96\blue96;}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 /*\
A Class to make midi sysex messages that an ETC Eon Lightdesk understands\
\
MIDIClient.init;\
m= MIDIOut(1);\
m.sysex(ETCEonSysex.submaster(1, 2, 10)); \
m.sysex(ETCEonSysex.macro(1, 17));\
m.sysex(ETCEonSysex.grandmaster(1, 100));\
m.sysex(ETCEonSysex.goCue(1, 1, 0));\
m.sysex(ETCEonSysex.goCue(1, 2, 0));\
m.sysex(ETCEonSysex.pauseCue(1, 2, 1));\
m.sysex(ETCEonSysex.resumeCue(1, 2, 1));\
m.sysex(ETCEonSysex.goCue(1, 54.6, 2));\
\
ETCEonSysex.goCue(1, 1, 1)\
\
\
// in sysex\
// Go Cue 1/10 (to Device 1)\
m.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x01, 0x31, 0x30, 0x00, 0x31,  0xf7]);\
\
// Go Cue 1/1 (to Device 1)\
m.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x01, 0x31, 0x00, 0x31,  0xf7]);\
m.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x01, 49, 0x00, 0x31,  0xf7]);\
// Go Cue 1/2 (to Device 1)\
m.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x01, 0x32, 0x00, 0x31,  0xf7]);\
m.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x01, 50, 0x00, 0x31,  0xf7]);\
\
\
*/\cf3 \
\
\cf4 ETCEonSysex\cf3  \{\
	\
	*submaster\{\cf5 |device= 127, submaster= 1, value= 0|\cf3 \
		^\cf4 Int8Array\cf3 [0xf0, 0x7f, device,  0x02, 0x01,  0x06, submaster, 0x00, value, 0x00, 0xf7]\
	\}\
	\
	*grandmaster\{\cf5 |device= 127, value= 0|\cf3 \
		^\cf4 Int8Array\cf3 [0xf0, 0x7f, device,  0x02, 0x01,  0x06, 0x7e, 0x03, value, 0x00, 0xf7]\
	\}\
	\
	*macro\{\cf5 |device= 127, macro= 0|\cf3 \
		^\cf4 Int8Array\cf3 [0xf0, 0x7f, device,  0x02, 0x01,  0x07, macro, 0xf7]\
	\}\
	\
	*goCue\{\cf5 |device= 127, val1= 1, val2= 1|\cf3 \
		\cf5 var\cf3  t, t2, cue1, cue2, sysexArray;\
	\
	if( (val1 - val1.floor) != 0, \{\
	val1= val1.round(0.1);\
	val1= val1.asString.findReplace(\cf6 "."\cf3 , \cf6 ""\cf3 ); \
	cue1= val1.asInteger.asDigits.collect(\{\cf5 |it|\cf3 \
		(\cf6 "0x3"\cf3 ++(it.asString)).interpret;\
	\});\
	t= cue1.last;\
	\cf2 //cue2[cue2.size-1]= 0x2E;\cf3 \
	cue1[(cue1.size-1)]= 46;\
	cue1= cue1.add(t);\
	cue1;\
\},\{\
	val1= val1.asInteger;\
	cue1= val1.asDigits.collect(\{\cf5 |it|\cf3 \
		(\cf6 "0x3"\cf3 ++(it.asString)).interpret;\
	\});\
	cue1;\
\});\
\
if((val2 - val2.floor) != 0, \{\
	val2= val2.round(0.1);\
	val2= val2.asString.findReplace(\cf6 "."\cf3 , \cf6 ""\cf3 ); \
	cue2= val2.asInteger.asDigits.collect(\{\cf5 |it|\cf3 \
		(\cf6 "0x3"\cf3 ++(it.asString)).interpret;\
	\});\
	t2= cue2.last;\
	\cf2 //cue2[cue2.size-1]= 0x2E;\cf3 \
	cue2[cue2.size-1]= 46;\
	cue2= cue2.add(t2);\
	cue2;\
\},\{\
	val2= val2.asInteger;\
	cue2= val2.asDigits.collect(\{\cf5 |it|\cf3 \
		(\cf6 "0x3"\cf3 ++(it.asString)).interpret;\
	\});\
	cue2;\
\});\
\
sysexArray= \cf4 Int8Array\cf3 [ -16, 127, device, 2, 1, 1]++\cf4 Int8Array\cf3 .newFrom(cue1)++\cf4 Int8Array\cf3 [0]++\cf4 Int8Array\cf3 .newFrom(cue2)++\cf4 Int8Array\cf3 [0xf7];\
\
^sysexArray\
		\
\}\
\
	*pauseCue\{\cf5 |device= 127, val1= 1, val2= 1|\cf3 \
		\cf5 var\cf3  t, t2, cue1, cue2, sysexArray;\
	\
	if( (val1 - val1.floor) != 0, \{\
	val1= val1.round(0.1);\
	val1= val1.asString.findReplace(\cf6 "."\cf3 , \cf6 ""\cf3 ); \
	cue1= val1.asInteger.asDigits.collect(\{\cf5 |it|\cf3 \
		(\cf6 "0x3"\cf3 ++(it.asString)).interpret;\
	\});\
	t= cue1.last;\
	\cf2 //cue2[cue2.size-1]= 0x2E;\cf3 \
	cue1[(cue1.size-1)]= 46;\
	cue1= cue1.add(t);\
	cue1;\
\},\{\
	val1= val1.asInteger;\
	cue1= val1.asDigits.collect(\{\cf5 |it|\cf3 \
		(\cf6 "0x3"\cf3 ++(it.asString)).interpret;\
	\});\
	cue1;\
\});\
\
if((val2 - val2.floor) != 0, \{\
	val2= val2.round(0.1);\
	val2= val2.asString.findReplace(\cf6 "."\cf3 , \cf6 ""\cf3 ); \
	cue2= val2.asInteger.asDigits.collect(\{\cf5 |it|\cf3 \
		(\cf6 "0x3"\cf3 ++(it.asString)).interpret;\
	\});\
	t2= cue2.last;\
	\cf2 //cue2[cue2.size-1]= 0x2E;\cf3 \
	cue2[cue2.size-1]= 46;\
	cue2= cue2.add(t2);\
	cue2;\
\},\{\
	val2= val2.asInteger;\
	cue2= val2.asDigits.collect(\{\cf5 |it|\cf3 \
		(\cf6 "0x3"\cf3 ++(it.asString)).interpret;\
	\});\
	cue2;\
\});\
\
sysexArray= \cf4 Int8Array\cf3 [ -16, 127, device, 2, 1, 2]++\cf4 Int8Array\cf3 .newFrom(cue1)++\cf4 Int8Array\cf3 [0]++\cf4 Int8Array\cf3 .newFrom(cue2)++\cf4 Int8Array\cf3 [0xf7];\
\
^sysexArray\
		\
\}\
\
	*resumeCue\{\cf5 |device= 127, val1= 1, val2= 1|\cf3 \
		\cf5 var\cf3  t, t2, cue1, cue2, sysexArray;\
	\
	if( (val1 - val1.floor) != 0, \{\
	val1= val1.round(0.1);\
	val1= val1.asString.findReplace(\cf6 "."\cf3 , \cf6 ""\cf3 ); \
	cue1= val1.asInteger.asDigits.collect(\{\cf5 |it|\cf3 \
		(\cf6 "0x3"\cf3 ++(it.asString)).interpret;\
	\});\
	t= cue1.last;\
	\cf2 //cue2[cue2.size-1]= 0x2E;\cf3 \
	cue1[(cue1.size-1)]= 46;\
	cue1= cue1.add(t);\
	cue1;\
\},\{\
	val1= val1.asInteger;\
	cue1= val1.asDigits.collect(\{\cf5 |it|\cf3 \
		(\cf6 "0x3"\cf3 ++(it.asString)).interpret;\
	\});\
	cue1;\
\});\
\
if((val2 - val2.floor) != 0, \{\
	val2= val2.round(0.1);\
	val2= val2.asString.findReplace(\cf6 "."\cf3 , \cf6 ""\cf3 ); \
	cue2= val2.asInteger.asDigits.collect(\{\cf5 |it|\cf3 \
		(\cf6 "0x3"\cf3 ++(it.asString)).interpret;\
	\});\
	t2= cue2.last;\
	\cf2 //cue2[cue2.size-1]= 0x2E;\cf3 \
	cue2[cue2.size-1]= 46;\
	cue2= cue2.add(t2);\
	cue2;\
\},\{\
	val2= val2.asInteger;\
	cue2= val2.asDigits.collect(\{\cf5 |it|\cf3 \
		(\cf6 "0x3"\cf3 ++(it.asString)).interpret;\
	\});\
	cue2;\
\});\
\
\
sysexArray= \cf4 Int8Array\cf3 [ -16, 127, device, 2, 1, 3]++\cf4 Int8Array\cf3 .newFrom(cue1)++\cf4 Int8Array\cf3 [0]++\cf4 Int8Array\cf3 .newFrom(cue2)++\cf4 Int8Array\cf3 [0xf7];\
\
^sysexArray\
		\
\}\
\
\
\
\}\
\
\cf2 //EOF\cf3 \
	}