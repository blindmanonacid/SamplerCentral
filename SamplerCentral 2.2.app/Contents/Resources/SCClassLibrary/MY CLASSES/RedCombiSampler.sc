
/*

still need to RedAbstractSamplerVoice

*/


RedCombiSampler {
	var keys, ramSampler, diskSampler;
	var server, thresh;
	
	*new{|server, thresh|
		^super.new.init(server)
	}
	
	init {|argServer, argthresh|
		keys= ();
		server= argServer ?? Server.default;
		thresh= argthresh ?? 30;
		
		keys= Dictionary.new;
		
		ramSampler= RedSampler(server);
		diskSampler= RedDiskInSamplerGiga(server);
	}

	prepareForPlay{|key, path, startFrame, numFrames|
		var f;
		f= SoundFile.new;
		f.openRead(path);
		if (f.duration > thresh, { keys[key]= \disk }, {keys[key]= \ram});
		f.close;
		case 
		{keys[key]==\ram} {ramSampler.prepareForPlay(key, path, startFrame= 0, numFrames)}
		{keys[key]==\disk} {diskSampler.prepareForPlay(key, path, startFrame= 0, numFrames)};
		
		}
	channels {|key|
		case 
		{keys[key]==\ram} {^ramSampler.channels(key)}
		{keys[key]==\disk} {^diskSampler.channels(key)}
		{keys[key]== nil } {^nil};
	}
	buffers {|key|
		case 
		{keys[key]==\ram} {^ramSampler.buffers(key)}
		{keys[key]==\disk} {^diskSampler.buffers(key)}
		{keys[key]== nil } {^nil};
	}
	voicesLeft {|key|
		case 
		{keys[key]==\ram} {^ramSampler.voicesLeft(key)}
		{keys[key]==\disk} {^diskSampler.voicesLeft(key)}
		{keys[key]== nil } {^nil};
	}	
	isPlaying { |key|
		case 
		{keys[key]==\ram} {^ramSampler.isPlaying(key)}
		{keys[key]==\disk} {^diskSampler.isPlaying(key)}
		{keys[key]== nil } {^false};
	}
	play { |key, attack= 0, sustain, release= 0, amp= 0.7, out= 0, group, loop= 0, pan= 0, speed= 1, offset= 0, startLoop= 0, endLoop= 1, id|
		case 
		{keys[key]==\ram} {ramSampler.play(key, attack, sustain, release, amp, out, group, loop, pan, speed, offset, startLoop, endLoop, id)}
		{keys[key]==\disk} {diskSampler.play(key, attack, sustain, release, amp, out, group, loop, pan, speed, offset, startLoop, endLoop, id)};
	}
	stop { arg key... args;
		case 
		{keys[key]==\ram} {ramSampler.stop(key, *args)}
		{keys[key]==\disk} {diskSampler.stop(key, *args)}
		{keys[key]== nil } {"WARNING:".postln; "RedCombiSampler: key not found"};
	}
	length { arg key;
		case 
		{keys[key]==\ram} {^ramSampler.length(key)}
		{keys[key]==\disk} {^diskSampler.length(key)}
		{keys[key]== nil } {^nil};
	}

	speed_{ arg val; 
		ramSampler.speed_(val);
		diskSampler.speed_(val);
	}
	
	amp_{ arg val; 
		ramSampler.amp_(val);
		diskSampler.amp_(val);
	}
	flush { arg release; 
		ramSampler.flush(release);
		diskSampler.flush(release);
	}
	freeKey { arg key;
		case 
		{keys[key]==\ram} {ramSampler.freeKey(key)}
		{keys[key]==\disk} {diskSampler.freeKey(key)};
		keys.removeAt(key);
	}
	free {
		ramSampler.free;
		diskSampler.free;
		keys= Dictionary.new;
	}
	keys {
		^(ramSampler.keys++diskSampler.keys);
	}
	loadedKeys {
		^(ramSampler.loadedKeys++diskSampler.loadedKeys);
	}
	playingKeys {
		^(ramSampler.playingKeys++diskSampler.playingKeys);
	}
	overlaps_{|val|
		ramSampler.overlaps_(val);
		diskSampler.overlaps_(val);
	}
	overlaps {
		^diskSampler.overlaps;
	}
	numFrames_{|val|
		diskSampler.numFrames_(val);
	}
	numFrames {
		^diskSampler.numFrames;
	}
	set {|key|
		case //only sets first voice, but that's usually all thats needed
		{keys[key]==\ram} {^ramSampler.keys[key][0]}
		{keys[key]==\disk} {^diskSampler.keys[key][0]}
		{keys[key]== nil } {"WARNING:".postln; "RedCombiSampler: key not found"};
	}



}

