{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf600
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red191\green0\blue0;\red0\green0\blue0;\red0\green0\blue191;
\red0\green0\blue255;\red51\green51\blue191;\red102\green102\blue191;\red96\green96\blue96;\red0\green115\blue0;
}
{\*\expandedcolortbl;;\csgenericrgb\c75000\c0\c0;\csgenericrgb\c0\c0\c0;\csgenericrgb\c0\c0\c75000;
\csgenericrgb\c0\c0\c100000;\csgenericrgb\c20000\c20000\c75000;\csgenericrgb\c40000\c40000\c75000;\csgenericrgb\c37500\c37500\c37500;\csgenericrgb\c0\c45000\c0;
}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 /*\
PresetMenuGUI\
\
\
PresetMenuGUI.new(view, x position y position, saveAction, loadAction)\
saveAction = \{[presetDict, storedKeyValues, pitchmenuitems]\}\
loadAction = \{|array| presetDict= array[0]; storedKeyValues= array[1]; etc... \}\
*/\cf3 \
\cf4 PresetMenuGUI\cf3 \{\
	\cf5 var\cf3  w, savePreset, loadPreset;\
	\cf5 var\cf3  win, x, y;\
	\cf5 var\cf3  view, title, filesDir, files, savefiles, backup, reloadSavefiles;\
	\cf5 var\cf3  currentPresetPath, loadmenu, menuitem, dirbutton, loadPresetBut, wrefresh;\
	\cf5 var\cf3  loadAction, saveAction;\
\
	*new\{ \cf5 arg\cf3  win, x, y, savepath= \cf6 nil\cf3 , saveAction, loadAction;\
		^\cf7 super\cf3 .new.init(win, x, y, savepath, saveAction, loadAction);\
	\}\
\
	init\{ \cf5 arg\cf3  argwin, argx, argy, argsavepath, argSaveAction, argLoadAction;\
\
		win= argwin;\
		x= argx;\
		y= argy;\
		if (x.isNil, \{x= 0\});\
		if (y.isNil, \{y= 0\});\
\
		loadAction= argLoadAction;\
		saveAction= argSaveAction;\
		filesDir= argsavepath;\
		filesDir.postln;\
\
		\cf2 /*\
		if (savepath.isNil.not, \{\
			if(filesDir.isFolder.not, \{filesDir.makeDir\});\
		\});\
		*/\cf3 \
\
		view= \cf4 CompositeView\cf3 (win, \cf4 Rect\cf3 (x, y, 200, 60));\
\
		\cf4 StaticText\cf3 (view, \cf4 Rect\cf3 (0, 0, 50, 30))\
		.string_(\cf8 "Active:"\cf3 )\
		.background_(\cf4 Color\cf3 .grey.alpha_(0.5))\
		.align_(\cf9 \\center\cf3 );\
\
		\cf4 StaticText\cf3 (view, \cf4 Rect\cf3 (0, 30, 50, 15))\
		.string_(\cf8 "Presets:"\cf3 )\
		.background_(\cf4 Color\cf3 .grey.alpha_(0.5))\
		.align_(\cf9 \\center\cf3 );\
		\cf2 //.font_(Font("Monaco", 9));\cf3 \
\
		title= \cf4 StaticText\cf3 (view, \cf4 Rect\cf3 (50, 0, 120, 30))\
		.background_(\cf4 Color\cf3 .grey.alpha_(0.3));\
\
		\cf4 Button\cf3 (view, \cf4 Rect\cf3 (170, 0, 30, 20))\
		.states_([[\cf8 "S"\cf3 ]])\
		.canFocus_(\cf6 false\cf3 )\
		.action_(\{ \cf7 this\cf3 .save; \});\
\
		files= (filesDir++\cf8 "*"\cf3 ).standardizePath.pathMatch;\
		savefiles= files.addFirst(\cf8 "none"\cf3 );\
		files= files.addFirst(\cf8 "none"\cf3 );\
		savefiles= savefiles.collect(\{\cf5 |it|\cf3  it.basename\});\
\
		loadmenu= \cf4 PopUpMenu\cf3 (view, \cf4 Rect\cf3 (50, 30, 120, 30))\
		.canFocus_(\cf6 false\cf3 )\
		.stringColor_(\cf4 Color\cf3 .green)\
		.background_(\cf4 Color\cf3 .grey.alpha_(0.5))\
		.items_( savefiles )\
		.keyDownAction_(\{\cf5 |view, char|\cf3 \
			if(char==$\\r, \{\
				\cf2 //"return".postln;\cf3 \
				\cf2 //view.focus_(false);\cf3 \
				\{loadPresetBut.mouseDownAction.value(\cf6 nil\cf3 , 0, 0, 0, 0, 1)\}.defer;\
			\});\
\
		\})\
		.action_(\{ \cf5 |v|\cf3 \
			menuitem= v.items.at(v.value);\
			\cf2 //menuitem.postln;\cf3 \
			\cf2 //files[loadmenu.value].postln;\cf3 \
			\cf2 //("menu size:"+loadmenu.items.size).postln;\cf3 \
			\cf2 //("files size:"+files.size).postln;\cf3 \
			\cf2 //("loadmenu fileS:"+loadmenu.items).postcs;\cf3 \
			\cf2 //("files fileS:"+files).postcs;\cf3 \
		\});\
		menuitem= \cf8 "none"\cf3 ;\
\
		dirbutton= \cf4 Button\cf3 (view, \cf4 Rect\cf3 (0, 45, 50, 15))\
		.canFocus_(\cf6 false\cf3 )\
		.states_([[\cf8 "saves"\cf3 ], [\cf8 "backup"\cf3 ] ])\
		.font_(\cf4 Font\cf3 (\cf8 "Helvetica"\cf3 , 9))\
		.action_(\{ \cf5 |v|\cf3 \
			\cf5 var\cf3  directory;\
			if (v.value == 1, \{\
				directory= filesDir++\cf8 "backup/"\cf3 ;\
			\},\{\
				directory= filesDir;\
			\});\
			files= (directory++\cf8 "*"\cf3 ).standardizePath.pathMatch;\
			savefiles= files.addFirst(\cf8 "none"\cf3 );\
			files= files.addFirst(\cf8 "none"\cf3 );\
			savefiles= savefiles.collect(\{\cf5 |it|\cf3  it.basename\});\
			loadmenu.items= savefiles;\
		\});\
\
		loadPresetBut= \cf4 Button\cf3 (view, \cf4 Rect\cf3 (170, 40, 30, 20))\
		.canFocus_(\cf6 false\cf3 )\
		.states_([[\cf8 "L"\cf3 , \cf4 Color\cf3 .red, \cf4 Color\cf3 .black]])\
		.mouseDownAction_(\{ \cf5 |view, x, y, mod|\cf3 \
			if( mod.isAlt, \{\
				\cf7 this\cf3 .delete;\
			\},\{\
				\cf7 this\cf3 .load;\
\
			\});\
		\});\
\
\
		\cf4 Button\cf3 (view, \cf4 Rect\cf3 (170, 20, 30, 20))\
		.canFocus_(\cf6 false\cf3 )\
		.states_([[\cf8 "qs"\cf3 , \cf4 Color\cf3 .white, \cf4 Color\cf3 .grey]])\
		.action_(\{ \cf5 |v|\cf3 \
			\cf7 this\cf3 .overwrite;\
		\});\
\
\
	\}\
\
	\cf2 // INIT FINISHED\cf3 \
\
	save\{ \cf2 //save preset\cf3 \
		\cf5 var\cf3  w, t, saveBut;\
		w= \cf4 Window\cf3 (\cf8 "save"\cf3 , \cf4 Rect\cf3 (400, 400, 300, 100))\
		.alwaysOnTop_(\cf6 true\cf3 );\
\
		t= \cf4 TextView\cf3 (w, \cf4 Rect\cf3 (10, 10, 280, 20))\
		.focus(\cf6 true\cf3 )\
		.keyDownAction_(\{\cf5 |view, char, mod, uni, key|\cf3 \
			if(key == 36, \{ saveBut.valueAction= 1 \});\
		\});\
\
		saveBut= \cf4 Button\cf3 (w, \cf4 Rect\cf3 (10, 40, 100, 40))\
		.states_([[\cf8 "save"\cf3 ]])\
		.action_(\{\
			\cf5 var\cf3  values, path, stringSize;\
			stringSize= t.string.size;\
			if (stringSize > 0, \{\
\
				path= filesDir++(t.string);\
				\cf2 //this.backup;\cf3 \
				values= saveAction.value;\
				values.writeArchive(path);\
				currentPresetPath= path;\
				dirbutton.doAction;\
				title.string= path.basename;\
				title.align= \cf9 \\center\cf3 ;\
				\cf7 this\cf3 .reloadSavefiles;\
				w.close;\
			\});\
\
\
		\});\
\
		\cf4 Button\cf3 (w, \cf4 Rect\cf3 (120, 40, 100, 40))\
		.states_([[\cf8 "cancel"\cf3 ]])\
		.action_(\{\
			w.close;\
		\});\
\
		w.front;\
	\}\
\
	overwrite\{\
		\cf5 var\cf3  values, path;\
		path= currentPresetPath;\
		\cf7 this\cf3 .backup;\
		values= saveAction.value;\
		values.writeArchive(path);\
	\}\
\
	load\{\cf5 |paths|\cf3 \
		\cf5 var\cf3  values, file, oldPropSize;\
		if(paths.isNil.not, \{\
			values= \cf4 Object\cf3 .readArchive(paths);\
			currentPresetPath= paths;\
			values= loadAction.value(values); \cf2 //MAGIC!\cf3 \
			title.string= paths.basename;\
			title.align= \cf9 \\center\cf3 ;\
			\{view.refresh\}.defer;\
		\},\{\
\
		if (menuitem == \cf8 "none"\cf3  or: \{menuitem == \cf8 "backup"\cf3 \}, \{\cf6 nil\cf3 \}, \{\
\
			\cf2 //("loading"+files[loadmenu.value]).postln;\cf3 \
			\cf2 //values= Object.readArchive(files[loadmenu.value]);\cf3 \
\
			if (dirbutton.value == 0, \{\
				currentPresetPath= filesDir++loadmenu.item;\
				(\cf8 "loading"\cf3 +(filesDir++loadmenu.item)).postln;\
				values= \cf4 Object\cf3 .readArchive((filesDir++loadmenu.item));\
			\},\{\
				currentPresetPath= filesDir++\cf8 "backup/"\cf3 ++loadmenu.item;\
				(\cf8 "loading"\cf3 +(filesDir++\cf8 "backup/"\cf3 ++loadmenu.item)).postln;\
				values= \cf4 Object\cf3 .readArchive((filesDir++\cf8 "backup/"\cf3 ++loadmenu.item));\
			\});\
\
			values= loadAction.value(values); \cf2 //MAGIC!\cf3 \
			title.string= currentPresetPath.basename;\
			title.align= \cf9 \\center\cf3 ;\
			\{view.refresh\}.defer;\
		\});\
		\});\
\
	\}\
\
	delete\{\
		if (currentPresetPath.isNil.not, \{\
			if (dirbutton.value == 0, \{\
				currentPresetPath= filesDir++loadmenu.item;\
				\cf7 this\cf3 .backup;\
			\},\{\
				currentPresetPath= filesDir++\cf8 "backup/"\cf3 ++loadmenu.item;\
\
			\});\
			currentPresetPath.removeFile;\
			\cf7 this\cf3 .reloadSavefiles;\
			title.string= \cf8 "none"\cf3 ;\
			title.align= \cf9 \\center\cf3 ;\
		\},\{\
			\cf8 "no preset to delete"\cf3 .postln;\
		\});\
\
	\}\
\
	\cf2 //make private??\cf3 \
	backup \{\
		\cf5 var\cf3  file, filename, backupname, backupdir, dir;\
		if (currentPresetPath.isNil.not, \{\
			file= currentPresetPath.basename;\
			dir= filesDir;\
			backupdir= dir++\cf8 "backup/"\cf3 ;\
\
			if (\cf4 File\cf3 .exists(dir++file)) \{\
				if(backupdir.isFolder.not, \{backupdir.makeDir\});\
\
				backupname = file ++ \cf8 ".backup_"\cf3  ++ \cf4 Date\cf3 .getDate.stamp;\
\
				(dir++file).copyTo(dir++\cf8 "backup/"\cf3 , backupname)\
\
			\};\
		\});\
	\}\
\
	reloadSavefiles \{\
		files= (filesDir++\cf8 "*"\cf3 ).standardizePath.pathMatch;\
		savefiles= files.addFirst(\cf8 "none"\cf3 );\
		files= files.addFirst(\cf8 "none"\cf3 );\
		savefiles= savefiles.collect(\{\cf5 |it|\cf3  it.basename\});\
		loadmenu.items= ( savefiles );\
	\}\
\
\
\}\
}