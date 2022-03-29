

/*

b = Buffer.read(s,"sounds/a11wlk01.wav");

(  // timestretch using easy crossfadelooping
SynthDef("cheap-timestretch",{ arg out=0, bufnum=0, fadeTime = 0.05, speed = 20.0;
	var timescale = MouseX.kr(0, 2, 0), ratescale = MouseY.kr(4, 0.25, 1);
	var trig, trigdiv, env, offset;
	trig = Impulse.kr(speed);
	trigdiv = PulseDivider.kr(trig, 2, [0,1]); // divide triggers over 2 channels
	env = Lag.kr(ToggleFF.kr(trig), fadeTime); // one signal to contol which channel is heard
	offset = Phasor.ar(0, timescale * BufRateScale.kr(bufnum), 0, BufFrames.kr(bufnum)); 
	Out.ar(out, SelectL.ar( env,
			PlayBuf.ar(1,b.bufnum,ratescale * BufRateScale.kr(bufnum), trigdiv, offset, 1.0) )
	);
}).play;
)

//TimeStretching with PitchShift
SynthDef(\stretch, { |bufnum, ratio = 1|
       var sig; ratio;
    ratio= MouseX.kr(1, 100)*MouseY.kr(0.2, 4);
	sig = PlayBuf.ar(1, bufnum, rate: ratio.reciprocal *
BufRateScale.kr(bufnum), loop: 1);
       Out.ar([0, 1], PitchShift.ar(sig, pitchRatio: ratio))
}).send(s);

b= Buffer.read(s, "sounds/break")

a= Synth(\stretch, [\bufnum, b.bufnum], addAction: \addToHead)

a.set(\ratio, 10)

a.free;
*/

//////////////////////
/*
	TIME STRETCH (Spectral) NOT WORKING!!!
*/

/*
SynthDef(\fx_TimeStretch,{ |arg0= 0.5, arg2=0.5, gate= 1, out= 0, mix= 1| //arg0=> rate[ 0,2] arg1=> pitch[ 0,1]
Ê Ê var array, select, rate, pitch; //specs
Ê Ê var input, chain, bufnum, bufnum2, recBuf;
Ê Ê var frames= 1024, hop= 0.5;
Ê Ê var playChain, sig;
Ê Ê var signal, phasor;
	Êrate = [0, 2].asSpec;
	Êpitch= [0,1].asSpec;

	input= In.ar(out,2);

Ê Ê bufnum = LocalBuf.new(2048, 1);
Ê Ê //recording
Ê Ê recBuf= LocalBuf.new((4).calcPVRecSize(frames, hop, Server.default.options.sampleRate), 1);
Ê Ê chain = FFT(bufnum, input, 0.25, 0);
Ê Ê Ê chain = PV_RecordBuf(chain, recBuf, 0, gate, 1, 0.5, 1);

Ê Ê //playing
Ê ÊplayChain = PV_PlayBuf(bufnum, recBuf, rate.map(arg0) Ê, 0, 1);
Ê Ê playChain = PV_MagShift(playChain, pitch.map(arg2),1); //pitch shift
Ê Ê sig= Limiter.ar(IFFT(playChain, 1)*5);

ReplaceOut.ar(out,  XFade2.ar(input, sig, mix)) ;
}, metadata: (specs: (
	arg0: ControlSpec(0, 1, \lin, 0, 0.1),
	arg2: ControlSpec(0, 1, \lin, 0, 0.1),
	gate: ControlSpec(0, 1, \lin, 1, 0),
	mix: ControlSpec(-1,1, \lin, 0, -1))
)).add;
*/

//////////////////////
/*
	DUB DELAY
*/


SynthDef(\fx_DubDelay,{|out= 0, mix, length = 0.375, fb = 0.8, sep = 0.0012, hipass= 400, lopass= 5000|
var input = In.ar(out, 2);
var signal = input + Fb({

	arg feedback; // this will contain the delayed signal from the Fb unit

	var left,right;
	var magic = LeakDC.ar(feedback*fb + input);
	magic = HPF.ar(magic, hipass);
	magic = LPF.ar(magic, lopass);
	magic = magic.tanh; 
	#left, right = magic; 
	magic = [DelayC.ar(left, 1, LFNoise2.ar(12).range(0,sep.lag(0.3))), DelayC.ar(right, 1, LFNoise2.ar(12).range(sep.lag(0.3),0))];
},length.lag(0.3));
ReplaceOut.ar(out, XFade2.ar(input, signal, mix)) ;
}, metadata: (specs: (
	length: ControlSpec(0.01,1, \lin, 0, 0),
	fb: ControlSpec(0,0.99, \lin, 0, 0.6),
	sep: ControlSpec(0.0,0.01, \lin, 0, 0.0012),
	mix: ControlSpec(-1,1, \lin, 0, -1),
	hipass: \freq.asSpec,
	lopass: \freq.asSpec
))).add;



