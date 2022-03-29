SliderLooper{ 

	var player= "gpLooper", c, buffer, <>title, syn, synOn, loadFile, loadDialog, x= 20, y= 20, s, <>knob1, knobDefaultAction;
	var view, x, y, number, out= 0, preferences;
	var amp, ampspec, bufferfree, firstRun= true;
	var ctrl, shift, alt;
	var <>pan= 0; //was 1
	var panarr, outputs, <>defaultout, outbut, panbut;
	var currentPath, speechout, <>output;
	var >allSliders;
	var panKnob;
	var frames= 0, samplerate= 44100, dur= 1, synthID;
	var progressFunc, progressView, prevDrawFunc;
	var ruleFolderNames, rulesList, rulesApply, rulesOnOff;
	var errorFileMessage;
	var rate= 1;
	var paused= false;

	*new {arg view, x, y, number, out, preferences;
		^super.new.initSliderLooper(view, x, y, number, out, preferences);
	}
	
	initSliderLooper {arg argview, argx, argy, argnumber, argout, argpreferences;

		view= argview;
		x= argx;
		y= argy;
		number= argnumber;
		s= Server.default;
		player= "gpLooper";
		out= argout;
		defaultout= argout;
		synthID= UniqueID.next;
		preferences= argpreferences;
		
		
		ruleFolderNames= preferences[9];
		rulesList= preferences[10];
		rulesApply= preferences[11];
		rulesOnOff= preferences[12];
		
		
		Platform.case(
			\osx,		{ ctrl= 262401; shift= 131330; alt= 524576; },
			\linux,		{ ctrl= 262144; shift= 131072; },
			\windows, 	{ "ERROR: havent tested this on Windows, so I dont know what number shift and ctrl give in a keydownaction. insert it here (in the class) and it should work.".postcs }
		);
	
		synOn = false;

		ampspec= ControlSpec( 0.001, 1.0,\amp);
		panarr= [0, -1, 1];
		outputs= [nil, 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24];
		currentPath= "nopath";
		
		if (s.options.device == nil, {speechout= 0; }, {speechout= 8; });

		loadDialog= {
			GUI.dialog.getPaths({ arg paths;
				loadFile.value(paths);			
				},{
			"cancelled".postln;
			});
		};
		
		loadFile= { |paths|
			/*
			var maxnewsamples, numsliders;
			maxnewsamples= paths.size+(number-1);
			numsliders= allSliders.size;
			allSliders.postln;
				if (paths.size > 1, {
					if (maxnewsamples < numsliders, {
						"adding samples to other sliders".postln;
						paths.do({|it, i|
							if(i==0, {nil}, {
							allSliders[number+i].setValues(it);
							});
						});
					}, {"too many samples".postln; });
				}); */
				if(paths[0].isSoundFile , {
				1.do({
					var f, chans, p;
					p= paths[0];
					{
					if (synOn, {syn.free; synOn= false; });
					s.sync;
					if (buffer.isNil.not, {
						if(player == "diskin", { {buffer.close}.try; });
					s.sync;
					buffer.free;
					});
					firstRun= true;
					f= SoundFile.new;
					f.openRead(p);
					dur = f.numFrames/s.sampleRate;
					frames= f.numFrames;
					samplerate= f.sampleRate;
					chans= f.numChannels;
					currentPath= p;
					s.sync;
					if (dur > 7, {
						buffer = Buffer.cueSoundFile(s, p, 0, chans);
						player= "diskin";
					},{
						buffer= Buffer.read(s, p);
						player= "gpLooper";
					});
					(p++" read").postln;
					{ title.string= (p.basename.removeExtension) }.defer;
					{ title.stringColor= Color.white }.defer; 
					amp= 0.0; //set sensible amplitude as default
					outbut.valueAction= 0; pan= 0; panKnob.value= 0.5;
					rulesOnOff.do({|it, onoff_iter|
						if(it == 1, {
							//"onoff!".postln;
							if (p.contains(ruleFolderNames[onoff_iter]), {
								//"it contains!!".postln;
								rulesApply[onoff_iter].do({|it, apply_iter| // 9 is pan, 10 is out
									
									if(apply_iter == 9 and: {it == 1},{
										//"applying properties!!".postln;
										pan= rulesList[onoff_iter][apply_iter];
										panKnob.value= rulesList[onoff_iter][apply_iter];
									});
																					if(apply_iter == 10 and: {it == 1},{
										//"applying properties!!".postln;
										outbut.valueAction= outputs.indexOf(rulesList[onoff_iter][apply_iter]);
									});
								});
							});
						});
					});
					
					f.close;
					progressView.drawFunc = {
					Pen.perform(\fill);
					Pen.color = Color.white(0.5, 0.5);
					Pen.stringAtPoint((dur.floor).asTimeString.drop(3).drop(-4), 10@10);
					};
					progressView.refresh;

					}.fork(AppClock);
				});
				},{
					errorFileMessage.value;
				});
		};

		knobDefaultAction= { |k|
			var chans;
			case 
			{k.value < 0.01 } { if (firstRun == false, { {syn.run(false); synOn= false}.try }); }
			{k.value > 0.01 } { if (synOn, 
				{syn.set(\amp, ampspec.map(k.value))}, 
				{
					if (firstRun, {
						if(outbut.value==0, {out= defaultout });
						//if (currentPath.contains("/Tale/"), { output= speechout; }, { output= out });
						output= out;
						if (outbut.value > 0, {output= out});
					 	if (buffer.numChannels == 1, {chans= "Mono"}, {chans= "Stereo"});
						if (buffer.isNil.not, {syn= Synth(player++chans, [\bufnum, buffer, \amp, ampspec.map(k.value), \out, output, \pan, pan, \synthID, synthID, \rate, rate]); synOn= true; firstRun= false;});
					},{
						syn.run; syn.set(\amp, ampspec.map(k.value), \rate, rate, \pan, pan); synOn= true;
						});
					if( ~logfile.isNil.not, { {~logfile.write(Date.getDate.hourStamp.asString+(currentPath.basename)++"\n")}.defer; });
				}); 
			};	
		};
		
		c= CompositeView(view, Rect(x, y, 45, 225))
		.background_(Color.black.alpha_(0.4));

		
	progressFunc= {|w, rect, play, reset|
		var view, elapsed= 0, remaining= dur, o;
		
		progressView= UserView(w, rect).canFocus_(false);

		o = OSCresponderNode(Server.default.addr, '/diskin', { arg time,responder,msg;
		var sendID = msg[2];
		var index = msg[3];
		
		if (msg[2] == synthID, {
			//debug
		/*	
		msg.postln;
		"id: % pos: % frames (% sec)\n"
			.postf(sendID, index % frames, (index % frames / samplerate));
		*/
		elapsed= (index % frames / samplerate).round(0.1) / dur.round(0.1);
		remaining= dur - (index % frames / samplerate).round(0.1);

		{	
		progressView.drawFunc = {
			//Pen.translate(100, 100);
				// set the Color
				Pen.color = Color.blue(0.5, 0.5);
				Pen.addWedge(20@20, 15, 0.75*2pi, elapsed*2pi);
				Pen.perform(\fill);
				Pen.color = Color.white(0.5, 0.5);
				Pen.stringAtPoint((remaining.floor).asTimeString.drop(3).drop(-4), 10@10);
				//Pen.stringAtPoint("sec", 10@10);
		};
		progressView.refresh;
		}.defer;
		});
		}).add;

		progressView.onClose= {o.remove; };
	};

		
		progressFunc.value(c, Rect(0, 130, 50, 50));		
		
		knob1= SmoothSlider(c, Rect(0, 0, 45, 170))
		//.addAction(f, \mouseDownAction)
		.mouseDownAction_({ |view, x, y, mod|
			if (mod == shift, {loadDialog.value});
			if (mod == alt, { this.free2; "remove file".postln;});
			if (mod == ctrl, {
				this.reloadSample;
				//loadFile.value([currentPath])
				}); //reload
		})
		.knobColor_( Color.red )
		.background_( Color.white.alpha_(0.1))
		.hilightColor_( Color.red.alpha_(0.5))
		.knobSize_(0.18)
		.border_(1).extrude_(true)
		.value_( 0 )
		//.value_(0!2)
		//.thumbSize_(5.0)
		//.valueThumbSize_(5.0)
		//.indexThumbSize_( 45 )
		//.colors_(Color.new255(205, 145, 158), Color.red)
		//.background_(Color.white.alpha_(0.1))
		.canFocus_(false)
		.canReceiveDragHandler_(true)
		.receiveDragHandler_({|view|
			var paths;
			paths= View.currentDrag;
		loadFile.value(paths);
		})
		.beginDragAction_({ this })
		.action_(knobDefaultAction);
		
		
		title= StaticText(c, Rect(5, 0, 40, 80))
		.string_("empty").font_( GUI.font.new("Helvetica", 10)).align_( \left ).stringColor_(Color.grey);
		
		StaticText(c, Rect(5, 60, 40, 80))
		.string_(number.asString).font_( GUI.font.new("Helvetica", 20)).align_( \center ).stringColor_(Color.grey);
		
		
		
		
		/*
		panbut= Button(c, Rect(0, 172, 22, 15))
		.states_([ ["<", Color.green, Color.black], ["c", Color.black, Color.grey],[">", Color.green, Color.black] ])
		.canFocus_(false)
		.value_(pan)
		.action_({ |v|
			pan= (v.value);
		});
		*/
		
		panKnob= Knob(c, Rect(0, 172, 15, 15))
		.centered_(true)
		.canFocus_(false)
		.value_(\pan.asSpec.unmap(pan))
		.action_({ |v|
			pan= (\pan.asSpec.map(v.value));
			if(firstRun.not, {syn.set(\pan, \pan.asSpec.map(v.value))});
		})
		.color_([Color.gray, Color.red, Color.white, Color.black])
		.mouseDownAction_({|view, x, y, mod|
			if (mod == alt, {view.valueAction= \pan.asSpec.unmap(0); pan= 0})
		})
		.canReceiveDragHandler_(true)
		.receiveDragHandler_({|view|
			var drag;
			drag= View.currentDrag;
			if (drag.class == UC33LoopChan, {
				drag.action= {|v| panKnob.valueAction= (v.value)};
			});
		});
		
		outbut= Button(c, Rect(17, 172, 30, 15))
		.states_([["nil", Color.black, Color.grey], ["1-2", Color.yellow, Color.black],["3-4", Color.yellow, Color.black], ["5-5", Color.yellow, Color.black], ["7-8", Color.yellow, Color.black], ["9-10", Color.yellow, Color.black], ["11-12", Color.yellow, Color.black], ["13-14", Color.yellow, Color.black], ["15-16", Color.yellow, Color.black], ["17-18", Color.yellow, Color.black], ["19-20", Color.yellow, Color.black], ["21-22", Color.yellow, Color.black], ["23-24", Color.yellow, Color.black]] )
		.font_(Font("Helvetica", 9))
		.canFocus_(false)
		.value_( 0 )
		.action_({ |v|
			if(v.value==0, {out= defaultout },
			{out= outputs[v.value];});
			{syn.free}.try;
			firstRun= true;
			synOn= false;
		});		

errorFileMessage= {
var w, r;

	w= SCAlert( "the file you loaded is not valid. It's either just plain wrong or mp3..",["close.. 5"],[{w.window.close; r.stop; }] );
	
	r= {1.wait; 
	5.do({|i| {w.buttonLabel_(0, "close.."+(5-i));}.defer; 1.wait;});
	w.window.close;}.fork(AppClock);
};
		
		c.onClose= {
			if (buffer.isNil.not, {
				if (player == "diskin", {buffer.close});
				buffer.free;
			});
		};
		
		

	}


setBuf{|buf|
	var f, chans;
	if (buf.isNil.not, {
	{
	if (synOn, {syn.free; synOn= false; });
	s.sync;
	if (buffer.isNil.not, {
		if(player == "diskin", { buffer.close });
		s.sync;
		buffer.free;
	});
	firstRun= true;
	f= SoundFile.new;
	f.openRead(buf);
	dur = f.numFrames/s.sampleRate;
	frames= f.numFrames;
	samplerate= f.sampleRate;
	chans= f.numChannels;
	currentPath= buf;
	s.sync;
	if (dur > 7, {
		buffer = Buffer.cueSoundFile(Server.local, buf, 0, chans);
		player= "diskin";
	},{
		buffer= Buffer.read(Server.local, buf);
		player= "gpLooper";
		//NetAddr(s.addr, 57120).sendMsg("/diskin", synthID);
	});
	//buffer= Buffer.read(Server.local, buf);
	{ title.string= buf.basename.removeExtension;}.defer;
	{ title.stringColor= Color.white }.defer;
	s.sync;
	f.close;
	/*
	progressView.drawFunc = {
		Pen.perform(\fill);
		Pen.color = Color.white(0.5, 0.5);
		Pen.stringAtPoint((dur.floor).asTimeString.drop(3).drop(-4), 10@10);
	};
	progressView.refresh;
	*/
	}.fork(AppClock);
	});
}

setVal {|val|
	{knob1.valueAction= (val);}.defer;
	//{knob1[0].doAction}.defer;
}

getValues{
	var bufFile, vals;
	if (buffer.isNil.not, { bufFile= {buffer.path}.try; });
	//vals= [bufFile, player];
	vals= [bufFile, player, pan, outputs[outbut.value], 1];
	^vals
}

setValues{ |vals|
	if (vals[0].isNil.not, { 
			//this.setBuf(vals[0]);
			loadFile.value([vals[0]]);
			if (vals[4].isNil.not, {
			if (vals[2].isNil.not, { pan= vals[2]; panKnob.value= \pan.asSpec.unmap(vals[2]); }, {
				pan= 0; panKnob.value= 0.5});
			}, {pan= 0; panKnob.value= 0.5});
			if (vals[3].isNil.not, { out= vals[3]; outbut.value= outputs.indexOf(vals[3]); }, {
				out= defaultout; outbut.value= 0;});
		}, {
			if (player == "diskin", { buffer.close });
			buffer.free;
			buffer= nil;
			player= nil;
			{title.string= "empty" }.defer;
			{title.stringColor= Color.grey}.defer;
			panKnob.value= 0.5;
			outbut.value= 0;
			out= defaultout;
			pan= 0;
			{
				progressView.drawFunc = {
					progressView.clearDrawing;
				};
			progressView.refresh;
			}.defer;
	}
	);
	//player= vals[1];
}

reloadSample{
	loadFile.value([currentPath])
	}

reloadSampleSoft{
	var paths= [currentPath];
				if(paths[0].isSoundFile , {
				1.do({
					var f, chans, p;
					p= paths[0];
					{
					if (synOn, {syn.free; synOn= false; });
					s.sync;
					if (buffer.isNil.not, {
						if(player == "diskin", { {buffer.close}.try; });
					s.sync;
					buffer.free;
					});
					firstRun= true;
					f= SoundFile.new;
					f.openRead(p);
					dur = f.numFrames/s.sampleRate;
					frames= f.numFrames;
					samplerate= f.sampleRate;
					chans= f.numChannels;
					currentPath= p;
					s.sync;
					if (dur > 7, {
						buffer = Buffer.cueSoundFile(s, p, 0, chans);
						player= "diskin";
					},{
						buffer= Buffer.read(s, p);
						player= "gpLooper";
					});
					(p++" read").postln;
					{ title.string= (p.basename.removeExtension) }.defer;
					{ title.stringColor= Color.white }.defer; 
					//amp= 0.0; //set sensible amplitude as default
					//outbut.valueAction= 0; pan= 0; panKnob.value= 0.5;
					f.close;
					progressView.drawFunc = {
					Pen.perform(\fill);
					Pen.color = Color.white(0.5, 0.5);
					Pen.stringAtPoint((dur.floor).asTimeString.drop(3).drop(-4), 10@10);
					};
					progressView.refresh;

					}.fork(AppClock);
				});
				},{
					//errorFileMessage.value;
				});
	}

free{
	if (synOn, {syn.free; synOn= false; });
	if (buffer.isNil.not, {
		if (player == "diskin", { buffer.close });
		buffer.free;
		buffer= nil;
	});
	}

free2{
			if (player == "diskin", { buffer.close });
			buffer.free;
			buffer= nil;
			player= nil;
			{title.string= "empty" }.defer;
			{title.stringColor= Color.grey}.defer;
			panKnob.value= 0.5;
			outbut.value= 0;
			out= defaultout;
			pan= 0;
			{
				progressView.drawFunc = {
					progressView.clearDrawing;
				};
			progressView.refresh;
			}.defer;
}

progress{|val|
	if (val == 0, { if(progressView.isClosed.not, { progressView.remove }); });
	if (val == 1, { if(progressView.isClosed, { progressFunc.value(c, Rect(0, 130, 50, 50));})});
	}

setPitch{|pitch|
	if(synOn==true, {syn.set(\rate, pitch)});
	rate= pitch;
}

setPan{|v| panKnob.valueAction= (v)}

pause{
	if(synOn == true, {syn.run(false); synOn= false; paused= true;}); 
	}

unpause{
	if(paused == true, {syn.run; syn.set(\amp, ampspec.map(knob1.value[0]), \rate, rate, \pan, pan); synOn= true; paused == false; });
	}

}

//EOF