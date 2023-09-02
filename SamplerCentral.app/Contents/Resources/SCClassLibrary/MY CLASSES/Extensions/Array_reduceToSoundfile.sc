{\rtf1\ansi\ansicpg1252\cocoartf1265\cocoasubrtf200
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;\red0\green0\blue191;\red0\green0\blue255;
\red102\green102\blue191;}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 +\cf3 Array\cf2 \{\
\
reduceToSoundFiles \{\
	\cf4 var\cf2  arr;\
	arr= \cf3 Array\cf2 .new;\
	\cf5 this\cf2 .do \{ \cf4 |it|\cf2  if(it.isSoundFile, \{arr= arr.add(it)\}); \};\
	^arr\
\}\
\
\}}