//////////////////////
/*
	FREEZE SAMPLER 
*/

SynthDef(\fx_freeze,{ arg out= 0, point= 0, pitch= 1, glide= 0.3, gate= 0;
	var bufnum, signal, input, mix;
	input= In.ar(out,2);
	bufnum= LocalBuf(44100*2, 2);

	RecordBuf.ar(input, bufnum, 0, 1, 0, (gate-1).abs, 1, gate);
	point = Lag.kr(point, glide);	
	signal = Warp1.ar(2, bufnum, point, pitch, 0.1, -1, 8, 0.1, 2);

	mix= gate.linlin(0, 1, -1, 1);
	ReplaceOut.ar(out, XFade2.ar(input, signal, mix)) ;
}, metadata: (specs: (
	point: ControlSpec(0,1, \lin, 0, 0),
	pitch: ControlSpec(0,2, \lin, 0, 1),
	glide: ControlSpec(0,1, \lin, 0, 0.3),
	gate: ControlSpec(0,1, \lin, 1, 0)
))).add;




//////////////////////
/*
	VOCODER
*/

SynthDef(\fx_vocoder ,{ arg out,  mix= 1, sel, freq, mul, mMul;
	var input, sig, mod;
	var lowfreq= [20, 300].asSpec;
	var hifreq= [20, 1000].asSpec;
	input = In.ar(out, 2);
	mod= Select.ar(sel, [
		Saw.ar(hifreq.map(freq), mul),  
		HPF.ar(Saw.ar(hifreq.map(freq)*SinOsc.ar(386, 0, 2), mul), 300), 
		Pulse.ar(lowfreq.map(freq), ([0, 7.8].asSpec).map(mMul), mul), //! 
		Blip.ar(([20, 300].asSpec).map(freq), 3+(mul*5))*8, // !
		LFPulse.ar(hifreq.map(freq), 0, 0.5, mul), 
		VarSaw.ar(hifreq.map(freq), 0,0.3, mul), 
		Impulse.ar(lowfreq.map(freq), mul, 20)*1.5
		]);
	sig= Vocoder.ar(mod, input, 56);
	
	ReplaceOut.ar(out, XFade2.ar(input, sig, mix)) ;
}, metadata: (specs: (
	freq: ControlSpec(0,1, \lin, 0, 0.14),
	mMul: ControlSpec(0.1, 1, \lin, 0, 0.7),
	mul: ControlSpec(0.1, 20, \lin, 0, 5),
	sel: ControlSpec(0,6, \lin, 1, 2),
	mix: ControlSpec(-1,1, \lin, 0, -1))
)).add;




//////////////////////
/*
	DELAY PING PONG
*/


SynthDef(\fx_DelayPingPong,{ 
		arg out, mix, delay=0.5, fdbk, freeze, smooth;
		
		var input, inputPanned, outSound, delaytime, fdbkVal, fdbkType, 
			mixCombined, freezeCombined, invLagFreeze, smoothCombined;
		var modDelay=0, modFeedback=0, modFreeze=0, modSmoothTime=0, fdbkMin= 0.001, fdbkMax= 1.0, delayMin= 10, delayMax= 16000, initialPan= 0;
		var bufnumDelay;
		
		bufnumDelay= LocalBuf.new(Server.default.options.sampleRate*16, 2).clear;
		
		freezeCombined = (freeze + modFreeze).max(0).min(1).round(1);
		invLagFreeze = 1 - Lag.kr(freezeCombined, 0.1);
		smoothCombined = (smooth + modSmoothTime).max(0).min(1);
		input = In.ar(out, 2);
		inputPanned = Balance2.ar(input[0], input[1], (initialPan * 2)-1); 
		delaytime = Lag2.kr(
			(( (delayMax/delayMin) ** ((delay + modDelay).max(0.0001).min(1)) ) * delayMin / 1000),
			smoothCombined
		);
		fdbkType = 0;
		fdbkVal = fdbkMin + ( (fdbkMax-fdbkMin) * 
			(fdbk + modFeedback + (freezeCombined * 2)).max(0).min(1) );

		//outSound = PingPong.ar(bufnumDelay, input * invLagFreeze, delaytime, fdbkType * fdbkVal);
		outSound= PingPong.ar(bufnumDelay, inputPanned * invLagFreeze, delaytime, fdbk);
		outSound= outSound;
		//Out.ar(out, (TXClean.ar(outSound) * mixCombined) + (input * (1-mixCombined)));
		ReplaceOut.ar(out, XFade2.ar(input, outSound, mix)) ;//delete mixCombined, add mix
		
	}, metadata: (specs: (
	delay: ControlSpec(0, 1, \lin, 0, 0.5),
	fdbk: ControlSpec(0, 1, \lin, 0, 0.4),
	freeze: ControlSpec(0, 1, \lin, 1, 0),
	smooth: ControlSpec(0, 1, \lin, 0, 0.2),
	mix: ControlSpec(-1,1, \lin, 0, -1))
)).add;


