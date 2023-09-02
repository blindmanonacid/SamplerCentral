{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf600
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red191\green0\blue0;\red0\green0\blue0;\red0\green0\blue191;
\red0\green0\blue255;\red96\green96\blue96;\red102\green102\blue191;\red0\green115\blue0;}
{\*\expandedcolortbl;;\csgenericrgb\c75000\c0\c0;\csgenericrgb\c0\c0\c0;\csgenericrgb\c0\c0\c75000;
\csgenericrgb\c0\c0\c100000;\csgenericrgb\c37500\c37500\c37500;\csgenericrgb\c40000\c40000\c75000;\csgenericrgb\c0\c45000\c0;}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 //This file is part of The BBCut Library. Copyright (C) 2001  Nick M.Collins distributed under the terms of the GNU General Public License full notice in file BBCutLibrary.help \cf3 \
\
\cf2 //CutRev1 N.M.Collins 13/1/05\cf3 \
\
\cf2 //reverb burst on block start\cf3 \
\
\cf4 CutRev1\cf3  : \cf4 CutSynth\cf3  \{ \
	\cf5 var\cf3  <>amount,<>send;	\
	\cf5 var\cf3  synthid;\
	\
	\cf2 //makes SynthDef for filter FX Synth \cf3 \
	*initClass \{ \
		\cf4 StartUp\cf3 .add(\{\
		2.do(\{\cf5 arg\cf3  i;\
\
		\cf4 SynthDef\cf3 .writeOnce(\cf6 "cutrev1chan"\cf3 ++((i+1).asSymbol),\{ \cf5 arg\cf3  inbus=0, outbus=0, amount=0, send=0.0; \
		\cf5 var\cf3  input;\
		\cf5 var\cf3  a,c,z,y,in;\
		\
		input= \cf4 In\cf3 .ar(inbus,1+1);\
		\
		in=\cf4 Limiter\cf3 .ar(send*input);\
		\
		c = 7; \cf2 // number of comb delays\cf3 \
		a = 4; \cf2 // number of allpass delays\cf3 \
		\
		\cf2 // reverb predelay time :\cf3 \
		z = \cf4 DelayN\cf3 .ar(in, 0.048,0.048);\
		\
		\cf2 //for delaytime if want modulation-	//LFNoise1.kr(0.1.rand, 0.04, 0.05)\cf3 \
		y=\cf4 Mix\cf3 .fill(c,\{\cf4 CombL\cf3 .ar(z,0.1,rrand(0.01, 0.1),5)\});\
			\
		\cf2 // chain of 4 allpass delays on each of two channels (8 total) :\cf3 \
		a.do(\{ y = \cf4 AllpassN\cf3 .ar(y, 0.051, [rrand(0.01, 0.05),rrand(0.01, 0.05)], 1) \});\
			\
		\cf4 Out\cf3 .ar( outbus, (amount*y)); \
		\
		\}); \
		\});\
		\
		\});\
		\
	\} \
	\
	*new\{\cf5 arg\cf3  amount=0.0,send=0.0;\
	\
	^\cf7 super\cf3 .new.amount_(amount).send_(send);\
	\}\
	\
	setup \{ \
	\cf2 //tail of cutgroup\cf3 \
	synthid= cutgroup.server.nextNodeID;\
		\
	cutgroup.server.sendMsg(\cf8 \\s_new\cf3 , \cf8 \\cutrev1chan\cf3 ++(cutgroup.numChannels.asSymbol), synthid, 1,cutgroup.fxgroup.nodeID,\cf8 \\inbus\cf3 ,cutgroup.index,\cf8 \\outbus\cf3 ,cutgroup.index, \cf8 \\amount\cf3 ,0,\cf8 \\send\cf3 ,0);\
		 \
	\} \
\
\
\cf2 //can't assume, individual free required for cut fx\cf3 \
\cf2 //synth should be freed automatically by group free\cf3 \
	free \{\
		cutgroup.server.sendMsg(\cf8 \\n_free\cf3 ,synthid);	\
	\}\
\
	renderBlock \{\cf5 arg\cf3  block,clock;\
		\
		block.cuts.do(\{\cf5 arg\cf3  cut,i;\
		\
		\
		\
		block.msgs[i].add([\cf8 \\n_set\cf3 , synthid,\cf8 \\amount\cf3 ,amount.value(i,block),\cf8 \\send\cf3 ,send.value(i,block)]);\
		\
		\});\
		\
		\cf2 //don't need to return block, updated by reference\cf3 \
	\}\
	\
\
\}}