{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf600
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;\red0\green0\blue191;\red191\green0\blue0;
\red0\green0\blue255;\red96\green96\blue96;\red102\green102\blue191;}
{\*\expandedcolortbl;;\csgenericrgb\c0\c0\c0;\csgenericrgb\c0\c0\c75000;\csgenericrgb\c75000\c0\c0;
\csgenericrgb\c0\c0\c100000;\csgenericrgb\c37500\c37500\c37500;\csgenericrgb\c40000\c40000\c75000;}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 + \cf3 OSXPlatform\cf2  \{\
	\
	startupFiles \{\
		\cf4 // var filename = "startup.rtf";\cf2 \
		\cf4 // ^[this.systemAppSupportDir +/+ filename, this.userAppSupportDir +/+ filename];\cf2 \
		\cf4 // look for startup files inside the app Contents directory\cf2 \
		\cf5 var\cf2  filename = \cf6 "startup.*"\cf2 ;\
		^(\cf3 String\cf2 .scDir +/+ filename).pathMatch;\
	\}\
	\
	startup \{\
		\cf3 Server\cf2 .program = \cf6 "exec % -U %"\cf2 .format(\
			(\cf3 String\cf2 .scDir +/+ \cf6 "scsynth"\cf2 ).shellQuote, \
			(\cf3 String\cf2 .scDir +/+ \cf6 "plugins"\cf2 ).shellQuote\
		);\
		\cf3 Document\cf2 .implementationClass.startup;\
		\cf3 CocoaDocument\cf2 .postColor_(\cf3 Color\cf2 .green);\
		\
		\cf4 // make a server window for the internal if you like\cf2 \
		\cf3 Server\cf2 .internal.makeWindow;\
		\cf4 // Server.local.makeWindow;\cf2 \
		\cf4 // uncomment if you use a startup file\cf2 \
		\cf4 // this.loadStartupFiles;\cf2 \
		\cf4 // uncomment if you have multiple help files\cf2 \
		\cf4 // Help.addToMenu;\cf2 \
	\}\
	\
	\cf4 // the methods below may be commented out if you want to use \cf2 \
	\cf4 // Application Support folders instead\cf2 \
	\
	\cf4 // all extension dirs point to inside the SCClassLibrary\cf2 \
	systemExtensionDir \{ ^\cf3 String\cf2 .scDir +/+ \cf6 "SCClassLibrary/Extensions"\cf2  \}\
	userExtensionDir \{ ^\cf3 String\cf2 .scDir +/+ \cf6 "SCClassLibrary/Extensions"\cf2  \}\
	\
	\cf4 // make sure the real AppSupportDir is not used (quarks also go into app's contents)\cf2 \
	userAppSupportDir \{ ^\cf3 String\cf2 .scDir \}\
	systemAppSupportDir \{ ^\cf3 String\cf2 .scDir \}\
	\
	\cf4 //resourceDir \{ ^String.scDir \}\cf2 \
	\
	\
\}\
\
+ \cf3 Main\cf2  \{\
	startup \{\
		platform = \cf7 this\cf2 .platformClass.new;\
		platform.initPlatform;\
		\
		\cf7 super\cf2 .startup;\
		\
		\cf4 //GUI.fromID( this.platform.defaultGUIScheme );\cf2 \
		\cf3 GUI\cf2 .cocoa;\
		\cf4 //GUI.qt;\cf2 \
		\
		\cf3 GeneralHID\cf2 .fromID( \cf7 this\cf2 .platform.defaultHIDScheme );\
		\
		\cf4 // Set Server.default and the 's' interpreter variable to the internal server.\cf2 \
		\cf4 // You should use the internal server for standalone applications --\cf2 \
		\cf4 // otherwise, if your application has a problem, the user will\cf2 \
		\cf4 // be stuck with a process, possibly making sound, that he won't know\cf2 \
		\cf4 // how to kill.\cf2 \
		openPorts = \cf3 Set\cf2 [\cf3 NetAddr\cf2 .langPort];\
		\cf3 Server\cf2 .default = \cf3 Server\cf2 .internal;\
		interpreter.s = \cf3 Server\cf2 .default;\
		\
		\cf4 // some folder paths that should point inside the app's Contents folder\cf2 \
		\cf3 SynthDef\cf2 .synthDefDir = \cf3 String\cf2 .scDir +/+ \cf6 "synthdefs/"\cf2 ;\
		\cf3 Archive\cf2 .archiveDir = \cf3 String\cf2 .scDir;\
		\
		\cf7 this\cf2 .platform.startup;\
		\
		\cf4 // from here on, you should customize what should happen...\cf2 \
		\
		\cf3 StartUp\cf2 .run;\
		\
		\cf4 // One can boot the server, then use .load to evaluate a file\cf2 \
		\cf4 // OR - put things into a class... like the SCSA_Demo\cf2 \
		\
		\cf6 "Welcome to SamplerCentral, click help in the menu to the right for help."\cf2 .postln;\
		\
		\cf4 //(String.scDir.dirname ++ "/loadMenu.sc").load;\cf2 \
		\
		\cf3 MIDIClient\cf2 .init;\
		\
		\cf4 //Server.default.boot;\cf2 \
		\
		\cf4 //Server.default.waitForBoot(\{\cf2 \
		\
		\
		\cf4 //(String.scDir.dirname ++ "/keyboardGigaLETesterNEW.rtf").load;\cf2 \
		\cf4 //\});\cf2 \
		\cf3 GUI\cf2 .current.postln;\
		\cf3 Document\cf2 .listener.font= \cf3 Font\cf2 (\cf6 "Monaco"\cf2 , 12);\
		\cf3 Document\cf2 .listener.background= \cf3 Color\cf2 .grey(0.001, 0.9);\
		\cf4 //Document.postColor_(Color.green);\cf2 \
		\cf3 Document\cf2 .listener.bounds_(\cf3 Rect\cf2 (0, 500, 600, 300));\
		\cf4 // close post window if user should not have it\cf2 \
		\cf4 //Document.listener.close\cf2 \
		(\cf3 String\cf2 .scDir.dirname ++ \cf6 "/loadMenu.sc"\cf2 ).load;\
	\}\
	\
\}\
}