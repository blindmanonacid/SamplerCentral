

// BP filter w/ feedback 2010 10 29
SynthDef(\fx_LPFdbk, {| in=0, out=0, mix, freq, rq=0.5, fdbk=0.01|

	var src=  In.ar(out, 2);
	//var src = Blip.ar * Impulse.kr(10);
	var local = LocalIn.ar(2);
	var filter=RLPF.ar(src + (local*fdbk), freq, rq);
	LocalOut.ar(filter);
	ReplaceOut.ar(out,  XFade2.ar(src, filter, mix))
}, metadata: (specs: (
		mix: [-1,1, \lin, 0, -1],
		freq: [150, 10000, \lin, 0, 1500],
		rq: [0.2, 1, \lin, 0, 0.5], //lowest
		fdbk: [0, 0.2, \lin, 0, 0] ))
).add;

/*
x= Synth.tail(s, \fx_LPFdbk, [\mix, 1])
x.set(\freq, 4000);
x.set(\rq, 0.2);
x.set(\fdbk, 0.2)

x.free;
*/

// chorus w/ feedback 2010 10 29

SynthDef(\fx_chorusFdbk, { arg in, out, mix, delay=0.08, speed=0.05, depth=0.1, fdbk;
	var src, sig, modulators, local, numDelays = 10;
	
	src=  In.ar(out, 2);
	local = LocalIn.ar(1);
	modulators = Array.fill(numDelays, {arg i;
 		LFPar.kr(speed * rrand(0.94, 1.06), 0.5 * i, depth.lag(0.3), delay.lag(0.2)).range(-1,1);});
	sig = DelayC.ar(src + (local *fdbk), 0.5, modulators);
	sig = sig.sum; //Mix(sig); 
	//sig= Splay.ar(sig, 1);
	
	LocalOut.ar(sig);
	sig= Limiter.ar(sig, 0.9, 0.1);
	ReplaceOut.ar(out,  XFade2.ar(src, sig, mix)  ); 

}, metadata:(
	specs: ( 
		mix: [-1,1,\lin,0, -1]  ,
		delay: [0.005, 0.5, \lin, 0, 0.01] ,
		speed: [0.01, 0.25, \lin, 0, 0.05],
		depth: [0, 0.5, \lin, 0, 0.1],
		fdbk: [0,0.1,\lin, 0, 0]
 	)
)).add;

/*
x= Synth.tail(s, \fx_chorusFdbk, [\mix, 1])
x.set(\predelay, 0.5);
x.set(\speed, 0.1);
x.set(\depth, 0.5);
x.set(\fdbk, 0.01);

x.free;
*/

/*
 SynthDescLib.global[\a_mod_chorusfdbk_Mono].makeWindow; 
*/

////////////////////////
/*
 	// Reverse Noise Gate (radio fragments)
SynthDef(\fx_fragmented,{ | in =0, out=0 mix, thresh=0.02,attack=0.05, release=0.05, delTime=0.1 | 
 
	var	src=  In.ar(out, 2);
	var amp = (Lag.kr(Amplitude.kr(src,0.02, 0.05), 0) < thresh);
	var delay = DelayN.ar (src, 0.3, delTime); 
	var envelope = delay * (EnvGen.kr(Env.asr(attack, sustain, release, 1,curve:'sine'),amp, mainVol));
	var mainVol=2.5;
	var sustain=0.7;
 
	ReplaceOut.ar(out,  XFade2.ar(src, envelope, mix))  
}, metadata: (specs: (
	mix: ControlSpec(-1,1, \lin, 0, -1),	
	thresh: ControlSpec(0.0, 0.1, \lin, 0, 0.01), 
 	attack: ControlSpec(0.0, 0.1, \lin, 0, 0.05), 
	release: ControlSpec(0.0, 0.1, \lin, 0, 0.05), 
	delTime: ControlSpec(0.0, 0.5, \lin, 0, 0.05)
)).add;

*/
/*
x= Synth.tail(s, \fx_fragmented, [\mix, 1])
x.set(\thresh, 0.05);
x.set(\release, 0.01);
x.set(\deltime, 0.5);
x.set(\fdbk, 0.01);

x.free;
*/

/*
SynthDescLib.global[\a_fx_fragments].makeWindow;
*/

 ////////////////////
 
 //comb filter preceded by Low Cut Filter
 	//COULD BE A STEREO 
 	
SynthDef(\fx_combLP, {|in=0, out=0, mix, hiCut|
	var src, lpf, comb;

	src=  In.ar(out, 2)*0.8;
	
	lpf = LPF.ar(src, hiCut); 
	comb = Mix.new(Array.fill(4, {CombL.ar(lpf, 0.1, {Rand(0.001, 0.02)}, {Rand(0.5,3.0)});}));
	comb= Limiter.ar(comb, 0.9, 0.1);
ReplaceOut.ar(out,  XFade2.ar(src, comb, mix)) ;
},metadata: (specs: (
	mix: ControlSpec(-1,1, \lin, 0, -1),
	hiCut: ControlSpec(50,500, \lin, 0, 200, "Hz") ))
).add;

