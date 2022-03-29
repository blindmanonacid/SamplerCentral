/*
ColorblobPreset
use with a colorblob
!! ColorblobPreset must be created after Colorblob2

ColorblobPreset.new(view, x position, y position, a Colorblobs2)
-right clicking saves the current setup
-clicking recalls setup

*/
ColorblobsPreset{
	var ctrl, shift, next= 0, colors, w, v, savePreset, loadPreset;
	var win, x, y, blob, path;
	var saveList;
	var pbuttons;
	var numpresets;
	var butList;
	var click, ctlclick;
	
	*new{ arg win, x, y, blob, path= nil;
		^super.new.init(win, x, y, blob, path);
	}
	
	init{ arg argwin, argx, argy, argblob, argpath;
		
		var win= argwin;
		var x= argx;
		var y= argy;
		var blob= argblob;
		var path= argpath;
		var numpresets= 7;
		
		click= nil!numpresets;
		ctlclick= nil!numpresets;
		butList= nil!numpresets;
		v= nil!numpresets;
		pbuttons= nil!numpresets;
		saveList= List.newClear(10);
		
		// as Class, args (win, x, y, blob)
	//var ctrl, shift, next= 0, colors, w, savePreset, loadPreset;
		
		Platform.case(
			\osx,		{ ctrl= 262401; shift= 131330 },
			\linux,		{ ctrl= 262144; shift= 131072 };
		);
		
		//"got to here presetblobb".postln;
		
		colors= [Color.green, Color.red, Color.yellow, Color.blue, Color.new255(127, 255, 212), Color.new255(208, 32, 144), Color.new255(255, 192, 203), Color.new255(255, 105, 180), Color.new255(107, 142, 35), Color.new255(255, 165, 0)];

		//StaticText(win, Rect( x, y, 120, 20)).string_("colorblobPresets");
		
		pbuttons= numpresets.collect({ arg i; var f;		
			v[i] = UserView( win, Rect( x + (i * 25), y, 20, 20 ))
            //.relativeOrigin_( i == 0 )
            .background_( Color.black )
            .canFocus_( false );
			v[i].drawFunc= {
				Pen.color= Color.white; Pen.stringAtPoint((i+1).asString, 5@0); 
				
			};
			click[i]= {
				numpresets.do({|ii, num|
					if ( butList[num].isNil.not, {
						if( ii== i, {
						("loaded preset:"+i).postln; loadPreset.value(i); v[i].background= Color.blue; 
						});

						if (ii != i, {
							v[ii].background = Color.black;
							v[ii].drawFunc= {
								Pen.color= Color.white; Pen.stringAtPoint((ii+1).asString, 5@0); 
								Pen.color= Color.red(alpha:0.5); Pen.addArc(10@10, 5, 0, 2pi); Pen.perform(\fill);
							};
						});
					});
					v.do(_.refresh);	
				});
			};
			ctlclick[i]= {
				v[i].drawFunc= {
					Pen.color= Color.white; Pen.stringAtPoint((i+1).asString, 5@0); 	
					Pen.color= Color.red(alpha:0.5); Pen.addArc(10@10, 5, 0, 2pi); Pen.perform(\fill);
				};
				v[i].refresh;
				"save preset".postln; savePreset.value(i); 
				butList[i]= 1;
			};
			f = { arg view, x, y, mod; 
				case
				{mod == ctrl} {ctlclick[i].value}
				{mod == 0} {click[i].value}
				{mod == 256} {click[i].value}
			};
			v[i].mouseDownAction = f;
			v[i].refresh;
			blob.v.addAction({|view,char,modifiers,unicode,keycode| if(char.digit-1 == i, {click[i].value;}) }, \keyDownAction);
			v[i];	
		});

		savePreset= { |i| saveList.put(i, blob.save(nil, 1);) };
		loadPreset= { |i| blob.load(saveList[i], 1) };
		//savePreset= { |i| blob.save((path++i.asString).standardizePath)};
		//loadPreset= { |i| blob.load((path++i.asString).standardizePath)};

		//(path++"blobPreset"++i.asString)


	}

	save{|path|
		if (path.isNil, { Dialog.savePanel{|path| saveList.writeArchive(path); } }, {
			(saveList).writeArchive(path);
		})
	}
	
	load{|paths|
		if (paths.isNil, {
			Dialog.getPaths{ |paths| saveList= Object.readArchive(paths); }
		},{ saveList= Object.readArchive(paths); });
		butList.do({|it, i|
			if(saveList[i].isNil, {butList[i]= nil},{ butList[i]= 1})
		});
		click[0].value;
		
	}
	
	set{|num|
		num !? {click[num].value};
	}

	store{|num|
		num !? {ctlclick[num].value};
	}
}
