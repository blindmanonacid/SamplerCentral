{\rtf1\ansi\ansicpg1252\cocoartf1265\cocoasubrtf210
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue191;\red0\green0\blue0;\red0\green0\blue255;
\red96\green96\blue96;\red51\green51\blue191;\red191\green0\blue0;\red102\green102\blue191;\red0\green115\blue0;
\red255\green102\blue0;}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 SliderLooper\cf3 \{ \
\
	\cf4 var\cf3  player= \cf5 "gpLooper"\cf3 , c, buffer, <>title, syn, synOn, loadFile, loadDialog, x= 20, y= 20, s, <>knob1, knobDefaultAction;\
	\cf4 var\cf3  view, x, y, number, out= 0, preferences;\
	\cf4 var\cf3  amp, ampspec, bufferfree, firstRun= \cf6 true\cf3 ;\
	\cf4 var\cf3  ctrl, shift, alt;\
	\cf4 var\cf3  <>pan= 0; \cf7 //was 1\cf3 \
	\cf4 var\cf3  panarr, outputs, <>defaultout, outbut, panbut;\
	\cf4 var\cf3  currentPath, speechout, <>output;\
	\cf4 var\cf3  panKnob;\
	\cf4 var\cf3  frames= 0, samplerate= 44100, dur= 1, synthID;\
	\cf4 var\cf3  progressFunc, progressView, prevDrawFunc;\
	\cf4 var\cf3  ruleFolderNames, rulesList, rulesApply, rulesOnOff;\
	\cf4 var\cf3  errorFileMessage;\
	\cf4 var\cf3  rate= 1;\
	\cf4 var\cf3  paused= \cf6 false\cf3 ;\
	\cf4 var\cf3  builtin= \cf6 false\cf3 ;\
	\cf4 var\cf3  >allSliders;\
\
	*new \{\cf4 arg\cf3  view, x, y, number, out, preferences;\
		^\cf8 super\cf3 .new.initSliderLooper(view, x, y, number, out, preferences);\
	\}\
	\
	initSliderLooper \{\cf4 arg\cf3  argview, argx, argy, argnumber, argout, argpreferences;\
\
		view= argview;\
		x= argx;\
		y= argy;\
		number= argnumber;\
		s= \cf2 Server\cf3 .default;\
		player= \cf5 "gpLooper"\cf3 ;\
		out= argout;\
		defaultout= argout;\
		synthID= \cf2 UniqueID\cf3 .next;\
		preferences= argpreferences;\
		\
		\
		ruleFolderNames= preferences[9];\
		rulesList= preferences[10];\
		rulesApply= preferences[11];\
		rulesOnOff= preferences[12];\
		\
		if (s.options.outDevice.contains(\cf5 "Built-in"\cf3 ), \{out= 0; builtin= \cf6 true\cf3 ; \});\
	\
		synOn = \cf6 false\cf3 ;\
\
		ampspec= \cf2 ControlSpec\cf3 ( 0.001, 1.0,\cf9 \\amp\cf3 );\
		panarr= [0, -1, 1];\
		outputs= [\cf6 nil\cf3 , 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24];\
		currentPath= \cf5 "nopath"\cf3 ;\
		\
		if (s.options.device == \cf6 nil\cf3 , \{speechout= 0; \}, \{speechout= 8; \});\
\
		loadDialog= \{\
			\cf2 Dialog\cf3 .getPaths(\{ \cf4 arg\cf3  paths;\
				loadFile.value(paths);			\
				\},\{\
			\cf5 "cancelled"\cf3 .postln;\
			\});\
		\};\
		\
		loadFile= \{ \cf4 |paths|\cf3 \
			\cf4 var\cf3  maxnewsamples, numsliders;\
			case\
			\{paths.class == \cf2 Array\cf3  \} \{\
				if(paths[0].isSoundFile , \{\
				1.do(\{\
					\cf4 var\cf3  f, chans, p;\
					p= paths[0];\
					\{\
					if (synOn, \{syn.free; synOn= \cf6 false\cf3 ; \});\
					s.sync;\
					if (buffer.isNil.not, \{\
						if(player == \cf5 "diskin"\cf3 , \{ \{buffer.close\}.try; \});\
					s.sync;\
					buffer.free;\
					\});\
					firstRun= \cf6 true\cf3 ;\
					f= \cf2 SoundFile\cf3 .new;\
					f.openRead(p);\
					dur = f.numFrames/s.sampleRate;\
					frames= f.numFrames;\
					samplerate= f.sampleRate;\
					chans= f.numChannels;\
					currentPath= p;\
					s.sync;\
					if (dur > 7, \{\
						buffer = \cf2 Buffer\cf3 .cueSoundFile(s, p, 0, chans);\
						player= \cf5 "diskin"\cf3 ;\
					\},\{\
						buffer= \cf2 Buffer\cf3 .read(s, p);\
						player= \cf5 "gpLooper"\cf3 ;\
					\});\
					(p++\cf5 " read"\cf3 ).postln;\
					\{ title.string= (p.basename.removeExtension) \}.defer;\
					\{ title.stringColor= \cf2 Color\cf3 .white \}.defer; \
					amp= 0.0; \cf7 //set sensible amplitude as default\cf3 \
					outbut.valueAction= 0; pan= 0; panKnob.value= 0.5;\
					rulesOnOff.do(\{\cf4 |it, onoff_iter|\cf3 \
						if(it == 1, \{\
							\cf7 //"onoff!".postln;\cf3 \
							if (p.contains(ruleFolderNames[onoff_iter]), \{\
								\cf7 //"it contains!!".postln;\cf3 \
								rulesApply[onoff_iter].do(\{\cf4 |it, apply_iter|\cf3  \cf7 // 9 is pan, 10 is out\cf3 \
									\
									if(apply_iter == 9 and: \{it == 1\},\{\
										\cf7 //"applying properties!!".postln;\cf3 \
										pan= rulesList[onoff_iter][apply_iter];\
										panKnob.value= rulesList[onoff_iter][apply_iter];\
									\});\
																					if(apply_iter == 10 and: \{it == 1\},\{\
										\cf7 //"applying properties!!".postln;\cf3 \
										outbut.valueAction= outputs.indexOf(rulesList[onoff_iter][apply_iter]);\
									\});\
								\});\
							\});\
						\});\
					\});\
					\
					f.close;\
					progressView.drawFunc = \{\
					\cf2 Pen\cf3 .perform(\cf9 \\fill\cf3 );\
					\cf2 Pen\cf3 .color = \cf2 Color\cf3 .white(0.5, 0.5);\
					\cf2 Pen\cf3 .stringAtPoint((dur.floor).asTimeString.drop(3).drop(-4), 10@10);\
					\};\
					progressView.refresh;\
\
					\}.fork(\cf2 AppClock\cf3 );\
				\});\
				\
				\cf7 // multiple files spreads over more sliders\cf3 \
				if(allSliders.isNil.not, \{\
				if(paths.size > 1, \{\
				numsliders= allSliders.size;\
				maxnewsamples= numsliders-(number-1);\
				maxnewsamples.postln;\
				paths= paths.keep(maxnewsamples);\
				paths.do(\{\cf4 |it, i|\cf3 \
					if (i==0, \{\cf6 nil\cf3 \}, \{\
					allSliders[(number-1)+i].setValues([it]);\
					\});\
				\});\
				\});\
				\});\
				\
				\},\{\
					errorFileMessage.value;\
				\});\
			\}\
			\cf7 // dropping a knob to control panning\cf3 \
			\{paths.class == \cf2 UC33LoopChan\cf3  \} \{\
				paths.free;\
				paths.setAction(\{\cf4 |v|\cf3 \{ panKnob.valueAction_(v.value)\}.defer \}, number);\
				\cf7 //buffer= paths;\cf3 \
			\}\
		\};\
\
		knobDefaultAction= \{ \cf4 |k|\cf3 \
			\cf4 var\cf3  chans;\
			case \
			\{k.value < 0.01 \} \{ if (firstRun == \cf6 false\cf3 , \{ \{syn.run(\cf6 false\cf3 ); synOn= \cf6 false\cf3 \}.try \}); \}\
			\{k.value > 0.01 \} \{ if (synOn, \
				\{syn.set(\cf9 \\amp\cf3 , ampspec.map(k.value))\}, \
				\{\
					if (firstRun, \{\
						if(outbut.value==0, \{out= defaultout \});\
						\cf7 //if (currentPath.contains("/Tale/"), \{ output= speechout; \}, \{ output= out \});\cf3 \
						output= out;\
						if (outbut.value > 0, \{output= out\});\
						if (builtin, \{output= 0\});\
					 	if (buffer.numChannels == 1, \{chans= \cf5 "Mono"\cf3 \}, \{chans= \cf5 "Stereo"\cf3 \});\
						if (buffer.isNil.not, \{syn= \cf2 Synth\cf3 (player++chans, [\cf9 \\bufnum\cf3 , buffer, \cf9 \\amp\cf3 , ampspec.map(k.value), \cf9 \\out\cf3 , output, \cf9 \\pan\cf3 , pan, \cf9 \\synthID\cf3 , synthID, \cf9 \\rate\cf3 , rate]); synOn= \cf6 true\cf3 ; firstRun= \cf6 false\cf3 ;\});\
					\},\{\
						syn.run; syn.set(\cf9 \\amp\cf3 , ampspec.map(k.value), \cf9 \\rate\cf3 , rate, \cf9 \\pan\cf3 , pan); synOn= \cf6 true\cf3 ;\
						\});\
					if( \cf10 ~logfile\cf3 .isNil.not, \{ \{\cf10 ~logfile\cf3 .write(\cf2 Date\cf3 .getDate.hourStamp.asString+(currentPath.basename)++\cf5 "\\n"\cf3 )\}.defer; \});\
				\}); \
			\};	\
		\};\
		\
		c= \cf2 CompositeView\cf3 (view, \cf2 Rect\cf3 (x, y, 45, 225))\
		.background_(\cf2 Color\cf3 .black.alpha_(0.4));\
\
		\
	progressFunc= \{\cf4 |w, rect, play, reset|\cf3 \
		\cf4 var\cf3  view, elapsed= 0, remaining= dur, o;\
		\
		progressView= \cf2 UserView\cf3 (w, rect).canFocus_(\cf6 false\cf3 );\
\
		o = \cf2 OSCresponderNode\cf3 (\cf2 Server\cf3 .default.addr, \cf9 '/diskin'\cf3 , \{ \cf4 arg\cf3  time,responder,msg;\
		\cf4 var\cf3  sendID = msg[2];\
		\cf4 var\cf3  index = msg[3];\
		\
		if (msg[2] == synthID, \{\
			\cf7 //debug\cf3 \
		\cf7 /*	\
		msg.postln;\
		"id: % pos: % frames (% sec)\\n"\
			.postf(sendID, index % frames, (index % frames / samplerate));\
		*/\cf3 \
		elapsed= (index % frames / samplerate).round(0.1) / dur.round(0.1);\
		remaining= dur - (index % frames / samplerate).round(0.1);\
\
		\{	\
		progressView.drawFunc = \{\
			\cf7 //Pen.translate(100, 100);\cf3 \
				\cf2 Pen\cf3 .font = \cf2 Font\cf3 ( \cf5 "Monaco"\cf3 , 10 );\
				\cf7 // set the Color\cf3 \
				\cf2 Pen\cf3 .color = \cf2 Color\cf3 .blue(1, 1);\
				\cf2 Pen\cf3 .addWedge(22@20, 15, 0.75*2pi, elapsed*2pi);\
				\cf2 Pen\cf3 .perform(\cf9 \\fill\cf3 );\
				\cf2 Pen\cf3 .color = \cf2 Color\cf3 .white(0.5, 0.5);\
				\cf2 Pen\cf3 .stringAtPoint((remaining.floor).asTimeString.drop(3).drop(-4), 8@10);\
				\cf7 //Pen.stringAtPoint("sec", 10@10);\cf3 \
		\};\
		progressView.refresh;\
		\}.defer;\
		\});\
		\}).add;\
\
		progressView.onClose= \{o.remove; \};\
	\};\
\
		\
		progressFunc.value(c, \cf2 Rect\cf3 (0, 130, 50, 50));	\
		\
		\
		title= \cf2 StaticText\cf3 (c, \cf2 Rect\cf3 (5, 0, 40, 80))\
		.string_(\cf5 "empty"\cf3 ).font_( \cf2 GUI\cf3 .font.new(\cf5 "Helvetica"\cf3 , 10)).align_( \cf9 \\left\cf3  ).stringColor_(\cf2 Color\cf3 .grey);\
		\
		\cf2 StaticText\cf3 (c, \cf2 Rect\cf3 (5, 60, 40, 80))\
		.string_(number.asString).font_( \cf2 GUI\cf3 .font.new(\cf5 "Helvetica"\cf3 , 20)).align_( \cf9 \\center\cf3  ).stringColor_(\cf2 Color\cf3 .grey);\
		\
\
		\
		knob1= \cf2 SmoothSlider\cf3 (c, \cf2 Rect\cf3 (0, 0, 45, 170))\
		\cf7 //.addAction(f, \\mouseDownAction)\cf3 \
		.mouseDownAction_(\{ \cf4 |view, x, y, mod|\cf3 \
			if (mod.isShift, \{loadDialog.value\});\
			if (mod.isAlt, \{ \cf8 this\cf3 .free2; \cf5 "remove file"\cf3 .postln;\});\
			if (mod.isCtrl, \{\
				view.enabled= \cf6 false\cf3 ;\
				\cf8 this\cf3 .reloadSample;\
				view.enabled= \cf6 true\cf3 ;\
				\cf7 //loadFile.value([currentPath])\cf3 \
				\}); \cf7 //reload\cf3 \
				\cf7 //mod.postln;\cf3 \
		\})\
		.knobColor_( \cf2 Color\cf3 .red )\
		.background_( \cf2 Color\cf3 .white.alpha_(0.1))\
		.hilightColor_( \cf2 Color\cf3 .red.alpha_(0.5))\
		.knobSize_(0.18)\
		.border_(1).extrude_(\cf6 true\cf3 )\
		.value_( 0 )\
		\cf7 //.value_(0!2)\cf3 \
		\cf7 //.thumbSize_(5.0)\cf3 \
		\cf7 //.valueThumbSize_(5.0)\cf3 \
		\cf7 //.indexThumbSize_( 45 )\cf3 \
		\cf7 //.colors_(Color.new255(205, 145, 158), Color.red)\cf3 \
		\cf7 //.background_(Color.white.alpha_(0.1))\cf3 \
		.canFocus_(\cf6 false\cf3 )\
		.canReceiveDragHandler_(\cf6 true\cf3 )\
		.receiveDragHandler_(\{\cf4 |view|\cf3 \
			\cf4 var\cf3  paths;\
			paths= \cf2 View\cf3 .currentDrag;\
			if(paths.isString, \{paths= [paths];\}); \cf7 // qt compatibility..\cf3 \
			loadFile.value(paths);\
		\})\
		.beginDragAction_(\{ \cf8 this\cf3  \})\
		.action_(knobDefaultAction);\
		\
		\
		\
		\cf7 /*\
		panbut= Button(c, Rect(0, 172, 22, 15))\
		.states_([ ["<", Color.green, Color.black], ["c", Color.black, Color.grey],[">", Color.green, Color.black] ])\
		.canFocus_(false)\
		.value_(pan)\
		.action_(\{ |v|\
			pan= (v.value);\
		\});\
		*/\cf3 \
		\
		panKnob= \cf2 Knob\cf3 (c, \cf2 Rect\cf3 (0, 172, 15, 15))\
		.centered_(\cf6 true\cf3 )\
		.canFocus_(\cf6 false\cf3 )\
		.value_(\cf9 \\pan\cf3 .asSpec.unmap(pan))\
		.action_(\{ \cf4 |v|\cf3 \
			pan= (\cf9 \\pan\cf3 .asSpec.map(v.value));\
			if(firstRun.not, \{syn.set(\cf9 \\pan\cf3 , \cf9 \\pan\cf3 .asSpec.map(v.value))\});\
		\})\
		.color_([\cf2 Color\cf3 .gray, \cf2 Color\cf3 .red, \cf2 Color\cf3 .white, \cf2 Color\cf3 .black])\
		.mouseDownAction_(\{\cf4 |view, x, y, mod|\cf3 \
			if (mod == alt, \{view.valueAction= \cf9 \\pan\cf3 .asSpec.unmap(0); pan= 0\})\
		\})\
		.canReceiveDragHandler_(\cf6 true\cf3 )\
		.receiveDragHandler_(\{\cf4 |view|\cf3 \
			\cf4 var\cf3  drag;\
			drag= \cf2 View\cf3 .currentDrag;\
			if (drag.class == \cf2 UC33LoopChan\cf3 , \{\
				drag.setAction(\{\cf4 |v|\cf3 \{ panKnob.valueAction_(v.value)\}.defer \}, \cf5 "sl"\cf3 +number);\
				\cf7 //drag.action= \{|v| panKnob.valueAction= (v.value)\};\cf3 \
			\});\
		\});\
		\
		outbut= \cf2 Button\cf3 (c, \cf2 Rect\cf3 (17, 172, 30, 15))\
		.states_([[\cf5 "nil"\cf3 , \cf2 Color\cf3 .black, \cf2 Color\cf3 .grey], [\cf5 "1-2"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black],[\cf5 "3-4"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf5 "5-5"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf5 "7-8"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf5 "9-10"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf5 "11-12"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf5 "13-14"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf5 "15-16"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf5 "17-18"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf5 "19-20"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf5 "21-22"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black], [\cf5 "23-24"\cf3 , \cf2 Color\cf3 .yellow, \cf2 Color\cf3 .black]] )\
		.font_(\cf2 Font\cf3 (\cf5 "Helvetica"\cf3 , 9))\
		.canFocus_(\cf6 false\cf3 )\
		.value_( 0 )\
		.action_(\{ \cf4 |v|\cf3 \
			if(v.value==0, \{out= defaultout \},\
			\{out= outputs[v.value];\});\
			\{syn.free\}.try;\
			firstRun= \cf6 true\cf3 ;\
			synOn= \cf6 false\cf3 ;\
		\});		\
\
errorFileMessage= \{\
\cf4 var\cf3  w, r;\
\
	w= \cf2 SCAlert\cf3 ( \cf5 "the file you loaded is not valid. It's either just plain wrong or mp3.."\cf3 ,[\cf5 "close.. 5"\cf3 ],[\{w.window.close; r.stop; \}] );\
	\
	r= \{1.wait; \
	5.do(\{\cf4 |i|\cf3  \{w.buttonLabel_(0, \cf5 "close.."\cf3 +(5-i));\}.defer; 1.wait;\});\
	w.window.close;\}.fork(\cf2 AppClock\cf3 );\
\};\
		\
		c.onClose= \{\
			if (buffer.isNil.not, \{\
				if (player == \cf5 "diskin"\cf3 , \{buffer.close\});\
				buffer.free;\
			\});\
		\};\
		\
		\
\
	\}\
\
\
setBuf\{\cf4 |buf|\cf3 \
	\cf4 var\cf3  f, chans;\
	if (buf.isNil.not, \{\
	\{\
	if (synOn, \{syn.free; synOn= \cf6 false\cf3 ; \});\
	s.sync;\
	if (buffer.isNil.not, \{\
		if(player == \cf5 "diskin"\cf3 , \{ buffer.close \});\
		s.sync;\
		buffer.free;\
	\});\
	firstRun= \cf6 true\cf3 ;\
	f= \cf2 SoundFile\cf3 .new;\
	f.openRead(buf);\
	dur = f.numFrames/s.sampleRate;\
	frames= f.numFrames;\
	samplerate= f.sampleRate;\
	chans= f.numChannels;\
	currentPath= buf;\
	s.sync;\
	if (dur > 7, \{\
		buffer = \cf2 Buffer\cf3 .cueSoundFile(\cf2 Server\cf3 .local, buf, 0, chans);\
		player= \cf5 "diskin"\cf3 ;\
	\},\{\
		buffer= \cf2 Buffer\cf3 .read(\cf2 Server\cf3 .local, buf);\
		player= \cf5 "gpLooper"\cf3 ;\
		\cf7 //NetAddr(s.addr, 57120).sendMsg("/diskin", synthID);\cf3 \
	\});\
	\cf7 //buffer= Buffer.read(Server.local, buf);\cf3 \
	\{ title.string= buf.basename.removeExtension;\}.defer;\
	\{ title.stringColor= \cf2 Color\cf3 .white \}.defer;\
	s.sync;\
	f.close;\
	\cf7 /*\
	progressView.drawFunc = \{\
		Pen.perform(\\fill);\
		Pen.color = Color.white(0.5, 0.5);\
		Pen.stringAtPoint((dur.floor).asTimeString.drop(3).drop(-4), 10@10);\
	\};\
	progressView.refresh;\
	*/\cf3 \
	\}.fork(\cf2 AppClock\cf3 );\
	\});\
\}\
\
setVal \{\cf4 |val|\cf3 \
	\{knob1.valueAction= (val);\}.defer;\
	\cf7 //\{knob1[0].doAction\}.defer;\cf3 \
\}\
\
getValues\{\
	\cf4 var\cf3  bufFile, vals;\
	if (buffer.isNil.not, \{ bufFile= \{buffer.path\}.try; \});\
	\cf7 //vals= [bufFile, player];\cf3 \
	vals= [bufFile, player, pan, outputs[outbut.value], 1];\
	^vals\
\}\
\
setValues\{ \cf4 |vals|\cf3 \
	if (vals[0].isNil.not, \{ \
		vals[0].postln;\
			\cf7 //this.setBuf(vals[0]);\cf3 \
			\{\
			loadFile.value([vals[0]]);\
			1.wait;\
			if (vals[4].isNil.not, \{\
				if (vals[2].isNil.not, \
					\{ pan= vals[2]; panKnob.value= \cf9 \\pan\cf3 .asSpec.unmap(vals[2]); \}, \
					\{ pan= 0; panKnob.value= 0.5\});\
				\}, \{\
				pan= 0; panKnob.value= 0.5\
			\});\
			if (vals[3].isNil.not, \
				\{ out= vals[3]; outbut.value= outputs.indexOf(vals[3]); \}, \
				\{ out= defaultout; outbut.value= 0;\});\
			\}.fork(\cf2 AppClock\cf3 );\
		\}, \{\
			if (player == \cf5 "diskin"\cf3 , \{ buffer.close \});\
			buffer.free;\
			buffer= \cf6 nil\cf3 ;\
			player= \cf6 nil\cf3 ;\
			\{title.string= \cf5 "empty"\cf3  \}.defer;\
			\{title.stringColor= \cf2 Color\cf3 .grey\}.defer;\
			panKnob.value= 0.5;\
			outbut.value= 0;\
			out= defaultout;\
			pan= 0;\
			\{\
				progressView.drawFunc = \{\
					progressView.clearDrawing;\
				\};\
			progressView.refresh;\
			\}.defer;\
	\}\
	);\
	\cf7 //player= vals[1];\cf3 \
\}\
\
reloadSample\{\
	loadFile.value([currentPath])\
	\}\
\
reloadSampleSoft\{\
	\cf4 var\cf3  paths= [currentPath];\
				if(paths[0].isSoundFile , \{\
				1.do(\{\
					\cf4 var\cf3  f, chans, p;\
					p= paths[0];\
					\{\
					if (synOn, \{syn.free; synOn= \cf6 false\cf3 ; \});\
					s.sync;\
					if (buffer.isNil.not, \{\
						if(player == \cf5 "diskin"\cf3 , \{ \{buffer.close\}.try; \});\
					s.sync;\
					buffer.free;\
					\});\
					firstRun= \cf6 true\cf3 ;\
					f= \cf2 SoundFile\cf3 .new;\
					f.openRead(p);\
					dur = f.numFrames/s.sampleRate;\
					frames= f.numFrames;\
					samplerate= f.sampleRate;\
					chans= f.numChannels;\
					currentPath= p;\
					s.sync;\
					if (dur > 7, \{\
						buffer = \cf2 Buffer\cf3 .cueSoundFile(s, p, 0, chans);\
						player= \cf5 "diskin"\cf3 ;\
					\},\{\
						buffer= \cf2 Buffer\cf3 .read(s, p);\
						player= \cf5 "gpLooper"\cf3 ;\
					\});\
					(p++\cf5 " read"\cf3 ).postln;\
					\{ title.string= (p.basename.removeExtension) \}.defer;\
					\{ title.stringColor= \cf2 Color\cf3 .white \}.defer; \
					\cf7 //amp= 0.0; //set sensible amplitude as default\cf3 \
					\cf7 //outbut.valueAction= 0; pan= 0; panKnob.value= 0.5;\cf3 \
					f.close;\
					progressView.drawFunc = \{\
					\cf2 Pen\cf3 .perform(\cf9 \\fill\cf3 );\
					\cf2 Pen\cf3 .color = \cf2 Color\cf3 .white(0.5, 0.5);\
					\cf2 Pen\cf3 .stringAtPoint((dur.floor).asTimeString.drop(3).drop(-4), 10@10);\
					\};\
					progressView.refresh;\
\
					\}.fork(\cf2 AppClock\cf3 );\
				\});\
				\},\{\
					\cf7 //errorFileMessage.value;\cf3 \
				\});\
	\}\
\
free\{\
	if (synOn, \{syn.free; synOn= \cf6 false\cf3 ; \});\
	if (buffer.isNil.not, \{\
		if (player == \cf5 "diskin"\cf3 , \{ buffer.close \});\
		buffer.free;\
		buffer= \cf6 nil\cf3 ;\
	\});\
	\}\
\
free2\{\
			if (player == \cf5 "diskin"\cf3 , \{ buffer.close \});\
			buffer.free;\
			buffer= \cf6 nil\cf3 ;\
			player= \cf6 nil\cf3 ;\
			\{title.string= \cf5 "empty"\cf3  \}.defer;\
			\{title.stringColor= \cf2 Color\cf3 .grey\}.defer;\
			panKnob.value= 0.5;\
			outbut.value= 0;\
			out= defaultout;\
			pan= 0;\
			\{\
				progressView.drawFunc = \{\
					progressView.clearDrawing;\
				\};\
			progressView.refresh;\
			\}.defer;\
\}\
\
progress\{\cf4 |val|\cf3 \
	if (val == 0, \{ if(progressView.isClosed.not, \{ progressView.remove \}); \});\
	if (val == 1, \{ if(progressView.isClosed, \{ progressFunc.value(c, \cf2 Rect\cf3 (0, 130, 50, 50));\})\});\
	\}\
\
setPitch\{\cf4 |pitch|\cf3 \
	if(synOn==\cf6 true\cf3 , \{syn.set(\cf9 \\rate\cf3 , pitch)\});\
	rate= pitch;\
\}\
\
setPan\{\cf4 |v|\cf3  panKnob.valueAction= (v)\}\
\
pause\{\
	if(synOn == \cf6 true\cf3 , \{syn.run(\cf6 false\cf3 ); synOn= \cf6 false\cf3 ; paused= \cf6 true\cf3 ;\}); \
	\}\
\
unpause\{\
	if(paused == \cf6 true\cf3 , \{syn.run; syn.set(\cf9 \\amp\cf3 , ampspec.map(knob1.value[0]), \cf9 \\rate\cf3 , rate, \cf9 \\pan\cf3 , pan); synOn= \cf6 true\cf3 ; paused == \cf6 false\cf3 ; \});\
	\}\
\
\}\
\
\cf7 //EOF}