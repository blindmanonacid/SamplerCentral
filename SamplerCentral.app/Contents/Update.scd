{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf600
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red191\green0\blue0;\red0\green0\blue0;\red0\green0\blue255;
\red0\green0\blue191;\red96\green96\blue96;\red0\green115\blue0;\red51\green51\blue191;}
{\*\expandedcolortbl;;\csgenericrgb\c75000\c0\c0;\csgenericrgb\c0\c0\c0;\csgenericrgb\c0\c0\c100000;
\csgenericrgb\c0\c0\c75000;\csgenericrgb\c37500\c37500\c37500;\csgenericrgb\c0\c45000\c0;\csgenericrgb\c20000\c20000\c75000;}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 /*\
1. Drag old app version onto DragSink (the one you want to merge from)\
2. Warning message\
3. Delete contents of\
CLOCKPRESETS, DELETED, PREFERENCES,  SAMPLERS,  SAVEFILES, SETTINGS\
4. Transfer from old\
	PREFERENCES, SAVEFILES, SETTINGS \
		+ also  , \
		CLOCKPRESETS, \
		CONDUCTORPRESETS, \
		DELETED,\
		KAOSSPADSAVES,\
		MIXERSAVES,\
		OSCRecordings,\
		PITCH_SAVEFILES,\
		ROBOTTESTERPRESETS,\
		SENDWINSAVES/DMX,\
		SENDWINSAVES/MIDI,\
		SENDWINSAVES/OSC,\
		\
		//buttons to choose which ones not to purge or merge\
		\
5. Get names of files in SAMPLERS folder\
6. copy samplerTemplate.scd to new SAMPLER folder and rename to old files names.\
\
IN THE FUTURE v3: Organize folder structure better with all "savefiles" folders grouped in one USER folder.\
\
\
\
DragSink\
SCAlert\
String.pathExists\
String.isFolder\
String.folderContents // gets contents of folder and sub folders\
String.isFile\
String.removeFile //also removes folders |toTrash = true, ask = true, silent = false|\
String.copyTo(newDir: "", newName, overwrite: false, createIfNotThere: true, silent: false)\
\
*/\cf3 \
\
(\
\cf4 var\cf3  path, clockpresetsPath, deletedPath, preferencesPath, samplersPath, savefilesPath, settingsPath;\
\cf4 var\cf3  clockpresets, deleted, preferences, samplers, savefiles, settings;\
\cf4 var\cf3  preferencesRemotePath, savefilesRemotePath, settingsRemotePath, samplersRemotePath;\
\cf4 var\cf3  preferencesRemote, savefilesRemote, settingsRemote, samplersRemote, samplersRemoteNames;\
\cf4 var\cf3  samplerTemplate;\
\cf4 var\cf3  w, d, c;\
\cf4 var\cf3  cleanUp, merge, fromText, toText;\
\
clockpresetsPath= (\cf5 String\cf3 .scDir+/+\cf6 "CLOCKPRESETS/"\cf3 );\
deletedPath= (\cf5 String\cf3 .scDir+/+\cf6 "DELETED/"\cf3 );\
preferencesPath= (\cf5 String\cf3 .scDir+/+\cf6 "PREFERENCES/"\cf3 );\
samplersPath= (\cf5 String\cf3 .scDir+/+\cf6 "SAMPLERS/"\cf3 );\
savefilesPath= (\cf5 String\cf3 .scDir+/+\cf6 "SAVEFILES/"\cf3 );\
settingsPath= (\cf5 String\cf3 .scDir+/+\cf6 "SETTINGS/"\cf3 );\
\
clockpresets= (\cf5 String\cf3 .scDir+/+\cf6 "CLOCKPRESETS/*"\cf3 ).pathMatch;\
deleted= (\cf5 String\cf3 .scDir+/+\cf6 "DELETED/*"\cf3 ).pathMatch;\
preferences= (\cf5 String\cf3 .scDir+/+\cf6 "PREFERENCES/*"\cf3 ).pathMatch; \cf2 //folders!!!\cf3 \
samplers= (\cf5 String\cf3 .scDir+/+\cf6 "SAMPLERS/*"\cf3 ).pathMatch;\
savefiles= (\cf5 String\cf3 .scDir+/+\cf6 "SAVEFILES/*"\cf3 ).pathMatch; \cf2 //folders!!!\cf3 \
settings= (\cf5 String\cf3 .scDir+/+\cf6 "SETTINGS/*"\cf3 ).pathMatch;\
\
samplerTemplate= (\cf5 String\cf3 .scDir.dirname+/+\cf6 "samplerTemplate.scd"\cf3 );\
\
w= \cf5 Window\cf3 (\cf6 "Update SamplerCentral"\cf3 , \cf5 Rect\cf3 (\cf5 Window\cf3 .screenBounds.width, \cf5 Window\cf3 .screenBounds.height, 400, 240)).front;\
\cf5 StaticText\cf3 (w, \cf5 Rect\cf3 (20, 0, 160, 60)).string_(\cf6 "drag OLDER app on square. ONLY DO THIS IF YOUR KNOW WHAT YOU'RE DOING!!"\cf3 );\
\
fromText= \cf5 StaticText\cf3 (w, \cf5 Rect\cf3 (20, 210, 170, 20)).string_(\cf6 "from"\cf3 ).align_(\cf7 \\center\cf3 );\
\cf5 StaticText\cf3 (w, \cf5 Rect\cf3 (200, 210, 20, 20)).string_(\cf6 "to:"\cf3 ).align_(\cf7 \\center\cf3 );\
toText= \cf5 StaticText\cf3 (w, \cf5 Rect\cf3 (230, 210, 170, 20))\
.string_(\cf5 String\cf3 .scDir.dirname.dirname.basename)\
.align_(\cf7 \\center\cf3 );\
\
d= \cf5 DragSink\cf3 (w, \cf5 Rect\cf3 (20, 60, 160, 130)).align_(\cf7 \\center\cf3 ).string_(\cf6 "drop app here"\cf3 );\
d.canReceiveDragHandler = \cf8 true\cf3 ;\
\cf2 //\{ View.currentDrag.isKindOf(Array) \};\cf3 \
d.receiveDragHandler = \{ \cf4 arg\cf3  v; \
	d.object = \cf5 View\cf3 .currentDrag.value;\
	d.object.postln;\
	d.object.class.postln;\
	path= d.object;\
	if(path.basename.find(\cf6 "SamplerCentral"\cf3 ) == 0, \{ \
		\cf6 "app is valid to merge"\cf3 .postln;\
		c= \cf5 View\cf3 (w, \cf5 Rect\cf3 (200, 0, 200, 200));\
		\cf5 Button\cf3 (c, \cf5 Rect\cf3 (0, 20, 100, 20)).states_([[\cf6 "reset/clean up"\cf3 ]])\
		.canFocus_(\cf8 false\cf3 )\
		.action_(\{\cf4 |v|\cf3 \
			\cf6 "SAMPLERS to be deleted:"\cf3 .postln;\
			samplers.do(\{\cf4 |it|\cf3  it.basename.postln;\});\
			\cf6 "CLOCKPRESETS to be deleted:"\cf3 .postln;\
			clockpresets.do(\{\cf4 |it|\cf3  it.basename.postln;\});\
			\cf6 "SETTINGS to be deleted:"\cf3 .postln;\
			settings.do(\{\cf4 |it|\cf3  it.basename.postln;\});\
			\cf6 "SAVEFILES to be deleted:"\cf3 .postln;\
			savefiles.do(\{\cf4 |it|\cf3  it.basename.postln;\});\
			\cf6 "PREFERENCES to be deleted:"\cf3 .postln;\
			preferences.do(\{\cf4 |it|\cf3  it.basename.postln;\});\
			\cf6 "DELETED to be deleted:"\cf3 .postln;\
			deleted.do(\{\cf4 |it|\cf3  it.basename.postln;\});\
			\
			\cf5 SCAlert\cf3 (\cf6 "this will delete all personal settings and samplers on this(!) instance of SamplerCentral"\cf3 , [\cf6 "OK"\cf3 , \cf6 "cancel"\cf3 ], [\{\
				\cf6 "do it"\cf3 .postln;\
				cleanUp.value;\
				\cf5 StaticText\cf3 (c, \cf5 Rect\cf3 (110, 20, 100, 20)).string_(\cf6 "DONE!"\cf3 );\
				\}, \{\cf6 "cancelling"\cf3 .postln \}]);\
\
		\});\
		\cf5 Button\cf3 (c, \cf5 Rect\cf3 (0, 50, 100, 20)).states_([[\cf6 "merge from old"\cf3 ]])\
		.canFocus_(\cf8 false\cf3 )\
		.action_(\{\cf4 |v|\cf3 \
			\cf5 SCAlert\cf3 (\cf6 "this will copy all personal settings from the OLD instance of SamplerCentral to THIS ONE"\cf3 , [\cf6 "OK"\cf3 , \cf6 "cancel"\cf3 ], [\{\
				\cf6 "do it"\cf3 .postln;\
				merge.value;\
				\cf5 StaticText\cf3 (c, \cf5 Rect\cf3 (110, 50, 100, 20)).string_(\cf6 "DONE!"\cf3 );\
				\}, \{\cf6 "cancelling"\cf3 .postln \}]);\
			\
			\cf6 "SAMPLERS to be copied from OLD to NEW:"\cf3 .postln;\
			samplersRemote.do(\{\cf4 |it|\cf3  it.basename.postln; \});\
			\cf6 "PREFERENCES to be copied from OLD to NEW:"\cf3 .postln;\
			preferencesRemote.do(\{\cf4 |it|\cf3  it.basename.postln; \});\
			\cf6 "SAVEFILES to be copied from OLD to NEW:"\cf3 .postln;\
			savefilesRemote.do(\{\cf4 |it|\cf3  it.basename.postln; \});\
			\cf6 "SETTINGS to be copied from OLD to NEW:"\cf3 .postln;\
			settingsRemote.do(\{\cf4 |it|\cf3  it.basename.postln; \});\
			\
		\});\
		\},\{\
		\cf6 "app is not valid!"\cf3 .postln;\
	\});\
	\cf6 "path is folder:"\cf3 .postln;\
	path.isFolder.postln;\
	path.basename.postln;\
	preferencesRemotePath= path++\cf6 "Contents/Resources/PREFERENCES/"\cf3 ;\
	savefilesRemotePath= path++\cf6 "Contents/Resources/SAVEFILES/"\cf3 ;\
	settingsRemotePath= path++\cf6 "Contents/Resources/SETTINGS/"\cf3 ;\
	samplersRemotePath= path++\cf6 "Contents/Resources/SAMPLERS/"\cf3 ;\
	preferencesRemotePath.postln;\
	preferencesRemotePath.isFolder.postln;\
	savefilesRemotePath.postln;\
	savefilesRemotePath.isFolder.postln;\
	settingsRemotePath.postln;\
	settingsRemotePath.isFolder.postln;\
	samplersRemotePath.postln;\
	samplersRemotePath.isFolder.postln;\
	\
	preferencesRemote= (preferencesRemotePath++\cf6 "*"\cf3 ).pathMatch; \cf2 //folders!!!\cf3 \
	savefilesRemote= (savefilesRemotePath++\cf6 "*"\cf3 ).pathMatch; \cf2 //folders!!!\cf3 \
	settingsRemote= (settingsRemotePath++\cf6 "*"\cf3 ).pathMatch;\
	samplersRemote= (samplersRemotePath++\cf6 "*"\cf3 ).pathMatch;\
	\
	fromText.string= path.basename;\
\};\
\
\
\
cleanUp= \{\
\cf2 //delete local clockpresets\cf3 \
clockpresets.do(\{\cf4 |it|\cf3  it.removeFile \});\
\cf2 //delete local deleted files\cf3 \
deleted.do(\{\cf4 |it|\cf3  it.removeFile \});\
\cf2 //delete local preferences\cf3 \
preferences.do(\{\cf4 |it|\cf3  it.removeFile \});\
\cf2 //delete local samplers\cf3 \
samplers.do(\{\cf4 |it|\cf3  it.removeFile \});\
\cf2 //delete local savefiles\cf3 \
savefiles.do(\{\cf4 |it|\cf3  it.removeFile \});\
\cf2 //delete local settings\cf3 \
settings.do(\{\cf4 |it|\cf3  it.removeFile \});\
\};\
\
\
merge= \{\
\cf2 // copy samplerTemplate to SAMPLERS dir with name of remote samplers\cf3 \
samplersRemoteNames= samplersRemote.collect(\{\cf4 |it|\cf3  it.basename; \});\
samplersRemoteNames.do(\{\cf4 |it|\cf3  \
	samplerTemplate.copyTo(samplersPath, it);\
\});\
\cf2 //copy preferences\cf3 \
preferencesRemote.do(\{\cf4 |it|\cf3 \
	it.copyTo(preferencesPath, it.basename);\
\});\
\cf2 //copy savefiles\cf3 \
savefilesRemote.do(\{\cf4 |it|\cf3 \
	it.copyTo(savefilesPath, it.basename);\
\});\
\cf2 //copy settings\cf3 \
settingsRemote.do(\{\cf4 |it|\cf3 \
	it.copyTo(settingsPath, it.basename);\
\});\
\};\
\
) \cf2 // EOF\cf3 \
}