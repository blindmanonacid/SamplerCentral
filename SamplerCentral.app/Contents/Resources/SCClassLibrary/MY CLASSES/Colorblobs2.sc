{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf600
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red191\green0\blue0;\red0\green0\blue0;\red0\green0\blue191;
\red0\green0\blue255;\red51\green51\blue191;\red102\green102\blue191;\red0\green115\blue0;\red96\green96\blue96;
}
{\*\expandedcolortbl;;\csgenericrgb\c75000\c0\c0;\csgenericrgb\c0\c0\c0;\csgenericrgb\c0\c0\c75000;
\csgenericrgb\c0\c0\c100000;\csgenericrgb\c20000\c20000\c75000;\csgenericrgb\c40000\c40000\c75000;\csgenericrgb\c0\c45000\c0;\csgenericrgb\c37500\c37500\c37500;
}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 /*\
\
\
\
to do:\
	fix bugs: \
	in SwingOSC ListView is not working\
\
\
possible improvements:\
	maybe to use with other gui controllers, include\
	getGUIVars \{\
	\
	\}\
	something like (w.view.children[0].valueAction= 1)\
	filter out useable GUIs\
	to use a window as an input?\
	\
	make resizable\
\
*/\cf3 \
\
\
\cf4 Colorblobs2\cf3 \{\
	\cf5 var\cf3  <>guis,<curloc;\
	\cf5 var\cf3  <points;\
	\cf5 var\cf3  <parameterDict;\
	\cf5 var\cf3  <weightDict;\
	\cf5 var\cf3  <defaultParDict;\
	\cf5 var\cf3  <parKeys;\
	\cf5 var\cf3  <currentPars;\
	\cf5 var\cf3  <weightfactor=2;\
	\cf5 var\cf3  <>mindist = 1;\
	\cf5 var\cf3  weight;\
	\cf5 var\cf3  shift, ctrl, alt;\
	\cf5 var\cf3  dummy;\
	\cf5 var\cf3  parentView, rect, inputs;\
	\cf5 var\cf3  gates;\
	\cf5 var\cf3  <>verbose= \cf6 false\cf3 ;\
\
	\cf2 // GUI\cf3 \
	\cf5 var\cf3  w, <v, all, tmppoint, getPoint, move;\
	\cf5 var\cf3  colors;\
	\cf5 var\cf3  rect;\
	\cf5 var\cf3  <bgcolor;\
	\
	\cf2 // save load\cf3 \
	\cf5 var\cf3  saveFiles, loadMenu, loadMenuItem, currentSaveFile;\
\
	*new\{ \cf5 arg\cf3  parentView, rect, inputs, saveDirectory, gates, pressAction, releaseAction; \cf2 //inputs is an array!\cf3 \
		^\cf7 super\cf3 .new.init(parentView, rect, inputs, saveDirectory, gates, pressAction, releaseAction);\
	\}\
\
	init\{ \cf5 arg\cf3  parentView, rect, inputs, saveDirectory, gates, pressAction, releaseAction; \
		points = \cf4 List\cf3 .new; \cf2 //coordinates of points\cf3 \
		parKeys = \cf4 List\cf3 .new; \cf2 // list for GUI variables\cf3 \
		parameterDict = \cf4 MultiLevelIdentityDictionary\cf3 .new; \cf2 //a point looks up its parameters\cf3 \
		defaultParDict = \cf4 IdentityDictionary\cf3 .new; \cf2 //default parameters\cf3 \
		weightDict = \cf4 IdentityDictionary\cf3 .new; \cf2 //weights \cf3 \
		curloc = \cf4 Point\cf3 .new; \cf2 //current location\cf3 \
		currentPars = \cf4 IdentityDictionary\cf3 .new; \cf2 //current parameters\cf3 \
\
		weight = weight ? weightfactor;\
\
		\cf4 Platform\cf3 .case(\
			\cf8 \\osx\cf3 ,		\{ ctrl= 262144; shift= 131072; alt= 524288\},\
			\cf8 \\linux\cf3 ,		\{ ctrl= 262144; shift= 131072; alt= 1048576\},\
			\cf8 \\windows\cf3 , 	\{ ctrl= 262144; shift= 131072; alt=\cf6 nil\cf3 ; \}\
		);\
\
\
		parKeys.array_(inputs); \cf2 //put the GUI variables into a list\cf3 \
		\cf2 //inputs.do(\{|it| parKeys.\cf3 \
\
		parKeys.do(\{\cf5 |it|\cf3  \cf2 //weights\cf3 \
			weightDict.put(it, weight);\
		\});\
		\
		parKeys.do(\{\cf5 |it|\cf3 	\cf2 //initial values\cf3 \
			case\
			\{ [\cf4 S\cf3 lider, \cf4 N\cf3 umberBox,\cf4 B\cf3 utton,\cf4 P\cf3 opUpMenu, \cf4 L\cf3 istView, \cf4 K\cf3 nob, \cf4 EZSlider\cf3 , \cf4 EZPopUpMenu\cf3 , \cf4 EZListView\cf3 , \cf4 EZNumber\cf3 , \cf4 EZKnob\cf3 ].includes(it.class)\} \{ \
				defaultParDict.put( it, it.value.round(0.001).deepCopy );\
				currentPars.put(it, it.value.round(0.001).deepCopy);\}\
			\{it.class == \cf4 S\cf3 lider2D\} \{  \
				defaultParDict.put( it, [it.x.round(0.001).deepCopy, it.y.round(0.001).deepCopy] );\
				currentPars.put(it, [it.x.round(0.001).deepCopy, it.y.round(0.001).deepCopy]);\}\
			\{it.class == \cf4 R\cf3 angeSlider\} \{ \
				defaultParDict.put( it, [it.lo.round(0.001).deepCopy, it.hi.round(0.001).deepCopy] ); \
				currentPars.put(it, [it.lo.round(0.001).deepCopy, it.hi.round(0.001).deepCopy]);\}\
			\{it.class == \cf4 S\cf3 oundFileView\} \{ \
				dummy= it.selectionStart(0).deepCopy;\
				\cf2 //dummy.class.postln;\cf3 \
				\cf2 //dummy.postln;\cf3 \
				defaultParDict.put( it, dummy );	\
				currentPars.put(it, it.selectionStart(0).deepCopy);\}\
			\{it.class == \cf4 M\cf3 ultiSliderView\} \{ \
				defaultParDict.put( it, it.value.round(0.001).deepCopy );\
				currentPars.put(it, it.value.round(0.001).deepCopy);\};		\
		\});\
		\
	\
		\
		\cf2 //GUI\cf3 \
\
\
		colors= [\cf4 Color\cf3 .green, \cf4 Color\cf3 .red, \cf4 Color\cf3 .yellow, \cf4 Color\cf3 .blue, \cf4 Color\cf3 .new255(127, 255, 212), \cf4 Color\cf3 .new255(208, 32, 144), \cf4 Color\cf3 .new255(255, 192, 203), \cf4 Color\cf3 .new255(255, 105, 180), \cf4 Color\cf3 .new255(107, 142, 35), \cf4 Color\cf3 .new255(255, 165, 0)];\
		\
		tmppoint= 0;\
		\
		w= parentView;\
		w ?? \{w= \cf4 W\cf3 indow.new(\cf9 "colorblobs"\cf3 , \cf4 Rect\cf3 (800, 0, 300, 300))\};\
		rect ?? \{rect= \cf4 Rect\cf3 (0, 0, 300, 300)\};\
		v= \cf4 U\cf3 serView.new(w, rect)\
		.background_(\cf4 Color\cf3 .black)\
		.canFocus_( \cf6 false\cf3  )\
		.mouseDownAction_(\{ \cf5 arg\cf3  view,x,y, mod;\
			\cf7 this\cf3 .mouseDown(view, x, y, mod);\
		\})\
		.mouseMoveAction_(\{ \cf5 arg\cf3  view,x,y, mod;\
			\cf7 this\cf3 .mouseMove(x, y, mod);\
		\})\
		.mouseUpAction_(\{ \cf5 arg\cf3  view, x, y, mod;\
			if (mod == ctrl, \{\
				case \
				\{tmppoint.isNil.not\} \{\cf7 this\cf3 .addPoint(tmppoint);\
					tmppoint = \cf6 nil\cf3 ;\
					view.refresh;\}				\
			\});\
		\})\
\
        .drawFunc_(\{\
			\cf5 var\cf3  pt, sizeF;\
			\
            \cf4 P\cf3 en.use \{  \
                \cf4 P\cf3 en.width = 2;\
				\
                if (tmppoint.isNil.not \{\
					\cf4 P\cf3 en.color = \cf4 Color\cf3 .white;\
					\cf4 P\cf3 en.fillOval( \cf4 Rect\cf3 ( tmppoint.x-20, tmppoint.y-20, 40, 40));\
                \});\
                points.do\{  \cf5 arg\cf3  p, i; \
		                \
					10.do(\{\cf5 |count|\cf3 \
						sizeF= ((count-10).abs)*0.1;\
						\cf4 P\cf3 en.color = colors[i].alpha_(count*0.1);\
						\cf4 P\cf3 en.fillOval( \cf4 Rect\cf3 ( p.x-(sizeF*25), p.y-(sizeF*25), sizeF*50, sizeF*50));\
					\})\
					\
				\};\
				\
				\cf2 //crosshair\cf3 \
				\cf4 P\cf3 en.color = \cf4 Color\cf3 .white;\
				\cf4 P\cf3 en.moveTo( curloc.translate( -8 @  0 ));\
				\cf4 P\cf3 en.lineTo( curloc.translate( -2 @  0 ));\
				\cf4 P\cf3 en.moveTo( curloc.translate(  0 @ (-8) ));\
				\cf4 P\cf3 en.lineTo( curloc.translate(  0 @ (-2) ));\
				\cf4 P\cf3 en.moveTo( curloc.translate(  2 @ 0 ));\
				\cf4 P\cf3 en.lineTo( curloc.translate(  8 @ 0 ));\
				\cf4 P\cf3 en.moveTo( curloc.translate(  0 @ 2 ));\
				\cf4 P\cf3 en.lineTo( curloc.translate(  0 @ 8 ));\
				\
                \cf4 P\cf3 en.stroke;\
            \};\
        \});\
		getPoint = \{\cf5 |xx, yy|\cf3  \cf2 //check within what circle the mouse is\cf3 \
			\cf5 var\cf3  val;\
			points.do\{\cf5 |p, i|\cf3 \
				if(p.x >= (xx-20), \{\
					if (p.x <= (xx+20), \{\
						if(p.y >= (yy-20), \{\
							if (p.y <= (yy+20), \{ val = points[i] \}); \cf2 //move\cf3 \
						\});\
					\});\
				\});\
			\};\
			val;\
		\};\
		\
		\
		\cf2 // ============  Load Save Menu  ============\cf3 \
\
		saveFiles= (saveDirectory++\cf9 "*"\cf3 ).standardizePath.pathMatch;\
		\cf2 //saveDirectory.postln;\cf3 \
		\cf2 //saveFiles.postln;\cf3 \
		loadMenu= \cf4 PopUpMenu\cf3 (w, \cf4 Rect\cf3 (rect.left+0, rect.bottom, 60, 15))\
		.items_(saveFiles.collect(\{\cf5 |it|\cf3  it.basename\}))\
		.canFocus_(\cf6 false\cf3 )\
		.background_(\cf4 Color\cf3 .grey)\
		.font_(\cf4 Font\cf3 (\cf9 "Helvetica"\cf3 , 10))\
		.action_(\{\cf5 |v|\cf3 \
			loadMenuItem= v.items.at(v.value);\
			if(verbose, \{\
			loadMenuItem.postln; \
			saveFiles[loadMenu.value].postln;\
			\});\
		\});\
		\cf4 Button\cf3 (w, \cf4 Rect\cf3 (rect.left+60, rect.bottom, 15, 15))\
		.states_([[\cf9 "L"\cf3 , \cf4 Color\cf3 .red, \cf4 Color\cf3 .black]])\
		.canFocus_(\cf6 false\cf3 )\
		.font_(\cf4 Font\cf3 (\cf9 "Helvetica"\cf3 , 10))\
		.action_(\{ if (loadMenuItem.isNil.not, \{ \cf7 this\cf3 .load(saveFiles[loadMenu.value])\}) \});\
		\cf4 Button\cf3 (w, \cf4 Rect\cf3 (rect.left+75, rect.bottom, 20, 15))\
		.states_([[\cf9 "qs"\cf3 ]])\
		.canFocus_(\cf6 false\cf3 )\
		.font_(\cf4 Font\cf3 (\cf9 "Helvetica"\cf3 , 10))\
		.action_(\{ \cf7 this\cf3 .save(saveDirectory+/+saveFiles[loadMenu.value]) \});\
		\cf4 Button\cf3 (w, \cf4 Rect\cf3 (rect.left+95, rect.bottom, 15, 15))\
		.states_([[\cf9 "s"\cf3 ]])\
		.canFocus_(\cf6 false\cf3 )\
		.font_(\cf4 Font\cf3 (\cf9 "Helvetica"\cf3 , 10))\
		.action_(\{\
			\cf2 //save preset\cf3 \
			\cf5 var\cf3  w, t, name, saveBut;\
				w= \cf4 Window\cf3 (\cf9 "save"\cf3 , \cf4 Rect\cf3 (400, 400, 230, 100), border: \cf6 false\cf3 )\
				.background_(\cf4 Color\cf3 .black)\
				.alwaysOnTop_(\cf6 true\cf3 );\
	\
				t= \cf4 TextView\cf3 (w, \cf4 Rect\cf3 (10, 10, 210, 20))\
				.focus(\cf6 true\cf3 )\
				.keyDownAction_(\{\cf5 |view, char, mod, uni, key|\cf3 \
					if(key == 36, \{ \{saveBut.valueAction= 1\}.defer; \});\
				\});\
				\
				saveBut= \cf4 Button\cf3 (w, \cf4 Rect\cf3 (10, 40, 100, 40))\
				.states_([[\cf9 "save"\cf3 ]])\
				.action_(\{\
					\cf5 var\cf3  values, path, stringSize;\
					stringSize= t.string.size;\
					if (stringSize > 0, \{\
						name= t.string;\
						path= saveDirectory+/+(name);\
						\cf7 this\cf3 .save(path);\
						currentSaveFile= path;\
						saveFiles= (saveDirectory++\cf9 "*"\cf3 ).standardizePath.pathMatch;\
						\{loadMenu.items= saveFiles.collect(\{\cf5 |it|\cf3  it.basename.asSymbol\});\}.defer;\
						loadMenu.value= loadMenu.items.indexOf(name.asSymbol);\
						w.close;\
					\});\
				\});\
				\cf4 Button\cf3 (w, \cf4 Rect\cf3 (120, 40, 100, 40))\
				.states_([[\cf9 "cancel"\cf3 ]])\
				.action_(\{\
					w.close;\
				\});\
				w.front;\
		\});\
		\cf4 Button\cf3 (w, \cf4 Rect\cf3 (rect.left+110, rect.bottom, 90, 15))\
		.states_([[\cf9 "kaoss touchPad"\cf3 , \cf4 Color\cf3 .white, \cf4 Color\cf3 .grey],[\cf9 "kaoss touchPad"\cf3 ]])\
		.font_(\cf4 Font\cf3 (\cf9 "Helvetica"\cf3 , 10))\
		.action_(\{\cf5 |v|\cf3 \
			if(v.value == 1, \{\
				\cf4 MultiTouchPad\cf3 .start;\
				\cf4 MultiTouchPad\cf3 .touchAction= \{\cf5 |curID, xys|\cf3 \
					\{\
					if(pressAction.isNil.not, \{pressAction.value\});\
					if(gates.isNil.not, \{\
							if(verbose, \{gates.postln;\});\
							\{ gates.do(\{\cf5 |it|\cf3  it.valueAction= 1\}); \}.defer;\
						\});\
					\cf7 this\cf3 .mouseMoveFloat(xys[0], (xys[1]-1).abs); \}.defer;\
					\};\
				\cf4 MultiTouchPad\cf3 .setAction = \{\cf5 |curID, xys|\cf3  \
					\{\cf7 this\cf3 .mouseMoveFloat(xys[0], (xys[1]-1).abs); \}.defer\
				\};\
				\cf4 MultiTouchPad\cf3 .untouchAction = \{\cf5 |curID, xys|\cf3 \
					if(releaseAction.isNil.not, \{releaseAction.value\});\
					if(gates.isNil.not, \{\
							if(verbose, \{gates.postln;\});\
							\{ gates.do(\{\cf5 |it|\cf3  it.valueAction= 0\}); \}.defer;\
						\});\
				\};\
				\},\{\
				\cf4 MultiTouchPad\cf3 .stop;	\
				\});\
			\});\
		\
	\}\
\
\
	mouseDown\{ \cf5 | view,x,y, mod |\cf3 \
		\cf5 var\cf3  lastVals, newPoint, pointIndex;\
		case \
		\{mod == ctrl\} \{ \cf2 // add point\cf3 \
			move= getPoint.value(x, y);\
				if (move.isNil, \{ tmppoint =  x @ y;\}, \cf2 // add point\cf3 \
					\{ \cf7 this\cf3 .updatePoint(move);\}); \cf2 //overwrite parameters in point\cf3 \
			\cf2 //"potentially updating point...".postln;\cf3 \
		\}\
		\{mod == shift\} \{move= getPoint.value(x, y);\} \cf2 //shift - move the selected blob\cf3 \
		\{mod == 0\} \{curloc.set(x, y); \cf7 this\cf3 .calculate;\} \cf2 // change the parameters\cf3 \
		\{mod == 256\} \{curloc.set(x, y); \cf7 this\cf3 .calculate;\} \cf2 // change the parameters osx\cf3 \
		\{mod == alt\} \{ \cf2 // remove point\cf3 \
			move= getPoint.value(x, y);\
			if (move.isNil.not,\
				\{ \cf7 this\cf3 .removePoint(move);\}); \cf2 //overwrite parameters in point	\cf3 \
		\};\
		view.refresh;\
		mod.postln;\
	\}\
	\
	mouseMove\{ \cf5 |  x, y, mod= 0 |\cf3 \
			\cf5 var\cf3  lastVals, newPoint, pointIndex;\
			case \
			\{mod == ctrl\} \{ \cf6 nil\cf3  \}\
			\{mod == shift\} \{  \cf2 //move the selected blob\cf3 \
				move.isNil.not.if(\{\
					move= getPoint.value(x, y);\
					newPoint= x @ y;\
					lastVals= parameterDict[move];\
					parameterDict.removeAt(move);\
					parameterDict.put(newPoint, lastVals);\
					pointIndex= points.indexOfEqual(move);\
					points.put(pointIndex, newPoint);\
					\cf2 //"moving a point".postln;\cf3 \
				\});\
				\{v.refresh\}.defer; \
			\}\
			\{mod == 0\} \{ \
				curloc.set(x, y); \
				\cf7 this\cf3 .calculate;\
				v.refresh;\
			\}\
			\{mod == 256\} \{ \
				curloc.set(x, y); \
				\cf7 this\cf3 .calculate;\
				v.refresh;\
			\};\
	\}\
\
	getPars\{ \cf5 |point|\cf3 \
		parKeys.do(\{\cf5 |it|\cf3 	\
			case\
			\{ [\cf4 S\cf3 lider, \cf4 N\cf3 umberBox,\cf4 B\cf3 utton,\cf4 P\cf3 opUpMenu, \cf4 L\cf3 istView, \cf4 K\cf3 nob, \cf4 EZSlider\cf3 , \cf4 EZPopUpMenu\cf3 , \cf4 EZListView\cf3 , \cf4 EZNumber\cf3 , \cf4 EZKnob\cf3 ].includes(it.class)\} \{ parameterDict.put( point, it, it.value.round(0.001).deepCopy );\}\
			\{it.class == \cf4 S\cf3 lider2D\} \{  parameterDict.put( point, it, [it.x.round(0.001).deepCopy, it.y.round(0.001).deepCopy] )\}\
			\{it.class == \cf4 R\cf3 angeSlider\} \{ parameterDict.put( point, it, [it.lo.round(0.001).deepCopy, it.hi.round(0.001).deepCopy] ) \}\
			\{it.class == \cf4 S\cf3 oundFileView\} \{ parameterDict.put(point, it, it.selectionStart(0).deepCopy)\}\
			\{it.class == \cf4 M\cf3 ultiSliderView\} \{ parameterDict.put( point, it, it.value.round(0.001).deepCopy );\};		\
		\});\
		\cf2 //"getpars doing its thang".postln;\cf3 \
	\}\
\
	mouseMoveFloat\{ \cf5 | x, y, mod= 0 |\cf3 \
		\cf7 this\cf3 .mouseMove(x*v.bounds.width, (y-1).abs*v.bounds.height, mod);\
	\}\
\
	addPoint\{ \cf5 |point|\cf3 \
		points.add( point );\
		\cf7 this\cf3 .getPars(point);\
		\cf2 //parameterDict.postln;\cf3 \
	\}\
	\
	removePoint\{\cf5 |point|\cf3 \
		points.remove(point);\
		parameterDict.removeAt(point);\
		\cf2 /*\
		delmenu= ListView(w, Rect(rect.left+point.x, rect.top+point.y, 70, 40))\
		.background_(Color.white)\
		.items_(["delete", "cancel"])\
		.mouseUpAction_(\{|menu|\
			if (menu.value == 0,\
				\{\
					points.remove(point);\
					pointsDict.removeAt(point);\
					parameterDict.removeAt(point);\
				\});\
			delmenu.visible_(false);\
			v.refresh;\
		\});\
		*/\cf3 \
	\}\
\
	updatePoint\{ \cf5 |point|\cf3 \
\
		\cf7 this\cf3 .getPars(point);\
	\}\
\
	weightfactor_\{ \cf5 |newweight|\cf3 \
		weightDict.keysValuesChange\{ \cf5 |key,value|\cf3 \
			if ( value == weightfactor,\
				\{ newweight \},\
				\{ value \});\
		\};\
	\}\
\
	calculate\{\
		\cf5 var\cf3  distances,invdistsum,thispoint;\
		if(points.size > 1, \{\
		thispoint = points.detect( \{ \cf5 |it|\cf3  it.dist( curloc) < mindist \} );\
		if ( thispoint.isNil, \{\
			distances = points.collect\{ \cf5 |it,i|\cf3  it.dist( curloc ) \};\
		\
			currentPars.keysValuesChange( \{ \cf5 |key,value|\cf3  \
				invdistsum = distances.sum( \{ \cf5 |it|\cf3  1/pow(it,weightDict.at( key )) \} );\
				(points.sum( \{ \cf5 |point,i|\cf3  (parameterDict.at( point, key ).deepCopy)/pow(distances[i],weightDict.at( key ) ) \} ) / invdistsum ).deepCopy.round(0.001);\
			\} );\
			\cf2 //parKeys.do(\{|it|	\{it.valueAction= currentPars[it]\}.defer; \});			\cf3 \
			\cf7 this\cf3 .setPars;\
		\},\{\
			if(verbose, \{\cf9 "notnil"\cf3 .postln;\});\
			\cf2 //currentPars = parameterDict.at( thispoint ); //THIS WAS THE BUG!!!!!!\cf3 \
			\cf2 //parKeys.do(\{|it|	\{it.valueAction= currentPars[it]\}.defer; \});\cf3 \
			\cf2 //this.setPars;\cf3 \
		\});\
		\});\
	\}\
\
	setPars\{\
		parKeys.do(\{\cf5 |it|\cf3 	\
			case\
			\{ [\cf4 S\cf3 lider, \cf4 K\cf3 nob, \cf4 EZSlider\cf3 , \cf4 EZPopUpMenu\cf3 , \cf4 EZListView\cf3 , \cf4 EZNumber\cf3 , \cf4 EZKnob\cf3 ].includes(it.class) \} \{ \{it.valueAction= currentPars[it].deepCopy\}.defer;\}\
			\{ it.class == \cf4 N\cf3 umberBox \} \{ \{it.valueAction_(currentPars[it].deepCopy)\}.defer;\}\
			\{ [\cf4 B\cf3 utton,\cf4 P\cf3 opUpMenu, \cf4 L\cf3 istView].includes(it.class)\} \{ \{it.valueAction= (currentPars[it]).deepCopy.round\}.defer;\}\
			\{it.class == \cf4 S\cf3 lider2D\} \{ \{it.activex_(currentPars[it][0].deepCopy.round(0.001)); it.activey_(currentPars[it][1].deepCopy.round(0.001)); \}.defer; \}\
			\{it.class == \cf4 R\cf3 angeSlider\} \{ \
				\{it.activeLo_(currentPars[it][0].deepCopy.round(0.001)); it.activeHi_(currentPars[it][1].deepCopy.round(0.001)); \}.defer; \}\
			\{it.class == \cf4 S\cf3 oundFileView\} \{  \{ it.setSelectionStart(0, currentPars[it].deepCopy); it.mouseUpAction.value\}.defer; \}\
			\{it.class == \cf4 M\cf3 ultiSliderView\} \{ \{it.value_(currentPars[it].deepCopy.round(0.01)).doAction\}.defer;\};		\
		\});\
	\}\
\
	\cf2 //Load and Save Functions\cf3 \
	\cf2 //..to do: a way to save into the document like MacicPreset\cf3 \
	save\{\cf5 |path, cbpresets|\cf3  \cf2 //include second arg for ColorblobsPreset\cf3 \
		\cf5 var\cf3  saveList, savePoints;\
		saveList= \cf4 List\cf3 .new;\
\
		points.do(\{ \cf5 |it, i|\cf3 \
			\cf5 var\cf3  values;\
			values= parKeys.collect(\{ \cf5 |it, iteration|\cf3  \cf2 //get values from the identity dictionary\cf3 \
				parameterDict.at(points[i])[parKeys[iteration]];\
			\});\
			if(verbose, \{ values.postln;\});\
			\cf9 "preset saved"\cf3 .postln;\
			saveList.add([points[i], values]) \cf2 //store them orderly\cf3 \
		\});\
		saveList= [points, saveList]; \cf2 //store points in two places for easy retrieval\cf3 \
	if( cbpresets.isNil.not, \{ ^saveList.deepCopy \}, \{ (saveList).writeArchive(path) \});\
	if(verbose, \{saveList.postln;\});\
	\}\
	\
	load\{\cf5 |paths, cbpresets|\cf3 \
		\cf5 var\cf3  values, saveList;\
		if( cbpresets.isNil.not, \{ saveList= paths.deepCopy \}, \
			\{ saveList= \cf4 Object\cf3 .readArchive(paths) \});\
		\cf2 //saveList.postcs;\cf3 \
\
		points.array_(saveList[0]);\
		values= saveList[1];     \cf2 //[[point, [values]], [point, [values]]]\cf3 \
		\cf9 "preset loaded"\cf3 .postln;\
		points.do(\{\cf5 |itPoint, iPoint|\cf3  \
			parKeys.do(\{\cf5 |itPar, iPar|\cf3 		\
				parameterDict.put( itPoint, itPar, values[iPoint][1][iPar] )\
			\});\
		\});\
\
	v.refresh;\
	\
	\}\
\
	add\{ \cf5 arg\cf3  ... args;\
		\cf5 var\cf3  newParKeys;\
		newParKeys = args; \cf2 //put the GUI variables into a list\cf3 \
		\
		newParKeys.do(\{\cf5 |it|\cf3  \
			weightDict.put(it, weight);\
			parKeys.add(it);\
		\});\
\
		newParKeys.do(\{\cf5 |itPar, iPar|\cf3 	\cf2 //set initial values 4 each new GUI\cf3 \
			case\
			\{ [\cf4 S\cf3 lider, \cf4 N\cf3 umberBox,\cf4 B\cf3 utton,\cf4 P\cf3 opUpMenu, \cf4 L\cf3 istView, \cf4 K\cf3 nob, \cf4 EZSlider\cf3 , \cf4 EZPopUpMenu\cf3 , \cf4 EZListView\cf3 , \cf4 EZNumber\cf3 , \cf4 EZKnob\cf3 ].includes(itPar.class)\} \{ \
				defaultParDict.put( itPar, itPar.value.round(0.001) );\
				currentPars.put(itPar, itPar.value.round(0.001));\}\
			\{itPar.class == \cf4 S\cf3 lider2D\} \{  \
				defaultParDict.put( itPar, [itPar.x.round(0.001), itPar.y.round(0.001)] );\
				currentPars.put(itPar, [itPar.x.round(0.001), itPar.y.round(0.001)]);\}\
			\{itPar.class == \cf4 R\cf3 angeSlider\} \{ \
				defaultParDict.put( itPar, [itPar.lo.round(0.001), itPar.hi.round(0.001)] ); \
				currentPars.put(itPar, [itPar.lo.round(0.001), itPar.hi.round(0.001)]);\}\
			\{itPar.class == \cf4 S\cf3 oundFileView\} \{ \
				dummy= itPar.selectionStart(0);\
				\cf2 //dummy.postln;\cf3 \
				\cf2 //dummy.class.postln;\cf3 \
				defaultParDict.put( itPar, dummy);	\
				currentPars.put(itPar, dummy);\}\
			\{itPar.class == \cf4 M\cf3 ultiSliderView\} \{ \
				defaultParDict.put( itPar, itPar.value.round(0.001) );\
				currentPars.put(itPar, itPar.value.round(0.001));\}		\
		\});\
		\
		points.do(\{\cf5 |itPoint, iPoint|\cf3  \
			\
			newParKeys.do(\{\cf5 |itPar, iPar|\cf3 	\cf2 //set initial values 4 each new GUI\cf3 \
				case\
				\{ [\cf4 S\cf3 lider, \cf4 N\cf3 umberBox,\cf4 B\cf3 utton,\cf4 P\cf3 opUpMenu, \cf4 L\cf3 istView, \cf4 K\cf3 nob, \cf4 EZSlider\cf3 , \cf4 EZPopUpMenu\cf3 , \cf4 EZListView\cf3 , \cf4 EZNumber\cf3 , \cf4 EZKnob\cf3 ].includes(itPar.class)\} \{ \
					parameterDict.put( itPoint, itPar, itPar.value.round(0.001) );\}\
				\{itPar.class == \cf4 S\cf3 lider2D\} \{\
					parameterDict.put( itPoint, itPar, [itPar.x.round(0.001), itPar.y.round(0.001)] );\}\
				\{itPar.class == \cf4 R\cf3 angeSlider\} \{ \
					parameterDict.put( itPoint, itPar, [itPar.lo.round(0.001), itPar.hi.round(0.001)] );\}\
				\{itPar.class == \cf4 S\cf3 oundFileView\} \{ \
					dummy= itPar.selectionStart(0);\
					\cf2 //dummy.postln;\cf3 \
					\cf2 //dummy.class.postln;\cf3 \
					parameterDict.put( itPoint, itPar, dummy);\
					\cf2 //("sfv: "++parameterDict.at(itPar)).postln;\cf3 \
				\}\
				\{itPar.class == \cf4 M\cf3 ultiSliderView\} \{ 		\
					parameterDict.put( itPoint, itPar, itPar.value.round(0.001) );\};\
			\});\
		\});\
	\}\
	\
	\
	print\{\
	parameterDict.postcs;\
	\}\
	printDefaults\{\
		\cf9 "defaultParDict:"\cf3 +defaultParDict.postcs;\
		\cf9 "parKeys:"\cf3 +parKeys.postcs;\
	\}\
\
\}\
}