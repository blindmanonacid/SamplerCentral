/*
OSC message recorder and player
(c) 2013 - Marije Baalman
GPL3 license

// this class needs the FileLog quark to function


// ------ recording

// to record, create a OSCFileLog
~timelog = OSCFileLog.new( "test" ); // "test" is the base for the filename, a datetime stamp will be automatically added to the name

// send some osc data to test:
n = NetAddr.new( "localhost", NetAddr.langPort );
(
Task({ 10.do{
	n.sendMsg( "/hello", 0, 20.rand, 19.rand, "hello", 3, 4, 2.003);
	1.0.rand.max(0.01).wait;
}}).play;
);

// close the file again:
~timelog.close;


//------- playback:

// set up our target net address (here we just send to SC again
n = NetAddr.new( "localhost", NetAddr.langPort );

// we trace it to see if we get it, just to show that it works:
OSCFunc.trace( true );

// create a player
~oscplayer = OSCFileLogPlayer.new( "/home/nescivi/SuperCollider/test_130812_121049", n ); // arguments are the file/folder we previously recorded, and the target netaddress

// and play it
~oscplayer.play;

~oscplayer.pause;

~oscplayer.resume;

~oscplayer.stop;

~oscplayer.reset;

// play back faster:
~myClock = TempoClock.new( 10 );
~oscplayer.play( ~myClock );


// close the file again:
~oscplayer.close;



*/


OSCFileLog{

	var <recTime;
	var <timelogfile;
	var <offset;
	var <oscRecFunc;
	var prevValue;

	*new{ |fn, ip|
		^super.new.init( fn, ip );
	}

	init{ |fn, ip|
		fn = fn ? "TimeFileLog";
		this.open(fn, ip);
	}

	open{ |fn, ip|
        var filename = fn ++ "_"++Date.localtime.stamp++".txt";
		timelogfile = MultiFileWriter.new( filename ).zipSingle_( false ).tarBundle_( false );
		timelogfile.open;
		recTime = true;
		oscRecFunc = { |msg, time| 
			//msg[0].postln;
			//msg[0].class.postln;
			//msg.postln;
			//ip.postln;
			//msg[0].class.postln;
			if (msg[0].asString==ip, {
				//"i gotz ur ip!".postln;
				if (msg[1].asString.contains("SR"), { // unnecesarry!!
					if(msg[1]!=prevValue, {
						this.writeLine( time, msg[1], msg.copyToEnd( 1 ) );
						prevValue= msg[1];
					});
					});
				});
			};
		this.resetTime;
		thisProcess.addOSCRecvFunc( oscRecFunc );
        "recording OSC data to %\n".postf( timelogfile.pathDir );
	}

	resetTime{
		offset = Process.elapsedTime;
	}

	writeLine{ |time,tag,data|
        timelogfile.writeLine( [time - offset, tag.asCompileString ] ++ data.collect{ |it| it.asCompileString } );
	}

	close{
		recTime = false;
		timelogfile.close;
		thisProcess.removeOSCRecvFunc( oscRecFunc );
	}
}

// reads a data network log and plays it

