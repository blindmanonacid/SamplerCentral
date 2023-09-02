{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf600
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red191\green0\blue0;\red0\green0\blue0;\red0\green0\blue191;
\red0\green0\blue255;\red102\green102\blue191;\red96\green96\blue96;\red51\green51\blue191;\red0\green115\blue0;
}
{\*\expandedcolortbl;;\csgenericrgb\c75000\c0\c0;\csgenericrgb\c0\c0\c0;\csgenericrgb\c0\c0\c75000;
\csgenericrgb\c0\c0\c100000;\csgenericrgb\c40000\c40000\c75000;\csgenericrgb\c37500\c37500\c37500;\csgenericrgb\c20000\c20000\c75000;\csgenericrgb\c0\c45000\c0;
}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 // (c) 2006, Thor Magnusson - www.ixi-software.net\cf3 \
\cf2 // GNU licence - google it.\cf3 \
\
\cf4 MIDIKeyboard\cf3  \{\
\
	\cf5 var\cf3  <>keys; \
	\cf5 var\cf3  trackKey, chosenkey, mouseTracker;\
	\cf5 var\cf3  win, bounds, octaves, startnote;\
	\cf5 var\cf3  downAction, upAction, trackAction;\
	\cf5 var\cf3  keyCodeMap, keyCodesPressed;\
	\cf5 var\cf3  <transpose=0, <>miscKeyAction;\
	\cf5 var\cf3  <>keyboardColor;\
	\
	*new \{ \cf5 arg\cf3  w, bounds, octaves, startnote; \
		^\cf6 super\cf3 .new.initMIDIKeyboard(w, bounds, octaves, startnote);\
	\}\
	\
	initMIDIKeyboard \{ \cf5 arg\cf3  w, argbounds, argoctaves=3, argstartnote;\
		\cf5 var\cf3  r, pix, pen;\
		octaves = argoctaves ? 4;\
		bounds = argbounds ? \cf4 Rect\cf3 (20, 10, 364, 60);\
				\
		if((win= w).isNil, \{\
			win = \cf4 GUI\cf3 .window.new(\cf7 "MIDI Keyboard"\cf3 ,\
				\cf4 Rect\cf3 (10, 250, bounds.left + bounds.width + 40, bounds.top + bounds.height+30));\
			win.front\
		\});\
\
 		mouseTracker = \cf4 GUI\cf3 .userView.new(win, bounds); \cf2 // thanks ron!\cf3 \
 		bounds = mouseTracker.bounds;\
\
		pen	= \cf4 GUI\cf3 .pen;\
\
		startnote = argstartnote ? 48;\
		trackKey = 0;\
		\cf2 //pix = [0, 6, 10, 16, 20, 30, 36, 40, 46, 50, 56, 60];\cf3 \
		pix = [ 0, 0.1, 0.17, 0.27, 0.33, 0.5, 0.6, 0.67, 0.77, 0.83, 0.93, 1 ]; \cf2 // as above but normalized\cf3 \
		keys = \cf4 List\cf3 .new;\
		\
		keyCodeMap=[6,1,7,2,8,9,5,11,4,45,38,46,12,19,13,20,14,\
									15,23,17,22,16,26,32,34,25,31,29,35];\
		keyCodesPressed=[];\
		\
		keyboardColor=\cf4 Color\cf3 (0.5,0.5,0.5);\
\
		octaves.do(\{\cf5 arg\cf3  j;\
			12.do(\{\cf5 arg\cf3  i;\
				if((i == 1) || (i == 3) || (i == 6) || (i == 8) || (i == 10), \{ \cf2 //black\cf3 \
					r = \cf4 Rect\cf3 (	(bounds.left+ (pix[i]*((bounds.width/octaves) -\
								(bounds.width/octaves/7))).round(1) + ((bounds.width/octaves)*j)).round(1)+0.5,\
							bounds.top, \
							bounds.width/octaves/10, \
							bounds.height/1.7);\
					keys.add(\cf4 MIDIKey\cf3 .new(startnote+i+(j*12), r, \cf4 Color\cf3 .black));\
				\}, \{ \cf2 //white\cf3 \
					r = \cf4 Rect\cf3 ((bounds.left+(pix[i]*((bounds.width/octaves) -\
								(bounds.width/octaves/7))).round(1) + ((bounds.width/octaves)*j)).round(1)+0.5,\
							bounds.top, \
							bounds.width/octaves/7, \
							bounds.height);\
					keys.add(\cf4 MIDIKey\cf3 .new(startnote+i+(j*12), r, \cf4 Color\cf3 .white));\
				\});\
			\});\
		\});\
\
		mouseTracker\
			.canFocus_(\cf8 true\cf3 )\
			.focusColor_(\cf4 Color\cf3 .red)\
			.mouseDownAction_(\{\cf5 |me, x, y, mod|\cf3 \
				chosenkey = \cf6 this\cf3 .findNote(x, y);\
				trackKey = chosenkey;\
				chosenkey.color = keyboardColor;\
				downAction.value(chosenkey.note);\
				\cf6 this\cf3 .refresh;	\
			\})\
			.mouseMoveAction_(\{\cf5 |me, x, y, mod|\cf3 \
				y=y.clip(0,bounds.height);\
				x=x.clip(1,bounds.width);\
				chosenkey = \cf6 this\cf3 .findNote(x, y);\
				if(trackKey.note != chosenkey.note, \{\
					trackKey.color = trackKey.scalecolor; \cf2 // was : type\cf3 \
					trackKey = chosenkey;\
					chosenkey.color = keyboardColor;\
					trackAction.value(chosenkey.note);\
					\cf6 this\cf3 .refresh;\
				\});\
			\})\
			.mouseUpAction_(\{\cf5 |me, x, y, mod|\cf3 \
				chosenkey = \cf6 this\cf3 .findNote(x, y);\
				trackKey = chosenkey;\
				chosenkey.color = chosenkey.scalecolor; \cf2 // was:  type\cf3 \
				upAction.value(chosenkey.note);\
				\cf6 this\cf3 .refresh;\
			\})\
			.drawFunc_(\{\
				octaves.do(\{\cf5 arg\cf3  j;\
					\cf2 // first draw the white keys\cf3 \
					12.do(\{\cf5 arg\cf3  i;\
						\cf5 var\cf3  key;\
						key = keys[i+(j*12)];\
						if(key.type == \cf4 Color\cf3 .white, \{\
							pen.color = \cf4 Color\cf3 .black;\
							pen.strokeRect(\cf4 Rect\cf3 (key.rect.left+0.5, key.rect.top+0.5, key.rect.width+0.5, key.rect.height-0.5));\
							pen.color = key.color; \cf2 // white or grey\cf3 \
							pen.fillRect(\cf4 Rect\cf3 (key.rect.left+0.5, key.rect.top+0.5, key.rect.width+0.5, key.rect.height-0.5));\
						\});\
					\});\
					\cf2 // and then draw the black keys on top of the white\cf3 \
					12.do(\{\cf5 arg\cf3  i;\
						\cf5 var\cf3  key;\
						key = keys[i+(j*12)];\
						if(key.type == \cf4 Color\cf3 .black, \{\
							pen.color = key.color;\
							pen.fillRect(\cf4 Rect\cf3 (key.rect.left+0.5, key.rect.top+0.5, key.rect.width+0.5, key.rect.height+0.5));\
						\});\
					\})\
				\})\
			\})\
			.keyDownAction_\{\cf5 |me,char, modifiers, unicode, keycode|\cf3 \
				\cf5 var\cf3  kcm=keyCodeMap.indexOf(keycode);\
				\
				\cf2 //[me,char, modifiers, unicode, keycode].postln;\cf3 \
				\
				if (keycode==126) \{miscKeyAction.value(\cf9 \\up\cf3 )   ;\};\
				if (keycode==125) \{miscKeyAction.value(\cf9 \\down\cf3 ) ;\};\
				if (keycode==123) \{miscKeyAction.value(\cf9 \\left\cf3 ) ;\};\
				if (keycode==124) \{miscKeyAction.value(\cf9 \\right\cf3 );\};\
				if (keycode== 49) \{miscKeyAction.value(\cf9 \\space\cf3 );\};\
				\
				if (keycode== 27) \{transpose=(transpose-1).clip(-1,2)\};\
				if (keycode== 24) \{transpose=(transpose+1).clip(-1,2)\};\
				\
				\cf2 // keyboard note pressed\cf3 \
				if (kcm.isNumber) \{									if (keyCodesPressed.includes(keycode).not) \{ \cf2 // test for repeat key press\cf3 \
						\cf6 this\cf3 .keyOn((kcm+(transpose*12)).clip(-24,127-24)); \cf2 // play note\cf3 \
						keyCodesPressed=keyCodesPressed.add(keycode); \cf2 // store for next key test\cf3 \
					\}\
				\}\
			\}\
			.keyUpAction = \{ \cf5 |me,char,modifiers,unicode,keycode|\cf3 \
				\cf5 var\cf3  kcm=keyCodeMap.indexOf(keycode);\
				if (kcm.isNumber) \{	\
					\cf6 this\cf3 .keyOff((kcm+(transpose*12)).clip(-24,127-24)); \cf2 // note off\cf3 \
					keyCodesPressed.remove(keycode); \cf2 // remove from repeat key list\cf3 \
				\}	\
			\};\
			\
		\
	\}\
	\
	keyOn\{\cf5 |note|\cf3 \
		note=note+24;\
		\cf2 //("Key On"+(note.asString)).postln;\cf3 \
		downAction.value(note);\
		\
		\cf6 this\cf3 .setColor(note,keyboardColor,0.75);\
	\}\
	\
	keyOff\{\cf5 |note|\cf3 \
		note=note+24;\
		\cf2 //("Key Off"+(note.asString)).postln;\cf3 \
		upAction.value(note);\
		\cf6 this\cf3 .removeColor(note);\
	\}\
	\
	refresh \{\
		if (win.isClosed.not) \{\
			mouseTracker.refresh;\
		\};\
	\}\
	\
	focus\{\
		mouseTracker.focus;\
	\}\
	\
	keyDown \{ \cf5 arg\cf3  note, color; \cf2 // midinote\cf3 \
		if(\cf6 this\cf3 .inRange(note), \{\
			keys[note - startnote].color = \cf4 Color\cf3 .grey;\
		\});\
		\cf6 this\cf3 .refresh;\
	\}\
	\
	keyUp \{ \cf5 arg\cf3  note; \cf2 // midinote\cf3 \
		if(\cf6 this\cf3 .inRange(note), \{\
			keys[note - startnote].color = keys[note - startnote].scalecolor;\
		\});\
		\cf6 this\cf3 .refresh;	\
	\}\
	\
	keyDownAction_ \{ \cf5 arg\cf3  func;\
		downAction = func;\
	\}\
	\
	keyUpAction_ \{ \cf5 arg\cf3  func;\
		upAction = func;\
	\}\
	\
	keyTrackAction_ \{ \cf5 arg\cf3  func;\
		trackAction = func;\
	\}\
	\
	showScale \{\cf5 arg\cf3  argscale, key=startnote, argcolor;\
		\cf5 var\cf3  color, scale, counter, transp;\
		\cf6 this\cf3 .clear; \cf2 // erase scalecolors (make them their type)\cf3 \
		counter = 0;\
		color = argcolor ? \cf4 Color\cf3 .red;\
		transp = key%12;\
		scale = argscale + transp + startnote;		\
		keys.do(\{\cf5 arg\cf3  key, i;\
			key.color = key.type; \cf2 // back to original color\cf3 \
			if(((i-transp)%12 == 0)&&((i-transp)!=0), \{ counter = 0; scale = scale+12;\});			if(key.note == scale[counter], \{\
				counter = counter + 1; \
				key.color = key.color.blend(color, 0.5);\
				key.scalecolor = key.color;\
				key.inscale = \cf8 true\cf3 ;\
			\});\
		\});\
		\cf6 this\cf3 .refresh;\
	\}\
	\
	clear \{\
		keys.do(\{\cf5 arg\cf3  key, i;\
			key.color = key.type; \cf2 // back to original color\cf3 \
			key.scalecolor = key.color;\
			key.inscale = \cf8 false\cf3 ;\
		\});\
		\cf6 this\cf3 .refresh;\
	\}\
	\
	\cf2 // just for fun\cf3 \
	playScale \{ \cf5 arg\cf3  argscale, key=startnote, int=0.5;\
		\cf5 var\cf3  scale = argscale;\
		\cf4 SynthDef\cf3 (\cf9 \\midikeyboardsine\cf3 , \{\cf5 arg\cf3  freq, amp = 0.25;\
			\cf4 Out\cf3 .ar(0, (\cf4 SinOsc\cf3 .ar(freq,0,amp)*\cf4 EnvGen\cf3 .ar(\cf4 Env\cf3 .perc, doneAction:2)).dup)\
		\}).load(\cf4 Server\cf3 .default);\
		\cf4 Task\cf3 (\{\
			scale.mirror.do(\{\cf5 arg\cf3  note;\
				\cf4 Synth\cf3 (\cf9 \\midikeyboardsine\cf3 , [\cf9 \\freq\cf3 , (key+note).midicps]);\
				int.wait;\
			\});		\}).start;\
	\}\
	\
	setColor \{\cf5 arg\cf3  note, color, blend=0.5;\
		\cf5 var\cf3  newcolor;\
		if (\cf6 this\cf3 .inRange(note)) \{\
			newcolor = keys[note - startnote].color.blend(color,blend);\
			keys[note - startnote].color = newcolor;\
			keys[note - startnote].scalecolor = newcolor;\
			\cf6 this\cf3 .refresh;\
		\}\
	\}\
	\
	getColor \{ \cf5 arg\cf3  note;\
		if (\cf6 this\cf3 .inRange(note)) \{\
			^keys[note - startnote].color;\
		\}\{\
			^\cf8 nil\cf3 \
		\}\
	\}\
	\
	getType \{ \cf5 arg\cf3  note;\
		^keys[note - startnote].type;\
	\}\
	\
	removeColor \{\cf5 arg\cf3  note;\
		if (\cf6 this\cf3 .inRange(note)) \{\
			keys[note - startnote].scalecolor = keys[note - startnote].type;\
			keys[note - startnote].color = keys[note - startnote].type;\
			\cf6 this\cf3 .refresh;\
		\}\
	\}\
	\
	inScale \{\cf5 arg\cf3  key;\
		^keys[key-startnote].inscale;\
	\}\
	\
	retNote \{\cf5 arg\cf3  key;\
		^keys[key].note;\
	\}\
	\
	remove \{\
		mouseTracker.remove;\
		win.refresh;\
	\}\
	\
	view \{\
		^mouseTracker\
	\}\
	\
	\cf2 // local function\cf3 \
	findNote \{\cf5 arg\cf3  x, y;\
		\cf5 var\cf3  chosenkeys;\
		chosenkeys = [];\
		keys.reverse.do(\{\cf5 arg\cf3  key;\
			if(key.rect.containsPoint(\cf4 Point\cf3 .new(x,y)), \{\
				chosenkeys = chosenkeys.add(key);\
			\});\
		\});\
		block\{\cf5 |break|\cf3 \
			chosenkeys.do(\{\cf5 arg\cf3  key;\
				if(key.type == \cf4 Color\cf3 .black, \{ \
					chosenkey = key; \
					break.value; \cf2 // the important part\cf3 \
				\}, \{\
					chosenkey = key; \
				\});\
			\});\
		\};\
		^chosenkey;\
	\}\
	\
	\cf2 // local\cf3 \
	inRange \{\cf5 arg\cf3  note; \cf2 // check if an input note is in the range of the keyboard\cf3 \
		if (note.isNumber.not) \{^\cf8 false\cf3 \};\
		if((note>=startnote) && (note<(startnote + (octaves*12))), \{^\cf8 true\cf3 \}, \{^\cf8 false\cf3 \});\
	\}\
	\
\
\
\}\
\
\cf4 MIDIKey\cf3  \{\
	\cf5 var\cf3  <rect, <>color, <note, <type;\
	\cf5 var\cf3  <>scalecolor, <>inscale;\
	\
	*new \{ \cf5 arg\cf3  note, rect, type; \
		^\cf6 super\cf3 .new.initMIDIKey(note, rect, type);\
	\}\
	\
	initMIDIKey \{\cf5 arg\cf3  argnote, argrect, argtype;\
		note = argnote;\
		rect = argrect;\
		type = argtype;\
		color = argtype;\
		scalecolor = color;\
		inscale = \cf8 false\cf3 ;\
	\}	\
\
\}\
}