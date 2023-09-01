

ClockGUI {
	var w, t, a, b, c;
	var parent, bounds;

	*new {arg parent, bounds;
		^super.new.initClockGUI(parent, bounds);
	}
	initClockGUI {  arg argparent, argbounds;
			
	parent= argparent;
	bounds= argbounds;

t = Task.new({ inf.do({ |i|
Ê Ê Ê Ê var min, secs;
Ê Ê Ê Ê Ê Ê Ê Ê min = (i / 60).asInteger;
Ê Ê Ê Ê Ê Ê Ê Ê secs = (i % 60);
Ê Ê Ê Ê Ê Ê Ê Ê if (secs < 10, {secs = (0.asSymbol ++ secs.asSymbol)});
Ê Ê Ê Ê Ê Ê Ê Ê a.string = (min.asSymbol ++ ":" ++ secs.asSymbol);
Ê Ê Ê Ê 1.wait;
Ê Ê Ê Ê })
}, AppClock);

w = parent ?? {Window.new("clock!", Rect(950,25,350,150), false )};
b = bounds ?? {Rect(25, 15, 300, 100)};

a = StaticText(w, b);
a.background=Color.white;
a.align = \center;
a.font = Font("Arial", b.height-15);
a.string = "0:00";

/*
b = Button.new(w, Rect(25, 120, 135, 20));
Ê Ê Ê Ê b.states = ([["Start",Color.black, Color(0.6, 0.35,
0.35)],["Pause",Color.black, Color(0.35, 0.35, 0.6)]]);
Ê Ê Ê Ê b.action = ( { case {b.value == 1} {t.play;};
Ê Ê Ê Ê Ê Ê Ê Ê case {b.value == 0} {t.pause;};
} );

c = Button.new(w, Rect(190, 120, 135, 20));
Ê Ê Ê Ê c.states = ([["Reset",Color.black, Color(0.35,0.6,0.35)]]);
Ê Ê Ê Ê c.action = ( { case {c.value == 0} {t.reset;a.string = "0:00"; };
} );
*/

if(parent.isNil,{
		    w.front;
		});
	}

play{t.play;}
pause{t.pause;}
reset{t.reset;a.string = "0:00";}


}