OSCFileLogPlayer{
	var <reader;
	var playTask;

	var <curTime=0;

	var <fileClass;

	var <hasExtraTab = false;

	var <targetaddr;
	
	var <doneFunc;
	
	var recToAddr;
	var <>clock;
	
	var midi, midiDict, mid;

	*new{ |fn,addr, done, recAddr|
		^super.new.init( fn, addr, done, recAddr );
	}

	init{ |fn,addr, done, recAddr|
		targetaddr = addr;
		doneFunc= done;
		recToAddr= recAddr;
		this.checkFileClass( fn );
		this.open( fn );
	}

	checkFileClass{ |fn|
		var tar,txt;
		var path = PathName(fn);
		tar = (path.extension == "tar");
		txt = (path.extension == "txt");
		mid = (path.extension == "mid");
		if ( mid ) { 
			midi= SimpleMIDIFile.read(fn);
			midi.timeMode= \seconds;
			midiDict= Dictionary.new;
			midiDict.putPairs([21, "SR1", 22, "SR2", 23, "SR3", 24, "SR4", 25, "SR5", 26, "SR6", 27, "SR7", 28, "SR8", 29, "SR9", 30, "BRK", 41, "RL1", 42, "RL2", 43, "RL3", 44, "RL4", 45, "RL5", 46, "RL6", 47, "RL7", 48, "RL8", 49, "RL9"]);
		}{
			if ( tar ){
				fileClass = MultiFilePlayer;
			}{
				if ( txt ){
					fileClass = TabFilePlayer;
				}{
					fileClass = MultiFilePlayer;
				}
			};
		};
		//		[tar, txt, fileClass].postln;
	}

	open{ |fn|
		if ( playTask.notNil ){ playTask.stop; };
		if ( reader.notNil ){ reader.close; };

		if( midi.isNil, {
			reader = fileClass.new( fn );
		});
		clock= TempoClock.new;

	//	this.readHeader;
		/*
		playTask = Task{
			var dt = 0;
			while( { dt.notNil }, {
				dt = this.readLine;
				if ( dt.notNil ){
					dt.wait;
				}
			});
		};
		*/
		if( midi.isNil, {
			
		playTask = Task({ // "regular" osc file
			var msg;
			var time = 0, lastTime = 0;
			while( { time.notNil }, {
				#time, msg = this.readLine;
				if ( time.notNil ){
					//if ( lastTime.isNil ) { lastTime = time };
					(time - lastTime).wait;
					targetaddr.sendMsg( *msg[0].asString );
					if(~recOSC, {NetAddr("localhost", NetAddr.langPort).sendMsg( targetaddr.ip, *msg[0].asString ) });
					//msg[0].postln;
					//msg[0].class.postln;
					//msg[0].asString;
					lastTime = time;
				}
	});

	}, clock);
	
		},{
			
		playTask = Task({ // midi file
			var msg, val;
			var time = 0, lastTime = 0;
			var midiCC, i= 0;
			midiCC= midi.ccEvents;
			//"midi play task".postln;
			//midiDict.postln;
			while( { midiCC[i].notNil }, {
				#time, msg = [midiCC[i][1], [midiCC[i][4], ((midiCC[i][5])/100)*127]];
				if ( time.notNil ){
					(time - lastTime).wait;
					//midiDict[msg[0]].postln;
					if(midiDict[msg[0]].notNil, {
						targetaddr.sendMsg( midiDict[msg[0]]++(msg[1].asString));
						//[time, ( midiDict[msg[0]]++(msg[1].asString))].postln;
						( midiDict[msg[0]]++(msg[1].asString)).postln; //VERBOSE
						if(~recOSC, {
							NetAddr("localhost", NetAddr.langPort).sendMsg( targetaddr.ip,  midiDict[msg[0]]++(msg[1].asString) ) 
						});
					});
					//msg[0].postln;
					//msg[0].class.postln;
					//msg[0].asString;
					lastTime = time;
					i= i+1;
				}
	});
	"end of Midi File".postln;

	}, clock);		
			
		});
	
	
	}
	

/*
		readLine{ |update=true|
		var dt,line,data;
		var oldid;
		var oldTime = curTime;
		oldid = reader.curid;
		line = reader.nextInterpret;

		if ( line.isNil ){
			"At end of data".postln;
			if(doneFunc.isNil.not, { {doneFunc.value }.defer;});
			^nil;
		};
		curTime = line.first;
		if ( update ){
			targetaddr.sendMsg( *line.copyToEnd( 1 )[0].asString );
		};
		dt = curTime - oldTime;
		^dt;
	}
	*/
	readLine{ |update=true|
		var line,data;
		var oldid;
		oldid = reader.curid;
		line = reader.nextInterpret;
		//	line.postcs;
		// header may have changed:
		//	if ( oldid != reader.curid ){
		//		this.readHeader;
		//	};
		if ( line.isNil ){
			"At end of data".postln;
			if(doneFunc.isNil.not, { {doneFunc.value }.defer;});
			^[nil, nil];
		};
		curTime = line.first;
		^[curTime, line.copyToEnd( 1 )];
	}
	


	play{ |clock|
		playTask.start( clock );
	}

	pause{
		playTask.pause;
	}

	resume{
		playTask.resume;
	}

	stop{
		playTask.stop;
		this.reset;
	}

	reset{
		curTime = 0;
		reader.reset;
//		this.readHeader;
		playTask.reset;
	}

	close{
		playTask.stop;
		if(reader.notNil, { reader.close; });
	}

	convertToMIDIFile{|outputFile|
		var msg, oscMsg, ccnum, key, val, m;
		var time = 0;
		midiDict= Dictionary.new;
		midiDict.putPairs(["SR1", 21, "SR2", 22, "SR3", 23, "SR4", 24, "SR5", 25, "SR6", 26, "SR7", 27, "SR8", 28, "SR9", 29, "BRK", 30, "RL1", 41, "RL2", 42, "RL3", 43, "RL4", 44, "RL5", 45, "RL6", 46, "RL7", 47, "RL8", 48, "RL9", 49]);
		if(mid == false, {
			m = SimpleMIDIFile(outputFile);
			m.init1(2, 120, "4/4" );
			m.timeMode = \seconds;
			//m.division= 96;
			while( { time.notNil }, {
				#time, msg = this.readLine;
				if ( time.notNil ){
					oscMsg= msg[0].asString;
					key= oscMsg[0]++oscMsg[1]++oscMsg[2];
					ccnum= midiDict[key];
					val= oscMsg.copyRange(3, (oscMsg.size-1));
					val= ((val.asInteger/127)*100).floor;
					m.addCC( ccnum, val, time, track:1);
					//[ ccnum, key, val, time].postln;
				}
			});
			//m.adjustEndOfTrack;
			m.ccEvents.postln;
			m.write;
		}, 
		{"input file is already MIDI!".postln});
	}

		/*
	goToTime{ |newtime|
		var line,oldid;
		if ( deltaT == 0 ){
			deltaT = this.readLine;
		};
		line = floor( newtime / deltaT );
		curTime = line * deltaT;
		// assuming dt is constant.

		if ( fileClass == MultiFilePlayer ){
			oldid = reader.curid;
			reader.goToLine( line.asInteger );
			// header may have changed:
			if ( oldid != reader.curid ){
				this.readHeader;
			};
		}{
			reader.goToLine( line.asInteger );
		};
	}
*/

/*
	readHeader{
		var spec,playset,playids;
		var playslots;
		var header;

		playnodes = Dictionary.new;

		header = reader.readHeader(hs:2);
		spec = header[0].last;
		if ( spec.notNil, {
			network.setSpec( spec );
			// if spec was not local, it may be included in the tar-ball
			if ( network.spec.isNil ){
				reader.extractFromTar( spec ++ ".spec" );
				network.spec.fromFileName( reader.pathDir +/+ spec );
			};
		});

		playslots = header[1].drop(1).collect{ |it| it.interpret };

		if ( fileClass == TabFilePlayer ){
			// backwards compatibility (there was an extra tab written at the end)
			playslots = playslots.drop(-1);
			hasExtraTab = true;
		};

		if ( playslots.first == "time" ){
			// date stamps in the first column:
			playslots.drop(1);
			hasStamp = true;
		};

		playset = Set.new;
		playids = playslots.collect{ |it| it.first }.do{
			|it,i| playset.add( it );
		};
		playset.do{ |it|
			network.addExpected( it );
			playnodes.put( it, Array.new )
		};
		playids.do{ |it,i|
			playnodes.put( it, playnodes[it].add( i ) )
		};
	}
*/
}

