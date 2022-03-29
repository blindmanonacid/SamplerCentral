{\rtf1\ansi\ansicpg1252\cocoartf1265\cocoasubrtf210
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;\red0\green0\blue191;\red96\green96\blue96;
\red255\green102\blue0;\red191\green0\blue0;\red0\green0\blue255;\red51\green51\blue191;\red0\green115\blue0;
}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 (\
w= \cf3 Window\cf2 (\cf4 "mixer"\cf2 , \cf3 Rect\cf2 (0, 0, 80*\cf5 ~mixerChans\cf2 .size, 350)).front;\
\
w.view.decorator=\cf3 FlowLayout\cf2 (w.view.bounds);\
\
\cf6 //what order do they come? a way to set this? Dictionary\cf2 \
\
\cf5 ~mixerChans\cf2 .keysValuesDo(\{\cf7 |key, val|\cf2 \
	\cf7 var\cf2  g;\
	g=\cf3 Knob\cf2 (w, 75@50);\
	g.centered= \cf8 true\cf2 ;\
	\cf6 //g.action= \{|v| val.set(\\pan, (v.value*2)-1); ((v.value*2)-1).postln\};\cf2 \
	g.action= \{\cf7 |v|\cf2  val.set(\cf9 \\pan\cf2 , (v.value*2)-1); \
		\cf6 //((v.value*2)-1).postln;\cf2 \
		\};\
	g.value= 0.5;\
\});\
\
\cf5 ~mixerChans\cf2 .keysValuesDo(\{\cf7 |key, val|\cf2 \
	\cf7 var\cf2  g;\
	g=\cf3 EZSlider\cf2 (w, 75@280, key, \cf8 nil\cf2 ,unitWidth:0, numberWidth:60,layout:\cf9 \\vert\cf2 , margin: m);\
	g.setColors(\cf3 Color\cf2 .grey,\cf3 Color\cf2 .white, \cf3 Color\cf2 .grey(0.7),\cf3 Color\cf2 .grey, \cf3 Color\cf2 .white, \cf3 Color\cf2 .yellow,\cf8 nil\cf2 ,\cf8 nil\cf2 , \cf3 Color\cf2 .grey(0.7));\
	g.font_(\cf3 Font\cf2 (\cf4 "Helvetica"\cf2 ,10));\
	g.action= \{\cf7 |v|\cf2  val.set(\cf9 \\amp\cf2 , v.value); \
		\cf6 //v.value.postln;\cf2 \
		\};\
	g.value= 1;\
\});\
\
\cf5 ~mixerOpen\cf2 = \cf8 true\cf2 ;\
\
\cf6 //midi binding\cf2 \
\
w.onClose= \{\cf5 ~mixerOpen\cf2 = \cf8 false\cf2 \};\
)}