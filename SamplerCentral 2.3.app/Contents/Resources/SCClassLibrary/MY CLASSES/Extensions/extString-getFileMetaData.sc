{\rtf1\ansi\ansicpg1252\cocoartf1265\cocoasubrtf210
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;\red0\green0\blue191;\red191\green0\blue0;
\red0\green0\blue255;\red102\green102\blue191;\red96\green96\blue96;\red51\green51\blue191;}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 + \cf3 String\cf2  \{\
	\
	getTags \{ \cf4 //return array of metadata tags of file. osx only\cf2 \
		\cf5 var\cf2  p, l, file;\
		\cf5 var\cf2  tagArr= \cf3 Array\cf2 .new;\
		file= \cf6 this\cf2 .standardizePath;\
		p= \cf3 Pipe\cf2 .new(\cf7 "mdls -name kOMUserTags -name kMDItemUserTags"\cf2 +file.quote, \cf7 "r"\cf2 );\
		l= p.getLine;\
		while(\{l.notNil\}, \{\
			\cf4 //l.postln;	\cf2 \
			if(l.contains(\cf7 "("\cf2 ).not && \{l.contains(\cf7 ")"\cf2 ).not\}, \{\
				while (\{ l.last == $, \}, \{l= l.copyFromStart(l.size-2)\}); \cf4 //remove comma\cf2 \
				while (\{ l.first == $ \}, \{l= l.copyToEnd(1)\}); \cf4 //remove whitespace\cf2 \
				tagArr= tagArr.add(l);\
			\});		\
			l = p.getLine; \
		\});\
		p.close;\
		tagArr= tagArr.as(\cf3 Set\cf2 ).asArray; \cf4 //remove duplicates\cf2 \
		if(tagArr.size > 0, \{^tagArr\}, \{^\cf8 nil\cf2 \});\
	\}\
	\
	hasTag \{ \cf5 |tag|\cf2  \cf4 //takes tagname as input, returns true or false\cf2 \
		\cf5 var\cf2  t, tag2;\
		tag2= tag.deepCopy;\
		if(tag2[0].isUpper, \{tag2[0]= tag2[0].toLower\}, \{tag2[0]= tag2[0].toUpper\});\
		t= \cf6 this\cf2 .getTags;\
		if (t.isNil.not, \{\
			if (t.indexOfEqual(tag).isNil.not or: \{t.indexOfEqual(tag2).isNil.not\}, \
				\{^\cf8 true\cf2 \}, \{^\cf8 false\cf2 \});\
		\},\{^\cf8 false\cf2 \});\
	\}\
	\
	caseStrange \{\
		\cf5 var\cf2  string2;\
		string2= \cf6 this\cf2 ;\
		string2[0]= string2[0].toUpper;\
		\cf6 this\cf2 .postln;\
		string2.postln;\
	\}\
\
\
\
\}}