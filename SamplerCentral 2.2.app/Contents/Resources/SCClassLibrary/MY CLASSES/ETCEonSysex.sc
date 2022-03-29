/*
A Class to make mido sysex messages that a ETC Eon Lightdesk understands

MIDIClient.init;
m= MIDIOut(1);
m.sysex(ETCEonSysex.submaster(1, 2, 10)); 
m.sysex(ETCEonSysex.macro(1, 17));
m.sysex(ETCEonSysex.grandmaster(1, 100));
m.sysex(ETCEonSysex.goCue(1, 1, 0));
m.sysex(ETCEonSysex.goCue(1, 2, 0));
m.sysex(ETCEonSysex.pauseCue(1, 2, 1));
m.sysex(ETCEonSysex.resumeCue(1, 2, 1));
m.sysex(ETCEonSysex.goCue(1, 54.6, 2));

ETCEonSysex.goCue(1, 1, 1)


// in sysex
// Go Cue 1/10 (to Device 1)
m.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x01, 0x31, 0x30, 0x00, 0x31,  0xf7]);

// Go Cue 1/1 (to Device 1)
m.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x01, 0x31, 0x00, 0x31,  0xf7]);
m.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x01, 49, 0x00, 0x31,  0xf7]);
// Go Cue 1/2 (to Device 1)
m.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x01, 0x32, 0x00, 0x31,  0xf7]);
m.sysex(Int8Array[0xf0, 0x7f, 0x01,  0x02, 0x01,  0x01, 50, 0x00, 0x31,  0xf7]);


*/

ETCEonSysex {
	
	*submaster{|device= 127, submaster= 1, value= 0|
		^Int8Array[0xf0, 0x7f, device,  0x02, 0x01,  0x06, submaster, 0x00, value, 0x00, 0xf7]
	}
	
	*grandmaster{|device= 127, value= 0|
		^Int8Array[0xf0, 0x7f, device,  0x02, 0x01,  0x06, 0x7e, 0x03, value, 0x00, 0xf7]
	}
	
	*macro{|device= 127, macro= 0|
		^Int8Array[0xf0, 0x7f, device,  0x02, 0x01,  0x07, macro, 0xf7]
	}
	
	*goCue{|device= 127, val1= 1, val2= 1|
		var t, t2, cue1, cue2, sysexArray;
	
	if( (val1 - val1.floor) != 0, {
	val1= val1.round(0.1);
	val1= val1.asString.findReplace(".", ""); 
	cue1= val1.asInteger.asDigits.collect({|it|
		("0x3"++(it.asString)).interpret;
	});
	t= cue1.last;
	//cue2[cue2.size-1]= 0x2E;
	cue1[(cue1.size-1)]= 46;
	cue1= cue1.add(t);
	cue1;
},{
	val1= val1.asInteger;
	cue1= val1.asDigits.collect({|it|
		("0x3"++(it.asString)).interpret;
	});
	cue1;
});

if((val2 - val2.floor) != 0, {
	val2= val2.round(0.1);
	val2= val2.asString.findReplace(".", ""); 
	cue2= val2.asInteger.asDigits.collect({|it|
		("0x3"++(it.asString)).interpret;
	});
	t2= cue2.last;
	//cue2[cue2.size-1]= 0x2E;
	cue2[cue2.size-1]= 46;
	cue2= cue2.add(t2);
	cue2;
},{
	val2= val2.asInteger;
	cue2= val2.asDigits.collect({|it|
		("0x3"++(it.asString)).interpret;
	});
	cue2;
});

sysexArray= Int8Array[ -16, 127, device, 2, 1, 1]++Int8Array.newFrom(cue1)++Int8Array[0]++Int8Array.newFrom(cue2)++Int8Array[0xf7];

^sysexArray
		
}

	*pauseCue{|device= 127, val1= 1, val2= 1|
		var t, t2, cue1, cue2, sysexArray;
	
	if( (val1 - val1.floor) != 0, {
	val1= val1.round(0.1);
	val1= val1.asString.findReplace(".", ""); 
	cue1= val1.asInteger.asDigits.collect({|it|
		("0x3"++(it.asString)).interpret;
	});
	t= cue1.last;
	//cue2[cue2.size-1]= 0x2E;
	cue1[(cue1.size-1)]= 46;
	cue1= cue1.add(t);
	cue1;
},{
	val1= val1.asInteger;
	cue1= val1.asDigits.collect({|it|
		("0x3"++(it.asString)).interpret;
	});
	cue1;
});

if((val2 - val2.floor) != 0, {
	val2= val2.round(0.1);
	val2= val2.asString.findReplace(".", ""); 
	cue2= val2.asInteger.asDigits.collect({|it|
		("0x3"++(it.asString)).interpret;
	});
	t2= cue2.last;
	//cue2[cue2.size-1]= 0x2E;
	cue2[cue2.size-1]= 46;
	cue2= cue2.add(t2);
	cue2;
},{
	val2= val2.asInteger;
	cue2= val2.asDigits.collect({|it|
		("0x3"++(it.asString)).interpret;
	});
	cue2;
});

sysexArray= Int8Array[ -16, 127, device, 2, 1, 2]++Int8Array.newFrom(cue1)++Int8Array[0]++Int8Array.newFrom(cue2)++Int8Array[0xf7];

^sysexArray
		
}

	*resumeCue{|device= 127, val1= 1, val2= 1|
		var t, t2, cue1, cue2, sysexArray;
	
	if( (val1 - val1.floor) != 0, {
	val1= val1.round(0.1);
	val1= val1.asString.findReplace(".", ""); 
	cue1= val1.asInteger.asDigits.collect({|it|
		("0x3"++(it.asString)).interpret;
	});
	t= cue1.last;
	//cue2[cue2.size-1]= 0x2E;
	cue1[(cue1.size-1)]= 46;
	cue1= cue1.add(t);
	cue1;
},{
	val1= val1.asInteger;
	cue1= val1.asDigits.collect({|it|
		("0x3"++(it.asString)).interpret;
	});
	cue1;
});

if((val2 - val2.floor) != 0, {
	val2= val2.round(0.1);
	val2= val2.asString.findReplace(".", ""); 
	cue2= val2.asInteger.asDigits.collect({|it|
		("0x3"++(it.asString)).interpret;
	});
	t2= cue2.last;
	//cue2[cue2.size-1]= 0x2E;
	cue2[cue2.size-1]= 46;
	cue2= cue2.add(t2);
	cue2;
},{
	val2= val2.asInteger;
	cue2= val2.asDigits.collect({|it|
		("0x3"++(it.asString)).interpret;
	});
	cue2;
});


sysexArray= Int8Array[ -16, 127, device, 2, 1, 3]++Int8Array.newFrom(cue1)++Int8Array[0]++Int8Array.newFrom(cue2)++Int8Array[0xf7];

^sysexArray
		
}



}

//EOF
	