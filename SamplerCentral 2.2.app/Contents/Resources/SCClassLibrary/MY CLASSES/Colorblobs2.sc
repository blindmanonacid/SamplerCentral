/*



to do:
	fix bugs: 
	in SwingOSC ListView is not working


possible improvements:
	maybe to use with other gui controllers, include
	getGUIVars {
	
	}
	something like (w.view.children[0].valueAction= 1)
	filter out useable GUIs
	to use a window as an input?
	
	make resizable

*/


Colorblobs2{
	var <>guis,<curloc;
	var <points;
	var <parameterDict;
	var <weightDict;
	var <defaultParDict;
	var <parKeys;
	var <currentPars;
	var <weightfactor=2;
	var <>mindist = 1;
	var weight;
	var shift, ctrl, alt;
	var dummy;
	var parentView, rect, inputs;
	var gates;
	var <>verbose= false;

	// GUI
	var w, <v, all, tmppoint, getPoint, move;
	var colors;
	var rect;
	var <bgcolor;
	
	// save load
	var saveFiles, loadMenu, loadMenuItem, currentSaveFile;

	*new{ arg parentView, rect, inputs, saveDirectory, gates, pressAction, releaseAction; //inputs is an array!
		^super.new.init(parentView, rect, inputs, saveDirectory, gates, pressAction, releaseAction);
	}

	init{ arg parentView, rect, inputs, saveDirectory, gates, pressAction, releaseAction; 
		points = List.new; //coordinates of points
		parKeys = List.new; // list for GUI variables
		parameterDict = MultiLevelIdentityDictionary.new; //a point looks up its parameters
		defaultParDict = IdentityDictionary.new; //default parameters
		weightDict = IdentityDictionary.new; //weights 
		curloc = Point.new; //current location
		currentPars = IdentityDictionary.new; //current parameters

		weight = weight ? weightfactor;

		Platform.case(
			\osx,		{ ctrl= 262401; shift= 131330; alt= 524576},
			\linux,		{ ctrl= 262144; shift= 131072; alt= 1048576},
			\windows, 	{ ctrl= 262144; shift= 131072; alt=nil; }
		);


		parKeys.array_(inputs); //put the GUI variables into a list
		//inputs.do({|it| parKeys.

		parKeys.do({|it| //weights
			weightDict.put(it, weight);
		});
		
		parKeys.do({|it|	//initial values
			case
			{ [GUI.slider, GUI.numberBox,GUI.button,GUI.popUpMenu, GUI.listView, GUI.knob, EZSlider, EZPopUpMenu, EZListView, EZNumber, EZKnob].includes(it.class)} { 
				defaultParDict.put( it, it.value.round(0.001).deepCopy );
				currentPars.put(it, it.value.round(0.001).deepCopy);}
			{it.class == GUI.slider2D} {  
				defaultParDict.put( it, [it.x.round(0.001).deepCopy, it.y.round(0.001).deepCopy] );
				currentPars.put(it, [it.x.round(0.001).deepCopy, it.y.round(0.001).deepCopy]);}
			{it.class == GUI.rangeSlider} { 
				defaultParDict.put( it, [it.lo.round(0.001).deepCopy, it.hi.round(0.001).deepCopy] ); 
				currentPars.put(it, [it.lo.round(0.001).deepCopy, it.hi.round(0.001).deepCopy]);}
			{it.class == GUI.soundFileView} { 
				dummy= it.selectionStart(0).deepCopy;
				//dummy.class.postln;
				//dummy.postln;
				defaultParDict.put( it, dummy );	
				currentPars.put(it, it.selectionStart(0).deepCopy);}
			{it.class == GUI.multiSliderView} { 
				defaultParDict.put( it, it.value.round(0.001).deepCopy );
				currentPars.put(it, it.value.round(0.001).deepCopy);};		
		});
		
	
		
		//GUI


		colors= [Color.green, Color.red, Color.yellow, Color.blue, Color.new255(127, 255, 212), Color.new255(208, 32, 144), Color.new255(255, 192, 203), Color.new255(255, 105, 180), Color.new255(107, 142, 35), Color.new255(255, 165, 0)];
		
		tmppoint= 0;
		
		w= parentView;
		w ?? {w= GUI.window.new("colorblobs", Rect(800, 0, 300, 300))};
		rect ?? {rect= Rect(0, 0, 300, 300)};
		v= GUI.userView.new(w, rect)
		.background_(Color.black)
		.canFocus_( false )
		.mouseDownAction_({ arg view,x,y, mod;
			this.mouseDown(view, x, y, mod);
		})
		.mouseMoveAction_({ arg view,x,y, mod;
			this.mouseMove(x, y, mod);
		})
		.mouseUpAction_({ arg view, x, y, mod;
			if (mod == ctrl, {
				case 
				{tmppoint.isNil.not} {this.addPoint(tmppoint);
					tmppoint = nil;
					view.refresh;}				
			});
		})

        .drawFunc_({
			var pt, sizeF;
			
            GUI.pen.use {  
                GUI.pen.width = 2;
				
                if (tmppoint.isNil.not {
					GUI.pen.color = Color.white;
					GUI.pen.fillOval( Rect( tmppoint.x-20, tmppoint.y-20, 40, 40));
                });
                points.do{  arg p, i; 
		                
					10.do({|count|
						sizeF= ((count-10).abs)*0.1;
						GUI.pen.color = colors[i].alpha_(count*0.1);
						GUI.pen.fillOval( Rect( p.x-(sizeF*25), p.y-(sizeF*25), sizeF*50, sizeF*50));
					})
					
				};
				
				//crosshair
				GUI.pen.color = Color.white;
				GUI.pen.moveTo( curloc.translate( -8 @  0 ));
				GUI.pen.lineTo( curloc.translate( -2 @  0 ));
				GUI.pen.moveTo( curloc.translate(  0 @ (-8) ));
				GUI.pen.lineTo( curloc.translate(  0 @ (-2) ));
				GUI.pen.moveTo( curloc.translate(  2 @ 0 ));
				GUI.pen.lineTo( curloc.translate(  8 @ 0 ));
				GUI.pen.moveTo( curloc.translate(  0 @ 2 ));
				GUI.pen.lineTo( curloc.translate(  0 @ 8 ));
				
                GUI.pen.stroke;
            };
        });
		getPoint = {|xx, yy| //check within what circle the mouse is
			var val;
			points.do{|p, i|
				if(p.x >= (xx-20), {
					if (p.x <= (xx+20), {
						if(p.y >= (yy-20), {
							if (p.y <= (yy+20), { val = points[i] }); //move
						});
					});
				});
			};
			val;
		};
		
		
		// ============  Load Save Menu  ============

		saveFiles= (saveDirectory++"*").standardizePath.pathMatch;
		//saveDirectory.postln;
		//saveFiles.postln;
		loadMenu= PopUpMenu(w, Rect(rect.left+0, rect.bottom, 60, 15))
		.items_(saveFiles.collect({|it| it.basename}))
		.canFocus_(false)
		.background_(Color.grey)
		.font_(Font("Helvetica", 10))
		.action_({|v|
			loadMenuItem= v.items.at(v.value);
			if(verbose, {
			loadMenuItem.postln; 
			saveFiles[loadMenu.value].postln;
			});
		});
		Button(w, Rect(rect.left+60, rect.bottom, 15, 15))
		.states_([["L", Color.red, Color.black]])
		.canFocus_(false)
		.font_(Font("Helvetica", 10))
		.action_({ if (loadMenuItem.isNil.not, { this.load(saveFiles[loadMenu.value])}) });
		Button(w, Rect(rect.left+75, rect.bottom, 20, 15))
		.states_([["qs"]])
		.canFocus_(false)
		.font_(Font("Helvetica", 10))
		.action_({ this.save(saveDirectory+/+saveFiles[loadMenu.value]) });
		Button(w, Rect(rect.left+95, rect.bottom, 15, 15))
		.states_([["s"]])
		.canFocus_(false)
		.font_(Font("Helvetica", 10))
		.action_({
			//save preset
			var w, t, name, saveBut;
				w= Window("save", Rect(400, 400, 230, 100), border: false)
				.background_(Color.black)
				.alwaysOnTop_(true);
	
				t= TextView(w, Rect(10, 10, 210, 20))
				.focus(true)
				.keyDownAction_({|view, char, mod, uni, key|
					if(key == 36, { {saveBut.valueAction= 1}.defer; });
				});
				
				saveBut= Button(w, Rect(10, 40, 100, 40))
				.states_([["save"]])
				.action_({
					var values, path, stringSize;
					stringSize= t.string.size;
					if (stringSize > 0, {
						name= t.string;
						path= saveDirectory+/+(name);
						this.save(path);
						currentSaveFile= path;
						saveFiles= (saveDirectory++"*").standardizePath.pathMatch;
						{loadMenu.items= saveFiles.collect({|it| it.basename.asSymbol});}.defer;
						loadMenu.value= loadMenu.items.indexOf(name.asSymbol);
						w.close;
					});
				});
				Button(w, Rect(120, 40, 100, 40))
				.states_([["cancel"]])
				.action_({
					w.close;
				});
				w.front;
		});
		Button(w, Rect(rect.left+110, rect.bottom, 90, 15))
		.states_([["kaoss touchPad", Color.white, Color.grey],["kaoss touchPad"]])
		.font_(Font("Helvetica", 10))
		.action_({|v|
			if(v.value == 1, {
				MultiTouchPad.start;
				MultiTouchPad.touchAction= {|curID, xys|
					{
					if(pressAction.isNil.not, {pressAction.value});
					if(gates.isNil.not, {
							if(verbose, {gates.postln;});
							{ gates.do({|it| it.valueAction= 1}); }.defer;
						});
					this.mouseMoveFloat(xys[0], (xys[1]-1).abs); }.defer;
					};
				MultiTouchPad.setAction = {|curID, xys| 
					{this.mouseMoveFloat(xys[0], (xys[1]-1).abs); }.defer
				};
				MultiTouchPad.untouchAction = {|curID, xys|
					if(releaseAction.isNil.not, {releaseAction.value});
					if(gates.isNil.not, {
							if(verbose, {gates.postln;});
							{ gates.do({|it| it.valueAction= 0}); }.defer;
						});
				};
				},{
				MultiTouchPad.stop;	
				});
			});
		
	}


	mouseDown{ | view,x,y, mod |
		var lastVals, newPoint, pointIndex;
		case 
		{mod == ctrl} { // add point
			move= getPoint.value(x, y);
				if (move.isNil, { tmppoint =  x @ y;}, // add point
					{ this.updatePoint(move);}); //overwrite parameters in point
			//"potentially updating point...".postln;
		}
		{mod == shift} {move= getPoint.value(x, y);} //shift - move the selected blob
		{mod == 0} {curloc.set(x, y); this.calculate;} // change the parameters
		{mod == 256} {curloc.set(x, y); this.calculate;} // change the parameters osx
		{mod == alt} { // remove point
			move= getPoint.value(x, y);
			if (move.isNil.not,
				{ this.removePoint(move);}); //overwrite parameters in point	
		};
		view.refresh;
		//mod.postln;
	}
	
	mouseMove{ |  x, y, mod= 0 |
			var lastVals, newPoint, pointIndex;
			case 
			{mod == ctrl} { nil }
			{mod == shift} {  //move the selected blob
				move.isNil.not.if({
					move= getPoint.value(x, y);
					newPoint= x @ y;
					lastVals= parameterDict[move];
					parameterDict.removeAt(move);
					parameterDict.put(newPoint, lastVals);
					pointIndex= points.indexOfEqual(move);
					points.put(pointIndex, newPoint);
					//"moving a point".postln;
				});
				{v.refresh}.defer; 
			}
			{mod == 0} { 
				curloc.set(x, y); 
				this.calculate;
				v.refresh;
			}
			{mod == 256} { 
				curloc.set(x, y); 
				this.calculate;
				v.refresh;
			};
	}

	getPars{ |point|
		parKeys.do({|it|	
			case
			{ [GUI.slider, GUI.numberBox,GUI.button,GUI.popUpMenu, GUI.listView, GUI.knob, EZSlider, EZPopUpMenu, EZListView, EZNumber, EZKnob].includes(it.class)} { parameterDict.put( point, it, it.value.round(0.001).deepCopy );}
			{it.class == GUI.slider2D} {  parameterDict.put( point, it, [it.x.round(0.001).deepCopy, it.y.round(0.001).deepCopy] )}
			{it.class == GUI.rangeSlider} { parameterDict.put( point, it, [it.lo.round(0.001).deepCopy, it.hi.round(0.001).deepCopy] ) }
			{it.class == GUI.soundFileView} { parameterDict.put(point, it, it.selectionStart(0).deepCopy)}
			{it.class == GUI.multiSliderView} { parameterDict.put( point, it, it.value.round(0.001).deepCopy );};		
		});
		//"getpars doing its thang".postln;
	}

	mouseMoveFloat{ | x, y, mod= 0 |
		this.mouseMove(x*v.bounds.width, (y-1).abs*v.bounds.height, mod);
	}

	addPoint{ |point|
		points.add( point );
		this.getPars(point);
		//parameterDict.postln;
	}
	
	removePoint{|point|
		points.remove(point);
		parameterDict.removeAt(point);
		/*
		delmenu= ListView(w, Rect(rect.left+point.x, rect.top+point.y, 70, 40))
		.background_(Color.white)
		.items_(["delete", "cancel"])
		.mouseUpAction_({|menu|
			if (menu.value == 0,
				{
					points.remove(point);
					pointsDict.removeAt(point);
					parameterDict.removeAt(point);
				});
			delmenu.visible_(false);
			v.refresh;
		});
		*/
	}

	updatePoint{ |point|

		this.getPars(point);
	}

	weightfactor_{ |newweight|
		weightDict.keysValuesChange{ |key,value|
			if ( value == weightfactor,
				{ newweight },
				{ value });
		};
	}

	calculate{
		var distances,invdistsum,thispoint;
		if(points.size > 1, {
		thispoint = points.detect( { |it| it.dist( curloc) < mindist } );
		if ( thispoint.isNil, {
			distances = points.collect{ |it,i| it.dist( curloc ) };
		
			currentPars.keysValuesChange( { |key,value| 
				invdistsum = distances.sum( { |it| 1/pow(it,weightDict.at( key )) } );
				(points.sum( { |point,i| (parameterDict.at( point, key ).deepCopy)/pow(distances[i],weightDict.at( key ) ) } ) / invdistsum ).deepCopy.round(0.001);
			} );
			//parKeys.do({|it|	{it.valueAction= currentPars[it]}.defer; });			
			this.setPars;
		},{
			if(verbose, {"notnil".postln;});
			//currentPars = parameterDict.at( thispoint ); //THIS WAS THE BUG!!!!!!
			//parKeys.do({|it|	{it.valueAction= currentPars[it]}.defer; });
			//this.setPars;
		});
		});
	}

	setPars{
		parKeys.do({|it|	
			case
			{ [GUI.slider, GUI.knob, EZSlider, EZPopUpMenu, EZListView, EZNumber, EZKnob].includes(it.class) } { {it.valueAction= currentPars[it].deepCopy}.defer;}
			{ it.class == GUI.numberBox } { {it.valueAction_(currentPars[it].deepCopy)}.defer;}
			{ [GUI.button,GUI.popUpMenu, GUI.listView].includes(it.class)} { {it.valueAction= (currentPars[it]).deepCopy.round}.defer;}
			{it.class == GUI.slider2D} { {it.activex_(currentPars[it][0].deepCopy.round(0.001)); it.activey_(currentPars[it][1].deepCopy.round(0.001)); }.defer; }
			{it.class == GUI.rangeSlider} { 
				{it.activeLo_(currentPars[it][0].deepCopy.round(0.001)); it.activeHi_(currentPars[it][1].deepCopy.round(0.001)); }.defer; }
			{it.class == GUI.soundFileView} {  { it.setSelectionStart(0, currentPars[it].deepCopy); it.mouseUpAction.value}.defer; }
			{it.class == GUI.multiSliderView} { {it.value_(currentPars[it].deepCopy.round(0.01)).doAction}.defer;};		
		});
	}

	//Load and Save Functions
	//..to do: a way to save into the document like MacicPreset
	save{|path, cbpresets| //include second arg for ColorblobsPreset
		var saveList, savePoints;
		saveList= List.new;

		points.do({ |it, i|
			var values;
			values= parKeys.collect({ |it, iteration| //get values from the identity dictionary
				parameterDict.at(points[i])[parKeys[iteration]];
			});
			if(verbose, { values.postln;});
			"preset saved".postln;
			saveList.add([points[i], values]) //store them orderly
		});
		saveList= [points, saveList]; //store points in two places for easy retrieval
	if( cbpresets.isNil.not, { ^saveList.deepCopy }, { (saveList).writeArchive(path) });
	if(verbose, {saveList.postln;});
	}
	
	load{|paths, cbpresets|
		var values, saveList;
		if( cbpresets.isNil.not, { saveList= paths.deepCopy }, 
			{ saveList= Object.readArchive(paths) });
		//saveList.postcs;

		points.array_(saveList[0]);
		values= saveList[1];     //[[point, [values]], [point, [values]]]
		"preset loaded".postln;
		points.do({|itPoint, iPoint| 
			parKeys.do({|itPar, iPar|		
				parameterDict.put( itPoint, itPar, values[iPoint][1][iPar] )
			});
		});

	v.refresh;
	
	}

	add{ arg ... args;
		var newParKeys;
		newParKeys = args; //put the GUI variables into a list
		
		newParKeys.do({|it| 
			weightDict.put(it, weight);
			parKeys.add(it);
		});

		newParKeys.do({|itPar, iPar|	//set initial values 4 each new GUI
			case
			{ [GUI.slider, GUI.numberBox,GUI.button,GUI.popUpMenu, GUI.listView, GUI.knob, EZSlider, EZPopUpMenu, EZListView, EZNumber, EZKnob].includes(itPar.class)} { 
				defaultParDict.put( itPar, itPar.value.round(0.001) );
				currentPars.put(itPar, itPar.value.round(0.001));}
			{itPar.class == GUI.slider2D} {  
				defaultParDict.put( itPar, [itPar.x.round(0.001), itPar.y.round(0.001)] );
				currentPars.put(itPar, [itPar.x.round(0.001), itPar.y.round(0.001)]);}
			{itPar.class == GUI.rangeSlider} { 
				defaultParDict.put( itPar, [itPar.lo.round(0.001), itPar.hi.round(0.001)] ); 
				currentPars.put(itPar, [itPar.lo.round(0.001), itPar.hi.round(0.001)]);}
			{itPar.class == GUI.soundFileView} { 
				dummy= itPar.selectionStart(0);
				//dummy.postln;
				//dummy.class.postln;
				defaultParDict.put( itPar, dummy);	
				currentPars.put(itPar, dummy);}
			{itPar.class == GUI.multiSliderView} { 
				defaultParDict.put( itPar, itPar.value.round(0.001) );
				currentPars.put(itPar, itPar.value.round(0.001));}		
		});
		
		points.do({|itPoint, iPoint| 
			
			newParKeys.do({|itPar, iPar|	//set initial values 4 each new GUI
				case
				{ [GUI.slider, GUI.numberBox,GUI.button,GUI.popUpMenu, GUI.listView, GUI.knob, EZSlider, EZPopUpMenu, EZListView, EZNumber, EZKnob].includes(itPar.class)} { 
					parameterDict.put( itPoint, itPar, itPar.value.round(0.001) );}
				{itPar.class == GUI.slider2D} {
					parameterDict.put( itPoint, itPar, [itPar.x.round(0.001), itPar.y.round(0.001)] );}
				{itPar.class == GUI.rangeSlider} { 
					parameterDict.put( itPoint, itPar, [itPar.lo.round(0.001), itPar.hi.round(0.001)] );}
				{itPar.class == GUI.soundFileView} { 
					dummy= itPar.selectionStart(0);
					//dummy.postln;
					//dummy.class.postln;
					parameterDict.put( itPoint, itPar, dummy);
					//("sfv: "++parameterDict.at(itPar)).postln;
				}
				{itPar.class == GUI.multiSliderView} { 		
					parameterDict.put( itPoint, itPar, itPar.value.round(0.001) );};
			});
		});
	}
	
	
	print{
	parameterDict.postcs;
	}
	printDefaults{
		"defaultParDict:"+defaultParDict.postcs;
		"parKeys:"+parKeys.postcs;
	}

}
