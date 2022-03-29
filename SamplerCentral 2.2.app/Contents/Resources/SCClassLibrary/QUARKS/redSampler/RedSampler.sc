//these classes are part of the RedSample package / redFrik, gnu gpl v2
//preloads buffer into ram

RedSampler : RedAbstractSampler {					//playing buffers in ram
	*initClass {
		StartUp.add{
			8.do{|i|								//change here for more channels than 8
				SynthDef("redSampler-"++(i+1), {
					|i_out= 0, bufnum, amp= 0.7, attack= 0.01, sustain, release= 0.1, gate= 1, pan= 0, offset= 0, speed= 1|
					
					var src= PlayBuf.ar(
						i+1,
						bufnum,
						BufRateScale.ir(bufnum)*speed.lag(0.3),
						1,
						BufFrames.ir(bufnum)*offset,
						0
					);
					var env= EnvGen.kr(
						Env(#[0, 1, 1, 0], [attack, sustain*((speed.abs).reciprocal), release], -4),
						gate,
						1,
						0,
						1,
						2						//doneAction
					);
					if (i== 0, {
						Out.ar(i_out, Pan2.ar(src*env*amp, pan));
						},{
						Out.ar(i_out, Balance2.ar(src[0]*env*amp, src[1]*env*amp, pan));
					});
				}, #['ir']).store;
				SynthDef("redSampler-"++(i+1)++"loop", {
					|i_out= 0, bufnum, amp= 0.7, attack= 0.01, release= 0.1, gate= 1, pan= 0, offset= 0, speed= 1, startLoop= 0.0, endLoop= 1.0|
					var src= LoopBuf.ar(
						i+1,
						bufnum,
						BufRateScale.ir(bufnum)*speed.lag(0.3),
						0, //gate...
						BufFrames.ir(bufnum)*offset, //startPos
						BufFrames.ir(bufnum)*startLoop,
						BufFrames.ir(bufnum)*endLoop,
						2 //interpolation
					);
					var env= EnvGen.kr(
						Env(#[0, 1, 0], [attack, release], -4, 1),
						gate,
						1,
						0,
						1,
						2						//doneAction
					);
					if (i== 0, {
						Out.ar(i_out, Pan2.ar(src*env*amp, pan));
						},{
						Out.ar(i_out, Balance2.ar(src[0]*env*amp, src[1]*env*amp, pan));
					});
				}, #['ir']).store;
				SynthDef("redSampler-"++(i+1)++"loopEnv", {
					|i_out= 0, bufnum, amp= 0.7, attack= 0.01, sustain, release= 0.1, gate= 1, pan= 0, offset= 0, speed= 1, startLoop= 0, endLoop= 1|
					var src= LoopBuf.ar(
						i+1,
						bufnum,
						BufRateScale.ir(bufnum)*speed.lag(0.3),
						0, //gate...
						BufFrames.ir(bufnum)*offset, //startPos
						BufFrames.ir(bufnum)*startLoop,
						BufFrames.ir(bufnum)*endLoop,
						2 //interpolation
					);
					var env= EnvGen.kr(
						Env(#[0, 1, 1, 0], [attack, sustain, release], -4),
						gate,
						1,
						0,
						1,
						2						//doneAction
					);
					if (i== 0, {
						Out.ar(i_out, Pan2.ar(src*env*amp, pan));
						},{
						Out.ar(i_out, Balance2.ar(src[0]*env*amp, src[1]*env*amp, pan));
					});
				}, #['ir']).store;
				
				// with coyote to send OSC Triggers:
				
		SynthDef("redSampler-"++(i+1)++"Trigger", {
					|i_out= 0, bufnum, amp= 0.7, attack= 0.01, sustain, release= 0.1, gate= 1, pan= 0, offset= 0, speed= 1, id= 0|
					
					var src= PlayBuf.ar(
						i+1,
						bufnum,
						BufRateScale.ir(bufnum)*speed.lag(0.3),
						1,
						BufFrames.ir(bufnum)*offset,
						0
					);
					var env= EnvGen.kr(
						Env(#[0, 1, 1, 0], [attack, sustain*((speed.abs).reciprocal), release], -4),
						gate,
						1,
						0,
						1,
						2						//doneAction
					);
					
					if (i== 0, {
						SendTrig.kr(Coyote.kr(src, minDur: 0.31), id, 1);
						},{
						SendTrig.kr(Coyote.kr(src[0], minDur: 0.31), id, 1);
					});
					
					if (i== 0, {
						Out.ar(i_out, Pan2.ar(src*env*amp, pan));
						},{
						Out.ar(i_out, Balance2.ar(src[0]*env*amp, src[1]*env*amp, pan));
					});
				}, #['ir']).store;
				SynthDef("redSampler-"++(i+1)++"loop"++"Trigger", {
					|i_out= 0, bufnum, amp= 0.7, attack= 0.01, release= 0.1, gate= 1, pan= 0, offset= 0, speed= 1, startLoop= 0.0, endLoop= 1.0, id= 0|
					var src= LoopBuf.ar(
						i+1,
						bufnum,
						BufRateScale.ir(bufnum)*speed.lag(0.3),
						0, //gate...
						BufFrames.ir(bufnum)*offset, //startPos
						BufFrames.ir(bufnum)*startLoop,
						BufFrames.ir(bufnum)*endLoop,
						2 //interpolation
					);
					var env= EnvGen.kr(
						Env(#[0, 1, 0], [attack, release], -4, 1),
						gate,
						1,
						0,
						1,
						2						//doneAction
					);
					if (i== 0, {
						SendTrig.kr(Coyote.kr(src, minDur: 0.31), id, 1);
						},{
						SendTrig.kr(Coyote.kr(src[0], minDur: 0.31), id, 1);
					});
					if (i== 0, {
						Out.ar(i_out, Pan2.ar(src*env*amp, pan));
						},{
						Out.ar(i_out, Balance2.ar(src[0]*env*amp, src[1]*env*amp, pan));
					});
				}, #['ir']).store;
				SynthDef("redSampler-"++(i+1)++"loopEnv"++"Trigger", {
					|i_out= 0, bufnum, amp= 0.7, attack= 0.01, sustain, release= 0.1, gate= 1, pan= 0, offset= 0, speed= 1, startLoop= 0, endLoop= 1, id= 0|
					var src= LoopBuf.ar(
						i+1,
						bufnum,
						BufRateScale.ir(bufnum)*speed.lag(0.3),
						0, //gate...
						BufFrames.ir(bufnum)*offset, //startPos
						BufFrames.ir(bufnum)*startLoop,
						BufFrames.ir(bufnum)*endLoop,
						2 //interpolation
					);
					var env= EnvGen.kr(
						Env(#[0, 1, 1, 0], [attack, sustain, release], -4),
						gate,
						1,
						0,
						1,
						2						//doneAction
					);
					if (i== 0, {
						SendTrig.kr(Coyote.kr(src, minDur: 0.31), id, 1);
						},{
						SendTrig.kr(Coyote.kr(src[0], minDur: 0.31), id, 1);
					});
					if (i== 0, {
						Out.ar(i_out, Pan2.ar(src*env*amp, pan));
						},{
						Out.ar(i_out, Balance2.ar(src[0]*env*amp, src[1]*env*amp, pan));
					});
				}, #['ir']).store;

			}
		}
	}
	prCreateVoice {|sf, startFrame, argNumFrames|
		var len;
		if(argNumFrames.notNil, {
			len= argNumFrames/sf.sampleRate;
		}, {
			len= sf.numFrames-startFrame/sf.sampleRate;
		});
		^RedSamplerVoice(server, sf.path, sf.numChannels, startFrame, argNumFrames, len);
	}
}

RedSamplerVoice : RedAbstractSamplerVoice {
	defName {^"redSampler-"++channels}
	play {|attack, sustain, release, amp, out, group, loop, pan, speed, offset, startLoop, endLoop, id|
		var name= this.defName;
		switch(loop,
			1, {name= name++"loop"},
			2, {name= name++"loopEnv"}
		);
		if (id.isNil.not, {name= name++"Trigger"});
		//name.postln;
		//("id in redsampler:"+id).postln;
		isPlaying= true;
		synth= Synth.head(group ?? {server.defaultGroup}, name, [
			\i_out, out,
			\bufnum, buffer.bufnum,
			\amp, amp,
			\attack, attack,
			\sustain, sustain ?? {(length-attack-release).max(0)},
			\release, release,
			\pan, pan,
			\speed, speed,
			\offset, offset,
			\startLoop, startLoop,
			\endLoop, endLoop,
			\id, id
		]);
		OSCresponderNode(server.addr, '/n_end', {|t, r, m|
			if(m[1]==synth.nodeID, {
				isPlaying= false;
				isReleased= false;
				r.remove;
			});
		}).add;
	}
	prAllocBuffer {|action|
		var num= numFrames ? -1;
		buffer= Buffer.read(server, path, startFrame, num, action)
	}
}
