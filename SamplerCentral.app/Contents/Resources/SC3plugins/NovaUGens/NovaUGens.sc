GendyI : UGen {
    *ar { arg ampdist=1, durdist=1, adparam=1.0, ddparam=1.0, minfreq=440, maxfreq=660, ampscale= 0.5, durscale=0.5,
        initCPs= 12, knum, interpolation = 0, mul=1.0,add=0.0;
        ^this.multiNew('audio', ampdist, durdist, adparam, ddparam, minfreq, maxfreq, ampscale, durscale, initCPs, knum ? initCPs, interpolation).madd( mul, add )
    }

    *kr {arg ampdist=1, durdist=1, adparam=1.0, ddparam=1.0, minfreq=20, maxfreq=1000, ampscale= 0.5, durscale=0.5,
        initCPs = 12, knum, interpolation = 0, mul=1.0,add=0.0;
        ^this.multiNew('control', ampdist, durdist, adparam, ddparam, minfreq, maxfreq, ampscale, durscale, initCPs, knum ? initCPs, interpolation).madd( mul, add )
    }
}