/*
x= Synth.tail(s, \fx_combLP, [\mix, 1])
x.set(\hiCut, 150);

x.free;
*/


///////////////////////////////////////////////
/*
	description:
	comb delay with lfo.
*/
SynthDef(\fx_combLFO, {|out= 0, mix= (-1),
	decay, rate|
	var src, efx;
	src=  In.ar(out, 2);
//	src=  Mix.new( In.ar(out, 2) ) * 0.5;
	efx= CombC.ar(src, 0.2, SinOsc.ar(rate, 0, 0.05, 0.1), decay);
	ReplaceOut.ar(out,  XFade2.ar(src, efx, mix) );
}, metadata: (specs: (
	mix: ControlSpec(-1,1, \lin, 0, -1),
	decay: ControlSpec(0, 5, \lin, 0, 0.8),	//min, max, warp, step, default
	rate: ControlSpec(0, 5, \lin, 0, 0.5)		//min, max, warp, step, default
))).add;

/*
x= Synth.tail(s, \fx_combLFO, [\mix, 1])
x.set(\decay, -1);
x.set(\rate, 4.2)
x.free;
*/

///////////////////////////////////////////////
/*
	description:
	simple reverb with damping.
*/
SynthDef(\fx_revSimpel, {|in, out, mix= (-1),
	decay, damp|
	var src, efx;
	src=  In.ar(out, 2);
	efx= src;
	5.do{
		efx= LPF.ar(AllpassN.ar(efx, 0.05, Rand(0.01, 0.05), decay), damp);
	};
	ReplaceOut.ar(out,  XFade2.ar(src, efx, mix) );
}, metadata: (specs: (
	mix: ControlSpec(-1,1, \lin, 0, -1),
	decay: ControlSpec(0, 5, \lin, 0, 5),		//min, max, warp, step, default
	damp: ControlSpec(50, 10000, \exp, 0, 10000)	//min, max, warp, step, default
))).add;

/*
x= Synth.tail(s, \fx_revSimpel, [\mix, 1])
x.set(\decay, 5);
x.set(\damp, 10000)
x.free;
*/




///////////////////////////////////////////////
/*
	description:
	adapter from example in Tour_of_UGens helpfile
*/
SynthDef(\fx_distFreqMod, {|in, out, mix= (-1),
	depth, lofreq|
	var src, efx;
	src=  In.ar(out, 2);
	efx= SinOsc.ar(lofreq, src*(1+(depth*(8pi-1))))*0.15;
	ReplaceOut.ar(out, XFade2.ar(src, efx, mix)) ;
}, metadata: (specs: (
	mix: ControlSpec(-1,1, \lin, 0, -1),
	depth: ControlSpec(0, 5, \lin, 0, 0.8),		//min, max, warp, step, default
	lofreq: ControlSpec(0.001, 15, \exp, 0, 0.3)	//min, max, warp, step, default
))).add;

/*
x= Synth.tail(s, \fx_distFreqMod, [\mix, 1])
x.set(\depth, 0.1);
x.set(\lofreq, 30)
x.free;
*/


///////////////////////////////////////////////
/*
	description: RING MODULATION
	adapter from example in Tour_of_UGens helpfile
*/
SynthDef(\fx_ringMod, {|in, out, mix= (-1),
	depth, freq|
	var src, efx;
	src=  In.ar(out, 2);
	efx= src*SinOsc.ar(freq.lag(0.3), 0, depth)*0.5;
	efx= Limiter.ar(efx, 0.9, 0.1);
	ReplaceOut.ar(out, XFade2.ar(src, efx, mix));
}, metadata: (specs: (
	mix: ControlSpec(-1,1, \lin, 0, -1),
	depth: ControlSpec(0, 15, \lin, 0, 1),		//min, max, warp, step, default
	freq: ControlSpec(0.001, 3000, \lin, 0, 300)	//min, max, warp, step, default
))).add;

/*
x= Synth.tail(s, \fx_ringMod, [\mix, 1])
x.set(\depth, 15);
x.set(\freq, 600)
x.free;
*/

//////////////////////
// adc_mod_delchain_ST Delay Chain Stereo Spread
//

SynthDef(\fx_delayST, {|out= 0, mix = (-1), time = 0.8 /*, drift = 0.2, driftspeed = 1*/|
	var src, efx, delaytimes;
	src=  In.ar(out, 2);
	delaytimes = (0.125, 0.25 .. 1) ** time.lag(0.5);
	efx= Splay.ar(DelayL.ar(src, 2, delaytimes));
	
	ReplaceOut.ar(out,  XFade2.ar(src, efx, mix));
}, metadata: (
	specs: (
	mix: [-1, 1, \lin, 0, -1].asSpec, 
	time: [0.5, 2, \exp].asSpec;
))).add;
