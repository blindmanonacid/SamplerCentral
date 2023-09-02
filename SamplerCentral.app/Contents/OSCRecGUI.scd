{\rtf1\ansi\ansicpg1252\cocoartf1265\cocoasubrtf210
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red191\green0\blue0;\red0\green0\blue0;\red0\green0\blue255;
\red51\green51\blue191;\red96\green96\blue96;\red255\green102\blue0;\red0\green0\blue191;\red0\green115\blue0;
}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 /*\
NetAddrMon\
\
if(~recOSC= true, \{\
	\
	\});\
\
~oscOutMonitor= 1;\
~oscOutMonitor= 0;\
\
for every message matching one ip, send also to localhost with ip as msg[0]\
\
"172.16.3.180"\
'"172.16.3.180"'.interpret\
.\
\\fat\
\
\
a= ["uauauassds", "1982h"]\
\
a.copyToEnd(1)\
\
a= PathName("/Users/martin/Desktop/testNEW_140306_134303")\
r= TabFilePlayer.new("/Users/martin/Desktop/robobobotestNEWNEW_140306_133003")\
\
l= r.nextInterpret\
r.curid\
/SR190\
\
*/\cf3 \
\cf2 // ================= OSC Rec GUI Multi ====================\cf3 \
\
(\
\cf4 var\cf3  window, w, win, recbut, rec, stop, timelog, oscplayer, n, playbut, play, stopplay, playbutton;\
\cf4 var\cf3  clockGUI, recPath, recFolder;\
\cf4 var\cf3  ipText, portText, nameText, nameString;\
\cf4 var\cf3  numChans= 4;\
\cf4 var\cf3  sfView, buffer, sf, sfDuration, sfNumChannels, sfNumFrames, synth, playCursorTask;\
\cf4 var\cf3  pBus, robotMenu;\
\cf4 var\cf3  loadSoundFile, recButton;\
\cf4 var\cf3  startRecord, stopRecord, recActive, recFile;\
\cf4 var\cf3  ipString;\
\cf4 var\cf3  recSound= \cf5 false\cf3 , recSoundStart, recSoundStop, recSoundBut, recordingsPath;\
\
recordingsPath= \cf6 "~/SamplerRecordings/"\cf3 ;\
\
\cf7 ~recOSC\cf3 = \cf5 false\cf3 ;\
\
\cf8 GUI\cf3 .qt;\
\
w= \cf5 nil\cf3 !numChans;\
recbut= \cf5 nil\cf3 !numChans;\
rec= \cf5 nil\cf3 !numChans;\
stop= \cf5 nil\cf3 !numChans;\
timelog= \cf5 nil\cf3 !numChans;\
oscplayer= \cf5 nil\cf3 !numChans;\
n= \cf5 nil\cf3 !numChans;\
playbut= \cf5 nil\cf3 !numChans;\
play= \cf5 nil\cf3 !numChans;\
stopplay= \cf5 nil\cf3 !numChans;\
clockGUI= \cf5 nil\cf3 !numChans;\
recPath= \cf5 nil\cf3 !numChans;\
recFolder= \cf5 nil\cf3 !numChans;\
ipText= \cf5 nil\cf3 !numChans;\
portText =\cf5 nil\cf3 !numChans;\
nameText= \cf5 nil\cf3 !numChans;\
nameString= \cf5 nil\cf3 !numChans;\
robotMenu= \cf5 nil\cf3 !numChans;\
recActive= \cf5 false\cf3 !numChans;\
recFile= \cf5 nil\cf3 !numChans;\
\
\cf2 /*\
~ipDict= (\
	\\fatBot: ["172.16.3.177", 8888],  \
	\\circleBot: ["172.16.3.178", 8888],\
	\\updownBot: ["172.16.3.180", 8888],\
	\\headBot: ["172.16.3.179", 8888],\
	\\servo: ["172.16.3.200", 8888],\
	\\wifi: ["172.16.1.6", 8888],\
	\\first: ["172.16.3.150", 8888]\
	);\
*/\cf3 \
\
ipString= \cf7 ~ipDict\cf3 [\cf9 \\first\cf3 ][0]!numChans;\
\
recFolder= \cf6 "/Users/martin/Desktop/OSCRecordings/"\cf3 ;\
\
startRecord= \{\
	\cf7 ~recOSC\cf3 = \cf5 true\cf3 ;\
		numChans.do(\{\cf4 |i|\cf3  if(recActive[i], \{rec[i].value\}); \});\
		if(buffer.isNil.not, \{\
			if (buffer.numChannels == 1, \{\
					synth= \cf8 Synth\cf3 (\cf9 \\oscSoundFile_1\cf3 , [\cf9 \\bufnum\cf3 , buffer, \cf9 \\pbus\cf3 , pBus])\
				\},\{\
					synth= \cf8 Synth\cf3 (\cf9 \\oscSoundFile_2\cf3 , [\cf9 \\bufnum\cf3 , buffer, \cf9 \\pbus\cf3 , pBus])\
			\});\
		playCursorTask.play(\cf8 AppClock\cf3 );\
		\});\
		if(recSoundBut.value== 1, \{recSoundStart.value;\});\
\};\
	\
stopRecord= \{\
	\cf7 ~recOSC\cf3 = \cf5 false\cf3 ;\
		numChans.do(\{\cf4 |i|\cf3  if(recActive[i], \{stop[i].value\}); \}); \
		if(buffer.isNil.not, \{ playCursorTask.stop; playCursorTask.reset; \});\
		synth.free;\
		if(recSound, \{recSoundStop.value;\});\
\};\
\
window= \cf8 Window\cf3 (\cf6 "Record OSC"\cf3 , \cf8 Rect\cf3 (0, 0, 1200, 380));\
win= \cf8 HLayoutView\cf3 (window, \cf8 Rect\cf3 (0, 50, 1100, 300));\
win.decorator = \cf8 FlowLayout\cf3 (win.bounds);\
\
\cf2 //sfView= SoundFileView.new(window, Rect(220, 10, 750, 40));\cf3 \
\
		\cf8 Button\cf3 (window, \cf8 Rect\cf3 (10, 10, 80, 40))\
		.canFocus_(\cf5 false\cf3 )\
		.states_([[\cf6 "open sf"\cf3 ]])\
		.action_(\{ \cf4 |view, x, y, mod|\cf3 \
			\cf8 Dialog\cf3 .getPaths(\{ \cf4 arg\cf3  paths; \cf2 //load sound\cf3 \
			loadSoundFile.value(paths);\
				\});\
		\})\
		.canReceiveDragHandler_(\cf5 true\cf3 )\
		.receiveDragHandler_(\{\cf4 |view|\cf3 \
			\cf4 var\cf3  values, paths;\
			paths= \cf8 View\cf3 .currentDrag;\
			paths= [paths];\
			loadSoundFile.value(paths);\
		\});\
		\
		loadSoundFile= \{\cf4 |paths|\cf3 \
				if (paths[0].isSoundFile, \{\
					if(buffer.isNil.not, \{buffer.free\});\
					if(sfView.isNil.not, \{sfView.remove\});\
					sf= \cf8 SoundFile\cf3 .openRead(paths[0]);\
					\cf2 //sfView= sf.plot(paths[0], scroll, Rect(0, 0, u.bounds.width, 127));\cf3 \
					sfDuration= sf.duration;\
					sfNumChannels= sf.numChannels;\
					sfView= \cf8 SoundFileView\cf3 .new(window, \cf8 Rect\cf3 (210, 10, 750, 40));\
					sfView.soundfile= (sf);\
					sfNumFrames= sf.numFrames;\
					sfView.readFileWithTask(sf, 0, sfNumFrames-1);\
					sfView.waveColors_(\cf8 Color\cf3 .blue!2);\
					sfView.background_(\cf8 Color\cf3 .white);\
					sfView.timeCursorOn_(\cf5 true\cf3 );\
					sfView.timeCursorColor_(\cf8 Color\cf3 .red);\
					sfView.gridColor_(\cf8 Color\cf3 .grey);\
					sfView.refresh;\
					buffer= \cf8 Buffer\cf3 .read(s, paths[0]);\
					if(pBus.isNil, \{ pBus= \cf8 Bus\cf3 .control(s, 1); \});\
					\cf2 //makeUserView.value;\cf3 \
					\cf2 //if(GUI.scheme== QtGUI, \{u.front; u.refresh; "yo".postln; \}, \{makeUserView.value\});\cf3 \
					\cf2 //u.front;\cf3 \
					\});\
		\
		\};\
\
recButton= \cf8 Button\cf3 (window, \cf8 Rect\cf3 (100, 10, 100, 40))\
.states_([ [ \cf6 "Record"\cf3 , \cf8 Color\cf3 .black, \cf8 Color\cf3 .red ], [ \cf6 "Recording"\cf3 , \cf8 Color\cf3 .red, \cf8 Color\cf3 .black] ])\
.action_\{\cf4 |v|\cf3 \
	case \
	\{v.value == 1\} \{ \
		startRecord.value;\
		\}\
	\{v.value == 0\} \{\
		stopRecord.value;\
	\};\
\};\
\
playbutton= \cf8 Button\cf3 (window, \cf8 Rect\cf3 (970, 10, 100, 40))\
.states_([ [ \cf6 "Play"\cf3 , \cf8 Color\cf3 .black, \cf8 Color\cf3 .green ], [ \cf6 "Playing"\cf3 , \cf8 Color\cf3 .white, \cf8 Color\cf3 .green] ])\
.action_\{\cf4 |v|\cf3 \
	case \
	\{v.value == 1\} \{ numChans.do(\{\cf4 |i|\cf3  if(playbut[i].value== 1, \{ play[i].value; \}); \});\
		if (buffer.numChannels == 1, \{\
				synth= \cf8 Synth\cf3 (\cf9 \\oscSoundFile_1\cf3 , [\cf9 \\bufnum\cf3 , buffer, \cf9 \\pbus\cf3 , pBus])\
			\},\{\
				synth= \cf8 Synth\cf3 (\cf9 \\oscSoundFile_2\cf3 , [\cf9 \\bufnum\cf3 , buffer, \cf9 \\pbus\cf3 , pBus])\
		\});\
		playCursorTask.play(\cf8 AppClock\cf3 );\
		\}\
	\{v.value == 0\} \{ numChans.do(\{\cf4 |i|\cf3  if(playbut[i].value== 1, \{ stopplay[i].value\}); \});\
		playCursorTask.stop;\
		playCursorTask.reset;\
		synth.free;\
	\};\
\};\
\
\
\
playCursorTask= \cf8 Task\cf3 (\{\
			\cf4 var\cf3  value= 0;\
			\cf5 inf\cf3 .do(\{\
				pBus.get(\{\cf4 arg\cf3  v; \
					\cf2 //sfView.timeCursorPosition_( v*buffer.numFrames);\cf3 \
					value= v;\
					\});\
					sfView.timeCursorPosition_(value*buffer.numFrames);\
					\cf2 //value.postln;\cf3 \
					\cf2 //buffer.numFrames.postln;\cf3 \
					\cf2 //(value*buffer.numFrames).postln;\cf3 \
				0.05.wait;\
				\});\
		\});\
\
\
\cf8 Button\cf3 (window, \cf8 Rect\cf3 (1080, 10, 110, 40))\
.states_([ [ \cf6 "rec from Ableton"\cf3 , \cf8 Color\cf3 .black, \cf8 Color\cf3 .yellow ] ])\
.action_(\{\cf4 |v|\cf3 \
	if(\cf7 ~ableton2oscOpen\cf3 == \cf5 false\cf3 , \{\
		((\cf8 String\cf3 .scDir).dirname++\cf6 "/ableton2osc.scd"\cf3 ).standardizePath.load;\
	\});\
\});\
\
\cf8 Button\cf3 (window, \cf8 Rect\cf3 (1080, 60, 110, 40))\
.states_([ [ \cf6 "rec from Joystick"\cf3 , \cf8 Color\cf3 .black, \cf8 Color\cf3 .yellow ] ])\
.action_(\{\cf4 |v|\cf3 \
	if(\cf7 ~joy2oscOpen\cf3 == \cf5 false\cf3 , \{\
		((\cf8 String\cf3 .scDir).dirname++\cf6 "/joy2osc2.scd"\cf3 ).standardizePath.load;\
	\});\
\});\
\
recSoundBut= \cf8 Button\cf3 (window, \cf8 Rect\cf3 (1080, 130, 110, 40))\
.states_([ [ \cf6 "record sound"\cf3 , \cf8 Color\cf3 .black, \cf8 Color\cf3 .grey ],[ \cf6 "record sound"\cf3 , \cf8 Color\cf3 .black, \cf8 Color\cf3 .red ] ])\
.action_(\{\cf4 |v|\cf3 \
	\
\});\
\
\
\
numChans.do(\{\cf4 |i|\cf3 \
\
recPath[i]= \cf6 "/Users/martin/Desktop/OSCRecordings/robotOSCTest"\cf3 ;\
\
w[i]= \cf8 CompositeView\cf3 (win, \cf8 Rect\cf3 (270*i, 0, 270, 320));\
w[i].decorator = \cf8 FlowLayout\cf3 (w[i].bounds);\
\
\cf8 StaticText\cf3 (w[i], \cf8 Rect\cf3 (10, 10, 50, 20)).string_(\cf6 "name:"\cf3 );\
nameText[i]= \cf8 TextField\cf3 (w[i], \cf8 Rect\cf3 (10, 10, 200, 20))\
.string_(\cf6 "RobotOSCTest"\cf3 ++(i.asString))\
.action_(\{\cf4 |v|\cf3  nameString[i]= v.value; \})\
\cf2 //.keyDownAction_(\{|v| nameString[i]= v.value; \})\cf3 \
;\
\cf2 //.action_(\{arg field; recPath= (recFolder++field.value) \});\cf3 \
\
w[i].decorator.nextLine;\
w[i].decorator.nextLine;\
w[i].decorator.nextLine;\
\
recbut[i]= \cf8 Button\cf3 .new(w[i],\cf8 Rect\cf3 (20, 10, 260, 40))\
	.states_([ [ \cf6 "arm rec"\cf3 , \cf8 Color\cf3 .black, \cf8 Color\cf3 .grey ], [ \cf6 "armed rec"\cf3 , \cf8 Color\cf3 .black, \cf8 Color\cf3 .red] ])\
	.action_(\{\cf4 |v|\cf3 \
		if(v.value==1, \{recActive[i]=\cf5 true\cf3  \}, \{recActive[i]= \cf5 false\cf3 \});\
	\});\
\
\
rec[i]= \{\
	recPath[i]= recFolder++nameString[i];\
	recPath[i].postln;\
	\
	timelog[i]= \cf8 OSCFileLog\cf3 .new( recPath[i], ipString[i] );\
	\cf2 //n[i] = NetAddr.new( "localhost", NetAddr.langPort );\cf3 \
	\
	\{clockGUI[i].reset;\
	clockGUI[i].play;\}.fork(\cf8 AppClock\cf3 );\
	\
	recFile[i]= timelog[i].timelogfile;\
	\
	\};\
	\
stop[i]= \{\
	\{\
	timelog[i].close;\
	clockGUI[i].pause;\
	\}.fork(\cf8 AppClock\cf3 );\
	\};\
\
clockGUI[i]= \cf8 ClockGUI\cf3 .new(w[i], \cf8 Rect\cf3 (20, 40, 260, 100));\
\
\
\
\cf8 StaticText\cf3 (w[i], \cf8 Rect\cf3 (10, 10, 55, 20)).string_(\cf6 "send to:"\cf3 );\
ipText[i]= \cf8 TextField\cf3 (w[i], \cf8 Rect\cf3 (10, 10, 100, 20)).string_(\cf7 ~ipDict\cf3 [\cf9 \\first\cf3 ][0])\
.action_(\{\cf4 |v|\cf3  ipString[i]= v.value; \});\
\cf8 StaticText\cf3 (w[i], \cf8 Rect\cf3 (10, 10, 30, 20)).string_(\cf6 "port:"\cf3 );\
portText[i]= \cf8 TextField\cf3 (w[i], \cf8 Rect\cf3 (10, 10, 50, 20)).string_(\cf6 "8888"\cf3 );\
\cf2 /*\
Button(w[i], Rect(10, 10, 50, 20)).states_([["set"]])\
.action_(\{\
	n[i] = NetAddr.new(ipText[i].string, portText[i].string.interpret);\
	\}); */\cf3 \
	\
robotMenu[i]= \cf8 PopUpMenu\cf3 (w[i], \cf8 Rect\cf3 (0, 0, 200, 30))\
.items_(\cf7 ~ipDict\cf3 .keys.asArray)\
.background_(\cf8 Color\cf3 .white)\
.canFocus_(\cf5 false\cf3 )\
.font_(\cf8 Font\cf3 (\cf6 "Helvetica"\cf3 , 15))\
.action_(\{\cf4 |menu|\cf3 \
	ipText[i].string= \cf7 ~ipDict\cf3 [menu.item][0];\
	ipString[i]=\cf7 ~ipDict\cf3 [menu.item][0];\
	portText[i].string= \cf7 ~ipDict\cf3 [menu.item][1].asString;\
	n[i] = \cf8 NetAddr\cf3 .new(ipText[i].string, portText[i].string.interpret);\
\});\
\
playbut[i]= \cf8 Button\cf3 .new(w[i],\cf8 Rect\cf3 (20, 10, 260, 40))\
	.states_([ [ \cf6 "arm play"\cf3 , \cf8 Color\cf3 .black, \cf8 Color\cf3 .grey ], [ \cf6 "armed"\cf3 , \cf8 Color\cf3 .white, \cf8 Color\cf3 .green] ]);\
\
play[i]= \{\
	n[i] = \cf8 NetAddr\cf3 .new(ipText[i].string, portText[i].string.interpret);\
	\cf2 //n = NetAddr.new( "localhost", NetAddr.langPort );\cf3 \
	\cf2 //OSCFunc.trace( true );\cf3 \
	oscplayer[i] = \cf8 OSCFileLogPlayer\cf3 .new(timelog[i].timelogfile.pathDir, n[i], \{ playbut[i].valueAction= 0 \} );\
	oscplayer[i].play;\
	\};\
\
stopplay[i]= \{\
	oscplayer[i].stop;\
	oscplayer[i].close;\
	\cf2 //OSCFunc.trace( false );\cf3 \
	\};\
\
\cf8 Button\cf3 (w[i], \cf8 Rect\cf3 (0, 0, 100, 20))\
.states_([ [ \cf6 "open in editor"\cf3 , \cf8 Color\cf3 .black, \cf8 Color\cf3 .blue ] ])\
.action_(\{\
		recFile[i];\
\});\
\}); \cf2 //end of do\cf3 \
\
recSoundStart= \
\{\
\cf4 var\cf3  b, d, sfpath;\
\
recSound= \cf5 true\cf3 ;\
\
\cf2 // allocate a disk i/o buffer\cf3 \
b= \cf8 Buffer\cf3 .alloc(s, 65536, 2);\
\
\cf8 SynthDef\cf3 (\cf9 \\recordGiga\cf3 , \{\cf4 arg\cf3  bufnum, in;\
	\cf8 DiskOut\cf3 .ar(bufnum, \cf8 In\cf3 .ar(in,2));\
\}).send(s);\
\
\
	sfpath= ((recordingsPath++\cf6 "OSCRec"\cf3 ++\cf8 Date\cf3 .localtime.stamp++\cf6 ".wav"\cf3 ).standardizePath);\
	b.write(sfpath, \cf6 "wav"\cf3 , \cf6 "int16"\cf3 , 0, 0, \cf5 true\cf3 );\
	\cf8 Routine\cf3 (\{\
		s.sync;\
		d = \cf8 Synth\cf3 .tail(\cf5 nil\cf3 , \cf9 \\recordGiga\cf3 , [\cf9 \\bufnum\cf3 , b, \cf9 \\in\cf3 , 0]);\
	\}).play(\cf8 AppClock\cf3 );	\
\
\
recSoundStop= \{ \cf2 // stop recording\cf3 \
	d.free; b.close; b.free;\
	recSound= \cf5 false\cf3 ;\
\};\
\
\
\};\
\
\cf8 SynthDef\cf3 (\cf9 \\oscSoundFile_1\cf3 ,\{ \
	\cf4 | out=0, bufnum, rate=1, gate=1, start= 0, startLoop, endLoop, ipol=2, amp=1, pbus= 0|\cf3 \
	\cf4 var\cf3  env, signal, posTrig, phasor;\
	\cf2 //posTrig= HPZ2.kr(startLoop); //trig when startLoop changes\cf3 \
	phasor= \cf8 Phasor\cf3 .ar(0, \cf8 BufRateScale\cf3 .kr(bufnum) * rate, start,\cf8 BufFrames\cf3 .kr(bufnum)-1);\
	signal = \cf8 BufRd\cf3 .ar(1, bufnum, phasor, 0, ipol);\
	\cf8 Out\cf3 .kr(pbus, phasor/\cf8 BufFrames\cf3 .kr(bufnum));\
	\cf8 Out\cf3 .ar(out, (signal * amp)!2);\
\}).add;\
\
\cf8 SynthDef\cf3 (\cf9 \\oscSoundFile_2\cf3 ,\{ \
	\cf4 | out=0, bufnum, rate=1, gate=1, start= 0, startLoop, endLoop, ipol=2, amp=1, pbus= 0|\cf3 \
	\cf4 var\cf3  signal, posTrig, phasor;\
	\cf2 //posTrig= HPZ2.kr(startLoop); //trig when startLoop changes\cf3 \
	phasor= \cf8 Phasor\cf3 .ar(0, \cf8 BufRateScale\cf3 .kr(bufnum) * rate, start,\cf8 BufFrames\cf3 .kr(bufnum)-1);\
	signal = \cf8 BufRd\cf3 .ar(2, bufnum, phasor, 0, ipol);\
	\cf8 Out\cf3 .kr(pbus, phasor/\cf8 BufFrames\cf3 .kr(bufnum));\
	\cf8 Out\cf3 .ar(out, (signal *amp));\
\}).add;\
\
\
\cf8 OSCdef\cf3 (\cf9 \\abeltonRec\cf3 ).enable;\
\cf8 OSCdef\cf3 (\cf9 \\abeltonRec\cf3 , \{\cf4 |msg, time, addr, recvPort|\cf3 \
	\cf2 //"jo".postln;\cf3 \
	if(msg[1]== 1 and: \{\cf7 ~recOSC\cf3 ==\cf5 false\cf3 \}, \{\
		\cf6 "start rec from ableton"\cf3 .postln;\
		startRecord.value;\
		\{recButton.value= 1\}.defer;\
		\});\
	if(msg[1]== 0 and: \{\cf7 ~recOSC\cf3  == \cf5 true\cf3 \}, \{\
		stopRecord.value;\
		\{recButton.value= 0\}.defer;\
		\});	\
\}, \cf9 '/RECosc'\cf3 , \cf8 NetAddr\cf3 (\cf6 "127.0.0.1"\cf3 , \cf5 nil\cf3 ));\
\
window.front;\
\
window.onClose= \{\
			if(buffer.isNil.not, \{ \{buffer.free\}.try \});\
			if(pBus.isNil.not, \{ \{pBus.free\}.try \});\
			\cf8 OSCdef\cf3 (\cf9 \\abeltonRec\cf3 ).disable;\
			\cf8 OSCdef\cf3 (\cf9 \\abeltonRec\cf3 ).free;\
			\};\
\
)}