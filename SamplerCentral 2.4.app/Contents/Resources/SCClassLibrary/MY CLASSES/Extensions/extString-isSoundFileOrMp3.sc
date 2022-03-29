+ String {

	isSoundFileOrMp3 { var sf;
		if( this.isFile )
			{ sf = SoundFile.new;
				if( sf.openRead( this.standardizePath ) )
					{ sf.close; 
						^true }
					{ if(this.extension=="mp3", {^true }, {^false}); };
			}
			{ ^false  }
		}
		
}