//////////////////////
/*
	PHASER NOTCH
*/


SynthDef(\fx_PhaserNotch,{ 
		arg out, mix, fFreq,  res, freq, lfoDpt;
		var outLfo, outFreq, outLfoDepth, outFunction, phaseFreq;
		var input, outSound, resVal, mixCombined, filterFunc, numLayers;
		var fFreqMin= 100, fFreqMax= 10000, resMin= 0.0, resMax= 1.0, freqMin= 0.01, freqMax= 100, modFFreq= 0, modRes= 0, modFreq= 0, modLfoDepth= 0;
		
		outFreq = ( (freqMax/freqMin) ** ((freq + modFreq).max(0.001).min(1)) ) * freqMin;
		outLfoDepth = (lfoDpt + modLfoDepth).max(0).min(1);
		// select function based on arrOptions
		outFunction = TXLFO.arrOptionData.at(0).at(1);
		outLfo = outFunction.value(outFreq) * outLfoDepth;
		input = In.ar(out,2);
		phaseFreq =( (fFreqMax/fFreqMin) ** ((fFreq + modFFreq + [outLfo, outLfo.neg]).max(0).min(1)) ) * fFreqMin;
		resVal = resMin + ( (resMax - resMin) * (res + modRes).max(0).min(1) );
		mixCombined = 1;
		//	BRF.ar(in, freq, rq, mul, add);
		filterFunc = {arg argIn, argFactor; 
			BRF.ar(argIn, phaseFreq * [1, 1.5, 0.75, 1.25, 0.875].at(argFactor), (1 - resVal));
		};
		numLayers = 2;
		outSound = input;
		numLayers.do({ arg item, i;
			var holdSound;
			holdSound = filterFunc.value(outSound, i);
			outSound = holdSound;
		});
		outSound = outSound.madd(mixCombined/2, input * (1-mixCombined));

//		outSound = Mix.new(BRF.ar(input, [phaseFreq * 2, phaseFreq, phaseFreq/2], (1 - resVal)))
//			.madd(mixCombined, input * (mixCombined + (1-mixCombined)));
//		outSound = (BRF.ar(input, phaseFreq, (1 - resVal)))
//			.madd(mixCombined/2, input * ((mixCombined/2) + (1-mixCombined)));
//		outSound = (BRF.ar(BRF.ar(BRF.ar(input, phaseFreq/2, (1 - resVal)), phaseFreq, (1 - resVal)), phaseFreq/1.5, (1 - resVal)))
//			outSound.madd(mixCombined/2, input * (1-mixCombined));

		// use tanh as a limiter
		ReplaceOut.ar(out, XFade2.ar(input, outSound.tanh, mix)) ;//delete mixCombined, add mix
	}, metadata: (specs: (
	fFreq: ControlSpec(0, 1, \lin, 0, 0.5),
	res: ControlSpec(0, 1, \lin, 0, 0.5),
	freq: ControlSpec(0,1, \lin, 0, 0.4),
	lfoDpt: ControlSpec(0,1, \lin, 0, 0.3),
	mix: ControlSpec(-1,1, \lin, 0, -1))
)).add;


//////////////////////
/*
	HARMONISER
*/

SynthDef(\fx_Harmoniser,{ 
		arg mix, out= 0, outVol, chg1, chg2, pitch, smoothTime, lag;
		var input, att, rel, freq, hasFreq, outFreq, trans, outFunction, outchg1, outchg2, 
			lagtime, outAmp, outWave, mixCombined, outSound, pitchDetectFunction;
		var chg1Min= 0, chg1Max= 1, chg2Min= 0, chg2Max= 1, lagMin= 0.001, lagMax= 1;
		var modchg1= 0, modchg2= 0, modLag= 0;
		input = In.ar(out,2);
		//pitchDetectFunction = this.getSynthOption(1);
		# freq, hasFreq = Pitch.kr(input, ampThreshold: 0.02, median: 7);
		trans = 2 ** (pitch /12);
		lagtime = lagMin + ((lagMax - lagMin) * (lag + modLag).max(0.001).min(1));
		outFreq = Lag.kr(			// lag the freq 
				freq * trans,
				smoothTime		//  lag time
		);

		outFunction = TXWaveForm.arrOptionData.at([0, 0]).at(1).at(1);
		outchg1 = chg1Min + ((chg1Max - chg1Min) * (chg1 + modchg1).max(0).min(1));
		outchg2 = chg2Min + ((chg2Max - chg2Min) * (chg2 + modchg2).max(0).min(1));
		outAmp = Lag.kr(			// lag the input 
				hasFreq.round(1.0) *
				Amplitude.kr(In.ar(out,1), 0.1, 0.1),
				lagtime		//  lag time
		);
		outWave = outFunction.value(outFreq, outchg1, outchg2) * outAmp *0.05 * outVol;
		outWave= Limiter.ar(LPF.ar(LPF.ar(outWave, 800), 800), 0.6);
		ReplaceOut.ar(out, XFade2.ar(input, outWave[0]!2, mix)) ;//delete mixCombined, add mix
	}, metadata: (specs: (
	chg1: ControlSpec(0, 1, \lin, 0, 0.5),
	chg2: ControlSpec(0, 1, \lin, 0, 0.1),
	pitch: ControlSpec(-12,12, \lin, 1, 0),
	smoothT: ControlSpec(0,1, \lin, 0, 0.078),
	lag: ControlSpec(0,1, \lin, 0, 0.05),
	outVol: ControlSpec(0,1, \lin, 0, 0.5),
	mix: ControlSpec(-1,1, \lin, 0, -1))
)).add;