OSCFileLogPlotter{
	var <reader;

//	var <timeMap;
	var <curTime=0;
//	var <deltaT=0;

	var <fileClass;
	var <hasExtraTab = false;

	var <targetaddr;
	
	var <doneFunc;
	var <timesList;
	var <valsList;
	var <keysList;
	var <duration;
	var <file;
	var <times, <vals, <keys;
	var <timesInSecs;
	var <keysDict;
	// v 2
	var <>sfView, <sfDuration;
	var <>plotChans;
	var w, scroll;
	var chanSelButs;
	//colors
	var pointClrs, lineClrs;
	//=== integrating ===
	//gui
	var s, tabs, sfTab, playBut;
	//soundfile
	var sfNumChannels, loadSoundFile, zoom;
	var buffer, synth;
	var sfDur, sfNumFrames, playSoundTask, playPoint1, playPoint2;	
	var oscFilePlayer;
	var oscPlayTask;
	var playCursorTask, pBus;
	var timeCursorSecs= 0;
	var timeCursorFrames= 0;
		
	var getPoint, move;



	*new{ |fn,addr, done|
		^super.new.init( fn, addr, done );
	}

	init{ |fn,addr, done|
		targetaddr = addr;
		doneFunc= done;
		timesList= List.new;
		valsList= List.new;
		keysList= List.new;
		file= fn;
		this.checkFileClass( fn );
		pointClrs= [Color.magenta, Color.cyan, Color.yellow];
		lineClrs= [Color.red, Color.new255(238, 130, 238), Color.new255(255, 140, 0)];
		chanSelButs= List.new;
		s= Server.default;
		plotChans= List.new;
		zoom= 60;
		
		this.open2( fn );
		//this.plot2( keysDict );
		
		//for every oscscore a tab, soundfile in background, on its own tab
		
		w= Window("plot", Rect(0, 0, 800, 400)).front;
		w.view.keyDownAction = {|view, char, mod, uni, key|
			//[view, char, mod, uni, key].postln;
			case {char == $1} { if(chanSelButs[0].isNil.not, {chanSelButs[0].doAction}); }
				{char == $2} { if(chanSelButs[1].isNil.not, {chanSelButs[1].doAction}); }
				{char == $3} { if(chanSelButs[2].isNil.not, {chanSelButs[2].doAction}); }
				{char == $4} { if(chanSelButs[3].isNil.not, {chanSelButs[3].doAction}); }
				{char == $5} { if(chanSelButs[4].isNil.not, {chanSelButs[4].doAction}); }
				{char == $ } { playBut.valueAction_((playBut.value+1).wrap(0, 1)) };
				
			};
		//tabs= TabbedView2.new(w, Rect(0, 20, 780, 150));
		//tabs.backgrounds_([Color.clear,Color.clear,Color.clear,Color.clear]);
		//tabs.unfocusedColors_([Color.clear,Color.clear,Color.clear]);
		scroll= ScrollView(w, Rect(0, 20, 780, 150));
		//sfTab= tabs.add("sf", scroll: true).unfocusAction= {|v| v.background_(Color.clear)};
		//scroll= tabs.add(keysList[0], 0, scroll: true).background_(Color.clear);
		//in keysDict.keysDo(|key| this.plotOSC(it, tabs); ....
		//..save those in dict too???
		
		//sfview not on scroll, not u.front but tab focus
		
		//create instances of 
		keysDict.postln;
		keysDict.keysValuesDo({|key, vals, i|
			plotChans.add(OSCScorePlotChannel.new(file, targetaddr, key, vals, scroll, this, i) );
			chanSelButs.add(Button(w, Rect(50*i, 0, 50, 20)).states_([[key, Color.black, pointClrs[i]]])
			.action_({
				plotChans[i].u.front; 
				plotChans.do({|it, i| 
					if(it.key!=key, 
						{it.alpha= 0.5; it.u.refresh; }, 
						{it.alpha= 1; it.u.refresh;}); 
					});
				});
				);
			});
		
		Button(w, Rect(0, 170, 50, 20))
		.canFocus_(false)
		.states_([["open sf"]])
		.action_({ |view, x, y, mod|
			Dialog.getPaths({ arg paths; //load sound
					this.loadSoundFile(paths[0]);
				});
		})
		.canReceiveDragHandler_(true)
		.receiveDragHandler_({|view|
			var values, paths;
			paths= View.currentDrag;
			paths= [paths];
			loadSoundFile.value(paths[0]);
		});

		
		// play an array of oscPlayTasks, only one cursorTask
		playBut= Button(w, Rect(120, 170, 50, 20))
		.canFocus_(false)
		.states_([["play"], ["stop"]])
		.action_({|v|
			timeCursorSecs= this.timeCursorPosSecs;
			if(v.value == 1, {
				if(sfView.isNil.not, {
					
					if (buffer.numChannels == 1, {
						synth= Synth(\oscSoundFile_1, [\bufnum, buffer, \pbus, pBus, \start, (timeCursorSecs/sfDuration)*buffer.numFrames])
					},{
						synth= Synth(\oscSoundFile_2, [\bufnum, buffer, \pbus, pBus, \start, (timeCursorSecs/sfDuration)*buffer.numFrames])
					});
					playCursorTask.play(AppClock);
					"file".postln;
					file.postln;
					plotChans.do({|it| it.oscPlayTask.play(SystemClock); });
					targetaddr.postln;
					//oscFilePlayer= OSCFileLogPlayer.new(file, targetaddr);// play old file
					//oscFilePlayer.play;
					
					},{
					plotChans.do({|it| it.playSoundTask.play(AppClock) });
					oscFilePlayer= OSCFileLogPlayer.new(file, targetaddr);// play old file
					oscFilePlayer.play;
					});
					},{
					if(sfView.isNil.not, {
						playCursorTask.stop;
						playCursorTask.reset;
						sfView.timeCursorPosition_((timeCursorSecs/sfDuration)*buffer.numFrames);
						synth.free;
						plotChans.do({|it| it.oscPlayTask.stop; });
						plotChans.do({|it| it.oscPlayTask.reset; });
						},{
						plotChans.do({|it| it.playSoundTask.stop });
						plotChans.do({|it| it.playSoundTask.reset });
						oscFilePlayer.stop;
						oscFilePlayer.close;
						});
					plotChans.do({|it| it.highlightReset });
					plotChans.do({|it| it.u.refresh });
					});
			});
		
		/*
		EZSlider(w, Rect(180, 170, 450, 20), "zoom", [1, 200, \lin, zoom].asSpec,
		{|ez| zoom= ez.value; 
			plotChans.do({|it| 
				it.u.bounds= Rect(0, 0, it.duration * zoom, 127);
				it.u.refresh; 
			});
			sfView.bounds= Rect(0, 0, sfDuration * zoom, 127);
			//sfView.refresh;
			scroll.refresh;
			// phuuuu and then re read the soundfile again....? or use zoom!!!
			}
		);
		*/

	
		getPoint = {|xx, yy, points| //check within what circle the mouse is
			var val;
			points.do{|p, i|
				if(p.x >= (xx-5), {
					if (p.x <= (xx+5), {
						if(p.y >= (yy-5), {
							if (p.y <= (yy+5), { val = p }); //move
						});
					});
				});
			};
			val;
		};

		
		playCursorTask= Task({
			var value= 0;
			inf.do({
				pBus.get({arg v; 
					//sfView.timeCursorPosition_( v*buffer.numFrames);
					value= v;
					});
					sfView.timeCursorPosition_(value*buffer.numFrames);
					plotChans.do({|it| it.highlight(value)});
					/*
					points.do({|it, i| if(it.x.equalWithPrecision(value*duration, 0.1), {
						pointsHighlight[i]= true; 
						pointsHighlight[(i-1).wrap(0, pointsHighlight.size-1)]= false;
						});
					});
					*/
					//value.postln;
					//buffer.numFrames.postln;
					//(value*buffer.numFrames).postln;
				0.05.wait;
				});
		});
		
		w.onClose= {
			if(buffer.isNil.not, { {buffer.free}.try });
			if(pBus.isNil.not, { {pBus.free}.try });
			};
	}
	
	loadSoundFile{|paths|
			var sf, tabCheck;
			if (paths.isSoundFile, {
				s.waitForBoot{
				"load sf".postln;
					if(buffer.isNil.not, {buffer.free});
					if(sfView.isNil.not, {sfView.remove});
					sf= SoundFile.openRead(paths);
					//sfView= sf.plot(paths[0], scroll, Rect(0, 0, u.bounds.width, 127));
					sfDuration= sf.duration;
					sfNumChannels= sf.numChannels;
					sfView= SoundFileView.new(scroll, Rect(0, 0, sfDuration*zoom, 180));
					sfView.soundfile= (sf);
					sfNumFrames= sf.numFrames;
					sfView.readFileWithTask(sf, 0, sfNumFrames-1, 256,{
						sf.close; sfView.refresh; sfView.postln;
						/*
						tabs.tabViews.do({|it| 
							it.resizeTo(sfView.bounds.width, it.bounds.height) 
							});
							*/
						});
					sfView.waveColors_(Color.blue.alpha_(1)!2);
					sfView.background_(Color.black.alpha_(1));
					sfView.timeCursorOn_(true);
					sfView.timeCursorColor_(Color.red);
					sfView.gridColor_(Color.grey);
					buffer= Buffer.read(s, paths);
					if(pBus.isNil, { pBus= Bus.control(s, 1); });
					//StaticText(sfTab, Rect(0, 0, 300, 127)).string_("can u see me???");
					w.front;
				};
			});		
		}	
	
	

	checkFileClass{ |fn|
		var tar,txt;
		var path = PathName(fn);
		tar = (path.extension == "tar");
		txt = (path.extension == "txt");
		if ( tar ){
			fileClass = MultiFilePlayer;
		}{
			if ( txt ){
				fileClass = TabFilePlayer;
			}{
				fileClass = MultiFilePlayer;
			}
		};
		//		[tar, txt, fileClass].postln;
	}

	open{ |fn|
		var msg;
		var time = 0, lastTime = nil;
		var keysCheck;
		
		//if ( playTask.notNil ){ playTask.stop; };
		if ( reader.notNil ){ reader.close; };

		reader = fileClass.new( fn );
		this.checkForMultipleKeys.postln;

			while( { time.notNil }, {
				#time, msg = this.readLine;
				if ( time.notNil ){
					if ( lastTime.isNil ) { lastTime = time };
					//(time - lastTime).wait;
					//targetaddr.sendMsg( *msg[0].asString );
					timesList.add(time);
					keysList.add(*msg[0].asString.copyFromStart(2));
					valsList.add(*msg[0].asString.copyToEnd(3).interpret);
					//msg[0].asString.copyToEnd(3).postln;
					//msg[0].class.postln;
					//msg[0].asString;
					lastTime = time;
				}
			});
			
		reader.close;
	
	}
	
	open2{ |fn|
		var msg;
		var time = 0, lastTime = nil;
		var keysCheck;

		keysDict= Dictionary.new;
		
		//if ( playTask.notNil ){ playTask.stop; };
		if ( reader.notNil ){ reader.close; };

		reader = fileClass.new( fn );
		keysCheck= this.checkForMultipleKeys.postln;
		("Keys:"+keysCheck).postln;
		
		keysCheck.do({|it|
			keysDict.put(it, List.new);
		});
		
		//separate keys
			while( { time.notNil }, {
				#time, msg = this.readLine;
				if ( time.notNil ){
					if ( lastTime.isNil ) { lastTime = time };
					keysDict[msg[0].asString.copyFromStart(2)].add(Point(time, msg[0].asString.copyToEnd(3).interpret));
						//keysList.add(*msg[0].asString.copyFromStart(2));
						//timesList.add(time);
						//valsList.add(*msg[0].asString.copyToEnd(3).interpret);

						lastTime = time;
				}
			});
		
		reader.close;
		
		keysDict.postln;
	}
	
	openAdditionalFile{ |fn|
		var msg;
		var time = 0, lastTime = nil;
		var keysCheck;
		var key, pointsList;
		
		pointsList= List.new;

		if ( reader.notNil ){ reader.close; };

		reader = fileClass.new( fn );
		keysCheck= this.checkForMultipleKeys.postln;
		("Keys:"+keysCheck).postln;
		
		keysCheck.do({|it| if (keysDict.keys.includes(it), { 
			"WARNING: the key -"+it+"- already exists!" }); });
		
		keysCheck.do({|it|
			keysDict.put(it, List.new); // hmm could erase old values..
		});
		
		//separate keys
			while( { time.notNil }, {
				#time, msg = this.readLine;
				if ( time.notNil ){
					if ( lastTime.isNil ) { lastTime = time };
					keysDict[msg[0].asString.copyFromStart(2)].add(Point(time, msg[0].asString.copyToEnd(3).interpret));

						// but what if it has several keys?
						key= msg[0].asString.copyFromStart(2);
						pointsList.add(Point(time, msg[0].asString.copyToEnd(3).interpret));

						lastTime = time;
				}
			});
		
		reader.close;
		
			plotChans.add(OSCScorePlotChannel.new(fn, targetaddr, key, pointsList, scroll, this, plotChans.size) );
			chanSelButs.add(Button(w, Rect(50*(plotChans.size-1), 0, 50, 20)).states_([[key, Color.black, pointClrs[(plotChans.size-1).copy]]])
			.action_({
				plotChans[(plotChans.size-1).copy].u.front;
				plotChans.do({|it, i| if(it.key!=key, 
					{it.alpha= 0.5; it.u.refresh; }, 
					{it.alpha= 1; it.u.refresh; });
					});
				});
			);
		
		keysDict.keys.postln;
	}
	
	checkForMultipleKeys{ 
			var msg;
			var time = 0, keyCheckList;
			keyCheckList= List.new;
			while( { time.notNil }, {
				#time, msg = this.readLine;
				if ( time.notNil ){
					keyCheckList.add(*msg[0].asString.copyFromStart(2));
					}
				});
			keyCheckList= keyCheckList.removeEqualDups;
			^keyCheckList;
	}
	
	separateKeys{|keys|
		
		^[]
	}
	
	readLine{ |update=true|
		var line,data;
		var oldid;
		oldid = reader.curid;
		line = reader.nextInterpret;

		if ( line.isNil ){
			"At end of data".postln;
			duration= timesList.last;
			//if(doneFunc.isNil.not, { {doneFunc.value }.defer;});
			
			^[nil, nil];
		};
		curTime = line.first;
		^[curTime, line.copyToEnd( 1 )];
	}
	


	play{ |clock|
		//playTask.start( clock );
	}

	pause{

	}

	resume{
		
	}

	stop{
		this.reset;
	}

	reset{
		curTime = 0;
		reader.reset;
	}

	close{
		reader.close;
	}
	
		writeFileOld { |fn |
		var timelogfile;
		var prevValue;
		var filename = fn ++".txt";
		
		timelogfile = MultiFileWriter.new( filename ).zipSingle_( false ).tarBundle_( false );
		timelogfile.open;
		timesInSecs.do({|it, i|
					if(vals[i]!=prevValue, { // clean up duplicates as well
						//this.writeLine( it, (keys[i]++points[i].y).asSymbol ) //twice??
						timelogfile.writeLine( [it, (keys[i]++vals[i]).asCompileString ] );
					});
					prevValue= vals[i];
			});
		timelogfile.close;
	}
	
		writeFile { |fn |
		var timelogfile;
		var prevValue;
		var filename = fn ++".txt";
		
		timelogfile = MultiFileWriter.new( filename ).zipSingle_( false ).tarBundle_( false );
		timelogfile.open;
		timesInSecs.do({|it, i|
					if(vals[i]!=prevValue, { // clean up duplicates as well
						//this.writeLine( it, (keys[i]++points[i].y).asSymbol ) //twice??
						timelogfile.writeLine( [it, (keys[i]++vals[i]).asCompileString ] );
					});
					prevValue= vals[i];
			});
		timelogfile.close;
	}
/*
	writeLine{ |time,tag,data|
        timelogfile.writeLine( [time, tag.asCompileString ] ++ data.collect{ |it| it.asCompileString } );
	}
	*/
	
	mergeFiles{ |arrayOfFiles| //don't use
		var merge, sorted;
		arrayOfFiles.do({|it|
			merge= it++merge;
		});
		sorted= merge.quickSort { |n,m| n[0] <= m[0] } ;
		^sorted;
	
	}

	mergeFilesAndWrite{ |fn |
		var timelogfile;
		var prevValue;
		var filename = fn ++".txt";
		var arraysToMerge, merge, sorted;
		
		//merge
		arraysToMerge= plotChans.collect({ |it|
			it.timesInSecs.collect({|time, i| [time, it.key, it.vals[i]]});
		});
		
		arraysToMerge.do({|it|
			merge= it++merge;
		});
		//sort
		sorted= merge.quickSort { |n,m| n[0] <= m[0] } ;


		//write
		timelogfile = MultiFileWriter.new( filename ).zipSingle_( false ).tarBundle_( false );
		timelogfile.open;
		sorted.do({|it, i|
					if((it[1]++it[2])!=prevValue, { // clean up duplicates as well
						//this.writeLine( it, (keys[i]++points[i].y).asSymbol ) //twice??
						timelogfile.writeLine( [it[0], (it[1]++it[2]).asCompileString ] );
					});
					prevValue= (it[1]++it[2]);
			});
		timelogfile.close;
	
	}
	
		mergeFilesAndWritePlus65{ |fn |
		var timelogfile;
		var prevValue;
		var filename = fn ++".txt";
		var arraysToMerge, merge, sorted;
		
		//merge
		arraysToMerge= plotChans.collect({ |it|
			it.timesInSecs.collect({|time, i| [time, it.key, it.vals[i]]});
		});
		
		arraysToMerge.do({|it|
			merge= it++merge;
		});
		
		//sort
		sorted= merge.quickSort { |n,m| n[0] <= m[0] } ;


		//write
		timelogfile = MultiFileWriter.new( filename ).zipSingle_( false ).tarBundle_( false );
		timelogfile.open;
		sorted.do({|it, i|
					if((it[1]++it[2])!=prevValue, { // clean up duplicates as well
						//this.writeLine( it, (keys[i]++points[i].y).asSymbol ) //twice??
						if(it[1]=="SR2", {it[2]= it[2]+65});
						if(it[1]=="SR1", {it[2]= it[2]+25});
						timelogfile.writeLine( [it[0], (it[1]++it[2]).asCompileString ] );
					});
					prevValue= (it[1]++it[2]);
			});
		timelogfile.close;
	
	}
	
	timeCursorPosSecs{
		var pos;
		pos= (sfView.timeCursorPosition/sfView.numFrames)*sfDuration;
		plotChans.do({|it| it.timeCursorSecs= pos });
		^pos;
	}

	
}

