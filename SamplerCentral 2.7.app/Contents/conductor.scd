{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf600
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red191\green0\blue0;\red0\green0\blue0;\red0\green0\blue255;
\red51\green51\blue191;\red96\green96\blue96;\red0\green0\blue191;\red255\green102\blue0;\red0\green115\blue0;
\red0\green0\blue0;\red0\green0\blue177;}
{\*\expandedcolortbl;;\csgenericrgb\c75000\c0\c0;\csgenericrgb\c0\c0\c0;\csgenericrgb\c0\c0\c100000;
\csgenericrgb\c20000\c20000\c75000;\csgenericrgb\c37500\c37500\c37500;\csgenericrgb\c0\c0\c75000;\csgenericrgb\c100000\c40000\c0;\csgenericrgb\c0\c45000\c0;
\cssrgb\c0\c0\c0;\cssrgb\c0\c0\c74902;}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 //CONDUCTOR\cf3 \
\cf2 /*\
try to translate speed to bpm or implement tap tempo\
option to send OSC to clock\
volume slider...?\
tap tempo\
when tempo/speed is locked, adjustment slider/buttons to match up clicks\
*/\cf3 \
(\
\cf4 var\cf3  w, wb, c, buffers= [\cf5 nil\cf3 , \cf5 nil\cf3 ], metronomeResp1, metronomeResp2;\
\cf4 var\cf3  s, out= 0, outputs, defaultout= 0, outbut;\
\cf4 var\cf3  player= [\cf6 "Buf"\cf3 , \cf6 "Buf"\cf3 ], chans= [2, 2], loadDialog, loadFile;\
\cf4 var\cf3  button1, button2, errorFileMessage;\
\cf4 var\cf3  builtin= \cf5 false\cf3 , sendNetAddr, recieveNetAddr;\
\cf4 var\cf3  saveDirectory, saveFiles, loadMenu, loadMenuItem, saveArchive;\
\cf4 var\cf3  slider, soundFilePath= [\cf5 nil\cf3 , \cf5 nil\cf3 ];\
\cf4 var\cf3  tapTempo, tapTempoView;\
\
s= \cf7 Server\cf3 .default;\
outputs= [\cf5 nil\cf3 , 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24];\
if (s.options.outDevice.contains(\cf6 "Built-in"\cf3 ), \{out= 0; builtin= \cf5 true\cf3 ; \});\
\
sendNetAddr= \cf7 NetAddr\cf3 (\cf8 ~ipDict\cf3 [\cf9 \\conductor\cf3 ][0], \cf8 ~ipDict\cf3 [\cf9 \\conductor\cf3 ][1]);\
\cf2 //sendNetAddr= NetAddr(~ipDict[\\clock][0], ~ipDict[\\clock][1]);\cf3 \
recieveNetAddr = \cf7 NetAddr\cf3 (\cf8 ~ipDict\cf3 [\cf9 \\conductorRCV\cf3 ][0], \cf8 ~ipDict\cf3 [\cf9 \\conductorRCV\cf3 ][1]);\
\
soundFilePath[0]= \cf6 "/Volumes/MEDIA/Ableton/nedmixer/12spaten/metronomeWood1.wav"\cf3 ;\
soundFilePath[1]= \cf6 "/Volumes/MEDIA/Ableton/nedmixer/12spaten/metronomeWood2.wav"\cf3 ;\
\
\cf2 // ================ LOADING SAMPLES ================\cf3 \
\
		loadDialog= \{ \cf4 | buffer, buttonView, samplerNum |\cf3 \
			\cf7 Dialog\cf3 .getPaths(\{ \cf4 arg\cf3  paths;\
				loadFile.value(paths, buffer, buttonView, samplerNum );\
				\},\{\
			\cf6 "cancelled"\cf3 .postln;\
			\});\
		\};\
		\
		loadFile= \{ \cf4 |paths, buffer, buttonView, samplerNum|\cf3 \
			\cf2 //var maxnewsamples, numsliders;\cf3 \
			case\
			\{paths.class == \cf7 Array\cf3  \} \{\
				if(paths[0].isSoundFile , \{\
				1.do(\{\
					\cf4 var\cf3  f, p, dur;\
					p= paths[0];\
					\{\
					\cf2 //if (synOn, \{syn.free; synOn= false; \});\cf3 \
					s.sync;\
					if (buffers[samplerNum-1].isNil.not, \{\
						if(player[samplerNum-1] == \cf6 "Disk"\cf3 , \{ \{buffers[samplerNum-1].close\}.try; \});\
					s.sync;\
					buffers[samplerNum-1].free;\
					\});\
					\cf2 //firstRun= true;\cf3 \
					f= \cf7 SoundFile\cf3 .new;\
					f.openRead(p);\
					dur = f.numFrames/s.sampleRate;\
					\cf2 //frames= f.numFrames;\cf3 \
					\cf2 //samplerate= f.sampleRate;\cf3 \
					if (samplerNum == 1, \{ chans[0]= f.numChannels \}, \{chans[1]= f.numChannels\});\
					\cf2 //currentPath= p;\cf3 \
					s.sync;\
					if (dur > 7, \{\
						buffers[samplerNum-1] = \cf7 Buffer\cf3 .cueSoundFile(s, p, 0, chans[samplerNum-1]);\
						player[samplerNum-1]= \cf6 "Disk"\cf3 ;\
					\},\{	\
						buffers[samplerNum-1]= \cf7 Buffer\cf3 .read(s, p);\
						player[samplerNum-1]= \cf6 "Buf"\cf3 ;\
\
					\});\
					(p++\cf6 " read"\cf3 ).postln;\
					\{ buttonView.states= ([[p.basename.removeExtension, \cf7 Color\cf3 .white, \cf7 Color\cf3 .black]]) \}.defer;\
					\cf2 //\{ title.stringColor= Color.white \}.defer; \cf3 \
					\cf2 //amp= 0.0; //set sensible amplitude as default\cf3 \
					\cf2 //outbut.valueAction= 0; pan= 0; panKnob.value= 0.5;\cf3 \
					soundFilePath[samplerNum] = p;\
					\
					f.close;\
\
\
					\}.fork(\cf7 AppClock\cf3 );\
				\});\
				\
				\
				\},\{\
					errorFileMessage.value;\
				\});\
			\}\
		\};\
\
\
\cf2 // ================ END LOADING SAMPLES ============\cf3 \
\
w= \cf7 Window\cf3 (\cf6 "CONDUCTOR"\cf3 , \cf7 Rect\cf3 (1000, 655, 200, 300)).front;\
wb= w.bounds;\
c= \cf7 GUI\cf3 .vLayoutView.new(w, \cf7 Rect\cf3 (0, 0, wb.width, wb.height));\
\
\cf7 StaticText\cf3 (c, \cf7 Rect\cf3 (0, 10, 100, 15))\
.string_(\cf6 "CONDUCTOR"\cf3 )\
.font_(\cf7 Font\cf3 (\cf6 "Helvetica"\cf3 , 15))\
.align_(\cf9 \\center\cf3 );\
\
buffers[0]= \cf7 Buffer\cf3 .read(s, \cf6 "/Volumes/MEDIA/Ableton/nedmixer/12spaten/metronomeWood1.wav"\cf3 );\
buffers[1]= \cf7 Buffer\cf3 .read(s, \cf6 "/Volumes/MEDIA/Ableton/nedmixer/12spaten/metronomeWood2.wav"\cf3 );\
\
\cf2 //make mono + stereo + buf + diskin versions\cf3 \
\cf7 SynthDef\cf3 (\cf9 \\metronomeBuf1\cf3 , \{\cf4 |buf, out= 0|\cf3 \
\cf7 Out\cf3 .ar(out, \cf7 PlayBuf\cf3 .ar(1, buf, doneAction:2))\
\}).add;\
\cf7 SynthDef\cf3 (\cf9 \\metronomeBuf2\cf3 , \{\cf4 |buf, out= 0|\cf3 \
\cf7 Out\cf3 .ar(out, \cf7 PlayBuf\cf3 .ar(2, buf, doneAction:2))\
\}).add;\
\cf7 SynthDef\cf3 (\cf9 \\metronomeDisk1\cf3 , \{\cf4 |buf, out= 0|\cf3 \
	\cf4 var\cf3  disk= \cf7 DiskIn\cf3 .ar(1, buf);\
	\cf7 FreeSelf\cf3 .kr(\cf7 Done\cf3 .kr(disk));\
\cf7 Out\cf3 .ar(out, disk)\
\}).add;\
\cf7 SynthDef\cf3 (\cf9 \\metronomeDisk2\cf3 , \{\cf4 |buf, out= 0|\cf3 \
	\cf4 var\cf3  disk= \cf7 DiskIn\cf3 .ar(2, buf);\
	\cf7 FreeSelf\cf3 .kr(\cf7 Done\cf3 .kr(disk));\
\cf7 Out\cf3 .ar(out, disk)\
\}).add;\
\
\cf7 Button\cf3 (c, 50@20)\
	.states_([[\cf6 "conduct OFF"\cf3 , \cf7 Color\cf3 .white,\cf7 Color\cf3 .grey], [\cf6 "conduct ON"\cf3 , \cf7 Color\cf3 .white,\cf7 Color\cf3 .green]])\
	.action_(\{ \cf4 |v|\cf3 \
		if(v.value==1, \{\
			metronomeResp1= \cf7 OSCFunc\cf3 .new(\{\cf4 |msg|\cf3 \
				\cf6 "play metronome1 tick!"\cf3 .postln;\
				msg.postln;\
				\cf7 Synth\cf3 (\cf6 "metronome"\cf3 ++player[0]++chans[0], [\cf9 \\buf\cf3 , buffers[0].bufnum, \cf9 \\out\cf3 , out]);\
				\}, \
				\cf9 '/END1'\cf3 , \cf2 //symbol to respond to\cf3 \
				\cf7 NetAddr\cf3 (\cf8 ~ipDict\cf3 [\cf9 \\conductorRCV\cf3 ][0], \cf8 ~ipDict\cf3 [\cf9 \\conductorRCV\cf3 ][1]) \cf2 // ip of sender\cf3 \
				);\
			metronomeResp2= \cf7 OSCFunc\cf3 .new(\{\cf4 |msg|\cf3 \
				\cf6 "play metronome2 tick!"\cf3 .postln;\
				msg.postln;\
				\cf7 Synth\cf3 (\cf6 "metronome"\cf3 ++player[1]++chans[1], [\cf9 \\buf\cf3 , buffers[1].bufnum, \cf9 \\out\cf3 , out]);\
				\}, \
				\cf9 '/END2'\cf3 , \cf2 //symbol to respond to\cf3 \
				\cf7 NetAddr\cf3 (\cf8 ~ipDict\cf3 [\cf9 \\conductorRCV\cf3 ][0], \cf8 ~ipDict\cf3 [\cf9 \\conductorRCV\cf3 ][1]) \cf2 // ip of sender\cf3 \
				);\
				sendNetAddr.sendMsg(\cf6 "SR1"\cf3 ++(slider.value.asString));\
		\},\{\
			metronomeResp1.free;\
			metronomeResp2.free;\
			\cf2 //buffers[0].free;\cf3 \
		\});\
\});\
\
\cf2 // TWO BUTTONS TO LOAD SAMPLES\cf3 \
	button1= \cf7 Button\cf3 (c, \cf7 Rect\cf3 (0, 0, 100, 40))\
		.states_([[\cf6 "sample1"\cf3 , \cf7 Color\cf3 .white, \cf7 Color\cf3 .black]])\
		.mouseDownAction_(\{ \cf4 |view, x, y, mod|\cf3 \
			if (mod.isShift, \{loadDialog.value(buffers[0], view, 1)\});\
			if (mod.isAlt, \{ buffers[0].free; \cf6 "remove file"\cf3 .postln;\});\
			if (mod.isCtrl, \{ \
				\cf7 Synth\cf3 (\cf6 "metronome"\cf3 ++player[0]++chans[0], [\cf9 \\buf\cf3 , buffers[0].bufnum, \cf9 \\out\cf3 , out]);\
			\});\
		\})\
		.canFocus_(\cf5 false\cf3 )\
		.canReceiveDragHandler_(\cf5 true\cf3 )\
		.receiveDragHandler_(\{\cf4 |view|\cf3 \
			\cf4 var\cf3  paths;\
			paths= \cf7 View\cf3 .currentDrag;\
			if(paths.isString, \{paths= [paths];\}); \cf2 // qt compatibility..\cf3 \
			loadFile.value(paths, buffers[0], view, 1);\
		\});\
\
	button2= \cf7 Button\cf3 (c, \cf7 Rect\cf3 (0, 0, 100, 40))\
		.states_([[\cf6 "sample2"\cf3 , \cf7 Color\cf3 .white, \cf7 Color\cf3 .black]])\
		.mouseDownAction_(\{ \cf4 |view, x, y, mod|\cf3 \
			if (mod.isShift, \{loadDialog.value(buffers[1], view, 2)\});\
			if (mod.isAlt, \{ buffers[1].free; \cf6 "remove file"\cf3 .postln;\});\
			if (mod.isCtrl, \{ \
				\cf7 Synth\cf3 (\cf6 "metronome"\cf3 ++player[1]++chans[1], [\cf9 \\buf\cf3 , buffers[1].bufnum, \cf9 \\out\cf3 , out]);\
			\});\
		\})\
		.canFocus_(\cf5 false\cf3 )\
		.canReceiveDragHandler_(\cf5 true\cf3 )\
		.receiveDragHandler_(\{\cf4 |view|\cf3 \
			\cf4 var\cf3  paths;\
			paths= \cf7 View\cf3 .currentDrag;\
			if(paths.isString, \{paths= [paths];\}); \cf2 // qt compatibility..\cf3 \
			loadFile.value(paths, buffers[1], view, 2);\
		\});\
\
\
\cf2 // SLIDER VAL 95 (stop) - 0???\cf3 \
\
slider= \cf7 EZSlider\cf3 (c, 200@40, \cf5 nil\cf3 , \cf7 ControlSpec\cf3 (95, 50, \cf9 \\lin\cf3 , 1, 95, \cf6 "/SR1"\cf3 ), \{\
	\cf4 |ez|\cf3 \
	sendNetAddr.sendMsg(\cf6 "SR1"\cf3 ++(ez.value.asString));\
	(\cf6 "SR1"\cf3 ++(ez.value.asString)).postln;\
	\});\
	\
\cf2 //outbutton\cf3 \
	outbut= \cf7 Button\cf3 (c, \cf7 Rect\cf3 (17, 172, 30, 15))\
		.states_([[\cf6 "nil"\cf3 , \cf7 Color\cf3 .black, \cf7 Color\cf3 .grey], [\cf6 "1-2"\cf3 , \cf7 Color\cf3 .yellow, \cf7 Color\cf3 .black],[\cf6 "3-4"\cf3 , \cf7 Color\cf3 .yellow, \cf7 Color\cf3 .black], [\cf6 "5-5"\cf3 , \cf7 Color\cf3 .yellow, \cf7 Color\cf3 .black], [\cf6 "7-8"\cf3 , \cf7 Color\cf3 .yellow, \cf7 Color\cf3 .black], [\cf6 "9-10"\cf3 , \cf7 Color\cf3 .yellow, \cf7 Color\cf3 .black], [\cf6 "11-12"\cf3 , \cf7 Color\cf3 .yellow, \cf7 Color\cf3 .black], [\cf6 "13-14"\cf3 , \cf7 Color\cf3 .yellow, \cf7 Color\cf3 .black], [\cf6 "15-16"\cf3 , \cf7 Color\cf3 .yellow, \cf7 Color\cf3 .black], [\cf6 "17-18"\cf3 , \cf7 Color\cf3 .yellow, \cf7 Color\cf3 .black], [\cf6 "19-20"\cf3 , \cf7 Color\cf3 .yellow, \cf7 Color\cf3 .black], [\cf6 "21-22"\cf3 , \cf7 Color\cf3 .yellow, \cf7 Color\cf3 .black], [\cf6 "23-24"\cf3 , \cf7 Color\cf3 .yellow, \cf7 Color\cf3 .black]] )\
		.font_(\cf7 Font\cf3 (\cf6 "Helvetica"\cf3 , 9))\
		.canFocus_(\cf5 false\cf3 )\
		.value_( 0 )\
		.action_(\{ \cf4 |v|\cf3 \
			if(v.value==0, \{out= defaultout \},\
			\{out= outputs[v.value];\});\
			\cf2 //\{syn.free\}.try;\cf3 \
			\cf2 //firstRun= true;\cf3 \
			\cf2 //synOn= false;\cf3 \
		\});\
\
\cf2 //tapTempoView\cf2 \expnd0\expndtw0\kerning0
= CompositeView(w, Rect(0, 200, \cf2 \kerning1\expnd0\expndtw0 200\cf2 \expnd0\expndtw0\kerning0
, 30));\cf3 \
\cf2 \kerning1\expnd0\expndtw0 //tapTempoView\cf2 \expnd0\expndtw0\kerning0
.decorator= FlowLayout(Rect(0, 0, \cf2 \kerning1\expnd0\expndtw0 wb.width\cf2 \expnd0\expndtw0\kerning0
, 30));\cf3 \kerning1\expnd0\expndtw0 \
\cf2 //tapTempo= RedTapTempoGUI(parent:tapTempoView);\cf3 \
\
tapTempo= \cf7 RedTapTempoGUI\cf3 (parent:w);\
\
\cf2 // ===========. SAVE MENU =============\cf3 \
\
\cf7 StaticText\cf3 (w, \cf7 Rect\cf3 (0, 260, 100, 20)).string_(\cf6 "Preset:"\cf3 );\
saveDirectory= (\cf7 String\cf3 .scDir.dirname ++ \cf6 "/Resources/CONDUCTORPRESETS/"\cf3 );\
saveFiles= (saveDirectory+/+\cf6 "*"\cf3 ).standardizePath.pathMatch;\
\
		loadMenu= \cf7 PopUpMenu\cf3 (w, \cf7 Rect\cf3 (0, 280, 130, 20)) \cf2 // -----\cf3 \
		.items_(saveFiles.collect(\{\cf4 |it|\cf3  it.basename\}))\
		.canFocus_(\cf5 false\cf3 )\
		.background_(\cf7 Color\cf3 .white)\
		.font_(\cf7 Font\cf3 (\cf6 "Helvetica"\cf3 , 10))\
		.action_(\{\cf4 |v|\cf3 \
			loadMenuItem= v.items.at(v.value);\
		\});\
		\
		\cf2 //load preset\cf3 \
		\cf7 Button\cf3 (w, \cf7 Rect\cf3 (130, 280, 20, 20)) \cf2 // ------\cf3 \
		.states_([[\cf6 "L"\cf3 , \cf7 Color\cf3 .red, \cf7 Color\cf3 .black]])\
		.canFocus_(\cf5 false\cf3 )\
		.font_(\cf7 Font\cf3 (\cf6 "Helvetica"\cf3 , 10))\
		.action_(\{\
			\cf4 var\cf3  loadArray;\
			if (loadMenuItem.isNil.not, \{ \
				loadArray= \cf7 Object\cf3 .readArchive(saveFiles[loadMenu.value]);\
				saveArchive= loadArray.interpret;\
				loadFile.value(saveArchive[0][0], buffers[0], button1, 1);\
				loadFile.value(saveArchive[0][1], buffers[1], button2, 2);\
				\{outbut.valueAction= saveArchive[2]\}.defer;\
				\{slider.valueAction= saveArchive[1]\}.defer;\
			\});\
		\});\
		\cf7 Button\cf3 (w, \cf7 Rect\cf3 (150, 280, 30, 20))\
		.states_([[\cf6 "qs"\cf3 ]])\
		.canFocus_(\cf5 false\cf3 )\
		.font_(\cf7 Font\cf3 (\cf6 "Helvetica"\cf3 , 12))\
		.action_(\{ \
			saveArchive.asCompileString.writeArchive(saveDirectory+/+loadMenuItem);\
		\});\
		\cf7 Button\cf3 (w, \cf7 Rect\cf3 (180, 280, 20, 20))\
		.states_([[\cf6 "s"\cf3 ]])\
		.canFocus_(\cf5 false\cf3 )\
		.font_(\cf7 Font\cf3 (\cf6 "Helvetica"\cf3 , 12))\
		.action_(\{\
			\cf2 //save preset\cf3 \
			\cf4 var\cf3  w, t, name, saveBut;\
				w= \cf7 Window\cf3 (\cf6 "save"\cf3 , \cf7 Rect\cf3 (400, 400, 230, 100), border: \cf5 false\cf3 )\
				.background_(\cf7 Color\cf3 .black)\
				.alwaysOnTop_(\cf5 true\cf3 );\
	\
				t= \cf7 TextView\cf3 (w, \cf7 Rect\cf3 (10, 10, 210, 20))\
				.focus(\cf5 true\cf3 )\
				.keyDownAction_(\{\cf4 |view, char, mod, uni, key|\cf3 \
					if(key == 36, \{ \{saveBut.valueAction= 1\}.defer; \});\
				\});\
				\
				saveBut= \cf7 Button\cf3 (w, \cf7 Rect\cf3 (10, 40, 100, 40))\
				.states_([[\cf6 "save"\cf3 ]])\
				.action_(\{\
					\cf4 var\cf3  values, path, stringSize;\
					stringSize= t.string.size;\
					if (stringSize > 0, \{\
						name= t.string;\
						path= saveDirectory+/+(name);\
						saveArchive= [soundFilePath, slider.value, outbut.value];\
						saveArchive.asCompileString.writeArchive(path);\
						\cf2 //currentSaveFile= path;\cf3 \
						saveFiles= (saveDirectory++\cf6 "*"\cf3 ).standardizePath.pathMatch;\
						\{loadMenu.items= saveFiles.collect(\{\cf4 |it|\cf3  it.basename.asSymbol\});\}.defer;\
						loadMenu.value= loadMenu.items.indexOf(name.asSymbol);\
						w.close;\
					\});\
				\});\
				\cf7 Button\cf3 (w, \cf7 Rect\cf3 (120, 40, 100, 40))\
				.states_([[\cf6 "cancel"\cf3 ]])\
				.action_(\{\
					w.close;\
				\});\
				w.front;\
		\});\
\
\
\
\cf2 // ERROR MESSAGE\cf3 \
errorFileMessage= \{\
\cf4 var\cf3  w, r;\
\
	w= \cf7 SCAlert\cf3 ( \cf6 "the file you loaded is not valid. It's either just plain wrong or mp3.."\cf3 ,[\cf6 "close.. 5"\cf3 ],[\{w.window.close; r.stop; \}] );\
	\
	r= \{1.wait; \
	5.do(\{\cf4 |i|\cf3  \{w.buttonLabel_(0, \cf6 "close.."\cf3 +(5-i));\}.defer; 1.wait;\});\
	w.window.close;\}.fork(\cf7 AppClock\cf3 );\
\};\
\
\cf2 //ON WINDOW CLOSE CLEAN UP\cf3 \
w.onClose= \{\
	tapTempo.close;\
	\cf8 ~conductorOpen\cf3 = \cf5 false\cf3 ;\
	metronomeResp1.remove;\
	metronomeResp2.remove;\
	buffers[0].free;\
	buffers[1].free;\
	sendNetAddr.disconnect;\
	recieveNetAddr.disconnect;\
\};\
\
)}