//////////////////////
/*
	FLANGER 3 (expensive!)
*/

SynthDef(\fx_Flanger3,{ 
		arg mix, out, selM, freq=0.1, fedbk= 0.1, lfoFreq= 0.25, lfoDpt= 0.1, stDpth= 0.5;
			
		var outLfo, outLFOFreq, outLfoDepth, outVolRamp;
		var inputL, inputR, inputLDelayed, inputRDelayed, outSound, delaytime, fedbkVal, decaytime, stDpthComb, mixCombined= 1;
		var freqMin= 0.midicps, freqMax= 127.midicps, lfoFreqMin= 0.01, lfoFreqMax= 20;
		var fedbkMin= 0.01, fedbkMax= 1;
		var modFreq= 0, modFeedback= 0, modLFOFreq= 0, modLfoDepth= 0, modStereoDepth= 0;
		var bufnumDelayL, bufnumDelayR, bufnumDelayL2, bufnumDelayR2;
		var maxDelaytime= 0.5;
		
		bufnumDelayL= LocalBuf.new(Server.default.options.sampleRate*maxDelaytime/2, 1);
		bufnumDelayR= LocalBuf.new(Server.default.options.sampleRate*maxDelaytime/2, 1);
		bufnumDelayL2= LocalBuf.new(Server.default.options.sampleRate*maxDelaytime, 1);
		bufnumDelayR2= LocalBuf.new(Server.default.options.sampleRate*maxDelaytime, 1);
		
		outLFOFreq = ( (lfoFreqMax/lfoFreqMin) ** ((lfoFreq + modLFOFreq).max(0.001).min(1)) ).lag(0.3) * lfoFreqMin;
		outLfoDepth = (lfoDpt + modLfoDepth).max(0).min(1);
		// select function based on arrOptions
		outLfo = Select.kr(selM, [SinOsc.kr(outLFOFreq), LFPulse.kr(outLFOFreq), LFTri.kr(outLFOFreq), LFSaw.kr(outLFOFreq)]) * outLfoDepth;
		inputL = In.ar(out,1);
		inputR = In.ar(out+1,1);
		delaytime =(
			((freqMax/freqMin) ** ((freq + modFreq + outLfo).max(0.0001).min(1)) ) * freqMin
		).reciprocal;
		fedbkVal = fedbkMin + ( (fedbkMax-fedbkMin) * (fedbk + modFeedback).max(0).min(1) );
		decaytime = 0.1 + (delaytime * (1 + (128 * fedbkVal)) );
		stDpthComb =  (stDpth + modStereoDepth).max(0.001).min(1);
		inputLDelayed = BufDelayC.ar(bufnumDelayL, inputL, stDpthComb/2 * ((0.5 * outLfoDepth) - outLfo) * (delaytime/2));
		inputRDelayed = BufDelayC.ar(bufnumDelayR, inputR, stDpthComb/2 * (outLfo - (0.5 * outLfoDepth)) * (delaytime/2));
		//mixCombined = (wetDryMix + modWetDryMix).max(0).min(1);
		//	CombC.ar(in, maxdelaytime, delaytime, decaytime, mul, add)
		outSound = BufCombC.ar([bufnumDelayL2, bufnumDelayR2], [inputLDelayed, inputRDelayed], delaytime, decaytime, mixCombined, 
			[inputL, inputR] * (1-mixCombined));
		outVolRamp = EnvGen.kr(Env.new([0, 0, 1], [0.1,0.1]), 1);
		// use tanh as a limiter to stop blowups
		outSound= outVolRamp * LeakDC.ar(outSound.tanh, 0.995);
		ReplaceOut.ar(out, XFade2.ar([inputL, inputR], outSound, mix)) ;//delete mixCombined, add mix
	}, metadata: (specs: (
	freq: ControlSpec(0, 1, \lin, 0, 0.5),
	fedbk: ControlSpec(0, 1, \lin, 0, 0.1),
	lfoFreq: ControlSpec(0, 1, \lin, 0, 0.25),
	lfoDpt: ControlSpec(0, 1, \lin, 0, 0.1),
	stDpth: ControlSpec(0, 1, \lin, 0, 0.5),
	selM: ControlSpec(0, 3, \lin, 1, 0),
	mix: ControlSpec(-1,1, \lin, 0, -1))
)).add;



