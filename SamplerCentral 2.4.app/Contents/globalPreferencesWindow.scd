
(
var w, c;
var soundcardOrder;
var file, preferences, defaultPreferences;
var writeSettings;
var outputBusChannelView, inputBusChannelView, samplerateItems, samplerateView;
var bufferSizeItems, bufferSizeView, memorySizeItems, memorySizeView;
var deleteMenu, samplerFiles, samplerNames;
var deleteSampler, launchSamplers;

~globalPreferencesOpen= true;

file = String.scDir++"/PREFERENCES/globalPreferences";
defaultPreferences= [nil!4, 12, 0, 44100, 1024, 65536, nil!4, nil, nil, nil];

if( file.isFile, { preferences= Object.readArchive(file); }, { preferences= defaultPreferences });

soundcardOrder= preferences[0];
launchSamplers= preferences[6];

w= Window("Global Sampler Central Settings", Rect(400, 400, 400, 580));

c= CompositeView(w, Rect(10, 10, 380, 560))
.background_(Color(0.5, 0.6, 0.6, 1.0));

StaticText(w, Rect(10, 10, 380, 40))
.string_("Global Preferences:")
.align_(\center)
.font_(Font.new("Helvetica", 24));

// SOUND CARD CONNECTION PRIORITY
StaticText(c, Rect(10, 40, 360, 20))
.string_("Sound Card Connection Priority:")
.align_(\center)
.background_(Color.grey)
.font_(Font.new("Helvetica", 15));

soundcardOrder.do({|it, i|
	var current;

	StaticText(c, Rect(20, 70+(i*30), 60, 20))
	.string_((i+1).asString++". Priority:")
	.align_(\left)
	.font_(Font.new("Helvetica", 12));

	current= StaticText(c, Rect(80, 70+(i*30), 130, 20))
	.string_(it.asString)
	.align_(\center)
	.background_(Color.white)
	.font_(Font.new("Helvetica", 10));	
	
	PopUpMenu(c, Rect(210, 70+(i*30), 150, 20))
	.items_(ServerOptions.outDevices)
	.action_({|v| 
		soundcardOrder[i]= v.items[v.value];
		current.string= v.items[v.value];
		current.align= \center;
		current.font= Font.new("Helvetica", 10);
		});

});

// AUDIO SETTINGS
StaticText(c, Rect(10, 190, 210, 20))
.string_("Audio Settings:")
.align_(\center)
.background_(Color.grey)
.font_(Font.new("Helvetica", 15));

//Output Bus Channels
StaticText(c, Rect(20, 220, 180, 20))
.string_("Output Bus Channels:")
.align_(\left)
.font_(Font.new("Helvetica", 12));

outputBusChannelView= NumberBox(w, Rect(150, 230, 30, 20))
.value_(preferences[1].asInteger)
.action_({|v| preferences[1]= v.value })
.step_(1)
.clipLo_(2)
.clipHi_(50);

//Input Bus Channels
StaticText(c, Rect(20, 250, 180, 20))
.string_("Input Bus Channels:")
.align_(\left)
.font_(Font.new("Helvetica", 12));

inputBusChannelView= NumberBox(w, Rect(150, 260, 30, 20))
.value_(preferences[2].asInteger)
.action_({|v| preferences[2]= v.value })
.step_(1)
.clipLo_(1)
.clipHi_(50);

//Sample Rate
StaticText(c, Rect(20, 280, 180, 20))
.string_("Sample Rate:")
.align_(\left)
.font_(Font.new("Helvetica", 12));

samplerateItems= [\22050, \44100, \48000, \96000];
samplerateView= PopUpMenu(w, Rect(120, 290, 100, 20))
.items_(samplerateItems)
.value_(samplerateItems.indexOf(preferences[3].asSymbol))
.action_({|v| preferences[3]= v.item.asInteger});

//HW Buffer Size
StaticText(c, Rect(20, 310, 180, 20))
.string_("HW Buffer Size:")
.align_(\left)
.font_(Font.new("Helvetica", 12));

bufferSizeItems= [\512,\1024, \2048, \4096];
bufferSizeView= PopUpMenu(w, Rect(120, 320, 100, 20))
.items_(bufferSizeItems)
.value_(bufferSizeItems.indexOf(preferences[4].asSymbol))
.action_({|v| preferences[4]= v.item.asInteger});

//HW Memory Size
StaticText(c, Rect(20, 340, 180, 20))
.string_("Memory Size:")
.align_(\left)
.font_(Font.new("Helvetica", 12));

memorySizeItems= [\65536];
memorySizeView= PopUpMenu(w, Rect(120, 350, 100, 20))
.items_(memorySizeItems)
.value_(memorySizeItems.indexOf(preferences[5].asSymbol))
.action_({|v| preferences[5]= v.item.asInteger});



// DELETE SAMPLER
StaticText(c, Rect(225, 190, 145, 20))
.string_("Delete Sampler:")
.align_(\center)
.background_(Color.grey)
.font_(Font.new("Helvetica", 15));

samplerFiles= (String.scDir++"/"++"SAMPLERS/*").pathMatch;
samplerNames= samplerFiles.collect({|it| it.basename.removeExtension});


deleteMenu= ListView(c,Rect(230,240,130,120));
deleteMenu.items = samplerNames;

Button(c, Rect(230, 220, 130, 18))
.states_([["delete selected", Color.red, Color.black]])
.action_({ deleteSampler.value(deleteMenu.item); });

// LAUNCH SAMPLERS AT STARTUP
StaticText(c, Rect(10, 370, 360, 20))
.string_("Launch Sampler at Startup:")
.align_(\center)
.background_(Color.grey)
.font_(Font.new("Helvetica", 15));

launchSamplers.do({|it, i|
	var current;

	StaticText(c, Rect(20, 400+(i*30), 60, 20))
	.string_((i+1).asString++". Launch:")
	.align_(\left)
	.font_(Font.new("Helvetica", 12));

	current= StaticText(c, Rect(80, 400+(i*30), 130, 20))
	//.string_(samplerNames[i].asString)
	.align_(\center)
	.background_(Color.white)
	.font_(Font.new("Helvetica", 10));
	if(it.isNil.not, {current.string= (it.basename.removeExtension)});
	
	PopUpMenu(c, Rect(210, 400+(i*30), 130, 20))
	.items_(samplerNames)
	.action_({|v|
		launchSamplers[i]= samplerFiles[v.value];
		current.string= v.items[v.value];
		current.align= \center;
		current.font= Font.new("Helvetica", 10);
		});
	Button(c, Rect(340, 400+(i*30), 20, 20))
	.states_([["rm", Color.red, Color.black]])
	.action_({
		launchSamplers[i]= nil;
		{ current.string_("") }.defer;
		});

});

deleteSampler= {|name|
	var alert, samplerFile, savefilePath, settingsFile, prefPath, nameDate;
	
	nameDate= name++"_"++Date.getDate.stamp;
	samplerFile= String.scDir+/+"SAMPLERS/"++name++".scd";
	savefilePath= String.scDir+/+"SAVEFILES/"++name;
	settingsFile= String.scDir+/+"SETTINGS/"++name++"SETUP";
	prefPath= String.scDir+/+"PREFERENCES/"++name;
	
	alert = SCAlert( ("Permanently delete"+name+"???"), ["cancel", "DO IT!"] );
	//a.buttonClosesWindow_( false );
	alert.actions_( [ 
		{ alert.window.close }, // cancel closes the window
		{ 
		
		(String.scDir+/+"DELETED/"++nameDate++"/SAVEFILES").makeDir;
		(String.scDir+/+"DELETED/"++nameDate++"/PREFERENCES").makeDir;
		
		samplerFile.moveTo(String.scDir+/+"DELETED/"++nameDate, name);
		savefilePath.moveTo(String.scDir+/+"DELETED/"++nameDate++"/SAVEFILES", name);
		settingsFile.moveTo(String.scDir+/+"DELETED/"++nameDate, name++"SETUP");
		prefPath.moveTo(String.scDir+/+"DELETED/"++nameDate++"/PREFERENCES", name);

		samplerNames.removeAt(deleteMenu.value);
		deleteMenu.items = samplerNames;
		} ] );
	};


writeSettings= { //write both setup and preferences? or have preferences override settings?
	var currentPrefs, savedText;

		preferences[0]= soundcardOrder;
		preferences[6]= launchSamplers;

		currentPrefs= preferences;
	
		currentPrefs.writeArchive(file);

		{ // confirmation text routine
		savedText= StaticText(w, Rect(200, 540, 150, 20))
		.string_("Preferences saved!").background_(Color.green).align_(\center);
		2.wait;
		savedText.string= "";
		savedText.background_(Color(0.0, 0.0, 0.0, 0.0));
		Button(w, Rect(200, 540, 150, 20))
		.states_([["Restart", Color.black, Color.green]])
		.action_({
		thisProcess.recompile;
		});
		}.fork(AppClock);
	
};


Button(w, Rect(30, 540, 150, 20))
.states_([["Save Preferences!", Color.black, Color(0.46268656716418, 0.86567164179104, 0.47761194029851, 1.0)]])
.action_({
	|v|
	writeSettings.value;
	});


w.onClose= {
	~globalPreferencesOpen= false;
	};

w.front;
)