{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf600
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;\red0\green0\blue191;\red0\green0\blue255;
\red191\green0\blue0;\red102\green102\blue191;\red51\green51\blue191;\red96\green96\blue96;}
{\*\expandedcolortbl;;\csgenericrgb\c0\c0\c0;\csgenericrgb\c0\c0\c75000;\csgenericrgb\c0\c0\c100000;
\csgenericrgb\c75000\c0\c0;\csgenericrgb\c40000\c40000\c75000;\csgenericrgb\c20000\c20000\c75000;\csgenericrgb\c37500\c37500\c37500;}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 + \cf3 String\cf2  \{\
\
	isSoundFileOrMp3 \{ \cf4 var\cf2  sf;\
		\cf5 //if( this.isFile )\cf2 \
		if( \cf3 File\cf2 .exists(\cf6 this\cf2 ) ) \cf5 // changed to include odd letters in name that isFile rejects\cf2 \
			\{ sf = \cf3 SoundFile\cf2 .new;\
				if( sf.openRead( \cf6 this\cf2 .standardizePath ) )\
					\{ sf.close; \
						^\cf7 true\cf2  \}\
					\{ if(\cf6 this\cf2 .extension==\cf8 "mp3"\cf2 , \{^\cf7 true\cf2  \}, \{^\cf7 false\cf2 \}); \};\
			\}\
			\{ ^\cf7 false\cf2   \}\
		\}\
		\
\}}