OSCScorePlotChannel{


	var <fileClass;
	var <hasStamp = false;
	var <hasExtraTab = false;

	var <targetaddr;
	
	var <doneFunc;
	var <timesList;
	var <valsList;
	var <duration;
	var <file;
	var <key;
	var <times, <vals;
	var <timesInSecs;
	var move;
	var getPoint;
	
	// v 2
	// gui
	var s, mother, <>timeCursorSecs;
	var <>u, tabs, <>scroll;
	var playPoint1, playPoint2;
	var zoom= 60;
	var pointClrs, lineClrs, instanceNum;
	var <>alpha= 1;
	//points
	var <points, pointsBwd, pointsFwd, <>pointsHighlight;
	var updateBwdFwdPoints;
	//tasks
	var <>oscPlayTask, <>playSoundTask;

		
	

	*new{ |fn, addr, ky, pnts, tbs, mum, num|
		^super.new.init( fn, addr, ky, pnts, tbs, mum, num );
	}

	init{ |fn, addr, ky, pnts, tbs, mum, num|
		s= Server.default;
		targetaddr = addr;
		key= ky;
		timesList= pnts.collect({|it| it.x });
		valsList= pnts.collect({|it| it.y });
		file= fn;
		//tabs= tbs;
		scroll= tbs;
		mother= mum;
		instanceNum= num;
		
		//this.open2( fn );
		
		duration= timesList.last;
		
		pointClrs= [Color(1.0, 0.35294117647059, 1.0), Color.cyan, Color.yellow];
		lineClrs= [Color(1.0, 0.35294117647059, 1.0), Color.cyan, Color.new255(255, 140, 0)];
	
		//scroll= tabs.add(key, 1, scroll: true).unfocusAction= {|v| v.background_(Color.clear)};
	
	
		u= UserView(scroll, Rect(0, 0, duration * zoom, 180))
		.mouseDownAction_({ arg view,x,y, mod, but, clicks;
			var point, pointIndex, newPoint, delmenu;
			mod.postln;
			clicks.postln;
			move.postln;
			case
			{mod == 0 or: {mod == 256} } { // change the parameters for every move
				move= getPoint.value(x, y, points);
				mother.sfView.postln;
				mother.sfView.bounds.width.postln;
				mother.sfView.numFrames.postln;
				if(move.isNil.not, {"u hit a point".postln;});
				if(mother.sfView.isNil.not and: {move.isNil}, {
					mother.sfView.timeCursorPosition_((x/mother.sfView.bounds.width)*mother.sfView.numFrames);
					//timeCursorSecs= (sfView.timeCursorPosition/buffer.numFrames)*sfDuration;
					mother.timeCursorPosSecs;
					});
				view.refresh;
				if (clicks == 2, {
				"add point??".postln;
				move= getPoint.value(x, y, points);
				if (move.isNil, { // ======  add point ======
					pointIndex= times.indexOfGreaterThan(x/u.bounds.width);
					times.insert(pointIndex, x/u.bounds.width);
					timesInSecs.insert(pointIndex, (x/u.bounds.width)*duration);
					vals.insert(pointIndex, y);
					points.insert(pointIndex, Point(x, y));
					updateBwdFwdPoints.value;
					pointsHighlight= false!times.size;
					view.refresh;
					},
				{ //======================= remove point ========
					//move.postln;
					//move.class.postln;
				pointIndex= points.indexOfEqual(move);
				points.removeAt(pointIndex);
				//"gm".postln;
				pointsBwd.removeAt(pointIndex);
				pointsFwd.removeAt(pointIndex);
				times.removeAt(pointIndex);
				vals.removeAt(pointIndex);
				timesInSecs.removeAt(pointIndex);
				pointsHighlight= false!times.size;
				pointsBwd= times.collect({|it, i| Point((it*u.bounds.width).floor(0.001), vals[(i-1).clip(0, vals.size-1)])});
				pointsFwd= times.collect({|it, i| Point(((times[(i+1).clip(0, times.size-1)])*u.bounds.width).floor(0.001), vals[i])});
					});
				});
			};
		})
		.mouseMoveAction_({ arg view,x,y, mod;
			var pointIndex, newPoint;
			//"move".postln;
			move.isNil.not.if({ // =============== move a point =============
				//"move should be something...".postln;
				//view.postln;
					move= getPoint.value(x, y, points);
					newPoint= x @ y;
					pointIndex= points.indexOfEqual(move);
					//["pointIndex:"+pointIndex, "x:"+x, "y:" +y ].postln;
					if(pointIndex.isNil.not, {
						//["move point no"+pointIndex, "size:"+points.size].postln;
					case { pointIndex==0 } { // move first point
							times[pointIndex]= x/u.bounds.width;
							timesInSecs[pointIndex]= x/u.bounds.width*duration;
							points.put(pointIndex, newPoint);
							vals[pointIndex]= y;
							pointsBwd[pointIndex].x_(newPoint.x);
							pointsBwd[pointIndex+1].y_(newPoint.y);
							pointsFwd[pointIndex].y_(newPoint.y);
							//pointsFwd[pointIndex-1].x_(newPoint.x);
							//"moving a point".postln;
							
							u.refresh;			
							}
						{ pointIndex==(points.size-1) } { //move last point
							["x:"+x, "y"+y].postln;
							if(x > u.bounds.width, {u.resizeTo(x, u.bounds.height)});
							//duration= !!!!!
							times[pointIndex]= x/u.bounds.width;
							timesInSecs[pointIndex]= x/u.bounds.width*duration; // !!!!!
							points.put(pointIndex, newPoint);
							vals[pointIndex]= y;
							pointsBwd[pointIndex].x_(newPoint.x);
							pointsBwd[pointIndex].y_(newPoint.y);
							pointsFwd[pointIndex].y_(newPoint.y);
							pointsFwd[pointIndex-1].x_(newPoint.x);
							u.refresh;
							}
						{  x > points[pointIndex-1].x and: {x < points[pointIndex+1].x} } {
							// move any other point
							//["move point no"+pointIndex, "size:"+points.size].postln;
							times[pointIndex]= x/u.bounds.width;
							timesInSecs[pointIndex]= x/u.bounds.width*duration;
							points.put(pointIndex, newPoint);
							vals[pointIndex]= y;
							pointsBwd[pointIndex].x_(newPoint.x);
							pointsBwd[pointIndex+1].y_(newPoint.y);
							pointsFwd[pointIndex].y_(newPoint.y);
							pointsFwd[pointIndex-1].x_(newPoint.x);
							//"moving a point".postln;
							u.refresh;	
						};
					});
			});
		})
		.mouseUpAction_({ arg view,x,y, mod;
		//move= nil;
		//u.refresh;
		});
		//.background_(Color.white.alpha_(0.2));
		//if(GUI.scheme==QtGUI, { u.alwaysOnTop= true; });
		

		
		playPoint1= Point(u.bounds.left, 0);
		playPoint2= Point(u.bounds.left, u.bounds.height);
		
		times= (timesList / duration).asArray;
		timesInSecs= timesList.asArray;
		vals= valsList.asArray;
		//keys= keysList.asArray;
		
		points= times.collect({|it, i| Point((it*u.bounds.width).floor(0.001), vals[i])});
		pointsBwd= times.collect({|it, i| Point((it*u.bounds.width).floor(0.001), vals[(i-1).clip(0, vals.size-1)])});
		pointsFwd= times.collect({|it, i| Point(((times[(i+1).clip(0, times.size-1)])*u.bounds.width).floor(0.001), vals[i])});

		pointsHighlight= false!times.size;
		
		//u.animate= true;
		//u.frameRate= 15;

		u.drawFunc= {|uview|

			//Pen.stringAtPoint(keys[i].asString, 20@20, Font("Monaco", 25));
			
			Pen.strokeColor = lineClrs[instanceNum].alpha_(alpha);
			Pen.fillColor= pointClrs[instanceNum].alpha_(alpha);
			Pen.moveTo(points[0]);
			Pen.lineTo(pointsFwd[0]);
			Pen.draw(2);
			Pen.fillOval(Rect(points[0].x-5, points[0].y-5, 10, 10));
			
			Pen.moveTo(playPoint1);
			Pen.lineTo(playPoint2);

			points.do({|it, i| 
				if(i > 0, {
				
				Pen.strokeColor = lineClrs[instanceNum].alpha_(alpha);
				
				Pen.moveTo(pointsBwd[i]);
				Pen.lineTo(points[i]);
				Pen.lineTo(pointsFwd[i]);
				Pen.draw(2);
				Pen.fillOval(Rect(it.x-5, it.y-5, 10, 10));
					if(pointsHighlight[i]==true, {
						Pen.fillColor= Color.green;
						Pen.fillOval(Rect(it.x-5, it.y-5, 10, 10));
						Pen.fillColor= pointClrs[instanceNum].alpha_(alpha);
						});
				Pen.strokeColor = Color.blue.alpha_(alpha);
				Pen.stringAtPoint(vals[i].asString, Point(it.x+2, it.y-17), Font("Monaco", 9), pointClrs[instanceNum].alpha_(alpha));
				});
				
				});
		};
		
		playSoundTask= Task{
			var time= 0;
			while ( {time<duration}, {
				time= time+0.05;
				0.05.wait;
				playPoint1.x_((time/duration)*u.bounds.width);
				playPoint2.x_((time/duration)*u.bounds.width);
				//sfView.timeCursorPosition_( (time/duration)*sfNumFrames);
			});
			
		};

		oscPlayTask= Task({
			var startIndex= 0, time, lastTime= 0;
			
			//timeCursor= (sfView.timeCursorPosition/buffer.numFrames)*sfDuration;
			//timeCursorSecs= mother.timeCursorPosSecs;
			if(timeCursorSecs > 0, {
				startIndex= timesInSecs.indexOfGreaterThan(timeCursorSecs);
				//(timesInSecs[startIndex]-timeCursorSecs).wait;
				//lastTime= timesInSecs[startIndex];
				lastTime= timeCursorSecs;
			});
			
			"starting task".postln;
			timesInSecs.do({|it, i|
				if( i >= startIndex, {
				//"starting do".postln;
				//("lastTime:"+lastTime.asString).postln;
				//("time:"+it.asString).postln;
				(it-lastTime).wait;
				//("value:"+keys[i]++points[i].y).postln;
				targetaddr.sendMsg(key++points[i].y);
				pointsHighlight[i]= true; 
				pointsHighlight[(i-1).wrap(0, pointsHighlight.size-1)]= false;
				//{u.refresh}.defer;
				//("send osc").postln;
				lastTime= it;
				});
			});
			
		});
		
		getPoint = {|xx, yy, points| //check within what circle the mouse is
			var val;
			points.do{|p, i|
				if(p.x >= (xx-5), {
					if (p.x <= (xx+5), {
						if(p.y >= (yy-5), {
							if (p.y <= (yy+5), { val = p }); //move
						});
					});
				});
			};
			val;
		};
		
		updateBwdFwdPoints= {
		pointsBwd= times.collect({|it, i| Point((it*u.bounds.width).floor(0.001), vals[(i-1).clip(0, vals.size-1)])});
		pointsFwd= times.collect({|it, i| Point(((times[(i+1).clip(0, times.size-1)])*u.bounds.width).floor(0.001), vals[i])});
		};
	
	} //end of init
	
	highlight{|value|
		points.do({|it, i| if(it.x.equalWithPrecision(value*duration, 0.1), {
				pointsHighlight[i]= true; 
				pointsHighlight[(i-1).wrap(0, pointsHighlight.size-1)]= false;
				});
			});
	}
	highlightReset{ pointsHighlight= false!times.size;}
	
}