//////////////////////
/*
	DISINTEGRATOR
*/

SynthDef(\fx_Disintegrator,{ 
		arg mix, out, prob, mult, 
			modP, modM;
		var input, outSound, probVal, multVal, mixCombined;
		var limit = 0.9;
		var probMin= 0, probMax= 1.0, multMin= -1.0, multMax= 1.0;

		input = In.ar(out,2);

		probVal = probMin + ( (probMax-probMin) * (prob + modP).max(0).min(1) );
		multVal = multMin + ( (multMax-multMin) * (mult + modM).max(-1).min(1) );

		outSound = Disintegrator.ar(input, probVal, multVal);

		outSound = LeakDC.ar(outSound, 0.995);

		ReplaceOut.ar(out, XFade2.ar(input, outSound, mix)) ;//delete mixCombined, add mix
	}, metadata: (specs: (
	prob: ControlSpec(0, 1, \lin, 0, 0.5),
	mult: ControlSpec(0, 1, \lin, 0, 0),
	modP: ControlSpec(-1, 1, \lin, 0, 0),
	modM: ControlSpec(-1, 1, \lin, 0, 0),
	mix: ControlSpec(-1,1, \lin, 0, -1))
)).add;


//////////////////////
/*
	BIT CRUSHER
*/

SynthDef(\fx_BitCrusher,{ 
		arg mix, sel, out, sRate, bitSize, smooth,
			mSRate;
		var input, outSound, outFunction, sRateCombined, bitSizeCombined, smoothCombined, 
			bitRedux, downsamp, inGain= 1, outGain= 0.5, sRateMin= 100, sRateMax= 22050, modBitSize= 0, modSmoothing= 0;
		input = In.ar(out,2);
		sRateCombined = ( (sRateMax/sRateMin) ** ((sRate + mSRate).max(0.001).min(1)) ) * sRateMin;
		bitSizeCombined = ControlSpec.new(1, 24, \exp, 1 ).map ( // controlSpecBit
			(ControlSpec.new(1, 24, \exp, 1 ).unmap(bitSize) + modBitSize).max(0).min(1) // controlSpecBit
		);
		smoothCombined = (smooth + modSmoothing).max(0).min(1);

	downsamp = Latch.ar(inGain * input, Impulse.ar(sRateCombined));
	bitRedux = downsamp.round(0.5 ** bitSize);
	outSound= Select.ar(sel, [downsamp, Decimator.ar(inGain * input, sRateCombined, bitSizeCombined), SmoothDecimator.ar(inGain * input, sRateCombined, smoothCombined)]);
		
	ReplaceOut.ar(out, XFade2.ar(input, outGain * outSound, mix)) ; //delete mixCombined, add mix
	}, metadata: (specs: (
	sRate: ControlSpec(0,1, \lin, 0, 0.5),
	bitSize: ControlSpec(1, 16, \lin, 1, 8),
	smooth: ControlSpec(0, 1, \lin, 0, 0.5),
	mSRate: ControlSpec(0, 1, \lin, 0, 0),
	sel: ControlSpec(0, 2, \lin, 1, 0),
	mix: ControlSpec(-1,1, \lin, 0, -1))
)).add;



//////////////////////
/*
	ECHO DELAY
*/
SynthDef(\fx_Echo, { arg delay = 0.2, decay = 4, mix= 0, out= 0;
	var input, sig;
	input = In.ar(out,2);
	sig= AllpassL.ar(input, 0.9, delay.lag(0.3), 0.001+decay, 1);
	ReplaceOut.ar(out, XFade2.ar(input, sig, mix)) ;
}, metadata: (specs: (
	mix: ControlSpec(-1,1, \lin, 0, -1),
	decay: ControlSpec(0, 5, \lin, 0, 0.8),
	delay: ControlSpec(0.005, 0.5, \lin, 0, 0.01))
)).add;


