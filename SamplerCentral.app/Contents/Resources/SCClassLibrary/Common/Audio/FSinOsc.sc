{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf600
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red191\green0\blue0;\red0\green0\blue0;\red0\green0\blue191;
\red0\green0\blue255;\red102\green102\blue191;\red0\green115\blue0;}
{\*\expandedcolortbl;;\csgenericrgb\c75000\c0\c0;\csgenericrgb\c0\c0\c0;\csgenericrgb\c0\c0\c75000;
\csgenericrgb\c0\c0\c100000;\csgenericrgb\c40000\c40000\c75000;\csgenericrgb\c0\c45000\c0;}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 /*\
	FSinOsc - fixed frequency sine oscillator\
	arguments :\
		freq - frequency in cycles per second. Must be a scalar.\
		mul - multiply by signal or scalar\
		add - add to signal or scalar\
\
	This unit generator uses a very fast algorithm for generating a sine\
	wave at a fixed frequency.\
*/\cf3 \
\
\cf4 FSinOsc\cf3  : \cf4 UGen\cf3  \{\
	*ar \{ \cf5 arg\cf3  freq=440.0, iphase = 0.0, mul = 1.0, add = 0.0;\
		^\cf6 this\cf3 .multiNew(\cf7 'audio'\cf3 , freq, iphase).madd(mul, add)\
	\}\
	*kr \{ \cf5 arg\cf3  freq=440.0, iphase = 0.0, mul = 1.0, add = 0.0;\
		^\cf6 this\cf3 .multiNew(\cf7 'control'\cf3 , freq, iphase).madd(mul, add)\
	\}\
\}\
\
\
\cf4 Klang\cf3  : \cf4 UGen\cf3  \{\
	*ar \{ \cf5 arg\cf3  specificationsArrayRef, freqscale = 1.0, freqoffset = 0.0;\
		specificationsArrayRef = specificationsArrayRef.multichannelExpandRef(2);\
			^\cf6 this\cf3 .multiNewList([\cf7 'audio'\cf3 , freqscale,\
						freqoffset, specificationsArrayRef] )\
	\}\
	*new1 \{ \cf5 arg\cf3  rate, freqscale, freqoffset, arrayRef;\
		\cf5 var\cf3  specs, freqs, amps, phases;\
		# freqs, amps, phases = arrayRef.dereference;\
		specs = [freqs,\
				amps ?? \{\cf4 Array\cf3 .fill(freqs.size,1.0)\},\
				phases ?? \{\cf4 Array\cf3 .fill(freqs.size,0.0)\}\
				].flop.flat;\
\
		^\cf6 super\cf3 .new.rate_(rate).addToSynth.init([freqscale,freqoffset] ++ specs);\
	\}\
 	init \{ \cf5 arg\cf3  theInputs;\
 		\cf2 // store the inputs as an array\cf3 \
 		inputs = theInputs;\
 	\}\
	argNamesInputsOffset \{ ^2 \}\
\}\
\
\cf4 Klank\cf3  : \cf4 UGen\cf3  \{\
	*ar \{ \cf5 arg\cf3  specificationsArrayRef, input, freqscale = 1.0, freqoffset = 0.0, decayscale = 1.0;\
			specificationsArrayRef = specificationsArrayRef.multichannelExpandRef(2);\
			^\cf6 this\cf3 .multiNewList([\cf7 'audio'\cf3 ,  input, freqscale,\
						freqoffset, decayscale, specificationsArrayRef] )\
	\}\
	*new1 \{ \cf5 arg\cf3  rate, input, freqscale, freqoffset, decayscale, arrayRef;\
		\cf5 var\cf3  specs, freqs, amps, times;\
		# freqs, amps, times = arrayRef.dereference;\
		specs = [freqs,\
				amps ?? \{\cf4 Array\cf3 .fill(freqs.size,1.0)\},\
				times ?? \{\cf4 Array\cf3 .fill(freqs.size,1.0)\}\
				].flop.flat;\
\
		^\cf6 super\cf3 .new.rate_(rate).addToSynth.init([input,freqscale,freqoffset,decayscale] ++ specs);\
	\}\
 	init \{ \cf5 arg\cf3  theInputs;\
 		\cf2 // store the inputs as an array\cf3 \
 		inputs = theInputs;\
 	\}\
	argNamesInputsOffset \{ ^2 \}\
\}\
\
\cf4 DynKlank\cf3  : \cf4 UGen\cf3  \{\
\
	*ar \{ \cf5 arg\cf3  specificationsArrayRef, input, freqscale = 1.0, freqoffset = 0.0, decayscale = 1.0;\
		specificationsArrayRef = specificationsArrayRef.multichannelExpandRef(2);\
		^\cf6 this\cf3 .multiNew(\cf7 \\audio\cf3 , specificationsArrayRef, input, freqscale, freqoffset, decayscale)\
	\}\
\
	*kr \{ \cf5 arg\cf3  specificationsArrayRef, input, freqscale = 1.0, freqoffset = 0.0, decayscale = 1.0;\
		specificationsArrayRef = specificationsArrayRef.multichannelExpandRef(2);\
		^\cf6 this\cf3 .multiNew(\cf7 \\control\cf3 , specificationsArrayRef, input, freqscale, freqoffset, decayscale)\
	\}\
\
	*new1 \{ \cf5 arg\cf3  rate, specificationsArrayRef, input, freqscale = 1.0, freqoffset = 0.0, decayscale = 1.0;\
		\cf5 var\cf3  spec = specificationsArrayRef.value;\
		\cf5 var\cf3  selector = \cf6 this\cf3 .methodSelectorForRate(rate);\
		^\cf4 Ringz\cf3 .perform(selector,\
				input,\
				spec[0] ? #[440.0] * freqscale + freqoffset,\
				spec[2] ? #[1.0] * decayscale,\
				spec[1] ? #[1.0]\
		).sum\
	\}\
\}\
\
\cf4 DynKlang\cf3  : \cf4 UGen\cf3  \{\
\
	*ar \{ \cf5 arg\cf3  specificationsArrayRef, freqscale = 1.0, freqoffset = 0.0;\
		specificationsArrayRef = specificationsArrayRef.multichannelExpandRef(2);\
		^\cf6 this\cf3 .multiNew(\cf7 \\audio\cf3 , specificationsArrayRef, freqscale, freqoffset);\
	\}\
\
	*kr \{ \cf5 arg\cf3  specificationsArrayRef, freqscale = 1.0, freqoffset = 0.0;\
		specificationsArrayRef = specificationsArrayRef.multichannelExpandRef(2);\
		^\cf6 this\cf3 .multiNew(\cf7 \\control\cf3 , specificationsArrayRef, freqscale, freqoffset);\
	\}\
\
	*new1 \{ \cf5 arg\cf3  rate, specificationsArrayRef, freqscale = 1.0, freqoffset = 0.0;\
		\cf5 var\cf3  spec = specificationsArrayRef.value;\
		\cf5 var\cf3  selector = \cf6 this\cf3 .methodSelectorForRate(rate);\
		^\cf4 SinOsc\cf3 .perform(selector,\
				spec[0] ? #[440.0] * freqscale + freqoffset,\
				spec[2] ? #[0.0],\
				spec[1] ? #[1.0]\
		).sum\
	\}\
\}\
\
\
\cf4 Blip\cf3  : \cf4 UGen\cf3  \{\
	*ar \{ \cf5 arg\cf3  freq=440.0, numharm = 200.0, mul = 1.0, add = 0.0;\
		^\cf6 this\cf3 .multiNew(\cf7 'audio'\cf3 , freq, numharm).madd(mul, add)\
	\}\
	*kr \{ \cf5 arg\cf3  freq=440.0, numharm = 200.0, mul = 1.0, add = 0.0;\
		^\cf6 this\cf3 .multiNew(\cf7 'control'\cf3 , freq, numharm).madd(mul, add)\
	\}\
\}\
\
\cf4 Saw\cf3  : \cf4 UGen\cf3  \{\
	*ar \{ \cf5 arg\cf3  freq=440.0, mul = 1.0, add = 0.0;\
		^\cf6 this\cf3 .multiNew(\cf7 'audio'\cf3 , freq).madd(mul, add)\
	\}\
	*kr \{ \cf5 arg\cf3  freq=440.0, mul = 1.0, add = 0.0;\
		^\cf6 this\cf3 .multiNew(\cf7 'control'\cf3 , freq).madd(mul, add)\
	\}\
\}\
\
\cf4 Pulse\cf3  : \cf4 UGen\cf3  \{\
	*ar \{ \cf5 arg\cf3  freq=440.0, width = 0.5, mul = 1.0, add = 0.0;\
		^\cf6 this\cf3 .multiNew(\cf7 'audio'\cf3 , freq, width).madd(mul, add)\
	\}\
	*kr \{ \cf5 arg\cf3  freq=440.0, width = 0.5, mul = 1.0, add = 0.0;\
		^\cf6 this\cf3 .multiNew(\cf7 'control'\cf3 , freq, width).madd(mul, add)\
	\}\
\}\
}