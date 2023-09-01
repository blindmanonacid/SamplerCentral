{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf600
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red191\green0\blue0;\red0\green0\blue0;\red0\green0\blue255;
\red51\green51\blue191;\red96\green96\blue96;\red0\green115\blue0;\red0\green0\blue191;\red255\green102\blue0;
\red102\green102\blue191;}
{\*\expandedcolortbl;;\csgenericrgb\c75000\c0\c0;\csgenericrgb\c0\c0\c0;\csgenericrgb\c0\c0\c100000;
\csgenericrgb\c20000\c20000\c75000;\csgenericrgb\c37500\c37500\c37500;\csgenericrgb\c0\c45000\c0;\csgenericrgb\c0\c0\c75000;\csgenericrgb\c100000\c40000\c0;
\csgenericrgb\c40000\c40000\c75000;}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 // CLOCK\cf3 \
\cf2 /*\
Knobs need sounds too, pitched relatively to values\
posibility to sync it with other sounds too.. such as a march\
its own volume slider? Also for conductor....\
Also receive sync from conductor..!\
maybe pause tdef when clock strikes the hour?\
speed slider for Tdef, not ms+steps. sync with rate of soundfile(s)\
	can sync over OSC with sampler or qlab\
		either rate/pitch or ticks to trigger keys on samplers.... ojojoj\
		for sounds that are part of Tdefs, different or additional sounds at higher speeds?\
		clock sequencer?\
		easier to make an ableton project?\
reset position to 0 on mouse up? what about homing...?\
MAKE REDCOMBISAMPLER AJAJ!\
SliderLooper\
\
Load last active preset on start\
clock "winding" sound, clockworks\
\
1.reverse at set speed until limit switch\
2.set current pos as zero\
3.find increment size that has effect POS+?\
4.find how many increments per revelation\
\
when should limit switch make the clock stop? not on SR at least\
PAN knob???\
*/\cf3 \
(\
s.waitForBoot\{\
\cf4 var\cf3  settings, n, m;\
\cf4 var\cf3  secWait= 1;\
\cf4 var\cf3  buffers= [\cf5 nil\cf3 , \cf5 nil\cf3 ];\
\cf4 var\cf3  s, out= 0, outputs, defaultout= 0, outbut;\
\cf4 var\cf3  player= [\cf6 "Buf"\cf3 , \cf6 "Buf"\cf3 ], chans= [2, 2], loadDialog, loadDialogSampler, loadFile;\
\cf4 var\cf3  button1, button2, errorFileMessage;\
\cf4 var\cf3  builtin= \cf5 false\cf3 , sendNetAddr, recieveNetAddr, localNetAddr;\
\cf4 var\cf3  saveDirectory, saveFiles, loadMenu, loadMenuItem, saveArchive, activePreset;\
\cf4 var\cf3  w, wb, tabs, knobView, playerView, verticalView;\
\cf4 var\cf3  minuteSlider, hourSlider, soundFilePath= [\cf5 nil\cf3 , \cf5 nil\cf3 ];\
\cf4 var\cf3  playBut, waitSlider, stepSlider, playerView2, resetBut, dirBut1, dirBut2, soundButtons;\
\cf4 var\cf3  soundButView, clockResp1, clockResp2, clockResp3;\
\cf4 var\cf3  minuteSteps= 100, hourSteps= 100;\
\cf4 var\cf3  clockSecTdefPaused= 0, minDir= 0, hourDir= 0;\
\cf4 var\cf3  tdefView, tdefMenu, tdefMenuItem, tdefs, currentTdef;\
\cf4 var\cf3  minPrevDir= \cf5 false\cf3 , hourPrevDir= \cf5 false\cf3 ;\
\cf4 var\cf3  lastMinVal= 0, lastHourVal= 0;\
\cf4 var\cf3  actualTimeNow, goToTime;\
\cf4 var\cf3  sampler, loadPreset, sounds, durations, numKeys, keyButs, keyNames, textcolors, colorsOn, colors;\
\cf2 //seq\cf3 \
\cf4 var\cf3  seqView, t, beat= 1, mute, muteButtons, length, rate, amp;\
\cf4 var\cf3  tempoSlider, playBut2, stopBut, topGrid, gridArray, clockArray, meter, freq;\
\cf4 var\cf3  columns= 16;\
\cf4 var\cf3  boxHeight= 16, boxSpace= 3, topSpace= 50;\
\cf4 var\cf3  tapTempoView, tapTempoGUI;\
\cf4 var\cf3  oscCom, oscVal, oscComButs, oscComButsItem, oscValButs, delayButs, delayVal;\
\cf4 var\cf3  lengthKnobs, rateKnobs, sendButs, sendOnOff, seqPaused= 0;\
\cf2 //simpleview\cf3 \
\cf4 var\cf3  simpleButView, simpleButtons, simpleButStates, simpleButActions, simpleTasks;\
\cf4 var\cf3  simpleTempoSlider, simpleResponders, simpleDingBut1, simpleDingBut2, simpleDingBut3;\
\cf2 //ape view\cf3 \
\cf4 var\cf3  apeButView, apeButtons, apeButStates, apeButActions, apeTasks;\
\cf4 var\cf3  apeTempoSlider, apeResponders1, apeResponders2;\
\cf4 var\cf3  minNB, hrNB;\
\cf2 //==\cf3 \
\cf4 var\cf3  sendOscKeyboard, sendOscKeyboardMenu, sendOscKeyboardMenuItem;\
\cf4 var\cf3  saveGrid, soundFileNames, speedMul= 1;\
\cf4 var\cf3  apeTasksPaused, simpleTasksPaused, manualView, stopAt12, dingBut1, dingBut2, dingBut3;\
\cf4 var\cf3  soundFilesWindowOpen= \cf5 false\cf3 , numSounds;\
\cf4 var\cf3  loadPresetBut, lastUsedPresetFile, lastUsedPreset,loadMenuItemsSymbolsArray, activePresetCurrent;\
\cf4 var\cf3  apeMinKnob, apeHourKnob, tickMinApeBut, sfWindow, panKnob, pan= 0;\
\
tdefs= [\cf7 \\clockSeconds\cf3 , \cf7 \\clockJam\cf3 ];\
currentTdef= \cf8 Tdef\cf3 (\cf7 \\clockSeconds\cf3 );\
\
s= \cf8 Server\cf3 .default;\
outputs= [\cf5 nil\cf3 , 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24];\
if (s.options.outDevice.contains(\cf6 "Built-in"\cf3 ), \{out= 0; builtin= \cf5 true\cf3 ; \});\
\
recieveNetAddr= \cf8 NetAddr\cf3 (\cf6 "127.0.0.1"\cf3 , \cf5 nil\cf3 ); \cf2 // local machine\cf3 \
sendNetAddr= \cf8 NetAddr\cf3 (\cf9 ~ipDict\cf3 [\cf7 \\clock\cf3 ][0], \cf9 ~ipDict\cf3 [\cf7 \\clock\cf3 ][1]);\
localNetAddr= \cf8 NetAddr\cf3 (\cf6 "127.0.0.1"\cf3 , 57120);\
\
soundButtons= \cf5 nil\cf3 !8;\
\
\cf2 //soundFilePath[0]= "/Volumes/MEDIA/Ableton/nedmixer/12spaten/metronomeWood1.wav";\cf3 \
\cf2 //soundFilePath[1]= "/Volumes/MEDIA/Ableton/nedmixer/12spaten/metronomeWood2.wav";\cf3 \
\
\cf9 ~clockOpen\cf3 = \cf5 true\cf3 ;\
\
numKeys= 16;\
numSounds= 24;\
sounds= \cf5 nil\cf3 !24;\
keyButs= \cf5 nil\cf3 !24;\
keyNames= \cf5 nil\cf3 !24;\
mute= 0!numKeys;\
muteButtons= \cf5 nil\cf3 !numKeys;\
oscCom= 0!8;\
oscVal= 0!8;\
oscComButs= 2!8;\
oscValButs= 0!8;\
delayButs= \cf5 nil\cf3 !24;\
delayVal= 0!24;\
oscComButsItem= \cf6 "ST1"\cf3 !8;\
length= 1!24;\
rate= 1!24;\
amp= 0.7!24;\
lengthKnobs= \cf5 nil\cf3 !24;\
rateKnobs= \cf5 nil\cf3 !24;\
sendButs= \cf5 nil\cf3 !8;\
sendOnOff= 0!8;\
soundFileNames= \cf6 "no file"\cf3 !24;\
durations= 0!24;\
apeTasksPaused= 0!4;\
simpleTasksPaused= 0!16;\
\
saveGrid= \cf8 Array2D\cf3 .new(numKeys, columns);\
\
sendOscKeyboardMenuItem= \cf6 "miditec MA 4"\cf3 ;\
\
sampler= \cf8 RedCombiSampler\cf3 (s, 15).overlaps_(4);\
\
actualTimeNow= \cf8 Date\cf3 .localtime;\
\
\cf2 /*\
actualTimeNow= Date.localtime;\
min go to:\
sendNetAddr.sendMsg("PS1"++(((steps360 / 60) * actualTimeNow.minute).asString));\
hour go to: (steps360 / 12) * actualTimeNow.hour.wrap(0, 11)\
sendNetAddr.sendMsg("PS1"++(((steps360 / 12) * actualTimeNow.minute.wrap(0, 11)).asString));\
steps360\
currentPositionInSteps1\
currentPositionInSteps1\
*/\cf3 \
\
\cf2 //settings= Dictionary.new;\cf3 \
\
colors= [\cf8 Color\cf3 .new255(160, 255, 160), \cf8 Color\cf3 .black, \cf8 Color\cf3 .white, \cf8 Color\cf3 .black, \cf8 Color\cf3 .white, \cf8 Color\cf3 .white, \cf8 Color\cf3 .black, \cf8 Color\cf3 .white, \cf8 Color\cf3 .black, \cf8 Color\cf3 .white, \cf8 Color\cf3 .black, \cf8 Color\cf3 .white];\
\
textcolors= [\cf8 Color\cf3 .black, \cf8 Color\cf3 .white, \cf8 Color\cf3 .black, \cf8 Color\cf3 .white, \cf8 Color\cf3 .black, \cf8 Color\cf3 .black, \cf8 Color\cf3 .white, \cf8 Color\cf3 .black, \cf8 Color\cf3 .white, \cf8 Color\cf3 .black, \cf8 Color\cf3 .white, \cf8 Color\cf3 .black];\
\
colorsOn= [\cf8 Color\cf3 .yellow.alpha_(0), \cf8 Color\cf3 .new255(255, 165, 0).alpha_(0), \cf8 Color\cf3 .yellow.alpha_(0), \cf8 Color\cf3 .new255(255, 165, 0).alpha_(0), \cf8 Color\cf3 .yellow.alpha_(0), \cf8 Color\cf3 .yellow.alpha_(0), \cf8 Color\cf3 .new255(255, 165, 0).alpha_(0), \cf8 Color\cf3 .yellow.alpha_(0), \cf8 Color\cf3 .new255(255, 165, 0).alpha_(0), \cf8 Color\cf3 .yellow.alpha_(0), \cf8 Color\cf3 .new255(255, 165, 0).alpha_(0), \cf8 Color\cf3 .yellow.alpha_(0)];\
\
\cf2 // ========== SYNTH DEFS ===============\cf3 \
\cf2 // mono + stereo + buf + diskin versions + 2 loopers JUST USE RedCombiSampler!!!!!\cf3 \
\cf8 SynthDef\cf3 (\cf7 \\clockBuf1\cf3 , \{\cf4 |buf, out= 0|\cf3 \
\cf8 Out\cf3 .ar(out, \cf8 PlayBuf\cf3 .ar(1, buf, doneAction:2))\
\}).add;\
\cf8 SynthDef\cf3 (\cf7 \\clockBuf2\cf3 , \{\cf4 |buf, out= 0|\cf3 \
\cf8 Out\cf3 .ar(out, \cf8 PlayBuf\cf3 .ar(2, buf, doneAction:2))\
\}).add;\
\cf8 SynthDef\cf3 (\cf7 \\clockDisk1\cf3 , \{\cf4 |buf, out= 0|\cf3 \
	\cf4 var\cf3  disk= \cf8 DiskIn\cf3 .ar(1, buf);\
	\cf8 FreeSelf\cf3 .kr(\cf8 Done\cf3 .kr(disk));\
\cf8 Out\cf3 .ar(out, disk)\
\}).add;\
\cf8 SynthDef\cf3 (\cf7 \\clockDisk2\cf3 , \{\cf4 |buf, out= 0|\cf3 \
	\cf4 var\cf3  disk= \cf8 DiskIn\cf3 .ar(2, buf);\
	\cf8 FreeSelf\cf3 .kr(\cf8 Done\cf3 .kr(disk));\
\cf8 Out\cf3 .ar(out, disk)\
\}).add;\
\cf8 SynthDef\cf3 (\cf7 \\clockLooperBuf1\cf3 , \{\cf4 |buf|\cf3 \
\cf8 Out\cf3 .ar(0, \cf8 PlayBuf\cf3 .ar(1, buf, loop:1)!2)\
\}).add;\
\cf8 SynthDef\cf3 (\cf7 \\clockLooperBuf2\cf3 , \{\cf4 |buf|\cf3 \
\cf8 Out\cf3 .ar(0, \cf8 PlayBuf\cf3 .ar(2, buf, loop:1))\
\}).add;\
\
buffers[0]= \cf8 Buffer\cf3 .read(s, \cf6 "/Volumes/MEDIA/Ableton/nedmixer/12spaten/metronomeWood1.wav"\cf3 );\
buffers[1]= \cf8 Buffer\cf3 .read(s, \cf6 "/Volumes/MEDIA/Ableton/nedmixer/12spaten/metronomeWood2.wav"\cf3 );\
\
\cf2 // ================ LOADING SAMPLES ================\cf3 \
\
\
loadPreset= \{\cf4 |paths, i|\cf3 \
	\cf4 var\cf3  folderName, fileName, num, midifile;\
	num= i.wrap(0, 11);\
	if (paths[0].isFolder, \cf2 //if file is a folder, load all on one key\cf3 \
			\{\cf5 nil\cf3 \},\{\
		\cf2 // if path is not folder, normal\cf3 \
	paths.do(\{ \cf4 |path, ii|\cf3 \
		fileName= path.basename.removeExtension;\
		if (path.isSoundFile, \{\
		\{sampler.freeKey((\cf6 "snd"\cf3 ++(i).asString).asSymbol);\}.try;\
		\cf2 //path.postln;\cf3 \
		sounds[i]= path;\
		sampler.prepareForPlay((\cf6 "snd"\cf3 ++(i).asString).asSymbol, sounds[i]);\
		\{ if ( (keyNames[i].class == \cf8 QStaticText\cf3 ), \
			\{ keyNames[i].string= path.basename.removeExtension; \}\
			);\
		soundFileNames[i]= path.basename.removeExtension;\
		 \}.defer;\
		\cf2 //properties[(i+ii)]= defaultProperties[0].deepCopy;\cf3 \
		durations[i]= sampler.length((\cf6 "snd"\cf3 ++(i).asString).asSymbol);\
		\
		\});\
	\});\
		\});\
	\};\
\
		loadDialog= \{ \cf4 | buffer, buttonView, samplerNum |\cf3 \
			\cf8 Dialog\cf3 .getPaths(\{ \cf4 arg\cf3  paths;\
				loadFile.value(paths, buffer, buttonView, samplerNum);\
				\},\{\
			\cf6 "cancelled"\cf3 .postln;\
			\});\
		\};\
		\
		loadDialogSampler= \{ \cf4 | i |\cf3 \
			\cf8 Dialog\cf3 .getPaths(\{ \cf4 arg\cf3  paths;\
				loadPreset.value(paths, i);\
				\},\{\
			\cf6 "cancelled"\cf3 .postln;\
			\});\
		\};\
\
\cf2 /*\
		loadFile= \{ |paths, buffer, buttonView, samplerNum|\
			//var maxnewsamples, numsliders;\
			case\
			\{paths.class == Array \} \{\
				if(paths[0].isSoundFile , \{\
				1.do(\{\
					var f, p, dur;\
					p= paths[0];\
					\{\
					//if (synOn, \{syn.free; synOn= false; \});\
					s.sync;\
					if (buffers[samplerNum-1].isNil.not, \{\
						if(player[samplerNum-1] == "Disk", \{ \{buffers[samplerNum-1].close\}.try; \});\
					s.sync;\
					buffers[samplerNum-1].free;\
					\});\
					//firstRun= true;\
					f= SoundFile.new;\
					f.openRead(p);\
					dur = f.numFrames/s.sampleRate;\
					//frames= f.numFrames;\
					//samplerate= f.sampleRate;\
					if (samplerNum == 1, \{ chans[0]= f.numChannels \}, \{chans[1]= f.numChannels\});\
					//currentPath= p;\
					s.sync;\
					if (dur > 7, \{\
						buffers[samplerNum-1] = Buffer.cueSoundFile(s, p, 0, chans[samplerNum-1]);\
						player[samplerNum-1]= "Disk";\
					\},\{	\
						buffers[samplerNum-1]= Buffer.read(s, p);\
						player[samplerNum-1]= "Buf";\
\
					\});\
					(p++" read").postln;\
					\{ buttonView.states= ([[p.basename.removeExtension, Color.white, Color.black]]) \}.defer;\
					//\{ title.stringColor= Color.white \}.defer; \
					//amp= 0.0; //set sensible amplitude as default\
					//outbut.valueAction= 0; pan= 0; panKnob.value= 0.5;\
					soundFilePath[samplerNum] = p;\
					\
					f.close;\
\
\
					\}.fork(AppClock);\
				\});\
				\
				\
				\},\{\
					errorFileMessage.value;\
				\});\
			\}\
		\};\
\
*/\cf3 \
\
\
\
\cf2 // =========== GUI ===============\cf3 \
\
w= \cf8 Window\cf3 (\cf6 "CLOCK"\cf3 , \cf8 Rect\cf3 (600, 655, 800, 440)).front;\
wb= w.bounds;\
tabs= \cf8 TabbedView\cf3 (w, \cf8 Rect\cf3 (0, 0, wb.width, wb.height-40), [\cf6 "Advanced Clock For Adventurous Minds"\cf3 , \cf6 "Simple Clock For Simple Minds"\cf3 , \cf6 "Clock For Apes"\cf3 ], [\cf8 Color\cf3 .new255(158, 158, 158), \cf8 Color\cf3 .new255(148, 148, 148), \cf8 Color\cf3 .new255(138, 138, 138)]).tabHeight_(20);\cf3 \expnd0\expndtw0\kerning0
\
tabs.labelColors_([\cf8 Color\cf3 .red, \cf8 Color\cf3 .blue, \cf8 Color\cf3 .green]);\
\pard\pardeftab560
\cf3 tabs.unfocusedColors_([\cf8 Color\cf3 .red.alpha_(0.3),\cf8 Color\cf3 .blue.alpha_(0.3), \cf8 Color\cf3 .green.alpha_(0.3)]);\
tabs.backgrounds_([\cf8 Color\cf3 .red.alpha_(0.1),\cf8 Color\cf3 .blue.alpha_(0.1), \cf8 Color\cf3 .green.alpha_(0.1)]);\kerning1\expnd0\expndtw0 \
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural
\cf3 \
w.view.keyDownAction= (\{\cf4 |view, char, mod, uni, key |\cf3 \
	\cf6 "keydown"\cf3 .postln;\
	if ( tabs.activeTab == 0, \{\
		if( uni == 32, \{\
			playBut2.valueAction= (playBut2.value+1).wrap(0, 1);\
			\});\
		\});\
	if ( tabs.activeTab == 2, \{\
		\cf6 "tab2"\cf3 .postln;\
		if( uni == 32, \{\
			\cf6 "tick"\cf3 .postln;\
			tickMinApeBut.valueAction= (tickMinApeBut.value+1).wrap(0, 1);\
		\});\
	\});\
	\});\
\
tabs.focus(2);\
\
\cf2 // ======= ADVANCED GUI ==========\cf3 \
\
\
dingBut1= \cf8 Button\cf3 (tabs.views[0], \cf8 Rect\cf3 (0, 15, 200, 20))\
	.states_([[\cf6 "no ding at 12 MINUTE arm"\cf3 , \cf8 Color\cf3 .white,\cf8 Color\cf3 .black], [\cf6 "ding at 12 MINUTE arm!!!"\cf3 , \cf8 Color\cf3 .black, \cf8 Color\cf3 .green]])\
	.canFocus_(\cf5 false\cf3 )\
	.action_(\{ \cf4 |v|\cf3 \
		if(v.value==1, \{\
			simpleDingBut1.value= 1;\
			clockResp1= \cf8 OSCFunc\cf3 .new(\{\cf4 |msg|\cf3 \
				\cf6 "play clockResp1 tick!"\cf3 .postln;\
				sampler.play(\cf6 "snd14"\cf3 .asSymbol, 0.01, durations[14]*length[14], amp: amp[14], speed: rate[14], out: out, pan: pan);\
				\}, \
				\cf7 '/END1'\cf3 , \cf2 //symbol to respond to\cf3 \
				\cf8 NetAddr\cf3 (\cf9 ~ipDict\cf3 [\cf7 \\clock\cf3 ][0], \cf9 ~ipDict\cf3 [\cf7 \\clock\cf3 ][1]) \cf2 // ip of sender\cf3 \
				);\
		\},\{\
			clockResp1.free;\
			simpleDingBut1.value= 0;\
		\});\
\});\
\
dingBut2= \cf8 Button\cf3 (tabs.views[0], \cf8 Rect\cf3 (0, 35, 200, 20))\
	.states_([[\cf6 "no ding at 12 HOUR arm"\cf3 , \cf8 Color\cf3 .white,\cf8 Color\cf3 .black], [\cf6 "ding at 12 HOUR arm!!!"\cf3 , \cf8 Color\cf3 .black, \cf8 Color\cf3 .green]])\
	.canFocus_(\cf5 false\cf3 )\
	.action_(\{ \cf4 |v|\cf3 \
		if(v.value==1, \{\
			if (clockResp3.isNil.not,\{\
				if (clockResp3.enabled, \{ clockResp3.free\});\
			\});\
			simpleDingBut2.value= 1;		\
			clockResp2= \cf8 OSCFunc\cf3 .new(\{\cf4 |msg|\cf3 \
				\cf6 "play clockResp2 tick!"\cf3 .postln;\
				sampler.play(\cf6 "snd14"\cf3 .asSymbol, 0.01, durations[14]*length[14], amp: amp[14], speed: rate[14], out: out, pan: pan);\
				if ( stopAt12 == 1, \{\
					\cf2 //stop all tasks\cf3 \
					if( t.isPlaying, \{ playBut2.action.value= 0; \});\
					apeTasks.do(\{\cf4 |it, i|\cf3  if (it.isPlaying, \{ apeButtons[i].valueAction= 0; \}); \});\
					simpleTasks.do(\{\cf4 |it, i|\cf3  if (it.isPlaying, \{ simpleButtons[i].valueAction= 0; \}); \});\
				\});\
				\}, \
				\cf7 '/END2'\cf3 , \cf2 //symbol to respond to\cf3 \
				\cf8 NetAddr\cf3 (\cf9 ~ipDict\cf3 [\cf7 \\clock\cf3 ][0], \cf9 ~ipDict\cf3 [\cf7 \\clock\cf3 ][1]) \cf2 // ip of sender\cf3 \
				);\
		\},\{\
			clockResp2.free;\
			simpleDingBut2.value= 0;\
		\});\
\});\
\
\
dingBut3= \cf8 Button\cf3 (tabs.views[0], \cf8 Rect\cf3 (0, 55, 200, 20))\
	.states_([[\cf6 "keep going"\cf3 , \cf8 Color\cf3 .white,\cf8 Color\cf3 .black], [\cf6 "stopping at 12 o clock!"\cf3 , \cf8 Color\cf3 .black, \cf8 Color\cf3 .red]])\
	.canFocus_(\cf5 false\cf3 )\
	.action_(\{ \cf4 |v|\cf3 \
		if(v.value==1, \{\
			stopAt12= 1;\
			simpleDingBut3.value= 1;\
			if (clockResp2.isNil.not,\{\
			if (clockResp2.enabled.not, \{\
				clockResp3= \cf8 OSCFunc\cf3 .new(\{\cf4 |msg|\cf3 \
				\cf6 "play clockResp3 tick!"\cf3 .postln;\
				if ( stopAt12 == 1, \{\
					\cf2 //stop all tasks\cf3 \
					if( t.isPlaying, \{ playBut2.action.value= 0; \});\
					apeTasks.do(\{\cf4 |it, i|\cf3  if (it.isPlaying, \{ apeButtons[i].valueAction= 0; \}); \});\
					simpleTasks.do(\{\cf4 |it, i|\cf3  if (it.isPlaying, \{ simpleButtons[i].valueAction= 0; \}); \});\
				\});\
				\}, \
				\cf7 '/END2'\cf3 , \cf2 //symbol to respond to\cf3 \
				\cf8 NetAddr\cf3 (\cf9 ~ipDict\cf3 [\cf7 \\clock\cf3 ][0], \cf9 ~ipDict\cf3 [\cf7 \\clock\cf3 ][1]) \cf2 // ip of sender\cf3 \
				);\
				\});\
			\});\
		\},\{\
			stopAt12= 0;\
			simpleDingBut3.value= 0;\
			if (clockResp3.isNil.not,\{\
				if (clockResp3.enabled, \{ clockResp3.free\});\
			\});\
		\});\
\});\
\
\cf2 //knobView= GUI.hLayoutView.new(w, Rect(0, 30, wb.width, 90));\cf3 \
\
\cf2 //check direction once before knob and separately for tdef, pausing too!\cf3 \
\
\
\cf2 // ============= MANUAL CONTROL ==============\cf3 \
\
manualView= \cf8 CompositeView\cf3 (tabs.views[0], \cf8 Rect\cf3 (20, 160, 180, 120));\
\
\cf8 StaticText\cf3 (manualView, \cf8 Rect\cf3 (0, 0, 150, 20)).string_(\cf6 "Manual Control:"\cf3 ).align_(\cf7 \\center\cf3 ).background_(\cf8 Color\cf3 .grey.alpha_(0.3));\
\
minuteSlider= \cf8 EZKnob\cf3 (manualView, \cf8 Rect\cf3 (0, 20, 50, 90), \cf6 "   mins"\cf3 , \cf8 ControlSpec\cf3 (-3000, 3000, \cf7 \\lin\cf3 , 1, 0, \cf6 "/SR1"\cf3 ), 	\{\
	\cf4 |ez|\cf3 \
	\cf4 var\cf3  val, dir;\
	dir= ez.value.isPositive;\
	val= ez.value;\
	if( val != lastMinVal, \{\
		sendNetAddr.sendMsg(\cf6 "SR1"\cf3 ++(val.asString));\
		(\cf6 "SR1"\cf3 ++(ez.value.asString)).postln;\
		if( currentTdef.isPlaying, \{ \
				currentTdef.stop; \
				clockSecTdefPaused= 1; \
				playBut.value= 0;\
				\cf6 "pausing Tdef!"\cf3 .postln;\
		\});\
		if( t.isPlaying, \{ \
				t.pause; \
				seqPaused= 1; \
				playBut2.value= 0;\
				\cf6 "pausing Seq!"\cf3 .postln;\
		\});\
		\cf2 // stop all other tasks\cf3 \
		apeTasks.do(\{\cf4 |it, i|\cf3  if (it.isPlaying, \{ \
			\cf2 //apeButtons[i].value= 0;\cf3 \
			apeTasks[i].pause;\
			apeTasksPaused[i]= 1;\
			\}); \
		\});\
		simpleTasks.do(\{\cf4 |it, i|\cf3  if (it.isPlaying, \{ \
			\cf2 //simpleButtons[i].value= 0;\cf3 \
			simpleTasks[i].pause;\
			simpleTasksPaused[i]= 1;\
			\}); \
		\});\
		\
		lastMinVal= val;\
		if (sampler.isPlaying(\cf7 \\snd16\cf3 ), \{\
			sampler.set(\cf7 \\snd16\cf3 ).speed_(ez.value.abs.linexp(400, 3000, 1, 1.5));\
		\},\{\
		sampler.play(\cf7 \\snd16\cf3 , 0.01, durations[16]*length[16], 0, amp: amp[16], loop: 1, speed: ez.value.abs.linexp(400, 3000, 1, 1.5), out: out, pan: pan);\
		\});\
		\});\
	\});\
minuteSlider.view.mouseUpAction= (\{ \cf4 |view, x, y, mod|\cf3 \
			if (mod.isShift.not, \{\
				minuteSlider.value= 0;\
				lastMinVal= 0;\
				sendNetAddr.sendMsg(\cf6 "SR1"\cf3 ++(0.asString));\
				if (clockSecTdefPaused == 1, \{\
					currentTdef.play(\cf8 AppClock\cf3 ); clockSecTdefPaused= 0; \
					playBut.value= 1;\
				\});\
				if (seqPaused == 1, \{\
					t.play; seqPaused= 0; \
					playBut2.value= 1;\
				\});\
				apeTasks.do(\{\cf4 |it, i|\cf3  if (apeTasksPaused[i] == 1, \{ \
					if (apeButtons[i].value == 1, \{\
						apeTasks[i].play;\
						apeTasksPaused[i]= 0;\
					\},\{\
						apeTasks[i].stop; apeTasks[i].reset;\
						apeTasksPaused[i]= 0;\
						\}\
					);\
				\}); \
				\});\
				simpleTasks.do(\{\cf4 |it, i|\cf3  if (simpleTasksPaused[i] == 1, \{ \
					if ( simpleButtons[i].value == 1, \{\
						simpleTasks[i].play;\
						simpleTasksPaused[i]= 0;\
					\},\{\
						simpleTasks[i].stop; simpleTasks[i].reset;\
						simpleTasksPaused[i]= 0;\
					\});\
				\}); \
				\});\
				if (sampler.isPlaying(\cf7 \\snd16\cf3 ), \{\
					sampler.stop(\cf7 \\snd16\cf3 , 0.01);\
					\});\
				sampler.play(\cf7 \\snd18\cf3 , 0.01, durations[18]*length[18], 0, amp: amp[18], speed: rate[18], out: out, pan: pan);\
			\}) \});\
\
\cf2 //Knob(manualView, Rect(55, 90, 20, 20)).canFocus_(false);\cf3 \
\cf2 //Knob(manualView, Rect(75, 90, 20, 20)).centered_(true).canFocus_(false);\cf3 \
\
hourSlider= \cf8 EZKnob\cf3 (manualView, \cf8 Rect\cf3 (100, 20, 50, 90), \cf6 "  hours"\cf3 , \cf8 ControlSpec\cf3 (-3000, 3000, \cf7 \\lin\cf3 , 1, 0, \cf6 "/SR2"\cf3 ), 	\{\
		\cf4 |ez|\cf3 \
		\cf4 var\cf3  val;\
		val= ez.value;\
		if( val != lastHourVal, \{\
			sendNetAddr.sendMsg(\cf6 "SR2"\cf3 ++(val.asString));\
			(\cf6 "SR2"\cf3 ++(ez.value.asString)).postln;\
			lastHourVal= val;\
			if (sampler.isPlaying(\cf7 \\snd17\cf3 ), \{\
				sampler.set(\cf7 \\snd17\cf3 ).speed_(ez.value.abs.linexp(400, 3000, 1, 1.5));\
			\},\{\
				sampler.play(\cf7 \\snd17\cf3 , 0.01, durations[16]*length[16], 0, amp: amp[16], loop: 1, speed: ez.value.abs.linexp(400, 3000, 1, 1.5), out: out, pan: pan);\
			\});\
		\});\
	\});\
hourSlider.view.mouseUpAction= (\{ \cf4 |view, x, y, mod|\cf3 \
			if (mod.isShift.not, \{ \
				hourSlider.value= 0;\
				lastHourVal= 0;\
				sendNetAddr.sendMsg(\cf6 "SR2"\cf3 ++(0.asString));\
				if (sampler.isPlaying(\cf7 \\snd17\cf3 ), \{\
					sampler.stop(\cf7 \\snd17\cf3 , 0.01);\
				\});\
				sampler.play(\cf7 \\snd19\cf3 , 0.01, durations[19]*length[19], 0, amp: amp[19], speed: rate[19], out: out, pan: pan);\
			\});\
		\});\
\
\cf2 /*\
// player\
tdefView= GUI.hLayoutView.new(tabs.views[0], Rect(0, 165, wb.width, 20));\
tdefMenu= PopUpMenu(tdefView, Rect(0, 0, 130, 20)) // -----\
		.items_(tdefs)\
		.canFocus_(false)\
		.background_(Color.white)\
		.font_(Font("Helvetica", 10))\
		.action_(\{|v|\
			tdefMenuItem= v.items.at(v.value);\
		\});\
		\
		//load preset\
Button(tdefView, Rect(0, 0, 20, 20)) // ------\
		.states_([["L", Color.red, Color.black]])\
		.canFocus_(false)\
		.font_(Font("Helvetica", 10))\
		.action_(\{ \
			if(currentTdef.isPlaying, \{ currentTdef.stop; playBut.value= 0 \});			currentTdef= Tdef(tdefMenuItem);\
		 \});\
\
playerView= GUI.hLayoutView.new(tabs.views[0], Rect(0, 190, wb.width, 30));\
\
\
playBut= Button(playerView, Rect(0, 0, 50, 30))\
	.states_([["|>", Color.red, Color.black], ["|>", Color.green, Color.black]])\
	.canFocus_(false)\
	.action_(\{|v|\
		if (v.value == 1, \{currentTdef.play(AppClock);\}, \{currentTdef.stop;\})\
		\});\
\
resetBut= Button(playerView, Rect(0, 0, 50, 30))\
	.states_([["reset", Color.red, Color.black]])\
	.canFocus_(false)\
	.action_(\{|v|\
		currentTdef.reset;\
	\});\
\
dirBut1= Button(playerView, Rect(0, 0, 50, 30))\
	.states_([["-->", Color.black, Color.white], ["<--", Color.white, Color.black]])\
	.canFocus_(false)\
	.action_(\{|v|\
		minDir= v.value;\
		sendNetAddr.sendMsg("DR1"++(v.value.asString));\
	\});\
	\
dirBut2= Button(playerView, Rect(0, 0, 50, 30))\
	.states_([["-->", Color.black, Color.white], ["<--", Color.white, Color.black]])\
	.canFocus_(false)\
	.action_(\{|v|\
		hourDir= v.value;\
		sendNetAddr.sendMsg("DR2"++(v.value.asString));\
	\});\
\
\
//playerView2= GUI.hLayoutView.new(w, Rect(0, 160, wb.width, 30));\
\
waitSlider= EZSlider(tabs.views[0], Rect(0, 230, 200, 20), "ms", ControlSpec(0, 5000, \\lin, 1, 1000), \{\
	|ez|\
	secWait= ez.value / 1000;\
	\},\
	labelWidth:20,\
	numberWidth: 35\
	);\
\
stepSlider= EZSlider(tabs.views[0], Rect(0, 250, 200, 20), "stp", ControlSpec(0, 500, \\lin, 1, 100), \{\
	|ez|\
	minuteSteps= ez.value;\
	\},\
	labelWidth:20,\
	numberWidth: 35\
	);\
\
// TWO BUTTONS TO LOAD SAMPLES\
soundButView= GUI.hLayoutView.new(tabs.views[0], Rect(0, 280, wb.width, 30));\
\
	soundButtons[0]= Button(soundButView, Rect(0, 0, 100, 40))\
		.states_([["minSound", Color.white, Color.black]])\
		.mouseDownAction_(\{ |view, x, y, mod|\
			if (mod.isShift, \{loadDialog.value(buffers[0], view, 1)\});\
			if (mod.isAlt, \{ buffers[0].free; "remove file".postln;\});\
			if (mod.isCtrl, \{ \
				Synth("clock"++player[0]++chans[0], [\\buf, buffers[0].bufnum, \\out, out]);\
			\});\
		\})\
		.canFocus_(false)\
		.canReceiveDragHandler_(true)\
		.receiveDragHandler_(\{|view|\
			var paths;\
			paths= View.currentDrag;\
			if(paths.isString, \{paths= [paths];\}); // qt compatibility..\
			loadFile.value(paths, buffers[0], view, 1);\
		\});\
\
	soundButtons[1]= Button(soundButView, Rect(0, 0, 100, 40))\
		.states_([["hourSound", Color.white, Color.black]])\
		.mouseDownAction_(\{ |view, x, y, mod|\
			if (mod.isShift, \{loadDialog.value(buffers[1], view, 2)\});\
			if (mod.isAlt, \{ buffers[1].free; "remove file".postln;\});\
			if (mod.isCtrl, \{ \
				Synth("clock"++player[1]++chans[1], [\\buf, buffers[1].bufnum, \\out, out]);\
			\});\
		\})\
		.canFocus_(false)\
		.canReceiveDragHandler_(true)\
		.receiveDragHandler_(\{|view|\
			var paths;\
			paths= View.currentDrag;\
			if(paths.isString, \{paths= [paths];\}); // qt compatibility..\
			loadFile.value(paths, buffers[1], view, 2);\
		\});\
		\
*/\cf3 \
\
goToTime = \{\cf4 |time|\cf3 \
	\cf4 var\cf3  minutes, hours;\
	hours= time[0];\
	minutes= time[1];\
	\
	\cf2 // stop all other tasks\cf3 \
	apeTasks.do(\{\cf4 |it, i|\cf3  if (it.isPlaying, \{ apeButtons[i].valueAction= 0; \}); \});\
	if( t.isPlaying, \{ stopBut.action.value; \});\
	simpleTasks.do(\{\cf4 |it, i|\cf3  if (it.isPlaying, \{ simpleButtons[i].valueAction= 0; \}); \});\
\
	minutes= minutes*33;\
	hours= hours*166;\
	\
	sendNetAddr.sendMsg(\cf6 "SR1"\cf3 ++(300.asString));\
	sendNetAddr.sendMsg(\cf6 "SR2"\cf3 ++(300.asString));\
	\
	\cf8 OSCFunc\cf3 .new(\{\cf4 |msg|\cf3 \
		\cf6 "endpoint minute arm"\cf3 .postln;\
		\{sendNetAddr.sendMsg(\cf6 "PS1"\cf3 ++(minutes.asString));\}.defer(0.5);\
		\}, \
		\cf7 '/END1'\cf3 , \cf2 //symbol to respond to\cf3 \
		\cf8 NetAddr\cf3 (\cf9 ~ipDict\cf3 [\cf7 \\clock\cf3 ][0], \cf9 ~ipDict\cf3 [\cf7 \\clock\cf3 ][1]) \cf2 // ip of sender\cf3 \
	).oneShot;\
\
	\cf8 OSCFunc\cf3 .new(\{\cf4 |msg|\cf3 \
		\cf6 "endpoint hour arm"\cf3 .postln;\
		\{sendNetAddr.sendMsg(\cf6 "PS2"\cf3 ++(hours.asString)); \}.defer(0.5);\
		\}, \
		\cf7 '/END2'\cf3 , \cf2 //symbol to respond to\cf3 \
		\cf8 NetAddr\cf3 (\cf9 ~ipDict\cf3 [\cf7 \\clock\cf3 ][0], \cf9 ~ipDict\cf3 [\cf7 \\clock\cf3 ][1]) \cf2 // ip of sender\cf3 \
	).oneShot;\
\};\
\
\cf2 // ================= SEQUENCER ================\cf3 \
\
\
seqView= \cf8 CompositeView\cf3 (tabs.views[0], \cf8 Rect\cf3 (200, 15, 600, 650))\
.background_(\cf8 Color\cf3 .grey.alpha_(0.3));\
\
tempoSlider= \cf8 EZSlider\cf3 (seqView,  	\
	\cf8 Rect\cf3 (10, 0, 180, boxHeight),\
	\cf6 "bpm"\cf3 ,	\cf2 // label\cf3 \
	[20, 400, \cf7 \\lin\cf3 , 1, 120, \cf6 "tempo"\cf3 ].asSpec, \cf2 // controlSpec\cf3 \
	\{\cf4 |ez|\cf3  t.clock.tempo_(ez.value/60); \}, \cf2 // action\cf3 \
	120, \cf2 // init value, set from A DICTIONARY\cf3 \
	labelWidth: 30,\
	numberWidth: 30\
	)\
	.setColors(\
		\cf5 nil\cf3 , \cf2 //string backgr\cf3 \
		\cf8 Color\cf3 .white, \cf2 //string\cf3 \
		\cf8 Color\cf3 (0.298, 0.298, 0.298, 1.0), \cf2 //slider backgr\cf3 \
		\cf8 Color\cf3 .grey, \cf2 //num backgr\cf3 \
		\cf8 Color\cf3 .white, \cf2 //num clr\cf3 \
		\cf5 nil\cf3 ,\
		\cf5 nil\cf3 ,\
		\cf8 Color\cf3 (0.298, 0.776, 1.0, 1.0) \cf2 //knob clr\cf3 \
);\
\
playBut2 = \cf8 RoundButton\cf3 ( seqView, \cf8 Rect\cf3 (10, 25, 50, 20) )\
.canFocus_(\cf5 false\cf3 )\
.states_([[ \cf7 \\play\cf3 , \cf8 Color\cf3 .black, \cf8 Color\cf3 .cyan.alpha_(0.3) ], [\cf7 \\pause\cf3 , \cf8 Color\cf3 .black, \cf8 Color\cf3 .green]] )\
.action_(\{\cf4 |v|\cf3  if(v.value == 1, \{t.play\}, \{t.pause\}) \});\
\
stopBut = \cf8 RoundButton\cf3 ( seqView, \cf8 Rect\cf3 (60, 25, 40, 20) )\
.canFocus_(\cf5 false\cf3 )\
.states_([[ \cf7 \\stop\cf3 , \cf8 Color\cf3 .black, \cf8 Color\cf3 .grey ]] )\
.action_(\{ t.stop; t.reset; playBut2.value= 0; \});\
\
\cf8 RoundButton\cf3 ( seqView, \cf8 Rect\cf3 (100, 25, 40, 20) )\
.canFocus_(\cf5 false\cf3 )\
.states_([[ \cf7 \\return\cf3 , \cf8 Color\cf3 .black, \cf8 Color\cf3 .grey ]] )\
.action_(\{ t.reset; \});\
\
\cf8 StaticText\cf3 (tabs.views[0], \cf8 Rect\cf3 (640, 3, 160, 10))\
.string_(\cf6 "[S] trigger note on keyboard:"\cf3 )\
.font_(\cf8 Font\cf3 (\cf6 "monaco"\cf3 , 9));\
\
sendOscKeyboardMenu= \cf8 PopUpMenu\cf3 (seqView, \cf8 Rect\cf3 (440, 0, 150, 20))\
.canFocus_(\cf5 false\cf3 )\
.items_(\cf9 ~samplerNames\cf3 )\
.action_(\{\cf4 |v|\cf3  sendOscKeyboardMenuItem= v.item \});\
\
(numKeys/2).do(\{\cf4 arg\cf3  i;\
	keyNames[i]= \cf8 StaticText\cf3 (seqView, \cf8 Rect\cf3 (15, (boxHeight+boxSpace)*((i-numKeys).abs)+topSpace-(boxHeight+boxSpace), 90, 20))\
	.string_(\cf6 "sound"\cf3 +(i+1));\
	\
	keyButs[i]= \cf8 Slider\cf3 (seqView, \cf8 Rect\cf3 (10, (boxHeight+boxSpace)*((i-numKeys).abs)+topSpace-(boxHeight+boxSpace), 90, 20))\
	\cf2 //.states_([["sound"+(i+1), Color.black, Color.white]])\cf3 \
	.background_(\cf8 Color\cf3 .grey.alpha_(0))\
	.thumbSize_(8)\
	.canFocus_(\cf5 false\cf3 )\
	.value_(0.7)\
	.action_(\{\cf4 |v|\cf3  amp[i]= v.value; \})\
	.canReceiveDragHandler_(\cf5 true\cf3 )\
	.receiveDragHandler_(\{\cf4 |view|\cf3 \
		\cf4 var\cf3  paths;\
		paths= \cf8 View\cf3 .currentDrag;\
		paths.postln;\
		if(paths.isString, \{paths= [paths];\}); \cf2 // qt compatibility..\cf3 \
		paths.postln;\
		loadPreset.value(paths, i);\
	\});\
\
	lengthKnobs[i]= \cf8 Knob\cf3 (seqView, \cf8 Rect\cf3 (100, (boxHeight+boxSpace)*((i-numKeys).abs)+topSpace-(boxHeight+boxSpace), 20, 20))\
	.canFocus_(\cf5 false\cf3 )\
	.value_(length[i])\
	.action_(\{\cf4 |v|\cf3  length[i]= v.value\});\
	\
	rateKnobs[i]= \cf8 Knob\cf3 (seqView, \cf8 Rect\cf3 (120, (boxHeight+boxSpace)*((i-numKeys).abs)+topSpace-(boxHeight+boxSpace), 20, 20))\
	.canFocus_(\cf5 false\cf3 )\
	.value_(rate[i])\
	.centered_(\cf5 true\cf3 )\
	.action_(\{\cf4 |v|\cf3  rate[i]= v.value; v.value.postln;\});\
	\
	sendButs[i]= \cf8 Button\cf3 (seqView, \cf8 Rect\cf3 (140, (boxHeight+boxSpace)*((i-numKeys).abs)+topSpace-(boxHeight+boxSpace), 20, 20))\
	.states_([[\cf6 "S"\cf3 , \cf8 Color\cf3 .black, \cf8 Color\cf3 .white], [\cf6 "S"\cf3 , \cf8 Color\cf3 .black, \cf8 Color\cf3 .green]])\
	.canFocus_(\cf5 false\cf3 )\
	.value_(0)\
	.action_(\{\cf4 |v|\cf3  sendOnOff[i]= v.value \});\
\
\
\});\
\
(numKeys/2).do(\{\cf4 arg\cf3  i;\
	oscComButs[i]= \cf8 PopUpMenu\cf3 (seqView, \cf8 Rect\cf3 (10, (boxHeight+boxSpace)*(((i+8)-numKeys).abs)+topSpace-(boxHeight+boxSpace), 55, 20))\
	.canFocus_(\cf5 false\cf3 )\
	.items_([\cf6 "ST1"\cf3 , \cf6 "PS1"\cf3 , \cf6 "SR1"\cf3 , \cf6 "ST2"\cf3 , \cf6 "PS2"\cf3 , \cf6 "SR2"\cf3 ])\
	.action_(\{\cf4 |v|\cf3  oscCom[i]= v.value; oscComButsItem[i]= v.item; \});\
oscValButs[i]= \cf8 NumberBox\cf3 (seqView, \cf8 Rect\cf3 (65, (boxHeight+boxSpace)*(((i+8)-numKeys).abs)+topSpace-(boxHeight+boxSpace), 55, 20))\
	.value_(0)\
	.action_(\{\cf4 |v|\cf3  oscVal[i]= v.value \});\
\});\
\
\cf8 StaticText\cf3 (seqView, \cf8 Rect\cf3 (530, 25, 50, 30)).string_(\cf6 "delay: (ms)"\cf3 ).align_(\cf7 \\center\cf3 );\
\
(numKeys).do(\{\cf4 arg\cf3  i;\
	delayButs[i]= \cf8 NumberBox\cf3 (seqView, \cf8 Rect\cf3 (530, (boxHeight+boxSpace)*(((i)-numKeys).abs)+topSpace-(boxHeight+boxSpace), 50, 18))\
	\cf2 //.canFocus_(false)\cf3 \
	.value_(0)\
	.clipLo_(0)\
	.clipHi_(1000)\
	.alt_scale_(1)\
	.action_(\{\cf4 |v|\cf3  delayVal[i]= v.value \});\
\});\
\
\
topGrid = \cf8 BoxGrid\cf3 .new(seqView, bounds: \cf8 Rect\cf3 (160, 25, 360, boxHeight), columns: columns, rows: 1)\
.setFillMode_(\cf5 true\cf3 )\
.setFillColor_(\cf8 Color\cf3 .red)\
	.setBackgrDrawFunc_(\{\
		16.do(\{\cf4 arg\cf3  i;\
			if((i==0)||(i==4)||(i==8)||(i==12)||(i==16),\{\
			\cf8 GUI\cf3 .pen.fillColor = \cf8 Color\cf3 .new255(60, 60, 60).alpha_(0.5);\
			\},\{\
			\cf8 GUI\cf3 .pen.fillColor = \cf8 Color\cf3 .new255(255, 255, 255).alpha_(0.5);\
			\});\
			\cf8 GUI\cf3 .pen.fillRect(\cf8 Rect\cf3 (1+(i*(360/columns)), 0, 360/columns, 240));\
		\})\
	\});\
\
gridArray = \cf8 Array\cf3 .fill(numKeys, \{\cf4 arg\cf3  i;\
	\cf8 BoxGrid\cf3 .new(seqView, bounds: \cf8 Rect\cf3 (160, (boxHeight+boxSpace)*((i-numKeys).abs)+topSpace-(boxHeight+boxSpace), 360, boxHeight), columns: columns, rows: 1)\
	.setFillMode_(\cf5 true\cf3 )\
	.setFillColor_(\cf8 Color\cf3 .green)\
	.setBackgrColor_(colors[i.wrap(0, 11)])\
	.setBackgrDrawFunc_(\{\
		16.do(\{\cf4 arg\cf3  i;\
			if((i==0)||(i==4)||(i==8)||(i==12)||(i==16),\{\
			\cf8 GUI\cf3 .pen.fillColor = \cf8 Color\cf3 .new255(60, 60, 60).alpha_(0.5);\
			\},\{\
			\cf8 GUI\cf3 .pen.fillColor = \cf8 Color\cf3 .new255(255, 255, 255).alpha_(0.5);\
			\});\
			\cf8 GUI\cf3 .pen.fillRect(\cf8 Rect\cf3 (1+(i*(360/16)), 0, 360/16, 240));\
		\})\
	\});\
\});\
 \cf2 // ----------  SEQUENCER TASK -----------\cf3 \
t= \cf8 Task\cf3 (\{\
	\cf5 inf\cf3 .do(\{\cf4 |i|\cf3 \
		beat= i%columns;\
\{topGrid.setState_( i%columns, 0, 1)\}.defer;\
\{topGrid.setState_( i%columns, 0, 0)\}.defer(\cf10 thisThread\cf3 .clock.beatDur);\
\
numKeys.do(\{\cf4 arg\cf3  ii;\
if(gridArray[ii].getState(i%16, 0) == 1, \{\
	if(mute[ii].value==0, \{\
		if(ii > 7, \{ \cf2 // send OSC\cf3 \
			\{\
			sendNetAddr.sendMsg(oscComButsItem[ii-8]++(oscVal[ii-8].asString));\
			(\cf6 "sending"\cf3 +(oscComButsItem[ii-8]++(oscVal[ii-8].asString))).postln;\
			\}.defer(delayVal[ii]/1000);\
		\},\{ \
			\{\
			if(sendOnOff[ii].value==1, \{\
				localNetAddr.sendMsg(sendOscKeyboardMenuItem, \cf7 \\noteon\cf3 , ii);\
				\},\{\
			if(sounds[ii].isNil.not, \{ \cf2 //play sound\cf3 \
		\cf2 //playnote.value(nil, ii, ii, nil, nil, length[ii].value);\cf3 \
		\cf2 //playnote.value(nil, ii, ii, nil, nil);\cf3 \
		\cf2 //\{stopnote.value(ii, ii)\}.defer(length[ii].value);\cf3 \
				sampler.play((\cf6 "snd"\cf3 ++(ii).asString).asSymbol, 0.01, 0, length[ii], amp: amp[ii], speed: rate[ii], out: out, pan: pan);\
			\});\
			\});\
			\}.defer(delayVal[ii]/1000);\
		\});\
	\});\
\});\
\});\
1.wait;\
	\});\
\}, \cf8 TempoClock\cf3 (120/60));\
\
tapTempoView= \cf8 CompositeView\cf3 (seqView, \cf8 Rect\cf3 (200, 0, 230, 20));\
tapTempoGUI= \cf8 RedTapTempoGUI\cf3 (t.clock, 4, 3, s, tapTempoView);\
\
seqView.onClose = \{tapTempoGUI.close; t.stop; \};\
\
\cf2 // ================ SIMPLE GUI ================\cf3 \
\
simpleButStates= [\
\cf6 "simple tick tock"\cf3 ,\
\cf6 "slow"\cf3 ,\
\cf6 "fast"\cf3 ,\
\cf6 "faster"\cf3 \
];\
\
simpleTasks= [\
	\cf8 Task\cf3 (\{\
		\cf5 inf\cf3 .do(\{\cf4 |i|\cf3 \
		\cf2 //sendNetAddr.sendMsg(ST1++(20.asString));\cf3 \
		(\cf6 "standard"\cf3 +\cf6 "taskplay"\cf3 +i).postln;\
		if ((i%60) == 1, \{ \cf6 "hour.postln"\cf3  \});\
		1.wait;\
		\});\
	\}, \cf8 TempoClock\cf3 (60/60)),\
	\cf8 Task\cf3 (\{\
		\cf5 inf\cf3 .do(\{\cf4 |i|\cf3 \
		\cf2 //sendNetAddr.sendMsg(ST1++(20.asString));\cf3 \
		(\cf6 "slow??"\cf3 +\cf6 "taskplay"\cf3 +i).postln;\
		1.wait;\
		\});\
	\}, \cf8 TempoClock\cf3 (120/60)),\
	\cf8 Task\cf3 (\{\
		\cf5 inf\cf3 .do(\{\cf4 |i|\cf3 \
		\cf2 //sendNetAddr.sendMsg(ST1++(20.asString));\cf3 \
		(\cf6 "fast!!"\cf3 +\cf6 "taskplay"\cf3 +i).postln;\
		1.wait;\
		\});\
	\}, \cf8 TempoClock\cf3 (120/60)),\
	\cf8 Task\cf3 (\{\
		\cf5 inf\cf3 .do(\{\cf4 |i|\cf3 \
		\cf2 //sendNetAddr.sendMsg(ST1++(20.asString));\cf3 \
		(\cf6 "faster"\cf3 +\cf6 "taskplay"\cf3 +i).postln;\
		1.wait;\
		\});\
	\}, \cf8 TempoClock\cf3 (120/60))\
	\
];\
\
simpleResponders= [];\
\
simpleButActions= [\
\{1.postln;\},\
\{2.postln;\},\
\{3.postln;\},\
\{4.postln;\}\
];\
\
simpleButView= \cf8 CompositeView\cf3 (tabs.views[1], \cf8 Rect\cf3 (200, 15, 600, 650))\
.background_(\cf8 Color\cf3 .grey.alpha_(0.3));\
simpleButView.decorator= \cf8 FlowLayout\cf3 (simpleButView.bounds);\
\
simpleButtons= simpleButStates.collect(\{ \cf4 |it, i|\cf3 \
	\cf8 Button\cf3 (simpleButView, \cf8 Rect\cf3 (0, 0, 100, 40))\
	.states_([[it, \cf8 Color\cf3 .white, \cf8 Color\cf3 .black],[it, \cf8 Color\cf3 .black, \cf8 Color\cf3 .green ]])\
	.canFocus_(\cf5 false\cf3 )\
	.action_(\{\cf4 |v|\cf3 \
		if (v.value == 1, \{\
			\cf2 //stop and reset any other tasks if playing\cf3 \
			simpleTasks.do(\{\cf4 |t, i|\cf3  if (t.isPlaying, \{ t.stop; t.reset; simpleButtons[i].value= 0; \}); \});\
			\cf2 //also stop tasks in advanced mode\cf3 \
			if (t.isPlaying, \{ t.stop; t.reset;\});\
			\cf2 //start this task\cf3 \
			simpleTasks[i].play;\
			simpleButActions[i].value;\
			simpleTempoSlider.value= simpleTasks[i].clock.tempo*60;\
			\},\{\
			\cf2 //stop this tdef, pause or stop and reset? if pause it needs 3 states\cf3 \
			simpleTasks[i].stop; simpleTasks[i].reset;\
			(\cf6 "stop"\cf3 +i).postln;\
		\});\
	\});\
\});\
\
\cf8 StaticText\cf3 (tabs.views[1], \cf8 Rect\cf3 (20, 20, 120, 20)).string_(\cf6 "Minute Arm:"\cf3 ).align_(\cf7 \\center\cf3 );\
\
simpleDingBut1= \cf8 Button\cf3 (tabs.views[1], \cf8 Rect\cf3 (20, 40, 120, 60))\
.states_([[\cf6 "no dingdong at 12"\cf3 , \cf8 Color\cf3 .white, \cf8 Color\cf3 .black],[\cf6 "dingdong at 12!!!"\cf3 , \cf8 Color\cf3 .black, \cf8 Color\cf3 .green ]])\
.canFocus_(\cf5 false\cf3 )\
.action_(\{\cf4 |v|\cf3 \
		if (v.value == 1, \{\
			dingBut1.valueAction= 1;\
		\},\{\
			dingBut1.valueAction= 0;\
		\});\
\});\
\
\cf8 StaticText\cf3 (tabs.views[1], \cf8 Rect\cf3 (20, 120, 120, 20)).string_(\cf6 "Hour Arm:"\cf3 ).align_(\cf7 \\center\cf3 );\
\
simpleDingBut2= \cf8 Button\cf3 (tabs.views[1], \cf8 Rect\cf3 (20, 140, 120, 60))\
.states_([[\cf6 "no dingdong at 12"\cf3 , \cf8 Color\cf3 .white, \cf8 Color\cf3 .black],[\cf6 "dingdong at 12!!!"\cf3 , \cf8 Color\cf3 .black, \cf8 Color\cf3 .green ]])\
.canFocus_(\cf5 false\cf3 )\
.action_(\{\cf4 |v|\cf3 \
		if (v.value == 1, \{\
			dingBut2.valueAction= 1;\
		\},\{\
			dingBut2.valueAction= 0;\
		\});\
\});\
\
\cf8 StaticText\cf3 (tabs.views[1], \cf8 Rect\cf3 (20, 220, 120, 20)).string_(\cf6 "stop at 12?:"\cf3 ).align_(\cf7 \\center\cf3 );\
\
simpleDingBut3= \cf8 Button\cf3 (tabs.views[1], \cf8 Rect\cf3 (20, 240, 120, 60))\
.states_([[\cf6 "keep going"\cf3 , \cf8 Color\cf3 .white, \cf8 Color\cf3 .black],[\cf6 "stopping at 12!"\cf3 , \cf8 Color\cf3 .black, \cf8 Color\cf3 .red ]])\
.canFocus_(\cf5 false\cf3 )\
.action_(\{\cf4 |v|\cf3 \
		if (v.value == 1, \{\
			dingBut3.valueAction= 1;\
		\},\{\
			dingBut3.valueAction= 0;\
		\});\
\});\
\
simpleTempoSlider= \cf8 EZSlider\cf3 (tabs.views[1],  	\
	\cf8 Rect\cf3 (150, 15, 40, 360),\
	\cf6 " BPM"\cf3 ,	\cf2 // label\cf3 \
	[10, 400, \cf7 \\lin\cf3 , 1, 120, \cf6 "tempo"\cf3 ].asSpec, \cf2 // controlSpec\cf3 \
	\{\cf4 |ez|\cf3  \cf2 // action\cf3 \
		simpleTasks.do(\{\cf4 |t, i|\cf3  if (t.isPlaying, \{ t.clock.tempo_(ez.value/60); \}); \});\
		apeTempoSlider.value= ez.value;\
		\}, \
	120, \cf2 // init value, set from A DICTIONARY\cf3 \
	layout: \cf7 \\vert\cf3 \
	)\
	.setColors(\
		\cf5 nil\cf3 , \cf2 //string backgr\cf3 \
		\cf8 Color\cf3 .white, \cf2 //string\cf3 \
		\cf8 Color\cf3 (0.298, 0.298, 0.298, 1.0), \cf2 //slider backgr\cf3 \
		\cf8 Color\cf3 .grey, \cf2 //num backgr\cf3 \
		\cf8 Color\cf3 .white, \cf2 //num clr\cf3 \
		\cf5 nil\cf3 ,\
		\cf5 nil\cf3 ,\
		\cf8 Color\cf3 (0.298, 0.776, 1.0, 1.0) \cf2 //knob clr\cf3 \
);\
\
\cf2 // ================= APE GUI =================\cf3 \
\cf2 //decrease inverval of hour arm with faster tempo\cf3 \
\
apeButView= \cf8 CompositeView\cf3 (tabs.views[2], \cf8 Rect\cf3 (200, 15, 600, 650))\
.background_(\cf8 Color\cf3 .grey.alpha_(0.3));\
apeButView.decorator= \cf8 FlowLayout\cf3 (apeButView.bounds);\
\
apeButStates= [\
\cf6 "<"\cf3 ,\
\cf6 ">"\cf3 ,\
\cf6 "<<"\cf3 ,\
\cf6 ">>"\cf3 \
];\
\
apeTasks= [\
	\cf8 Task\cf3 (\{\
		\cf5 inf\cf3 .do(\{\cf4 |i|\cf3 \
		sendNetAddr.sendMsg(\cf6 "ST1"\cf3 ++(-33.asString));\
		if (i.asInteger.odd, \{\
		sampler.play(\cf6 "snd11"\cf3 .asSymbol, 0.01, durations[11]*length[11], amp: amp[11], speed: rate[11], out: out, pan: pan);\
		\},\{\
		sampler.play(\cf6 "snd12"\cf3 .asSymbol, 0.01, durations[12]*length[12], amp: amp[12], speed: rate[12], out: out, pan: pan);\
		\});\
		(\cf6 "normal <"\cf3 +i).postln;\
		\cf2 //if ((i%60) == 1, \{ "hour.postln" sendNetAddr.sendMsg("ST2"++(-100.asString)); \});\cf3 \
		1.wait;\
		\});\
	\}, \cf8 TempoClock\cf3 (60/60)),\
	\cf8 Task\cf3 (\{\
		\cf5 inf\cf3 .do(\{\cf4 |i|\cf3 \
		sendNetAddr.sendMsg(\cf6 "ST1"\cf3 ++(33.asString));\
		if (i.asInteger.odd, \{\
		sampler.play(\cf6 "snd8"\cf3 .asSymbol, 0.01, durations[8]*length[8], amp: amp[8], speed: rate[8], out: out, pan: pan);\
		\},\{\
		sampler.play(\cf6 "snd9"\cf3 .asSymbol, 0.01, durations[9]*length[9], amp: amp[9], speed: rate[9], out: out, pan: pan);\
		\});\
		\cf2 //if ((i%60) == 1, \{ "hour.postln" sendNetAddr.sendMsg("ST2"++(-100.asString)); \});\cf3 \
		(\cf6 "normal >"\cf3 +i).postln;\
		1.wait;\
		\});\
	\}, \cf8 TempoClock\cf3 (60/60)),\
	\cf8 Task\cf3 (\{\
		\cf5 inf\cf3 .do(\{\cf4 |i|\cf3 \
		sendNetAddr.sendMsg(\cf6 "ST1"\cf3 ++(-33.asString));\
		if (i.asInteger.odd, \{\
		sampler.play(\cf6 "snd11"\cf3 .asSymbol, 0.01, durations[11]*length[11], amp: amp[11], speed: rate[11]*speedMul, out: out, pan: pan);\
		\},\{\
		sampler.play(\cf6 "snd12"\cf3 .asSymbol, 0.01, durations[12]*length[12], amp: amp[12], speed: rate[12]*speedMul, out: out, pan: pan);\
		\});\
		(\cf6 "fast <<"\cf3 +i).postln;\
		1.wait;\
		\});\
	\}, \cf8 TempoClock\cf3 (120/60)),\
	\cf8 Task\cf3 (\{\
		\cf5 inf\cf3 .do(\{\cf4 |i|\cf3 \
		sendNetAddr.sendMsg(\cf6 "ST1"\cf3 ++(33.asString));\
		if (i.asInteger.odd, \{\
		sampler.play(\cf6 "snd8"\cf3 .asSymbol, 0.01, durations[8]*length[8], amp: amp[8], speed: rate[8]*speedMul, out: out, pan: pan);\
		\},\{\
		sampler.play(\cf6 "snd9"\cf3 .asSymbol, 0.01, durations[9]*length[9], amp: amp[9], speed: rate[9]*speedMul, out: out, pan: pan);\
		\});\
		(\cf6 "fast >>"\cf3 +i).postln;\
		1.wait;\
		\});\
	\}, \cf8 TempoClock\cf3 (120/60))\
	\
];\
\
apeResponders1= \cf5 nil\cf3 !4;\
apeResponders2= \cf5 nil\cf3 !4;\
\
apeButActions= [\
\{ \cf2 // normal play backwards\cf3 \
	apeResponders1[0]= \cf8 OSCFunc\cf3 .new(\{\cf4 |msg|\cf3 \
		\cf6 "apeResponder1 tick!"\cf3 .postln;\
		\cf2 //msg.postln;\cf3 \
		sendNetAddr.sendMsg(\cf6 "ST2"\cf3 ++(-166.asString));			\cf2 //play louder, bit different clock tick\cf3 \
		sampler.play(\cf6 "snd13"\cf3 .asSymbol, 0.01, durations[13]*length[13], amp: amp[13], speed: rate[13], out: out, pan: pan);\
		\cf2 //play ding dong? maybe bit delay or warm up crank in sample...\cf3 \
		\cf2 //sampler.play("snd14".asSymbol, 0.01, durations[14]*length[14], amp: amp[14], speed: rate[14], out: out, pan: pan);\cf3 \
		\}, \
		\cf7 '/END1'\cf3 , \cf2 //symbol to respond to\cf3 \
		\cf8 NetAddr\cf3 (\cf9 ~ipDict\cf3 [\cf7 \\clock\cf3 ][0], \cf9 ~ipDict\cf3 [\cf7 \\clock\cf3 ][1]) \cf2 // ip of sender\cf3 \
		);\
	apeResponders2[0]= \cf8 OSCFunc\cf3 .new(\{\cf4 |msg|\cf3 \
		\cf6 "apeResponder2 tick!"\cf3 .postln;\
		\cf2 //msg.postln;\cf3 \
		\cf2 //stop task and button\cf3 \
		\{apeButtons[1].valueAction= 0\}.defer;\
		\cf2 //play 12 ding dong!!!!\cf3 \
		sampler.play(\cf6 "snd15"\cf3 .asSymbol, 0.01, durations[15]*length[15], amp: amp[15], speed: rate[15], out: out, pan: pan);\
		\}, \
		\cf7 '/END2'\cf3 , \cf2 //symbol to respond to\cf3 \
		\cf8 NetAddr\cf3 (\cf9 ~ipDict\cf3 [\cf7 \\clock\cf3 ][0], \cf9 ~ipDict\cf3 [\cf7 \\clock\cf3 ][1]) \cf2 // ip of sender\cf3 \
		);\
	\},\
\{ \cf2 // normal play forward\cf3 \
	apeResponders1[1]= \cf8 OSCFunc\cf3 .new(\{\cf4 |msg|\cf3 \
		\cf6 "apeResponder1 tick!"\cf3 .postln;\
		\cf2 //msg.postln;\cf3 \
		sendNetAddr.sendMsg(\cf6 "ST2"\cf3 ++(166.asString));			\cf2 //play louder, bit different clock tick\cf3 \
		sampler.play(\cf6 "snd10"\cf3 .asSymbol, 0.01, durations[10]*length[10], amp: amp[10], speed: rate[10], out: out, pan: pan);\
		\cf2 //play ding dong? maybe bit delay or warm up crank in sample...\cf3 \
		\cf2 //sampler.play("snd14".asSymbol, 0.01, durations[14]*length[14], amp: amp[14], speed: rate[14], out: out, pan: pan);\cf3 \
		\}, \
		\cf7 '/END1'\cf3 , \cf2 //symbol to respond to\cf3 \
		\cf8 NetAddr\cf3 (\cf9 ~ipDict\cf3 [\cf7 \\clock\cf3 ][0], \cf9 ~ipDict\cf3 [\cf7 \\clock\cf3 ][1]) \cf2 // ip of sender\cf3 \
		);\
	apeResponders2[1]= \cf8 OSCFunc\cf3 .new(\{\cf4 |msg|\cf3 \
		\cf6 "apeResponder2 tick!"\cf3 .postln;\
		\cf2 //msg.postln;\cf3 \
		\cf2 //stop task and button\cf3 \
		\{apeButtons[1].valueAction= 0\}.defer;\
		\cf2 //play 12 ding dong!!!!\cf3 \
		sampler.play(\cf6 "snd15"\cf3 .asSymbol, 0.01, durations[15]*length[15], amp: amp[15], speed: rate[15], out: out, pan: pan);\
		\}, \
		\cf7 '/END2'\cf3 , \cf2 //symbol to respond to\cf3 \
		\cf8 NetAddr\cf3 (\cf9 ~ipDict\cf3 [\cf7 \\clock\cf3 ][0], \cf9 ~ipDict\cf3 [\cf7 \\clock\cf3 ][1]) \cf2 // ip of sender\cf3 \
		);\
	\},\
\{ \cf2 // fast play backwards\cf3 \
	apeResponders1[0]= \cf8 OSCFunc\cf3 .new(\{\cf4 |msg|\cf3 \
		\cf6 "apeResponder1 tick!"\cf3 .postln;\
		\cf2 //msg.postln;\cf3 \
		sendNetAddr.sendMsg(\cf6 "ST2"\cf3 ++(-166.asString));			\cf2 //play louder, bit different clock tick\cf3 \
		sampler.play(\cf6 "snd13"\cf3 .asSymbol, 0.01, durations[13]*length[13], amp: amp[13], speed: rate[13], out: out, pan: pan);\
		\cf2 //play ding dong? maybe bit delay or warm up crank in sample...\cf3 \
		\cf2 //sampler.play("snd14".asSymbol, 0.01, durations[14]*length[14], amp: amp[14], speed: rate[14], out: out, pan: pan);\cf3 \
		\}, \
		\cf7 '/END1'\cf3 , \cf2 //symbol to respond to\cf3 \
		\cf8 NetAddr\cf3 (\cf9 ~ipDict\cf3 [\cf7 \\clock\cf3 ][0], \cf9 ~ipDict\cf3 [\cf7 \\clock\cf3 ][1]) \cf2 // ip of sender\cf3 \
		);\
	apeResponders2[0]= \cf8 OSCFunc\cf3 .new(\{\cf4 |msg|\cf3 \
		\cf6 "apeResponder2 tick!"\cf3 .postln;\
		\cf2 //msg.postln;\cf3 \
		\cf2 //stop task and button\cf3 \
		\{apeButtons[1].valueAction= 0\}.defer;\
		\cf2 //play 12 ding dong!!!!\cf3 \
		sampler.play(\cf6 "snd15"\cf3 .asSymbol, 0.01, durations[15]*length[15], amp: amp[15], speed: rate[15], out: out, pan: pan);\
		\}, \
		\cf7 '/END2'\cf3 , \cf2 //symbol to respond to\cf3 \
		\cf8 NetAddr\cf3 (\cf9 ~ipDict\cf3 [\cf7 \\clock\cf3 ][0], \cf9 ~ipDict\cf3 [\cf7 \\clock\cf3 ][1]) \cf2 // ip of sender\cf3 \
		);\
	\},\
\{ \cf2 // fast play forward\cf3 \
	apeResponders1[1]= \cf8 OSCFunc\cf3 .new(\{\cf4 |msg|\cf3 \
		\cf6 "apeResponder1 tick!"\cf3 .postln;\
		\cf2 //msg.postln;\cf3 \
		sendNetAddr.sendMsg(\cf6 "ST2"\cf3 ++(166.asString));			\cf2 //play louder, bit different clock tick\cf3 \
		sampler.play(\cf6 "snd10"\cf3 .asSymbol, 0.01, durations[10]*length[10], amp: amp[10], speed: rate[10], out: out, pan: pan);\
		\cf2 //play ding dong? maybe bit delay or warm up crank in sample...\cf3 \
		\cf2 //sampler.play("snd14".asSymbol, 0.01, durations[14]*length[14], amp: amp[14], speed: rate[14], out: out, pan: pan);\cf3 \
		\}, \
		\cf7 '/END1'\cf3 , \cf2 //symbol to respond to\cf3 \
		\cf8 NetAddr\cf3 (\cf9 ~ipDict\cf3 [\cf7 \\clock\cf3 ][0], \cf9 ~ipDict\cf3 [\cf7 \\clock\cf3 ][1]) \cf2 // ip of sender\cf3 \
		);\
	apeResponders2[1]= \cf8 OSCFunc\cf3 .new(\{\cf4 |msg|\cf3 \
		\cf6 "apeResponder2 tick!"\cf3 .postln;\
		\cf2 //msg.postln;\cf3 \
		\cf2 //stop task and button\cf3 \
		\{apeButtons[1].valueAction= 0\}.defer;\
		\cf2 //play 12 ding dong!!!!\cf3 \
		sampler.play(\cf6 "snd15"\cf3 .asSymbol, 0.01, durations[15]*length[15], amp: amp[15], speed: rate[15], out: out, pan: pan);\
		\}, \
		\cf7 '/END2'\cf3 , \cf2 //symbol to respond to\cf3 \
		\cf8 NetAddr\cf3 (\cf9 ~ipDict\cf3 [\cf7 \\clock\cf3 ][0], \cf9 ~ipDict\cf3 [\cf7 \\clock\cf3 ][1]) \cf2 // ip of sender\cf3 \
		);\
	\}\
];\
\
apeButtons= apeButStates.collect(\{ \cf4 |it, i|\cf3 \
	\cf8 Button\cf3 (apeButView, \cf8 Rect\cf3 (0, 0, 280, 180))\
	.states_([[it, \cf8 Color\cf3 .white, \cf8 Color\cf3 .black],[it, \cf8 Color\cf3 .black, \cf8 Color\cf3 .green ]])\
	.font_(\cf8 Font\cf3 (\cf6 "Helvetica"\cf3 , 140))\
	.canFocus_(\cf5 false\cf3 )\
	.action_(\{\cf4 |v|\cf3 \
		if (v.value == 1, \{ \cf2 //PLAY\cf3 \
			\cf2 //stop and reset any other tasks if playing\cf3 \
			apeTasks.do(\{\cf4 |t, i|\cf3  if (t.isPlaying, \{ apeButtons[i].valueAction= 0; \}); \});\
			\cf2 //also stop tasks in advanced mode\cf3 \
			if (t.isPlaying, \{ t.stop; t.reset; playBut2.value= 0; \});\
			\cf2 //stop simple respoders\cf3 \
			if (simpleDingBut1.value == 1, \{ simpleDingBut1.valueAction= 0; \});\
			if (simpleDingBut2.value == 1, \{ simpleDingBut2.valueAction= 0; \});\
			if (simpleDingBut3.value == 1, \{ simpleDingBut3.valueAction= 0; \});\
			\cf2 //start this task\cf3 \
			apeTasks[i].play;\
			apeButActions[i].value;\
			apeTempoSlider.value= apeTasks[i].clock.tempo*60;\
			\},\{ \cf2 // STOP\cf3 \
			\cf2 //stop this tdef, pause or stop and reset? if pause it needs 3 states\cf3 \
			apeTasks[i].stop; apeTasks[i].reset;\
			apeResponders1[i].free;\
			apeResponders2[i].free;\
			(\cf6 "stop"\cf3 +i).postln;\
		\});\
	\});\
\});\
\
apeTempoSlider= \cf8 EZSlider\cf3 (tabs.views[2],  	\
	\cf8 Rect\cf3 (150, 15, 40, 360),\
	\cf6 " BPM"\cf3 ,	\cf2 // label\cf3 \
	[10, 400, \cf7 \\lin\cf3 , 1, 120, \cf6 "tempo"\cf3 ].asSpec, \cf2 // controlSpec\cf3 \
	\{\cf4 |ez|\cf3  \cf2 // action\cf3 \
		apeTasks.do(\{\cf4 |t, i|\cf3  if (t.isPlaying, \{ t.clock.tempo_(ez.value/60); \}); \});\
		speedMul= ez.value.linexp(160, 400, 1, 2);\
		simpleTempoSlider.value= ez.value;\
		\}, \
	60, \cf2 // init value, set from A DICTIONARY\cf3 \
	layout: \cf7 \\vert\cf3 \
	)\
	.setColors(\
		\cf5 nil\cf3 , \cf2 //string backgr\cf3 \
		\cf8 Color\cf3 .white, \cf2 //string\cf3 \
		\cf8 Color\cf3 (0.298, 0.298, 0.298, 1.0), \cf2 //slider backgr\cf3 \
		\cf8 Color\cf3 .grey, \cf2 //num backgr\cf3 \
		\cf8 Color\cf3 .white, \cf2 //num clr\cf3 \
		\cf5 nil\cf3 ,\
		\cf5 nil\cf3 ,\
		\cf8 Color\cf3 (0.298, 0.776, 1.0, 1.0) \cf2 //knob clr\cf3 \
);\
\
tickMinApeBut= \cf8 Button\cf3 (tabs.views[2], \cf8 Rect\cf3 (10, 20, 60, 40))\
.states_([[\cf6 "Tick Min"\cf3 ], [\cf6 "Tick Min"\cf3 ]])\
.canFocus_(\cf5 false\cf3 )\
.action_(\{ \cf4 |v|\cf3 \
		sendNetAddr.sendMsg(\cf6 "ST1"\cf3 ++(33.asString));\
		if (v.value.even, \{\
		sampler.play(\cf6 "snd8"\cf3 .asSymbol, 0.01, durations[8]*length[8], amp: amp[8], speed: rate[8], out: out, pan: pan);\
		\},\{\
		sampler.play(\cf6 "snd9"\cf3 .asSymbol, 0.01, durations[9]*length[9], amp: amp[9], speed: rate[9], out: out, pan: pan);\
		\});\
\});\
\
\cf8 Button\cf3 (tabs.views[2], \cf8 Rect\cf3 (10, 65, 60, 20))\
.states_([[\cf6 "Tick Min <"\cf3 ], [\cf6 "Tick Min <"\cf3 ]])\
.font_(\cf8 Font\cf3 (\cf6 "Helvetica"\cf3 , 9))\
.canFocus_(\cf5 false\cf3 )\
.action_(\{ \cf4 |v|\cf3 \
		sendNetAddr.sendMsg(\cf6 "ST1"\cf3 ++(-33.asString));\
		if (v.value.even, \{\
		sampler.play(\cf6 "snd11"\cf3 .asSymbol, 0.01, durations[11]*length[11], amp: amp[11], speed: rate[11], out: out, pan: pan);\
		\},\{\
		sampler.play(\cf6 "snd12"\cf3 .asSymbol, 0.01, durations[12]*length[12], amp: amp[12], speed: rate[12], out: out, pan: pan);\
		\});\
\});\
\
\cf8 Button\cf3 (tabs.views[2], \cf8 Rect\cf3 (80, 20, 60, 40))\
.states_([[\cf6 "Tick Hour"\cf3 ]])\
.canFocus_(\cf5 false\cf3 )\
.action_(\{ \cf4 |v|\cf3 \
		sendNetAddr.sendMsg(\cf6 "ST2"\cf3 ++(166.asString));	\
		sampler.play(\cf6 "snd10"\cf3 .asSymbol, 0.01, durations[10]*length[10], amp: amp[10], speed: rate[10], out: out, pan: pan);\
\});\
\
\cf8 Button\cf3 (tabs.views[2], \cf8 Rect\cf3 (80, 65, 60, 20))\
.states_([[\cf6 "Tick Hr <"\cf3 ]])\
.font_(\cf8 Font\cf3 (\cf6 "Helvetica"\cf3 , 9))\
.canFocus_(\cf5 false\cf3 )\
.action_(\{ \cf4 |v|\cf3 \
		sendNetAddr.sendMsg(\cf6 "ST2"\cf3 ++(-166.asString));	\
		sampler.play(\cf6 "snd13"\cf3 .asSymbol, 0.01, durations[13]*length[13], amp: amp[13], speed: rate[13], out: out, pan: pan);\
\});\
\
\cf8 Button\cf3 (tabs.views[2], \cf8 Rect\cf3 (20, 95, 110, 40))\
.states_([[\cf6 "Play One Ding!"\cf3 ], [\cf6 "Stop playing"\cf3 ]])\
.canFocus_(\cf5 false\cf3 )\
.action_(\{ \cf4 |v|\cf3 \
	if(v.value == 1, \{\
	sampler.play(\cf6 "snd14"\cf3 .asSymbol, 0.01, durations[14]*length[14], amp: amp[14], speed: rate[14], out: out, pan: pan);\
	\{v.value= 0\}.defer(durations[14]*length[14]);\
	\},\{\
	sampler.stop(\cf6 "snd14"\cf3 .asSymbol, 0.1);\
	\});\
\});\
\
\cf8 Button\cf3 (tabs.views[2], \cf8 Rect\cf3 (20, 140, 110, 40))\
.states_([[\cf6 "Play 12 Dings!"\cf3 ], [\cf6 "Stop playing"\cf3 ]])\
.canFocus_(\cf5 false\cf3 )\
.action_(\{ \cf4 |v|\cf3 \
	if(v.value == 1, \{\
	sampler.play(\cf6 "snd15"\cf3 .asSymbol, 0.01, durations[15]*length[15], amp: amp[15], speed: rate[15]);\
	\{v.value= 0\}.defer(durations[15]*length[15], out: out, pan: pan);\
	\},\{\
	sampler.stop(\cf6 "snd15"\cf3 .asSymbol, 0.1);\
	\});\
\});\
\
\cf8 StaticText\cf3 (tabs.views[2], \cf8 Rect\cf3 (10, 185, 130, 95)).background_(\cf8 Color\cf3 .grey(0.7).alpha_(0.5));\
\cf8 StaticText\cf3 (tabs.views[2], \cf8 Rect\cf3 (12, 185, 10, 95)).string_(\cf6 "m a n u a l"\cf3 ).font_(\cf8 Font\cf3 (\cf6 "monaco"\cf3 , 8));\
\cf8 StaticText\cf3 (tabs.views[2], \cf8 Rect\cf3 (132, 185, 10, 95)).string_(\cf6 "c o n t r o l"\cf3 ).font_(\cf8 Font\cf3 (\cf6 "monaco"\cf3 , 8));\
\
apeMinKnob= \cf8 EZKnob\cf3 (tabs.views[2], \cf8 Rect\cf3 (20, 185, 50, 90), \cf6 "   mins"\cf3 , \cf8 ControlSpec\cf3 (-3000, 3000, \cf7 \\lin\cf3 , 1, 0, \cf6 "/SR1"\cf3 ),\
\{ \cf4 |ez|\cf3  minuteSlider.valueAction= ez.value \});\
\
apeMinKnob.view.mouseUpAction= (\{ \cf4 |view, x, y, mod|\cf3  \
	minuteSlider.view.mouseUpAction.value(view, x, y, mod); \
	if (mod.isShift.not, \{ apeMinKnob.value= 0; \}); \
\});\
\
apeMinKnob.view.children.do(\{\cf4 |it|\cf3  it.canFocus= \cf5 false\cf3 ; \});\
\
apeHourKnob= \cf8 EZKnob\cf3 (tabs.views[2], \cf8 Rect\cf3 (80, 185, 50, 90), \cf6 "  hours"\cf3 , \cf8 ControlSpec\cf3 (-3000, 3000, \cf7 \\lin\cf3 , 1, 0, \cf6 "/SR2"\cf3 ),\
\{ \cf4 |ez|\cf3  hourSlider.valueAction= ez.value \});\
\
apeHourKnob.view.mouseUpAction= (\{ \cf4 |view, x, y, mod|\cf3  \
	hourSlider.view.mouseUpAction.value(view, x, y, mod); \
	if (mod.isShift.not, \{ apeHourKnob.value= 0; \});\
\});\
\
apeHourKnob.view.children.do(\{\cf4 |it|\cf3  it.canFocus= \cf5 false\cf3 ; \});\
\
\cf8 Button\cf3 (tabs.views[2], \cf8 Rect\cf3 (20, 285, 110, 20))\
.states_([[\cf6 "set to 12 o clock"\cf3 ]])\
.canFocus_(\cf5 false\cf3 )\
.action_(\{ \cf4 var\cf3  time, hours, minutes;\
	goToTime.value([0, 0]);\
\});\
\
\
\cf8 StaticText\cf3 (tabs.views[2], \cf8 Rect\cf3 (25, 310, 100, 40)).background_(\cf8 Color\cf3 .grey);\
\
hrNB= \cf8 NumberBox\cf3 (tabs.views[2], \cf8 Rect\cf3 (40, 310, 25, 20))\
	.align_(\cf7 \\center\cf3 )\
	.value_(7)\
	.clipLo_(0)\
	.clipHi_(11)\
	.alt_scale_(1)\
	.step_(1);\
\
\cf8 StaticText\cf3 (tabs.views[2], \cf8 Rect\cf3 (70, 310, 10, 20)).string_(\cf6 ":"\cf3 );\
\
minNB= \cf8 NumberBox\cf3 (tabs.views[2], \cf8 Rect\cf3 (80, 310, 25, 20))\
	.align_(\cf7 \\center\cf3 )\
	.value_(45)\
	.clipLo_(0)\
	.clipHi_(59)\
	.alt_scale_(1)\
	.step_(1);\
\
\cf8 Button\cf3 (tabs.views[2], \cf8 Rect\cf3 (25, 330, 100, 20))\
.states_([[\cf6 "set to this time"\cf3 ]])\
.canFocus_(\cf5 false\cf3 )\
.action_(\{ \cf4 var\cf3  time, hours, minutes;\
	\cf2 //stop all other tasks\cf3 \
	time = \cf8 Date\cf3 .localtime.stamp;\
	minutes= minNB.value;\
	hours= hrNB.value;\
	[hours, minutes].postln;\
	goToTime.value([hours, minutes]);\
\});\
\
\cf8 Button\cf3 (tabs.views[2], \cf8 Rect\cf3 (20, 355, 110, 20))\
.states_([[\cf6 "set to IRL time"\cf3 ]])\
.canFocus_(\cf5 false\cf3 )\
.action_(\{ \cf4 var\cf3  time, hours, minutes;\
	time = \cf8 Date\cf3 .localtime.stamp;\
	minutes= (time[9]++time[10]).asInteger;\
	hours= ((time[7]++time[8]).asInteger%12);\
	[hours, minutes].postln;\
	goToTime.value([hours, minutes]);\
\});\
\
w.front;\
\
\cf2 // =================. ROUTINES ================\cf3 \
\
\cf8 Tdef\cf3 (\cf7 \\clockSeconds\cf3 , \{ \cf4 var\cf3  i= 900;\
	loop (\{\
		sendNetAddr.sendMsg(\cf6 "ST1"\cf3 ++(minuteSteps.asString));\
		\cf6 "bop"\cf3 .postln;\
		secWait.wait;\
	\})\
\});\
\
\cf8 Tdef\cf3 (\cf7 \\clockJam\cf3 , \{ \cf4 var\cf3  i= 0;\
	loop (\{\
		sendNetAddr.sendMsg(\cf6 "ST1"\cf3 ++(50.asString));\
		\cf6 "bip"\cf3 .postln;\
		(0.5*secWait).wait;\
		sendNetAddr.sendMsg(\cf6 "ST1"\cf3 ++(minuteSteps.asString));\
		\cf6 "blojp"\cf3 .postln;\
		(1.5*secWait).wait;\
		i= i+1;\
		if (i.even, \{sendNetAddr.sendMsg(\cf6 "ST2"\cf3 ++(minuteSteps.asString));\});\
		\
	\})\
\});\
\
\cf2 // ======== OUTPUT ======\cf3 \
\
\cf8 StaticText\cf3 (w, \cf8 Rect\cf3 (640, 410, 40, 20)).string_(\cf6 "Pan:"\cf3 );\
\
panKnob= \cf8 Knob\cf3 (w, \cf8 Rect\cf3 (670, 410, 20, 20))\
.centered_(\cf5 true\cf3 )\
.canFocus_(\cf5 false\cf3 )\
.value_(\cf7 \\pan\cf3 .asSpec.unmap(0))\
.action_(\{ \cf4 |v|\cf3 \
	pan= (\cf7 \\pan\cf3 .asSpec.map(v.value));\
	\cf2 //pan.postln;\cf3 \
\})\
.color_([\cf8 Color\cf3 .gray, \cf8 Color\cf3 .red, \cf8 Color\cf3 .white, \cf8 Color\cf3 .black]);\
\
\cf8 StaticText\cf3 (w, \cf8 Rect\cf3 (700, 410, 100, 20)).string_(\cf6 "Output:"\cf3 );\
outbut= \cf8 Button\cf3 (w, \cf8 Rect\cf3 (750, 410, 30, 20))\
		.states_([[\cf6 "nil"\cf3 , \cf8 Color\cf3 .black, \cf8 Color\cf3 .grey], [\cf6 "1-2"\cf3 , \cf8 Color\cf3 .yellow, \cf8 Color\cf3 .black],[\cf6 "3-4"\cf3 , \cf8 Color\cf3 .yellow, \cf8 Color\cf3 .black], [\cf6 "5-5"\cf3 , \cf8 Color\cf3 .yellow, \cf8 Color\cf3 .black], [\cf6 "7-8"\cf3 , \cf8 Color\cf3 .yellow, \cf8 Color\cf3 .black], [\cf6 "9-10"\cf3 , \cf8 Color\cf3 .yellow, \cf8 Color\cf3 .black], [\cf6 "11-12"\cf3 , \cf8 Color\cf3 .yellow, \cf8 Color\cf3 .black], [\cf6 "13-14"\cf3 , \cf8 Color\cf3 .yellow, \cf8 Color\cf3 .black], [\cf6 "15-16"\cf3 , \cf8 Color\cf3 .yellow, \cf8 Color\cf3 .black], [\cf6 "17-18"\cf3 , \cf8 Color\cf3 .yellow, \cf8 Color\cf3 .black], [\cf6 "19-20"\cf3 , \cf8 Color\cf3 .yellow, \cf8 Color\cf3 .black], [\cf6 "21-22"\cf3 , \cf8 Color\cf3 .yellow, \cf8 Color\cf3 .black], [\cf6 "23-24"\cf3 , \cf8 Color\cf3 .yellow, \cf8 Color\cf3 .black]] )\
		.font_(\cf8 Font\cf3 (\cf6 "Helvetica"\cf3 , 9))\
		.canFocus_(\cf5 false\cf3 )\
		.value_( 0 )\
		.action_(\{ \cf4 |v|\cf3 \
			if(v.value==0, \{out= defaultout \},\
			\{out= outputs[v.value];\});\
			\cf2 //\{syn.free\}.try;\cf3 \
			\cf2 //firstRun= true;\cf3 \
			\cf2 //synOn= false;\cf3 \
		\});\
\
\cf2 // ===========. SAVE MENU =============\cf3 \
\
\
\
\cf8 StaticText\cf3 (w, \cf8 Rect\cf3 (10, 410, 100, 20)).string_(\cf6 "Preset:"\cf3 );\
saveDirectory= (\cf8 String\cf3 .scDir.dirname ++ \cf6 "/Resources/CLOCKPRESETS/"\cf3 );\
saveFiles= (saveDirectory+/+\cf6 "*"\cf3 ).standardizePath.pathMatch;\
\
		loadMenu= \cf8 PopUpMenu\cf3 (w, \cf8 Rect\cf3 (50, 410, 130, 20)) \cf2 // -----\cf3 \
		.items_(saveFiles.collect(\{\cf4 |it|\cf3  it.basename\}))\
		.canFocus_(\cf5 false\cf3 )\
		.background_(\cf8 Color\cf3 .white)\
		.font_(\cf8 Font\cf3 (\cf6 "Helvetica"\cf3 , 10))\
		.action_(\{\cf4 |v|\cf3 \
			loadMenuItem= v.items.at(v.value);\
		\});\
		\
		\cf2 //load preset\cf3 \
		loadPresetBut= \cf8 Button\cf3 (w, \cf8 Rect\cf3 (180, 410, 20, 20)) \cf2 // ------\cf3 \
		.states_([[\cf6 "L"\cf3 , \cf8 Color\cf3 .red, \cf8 Color\cf3 .black]])\
		.canFocus_(\cf5 false\cf3 )\
		.font_(\cf8 Font\cf3 (\cf6 "Helvetica"\cf3 , 10))\
		.action_(\{\
			\cf4 var\cf3  loadArray;\
			if (loadMenuItem.isNil.not, \{\
				if (loadMenuItem != \cf6 "________"\cf3 , \{\
				activePreset.string= loadMenuItem;\
				activePresetCurrent= loadMenuItem;\
				loadArray= \cf8 Object\cf3 .readArchive(saveFiles[loadMenu.value]);\
				saveArchive= loadArray.interpret;\
				\cf2 /*\
				0= saveGrid, \
				1= t.clock.tempo, \
				2= sendOscKeyboardMenuItem, \
				3= oscCom, \
				4= oscVal, \
				5= sounds, \
				6= length, \
				7= rate, \
				8= sendOnOff, \
				9= outbut.value\
				10= amp\
				11= delay\
				12= pan (main)\
				missing:\
				keyNames\
				*/\cf3 \
				\cf6 "load 0 >>>"\cf3 .postln;\
				columns.do(\{\cf4 |i|\cf3 \
					numKeys.do(\{\cf4 arg\cf3  ii;\
						\cf2 //saveGrid.put(ii, i, gridArray[ii].getState(i%columns, 0));\cf3 \
						gridArray[ii].setState_(i%columns, 0, saveArchive[0].at(ii, i).deepCopy);\
						\cf2 //saveArchive[0].at(ii, i).postln;\cf3 \
					\});\
				\});\
				\cf6 "load 1 >>>"\cf3 .postln;\
				t.clock.tempo_(saveArchive[1]);\
				tempoSlider.value= saveArchive[1]/2;\
				\cf2 //sendOscKeyboardMenu.value= saveArchive[2];\cf3 \
				\cf6 "load 2 >>>"\cf3 .postln;\
				\cf9 ~samplerNames\cf3 .do(\{\cf4 |it, i|\cf3  if(it==saveArchive[2].deepCopy, \
					\{ sendOscKeyboardMenu.valueAction= i \}); \
				\});\
				\cf6 "load 3 >>>"\cf3 .postln;\
				oscCom= saveArchive[3].deepCopy;\
				oscComButs.do(\{\cf4 |it, i|\cf3  it.value= oscCom[i]\});\
				\cf6 "load 4 >>>"\cf3 .postln;\
				oscVal= saveArchive[4].deepCopy;\
				oscValButs.do(\{\cf4 |it, i|\cf3  it.value= oscVal[i]\});\
				\cf6 "load 5 >>>"\cf3 .postln;\
				saveArchive[5].do(\{\cf4 |it, i|\cf3  \cf2 //load soundfiles\cf3 \
					if(it.isNil.not, \{\
						if(it.isString, \{it= [it];\});\
						loadPreset.value(it, i);\
						\cf2 //[it, i].postln;\cf3 \
					\});\
				\});\
				\cf6 "load 6 >>>"\cf3 .postln;\
				length= saveArchive[6].deepCopy;\
				lengthKnobs.do(\{\cf4 |it, i|\cf3  if(it.isNil.not, \{it.value= length[i]\}); \});\
				\cf6 "load 7 >>>"\cf3 .postln;\
				rate= saveArchive[7].deepCopy;\
				rateKnobs.do(\{\cf4 |it, i|\cf3  if(it.isNil.not, \{it.value= rate[i]\}); \});\
				\cf6 "load 8 >>>"\cf3 .postln;\
				sendOnOff= saveArchive[8].deepCopy;\
				sendButs.do(\{\cf4 |it, i|\cf3  it.value= sendOnOff[i]\});\
				\cf6 "load 9 >>>"\cf3 .postln;\
				outbut.valueAction= saveArchive[9].deepCopy;\
				\cf6 "load 10 >>>"\cf3 .postln;\
				amp= saveArchive[10].deepCopy;\
				keyButs.do(\{\cf4 |it, i|\cf3  if(it.isNil.not, \{ it.value= amp[i]\}); \});\
				\cf6 "load 11 >>>"\cf3 .postln;\
				delayVal= saveArchive[11].deepCopy;\
				delayButs.do(\{\cf4 |it, i|\cf3  if(it.isNil.not, \{ it.value= delayVal[i]\}); \});\
				if(saveArchive[12].isNil.not, \{ \
					pan= saveArchive[12].deepCopy; panKnob.value= \cf7 \\pan\cf3 .asSpec.unmap(pan);\
					\});\
				\});\
			\});\
		\});\
		\cf8 Button\cf3 (w, \cf8 Rect\cf3 (200, 410, 30, 20))\
		.states_([[\cf6 "qs"\cf3 ]])\
		.canFocus_(\cf5 false\cf3 )\
		.font_(\cf8 Font\cf3 (\cf6 "Helvetica"\cf3 , 12))\
		.action_(\{\
			if (activePresetCurrent.isNil.not, \{\
			columns.do(\{\cf4 |i|\cf3 \
				numKeys.do(\{\cf4 arg\cf3  ii;\
					saveGrid.put(ii, i, gridArray[ii].getState(i%columns, 0));\
						\});\
				\});\
			saveArchive= [\
			saveGrid, \
			t.clock.tempo, \
			sendOscKeyboardMenuItem, \
			oscCom, \
			oscVal, \
			sounds, \
			length, \
			rate, \
			sendOnOff, \
			outbut.value, \
			amp,\
			delayVal,\
			pan\
			];\
			saveArchive.asCompileString.writeArchive(saveDirectory+/+loadMenuItem);\
\
			\});\
		\});\
		\cf8 Button\cf3 (w, \cf8 Rect\cf3 (230, 410, 20, 20))\
		.states_([[\cf6 "s"\cf3 ]])\
		.canFocus_(\cf5 false\cf3 )\
		.font_(\cf8 Font\cf3 (\cf6 "Helvetica"\cf3 , 12))\
		.action_(\{\
			\cf2 //save preset\cf3 \
			\cf4 var\cf3  w, textview, name, saveBut;\
				w= \cf8 Window\cf3 (\cf6 "save"\cf3 , \cf8 Rect\cf3 (400, 400, 230, 100), border: \cf5 false\cf3 )\
				.background_(\cf8 Color\cf3 .black)\
				.alwaysOnTop_(\cf5 true\cf3 );\
	\
				textview= \cf8 TextView\cf3 (w, \cf8 Rect\cf3 (10, 10, 210, 20))\
				.focus(\cf5 true\cf3 )\
				.keyDownAction_(\{\cf4 |view, char, mod, uni, key|\cf3 \
					if(key == 36, \{ \{saveBut.valueAction= 1\}.defer; \});\
				\});\
				\
				saveBut= \cf8 Button\cf3 (w, \cf8 Rect\cf3 (10, 40, 100, 40))\
				.states_([[\cf6 "save"\cf3 ]])\
				.action_(\{\
					\cf4 var\cf3  values, path, stringSize;\
					stringSize= textview.string.size;\
					if (stringSize > 0, \{\
						name= textview.string;\
						path= saveDirectory+/+(name);\
						columns.do(\{\cf4 |i|\cf3 \
							numKeys.do(\{\cf4 arg\cf3  ii;\
								saveGrid.put(ii, i, gridArray[ii].getState(i%columns, 0));\
								\});\
						\});\
						saveArchive= [\
						saveGrid, \
						t.clock.tempo, \
						sendOscKeyboardMenuItem, \
						oscCom, \
						oscVal, \
						sounds, \
						length, \
						rate, \
						sendOnOff, \
						outbut.value, \
						amp, \
						delayVal\
						];\
						saveArchive.asCompileString.writeArchive(path);\
						\cf2 //currentSaveFile= path;\cf3 \
						saveFiles= (saveDirectory++\cf6 "*"\cf3 ).standardizePath.pathMatch;\
						\{loadMenu.items= saveFiles.collect(\{\cf4 |it|\cf3  it.basename.asSymbol\});\}.defer;\
						loadMenu.value= loadMenu.items.indexOf(name.asSymbol);\
						activePreset.string= name;\
						activePresetCurrent= name;\
						w.close;\
					\});\
				\});\
				\cf8 Button\cf3 (w, \cf8 Rect\cf3 (120, 40, 100, 40))\
				.states_([[\cf6 "cancel"\cf3 ]])\
				.action_(\{\
					w.close;\
				\});\
				w.front;\
		\});\
		\
\cf8 StaticText\cf3 (w, \cf8 Rect\cf3 (255, 410, 100, 20)).string_(\cf6 "Active Preset:"\cf3 );\
activePreset= \cf8 StaticText\cf3 (w, \cf8 Rect\cf3 (340, 410, 120, 20))\
.string_(\cf6 "none"\cf3 )\
.background_(\cf8 Color\cf3 .grey.alpha_(0.3))\
.align_(\cf7 \\center\cf3 );\
\
\cf2 // =========== SOUNDFILES WINDOW ============\cf3 \
\
\cf8 Button\cf3 (w, \cf8 Rect\cf3 (470, 410, 110, 20))\
.states_([[\cf6 "Soundfiles"\cf3 ]])\
.canFocus_(\cf5 false\cf3 )\
.action_(\{\
	\cf4 var\cf3  w, leftInset= 180, topInset= 60, titles;\
	if(soundFilesWindowOpen.not, \{\
		\
		soundFilesWindowOpen= \cf5 true\cf3 ;\
\
sfWindow= \cf8 Window\cf3 (\cf6 "Clock Soundfiles"\cf3 , \cf8 Rect\cf3 (0, 0, 440, 400)).alwaysOnTop_(\cf5 true\cf3 ).front;\
w= sfWindow;\
\
\cf2 //load values from settings...\cf3 \
\
\cf8 StaticText\cf3 (w, \cf8 Rect\cf3 (0, 0, 440, 40))\
.string_(\cf6 "Drag Soundfiles to Sliders"\cf3 )\
.font_(\cf8 Font\cf3 (\cf6 "Helvetica"\cf3 , 35))\
.align_(\cf7 \\center\cf3 );\
\
\cf8 StaticText\cf3 (w, \cf8 Rect\cf3 (10, 50, leftInset, 10))\
.string_(\cf6 "Function:"\cf3 )\
.font_(\cf8 Font\cf3 (\cf6 "Helvetica"\cf3 , 10));\
\
\cf8 StaticText\cf3 (w, \cf8 Rect\cf3 (10+leftInset-70, 50, 160, 10))\
.string_(\cf6 "Soundfile / Volume:"\cf3 )\
.font_(\cf8 Font\cf3 (\cf6 "Helvetica"\cf3 , 10));\
\
\cf8 StaticText\cf3 (w, \cf8 Rect\cf3 (100+leftInset, 50, 160, 10))\
.string_(\cf6 "Length/Rate:"\cf3 )\
.font_(\cf8 Font\cf3 (\cf6 "Helvetica"\cf3 , 8));\
\
\cf8 StaticText\cf3 (w, \cf8 Rect\cf3 (180+leftInset, 50, 60, 10))\
.string_(\cf6 "Delay ms:"\cf3 )\
.font_(\cf8 Font\cf3 (\cf6 "Helvetica"\cf3 , 10));\
\
titles= [\
	\cf6 "Minute > Tick:"\cf3 , \
	\cf6 "Minute > Tock:"\cf3 , \
	\cf6 "Hour Arm >:"\cf3 , \
	\cf6 "Minute < Tick:"\cf3 , \
	\cf6 "Minute < Tock:"\cf3 , \
	\cf6 "Hour Arm <:"\cf3 , \
	\cf6 "Strike 12 Min Arm:"\cf3 , \
	\cf6 "Strike 12 Hr Arm:"\cf3 ,\
	\cf6 "Min Knob Loop:"\cf3 , \
	\cf6 "Hour Knob Loop:"\cf3 , \
	\cf6 "Min Knob Stop"\cf3 , \
	\cf6 "Hour Knob Stop"\cf3 , \
	\cf6 "?"\cf3 , \cf6 "?"\cf3 , \cf6 "?"\cf3 , \cf6 "?"\cf3 ];\
\
titles.do(\{\cf4 arg\cf3  it, i;\
	\cf8 StaticText\cf3 (w, \cf8 Rect\cf3 (10, ((boxHeight+boxSpace)*i)+topInset, leftInset, 20))\
	.string_(titles[i]);\
	\
	keyNames[i+8]= \cf8 StaticText\cf3 (w, \cf8 Rect\cf3 (15+leftInset-70, ((boxHeight+boxSpace)*i)+topInset, 160, 20))\
	.string_(soundFileNames[i+8]);\
	\
	keyButs[i+8]= \cf8 Slider\cf3 (w, \cf8 Rect\cf3 (10+leftInset-70, ((boxHeight+boxSpace)*i)+topInset, 160, 20))\
	\cf2 //.states_([["sound"+(i+1), Color.black, Color.white]])\cf3 \
	.background_(\cf8 Color\cf3 .grey.alpha_(0))\
	.thumbSize_(8)\
	.canFocus_(\cf5 false\cf3 )\
	.value_(amp[i+8])\
	.action_(\{\cf4 |v|\cf3  amp[i+8]= v.value; \})\
	.canReceiveDragHandler_(\cf5 true\cf3 )\
	.receiveDragHandler_(\{\cf4 |view|\cf3 \
		\cf4 var\cf3  paths;\
		paths= \cf8 View\cf3 .currentDrag;\
		paths.postln;\
		if(paths.isString, \{paths= [paths];\}); \cf2 // qt compatibility..\cf3 \
		paths.postln;\
		\cf2 //loadPreset.value(paths, i+8);\cf3 \
		\cf2 //multiple files\cf3 \
		if(paths.size > 1, \{ \
			paths= paths.keep(numSounds-(i+8));\
			paths.do(\{\cf4 |it, ii|\cf3 \
				loadPreset.value([it], (i+8)+ii);\
				\cf2 //allSliders[((i+8)-1)+ii].setValues([it]);\cf3 \
			\});\
			\},\{ \
			\cf2 //single file\cf3 \
			loadPreset.value(paths, i+8);\
		\});\
	\});\
\
	lengthKnobs[i+8]= \cf8 Knob\cf3 (w, \cf8 Rect\cf3 (100+leftInset, ((boxHeight+boxSpace)*i)+topInset, 20, 20))\
	.canFocus_(\cf5 false\cf3 )\
	.value_(length[i+8])\
	.action_(\{\cf4 |v|\cf3  length[i+8]= v.value\});\
	\
	rateKnobs[i]= \cf8 Knob\cf3 (w, \cf8 Rect\cf3 (120+leftInset, ((boxHeight+boxSpace)*i)+topInset, 20, 20))\
	.canFocus_(\cf5 false\cf3 )\
	.value_(rate[i+8])\
	.centered_(\cf5 true\cf3 )\
	.action_(\{\cf4 |v|\cf3  rate[i+8]= v.value; v.value.postln;\});\
	\
	\cf8 Button\cf3 (w, \cf8 Rect\cf3 (140+leftInset, ((boxHeight+boxSpace)*i)+topInset, 20, 20))\
	.states_([[\cf6 "L"\cf3 , \cf8 Color\cf3 .red, \cf8 Color\cf3 .black]])\
	.canFocus_(\cf5 false\cf3 )\
	.value_(0)\
	.action_(\{\cf4 |v|\cf3  \cf6 "load soundfile"\cf3 .postln; loadDialogSampler.value(i+8); \});\
	\
	\cf8 Button\cf3 (w, \cf8 Rect\cf3 (160+leftInset, ((boxHeight+boxSpace)*i)+topInset, 20, 20))\
	.states_([[\cf6 "|>"\cf3 , \cf8 Color\cf3 .green, \cf8 Color\cf3 .black], [\cf6 "||"\cf3 , \cf8 Color\cf3 .red, \cf8 Color\cf3 .black]])\
	.canFocus_(\cf5 false\cf3 )\
	.value_(0)\
	.action_(\{\cf4 |v|\cf3 \
		if(v.value == 1, \{\
		sampler.play((\cf6 "snd"\cf3 ++(i+8).asString).asSymbol, 0.01, durations[i+8]*length[i+8], amp: amp[i+8], speed: rate[i+8], out: out, pan: pan);\
		\{ v.value= 0 \}.defer(durations[i+8]*length[i+8]);\
		\},\{\
			sampler.stop((\cf6 "snd"\cf3 ++(i+8).asString).asSymbol, 0.01);\
		\});\
		\});\
	delayButs[i]= \cf8 NumberBox\cf3 (w, \cf8 Rect\cf3 (180+leftInset, ((boxHeight+boxSpace)*i)+topInset, 40, 20))\
	\cf2 //.canFocus_(false)\cf3 \
	.value_(0)\
	.clipLo_(0)\
	.clipHi_(1000)\
	.alt_scale_(1)\
	.action_(\{\cf4 |v|\cf3  delayVal[i]= v.value \});\
	\
	\cf8 StaticText\cf3 (w, \cf8 Rect\cf3 (220+leftInset, ((boxHeight+boxSpace)*i)+topInset, 30, 20))\
	.string_(\cf6 "("\cf3 ++(i+8)++\cf6 ")"\cf3 );\
\});\
\
w.onClose= (\{ soundFilesWindowOpen= \cf5 false\cf3 ; \});\
\
\});\
\
\});\
\
\cf8 Button\cf3 (w, \cf8 Rect\cf3 (590, 410, 40, 20))\
.states_([[\cf6 "panic"\cf3 , \cf8 Color\cf3 .black, \cf8 Color\cf3 .red.alpha_(0.4)]])\
.canFocus_(\cf5 false\cf3 )\
.action_(\{\
	sendNetAddr.sendMsg(\cf6 "SR1"\cf3 ++(0.asString));\
	sendNetAddr.sendMsg(\cf6 "SR2"\cf3 ++(0.asString));\
	sampler.flush(0.1);\
	\{t.stop\}.try;\
	simpleTasks.do(\{\cf4 |it|\cf3  \{it.stop\}.try; \});\
	apeTasks.do(\{\cf4 |it|\cf3  \{it.stop\}.try; \});\
	\
\});\
\
\cf2 // LOAD LAST USED PRESET ON START\cf3 \
if ( (saveDirectory+/+(\cf6 "________"\cf3 )).isFile, \{\
	lastUsedPresetFile= \cf8 Object\cf3 .readArchive(saveDirectory+/+(\cf6 "________"\cf3 ));\
	lastUsedPreset= lastUsedPresetFile.interpret;\
	\cf6 "lastUsedPreset:"\cf3 .postln;\
	lastUsedPreset.postln;\
	loadMenuItemsSymbolsArray= loadMenu.items.collect(\{\cf4 |it|\cf3  it.asSymbol \});\
	\cf6 "loadMenuItemsSymbolsArray:"\cf3 .postln;\
	loadMenuItemsSymbolsArray.postln;\
	if ( loadMenuItemsSymbolsArray.includes(lastUsedPreset.asSymbol), \{\
		\cf6 "trying..."\cf3 .postln;\
		loadMenuItemsSymbolsArray.indexOf(lastUsedPreset.asSymbol).postln;\
		loadMenu.valueAction= ( loadMenuItemsSymbolsArray.indexOf(lastUsedPreset.asSymbol) );\
		loadPresetBut.valueAction= 0;\
	\});\
\});\
\
\
\cf2 //ON WINDOW CLOSE CLEAN UP\cf3 \
w.onClose= \{\
	if(soundFilesWindowOpen, \{ sfWindow.close; \});\
	\cf9 ~clockOpen\cf3 = \cf5 false\cf3 ;\
	sendNetAddr.sendMsg(\cf6 "SR1"\cf3 ++(0.asString));\
	sendNetAddr.sendMsg(\cf6 "SR2"\cf3 ++(0.asString));\
	sendNetAddr.disconnect;\
	recieveNetAddr.disconnect;\
	localNetAddr.disconnect;\
	\cf8 Tdef\cf3 (\cf7 \\clockSeconds\cf3 ).clear;\
	clockResp1.free;\
	clockResp2.free;\
	clockResp3.free;\
	sampler.free;\
	\{t.stop\}.try;\
	simpleResponders.do(\{\cf4 |it|\cf3  \{it.free\}.try\});\
	simpleTasks.do(\{\cf4 |it|\cf3  \{it.stop\}.try; \});\
	apeResponders1.do(\{\cf4 |it|\cf3  \{it.free\}.try\});\
	apeResponders2.do(\{\cf4 |it|\cf3  \{it.free\}.try\});\
	apeTasks.do(\{\cf4 |it|\cf3  \{it.stop\}.try; \});\
	\cf6 "activePresetCurrent:"\cf3 .postln;\
	activePresetCurrent.postln;\
	if (activePresetCurrent.isNil.not, \{\
		(activePresetCurrent).asCompileString.writeArchive(saveDirectory+/+(\cf6 "________"\cf3 ););	\
	\});\
\};\
\
\{ w.view.focus; \}.defer(1);\
\
\};\
); \cf2 // EOF}