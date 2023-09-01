{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf600
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue191;\red0\green0\blue0;\red191\green0\blue0;
\red0\green0\blue255;\red51\green51\blue191;\red102\green102\blue191;\red96\green96\blue96;}
{\*\expandedcolortbl;;\csgenericrgb\c0\c0\c75000;\csgenericrgb\c0\c0\c0;\csgenericrgb\c75000\c0\c0;
\csgenericrgb\c0\c0\c100000;\csgenericrgb\c20000\c20000\c75000;\csgenericrgb\c40000\c40000\c75000;\csgenericrgb\c37500\c37500\c37500;}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 MIDIKeyboardWindow\cf3  \{\
	\
	\cf4 // needs work\cf3 \
	\
	\}\
\
\
\cf2 KeyboardWindow\cf3  \{\
	\cf5 classvar\cf3  <blackKeysStructure; \
	\cf5 classvar\cf3  <allWindows;\
	\
	\cf5 var\cf3  <nKeys = 36, <startOctave = 1, <>channel, <bounds;\
	\cf5 var\cf3  <activeKeys, <lastVelo, <notesDict;\
	\cf5 var\cf3  <window = \cf6 nil\cf3 , <userView = \cf6 nil\cf3 ;\
	\cf5 var\cf3  <>downAction, <>upAction;\
	\cf5 var\cf3  <>hold = \cf6 false\cf3 ;\
	\
	*initClass \{\
		blackKeysStructure = [0,1,1,0,1,1,1];\
		allWindows = [];\
		\}\
	\
	*new \{ \cf5 |nKeys = 36, startOctave = 1, channel = 0, bounds|\cf3 \
		\cf5 var\cf3  out;\
		bounds = bounds ?  \cf2 Rect\cf3 ( 128, 64, 600, 100 );\
		out = \cf7 super\cf3 .newCopyArgs( nKeys, startOctave, channel, bounds, [], 64, () )\
			.downAction_( \{ \cf5 |chan, note, velo|\cf3  [chan, note, velo].postln; \} ).newWindow;\
		allWindows = allWindows.add( out );\
		^out;\
		\}\
		\
	*scale \{ \
		\cf5 var\cf3  last = 0;\
		^blackKeysStructure.collect(\{ \cf5 |item|\cf3 \
			\cf5 var\cf3  out;\
			out = last + item + 1;\
			last = out;\
			out - 1;\
		\});\
	\}\
	\
	*pressNote \{ \cf5 |noteNumber = 64, velo = 64, channel = 0|\cf3 \
		allWindows\
			.select(\{ \cf5 |item|\cf3  item.channel == channel \})\
			.do( \cf2 _\cf3 .pressNote( noteNumber, velo ) );\
		\}\
		\
	*unPressNote \{ \cf5 |noteNumber = 64, velo = 64, channel = 0|\cf3 \
		allWindows\
			.select(\{ \cf5 |item|\cf3  item.channel == channel \})\
			.do( \cf2 _\cf3 .unPressNote( noteNumber, velo ) );\
		\}\
		\
	*unPressAll \{ \cf5 |velo = 64, channel|\cf3 \
		if( channel.notNil,\
			\{ allWindows\
				.select(\{ \cf5 |item|\cf3  item.channel == channel \}) \},\
			\{ allWindows \} )\
				.do( \cf2 _\cf3 .unPressAll( velo ) );\
		\}\
	\
	pressNote \{ \cf5 |noteNumber = 64, velo= 64|\cf3 \
		\cf5 var\cf3  newKey;\
		newKey = noteNumber.keyToDegree( \cf2 KeyboardWindow\cf3 .scale, 12 ).round(0.5);\
		if( \cf7 this\cf3 .pressKey( newKey, velo ) )\
			\{ downAction.value( channel, noteNumber, velo ); \}\
			\{ upAction.value( channel, noteNumber, velo );   \};\
		\}\
	\
	unPressNote \{ \cf5 |noteNumber = 64, velo= 64|\cf3 \
		\cf5 var\cf3  newKey;\
		newKey = noteNumber.keyToDegree( \cf2 KeyboardWindow\cf3 .scale, 12 ).round(0.5);\
		if( \cf7 this\cf3 .unPressKey( newKey, velo ) )\
			\{ upAction.value( channel, noteNumber, velo ); \};\
		\}\
		\
	unPressAll \{ \cf5 |velo = 64|\cf3 \
		\cf7 this\cf3 .activeNotes.do( \cf7 this\cf3 .unPressNote( \cf2 _\cf3 , velo ) );\
		\}\
		\
	activeNotes \{ \
		\cf5 var\cf3  scale;\
		scale = \cf7 this\cf3 .class.scale;\
		^activeKeys.collect(\{ \cf5 |key|\cf3  \
			key.floor.degreeToKey( scale, 12 ) + (key.frac * 2) \
				\cf4 // degreeToKey seems to have a problem with Floats... why?\cf3 \
			\});\
		\}\
		\
	\cf4 // private\cf3 \
	pressKey \{ \cf5 |key, velo|\cf3 \
		\cf4 // returns false and switchess off if already pressed\cf3 \
		if( activeKeys.remove( key ).isNil )\
				\{ activeKeys = activeKeys.add( key );\
					notesDict.put( key, velo ); \
					lastVelo = velo;\
					window.refresh; ^\cf6 true\cf3 ;\
					\}\
				\{ window.refresh; ^\cf6 false\cf3  \}\
		\}\
		\
	unPressKey \{ \cf5 |key, velo|\cf3  \cf4 // velo not used yet\cf3 \
		\cf4 // returns false if already unpressed\cf3 \
		if( activeKeys.includes( key ) )\
			\{ activeKeys.remove( key ); window.refresh;\
			^\cf6 true\cf3  \}\
			\{ ^\cf6 false\cf3  \};\
	\
		\}\
	\
	newWindow \{\
		\cf5 var\cf3  nWhiteKeys = ((nKeys / 12) * 7).ceil;\
		\cf5 var\cf3  scale;\
		\cf4 //var blackKeysStructure = [0,1,1,0,1,1,1];\cf3 \
					\
		window = \cf2 Window\cf3 ( \cf8 "keys (channel "\cf3  ++ channel ++ \cf8 " )"\cf3 , bounds );\
		window.view.background_( \cf2 Color\cf3 .white );	\
		window.front;\
				\
		scale = \cf2 KeyboardWindow\cf3 .scale;			\
		userView = \cf2 UserView\cf3 ( window, window.view.bounds ).resize_( 5 );\
		\
		userView.mouseDownAction_(\{\cf5 |v,x,y|\cf3  \
			\cf5 var\cf3  theKey = ( (x / bounds.width) * nWhiteKeys ) + ( (startOctave + 2) * 7 );\
			\cf5 var\cf3  velo;\
			if( ( y < ( bounds.height * 0.66 ) ) )  \
				\{  case	\{ (theKey.frac < 0.25) && \
							\{ blackKeysStructure.wrapAt( theKey.floor) == 1 \}  \}\
					\{ theKey = theKey.floor - 0.5 \}\
						\{ (theKey.frac > 0.75) && \
							\{ blackKeysStructure.wrapAt( theKey.floor + 1) == 1 \}  \}\
					\{ theKey = theKey.floor + 0.5 \}\
						\{ \cf6 true\cf3  \}\
					\{ theKey = theKey.floor \};\
					\}\
				\{ theKey = theKey.floor; \};\
			\
			if( theKey.frac == 0.5 )\
				\{ velo = (( y / ( bounds.height * 0.66 ) ) * 127); \}\
				\{ velo = (( y / bounds.height ) * 127); \};\
			\
			if( \cf7 this\cf3 .pressKey( theKey, velo ) )\
				\{ downAction.value( channel, \
							theKey.floor.degreeToKey( scale, 12 ) + \
							(theKey.frac * 2),\
							velo ); \} \
				\{ upAction.value( channel, \
							theKey.floor.degreeToKey( scale, 12 ) + \
							(theKey.frac * 2),\
							velo );\
					\};\
			lastVelo = velo;\
			\});\
			\
		userView.mouseUpAction_(\{\cf5 |v,x,y|\cf3  \
			\cf5 var\cf3  theKey; \
			\cf5 var\cf3  velo;\
			if( hold.not )\
				\{ theKey = ( (x / bounds.width) * nWhiteKeys )  + ( (startOctave + 2) * 7 );\
					if( ( y < ( bounds.height * 0.66 ) ) )  \
						\{  case	\{ (theKey.frac < 0.25) && \
									\{ blackKeysStructure.wrapAt( theKey.floor) == 1 \}  \}\
							\{ theKey = theKey.floor - 0.5 \}\
								\{ (theKey.frac > 0.75) && \
									\{ blackKeysStructure.wrapAt( theKey.floor + 1) == 1 \}  \}\
							\{ theKey = theKey.floor + 0.5 \}\
								\{ \cf6 true\cf3  \}\
							\{ theKey = theKey.floor \};\
							\}\
						\{ theKey = theKey.floor; \};\
					\
					if( theKey.frac == 0.5 )\
						\{ velo = (( y / ( bounds.height * 0.66 ) ) * 127); \}\
						\{ velo = (( y / bounds.height ) * 127); \};\
		\
					if( \cf7 this\cf3 .unPressKey( theKey, lastVelo.copy ) )\
						\{ upAction.value( channel, \
									theKey.floor.degreeToKey( scale, 12 ) + \
									(theKey.frac * 2),\
									velo );  \};\
				\}\
			\});\
			\
		\
		window.drawHook = \{ \cf5 | theWindow |\cf3 \
			bounds = theWindow.bounds;\
			\cf4 //userView.bounds = bounds.copy.top_(0).left_(0);\cf3 \
			\cf2 Color\cf3 .black.set;\
			\
			nWhiteKeys.do( \{ \cf5 |i|\cf3 \
				\cf5 var\cf3  position, keyWidth;\
				keyWidth = bounds.width / nWhiteKeys;\
				position = keyWidth * i;\
				if( activeKeys.includes( i + ( (startOctave + 2) * 7 )  ) )\
					\{ \cf2 Pen\cf3 .width = keyWidth;\
						\cf2 Color\cf3 .gray(0.66).blend(\cf2 Color\cf3 .red, (notesDict.at( \
							i + ( (startOctave + 2) * 7 ) ) ? 0.5) / 127 ).set;\
						\cf2 Pen\cf3 .moveTo( (keyWidth * (i + 0.5))@0 );\
						\cf2 Pen\cf3 .lineTo( (keyWidth * (i + 0.5))@bounds.height );\
						\cf2 Pen\cf3 .stroke;  \};\
					\
				\cf2 Color\cf3 .black.set;\
				\cf2 Pen\cf3 .width = 1;\
				\cf2 Pen\cf3 .moveTo( position@0 );\
				\cf2 Pen\cf3 .lineTo( position@bounds.height );\
				\cf2 Pen\cf3 .stroke;\
				if( blackKeysStructure.wrapAt(i) == 1 )\
					\{ 	if( activeKeys.includes( (i - 0.5) + \
									( (startOctave + 2) * 7 ) ) )\
							\{ \cf2 Color\cf3 .gray(0.33).blend( \cf2 Color\cf3 .red, \
								(notesDict.at( \
									(i - 0.5) + \
										( (startOctave + 2) * 7 ) ) ? 0.5) / 127 ).set; \};\
						\cf2 Pen\cf3 .width = keyWidth * 0.5;\
						\cf2 Pen\cf3 .moveTo( position@0 );\
						\cf2 Pen\cf3 .lineTo( position@(bounds.height * 0.66) );\
						\cf2 Pen\cf3 .stroke; \};\
				if( i%7 == 0) \{ [\cf8 "C"\cf3  ++ (startOctave + (i / 7))].wrapAt(i)\
					.drawAtPoint( (keyWidth * (i + 0.2))@(bounds.height - 14), \
						color: \cf2 Color\cf3 .gray ) \};\
				\} );\
		\
			\};\
		\
		window.onClose_( \{ allWindows.remove( \cf7 this\cf3  ) \} );\
		\
		^\cf7 this\cf3 ;\
		\}\
		\
	storeArgs \{ `[nKeys, startOctave, channel, window] \}\
	\
	\}\
		}