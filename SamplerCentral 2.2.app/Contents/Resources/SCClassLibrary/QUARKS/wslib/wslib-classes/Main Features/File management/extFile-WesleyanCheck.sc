+ File {

	*isWesleyanBuild { ^File.getcwd.basename == "SC3" } // simple check
	
	*getBuildDate {
		var out, file;
		if( File.isWesleyanBuild )
			{ file = File(String.scDir ++ 
				"/SuperCollider.app/Contents/Resources/English.lproj/Credits.rtf","r");
			out = file.readAllString.stripRTF.split( $\n )[2].split( $  )[0];
			file.close;
		 	} {out = ""};
		^out;
		}
	}