//////////////////////
/*
	TRANSIENT SHAPER - MAYBE NOT WORKING, CHECK SPECS
*/
SynthDef(\fx_Transient,{ arg out,  mix= 1, upFreq, downFreq= 0.5, modUp= 0, modDwn= 0;
		var input, upFreqSum, downFreqSum, outSlew, mixCombined;
		var upFreqMin= 20, upFreqMax= 20000, downFreqMin= 30, downFreqMax= 20000;
		input = In.ar(out,2);
		upFreqSum = ( (upFreqMax/upFreqMin) ** ((upFreq + modUp).max(0.001).min(1)) ) * upFreqMin;
		downFreqSum = ( (downFreqMax/downFreqMin) ** ((downFreq + modDwn).max(0.001).min(1)) ) * downFreqMin;
		outSlew = Slew.ar(input, upFreqSum, downFreqSum);
	ReplaceOut.ar(out, XFade2.ar(input, outSlew, mix)) ; //delete mixCombined, add mix
}, metadata: (specs: (
	upFreq: ControlSpec(0,1, \lin, 0, 0.5),
	downFreq: ControlSpec(0,1, \lin, 0, 0.5),
	modUp: ControlSpec(-1,1, \lin, 0, 0),
	modDwn: ControlSpec(-1,1, \lin, 0, 0),
	mix: ControlSpec(-1,1, \lin, 0, 1))
)).add;


//////////////////////
/*
	PITCH SHIFTER
*/
SynthDef(\fx_pitchShift,{
	arg out, mix= 1, pitch= 0, randP= 0, randT= 0.004, grSize= 0.05, ratio= 1;
	var input, outWet, outTranspose, ratioCombined, mixCombined, outSound, modRatio= 0,ratioMin= 0.25, ratioMax= 1;
	input = In.ar(out,2);
	ratioCombined = ratioMin + ((ratioMax - ratioMin) * (ratio + modRatio).max(0).min(1));
	outTranspose = 2 ** (pitch/12);
	outWet = PitchShift.ar(input, grSize, ratioCombined * outTranspose, randP, randT * grSize);
	ReplaceOut.ar(out, XFade2.ar(input, outWet, mix)) ;	//delete mixCombined, add mix
}, metadata: (specs: (
	mix: ControlSpec(-1,1, \lin, 0, -1),
	ratio: \rate.asSpec,
	pitch: ControlSpec(-10,10, \lin, 0, 0),
	randP: ControlSpec(0,1, \lin, 0, 0),
	randT: ControlSpec(0,1, \lin, 0, 0),
	grSize: ControlSpec(0.05, 0.25, \lin, 0.05, 0.25),
	delay: ControlSpec(0.005, 0.5, \lin, 0, 0.01))
)).add;



//////////////////////
/*
	TELEPHONE
*/

/*
SynthDef(\telephone, { arg mix= 1, out= 0;
	var input, sig;
	input = In.ar(out,2);
	sig = HPF.ar(LPF.ar(input, 1000), 100).softclip;
	ReplaceOut.ar(out, XFade2.ar(input, sig, mix)) ;
}, metadata: (specs: (
	mix: ControlSpec(-1,1, \lin, 0, 1))
)).add;

x= Synth.tail(s, \telephone)
x.free

*/

//////////////////////
/*
	PANNING MADNESS
*/

SynthDef(\fx_PanMadness, { arg freq= 2, mix= 0, out= 0;
	var input, sig, pan;
	input = In.ar(out,2);
	pan= LFPar.kr(freq);
	sig= Balance2.ar(input[0], input[1], pan);
	ReplaceOut.ar(out, XFade2.ar(input, sig, mix)) ;
}, metadata: (specs: (
	mix: ControlSpec(-1,1, \lin, 0, -1),
	freq: ControlSpec(0.001, 40, \exp, 0, 0.3)	//min, max, warp, step, default
))).add;


//////////////////////
/*
	GRAINS
*/
SynthDef(\fx_Grains, {| mix=1, t_rate=0.5, dura=0.5, ptch=0.5, gate=1, recrun=1, sel0=0, sel1=0, Êout=0|
	var array, select, buf,rec, cloudDur, clk, pos, pan, rateCloud,rateLine, env,sig, rate, trate, dur, pitch, input;
	// =>trate[10,100] t_rate Ê Ê Ê Ê Ê=>dur[0.05,1] dura Ê Ê Ê Ê Ê Ê Ê=>pitch [0,2] ptch
	trate=[10,100].asSpec;
	dur=[0.1,1].asSpec;
	pitch=[0.1,2].asSpec;

	input= In.ar(out,2);

	buf = LocalBuf(44100*1,1).clear;
	rec = RecordBuf.ar(Mix.new(input), buf, 0,1,0, recrun, 1);

	cloudDur = BufDur.kr(buf);
	clk = Dust.kr(trate.map(t_rate));
	pos=Select.kr (sel0, [SinOsc.kr(1).range(0,1), LFNoise1.kr(1).range(0,1)]) ;

	rate = Select.kr(sel1, [ TRand.kr(0.2*pitch.map(ptch), pitch.map(ptch), clk), pitch.map(ptch)]);

	env = EnvGen.kr(Env.asr(cloudDur/2, 1, cloudDur/2, Rand(-4,4) ),gate, doneAction:2); //!!!
	pan = WhiteNoise.kr(0.6);
	sig = GrainBuf.ar(2, clk, dur.map(dura), buf, rate, pos ,2, pan )*env;
	sig= Limiter.ar(sig, 0.9, 0.1);
	ReplaceOut.ar(out, XFade2.ar(input, sig, mix)) ;
}, metadata: (specs: (
	mix: ControlSpec(-1,1, \lin, 0, -1),
	t_rate: ControlSpec(5, 100, \lin, 0, 20),		//min, max, warp, step, default
	dur: ControlSpec(0.05, 1, \exp, 0, 0.5),	//min, max, warp, step, default
	ptch: ControlSpec(0.001, 2, \lin, 0, 0.5),
	sel0: ControlSpec(0, 1, \lin, 1, 0),
	sel1: ControlSpec(0, 1, \lin, 1, 0)
))).add;

