{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf600
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red191\green0\blue0;\red0\green0\blue0;\red0\green0\blue191;
\red0\green0\blue255;\red51\green51\blue191;\red102\green102\blue191;\red96\green96\blue96;}
{\*\expandedcolortbl;;\csgenericrgb\c75000\c0\c0;\csgenericrgb\c0\c0\c0;\csgenericrgb\c0\c0\c75000;
\csgenericrgb\c0\c0\c100000;\csgenericrgb\c20000\c20000\c75000;\csgenericrgb\c40000\c40000\c75000;\csgenericrgb\c37500\c37500\c37500;}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 //redFrik\cf3 \
\
\cf2 //--related:\cf3 \
\cf2 //RedAbstractMix RedMixGUI\cf3 \
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf4 RedTapTempoGUI\cf3  \{\
	\cf5 var\cf3  <parent, position,\
		<clock, task, monOn= \cf6 false\cf3 , monAmp= 0.5, monBus= 7,\
		win,\
		bpmView, bpsView, tapView, monOnView, monBusView;\
	*new \{\cf5 |clock, n= 4, timeout= 3, server, parent, position|\cf3 \
		^\cf7 super\cf3 .new.initRedTapTempoGUI(clock, n, timeout, server, parent, position);\
	\}\
	initRedTapTempoGUI \{\cf5 |argClock, n, timeout, server, argParent, argPosition|\cf3 \
		\cf5 var\cf3  cmp, times= 0.dup(n), counter, lastTime= 0;\
		clock= argClock ?? \cf4 TempoClock\cf3 .default;\
		server= server ?? \cf4 Server\cf3 .default;\
		parent= argParent;\
		position= argPosition;\
		cmp= \cf7 this\cf3 .prContainer;\
		\
		forkIfNeeded\{\
			server.bootSync;\
			\
			\cf2 //--send definition\cf3 \
			\cf2 //this.def.add;\cf3 \
			\cf2 //server.sync;\cf3 \
			\
			\cf2 //--gui\cf3 \
			\{\
				tapView= \cf4 RedButton\cf3 (cmp, 60@18, \cf8 "TAP"\cf3 , \cf8 "TAP"\cf3 )\
					.action_\{\cf5 |view|\cf3 \
						\cf5 var\cf3  newTempo, nowTime= \cf4 SystemClock\cf3 .seconds;\
						if(nowTime-timeout>lastTime, \{\
							(\cf7 this\cf3 .class.name++\cf8 ": timedout"\cf3 ).postln;\
							counter= 0;\
						\});\
						if(counter<(n-1), \{\
							times= times.put(counter, \cf4 SystemClock\cf3 .seconds);\
							counter= counter+1;\
						\}, \{\
							times= times.put(counter, \cf4 SystemClock\cf3 .seconds);\
							newTempo= times.differentiate.drop(1).mean;\
							bpmView.valueAction_(60/newTempo);\
							times= times.rotate(-1);\
						\});\
						lastTime= nowTime;\
						view.value= 0;\
					\}\
					.focus;\
				\cf2 /*\
				cmp.decorator.nextLine;\
				RedButton(cmp, 122@14, "sync")\
					.action_\{|view|\
						task.stop;\
						task= this.prRoutine.play(clock);\
					\};\
				\
				cmp.decorator.nextLine;\
				*/\cf3 \
				bpmView= \cf4 RedNumberBox\cf3 (cmp, 60@18)\
					.value_(clock.tempo*60)\
					.action_\{\cf5 |view|\cf3 \
						\cf5 var\cf3  bps= (view.value/60).round(0.0001);\
						clock.tempo= bps;\
						\cf2 //bpsView.value= bps;\cf3 \
						\cf2 //(this.class.name++": setting new tempo... bpm:"+(bps*60)).postln;\cf3 \
					\};\
				\cf4 RedStaticText\cf3 (cmp, \cf8 "bpm"\cf3 );\
				\cf4 RedButton\cf3 (cmp, \cf6 nil\cf3 , \cf8 "*2"\cf3 )\
					.action_\{\cf5 |view|\cf3  bpmView.valueAction= bpmView.value*2\};\
				\cf4 RedButton\cf3 (cmp, \cf6 nil\cf3 , \cf8 "/2"\cf3 )\
					.action_\{\cf5 |view|\cf3  bpmView.valueAction= bpmView.value/2\};\
				\
				\cf2 /*\
				bpsView= RedNumberBox(cmp)\
					.value_(clock.tempo)\
					.action_\{|view| this.tempo= view.value.max(0)\};\
				RedStaticText(cmp, "bps");\
				\
				cmp.decorator.nextLine;\
				*/\cf3 \
				\cf2 /*\
				monOnView= RedButton(cmp, nil, "monitor", "monitor")\
					.action_\{|view| monOn= view.value.booleanValue\};\
				monBusView= RedNumberBox(cmp).value_(monBus)\
					.action_\{|view| monBus= view.value.asInteger.max(0); view= monBus\};\
				*/\cf3 \
				cmp.decorator.nextLine;\
				cmp.bounds= cmp.bounds.resizeTo(cmp.bounds.width, cmp.decorator.top);\
				\
				task= \cf7 this\cf3 .prRoutine.play(clock, quant:1);\
				parent.onClose= \{task.stop\};\
			\}.defer;\
		\};\
	\}\
	tempo \{^clock.tempo\}\
	tempo_ \{\cf5 |bps|\cf3  bpmView.valueAction= bps*60\}\
	\cf2 /*\
	monitor_ \{|bool| monOnView.valueAction= bool.binaryValue\}\
	monitorAmp_ \{|val| monAmp= val\}\
	monitorBus_ \{|index|\
		monBus= index;\
		monBusView.value= index;\
	\}\
	*/\cf3 \
	close \{\
		task.stop;\
		if(win.notNil and:\{win.isClosed.not\}, \{win.close\});\
	\}\
	\cf2 /*\
	def \{^this.class.def\}\
	*def \{\
		^SynthDef(\\redTapTempo, \{|out= 0, amp= 0.5| //mono only\
			var e= EnvGen.kr(Env.perc(0.01, 0.1), doneAction:2);\
			var z= SinOsc.ar(400, e*2pi, e*amp);\
			Out.ar(out, z);\
		\}, metadata: (\
			specs: (\
				\\out: \\audiobus.asSpec,\
				\\amp: ControlSpec(0, 1, \\lin, 0, 0.5)\
			)\
		));\
	\}\
	*/\cf3 \
	\
	\cf2 //--private\cf3 \
	prContainer \{\
		\cf5 var\cf3  cmp, width, height, margin= 4@4, gap= 4@4;\
		position= position ?? \{400@600\};\
		width= 230;\
		height= 20;\
		if(parent.isNil, \{\
			parent= \cf4 Window\cf3 (\cf8 "redTapTempo"\cf3 , \cf4 Rect\cf3 (position.x, position.y, width, height), \cf6 false\cf3 );\
			win= parent;\
			win.alpha= \cf4 GUI\cf3 .skins.redFrik.unfocus;\
			win.front;\
			\cf4 CmdPeriod\cf3 .doOnce(\{if(win.isClosed.not, \{win.close\})\});\
		\});\
		cmp= \cf4 CompositeView\cf3 (parent, width@height)\
			.background_(\cf4 GUI\cf3 .skins.redFrik.background);\
		cmp.decorator= \cf4 FlowLayout\cf3 (cmp.bounds, margin, gap);\
		^cmp;\
	\}\
	prRoutine \{\
		^\cf4 Routine\cf3 (\{\
			\cf6 inf\cf3 .do\{\
				\cf2 //if(monOn, \{Synth(\\redTapTempo, [\\out, monBus, \\amp, monAmp])\});\cf3 \
				\{\
					if(bpmView.hasFocus.not, \{\
						if(bpmView.value!=\cf7 this\cf3 .tempo, \{\
							\cf7 this\cf3 .tempo= \cf7 this\cf3 .tempo;\
						\});\
					\});\
				\}.defer;\
				\{tapView.value= 1\}.defer;\
				0.25.wait;\
				\{tapView.value= 0\}.defer;\
				0.75.wait;\
			\};\
		\});\
	\}\
\}\
}