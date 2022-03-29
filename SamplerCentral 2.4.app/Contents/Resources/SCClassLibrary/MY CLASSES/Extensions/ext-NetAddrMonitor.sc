NetAddrMon : NetAddr {
Ê Ê Ê Ê sendMsg { arg ... args;
Ê Ê Ê Ê Ê Ê Ê Ê super.sendMsg( *args );
Ê Ê Ê Ê Ê Ê Ê Ê if(~oscOutMonitor == 1,
Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê {("OSC OUT --" + super.hostname + "--" + super.port + "--" +
args).postln});
Ê Ê Ê Ê }
}