/*
//////////////////////
/*
	PITCH FOLLOWING NOT WORKING
*/
SynthDef(\fx_pitchFollow,{ |out= 0, mix= 1| //glitchy
Ê Êvar input, amp, freq, hasFreq, sig;
	input = In.ar(out,2);
Ê Êamp = Amplitude.kr(input, 0.05, 0.05);
Ê Ê# freq, hasFreq = Pitch.kr(input, 220, ampThreshold: 0.002, maxBinsPerOctave:4, median: 10, downSample:4);
Ê Êfreq = Lag.kr(freq.cpsmidi.round(1).midicps, 0.05);
Ê Ê Ê//sig = Mix.new(VarSaw.ar(freq * [1, 1.1], 0,0.5, amp));
Ê Êsig = Limiter.ar(Mix.new(BPF.ar(input, freq*100, 1, 1)),0.4);
	ReplaceOut.ar(out, XFade2.ar(input, sig, mix)) ;
}, metadata: (specs: (
	mix: ControlSpec(-1,1, \lin, 0, 1)
))).add;

SynthDef(\fx_pitchFollowComb, { |out= 0, mix= 1| //with Comb
	var in, amp, freq, hasFreq, sig, input;
	input = In.ar(out,2);
	in = PitchShift.ar( input, 0,2, 0.5) ; //PlayBuf.ar(1, b.bufnum,0.5, loop:1);
	amp = Amplitude.kr(in, 0.05, 0.05);
	# freq, hasFreq = Pitch.kr(in, 220, ampThreshold: 0.002, maxBinsPerOctave:4, median: 10, downSample:4);
	freq = Lag.kr(freq.cpsmidi.round(1).midicps, 0.05);
	//sig = Mix.new(VarSaw.ar(freq * [1, 1.1], 0,0.5, amp));
	sig = Limiter.ar(Mix.new(CombC.ar(PitchShift.ar(in,0.2, 0.5), 0.1, Lag.kr(freq.wrap(0.05,0.0001),0.01), 0.7, 1)));
	ReplaceOut.ar(out, XFade2.ar(input, sig, mix)) ;
}, metadata: (specs: (
	mix: ControlSpec(-1,1, \lin, 0, 1)
))).add;
*/

//////////////////////
/*
	COMB FILTER WITH RING MOD
*/
SynthDef(\fx_CombFilter, {| arg0=0.5, arg1=0.5, out=0, mix=1|
var zerotwo, fade, delayTmul, array, select, comb, ring, input, sig;
	zerotwo= [0.01,2].asSpec;
	fade=[-1,1].asSpec;
	input= In.ar(out,2);
	comb = Array.fill(6, {CombL.ar( input, 1, {zerotwo.map(arg0)*Rand(0.01, 0.001)}, {zerotwo.map	(arg1)*Rand(0.8,1.5)}, 1/12) });
	// ring = Array.fill(2, {Ringz.ar(select, {zerotwo.map(arg2)*Rand(100, 1000)}, {zerotwo.map	(arg1)*Rand(0.01,0.5)},1/4)});
	//Limiter.ar(Mix.new(comb),0.9)
	sig= Splay.ar(comb,1,1)*2;
	ReplaceOut.ar(out, XFade2.ar(input, sig, mix)) ;
}, metadata: (specs: (
	mix: ControlSpec(-1,1, \lin, 0, -1),
	arg0: ControlSpec(0.01,1, \lin, 0, 0.1),
	arg1: ControlSpec(0.01,2, \lin, 0, 1),
	arg2: ControlSpec(0,1, \lin, 0, 1)
))).add;

