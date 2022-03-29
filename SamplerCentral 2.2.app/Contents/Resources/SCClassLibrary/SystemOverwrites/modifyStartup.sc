+ OSXPlatform {

	startupFiles {
//		var filename = "startup.rtf";
//		^[this.systemAppSupportDir +/+ filename, this.userAppSupportDir +/+ filename];
			// look for startup files inside the app Contents directory
		var filename = "startup.*";
		^(String.scDir +/+ filename).pathMatch;
	}

	startup {
		Server.program = "exec % -U %".format(
			(String.scDir +/+ "scsynth").shellQuote, 
			(String.scDir +/+ "plugins").shellQuote
		);
		Document.implementationClass.startup;
		CocoaDocument.postColor_(Color.green);

		// make a server window for the internal if you like
		Server.internal.makeWindow;
//		Server.local.makeWindow;
		// uncomment if you use a startup file
//		this.loadStartupFiles;
		// uncomment if you have multiple help files
//		Help.addToMenu;
	}

	// the methods below may be commented out if you want to use 
	// Application Support folders instead
	
	// all extension dirs point to inside the SCClassLibrary
	systemExtensionDir { ^String.scDir +/+ "SCClassLibrary/Extensions" }
	userExtensionDir { ^String.scDir +/+ "SCClassLibrary/Extensions" }
	
	// make sure the real AppSupportDir is not used (quarks also go into app's contents)
	userAppSupportDir { ^String.scDir }
	systemAppSupportDir { ^String.scDir }
	
	//resourceDir { ^String.scDir }


}

+ Main {
	startup {
		platform = this.platformClass.new;
		platform.initPlatform;

		super.startup;

		//GUI.fromID( this.platform.defaultGUIScheme );
		GUI.cocoa;
		GeneralHID.fromID( this.platform.defaultHIDScheme );

		// Set Server.default and the 's' interpreter variable to the internal server.
		// You should use the internal server for standalone applications --
		// otherwise, if your application has a problem, the user will
		// be stuck with a process, possibly making sound, that he won't know
		// how to kill.
		Server.default = Server.internal;
		interpreter.s = Server.default;

			// some folder paths that should point inside the app's Contents folder
		SynthDef.synthDefDir = String.scDir +/+ "synthdefs/";
		Archive.archiveDir = String.scDir;

		this.platform.startup;

		// from here on, you should customize what should happen...

		StartUp.run;

		// One can boot the server, then use .load to evaluate a file
		// OR - put things into a class... like the SCSA_Demo

		"Welcome to Standalone Demo made with SuperCollider, type cmd-d for help.".postln;

		(String.scDir.dirname ++ "/loadMenu.sc").load;

		MIDIClient.init;

		//Server.default.boot;

		//Server.default.waitForBoot({
			
			
			//(String.scDir.dirname ++ "/keyboardGigaLETesterNEW.rtf").load;
		//});
		Document.listener.font= Font("Monaco", 12);
		Document.listener.background= Color.grey(0.001, 0.9);
		//Document.postColor_(Color.green);
		Document.listener.bounds_(Rect(0, 500, 600, 300));
		// close post window if user should not have it
		//Document.listener.close
	}

}
