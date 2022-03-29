// ========================
// MENUUU
// ========================

(
var w, c, wb, nameList, actionList, homeDir, soundcardMenu;
var samplerFiles, samplerNames, buttonColors, buttonColorsNeg;
var winHeight;
var soundcardOuts, soundcardOrder;
var preferences, defaultPreferences, preferencesFile;
var card;

GUI.cocoa;

s= Server.internal;

~openSamplers= Dictionary.new;
~globalPreferencesOpen= false;
~makeNewWindowOpen= false;

preferencesFile = String.scDir++"/PREFERENCES/globalPreferences";
defaultPreferences= [nil!4, 12, 0, 44100, 1024, 65536, nil!4, nil, nil, nil];

if( preferencesFile.isFile, 
	{ preferences= Object.readArchive(preferencesFile); }, 
	{ preferences= defaultPreferences }
);

soundcardOrder= preferences[0];

soundcardOuts= ServerOptions.outDevices;

samplerFiles= (String.scDir+/+"SAMPLERS/*").pathMatch;

samplerNames= samplerFiles.collect({|it| it.basename.removeExtension});

~openSamplers= Dictionary.new;
samplerNames.do({|it|
	~openSamplers.put(it.asSymbol, true);
});


winHeight= (20*samplerFiles.size)+135;

w= Window("", Rect(1180, 655, 100, winHeight));
wb= w.bounds;
c= GUI.vLayoutView.new(w, Rect(0, 30, wb.width, wb.height-30));

StaticText(w, Rect(0, 10, 100, 15))
.string_("SAMPLERS")
.font_(Font("Helvetica", 15))
.align_(\center);

nameList= samplerNames;
actionList= samplerFiles;

//get background colors
buttonColors= samplerNames.collect({|it|
	var file, prefs, color;
	file= String.scDir++"/PREFERENCES/"++it++"/"++it++"_CURRENT";
	if(file.isFile, {
		prefs= Object.readArchive(file);
		color= prefs[7];
	}, {
		color= Color.white;	
	});
	
});

/*
buttonColorsNeg= buttonColors.collect({|it|
	Color(it.red.neg+1, it.green.neg+1, it.blue.neg+1, 1.0);
});


buttonColorsNeg= buttonColors.collect({|it|
	var r, g, b;
	if(it.red < 0.5, {r= 1}, {r= 0});
	if(it.green < 0.5, {g= 1}, {g= 0});
	if(it.blue < 0.5, {b= 1}, {b= 0});
	Color(r, g, b, 1.0);
});
*/

buttonColorsNeg= buttonColors.collect({|it|
	if((it.red+it.green+it.blue) < 1.5,  {Color.white}, {Color.black});
});

nameList.size.do({ |i|
	Button(c, 50@15)
	.states_([[nameList[i], buttonColorsNeg[i], buttonColors[i]]])
	.action_({
		if(~openSamplers[samplerNames[i].asSymbol], {actionList[i].load; ~openSamplers[samplerNames[i].asSymbol]= false })});
});

StaticText(c, Rect(0, 0, 50, 10))
.string_("s o u n d c a r d")
.font_(Font("Helvetica", 10))
.align_(\center);

soundcardMenu= PopUpMenu(c, (Rect(0, 0, 50, 20)))
.items_(soundcardOuts)
.value_(0)
.action_({ |v|
	s.options.outDevice= soundcardOuts[v.value]
	});

Button(c, 50@15)
	.states_([["MAKE NEW", Color.white,Color.grey]])
	.action_({
	if( ~makeNewWindowOpen == false, {
	((String.scDir).dirname++"/makeNewSampler.scd").standardizePath.load;
	});
	});

Button(c, 50@15)
	.states_([["global setup", Color.white,Color.black]])
	.action_({
	if( ~globalPreferencesOpen == false, {
	((String.scDir).dirname++"/globalPreferencesWindow.scd").standardizePath.load;
	});
	});

Button(c, 50@15)
	.states_([["kill all sound", Color.blue,Color.grey]])
	.action_({ Server.killAll; });


{
soundcardOrder.size.do({|it, i|
	var check;
	i= ((soundcardOrder.size-1) - i);

	check= soundcardOuts.detect({|it|
		it == soundcardOrder[i]
	});
	if (check.isNil.not, {card= check});
});

if (card.isNil.not, {soundcardMenu.value= soundcardMenu.items.indexOf(card); s.options.outDevice= card},{ s.options.device= nil; });
}.value;

w.view.keyDownAction= {|view, char, mod|
//[view, char, mod, char.class].postln;
if (char === $l, {
s.tryPerform(\meter);
});
};

w.front;
//MIDIClient.init;

s.options.memSize= preferences[5];
s.options.numOutputBusChannels= preferences[1];
s.options.numInputBusChannels= preferences[2];
s.options.sampleRate= preferences[3];
s.options.hardwareBufferSize= preferences[4];

("num outts:"+preferences[1]).postln;

//LAUNCH SAMPLER AT STARTUP
preferences[6].do({|it, i|
	{
		if(it.isNil.not && {it.isFile}, {
			samplerFiles.do({ |sf|
				if(sf == it, {
					it.load; ~openSamplers[(it.basename.removeExtension).asSymbol]= false; 1.wait; });
			});
		});
	}.fork(AppClock);
});


)