//////////////////////
/*
	STUTTER
*/
SynthDef(\fx_stutter,{ arg out=0, rate=1, gate=0, start= 0, end= 0.2;
	var env, signal, input, bufnum, mix, glide=0;
	input= In.ar(out,2);
	bufnum= LocalBuf(44100*2, 2);
	start= (start * bufnum.numFrames);
	end= (end * bufnum.numFrames).clip(start, bufnum.numFrames);
	start= start.clip(0, end);
	RecordBuf.ar(input, bufnum, 0, 1, 0, (gate-1).abs, 1, gate);
	rate = Lag.kr(rate, glide);
	signal = LoopBuf.ar(2,bufnum, (BufRateScale.kr(bufnum) * rate) * gate, gate, start, start, end, 2);
	mix= gate.linlin(0, 1, -1, 1);
	ReplaceOut.ar(out, XFade2.ar(input, signal, mix)) ;
}, metadata: (specs: (
	start: ControlSpec(0,1, \lin, 0, 0),
	end: ControlSpec(0,1, \lin, 0, 0.2),
	rate: ControlSpec(0,1, \lin, 0, 1),
	gate: ControlSpec(0,1, \lin, 1, 0)
))).add;

/*
x= Synth.tail(s, \fx_looper, [\startLoop, 0, \endLoop, 20000, \gate, 0])
x.set(\gate, 1)

x.set(\gate, 0)
x.set(\gate, 1)
x.free
*/

/*
SynthDef(\fx_grains, {|arg0=0.5, arg1=0.5, arg2=0.5, gate=1, recrun=1, sel0=0, sel1=0, Êout=0, mix=1|
	var array, select, buf,rec, cloudDur, clk, pos, pan, rateCloud,rateLine, env,sig, rate, trate, dur, pitch, input;
	// =>trate[10,100] arg0 Ê Ê Ê Ê Ê=>dur[0.05,1] arg1 Ê Ê Ê Ê Ê Ê Ê=>pitch [0,2] arg2
	trate=[10,100].asSpec;
	dur=[0.1,1].asSpec;
	pitch=[0.1,2].asSpec;

	input= In.ar(out,2);

	buf = LocalBuf(44100*1,1).clear;
	rec = RecordBuf.ar(Mix.new(input), buf, 0,1,0, recrun, 1);

	cloudDur = BufDur.kr(buf);
	clk = Dust.kr(trate.map(arg0));
	pos=Select.kr (sel0, [SinOsc.kr(1).range(0,1), LFNoise1.kr(1).range(0,1)]) ;

	rate = Select.kr(sel1, [ TRand.kr(0.2*pitch.map(arg2), pitch.map(arg2), clk), pitch.map(arg2)]);

	env = EnvGen.kr(Env.asr(cloudDur/2, 1, cloudDur/2, Rand(-4,4) ),gate, doneAction:2); //!!!
	pan = WhiteNoise.kr(0.6);
	sig = GrainBuf.ar(2, clk, dur.map(arg1), buf, rate, pos ,2, pan )*env;
	ReplaceOut.ar(out,(sig*mix)+ (input*(mix-1)));
}).send(s);


*/


/*
SynthDef(\fx_tgrainsBuf, {|trate=50, durMul=2, pitchLow=0.75, pitchHi=3.25, out=0, mix= 1|
Ê Êvar cloudDur, dur, clk, pos, pan, rateCloud,rateLine , env,sig, buffer, input;

	input= In.ar(out, 2);
	buffer = LocalBuf.new(44100*4, 2).clear;
	RecordBuf.ar(input, buffer, loop: 1);
Ê ÊcloudDur = BufDur.kr(buffer) * durMul;
Ê Êdur = 10 / trate;
Ê Êclk = Impulse.kr(Rand(5,50));
Ê Êpos= Line.kr(0,BufDur.kr(buffer),cloudDur, doneAction:2);
Ê ÊrateCloud = EnvGen.kr(Env.perc(cloudDur/20, (cloudDur/20)*19, Rand(pitchLow,pitchHi), Rand(-4,4)));
Ê ÊrateLine = TRand.kr(pitchLow, pitchHi, clk);
Ê Êenv = EnvGen.kr(Env.perc(cloudDur/20, (cloudDur/20)*19, 1, Rand(-4,4)));
Ê Êpan = WhiteNoise.kr(0.6);
Ê Êsig = TGrains.ar(2, clk, buffer, TWChoose.kr(1,[rateCloud,rateLine],[0.5,0.5]), pos, dur, pan, 0.5)*env;

ReplaceOut.ar(out, XFade2.ar(input, sig, mix)) ;
}, metadata: (specs: (
	mix: ControlSpec(0,1, \lin, 0, 1),
	trate: ControlSpec(5, 100, \lin, 0, 50),		//min, max, warp, step, default
	durMul: ControlSpec(0.05, 5, \lin, 0, 2),	//min, max, warp, step, default
	pitchLow: ControlSpec(0.001, 5, \lin, 0, 0.75),
	pitchHi: ControlSpec(0.001, 5, \lin, 0, 3.25)
))).add;
*/
