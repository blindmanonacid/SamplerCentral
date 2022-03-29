

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
� � � � var min, secs;
� � � � � � � � min = (i / 60).asInteger;
� � � � � � � � secs = (i % 60);
� � � � � � � � if (secs < 10, {secs = (0.asSymbol ++ secs.asSymbol)});
� � � � � � � � a.string = (min.asSymbol ++ ":" ++ secs.asSymbol);
� � � � 1.wait;
� � � � })
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
� � � � b.states = ([["Start",Color.black, Color(0.6, 0.35,
0.35)],["Pause",Color.black, Color(0.35, 0.35, 0.6)]]);
� � � � b.action = ( { case {b.value == 1} {t.play;};
� � � � � � � � case {b.value == 0} {t.pause;};
} );

c = Button.new(w, Rect(190, 120, 135, 20));
� � � � c.states = ([["Reset",Color.black, Color(0.35,0.6,0.35)]]);
� � � � c.action = ( { case {c.value == 0} {t.reset;a.string = "0:00"; };
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