{\rtf1\ansi\ansicpg1252\cocoartf1265\cocoasubrtf200
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red191\green0\blue0;\red0\green0\blue0;\red0\green0\blue191;
\red0\green0\blue255;\red96\green96\blue96;\red0\green115\blue0;\red102\green102\blue191;\red51\green51\blue191;
}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 //these classes are part of the RedSample package / redFrik, gnu gpl v2\cf3 \
\cf2 //preloads buffer into ram\cf3 \
\
\cf4 RedSampler\cf3  : \cf4 RedAbstractSampler\cf3  \{					\cf2 //playing buffers in ram\cf3 \
	*initClass \{\
		\cf4 StartUp\cf3 .add\{\
			8.do\{\cf5 |i|\cf3 								\cf2 //change here for more channels than 8\cf3 \
				\cf4 SynthDef\cf3 (\cf6 "redSampler-"\cf3 ++(i+1), \{\
					\cf5 |i_out= 0, bufnum, amp= 0.7, attack= 0.01, sustain, release= 0.1, gate= 1, pan= 0, offset= 0, speed= 1|\cf3 \
					\
					\cf5 var\cf3  src= \cf4 PlayBuf\cf3 .ar(\
						i+1,\
						bufnum,\
						\cf4 BufRateScale\cf3 .ir(bufnum)*speed.lag(0.3),\
						1,\
						\cf4 BufFrames\cf3 .ir(bufnum)*offset,\
						0\
					);\
					\cf5 var\cf3  env= \cf4 EnvGen\cf3 .kr(\
						\cf4 Env\cf3 (#[0, 1, 1, 0], [attack, sustain*((speed.abs).reciprocal), release], -4),\
						gate,\
						1,\
						0,\
						1,\
						2						\cf2 //doneAction\cf3 \
					);\
					if (i== 0, \{\
						\cf4 Out\cf3 .ar(i_out, \cf4 Pan2\cf3 .ar(src*env*amp, pan));\
						\},\{\
						\cf4 Out\cf3 .ar(i_out, \cf4 Balance2\cf3 .ar(src[0]*env*amp, src[1]*env*amp, pan));\
					\});\
				\}, #[\cf7 'ir'\cf3 ]).store;\
				\cf4 SynthDef\cf3 (\cf6 "redSampler-"\cf3 ++(i+1)++\cf6 "loop"\cf3 , \{\
					\cf5 |i_out= 0, bufnum, amp= 0.7, attack= 0.01, release= 0.1, gate= 1, pan= 0, offset= 0, speed= 1, startLoop= 0.0, endLoop= 1.0, loopId|\cf3 \
					\cf5 var\cf3  src= \cf4 LoopBuf\cf3 .ar(\
						i+1,\
						bufnum,\
						\cf4 BufRateScale\cf3 .ir(bufnum)*speed.lag(0.3),\
						0, \cf2 //gate...\cf3 \
						\cf4 BufFrames\cf3 .ir(bufnum)*offset, \cf2 //startPos\cf3 \
						\cf4 BufFrames\cf3 .ir(bufnum)*startLoop,\
						\cf4 BufFrames\cf3 .ir(bufnum)*endLoop,\
						2 \cf2 //interpolation\cf3 \
					);\
					\cf5 var\cf3  env= \cf4 EnvGen\cf3 .kr(\
						\cf4 Env\cf3 (#[0, 1, 0], [attack, release], -4, 1),\
						gate,\
						1,\
						0,\
						1,\
						2						\cf2 //doneAction\cf3 \
					);\
					\cf4 SendTrig\cf3 .kr(\cf4 Impulse\cf3 .kr(1/\cf4 BufDur\cf3 .ir(bufnum))*\cf4 EnvGen\cf3 .kr(\cf4 Env\cf3 .new([0, 0, 1], [0.01, 0.01])), loopId); \cf2 //send trigger when loop starts again\cf3 \
					if (i== 0, \{\
						\cf4 Out\cf3 .ar(i_out, \cf4 Pan2\cf3 .ar(src*env*amp, pan));\
						\},\{\
						\cf4 Out\cf3 .ar(i_out, \cf4 Balance2\cf3 .ar(src[0]*env*amp, src[1]*env*amp, pan));\
					\});\
				\}, #[\cf7 'ir'\cf3 ]).store;\
				\cf4 SynthDef\cf3 (\cf6 "redSampler-"\cf3 ++(i+1)++\cf6 "loopEnv"\cf3 , \{\
					\cf5 |i_out= 0, bufnum, amp= 0.7, attack= 0.01, sustain, release= 0.1, gate= 1, pan= 0, offset= 0, speed= 1, startLoop= 0, endLoop= 1|\cf3 \
					\cf5 var\cf3  src= \cf4 LoopBuf\cf3 .ar(\
						i+1,\
						bufnum,\
						\cf4 BufRateScale\cf3 .ir(bufnum)*speed.lag(0.3),\
						0, \cf2 //gate...\cf3 \
						\cf4 BufFrames\cf3 .ir(bufnum)*offset, \cf2 //startPos\cf3 \
						\cf4 BufFrames\cf3 .ir(bufnum)*startLoop,\
						\cf4 BufFrames\cf3 .ir(bufnum)*endLoop,\
						2 \cf2 //interpolation\cf3 \
					);\
					\cf5 var\cf3  env= \cf4 EnvGen\cf3 .kr(\
						\cf4 Env\cf3 (#[0, 1, 1, 0], [attack, sustain, release], -4),\
						gate,\
						1,\
						0,\
						1,\
						2						\cf2 //doneAction\cf3 \
					);\
					if (i== 0, \{\
						\cf4 Out\cf3 .ar(i_out, \cf4 Pan2\cf3 .ar(src*env*amp, pan));\
						\},\{\
						\cf4 Out\cf3 .ar(i_out, \cf4 Balance2\cf3 .ar(src[0]*env*amp, src[1]*env*amp, pan));\
					\});\
				\}, #[\cf7 'ir'\cf3 ]).store;\
				\
				\cf2 // with coyote to send OSC Triggers:\cf3 \
				\
		\cf4 SynthDef\cf3 (\cf6 "redSampler-"\cf3 ++(i+1)++\cf6 "Trigger"\cf3 , \{\
					\cf5 |i_out= 0, bufnum, amp= 0.7, attack= 0.01, sustain, release= 0.1, gate= 1, pan= 0, offset= 0, speed= 1, id= 0|\cf3 \
					\
					\cf5 var\cf3  src= \cf4 PlayBuf\cf3 .ar(\
						i+1,\
						bufnum,\
						\cf4 BufRateScale\cf3 .ir(bufnum)*speed.lag(0.3),\
						1,\
						\cf4 BufFrames\cf3 .ir(bufnum)*offset,\
						0\
					);\
					\cf5 var\cf3  env= \cf4 EnvGen\cf3 .kr(\
						\cf4 Env\cf3 (#[0, 1, 1, 0], [attack, sustain*((speed.abs).reciprocal), release], -4),\
						gate,\
						1,\
						0,\
						1,\
						2						\cf2 //doneAction\cf3 \
					);\
					\
					if (i== 0, \{\
						\cf2 //SendTrig.kr(Coyote.kr(src, minDur: 0.31), id, 1);\cf3 \
						\cf4 SendTrig\cf3 .kr(\cf4 Coyote\cf3 .kr(src, minDur: 0.41, thresh: 0.05, fastMul: 0.6), id, 1);\
						\cf4 SendTrig\cf3 .kr(\cf4 A2K\cf3 .kr(\cf4 DetectSilence\cf3 .ar(src, 0.01, 0.1)), id, 0);\
						\},\{\
						\cf2 //SendTrig.kr(Coyote.kr(src[0], minDur: 0.31), id, 1);\cf3 \
						\cf4 SendTrig\cf3 .kr(\cf4 Coyote\cf3 .kr(src[0], minDur: 0.41, thresh: 0.05, fastMul: 0.6), id, 1);\
						\cf4 SendTrig\cf3 .kr(\cf4 A2K\cf3 .kr(\cf4 DetectSilence\cf3 .ar(src[0], 0.01, 0.1)), id, 0);\
					\});\
					\
					if (i== 0, \{\
						\cf4 Out\cf3 .ar(i_out, \cf4 Pan2\cf3 .ar(src*env*amp, pan));\
						\},\{\
						\cf4 Out\cf3 .ar(i_out, \cf4 Balance2\cf3 .ar(src[0]*env*amp, src[1]*env*amp, pan));\
					\});\
				\}, #[\cf7 'ir'\cf3 ]).store;\
				\cf4 SynthDef\cf3 (\cf6 "redSampler-"\cf3 ++(i+1)++\cf6 "loop"\cf3 ++\cf6 "Trigger"\cf3 , \{\
					\cf5 |i_out= 0, bufnum, amp= 0.7, attack= 0.01, release= 0.1, gate= 1, pan= 0, offset= 0, speed= 1, startLoop= 0.0, endLoop= 1.0, id= 0|\cf3 \
					\cf5 var\cf3  src= \cf4 LoopBuf\cf3 .ar(\
						i+1,\
						bufnum,\
						\cf4 BufRateScale\cf3 .ir(bufnum)*speed.lag(0.3),\
						0, \cf2 //gate...\cf3 \
						\cf4 BufFrames\cf3 .ir(bufnum)*offset, \cf2 //startPos\cf3 \
						\cf4 BufFrames\cf3 .ir(bufnum)*startLoop,\
						\cf4 BufFrames\cf3 .ir(bufnum)*endLoop,\
						2 \cf2 //interpolation\cf3 \
					);\
					\cf5 var\cf3  env= \cf4 EnvGen\cf3 .kr(\
						\cf4 Env\cf3 (#[0, 1, 0], [attack, release], -4, 1),\
						gate,\
						1,\
						0,\
						1,\
						2						\cf2 //doneAction\cf3 \
					);\
					if (i== 0, \{\
						\cf2 //SendTrig.kr(Coyote.kr(src, minDur: 0.31), id, 1);\cf3 \
						\cf4 SendTrig\cf3 .kr(\cf4 Coyote\cf3 .kr(src, minDur: 0.41, thresh: 0.05, fastMul: 0.6), id, 1);\
						\cf4 SendTrig\cf3 .kr(\cf4 A2K\cf3 .kr(\cf4 DetectSilence\cf3 .ar(src, 0.01, 0.1)), id, 0);\
						\},\{\
						\cf2 //SendTrig.kr(Coyote.kr(src[0], minDur: 0.31), id, 1);\cf3 \
						\cf4 SendTrig\cf3 .kr(\cf4 Coyote\cf3 .kr(src[0], minDur: 0.41, thresh: 0.05, fastMul: 0.6), id, 1);\
						\cf4 SendTrig\cf3 .kr(\cf4 A2K\cf3 .kr(\cf4 DetectSilence\cf3 .ar(src[0], 0.01, 0.1)), id, 0);\
					\});\
					if (i== 0, \{\
						\cf4 Out\cf3 .ar(i_out, \cf4 Pan2\cf3 .ar(src*env*amp, pan));\
						\},\{\
						\cf4 Out\cf3 .ar(i_out, \cf4 Balance2\cf3 .ar(src[0]*env*amp, src[1]*env*amp, pan));\
					\});\
				\}, #[\cf7 'ir'\cf3 ]).store;\
				\cf4 SynthDef\cf3 (\cf6 "redSampler-"\cf3 ++(i+1)++\cf6 "loopEnv"\cf3 ++\cf6 "Trigger"\cf3 , \{\
					\cf5 |i_out= 0, bufnum, amp= 0.7, attack= 0.01, sustain, release= 0.1, gate= 1, pan= 0, offset= 0, speed= 1, startLoop= 0, endLoop= 1, id= 0|\cf3 \
					\cf5 var\cf3  src= \cf4 LoopBuf\cf3 .ar(\
						i+1,\
						bufnum,\
						\cf4 BufRateScale\cf3 .ir(bufnum)*speed.lag(0.3),\
						0, \cf2 //gate...\cf3 \
						\cf4 BufFrames\cf3 .ir(bufnum)*offset, \cf2 //startPos\cf3 \
						\cf4 BufFrames\cf3 .ir(bufnum)*startLoop,\
						\cf4 BufFrames\cf3 .ir(bufnum)*endLoop,\
						2 \cf2 //interpolation\cf3 \
					);\
					\cf5 var\cf3  env= \cf4 EnvGen\cf3 .kr(\
						\cf4 Env\cf3 (#[0, 1, 1, 0], [attack, sustain, release], -4),\
						gate,\
						1,\
						0,\
						1,\
						2						\cf2 //doneAction\cf3 \
					);\
					if (i== 0, \{\
						\cf4 SendTrig\cf3 .kr(\cf4 Coyote\cf3 .kr(src, minDur: 0.31), id, 1);\
						\},\{\
						\cf4 SendTrig\cf3 .kr(\cf4 Coyote\cf3 .kr(src[0], minDur: 0.31), id, 1);\
					\});\
					if (i== 0, \{\
						\cf4 Out\cf3 .ar(i_out, \cf4 Pan2\cf3 .ar(src*env*amp, pan));\
						\},\{\
						\cf4 Out\cf3 .ar(i_out, \cf4 Balance2\cf3 .ar(src[0]*env*amp, src[1]*env*amp, pan));\
					\});\
				\}, #[\cf7 'ir'\cf3 ]).store;\
				\
				\cf2 //"redSampler-"++(i+1)++"loopEnv"++"Trigger"\cf3 \
\
			\}\
		\}\
	\}\
	prCreateVoice \{\cf5 |sf, startFrame, argNumFrames|\cf3 \
		\cf5 var\cf3  len;\
		if(argNumFrames.notNil, \{\
			len= argNumFrames/sf.sampleRate;\
		\}, \{\
			len= sf.numFrames-startFrame/sf.sampleRate;\
		\});\
		^\cf4 RedSamplerVoice\cf3 (server, sf.path, sf.numChannels, startFrame, argNumFrames, len);\
	\}\
\}\
\
\cf4 RedSamplerVoice\cf3  : \cf4 RedAbstractSamplerVoice\cf3  \{\
	defName \{^\cf6 "redSampler-"\cf3 ++channels\}\
	play \{\cf5 |attack, sustain, release, amp, out, group, loop, pan, speed, offset, startLoop, endLoop, id, loopId|\cf3 \
		\cf5 var\cf3  name= \cf8 this\cf3 .defName;\
		switch(loop,\
			1, \{name= name++\cf6 "loop"\cf3 \},\
			2, \{name= name++\cf6 "loopEnv"\cf3 \}\
		);\
		if (id.isNil.not, \{name= name++\cf6 "Trigger"\cf3 \});\
		\cf2 //name.postln;\cf3 \
		\cf2 //("id in redsampler:"+id).postln;\cf3 \
		isPlaying= \cf9 true\cf3 ;\
		synth= \cf4 Synth\cf3 .head(group ?? \{server.defaultGroup\}, name, [\
			\cf7 \\i_out\cf3 , out,\
			\cf7 \\bufnum\cf3 , buffer.bufnum,\
			\cf7 \\amp\cf3 , amp,\
			\cf7 \\attack\cf3 , attack,\
			\cf7 \\sustain\cf3 , sustain ?? \{(length-attack-release).max(0)\},\
			\cf7 \\release\cf3 , release,\
			\cf7 \\pan\cf3 , pan,\
			\cf7 \\speed\cf3 , speed,\
			\cf7 \\offset\cf3 , offset,\
			\cf7 \\startLoop\cf3 , startLoop,\
			\cf7 \\endLoop\cf3 , endLoop,\
			\cf7 \\id\cf3 , id,\
			\cf7 \\loopId\cf3 , loopId\
		]);\
		\cf4 OSCresponderNode\cf3 (server.addr, \cf7 '/n_end'\cf3 , \{\cf5 |t, r, m|\cf3 \
			if(m[1]==synth.nodeID, \{\
				isPlaying= \cf9 false\cf3 ;\
				isReleased= \cf9 false\cf3 ;\
				r.remove;\
			\});\
		\}).add;\
	\}\
	prAllocBuffer \{\cf5 |action|\cf3 \
		\cf5 var\cf3  num= numFrames ? -1;\
		buffer= \cf4 Buffer\cf3 .read(server, path, startFrame, num, action)\
	\}\
\}\
}