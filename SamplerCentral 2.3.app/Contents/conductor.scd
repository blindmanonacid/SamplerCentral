{\rtf1\ansi\ansicpg1252\cocoartf1265\cocoasubrtf210
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red191\green0\blue0;\red0\green0\blue0;\red0\green0\blue255;
\red0\green0\blue191;\red96\green96\blue96;\red0\green115\blue0;\red255\green102\blue0;}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 //CONDUCTOR\cf3 \
(\
\cf4 var\cf3  w, wb, b, metronomeResp;\
\
w= \cf5 Window\cf3 (\cf6 ""\cf3 , \cf5 Rect\cf3 (1000, 655, 200, 200)).front;\
wb= w.bounds;\
c= \cf5 GUI\cf3 .vLayoutView.new(w, \cf5 Rect\cf3 (0, 30, wb.width, wb.height-30));\
\
\cf5 StaticText\cf3 (w, \cf5 Rect\cf3 (0, 10, 100, 15))\
.string_(\cf6 "CONDUCTOR"\cf3 )\
.font_(\cf5 Font\cf3 (\cf6 "Helvetica"\cf3 , 15))\
.align_(\cf7 \\center\cf3 );\
\
b= \cf5 Buffer\cf3 .read(s, \cf6 "/Volumes/MEDIA/Ableton/nedmixer/12spaten/metronomeWood2.wav"\cf3 );\
\
\cf5 SynthDef\cf3 (\cf7 \\metronome\cf3 , \{\cf4 |buf|\cf3 \
\cf5 Out\cf3 .ar(0, \cf5 PlayBuf\cf3 .ar(2, buf, doneAction:2))\
\}).add;\
\
\cf5 Button\cf3 (c, 50@20)\
	.states_([[\cf6 "conduct OFF"\cf3 , \cf5 Color\cf3 .white,\cf5 Color\cf3 .grey], [\cf6 "conduct ON"\cf3 , \cf5 Color\cf3 .white,\cf5 Color\cf3 .green]])\
	.action_(\{ \cf4 |v|\cf3 \
		if(v.value==1, \{\
			metronomeResp= \cf5 OSCFunc\cf3 .new(\{|msg|\
				\cf6 "play metronome tick!"\cf3 .postln;\
				msg.postln;\
				\cf5 Synth\cf3 (\cf7 \\metronome\cf3 );\
				\}, \cf7 '/playMetronome'\cf3 , \cf5 NetAddr\cf3 (\cf8 ~ipDict\cf3 [\cf7 \\conductor\cf3 ][0], \cf8 ~ipDict\cf3 [\cf7 \\conductor\cf3 ][1]));\
		\},\{\
			metronomeResp.free;\
		\});\
\});\
\
)}