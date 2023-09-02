{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf600
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;\red191\green0\blue0;\red0\green0\blue191;
\red0\green0\blue255;\red102\green102\blue191;\red96\green96\blue96;\red0\green115\blue0;\red51\green51\blue191;
}
{\*\expandedcolortbl;;\csgenericrgb\c0\c0\c0;\csgenericrgb\c75000\c0\c0;\csgenericrgb\c0\c0\c75000;
\csgenericrgb\c0\c0\c100000;\csgenericrgb\c40000\c40000\c75000;\csgenericrgb\c37500\c37500\c37500;\csgenericrgb\c0\c45000\c0;\csgenericrgb\c20000\c20000\c75000;
}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 \
\cf3 /*\
\
still need to RedAbstractSamplerVoice\
\
*/\cf2 \
\
\
\cf4 RedCombiSampler\cf2  \{\
	\cf5 var\cf2  keys, ramSampler, diskSampler;\
	\cf5 var\cf2  server, thresh, <mp3;\
	\
	*new\{\cf5 |server, thresh|\cf2 \
		^\cf6 super\cf2 .new.init(server)\
	\}\
	\
	init \{\cf5 |argServer, argthresh|\cf2 \
		keys= ();\
		server= argServer ?? \cf4 Server\cf2 .default;\
		thresh= argthresh ?? 30;\
		\
		keys= \cf4 Dictionary\cf2 .new;\
		mp3= \cf4 Dictionary\cf2 .new;\
		\
		ramSampler= \cf4 RedSampler\cf2 (server);\
		diskSampler= \cf4 RedDiskInSamplerGiga\cf2 (server);\
	\}\
\
	prepareForPlay\{\cf5 |key, path, startFrame= 0, numFrames|\cf2 \
		\cf5 var\cf2  f;\
		if(path.extension==\cf7 "mp3"\cf2 , \{path= \cf4 MP3\cf2 .decodeToTmpDir(path); mp3[key]= path.deepCopy;\});\
		f= \cf4 SoundFile\cf2 .new;\
		f.openRead(path);\
		if (f.duration > thresh, \{ keys[key]= \cf8 \\disk\cf2  \}, \{keys[key]= \cf8 \\ram\cf2 \});\
		f.close;\
		case \
		\{keys[key]==\cf8 \\ram\cf2 \} \{ramSampler.prepareForPlay(key, path, startFrame, numFrames)\}\
		\{keys[key]==\cf8 \\disk\cf2 \} \{diskSampler.prepareForPlay(key, path, startFrame, numFrames)\};\
		\
		\}\
	channels \{\cf5 |key|\cf2 \
		case \
		\{keys[key]==\cf8 \\ram\cf2 \} \{^ramSampler.channels(key)\}\
		\{keys[key]==\cf8 \\disk\cf2 \} \{^diskSampler.channels(key)\}\
		\{keys[key]== \cf9 nil\cf2  \} \{^\cf9 nil\cf2 \};\
	\}\
	buffers \{\cf5 |key|\cf2 \
		case \
		\{keys[key]==\cf8 \\ram\cf2 \} \{^ramSampler.buffers(key)\}\
		\{keys[key]==\cf8 \\disk\cf2 \} \{^diskSampler.buffers(key)\}\
		\{keys[key]== \cf9 nil\cf2  \} \{^\cf9 nil\cf2 \};\
	\}\
	voicesLeft \{\cf5 |key|\cf2 \
		case \
		\{keys[key]==\cf8 \\ram\cf2 \} \{^ramSampler.voicesLeft(key)\}\
		\{keys[key]==\cf8 \\disk\cf2 \} \{^diskSampler.voicesLeft(key)\}\
		\{keys[key]== \cf9 nil\cf2  \} \{^\cf9 nil\cf2 \};\
	\}	\
	isPlaying \{ \cf5 |key|\cf2 \
		case \
		\{keys[key]==\cf8 \\ram\cf2 \} \{^ramSampler.isPlaying(key)\}\
		\{keys[key]==\cf8 \\disk\cf2 \} \{^diskSampler.isPlaying(key)\}\
		\{keys[key]== \cf9 nil\cf2  \} \{^\cf9 false\cf2 \};\
	\}\
	play \{ \cf5 |key, attack= 0, sustain, release= 0, amp= 0.7, out= 0, group, loop= 0, pan= 0, speed= 1, offset= 0, startLoop= 0, endLoop= 1, id, loopId|\cf2 \
		case \
		\{keys[key]==\cf8 \\ram\cf2 \} \{ramSampler.play(key, attack, sustain, release, amp, out, group, loop, pan, speed, offset, startLoop, endLoop, id, loopId)\}\
		\{keys[key]==\cf8 \\disk\cf2 \} \{diskSampler.play(key, attack, sustain, release, amp, out, group, loop, pan, speed, id, loopId)\};\
	\}\
	stop \{ \cf5 arg\cf2  key... args;\
		case \
		\{keys[key]==\cf8 \\ram\cf2 \} \{ramSampler.stop(key, *args)\}\
		\{keys[key]==\cf8 \\disk\cf2 \} \{diskSampler.stop(key, *args)\}\
		\{keys[key]== \cf9 nil\cf2  \} \{\cf7 "WARNING:"\cf2 .postln; \cf7 "RedCombiSampler: key not found"\cf2 \};\
	\}\
	length \{ \cf5 arg\cf2  key;\
		case \
		\{keys[key]==\cf8 \\ram\cf2 \} \{^ramSampler.length(key)\}\
		\{keys[key]==\cf8 \\disk\cf2 \} \{^diskSampler.length(key)\}\
		\{keys[key]== \cf9 nil\cf2  \} \{^\cf9 nil\cf2 \};\
	\}\
\
	speed_\{ \cf5 arg\cf2  val; \
		ramSampler.speed_(val);\
		diskSampler.speed_(val);\
	\}\
	\
	amp_\{ \cf5 arg\cf2  val; \
		ramSampler.amp_(val);\
		diskSampler.amp_(val);\
	\}\
	flush \{ \cf5 arg\cf2  release; \
		ramSampler.flush(release);\
		diskSampler.flush(release);\
	\}\
	freeKey \{ \cf5 arg\cf2  key;\
		case \
		\{keys[key]==\cf8 \\ram\cf2 \} \{ramSampler.freeKey(key)\}\
		\{keys[key]==\cf8 \\disk\cf2 \} \{diskSampler.freeKey(key)\};\
		keys.removeAt(key);\
		if (mp3[key].isNil.not, \{ (\cf7 "rm"\cf2  + mp3[key]).unixCmd; mp3.removeAt(key) \});\
	\}\
	free \{\
		ramSampler.free;\
		diskSampler.free;\
		keys= \cf4 Dictionary\cf2 .new;\
		mp3.do(\{\cf5 |it|\cf2  (\cf7 "rm"\cf2  + it).unixCmd; \});\
		\cf3 //maybe ("rm" + "/tmp/sc3mp3read-*.*").unixCmd; to be sure...\cf2 \
	\}\
	keys \{\
		^(ramSampler.keys++diskSampler.keys);\
	\}\
	loadedKeys \{\
		^(ramSampler.loadedKeys++diskSampler.loadedKeys);\
	\}\
	playingKeys \{\
		^(ramSampler.playingKeys++diskSampler.playingKeys);\
	\}\
	overlaps_\{\cf5 |val|\cf2 \
		ramSampler.overlaps_(val);\
		diskSampler.overlaps_(val);\
	\}\
	overlaps \{\
		^diskSampler.overlaps;\
	\}\
	numFrames_\{\cf5 |val|\cf2 \
		diskSampler.numFrames_(val);\
	\}\
	numFrames \{\
		^diskSampler.numFrames;\
	\}\
	set \{\cf5 |key|\cf2 \
		case \cf3 //only sets first voice, but that's usually all thats needed\cf2 \
		\{keys[key]==\cf8 \\ram\cf2 \} \{^ramSampler.keys[key][0]\}\
		\{keys[key]==\cf8 \\disk\cf2 \} \{^diskSampler.keys[key][0]\}\
		\{keys[key]== \cf9 nil\cf2  \} \{\cf7 "WARNING:"\cf2 .postln; \cf7 "RedCombiSampler: key not found"\cf2 \};\
	\}\
\
\
\
\}\
\
}