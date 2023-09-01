{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf600
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red191\green0\blue0;\red0\green0\blue0;\red0\green0\blue191;
\red0\green0\blue255;\red102\green102\blue191;\red51\green51\blue191;\red0\green115\blue0;}
{\*\expandedcolortbl;;\csgenericrgb\c75000\c0\c0;\csgenericrgb\c0\c0\c0;\csgenericrgb\c0\c0\c75000;
\csgenericrgb\c0\c0\c100000;\csgenericrgb\c40000\c40000\c75000;\csgenericrgb\c20000\c20000\c75000;\csgenericrgb\c0\c45000\c0;}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 //This file is part of The BBCut Library. Copyright (C) 2001  Nick M.Collins distributed under the terms of the GNU General Public License full notice in file BBCutLibrary.help\cf3 \
\
\cf2 //CutStream1 24/12/04  by N.M.Collins \cf3 \
\
\cf2 //envelope applied in record saves CPU on playback! \cf3 \
\
\cf2 //could have a single playback synth running with retrigger, though would have to free whenever\cf3 \
\cf2 //recording a new block- can add a free msg though if keep track\cf3 \
\
\
\cf4 CutStream1\cf3  : \cf4 CutSynth\cf3  \{	\
\
\cf5 var\cf3  <>inbus,<>bbcutbuf, deallocate;\
\cf5 var\cf3  dutycycle, atkprop, relprop, curve;\
\cf5 var\cf3  playdef, recdef;\
\
	*new\{\cf5 arg\cf3  inbus, bbcutbuf, dutycycle, atkprop, relprop, curve; \
	^\cf6 super\cf3 .new.initCutStream1(inbus, bbcutbuf,dutycycle, atkprop, relprop, curve);\
	\}\
	\
	initCutStream1 \{\cf5 arg\cf3  ib, bcb, dc,ap,rp,c; \
	\
		deallocate=\cf7 false\cf3 ;\
		inbus=ib ?? \{\cf4 Server\cf3 .default.options.numOutputBusChannels\};\
		bbcutbuf = bcb; \cf2 //could be nil, dealt with in setup\cf3 \
		dutycycle= dc ? 1.0;  \
		atkprop= ap ? 0.001;\
		relprop= rp ? 0.001;\
		curve= c ? 0;\
		\
	\}\
\
	\
			\
	setup \{\
		playdef= \cf8 \\cs1playbuf\cf3 ++(cutgroup.numChannels.asSymbol);\
		recdef= \cf8 \\cs1recordbuf\cf3 ++(cutgroup.numChannels.asSymbol);\
		\
		\cf2 //have to wait until cutgroup known and have numChannels to create a Buffer\cf3 \
		bbcutbuf=bbcutbuf ?? \{deallocate=\cf7 true\cf3 ; \cf4 BBCutBuffer\cf3 .alloc(\cf4 Server\cf3 .default,44100,cutgroup.numChannels)\};\
		\
		playdef.postln;\
		recdef.postln;\
	\}\
	\
		\
	free \{\
		if (deallocate,\{bbcutbuf.free;\});\
	\}\
	\
	\cf2 //could refine CPU use by rendering one playbuf for all later repeats (need to know block.length-cuts[0][0] and sending retrigger messages for each cut\cf3 \
	\
	renderBlock \{\cf5 arg\cf3  block,clock;\
		\cf5 var\cf3  s, grpnum, dc, atk, rel, crv;\
		\
		s=cutgroup.server;\
		\
		grpnum=cutgroup.synthgroup.nodeID;\
		\
		\cf2 //pbsfunc.tryPerform(\\updateblock,  block);\cf3 \
		dutycycle.tryPerform(\cf8 \\updateblock\cf3 ,  block);\
		atkprop.tryPerform(\cf8 \\updateblock\cf3 ,  block);\
		relprop.tryPerform(\cf8 \\updateblock\cf3 ,  block);\
		curve.tryPerform(\cf8 \\updateblock\cf3 ,  block);\
		\
		block.cuts.do(\{\cf5 arg\cf3  cut,i;\
		\cf5 var\cf3  dur;\
		\
		dc= dutycycle.value(i,block);\
		atk= atkprop.value(i,block);\
		rel= relprop.value(i,block);\
		crv= curve.value(i,block);\
		\
		dur=cut[1]*dc; \cf2 //adjusted to \cf3 \
		\
		if(i==0,\{\
		\cf2 //block.msgs[i].add([\\s_new, \\br1playthrough, s.nextNodeID, 0,1,\\dur,dur]);\cf3 \
		\cf2 //hard coded for beat induction from bus 16\cf3 \
		block.msgs[i].add([\cf8 \\s_new\cf3 , recdef, s.nextNodeID, 1,grpnum,\cf8 \\bufnum\cf3 ,bbcutbuf.bufnum,\cf8 \\dur\cf3 ,dur,\cf8 \\inbus\cf3 ,inbus.value,\cf8 \\outbus\cf3 ,cutgroup.index, \cf8 \\atkprop\cf3 , atk, \cf8 \\relprop\cf3 , rel, \cf8 \\curve\cf3 , crv]);\
		\},\{ \cf2 //this was missing dur*dc before, rationalised now\cf3 \
		block.msgs[i].add([\cf8 \\s_new\cf3 , playdef, s.nextNodeID, 0,grpnum,\cf8 \\bufnum\cf3 ,bbcutbuf.bufnum,\cf8 \\dur\cf3 ,dur,\cf8 \\outbus\cf3 ,cutgroup.index]);\
		\});\
		\
		if(trace.notNil,\{trace.msg(block, i,0.0,0.0,\cf8 \\repeatlength\cf3 ,dur)\});\
		\
		\});\
		\
		\cf2 //don't need to return block, updated by reference\cf3 \
	\}\
	\
	\
	\
\
	\
	*initClass \{\
		\
		\cf4 StartUp\cf3 .add(\{\
		\
		2.do(\{\cf5 arg\cf3  i;\
		\
		\cf4 SynthDef\cf3 .writeOnce(\cf8 \\cs1playbuf\cf3 ++((i+1).asSymbol),\{\cf5 arg\cf3  bufnum=0,outbus=0,dur=0.1;  \
		\cf5 var\cf3  tmp;\
		\
		tmp= \cf4 PlayBuf\cf3 .ar(i+1,bufnum,1,1,0,1);\
		\
		\cf4 Out\cf3 .ar(outbus,tmp*\cf4 EnvGen\cf3 .kr(\cf4 Env\cf3 ([1,1],[dur]),doneAction:2));\
		\
		\});\
		\
		\cf2 //run record buf for duration of block- or just make one and keep retriggering? \cf3 \
		\cf4 SynthDef\cf3 .writeOnce(\cf8 \\cs1recordbuf\cf3 ++((i+1).asSymbol),\{\cf5 arg\cf3  bufnum=0,inbus=8,outbus=0,dur=0.1, atkprop=0.0,relprop=0.0,curve=0; \
		\cf5 var\cf3  in,tmp;\
		\
		\cf2 //used to be InFeedback for safety- must worry about execution order?\cf3 \
		\cf2 //or make two versions, an InFeedback one as well \cf3 \
		in=\cf4 In\cf3 .ar(inbus,i+1)*\cf4 EnvGen\cf3 .kr(\cf4 Env\cf3 ([0,1,1,0],[atkprop,1.0-atkprop-relprop,relprop]*dur,curve),doneAction:2);\
		\
		tmp= \cf4 RecordBuf\cf3 .ar(in,bufnum,0,1,0,1,1,1);\
		\
		\cf4 ReplaceOut\cf3 .ar(outbus,in);\
		\
		\});\
		\
		\});\
		\
		\});\
		\
	\}\
	\
\}}