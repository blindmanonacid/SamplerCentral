
// miguel negrao
// felix

ColorPicker {

	*new { arg parent,point,color,onPick, livePick= false;
		var w,r,g,b,update,colorview;

		w = parent ?? {w = Window.new("Color Picker",Rect(100,100,230,68),false)};
		point= point ?? {point= Point.new(0, 0)};
		color=  color ?? Color.grey;
	
		r = EZSlider(w, Rect(point.x+2,point.y+0,150,20),"R",labelWidth:20)
		.value_(color.red)
		.action_({ |v| update.(); if(livePick,{ onPick.value(colorview.background) }); });
		g = EZSlider(w, Rect(point.x+2,point.y+22,150,20),"G",labelWidth:20)
		.value_(color.green)
		.action_({ |v| update.(); if(livePick,{ onPick.value(colorview.background) }); });
		b = EZSlider(w, Rect(point.x+2,point.y+44,150,20),"B",labelWidth:20)
		.value_(color.blue)
		.action_({ |v| update.(); if(livePick,{ onPick.value(colorview.background) }); });
		
		[r,g,b].do({|item| item.sliderView.canFocus_(false) });

		colorview = UserView(w,Rect(point.x+160, point.y+0, 64, 64))
    		.background_(color ? Color.grey)
    		.enabled_(true)
    		.mouseDownAction_(onPick ? { colorview.background.postln;})
    		.beginDragAction_({colorview.background})
    		.canFocus_(false);

		update = { colorview.background_(Color(r.value,g.value,b.value)) }; 

        if(parent.isNil,{
		    w.front;
		})

	}

	/*
	    drag mouse to alter hue/saturation
	    control drag for value alpha
	    double click for action
	*/
	*hsv { arg color,onPick;
		var w,hslider,sslider,vslider,aslider,update,pallette;
		var h,s,v,a;
		
        color = color ? Color.grey;
		# h,s,v,a = color.asHSV;
        
		w = Window.new("Color Picker",Rect(100,100,250,88),false);
		if(onPick.isNil,{
			onPick = { arg clr; clr.postln;}				
		});
		pallette = UserView(w,Rect(160,0,84,84))
			.background_(color)
			.enabled_(true)
			.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
			    if(clickCount == 2,{
			        onPick.value(pallette.background)
			    });
			})
			.mouseMoveAction_({ arg view,x,y,mod;
			    var h,s,v,a;
			    if(x < 85 and: {y<85},{

			        x = (x / 84.0).clip(0.0,0.999);
			        y = 1.0 - (y / 84.0).clip(0.0,1.0);

    			    # h,s,v,a =pallette.background.asHSV;
    			    if(mod.isCtrl,{
    			        // value / alpha
    			        pallette.background = Color.hsv( h,s, x,y);
    			        vslider.value = x;
    			        aslider.value = y;
    			    },{
    			        // hue / saturation
    			        pallette.background = Color.hsv( x,y,v,a);
    			        hslider.value = x;
    			        sslider.value = y;
    		        });
    		    })
			})
			.beginDragAction_({pallette.background})
			.canFocus_(false);

		update = { 
		    pallette.background_(Color.hsv(hslider.value,sslider.value,vslider.value,aslider.value)) 
		}; 

		hslider = EZSlider(w, Rect(2,0,150,20),"H",initVal:h,labelWidth:20)
			.action_(update);
		sslider = EZSlider(w, Rect(2,22,150,20),"S",initVal:s,labelWidth:20)
			.action_(update);
		vslider = EZSlider(w, Rect(2,44,150,20),"V",initVal:v,labelWidth:20)
			.action_(update);
		aslider = EZSlider(w, Rect(2,66,150,20),"A",initVal:a,labelWidth:20)
			.action_(update);
		
		[hslider,sslider,vslider,aslider].do({|item| item.sliderView.canFocus_(false) });

		update.value();
		
		w.front;

	}
    /*
        a single square, no sliders

	    drag mouse for hue/saturation
	    control drag for value/alpha
	    
	    livePick: 
	        true: do onPick any time the value changes
	        false: do it on double click

        onPick(color,window)
            window or parent 
            so double click can select and do window.close

    */
	*hsvMini { arg parent,bounds,color,onPick,livePick=false;
		var w,b, hval,sval,vval,aval,pallette;
		var h,s,v,a;
		
        color = color ? Color.grey;
		# h,s,v,a = color.asHSV;
        
		w = parent ?? {Window.new("Color Picker",(bounds ? Rect(100,100,100,100)).asRect,false)};
        b = (bounds ?? w.bounds.insetBy(2,2));
		if(onPick.isNil,{
			onPick = { arg clr; clr.postln;}				
		});
		pallette = UserView(w,b)
			.background_(color)
			.enabled_(true)
			.mouseMoveAction_({ arg view,x,y,mod;
			    var h,s,v,a;
			    if(x < b.width and: {y<b.height},{

			        x = (x / 84.0).clip(0.0,0.999);
			        y = 1.0 - (y / 84.0).clip(0.0,1.0);

    			    # h,s,v,a =pallette.background.asHSV;
    			    if(mod.isCtrl,{
    			        // value / alpha
    			        pallette.background = Color.hsv( h,s, x,y);
    			        vval = x;
    			        aval = y;
    			    },{
    			        // hue / saturation
    			        pallette.background = Color.hsv( x,y,v,a);
    			        hval = x;
    			        sval = y;
    		        });
    		        if(livePick,{
    		            onPick.value(pallette.background,w)
    		        });
    		    })
			})
			.beginDragAction_({pallette.background})
			.canFocus_(false);

        if(livePick.not,{
			pallette.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
			    if(clickCount == 2,{
			        onPick.value(pallette.background,w)
			    });
			})
        });

        if(parent.isNil,{
		    w.front;
		})

	}	
}
	 