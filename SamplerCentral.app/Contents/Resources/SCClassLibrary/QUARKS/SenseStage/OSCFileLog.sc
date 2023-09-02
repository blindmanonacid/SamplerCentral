{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf600
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red191\green0\blue0;\red0\green0\blue0;\red0\green0\blue191;
\red0\green0\blue255;\red102\green102\blue191;\red96\green96\blue96;\red51\green51\blue191;\red0\green115\blue0;
\red255\green102\blue0;}
{\*\expandedcolortbl;;\csgenericrgb\c75000\c0\c0;\csgenericrgb\c0\c0\c0;\csgenericrgb\c0\c0\c75000;
\csgenericrgb\c0\c0\c100000;\csgenericrgb\c40000\c40000\c75000;\csgenericrgb\c37500\c37500\c37500;\csgenericrgb\c20000\c20000\c75000;\csgenericrgb\c0\c45000\c0;
\csgenericrgb\c100000\c40000\c0;}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 /*\
OSC message recorder and player\
(c) 2013 - Marije Baalman\
GPL3 license\
\
// this class needs the FileLog quark to function\
\
\
// ------ recording\
\
// to record, create a OSCFileLog\
~timelog = OSCFileLog.new( "test" ); // "test" is the base for the filename, a datetime stamp will be automatically added to the name\
\
// send some osc data to test:\
n = NetAddr.new( "localhost", NetAddr.langPort );\
(\
Task(\{ 10.do\{\
	n.sendMsg( "/hello", 0, 20.rand, 19.rand, "hello", 3, 4, 2.003);\
	1.0.rand.max(0.01).wait;\
\}\}).play;\
);\
\
// close the file again:\
~timelog.close;\
\
\
//------- playback:\
\
// set up our target net address (here we just send to SC again\
n = NetAddr.new( "localhost", NetAddr.langPort );\
\
// we trace it to see if we get it, just to show that it works:\
OSCFunc.trace( true );\
\
// create a player\
~oscplayer = OSCFileLogPlayer.new( "/home/nescivi/SuperCollider/test_130812_121049", n ); // arguments are the file/folder we previously recorded, and the target netaddress\
\
// and play it\
~oscplayer.play;\
\
~oscplayer.pause;\
\
~oscplayer.resume;\
\
~oscplayer.stop;\
\
~oscplayer.reset;\
\
// play back faster:\
~myClock = TempoClock.new( 10 );\
~oscplayer.play( ~myClock );\
\
\
// close the file again:\
~oscplayer.close;\
\
\
\
*/\cf3 \
\
\
\cf4 OSCFileLog\cf3 \{\
\
	\cf5 var\cf3  <recTime;\
	\cf5 var\cf3  <timelogfile;\
	\cf5 var\cf3  <offset;\
	\cf5 var\cf3  <oscRecFunc;\
	\cf5 var\cf3  prevValue;\
\
	*new\{ \cf5 |fn, ip|\cf3 \
		^\cf6 super\cf3 .new.init( fn, ip );\
	\}\
\
	init\{ \cf5 |fn, ip|\cf3 \
		fn = fn ? \cf7 "TimeFileLog"\cf3 ;\
		\cf6 this\cf3 .open(fn, ip);\
	\}\
\
	open\{ \cf5 |fn, ip|\cf3 \
        \cf5 var\cf3  filename = fn ++ \cf7 "_"\cf3 ++\cf4 Date\cf3 .localtime.stamp++\cf7 ".txt"\cf3 ;\
		timelogfile = \cf4 MultiFileWriter\cf3 .new( filename ).zipSingle_( \cf8 false\cf3  ).tarBundle_( \cf8 false\cf3  );\
		timelogfile.open;\
		recTime = \cf8 true\cf3 ;\
		oscRecFunc = \{ \cf5 |msg, time|\cf3  \
			\cf2 //msg[0].postln;\cf3 \
			\cf2 //msg[0].class.postln;\cf3 \
			\cf2 //msg.postln;\cf3 \
			\cf2 //ip.postln;\cf3 \
			\cf2 //msg[0].class.postln;\cf3 \
			if (msg[0].asString==ip, \{\
				\cf2 //"i gotz ur ip!".postln;\cf3 \
				if (msg[1].asString.contains(\cf7 "SR"\cf3 ), \{ \cf2 // unnecesarry!!\cf3 \
					if(msg[1]!=prevValue, \{\
						\cf6 this\cf3 .writeLine( time, msg[1], msg.copyToEnd( 1 ) );\
						prevValue= msg[1];\
					\});\
					\});\
				\});\
			\};\
		\cf6 this\cf3 .resetTime;\
		\cf6 thisProcess\cf3 .addOSCRecvFunc( oscRecFunc );\
        \cf7 "recording OSC data to %\\n"\cf3 .postf( timelogfile.pathDir );\
	\}\
\
	resetTime\{\
		offset = \cf4 Process\cf3 .elapsedTime;\
	\}\
\
	writeLine\{ \cf5 |time,tag,data|\cf3 \
        timelogfile.writeLine( [time - offset, tag.asCompileString ] ++ data.collect\{ \cf5 |it|\cf3  it.asCompileString \} );\
	\}\
\
	close\{\
		recTime = \cf8 false\cf3 ;\
		timelogfile.close;\
		\cf6 thisProcess\cf3 .removeOSCRecvFunc( oscRecFunc );\
	\}\
\}\
\
\cf2 // reads a data network log and plays it\cf3 \
\
\cf4 OSCFileLogPlayer\cf3 \{\
	\cf5 var\cf3  <reader;\
	\cf5 var\cf3  playTask;\
\
	\cf5 var\cf3  <curTime=0;\
\
	\cf5 var\cf3  <fileClass;\
\
	\cf5 var\cf3  <hasExtraTab = \cf8 false\cf3 ;\
\
	\cf5 var\cf3  <targetaddr;\
	\
	\cf5 var\cf3  <doneFunc;\
	\
	\cf5 var\cf3  recToAddr;\
	\cf5 var\cf3  <>clock;\
	\
	\cf5 var\cf3  midi, midiDict, mid;\
\
	*new\{ \cf5 |fn,addr, done, recAddr|\cf3 \
		^\cf6 super\cf3 .new.init( fn, addr, done, recAddr );\
	\}\
\
	init\{ \cf5 |fn,addr, done, recAddr|\cf3 \
		targetaddr = addr;\
		doneFunc= done;\
		recToAddr= recAddr;\
		\cf6 this\cf3 .checkFileClass( fn );\
		\cf6 this\cf3 .open( fn );\
	\}\
\
	checkFileClass\{ \cf5 |fn|\cf3 \
		\cf5 var\cf3  tar,txt;\
		\cf5 var\cf3  path = \cf4 PathName\cf3 (fn);\
		tar = (path.extension == \cf7 "tar"\cf3 );\
		txt = (path.extension == \cf7 "txt"\cf3 );\
		mid = (path.extension == \cf7 "mid"\cf3 );\
		if ( mid ) \{ \
			midi= \cf4 SimpleMIDIFile\cf3 .read(fn);\
			midi.timeMode= \cf9 \\seconds\cf3 ;\
			midiDict= \cf4 Dictionary\cf3 .new;\
			midiDict.putPairs([21, \cf7 "SR1"\cf3 , 22, \cf7 "SR2"\cf3 , 23, \cf7 "SR3"\cf3 , 24, \cf7 "SR4"\cf3 , 25, \cf7 "SR5"\cf3 , 26, \cf7 "SR6"\cf3 , 27, \cf7 "SR7"\cf3 , 28, \cf7 "SR8"\cf3 , 29, \cf7 "SR9"\cf3 , 30, \cf7 "BRK"\cf3 , 41, \cf7 "RL1"\cf3 , 42, \cf7 "RL2"\cf3 , 43, \cf7 "RL3"\cf3 , 44, \cf7 "RL4"\cf3 , 45, \cf7 "RL5"\cf3 , 46, \cf7 "RL6"\cf3 , 47, \cf7 "RL7"\cf3 , 48, \cf7 "RL8"\cf3 , 49, \cf7 "RL9"\cf3 ]);\
		\}\{\
			if ( tar )\{\
				fileClass = \cf4 MultiFilePlayer\cf3 ;\
			\}\{\
				if ( txt )\{\
					fileClass = \cf4 TabFilePlayer\cf3 ;\
				\}\{\
					fileClass = \cf4 MultiFilePlayer\cf3 ;\
				\}\
			\};\
		\};\
		\cf2 //		[tar, txt, fileClass].postln;\cf3 \
	\}\
\
	open\{ \cf5 |fn|\cf3 \
		if ( playTask.notNil )\{ playTask.stop; \};\
		if ( reader.notNil )\{ reader.close; \};\
\
		if( midi.isNil, \{\
			reader = fileClass.new( fn );\
		\});\
		clock= \cf4 TempoClock\cf3 .new;\
\
	\cf2 //	this.readHeader;\cf3 \
		\cf2 /*\
		playTask = Task\{\
			var dt = 0;\
			while( \{ dt.notNil \}, \{\
				dt = this.readLine;\
				if ( dt.notNil )\{\
					dt.wait;\
				\}\
			\});\
		\};\
		*/\cf3 \
		if( midi.isNil, \{\
			\
		playTask = \cf4 Task\cf3 (\{ \cf2 // "regular" osc file\cf3 \
			\cf5 var\cf3  msg;\
			\cf5 var\cf3  time = 0, lastTime = 0;\
			while( \{ time.notNil \}, \{\
				#time, msg = \cf6 this\cf3 .readLine;\
				if ( time.notNil )\{\
					\cf2 //if ( lastTime.isNil ) \{ lastTime = time \};\cf3 \
					(time - lastTime).wait;\
					targetaddr.sendMsg( *msg[0].asString );\
					if(\cf10 ~recOSC\cf3 , \{\cf4 NetAddr\cf3 (\cf7 "localhost"\cf3 , \cf4 NetAddr\cf3 .langPort).sendMsg( targetaddr.ip, *msg[0].asString ) \});\
					\cf2 //msg[0].postln;\cf3 \
					\cf2 //msg[0].class.postln;\cf3 \
					\cf2 //msg[0].asString;\cf3 \
					lastTime = time;\
				\}\
	\});\
\
	\}, clock);\
	\
		\},\{\
			\
		playTask = \cf4 Task\cf3 (\{ \cf2 // midi file\cf3 \
			\cf5 var\cf3  msg, val;\
			\cf5 var\cf3  time = 0, lastTime = 0;\
			\cf5 var\cf3  midiCC, i= 0;\
			midiCC= midi.ccEvents;\
			\cf2 //"midi play task".postln;\cf3 \
			\cf2 //midiDict.postln;\cf3 \
			while( \{ midiCC[i].notNil \}, \{\
				#time, msg = [midiCC[i][1], [midiCC[i][4], ((midiCC[i][5])/100)*127]];\
				if ( time.notNil )\{\
					(time - lastTime).wait;\
					\cf2 //midiDict[msg[0]].postln;\cf3 \
					if(midiDict[msg[0]].notNil, \{\
						targetaddr.sendMsg( midiDict[msg[0]]++(msg[1].asString));\
						\cf2 //[time, ( midiDict[msg[0]]++(msg[1].asString))].postln;\cf3 \
						\cf2 //( midiDict[msg[0]]++(msg[1].asString)).postln; //VERBOSE\cf3 \
						if(\cf10 ~recOSC\cf3 , \{\
							\cf4 NetAddr\cf3 (\cf7 "localhost"\cf3 , \cf4 NetAddr\cf3 .langPort).sendMsg( targetaddr.ip,  midiDict[msg[0]]++(msg[1].asString) ) \
						\});\
					\});\
					\cf2 //msg[0].postln;\cf3 \
					\cf2 //msg[0].class.postln;\cf3 \
					\cf2 //msg[0].asString;\cf3 \
					lastTime = time;\
					i= i+1;\
				\}\
	\});\
	\cf7 "end of Midi File"\cf3 .postln;\
\
	\}, clock);		\
			\
		\});\
	\
	\
	\}\
	\
\
\cf2 /*\
		readLine\{ |update=true|\
		var dt,line,data;\
		var oldid;\
		var oldTime = curTime;\
		oldid = reader.curid;\
		line = reader.nextInterpret;\
\
		if ( line.isNil )\{\
			"At end of data".postln;\
			if(doneFunc.isNil.not, \{ \{doneFunc.value \}.defer;\});\
			^nil;\
		\};\
		curTime = line.first;\
		if ( update )\{\
			targetaddr.sendMsg( *line.copyToEnd( 1 )[0].asString );\
		\};\
		dt = curTime - oldTime;\
		^dt;\
	\}\
	*/\cf3 \
	readLine\{ \cf5 |update=true|\cf3 \
		\cf5 var\cf3  line,data;\
		\cf5 var\cf3  oldid;\
		oldid = reader.curid;\
		line = reader.nextInterpret;\
		\cf2 //	line.postcs;\cf3 \
		\cf2 // header may have changed:\cf3 \
		\cf2 //	if ( oldid != reader.curid )\{\cf3 \
		\cf2 //		this.readHeader;\cf3 \
		\cf2 //	\};\cf3 \
		if ( line.isNil )\{\
			\cf7 "At end of data"\cf3 .postln;\
			if(doneFunc.isNil.not, \{ \{doneFunc.value \}.defer;\});\
			^[\cf8 nil\cf3 , \cf8 nil\cf3 ];\
		\};\
		curTime = line.first;\
		^[curTime, line.copyToEnd( 1 )];\
	\}\
	\
\
\
	play\{ \cf5 |clock|\cf3 \
		playTask.start( clock );\
	\}\
\
	pause\{\
		playTask.pause;\
	\}\
\
	resume\{\
		playTask.resume;\
	\}\
\
	stop\{\
		playTask.stop;\
		\cf6 this\cf3 .reset;\
	\}\
\
	reset\{\
		curTime = 0;\
		reader.reset;\
\cf2 //		this.readHeader;\cf3 \
		playTask.reset;\
	\}\
\
	close\{\
		playTask.stop;\
		if(reader.notNil, \{ reader.close; \});\
	\}\
\
	convertToMIDIFile\{\cf5 |outputFile|\cf3 \
		\cf5 var\cf3  msg, oscMsg, ccnum, key, val, m;\
		\cf5 var\cf3  time = 0;\
		midiDict= \cf4 Dictionary\cf3 .new;\
		midiDict.putPairs([\cf7 "SR1"\cf3 , 21, \cf7 "SR2"\cf3 , 22, \cf7 "SR3"\cf3 , 23, \cf7 "SR4"\cf3 , 24, \cf7 "SR5"\cf3 , 25, \cf7 "SR6"\cf3 , 26, \cf7 "SR7"\cf3 , 27, \cf7 "SR8"\cf3 , 28, \cf7 "SR9"\cf3 , 29, \cf7 "BRK"\cf3 , 30, \cf7 "RL1"\cf3 , 41, \cf7 "RL2"\cf3 , 42, \cf7 "RL3"\cf3 , 43, \cf7 "RL4"\cf3 , 44, \cf7 "RL5"\cf3 , 45, \cf7 "RL6"\cf3 , 46, \cf7 "RL7"\cf3 , 47, \cf7 "RL8"\cf3 , 48, \cf7 "RL9"\cf3 , 49]);\
		if(mid == \cf8 false\cf3 , \{\
			m = \cf4 SimpleMIDIFile\cf3 (outputFile);\
			m.init1(2, 120, \cf7 "4/4"\cf3  );\
			m.timeMode = \cf9 \\seconds\cf3 ;\
			\cf2 //m.division= 96;\cf3 \
			while( \{ time.notNil \}, \{\
				#time, msg = \cf6 this\cf3 .readLine;\
				if ( time.notNil )\{\
					oscMsg= msg[0].asString;\
					key= oscMsg[0]++oscMsg[1]++oscMsg[2];\
					ccnum= midiDict[key];\
					val= oscMsg.copyRange(3, (oscMsg.size-1));\
					val= ((val.asInteger/127)*100).floor;\
					m.addCC( ccnum, val, time, track:1);\
					\cf2 //[ ccnum, key, val, time].postln;\cf3 \
				\}\
			\});\
			\cf2 //m.adjustEndOfTrack;\cf3 \
			m.ccEvents.postln;\
			m.write;\
		\}, \
		\{\cf7 "input file is already MIDI!"\cf3 .postln\});\
	\}\
\
		\cf2 /*\
	goToTime\{ |newtime|\
		var line,oldid;\
		if ( deltaT == 0 )\{\
			deltaT = this.readLine;\
		\};\
		line = floor( newtime / deltaT );\
		curTime = line * deltaT;\
		// assuming dt is constant.\
\
		if ( fileClass == MultiFilePlayer )\{\
			oldid = reader.curid;\
			reader.goToLine( line.asInteger );\
			// header may have changed:\
			if ( oldid != reader.curid )\{\
				this.readHeader;\
			\};\
		\}\{\
			reader.goToLine( line.asInteger );\
		\};\
	\}\
*/\cf3 \
\
\cf2 /*\
	readHeader\{\
		var spec,playset,playids;\
		var playslots;\
		var header;\
\
		playnodes = Dictionary.new;\
\
		header = reader.readHeader(hs:2);\
		spec = header[0].last;\
		if ( spec.notNil, \{\
			network.setSpec( spec );\
			// if spec was not local, it may be included in the tar-ball\
			if ( network.spec.isNil )\{\
				reader.extractFromTar( spec ++ ".spec" );\
				network.spec.fromFileName( reader.pathDir +/+ spec );\
			\};\
		\});\
\
		playslots = header[1].drop(1).collect\{ |it| it.interpret \};\
\
		if ( fileClass == TabFilePlayer )\{\
			// backwards compatibility (there was an extra tab written at the end)\
			playslots = playslots.drop(-1);\
			hasExtraTab = true;\
		\};\
\
		if ( playslots.first == "time" )\{\
			// date stamps in the first column:\
			playslots.drop(1);\
			hasStamp = true;\
		\};\
\
		playset = Set.new;\
		playids = playslots.collect\{ |it| it.first \}.do\{\
			|it,i| playset.add( it );\
		\};\
		playset.do\{ |it|\
			network.addExpected( it );\
			playnodes.put( it, Array.new )\
		\};\
		playids.do\{ |it,i|\
			playnodes.put( it, playnodes[it].add( i ) )\
		\};\
	\}\
*/\cf3 \
\}\
\
\cf4 OSCFileLogPlotter\cf3 \{\
	\cf5 var\cf3  <reader;\
\
\cf2 //	var <timeMap;\cf3 \
	\cf5 var\cf3  <curTime=0;\
\cf2 //	var <deltaT=0;\cf3 \
\
	\cf5 var\cf3  <fileClass;\
	\cf5 var\cf3  <hasExtraTab = \cf8 false\cf3 ;\
\
	\cf5 var\cf3  <targetaddr;\
	\
	\cf5 var\cf3  <doneFunc;\
	\cf5 var\cf3  <timesList;\
	\cf5 var\cf3  <valsList;\
	\cf5 var\cf3  <keysList;\
	\cf5 var\cf3  <duration;\
	\cf5 var\cf3  <file;\
	\cf5 var\cf3  <times, <vals, <keys;\
	\cf5 var\cf3  <timesInSecs;\
	\cf5 var\cf3  <keysDict;\
	\cf2 // v 2\cf3 \
	\cf5 var\cf3  <>sfView, <sfDuration;\
	\cf5 var\cf3  <>plotChans;\
	\cf5 var\cf3  w, scroll;\
	\cf5 var\cf3  chanSelButs;\
	\cf2 //colors\cf3 \
	\cf5 var\cf3  pointClrs, lineClrs;\
	\cf2 //=== integrating ===\cf3 \
	\cf2 //gui\cf3 \
	\cf5 var\cf3  s, tabs, sfTab, playBut;\
	\cf2 //soundfile\cf3 \
	\cf5 var\cf3  sfNumChannels, loadSoundFile, zoom;\
	\cf5 var\cf3  buffer, synth;\
	\cf5 var\cf3  sfDur, sfNumFrames, playSoundTask, playPoint1, playPoint2;	\
	\cf5 var\cf3  oscFilePlayer;\
	\cf5 var\cf3  oscPlayTask;\
	\cf5 var\cf3  playCursorTask, pBus;\
	\cf5 var\cf3  timeCursorSecs= 0;\
	\cf5 var\cf3  timeCursorFrames= 0;\
		\
	\cf5 var\cf3  getPoint, move;\
\
\
\
	*new\{ \cf5 |fn,addr, done|\cf3 \
		^\cf6 super\cf3 .new.init( fn, addr, done );\
	\}\
\
	init\{ \cf5 |fn,addr, done|\cf3 \
		targetaddr = addr;\
		doneFunc= done;\
		timesList= \cf4 List\cf3 .new;\
		valsList= \cf4 List\cf3 .new;\
		keysList= \cf4 List\cf3 .new;\
		file= fn;\
		\cf6 this\cf3 .checkFileClass( fn );\
		pointClrs= [\cf4 Color\cf3 .magenta, \cf4 Color\cf3 .cyan, \cf4 Color\cf3 .yellow];\
		lineClrs= [\cf4 Color\cf3 .red, \cf4 Color\cf3 .new255(238, 130, 238), \cf4 Color\cf3 .new255(255, 140, 0)];\
		chanSelButs= \cf4 List\cf3 .new;\
		s= \cf4 Server\cf3 .default;\
		plotChans= \cf4 List\cf3 .new;\
		zoom= 60;\
		\
		\cf6 this\cf3 .open2( fn );\
		\cf2 //this.plot2( keysDict );\cf3 \
		\
		\cf2 //for every oscscore a tab, soundfile in background, on its own tab\cf3 \
		\
		w= \cf4 Window\cf3 (\cf7 "plot"\cf3 , \cf4 Rect\cf3 (0, 0, 800, 400)).front;\
		w.view.keyDownAction = \{\cf5 |view, char, mod, uni, key|\cf3 \
			\cf2 //[view, char, mod, uni, key].postln;\cf3 \
			case \{char == $1\} \{ if(chanSelButs[0].isNil.not, \{chanSelButs[0].doAction\}); \}\
				\{char == $2\} \{ if(chanSelButs[1].isNil.not, \{chanSelButs[1].doAction\}); \}\
				\{char == $3\} \{ if(chanSelButs[2].isNil.not, \{chanSelButs[2].doAction\}); \}\
				\{char == $4\} \{ if(chanSelButs[3].isNil.not, \{chanSelButs[3].doAction\}); \}\
				\{char == $5\} \{ if(chanSelButs[4].isNil.not, \{chanSelButs[4].doAction\}); \}\
				\{char == $ \} \{ playBut.valueAction_((playBut.value+1).wrap(0, 1)) \};\
				\
			\};\
		\cf2 //tabs= TabbedView2.new(w, Rect(0, 20, 780, 150));\cf3 \
		\cf2 //tabs.backgrounds_([Color.clear,Color.clear,Color.clear,Color.clear]);\cf3 \
		\cf2 //tabs.unfocusedColors_([Color.clear,Color.clear,Color.clear]);\cf3 \
		scroll= \cf4 ScrollView\cf3 (w, \cf4 Rect\cf3 (0, 20, 780, 150));\
		\cf2 //sfTab= tabs.add("sf", scroll: true).unfocusAction= \{|v| v.background_(Color.clear)\};\cf3 \
		\cf2 //scroll= tabs.add(keysList[0], 0, scroll: true).background_(Color.clear);\cf3 \
		\cf2 //in keysDict.keysDo(|key| this.plotOSC(it, tabs); ....\cf3 \
		\cf2 //..save those in dict too???\cf3 \
		\
		\cf2 //sfview not on scroll, not u.front but tab focus\cf3 \
		\
		\cf2 //create instances of \cf3 \
		keysDict.postln;\
		keysDict.keysValuesDo(\{\cf5 |key, vals, i|\cf3 \
			plotChans.add(\cf4 OSCScorePlotChannel\cf3 .new(file, targetaddr, key, vals, scroll, \cf6 this\cf3 , i) );\
			chanSelButs.add(\cf4 Button\cf3 (w, \cf4 Rect\cf3 (50*i, 0, 50, 20)).states_([[key, \cf4 Color\cf3 .black, pointClrs[i]]])\
			.action_(\{\
				plotChans[i].u.front; \
				plotChans.do(\{\cf5 |it, i|\cf3  \
					if(it.key!=key, \
						\{it.alpha= 0.5; it.u.refresh; \}, \
						\{it.alpha= 1; it.u.refresh;\}); \
					\});\
				\});\
				);\
			\});\
		\
		\cf4 Button\cf3 (w, \cf4 Rect\cf3 (0, 170, 50, 20))\
		.canFocus_(\cf8 false\cf3 )\
		.states_([[\cf7 "open sf"\cf3 ]])\
		.action_(\{ \cf5 |view, x, y, mod|\cf3 \
			\cf4 Dialog\cf3 .getPaths(\{ \cf5 arg\cf3  paths; \cf2 //load sound\cf3 \
					\cf6 this\cf3 .loadSoundFile(paths[0]);\
				\});\
		\})\
		.canReceiveDragHandler_(\cf8 true\cf3 )\
		.receiveDragHandler_(\{\cf5 |view|\cf3 \
			\cf5 var\cf3  values, paths;\
			paths= \cf4 View\cf3 .currentDrag;\
			paths= [paths];\
			loadSoundFile.value(paths[0]);\
		\});\
\
		\
		\cf2 // play an array of oscPlayTasks, only one cursorTask\cf3 \
		playBut= \cf4 Button\cf3 (w, \cf4 Rect\cf3 (120, 170, 50, 20))\
		.canFocus_(\cf8 false\cf3 )\
		.states_([[\cf7 "play"\cf3 ], [\cf7 "stop"\cf3 ]])\
		.action_(\{\cf5 |v|\cf3 \
			timeCursorSecs= \cf6 this\cf3 .timeCursorPosSecs;\
			if(v.value == 1, \{\
				if(sfView.isNil.not, \{\
					\
					if (buffer.numChannels == 1, \{\
						synth= \cf4 Synth\cf3 (\cf9 \\oscSoundFile_1\cf3 , [\cf9 \\bufnum\cf3 , buffer, \cf9 \\pbus\cf3 , pBus, \cf9 \\start\cf3 , (timeCursorSecs/sfDuration)*buffer.numFrames])\
					\},\{\
						synth= \cf4 Synth\cf3 (\cf9 \\oscSoundFile_2\cf3 , [\cf9 \\bufnum\cf3 , buffer, \cf9 \\pbus\cf3 , pBus, \cf9 \\start\cf3 , (timeCursorSecs/sfDuration)*buffer.numFrames])\
					\});\
					playCursorTask.play(\cf4 AppClock\cf3 );\
					\cf7 "file"\cf3 .postln;\
					file.postln;\
					plotChans.do(\{\cf5 |it|\cf3  it.oscPlayTask.play(\cf4 SystemClock\cf3 ); \});\
					targetaddr.postln;\
					\cf2 //oscFilePlayer= OSCFileLogPlayer.new(file, targetaddr);// play old file\cf3 \
					\cf2 //oscFilePlayer.play;\cf3 \
					\
					\},\{\
					plotChans.do(\{\cf5 |it|\cf3  it.playSoundTask.play(\cf4 AppClock\cf3 ) \});\
					oscFilePlayer= \cf4 OSCFileLogPlayer\cf3 .new(file, targetaddr);\cf2 // play old file\cf3 \
					oscFilePlayer.play;\
					\});\
					\},\{\
					if(sfView.isNil.not, \{\
						playCursorTask.stop;\
						playCursorTask.reset;\
						sfView.timeCursorPosition_((timeCursorSecs/sfDuration)*buffer.numFrames);\
						synth.free;\
						plotChans.do(\{\cf5 |it|\cf3  it.oscPlayTask.stop; \});\
						plotChans.do(\{\cf5 |it|\cf3  it.oscPlayTask.reset; \});\
						\},\{\
						plotChans.do(\{\cf5 |it|\cf3  it.playSoundTask.stop \});\
						plotChans.do(\{\cf5 |it|\cf3  it.playSoundTask.reset \});\
						oscFilePlayer.stop;\
						oscFilePlayer.close;\
						\});\
					plotChans.do(\{\cf5 |it|\cf3  it.highlightReset \});\
					plotChans.do(\{\cf5 |it|\cf3  it.u.refresh \});\
					\});\
			\});\
		\
		\cf2 /*\
		EZSlider(w, Rect(180, 170, 450, 20), "zoom", [1, 200, \\lin, zoom].asSpec,\
		\{|ez| zoom= ez.value; \
			plotChans.do(\{|it| \
				it.u.bounds= Rect(0, 0, it.duration * zoom, 127);\
				it.u.refresh; \
			\});\
			sfView.bounds= Rect(0, 0, sfDuration * zoom, 127);\
			//sfView.refresh;\
			scroll.refresh;\
			// phuuuu and then re read the soundfile again....? or use zoom!!!\
			\}\
		);\
		*/\cf3 \
\
	\
		getPoint = \{\cf5 |xx, yy, points|\cf3  \cf2 //check within what circle the mouse is\cf3 \
			\cf5 var\cf3  val;\
			points.do\{\cf5 |p, i|\cf3 \
				if(p.x >= (xx-5), \{\
					if (p.x <= (xx+5), \{\
						if(p.y >= (yy-5), \{\
							if (p.y <= (yy+5), \{ val = p \}); \cf2 //move\cf3 \
						\});\
					\});\
				\});\
			\};\
			val;\
		\};\
\
		\
		playCursorTask= \cf4 Task\cf3 (\{\
			\cf5 var\cf3  value= 0;\
			\cf8 inf\cf3 .do(\{\
				pBus.get(\{\cf5 arg\cf3  v; \
					\cf2 //sfView.timeCursorPosition_( v*buffer.numFrames);\cf3 \
					value= v;\
					\});\
					sfView.timeCursorPosition_(value*buffer.numFrames);\
					plotChans.do(\{\cf5 |it|\cf3  it.highlight(value)\});\
					\cf2 /*\
					points.do(\{|it, i| if(it.x.equalWithPrecision(value*duration, 0.1), \{\
						pointsHighlight[i]= true; \
						pointsHighlight[(i-1).wrap(0, pointsHighlight.size-1)]= false;\
						\});\
					\});\
					*/\cf3 \
					\cf2 //value.postln;\cf3 \
					\cf2 //buffer.numFrames.postln;\cf3 \
					\cf2 //(value*buffer.numFrames).postln;\cf3 \
				0.05.wait;\
				\});\
		\});\
		\
		w.onClose= \{\
			if(buffer.isNil.not, \{ \{buffer.free\}.try \});\
			if(pBus.isNil.not, \{ \{pBus.free\}.try \});\
			\};\
	\}\
	\
	loadSoundFile\{\cf5 |paths|\cf3 \
			\cf5 var\cf3  sf, tabCheck;\
			if (paths.isSoundFile, \{\
				s.waitForBoot\{\
				\cf7 "load sf"\cf3 .postln;\
					if(buffer.isNil.not, \{buffer.free\});\
					if(sfView.isNil.not, \{sfView.remove\});\
					sf= \cf4 SoundFile\cf3 .openRead(paths);\
					\cf2 //sfView= sf.plot(paths[0], scroll, Rect(0, 0, u.bounds.width, 127));\cf3 \
					sfDuration= sf.duration;\
					sfNumChannels= sf.numChannels;\
					sfView= \cf4 SoundFileView\cf3 .new(scroll, \cf4 Rect\cf3 (0, 0, sfDuration*zoom, 180));\
					sfView.soundfile= (sf);\
					sfNumFrames= sf.numFrames;\
					sfView.readFileWithTask(sf, 0, sfNumFrames-1, 256,\{\
						sf.close; sfView.refresh; sfView.postln;\
						\cf2 /*\
						tabs.tabViews.do(\{|it| \
							it.resizeTo(sfView.bounds.width, it.bounds.height) \
							\});\
							*/\cf3 \
						\});\
					sfView.waveColors_(\cf4 Color\cf3 .blue.alpha_(1)!2);\
					sfView.background_(\cf4 Color\cf3 .black.alpha_(1));\
					sfView.timeCursorOn_(\cf8 true\cf3 );\
					sfView.timeCursorColor_(\cf4 Color\cf3 .red);\
					sfView.gridColor_(\cf4 Color\cf3 .grey);\
					buffer= \cf4 Buffer\cf3 .read(s, paths);\
					if(pBus.isNil, \{ pBus= \cf4 Bus\cf3 .control(s, 1); \});\
					\cf2 //StaticText(sfTab, Rect(0, 0, 300, 127)).string_("can u see me???");\cf3 \
					w.front;\
				\};\
			\});		\
		\}	\
	\
	\
\
	checkFileClass\{ \cf5 |fn|\cf3 \
		\cf5 var\cf3  tar,txt;\
		\cf5 var\cf3  path = \cf4 PathName\cf3 (fn);\
		tar = (path.extension == \cf7 "tar"\cf3 );\
		txt = (path.extension == \cf7 "txt"\cf3 );\
		if ( tar )\{\
			fileClass = \cf4 MultiFilePlayer\cf3 ;\
		\}\{\
			if ( txt )\{\
				fileClass = \cf4 TabFilePlayer\cf3 ;\
			\}\{\
				fileClass = \cf4 MultiFilePlayer\cf3 ;\
			\}\
		\};\
		\cf2 //		[tar, txt, fileClass].postln;\cf3 \
	\}\
\
	open\{ \cf5 |fn|\cf3 \
		\cf5 var\cf3  msg;\
		\cf5 var\cf3  time = 0, lastTime = \cf8 nil\cf3 ;\
		\cf5 var\cf3  keysCheck;\
		\
		\cf2 //if ( playTask.notNil )\{ playTask.stop; \};\cf3 \
		if ( reader.notNil )\{ reader.close; \};\
\
		reader = fileClass.new( fn );\
		\cf6 this\cf3 .checkForMultipleKeys.postln;\
\
			while( \{ time.notNil \}, \{\
				#time, msg = \cf6 this\cf3 .readLine;\
				if ( time.notNil )\{\
					if ( lastTime.isNil ) \{ lastTime = time \};\
					\cf2 //(time - lastTime).wait;\cf3 \
					\cf2 //targetaddr.sendMsg( *msg[0].asString );\cf3 \
					timesList.add(time);\
					keysList.add(*msg[0].asString.copyFromStart(2));\
					valsList.add(*msg[0].asString.copyToEnd(3).interpret);\
					\cf2 //msg[0].asString.copyToEnd(3).postln;\cf3 \
					\cf2 //msg[0].class.postln;\cf3 \
					\cf2 //msg[0].asString;\cf3 \
					lastTime = time;\
				\}\
			\});\
			\
		reader.close;\
	\
	\}\
	\
	open2\{ \cf5 |fn|\cf3 \
		\cf5 var\cf3  msg;\
		\cf5 var\cf3  time = 0, lastTime = \cf8 nil\cf3 ;\
		\cf5 var\cf3  keysCheck;\
\
		keysDict= \cf4 Dictionary\cf3 .new;\
		\
		\cf2 //if ( playTask.notNil )\{ playTask.stop; \};\cf3 \
		if ( reader.notNil )\{ reader.close; \};\
\
		reader = fileClass.new( fn );\
		keysCheck= \cf6 this\cf3 .checkForMultipleKeys.postln;\
		(\cf7 "Keys:"\cf3 +keysCheck).postln;\
		\
		keysCheck.do(\{\cf5 |it|\cf3 \
			keysDict.put(it, \cf4 List\cf3 .new);\
		\});\
		\
		\cf2 //separate keys\cf3 \
			while( \{ time.notNil \}, \{\
				#time, msg = \cf6 this\cf3 .readLine;\
				if ( time.notNil )\{\
					if ( lastTime.isNil ) \{ lastTime = time \};\
					keysDict[msg[0].asString.copyFromStart(2)].add(\cf4 Point\cf3 (time, msg[0].asString.copyToEnd(3).interpret));\
						\cf2 //keysList.add(*msg[0].asString.copyFromStart(2));\cf3 \
						\cf2 //timesList.add(time);\cf3 \
						\cf2 //valsList.add(*msg[0].asString.copyToEnd(3).interpret);\cf3 \
\
						lastTime = time;\
				\}\
			\});\
		\
		reader.close;\
		\
		keysDict.postln;\
	\}\
	\
	openAdditionalFile\{ \cf5 |fn|\cf3 \
		\cf5 var\cf3  msg;\
		\cf5 var\cf3  time = 0, lastTime = \cf8 nil\cf3 ;\
		\cf5 var\cf3  keysCheck;\
		\cf5 var\cf3  key, pointsList;\
		\
		pointsList= \cf4 List\cf3 .new;\
\
		if ( reader.notNil )\{ reader.close; \};\
\
		reader = fileClass.new( fn );\
		keysCheck= \cf6 this\cf3 .checkForMultipleKeys.postln;\
		(\cf7 "Keys:"\cf3 +keysCheck).postln;\
		\
		keysCheck.do(\{\cf5 |it|\cf3  if (keysDict.keys.includes(it), \{ \
			\cf7 "WARNING: the key -"\cf3 +it+\cf7 "- already exists!"\cf3  \}); \});\
		\
		keysCheck.do(\{\cf5 |it|\cf3 \
			keysDict.put(it, \cf4 List\cf3 .new); \cf2 // hmm could erase old values..\cf3 \
		\});\
		\
		\cf2 //separate keys\cf3 \
			while( \{ time.notNil \}, \{\
				#time, msg = \cf6 this\cf3 .readLine;\
				if ( time.notNil )\{\
					if ( lastTime.isNil ) \{ lastTime = time \};\
					keysDict[msg[0].asString.copyFromStart(2)].add(\cf4 Point\cf3 (time, msg[0].asString.copyToEnd(3).interpret));\
\
						\cf2 // but what if it has several keys?\cf3 \
						key= msg[0].asString.copyFromStart(2);\
						pointsList.add(\cf4 Point\cf3 (time, msg[0].asString.copyToEnd(3).interpret));\
\
						lastTime = time;\
				\}\
			\});\
		\
		reader.close;\
		\
			plotChans.add(\cf4 OSCScorePlotChannel\cf3 .new(fn, targetaddr, key, pointsList, scroll, \cf6 this\cf3 , plotChans.size) );\
			chanSelButs.add(\cf4 Button\cf3 (w, \cf4 Rect\cf3 (50*(plotChans.size-1), 0, 50, 20)).states_([[key, \cf4 Color\cf3 .black, pointClrs[(plotChans.size-1).copy]]])\
			.action_(\{\
				plotChans[(plotChans.size-1).copy].u.front;\
				plotChans.do(\{\cf5 |it, i|\cf3  if(it.key!=key, \
					\{it.alpha= 0.5; it.u.refresh; \}, \
					\{it.alpha= 1; it.u.refresh; \});\
					\});\
				\});\
			);\
		\
		keysDict.keys.postln;\
	\}\
	\
	checkForMultipleKeys\{ \
			\cf5 var\cf3  msg;\
			\cf5 var\cf3  time = 0, keyCheckList;\
			keyCheckList= \cf4 List\cf3 .new;\
			while( \{ time.notNil \}, \{\
				#time, msg = \cf6 this\cf3 .readLine;\
				if ( time.notNil )\{\
					keyCheckList.add(*msg[0].asString.copyFromStart(2));\
					\}\
				\});\
			keyCheckList= keyCheckList.removeEqualDups;\
			^keyCheckList;\
	\}\
	\
	separateKeys\{\cf5 |keys|\cf3 \
		\
		^[]\
	\}\
	\
	readLine\{ \cf5 |update=true|\cf3 \
		\cf5 var\cf3  line,data;\
		\cf5 var\cf3  oldid;\
		oldid = reader.curid;\
		line = reader.nextInterpret;\
\
		if ( line.isNil )\{\
			\cf7 "At end of data"\cf3 .postln;\
			duration= timesList.last;\
			\cf2 //if(doneFunc.isNil.not, \{ \{doneFunc.value \}.defer;\});\cf3 \
			\
			^[\cf8 nil\cf3 , \cf8 nil\cf3 ];\
		\};\
		curTime = line.first;\
		^[curTime, line.copyToEnd( 1 )];\
	\}\
	\
\
\
	play\{ \cf5 |clock|\cf3 \
		\cf2 //playTask.start( clock );\cf3 \
	\}\
\
	pause\{\
\
	\}\
\
	resume\{\
		\
	\}\
\
	stop\{\
		\cf6 this\cf3 .reset;\
	\}\
\
	reset\{\
		curTime = 0;\
		reader.reset;\
	\}\
\
	close\{\
		reader.close;\
	\}\
	\
		writeFileOld \{ \cf5 |fn |\cf3 \
		\cf5 var\cf3  timelogfile;\
		\cf5 var\cf3  prevValue;\
		\cf5 var\cf3  filename = fn ++\cf7 ".txt"\cf3 ;\
		\
		timelogfile = \cf4 MultiFileWriter\cf3 .new( filename ).zipSingle_( \cf8 false\cf3  ).tarBundle_( \cf8 false\cf3  );\
		timelogfile.open;\
		timesInSecs.do(\{\cf5 |it, i|\cf3 \
					if(vals[i]!=prevValue, \{ \cf2 // clean up duplicates as well\cf3 \
						\cf2 //this.writeLine( it, (keys[i]++points[i].y).asSymbol ) //twice??\cf3 \
						timelogfile.writeLine( [it, (keys[i]++vals[i]).asCompileString ] );\
					\});\
					prevValue= vals[i];\
			\});\
		timelogfile.close;\
	\}\
	\
		writeFile \{ \cf5 |fn |\cf3 \
		\cf5 var\cf3  timelogfile;\
		\cf5 var\cf3  prevValue;\
		\cf5 var\cf3  filename = fn ++\cf7 ".txt"\cf3 ;\
		\
		timelogfile = \cf4 MultiFileWriter\cf3 .new( filename ).zipSingle_( \cf8 false\cf3  ).tarBundle_( \cf8 false\cf3  );\
		timelogfile.open;\
		timesInSecs.do(\{\cf5 |it, i|\cf3 \
					if(vals[i]!=prevValue, \{ \cf2 // clean up duplicates as well\cf3 \
						\cf2 //this.writeLine( it, (keys[i]++points[i].y).asSymbol ) //twice??\cf3 \
						timelogfile.writeLine( [it, (keys[i]++vals[i]).asCompileString ] );\
					\});\
					prevValue= vals[i];\
			\});\
		timelogfile.close;\
	\}\
\cf2 /*\
	writeLine\{ |time,tag,data|\
        timelogfile.writeLine( [time, tag.asCompileString ] ++ data.collect\{ |it| it.asCompileString \} );\
	\}\
	*/\cf3 \
	\
	mergeFiles\{ \cf5 |arrayOfFiles|\cf3  \cf2 //don't use\cf3 \
		\cf5 var\cf3  merge, sorted;\
		arrayOfFiles.do(\{\cf5 |it|\cf3 \
			merge= it++merge;\
		\});\
		sorted= merge.quickSort \{ \cf5 |n,m|\cf3  n[0] <= m[0] \} ;\
		^sorted;\
	\
	\}\
\
	mergeFilesAndWrite\{ \cf5 |fn |\cf3 \
		\cf5 var\cf3  timelogfile;\
		\cf5 var\cf3  prevValue;\
		\cf5 var\cf3  filename = fn ++\cf7 ".txt"\cf3 ;\
		\cf5 var\cf3  arraysToMerge, merge, sorted;\
		\
		\cf2 //merge\cf3 \
		arraysToMerge= plotChans.collect(\{ \cf5 |it|\cf3 \
			it.timesInSecs.collect(\{\cf5 |time, i|\cf3  [time, it.key, it.vals[i]]\});\
		\});\
		\
		arraysToMerge.do(\{\cf5 |it|\cf3 \
			merge= it++merge;\
		\});\
		\cf2 //sort\cf3 \
		sorted= merge.quickSort \{ \cf5 |n,m|\cf3  n[0] <= m[0] \} ;\
\
\
		\cf2 //write\cf3 \
		timelogfile = \cf4 MultiFileWriter\cf3 .new( filename ).zipSingle_( \cf8 false\cf3  ).tarBundle_( \cf8 false\cf3  );\
		timelogfile.open;\
		sorted.do(\{\cf5 |it, i|\cf3 \
					if((it[1]++it[2])!=prevValue, \{ \cf2 // clean up duplicates as well\cf3 \
						\cf2 //this.writeLine( it, (keys[i]++points[i].y).asSymbol ) //twice??\cf3 \
						timelogfile.writeLine( [it[0], (it[1]++it[2]).asCompileString ] );\
					\});\
					prevValue= (it[1]++it[2]);\
			\});\
		timelogfile.close;\
	\
	\}\
	\
		mergeFilesAndWritePlus65\{ \cf5 |fn |\cf3 \
		\cf5 var\cf3  timelogfile;\
		\cf5 var\cf3  prevValue;\
		\cf5 var\cf3  filename = fn ++\cf7 ".txt"\cf3 ;\
		\cf5 var\cf3  arraysToMerge, merge, sorted;\
		\
		\cf2 //merge\cf3 \
		arraysToMerge= plotChans.collect(\{ \cf5 |it|\cf3 \
			it.timesInSecs.collect(\{\cf5 |time, i|\cf3  [time, it.key, it.vals[i]]\});\
		\});\
		\
		arraysToMerge.do(\{\cf5 |it|\cf3 \
			merge= it++merge;\
		\});\
		\
		\cf2 //sort\cf3 \
		sorted= merge.quickSort \{ \cf5 |n,m|\cf3  n[0] <= m[0] \} ;\
\
\
		\cf2 //write\cf3 \
		timelogfile = \cf4 MultiFileWriter\cf3 .new( filename ).zipSingle_( \cf8 false\cf3  ).tarBundle_( \cf8 false\cf3  );\
		timelogfile.open;\
		sorted.do(\{\cf5 |it, i|\cf3 \
					if((it[1]++it[2])!=prevValue, \{ \cf2 // clean up duplicates as well\cf3 \
						\cf2 //this.writeLine( it, (keys[i]++points[i].y).asSymbol ) //twice??\cf3 \
						if(it[1]==\cf7 "SR2"\cf3 , \{it[2]= it[2]+65\});\
						if(it[1]==\cf7 "SR1"\cf3 , \{it[2]= it[2]+25\});\
						timelogfile.writeLine( [it[0], (it[1]++it[2]).asCompileString ] );\
					\});\
					prevValue= (it[1]++it[2]);\
			\});\
		timelogfile.close;\
	\
	\}\
	\
	timeCursorPosSecs\{\
		\cf5 var\cf3  pos;\
		pos= (sfView.timeCursorPosition/sfView.numFrames)*sfDuration;\
		plotChans.do(\{\cf5 |it|\cf3  it.timeCursorSecs= pos \});\
		^pos;\
	\}\
\
	\
\}\
\
\cf4 OSCScorePlotChannel\cf3 \{\
\
\
	\cf5 var\cf3  <fileClass;\
	\cf5 var\cf3  <hasStamp = \cf8 false\cf3 ;\
	\cf5 var\cf3  <hasExtraTab = \cf8 false\cf3 ;\
\
	\cf5 var\cf3  <targetaddr;\
	\
	\cf5 var\cf3  <doneFunc;\
	\cf5 var\cf3  <timesList;\
	\cf5 var\cf3  <valsList;\
	\cf5 var\cf3  <duration;\
	\cf5 var\cf3  <file;\
	\cf5 var\cf3  <key;\
	\cf5 var\cf3  <times, <vals;\
	\cf5 var\cf3  <timesInSecs;\
	\cf5 var\cf3  move;\
	\cf5 var\cf3  getPoint;\
	\
	\cf2 // v 2\cf3 \
	\cf2 // gui\cf3 \
	\cf5 var\cf3  s, mother, <>timeCursorSecs;\
	\cf5 var\cf3  <>u, tabs, <>scroll;\
	\cf5 var\cf3  playPoint1, playPoint2;\
	\cf5 var\cf3  zoom= 60;\
	\cf5 var\cf3  pointClrs, lineClrs, instanceNum;\
	\cf5 var\cf3  <>alpha= 1;\
	\cf2 //points\cf3 \
	\cf5 var\cf3  <points, pointsBwd, pointsFwd, <>pointsHighlight;\
	\cf5 var\cf3  updateBwdFwdPoints;\
	\cf2 //tasks\cf3 \
	\cf5 var\cf3  <>oscPlayTask, <>playSoundTask;\
\
		\
	\
\
	*new\{ \cf5 |fn, addr, ky, pnts, tbs, mum, num|\cf3 \
		^\cf6 super\cf3 .new.init( fn, addr, ky, pnts, tbs, mum, num );\
	\}\
\
	init\{ \cf5 |fn, addr, ky, pnts, tbs, mum, num|\cf3 \
		s= \cf4 Server\cf3 .default;\
		targetaddr = addr;\
		key= ky;\
		timesList= pnts.collect(\{\cf5 |it|\cf3  it.x \});\
		valsList= pnts.collect(\{\cf5 |it|\cf3  it.y \});\
		file= fn;\
		\cf2 //tabs= tbs;\cf3 \
		scroll= tbs;\
		mother= mum;\
		instanceNum= num;\
		\
		\cf2 //this.open2( fn );\cf3 \
		\
		duration= timesList.last;\
		\
		pointClrs= [\cf4 Color\cf3 (1.0, 0.35294117647059, 1.0), \cf4 Color\cf3 .cyan, \cf4 Color\cf3 .yellow];\
		lineClrs= [\cf4 Color\cf3 (1.0, 0.35294117647059, 1.0), \cf4 Color\cf3 .cyan, \cf4 Color\cf3 .new255(255, 140, 0)];\
	\
		\cf2 //scroll= tabs.add(key, 1, scroll: true).unfocusAction= \{|v| v.background_(Color.clear)\};\cf3 \
	\
	\
		u= \cf4 UserView\cf3 (scroll, \cf4 Rect\cf3 (0, 0, duration * zoom, 180))\
		.mouseDownAction_(\{ \cf5 arg\cf3  view,x,y, mod, but, clicks;\
			\cf5 var\cf3  point, pointIndex, newPoint, delmenu;\
			mod.postln;\
			clicks.postln;\
			move.postln;\
			case\
			\{mod == 0 or: \{mod == 256\} \} \{ \cf2 // change the parameters for every move\cf3 \
				move= getPoint.value(x, y, points);\
				mother.sfView.postln;\
				mother.sfView.bounds.width.postln;\
				mother.sfView.numFrames.postln;\
				if(move.isNil.not, \{\cf7 "u hit a point"\cf3 .postln;\});\
				if(mother.sfView.isNil.not and: \{move.isNil\}, \{\
					mother.sfView.timeCursorPosition_((x/mother.sfView.bounds.width)*mother.sfView.numFrames);\
					\cf2 //timeCursorSecs= (sfView.timeCursorPosition/buffer.numFrames)*sfDuration;\cf3 \
					mother.timeCursorPosSecs;\
					\});\
				view.refresh;\
				if (clicks == 2, \{\
				\cf7 "add point??"\cf3 .postln;\
				move= getPoint.value(x, y, points);\
				if (move.isNil, \{ \cf2 // ======  add point ======\cf3 \
					pointIndex= times.indexOfGreaterThan(x/u.bounds.width);\
					times.insert(pointIndex, x/u.bounds.width);\
					timesInSecs.insert(pointIndex, (x/u.bounds.width)*duration);\
					vals.insert(pointIndex, y);\
					points.insert(pointIndex, \cf4 Point\cf3 (x, y));\
					updateBwdFwdPoints.value;\
					pointsHighlight= \cf8 false\cf3 !times.size;\
					view.refresh;\
					\},\
				\{ \cf2 //======================= remove point ========\cf3 \
					\cf2 //move.postln;\cf3 \
					\cf2 //move.class.postln;\cf3 \
				pointIndex= points.indexOfEqual(move);\
				points.removeAt(pointIndex);\
				\cf2 //"gm".postln;\cf3 \
				pointsBwd.removeAt(pointIndex);\
				pointsFwd.removeAt(pointIndex);\
				times.removeAt(pointIndex);\
				vals.removeAt(pointIndex);\
				timesInSecs.removeAt(pointIndex);\
				pointsHighlight= \cf8 false\cf3 !times.size;\
				pointsBwd= times.collect(\{\cf5 |it, i|\cf3  \cf4 Point\cf3 ((it*u.bounds.width).floor(0.001), vals[(i-1).clip(0, vals.size-1)])\});\
				pointsFwd= times.collect(\{\cf5 |it, i|\cf3  \cf4 Point\cf3 (((times[(i+1).clip(0, times.size-1)])*u.bounds.width).floor(0.001), vals[i])\});\
					\});\
				\});\
			\};\
		\})\
		.mouseMoveAction_(\{ \cf5 arg\cf3  view,x,y, mod;\
			\cf5 var\cf3  pointIndex, newPoint;\
			\cf2 //"move".postln;\cf3 \
			move.isNil.not.if(\{ \cf2 // =============== move a point =============\cf3 \
				\cf2 //"move should be something...".postln;\cf3 \
				\cf2 //view.postln;\cf3 \
					move= getPoint.value(x, y, points);\
					newPoint= x @ y;\
					pointIndex= points.indexOfEqual(move);\
					\cf2 //["pointIndex:"+pointIndex, "x:"+x, "y:" +y ].postln;\cf3 \
					if(pointIndex.isNil.not, \{\
						\cf2 //["move point no"+pointIndex, "size:"+points.size].postln;\cf3 \
					case \{ pointIndex==0 \} \{ \cf2 // move first point\cf3 \
							times[pointIndex]= x/u.bounds.width;\
							timesInSecs[pointIndex]= x/u.bounds.width*duration;\
							points.put(pointIndex, newPoint);\
							vals[pointIndex]= y;\
							pointsBwd[pointIndex].x_(newPoint.x);\
							pointsBwd[pointIndex+1].y_(newPoint.y);\
							pointsFwd[pointIndex].y_(newPoint.y);\
							\cf2 //pointsFwd[pointIndex-1].x_(newPoint.x);\cf3 \
							\cf2 //"moving a point".postln;\cf3 \
							\
							u.refresh;			\
							\}\
						\{ pointIndex==(points.size-1) \} \{ \cf2 //move last point\cf3 \
							[\cf7 "x:"\cf3 +x, \cf7 "y"\cf3 +y].postln;\
							if(x > u.bounds.width, \{u.resizeTo(x, u.bounds.height)\});\
							\cf2 //duration= !!!!!\cf3 \
							times[pointIndex]= x/u.bounds.width;\
							timesInSecs[pointIndex]= x/u.bounds.width*duration; \cf2 // !!!!!\cf3 \
							points.put(pointIndex, newPoint);\
							vals[pointIndex]= y;\
							pointsBwd[pointIndex].x_(newPoint.x);\
							pointsBwd[pointIndex].y_(newPoint.y);\
							pointsFwd[pointIndex].y_(newPoint.y);\
							pointsFwd[pointIndex-1].x_(newPoint.x);\
							u.refresh;\
							\}\
						\{  x > points[pointIndex-1].x and: \{x < points[pointIndex+1].x\} \} \{\
							\cf2 // move any other point\cf3 \
							\cf2 //["move point no"+pointIndex, "size:"+points.size].postln;\cf3 \
							times[pointIndex]= x/u.bounds.width;\
							timesInSecs[pointIndex]= x/u.bounds.width*duration;\
							points.put(pointIndex, newPoint);\
							vals[pointIndex]= y;\
							pointsBwd[pointIndex].x_(newPoint.x);\
							pointsBwd[pointIndex+1].y_(newPoint.y);\
							pointsFwd[pointIndex].y_(newPoint.y);\
							pointsFwd[pointIndex-1].x_(newPoint.x);\
							\cf2 //"moving a point".postln;\cf3 \
							u.refresh;	\
						\};\
					\});\
			\});\
		\})\
		.mouseUpAction_(\{ \cf5 arg\cf3  view,x,y, mod;\
		\cf2 //move= nil;\cf3 \
		\cf2 //u.refresh;\cf3 \
		\});\
		\cf2 //.background_(Color.white.alpha_(0.2));\cf3 \
		\cf2 //if(GUI.scheme==QtGUI, \{ u.alwaysOnTop= true; \});\cf3 \
		\
\
		\
		playPoint1= \cf4 Point\cf3 (u.bounds.left, 0);\
		playPoint2= \cf4 Point\cf3 (u.bounds.left, u.bounds.height);\
		\
		times= (timesList / duration).asArray;\
		timesInSecs= timesList.asArray;\
		vals= valsList.asArray;\
		\cf2 //keys= keysList.asArray;\cf3 \
		\
		points= times.collect(\{\cf5 |it, i|\cf3  \cf4 Point\cf3 ((it*u.bounds.width).floor(0.001), vals[i])\});\
		pointsBwd= times.collect(\{\cf5 |it, i|\cf3  \cf4 Point\cf3 ((it*u.bounds.width).floor(0.001), vals[(i-1).clip(0, vals.size-1)])\});\
		pointsFwd= times.collect(\{\cf5 |it, i|\cf3  \cf4 Point\cf3 (((times[(i+1).clip(0, times.size-1)])*u.bounds.width).floor(0.001), vals[i])\});\
\
		pointsHighlight= \cf8 false\cf3 !times.size;\
		\
		\cf2 //u.animate= true;\cf3 \
		\cf2 //u.frameRate= 15;\cf3 \
\
		u.drawFunc= \{\cf5 |uview|\cf3 \
\
			\cf2 //Pen.stringAtPoint(keys[i].asString, 20@20, Font("Monaco", 25));\cf3 \
			\
			\cf4 Pen\cf3 .strokeColor = lineClrs[instanceNum].alpha_(alpha);\
			\cf4 Pen\cf3 .fillColor= pointClrs[instanceNum].alpha_(alpha);\
			\cf4 Pen\cf3 .moveTo(points[0]);\
			\cf4 Pen\cf3 .lineTo(pointsFwd[0]);\
			\cf4 Pen\cf3 .draw(2);\
			\cf4 Pen\cf3 .fillOval(\cf4 Rect\cf3 (points[0].x-5, points[0].y-5, 10, 10));\
			\
			\cf4 Pen\cf3 .moveTo(playPoint1);\
			\cf4 Pen\cf3 .lineTo(playPoint2);\
\
			points.do(\{\cf5 |it, i|\cf3  \
				if(i > 0, \{\
				\
				\cf4 Pen\cf3 .strokeColor = lineClrs[instanceNum].alpha_(alpha);\
				\
				\cf4 Pen\cf3 .moveTo(pointsBwd[i]);\
				\cf4 Pen\cf3 .lineTo(points[i]);\
				\cf4 Pen\cf3 .lineTo(pointsFwd[i]);\
				\cf4 Pen\cf3 .draw(2);\
				\cf4 Pen\cf3 .fillOval(\cf4 Rect\cf3 (it.x-5, it.y-5, 10, 10));\
					if(pointsHighlight[i]==\cf8 true\cf3 , \{\
						\cf4 Pen\cf3 .fillColor= \cf4 Color\cf3 .green;\
						\cf4 Pen\cf3 .fillOval(\cf4 Rect\cf3 (it.x-5, it.y-5, 10, 10));\
						\cf4 Pen\cf3 .fillColor= pointClrs[instanceNum].alpha_(alpha);\
						\});\
				\cf4 Pen\cf3 .strokeColor = \cf4 Color\cf3 .blue.alpha_(alpha);\
				\cf4 Pen\cf3 .stringAtPoint(vals[i].asString, \cf4 Point\cf3 (it.x+2, it.y-17), \cf4 Font\cf3 (\cf7 "Monaco"\cf3 , 9), pointClrs[instanceNum].alpha_(alpha));\
				\});\
				\
				\});\
		\};\
		\
		playSoundTask= \cf4 Task\cf3 \{\
			\cf5 var\cf3  time= 0;\
			while ( \{time<duration\}, \{\
				time= time+0.05;\
				0.05.wait;\
				playPoint1.x_((time/duration)*u.bounds.width);\
				playPoint2.x_((time/duration)*u.bounds.width);\
				\cf2 //sfView.timeCursorPosition_( (time/duration)*sfNumFrames);\cf3 \
			\});\
			\
		\};\
\
		oscPlayTask= \cf4 Task\cf3 (\{\
			\cf5 var\cf3  startIndex= 0, time, lastTime= 0;\
			\
			\cf2 //timeCursor= (sfView.timeCursorPosition/buffer.numFrames)*sfDuration;\cf3 \
			\cf2 //timeCursorSecs= mother.timeCursorPosSecs;\cf3 \
			if(timeCursorSecs > 0, \{\
				startIndex= timesInSecs.indexOfGreaterThan(timeCursorSecs);\
				\cf2 //(timesInSecs[startIndex]-timeCursorSecs).wait;\cf3 \
				\cf2 //lastTime= timesInSecs[startIndex];\cf3 \
				lastTime= timeCursorSecs;\
			\});\
			\
			\cf7 "starting task"\cf3 .postln;\
			timesInSecs.do(\{\cf5 |it, i|\cf3 \
				if( i >= startIndex, \{\
				\cf2 //"starting do".postln;\cf3 \
				\cf2 //("lastTime:"+lastTime.asString).postln;\cf3 \
				\cf2 //("time:"+it.asString).postln;\cf3 \
				(it-lastTime).wait;\
				\cf2 //("value:"+keys[i]++points[i].y).postln;\cf3 \
				targetaddr.sendMsg(key++points[i].y);\
				pointsHighlight[i]= \cf8 true\cf3 ; \
				pointsHighlight[(i-1).wrap(0, pointsHighlight.size-1)]= \cf8 false\cf3 ;\
				\cf2 //\{u.refresh\}.defer;\cf3 \
				\cf2 //("send osc").postln;\cf3 \
				lastTime= it;\
				\});\
			\});\
			\
		\});\
		\
		getPoint = \{\cf5 |xx, yy, points|\cf3  \cf2 //check within what circle the mouse is\cf3 \
			\cf5 var\cf3  val;\
			points.do\{\cf5 |p, i|\cf3 \
				if(p.x >= (xx-5), \{\
					if (p.x <= (xx+5), \{\
						if(p.y >= (yy-5), \{\
							if (p.y <= (yy+5), \{ val = p \}); \cf2 //move\cf3 \
						\});\
					\});\
				\});\
			\};\
			val;\
		\};\
		\
		updateBwdFwdPoints= \{\
		pointsBwd= times.collect(\{\cf5 |it, i|\cf3  \cf4 Point\cf3 ((it*u.bounds.width).floor(0.001), vals[(i-1).clip(0, vals.size-1)])\});\
		pointsFwd= times.collect(\{\cf5 |it, i|\cf3  \cf4 Point\cf3 (((times[(i+1).clip(0, times.size-1)])*u.bounds.width).floor(0.001), vals[i])\});\
		\};\
	\
	\} \cf2 //end of init\cf3 \
	\
	highlight\{\cf5 |value|\cf3 \
		points.do(\{\cf5 |it, i|\cf3  if(it.x.equalWithPrecision(value*duration, 0.1), \{\
				pointsHighlight[i]= \cf8 true\cf3 ; \
				pointsHighlight[(i-1).wrap(0, pointsHighlight.size-1)]= \cf8 false\cf3 ;\
				\});\
			\});\
	\}\
	highlightReset\{ pointsHighlight= \cf8 false\cf3 !times.size;\}\
	\
\}}