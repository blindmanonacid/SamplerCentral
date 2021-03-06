//these classes are part of the RedSample package / redFrik, gnu gpl v2
//preloads buffer when .play so there will be a slight hickup and latency

RedDiskInSampler : RedAbstractSampler {				//playing sounds from disk
	var <>numFrames= 32768;							//preload buffer size in samples
	*initClass {
		StartUp.add{
			8.do{|i|								//change here for more channels than 8
				SynthDef("redDiskInSampler-"++(i+1), {
					|i_out= 0, bufnum, amp= 0.7, attack= 0.01, sustain, release= 0.1, gate= 1, pan= 0, speed= 1|
					var src= VDiskIn.ar(i+1, bufnum, speed.abs.lag(0.3), 0);
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
				SynthDef("redDiskInSampler-"++(i+1)++"loop", {
					|i_out= 0, bufnum, amp= 0.7, attack= 0.01, release= 0.1, gate= 1, pan= 0, speed= 1|
					var src= VDiskIn.ar(i+1, bufnum, speed.abs.lag(0.3), 1);
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
				
				// with Coyote onset detection sending OSC Trigger
				SynthDef("redDiskInSampler-"++(i+1)++"Trigger", {
					|i_out= 0, bufnum, amp= 0.7, attack= 0.01, sustain, release= 0.1, gate= 1, pan= 0, speed= 1, id= 0|
					var src= VDiskIn.ar(i+1, bufnum, speed.abs.lag(0.3), 0);
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
				SynthDef("redDiskInSampler-"++(i+1)++"loop"++"Trigger", {
					|i_out= 0, bufnum, amp= 0.7, attack= 0.01, release= 0.1, gate= 1, pan= 0, speed= 1, id= 0|
					var src= VDiskIn.ar(i+1, bufnum, speed.abs.lag(0.3), 1);
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
			}
		}
	}
	prCreateVoice {|sf, startFrame|
		^RedDiskInSamplerVoice(server, sf.path, sf.numChannels, startFrame, numFrames, sf.duration);
	}
}

RedDiskInSamplerVoice : RedAbstractSamplerVoice {
	defName {^"redDiskInSampler-"++channels}
	play {|attack, sustain, release, amp, out, group, loop, pan, ctrl, speed, id|
		var name= this.defName;
		if(loop==1, {name= name++"loop"});
		if (id.isNil.not, {name= name++"Trigger"});
		
		isPlaying= true;
		synth= Synth.basicNew(name, server);
		buffer.cueSoundFile(path, startFrame, {
			OSCresponderNode(server.addr, '/n_end', {|t, r, m|
				if(m[1]==synth.nodeID, {
					buffer.close;
					isPlaying= false;
					isReleased= false;
					r.remove;
				});
			}).add;
			synth.addToHeadMsg(group ?? {server.defaultGroup}, [
				\i_out, out,
				\bufnum, buffer.bufnum,
				\amp, amp,
				\attack, attack,
				\sustain, sustain ?? {(length-attack-release).max(0)},
				\release, release,
				\pan, pan,
				\speed, speed,
				\id, id
			]);
		});
	}
	prAllocBuffer {|action|
		buffer= Buffer.alloc(server, numFrames, channels, action)
	}
}
