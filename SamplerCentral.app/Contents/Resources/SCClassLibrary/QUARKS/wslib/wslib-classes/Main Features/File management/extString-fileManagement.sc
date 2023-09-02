{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf600
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Monaco;}
{\colortbl;\red255\green255\blue255;\red191\green0\blue0;\red0\green0\blue0;\red0\green0\blue191;
\red51\green51\blue191;\red102\green102\blue191;\red0\green0\blue255;\red0\green115\blue0;\red96\green96\blue96;
}
{\*\expandedcolortbl;;\csgenericrgb\c75000\c0\c0;\csgenericrgb\c0\c0\c0;\csgenericrgb\c0\c0\c75000;
\csgenericrgb\c20000\c20000\c75000;\csgenericrgb\c40000\c40000\c75000;\csgenericrgb\c0\c0\c100000;\csgenericrgb\c0\c45000\c0;\csgenericrgb\c37500\c37500\c37500;
}
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural

\f0\fs18 \cf2 // wslib 2006\cf3 \
\
\cf2 // osx only\cf3 \
\
\cf2 // using .systemCmd and .pathMatch\cf3 \
\cf2 // don't use wild cards ( *.* etc ) unless you know very well what you're doing\cf3 \
\
+ \cf4 Nil\cf3  \{ \
	isValidExtension \{ ^\cf5 false\cf3  \}\
	standardizePath \{ ^\cf5 nil\cf3  \} \
	\}\
\
+ \cf4 Symbol\cf3  \{ isValidExtension \{ ^\cf6 this\cf3 .asString.isValidExtension \} \}\
\
+ \cf4 SequenceableCollection\cf3  \{ \
\
	flatNoString \{ \cf2 // flat everything but the Strings\cf3 \
		\cf7 var\cf3  list;	\
		list = \cf6 this\cf3 .species.new;\
		\cf6 this\cf3 .do(\{ \cf7 arg\cf3  item, i;\
			if ( item.respondsTo(\cf8 'flatNoString'\cf3 ), \{\
				list = list.addAll( item.flatNoString );\
			\},\{\
				list = list.add( item );\
			\});\
		\});\
		^list\
		\}\
		\
	\}\
\
+ \cf4 String\cf3  \{\
	\
	flatNoString \{ ^[ \cf6 this\cf3  ] \}\
\
	folderContents \{ \cf7 |levels = inf|\cf3  \cf2 // all folder contents\cf3 \
		\cf7 var\cf3  out = [];\
		out = (\cf6 this\cf3 .standardizePath ++ \cf9 "/*"\cf3 ).pathMatch;\
		if( levels != 0 )\
			\{ out = out.collect(\{ \cf7 |item|\cf3 \
			  if( item.last == $/ )\
				\{ item.folderContents( levels - 1 );  \}\
				\{ item; \}; \});\
			\};\
		^out.flatNoString;\
		\}\
\
	postlnIfTrue \{ \cf7 |bool = true|\cf3  if( bool ) \{ ^\cf6 this\cf3 .postln \}; \}\
\
	isFile \{ ^\cf4 PathName\cf3 ( \cf6 this\cf3  ).isFile; \}\
	\
	isSoundFile \{ \cf7 var\cf3  sf;\
		\cf2 //if( this.isFile )\cf3 \
		if( \cf4 File\cf3 .exists(\cf6 this\cf3 ) ) \cf2 // changed to include odd letters in name that isFile rejects\cf3 \
			\{ sf = \cf4 SoundFile\cf3 .new;\
				if( sf.openRead( \cf6 this\cf3 .standardizePath ) )\
					\{ sf.close; \
						^\cf5 true\cf3  \}\
					\{ ^\cf5 false\cf3  \};\
			\}\
			\{ ^\cf5 false\cf3   \}\
		\}\
	\
	\
	isFolder \{ ^\cf4 PathName\cf3 ( \cf6 this\cf3  ).isFolder; \} \cf2 // can also be bundle\cf3 \
	\
	isBundlePath \{ ^( \cf6 this\cf3 .last == $/ ) && \{ \cf6 this\cf3 .splitext.last.isValidExtension \}; \}\
		\
	isBundle \{  \cf2 // such as .app, .wdgt, .component, .bundle etc\cf3 \
		\cf7 var\cf3  path;\
		path = \cf6 this\cf3 .pathMatch;\
		^if(path.notEmpty, \{ path[0].isBundlePath; \}, \{ \cf5 false\cf3  \});\
		\}\
		\
	isValidExtension \{\
		if( (\cf6 this\cf3 .size == 0) or: \
				\{ \cf6 this\cf3 .includes( $ ) or: \cf6 this\cf3 .first.isAlpha.not \} ) \
			\{ ^\cf5 false\cf3  \} \{ ^\cf5 true\cf3  \}; \
		\}\
	\
	pad \{ \cf7 |char = $', amt = 1|\cf3 \
		\cf7 var\cf3  padString;\
		padString = \cf4 String\cf3 .fill( amt, \{ char \} );\
		^padString ++ \cf6 this\cf3  ++ padString;\
		\}\
		\
	removeFwdSlash \{ if( \cf6 this\cf3 .last == $/ ) \{ ^\cf6 this\cf3 [0..(\cf6 this\cf3 .size-2)] \} \{ ^\cf6 this\cf3  \} \}\
		\
	extension \{ \cf7 var\cf3  ext; \cf2 // returns only if valid\cf3 \
		ext = \cf6 this\cf3 .splitext.last;\
		if( ext.isValidExtension )\
			\{ ^ext.removeFwdSlash \} \cf2 // removes fwdSlash from bundle paths\cf3 \
			\{ ^\cf5 nil\cf3  \}\
		\}\
	\
	removeExtension \{ \cf7 var\cf3  ext;\
		ext = \cf6 this\cf3 .extension;\
		^if(ext.notNil)\
			\{ \cf6 this\cf3 .splitext.first \}\
			\{ \cf6 this\cf3  \}	\
		\}\
	\
	replaceExtension \{ \cf7 |newExt|\cf3 \
		if( newExt.notNil)\
			\{ ^\cf6 this\cf3 .standardizePath.removeExtension ++ \cf9 "."\cf3  ++ newExt \}\
		\}\
		\
	hasExtension \{ ^\cf6 this\cf3 .extension != \cf5 nil\cf3  \}\
	\
	absolutePath2 \{ \cf7 |base|\cf3  \cf2 // crude..\cf3 \
		if( base.isNil )\
			\{ ^\cf6 this\cf3 .basename \}\
			\{ ^\cf6 this\cf3 [base.size..] \}\
		\}\
	\
	pathExists \{ \cf7 |showType = true|\cf3  \cf2 // types are : \\bundle, \\folder and \\file\cf3 \
		\cf7 var\cf3  path;\
		path = \cf6 this\cf3 .pathMatch;\
		^if( showType )\
			\{ if(path.size == 1)\
				\{ if( path.at(0).last == $/ )\
					\{ if( path.at(0).isBundlePath ) \{ \cf8 \\bundle\cf3  \} \{ \cf8 \\folder\cf3  \} \}\
					\{ \cf8 \\file\cf3  \};\
				\}	\{ \cf5 false\cf3  \};\
			\} \{ path.size == 1 \}\
		\}\
\
	 makeDir \{ \cf7 |silent = false|\cf3 \
 		\cf2 // auto create directories when they're not there - be carefull with this one\cf3 \
 		\cf7 var\cf3  dname;\
 		dname = \cf6 this\cf3 .standardizePath;\
		if( dname.pathMatch == []; )\
				\{ (\cf9 "mkdir -p"\cf3  + dname.quote).systemCmd;\
				(\cf9 "created dir:"\cf3  + dname ).postlnIfTrue( silent.not );  \}\
		\}\
	\
	\cf2 //// copy, move and rename\cf3 \
		\
	renameTo \{ \cf7 |newName|\cf3  \cf2 // only the file's / folder's name is used\cf3 \
		\cf7 var\cf3  result;\
		if( newName != \cf5 nil\cf3  )\
			\{ if( \cf6 this\cf3 .isFile or: \cf6 this\cf3 .isFolder )\
				\{ 	newName = \cf6 this\cf3 .standardizePath.dirname ++ \cf9 "/"\cf3  ++ newName.basename;\
					result = (\cf9 "mv"\cf3  + \cf6 this\cf3 .standardizePath.quote + newName.quote ).systemCmd;\
					if( result == 0 )\
						\{ (\cf9 "String-renameTo:\\n\\trenamed '"\cf3  ++ \cf6 this\cf3 .basename ++ \
								\cf9 "' to '"\cf3  ++ newName.basename ++ \cf9 "'"\cf3 ).postln; \}\
						\{ (\cf9 "String-renameTo: failed (result:"\cf3  + result ++ \cf9 ")"\cf3 ).postln; \};\
								\
					^newName; \}\
				\{ (\cf9 "String-renameTo: '"\cf3  ++ \cf6 this\cf3  ++ \cf9 "' doesn't exist"\cf3 ).postln; \
					^\cf6 this\cf3  \};\
			\}\
		\}\
		\
	copyTo \{ \cf7 |newDir = "", newName, overwrite = false, createIfNotThere = true, silent = false |\cf3  \
	\
		\cf2 // if newName == nil the original name is used\cf3 \
		\
		\cf7 var\cf3  from, result, to, exists = \cf5 false\cf3 ;\
		from = \cf6 this\cf3 .standardizePath;\
		to = newDir.standardizePath ++ \cf9 "/"\cf3  ++ ( newName ? from.basename );\
		exists = to.isFile or: to.isFolder;\
		if( exists.not or: overwrite )\
			\{	if( createIfNotThere ) \{ to.dirname.makeDir( silent ) \};\
				result = (\cf9 "cp -R"\cf3  + from.quote + to.quote).systemCmd;\
				if( result == 0 )\
					\{ (\cf9 "String-copyPath:\\n\\tcopied  '"\cf3  ++ \
		     			from ++ \cf9 "'\\n\\tto      '"\cf3  ++ to ++ \cf9 "'"\cf3  ++ \
		     				 ( if(exists) \{\cf9 " (overwritten)"\cf3  \} \{\cf9 ""\cf3 \} ) )\
		     				 .postlnIfTrue( silent.not ); \}\
					\{ (\cf9 "String-copyTo: failed (result:"\cf3  + result ++ \cf9 ")"\cf3 )\
						.postlnIfTrue( silent.not ); \};\
					\
			\}\
			\{ (\cf9 "String-copyTo: failed\\n\\t'"\cf3  ++ to ++ \cf9 "' already exists"\cf3  )\
				.postlnIfTrue( silent.not ); \}\
		^result == 0; \cf2 // returns true when succeeded\cf3 \
		\}\
		\
	copyFile \{ \cf7 |newPath, overwrite = false, createIfNotThere = true, silent = false |\cf3 \
		\cf2 // full path as input\cf3 \
		\cf2 // still also copies folders\cf3 \
		newPath = newPath.standardizePath;\
		^\cf6 this\cf3 .copyTo( newPath.dirname, newPath.basename, overwrite, createIfNotThere, silent );\
		\} \
	\
	copyToDir \{ \cf7 |newDir = "", overwrite = false, createIfNotThere = true, silent = false |\cf3 \
		\cf2 // same as copyTo, but doesn't specify new name\cf3 \
		^\cf6 this\cf3 .copyTo( newDir, \cf5 nil\cf3 , overwrite, createIfNotThere, silent );\
		\}\
	\
	copyRename \{ \cf7 |newDir = "", newName, createIfNotThere = true, silent = false |\cf3 \
	\
		\cf2 // auto rename if exists\cf3 \
		\
		\cf7 var\cf3  result, to, exists = \cf5 false\cf3 ;\
		to = newDir.standardizePath ++ \cf9 "/"\cf3  ++ (newName ? \cf6 this\cf3 .basename);\
		if(  to.pathExists( \cf5 false\cf3  ) )\
			\{ ^\cf6 this\cf3 .copyRename( newDir, \cf4 PathName\cf3 ( to.basename ).realNextName, \
				createIfNotThere, silent );  \}\
			\{ if( \cf6 this\cf3 .copyTo( newDir, newName, createIfNotThere: createIfNotThere, \
				silent: silent ) )\
				\{ ^to \} \
				\{ ^\cf5 false\cf3  \};\
			\};\
		\}\
		\
	copyReplace \{ \cf7 |newDir = "", newName, createIfNotThere = true, \
		toTrash = true, ask = true, silent = false|\cf3 \
		( newDir.standardizePath ++ \cf9 "/"\cf3  ++ ( newName ? \cf6 this\cf3 .basename ) )\
			.removeFile( toTrash, ask, silent );\
		^\cf6 this\cf3 .copyTo( newDir, newName, \cf5 false\cf3 , createIfNotThere, silent );\
		\}\
		\
		\
	replaceWith \{ \cf7 |inPath, createIfNotThere = true|\cf3  \cf2 // copyTo vice versa\cf3 \
		^inPath.copyTo( \cf6 this\cf3 .standardizePath.dirname, \cf6 this\cf3 .standardizePath.basename, \
			\cf5 true\cf3 , createIfNotThere );\
		\}\
		\
	copyToDesktop \{ ^\cf6 this\cf3 .copyTo( \cf9 "~/Desktop"\cf3  ); \}\
	create_scwork \{ \cf9 "~/scwork"\cf3 .makeDir; \}\
	copyTo_scwork \{ ^\cf6 this\cf3 .copyTo( \cf9 "~/scwork"\cf3 , \cf5 nil\cf3 , \cf5 false\cf3 , \cf5 true\cf3  ); \} \cf2 // creates if not there\cf3 \
	\
	moveToDir \{ \cf7 |to, createIfNotThere = false, silent = false|\cf3  \cf2 // move anything to a dir \cf3 \
		\cf2 // doesn't overwrite (result:256)\cf3 \
		\cf7 var\cf3  result, exists;\
		exists = \cf6 this\cf3 .pathExists;\
		if( to.notNil && \{ exists != \cf5 false\cf3  \} )\
			\{ 	to = to.standardizePath;\
				if( createIfNotThere ) \{ to.makeDir( silent ) \};\
				if( to.isFolder )\
					\{ \
					result = (\cf9 "mv"\cf3  + \cf6 this\cf3 .standardizePath.quote + to.quote).systemCmd; \
					\
					if( result == 0 )\
						\{ (\cf9 "String-moveToDir:\\n\\tmoved  '"\cf3  ++ \
		     					\cf6 this\cf3 .standardizePath ++ \cf9 "' ("\cf3  ++ exists ++\
		     					 \cf9 ")\\n\\tto     '"\cf3  ++ to ++ \cf9 "/'"\cf3 ).postlnIfTrue( silent.not );\
		     					 \
		     			^to ++ \cf9 "/"\cf3  ++ \cf6 this\cf3 .standardizePath.basename; \cf2 // return new path\cf3 \
		     			\} \
		     			\{ (\cf9 "String-moveToDir: failed (result:"\cf3  + result ++ \cf9 ")"\cf3 )\
		     					.postlnIfTrue( silent.not ); \
		     			\};\
		     		\}\
					\{ \cf9 "String-moveToDir: folder or file doesn't exist"\cf3 \
						.postlnIfTrue( silent.not );\
					\};\
			\};\
		\}\
		\
	moveTo \{ \cf7 |newDir = "", newName, createIfNotThere = true, silent = false |\cf3  \
	\
		\cf2 // if newName == nil the original name is used\cf3 \
		\
		\cf2 // does not overwrite\cf3 \
		\
		\cf7 var\cf3  from, result, to, exists = \cf5 false\cf3 ;\
		from = \cf6 this\cf3 .standardizePath;\
		to = newDir.standardizePath ++ \cf9 "/"\cf3  ++ ( newName ? from.basename );\
		exists = to.isFile or: to.isFolder;\
		if( exists.not )\
			\{	if( createIfNotThere ) \{ to.dirname.makeDir( silent ) \};\
				result = (\cf9 "mv"\cf3  + from.quote + to.quote).systemCmd;\
				if( result == 0 )\
					\{ (\cf9 "String-moveTo:\\n\\tmoved  '"\cf3  ++ \
		     			from ++ \cf9 "'\\n\\tto      '"\cf3  ++ to ++ \cf9 "'"\cf3  )\
		     				.postlnIfTrue( silent.not ); \}\
					\{ (\cf9 "String-moveTo: failed (result:"\cf3  + result ++ \cf9 ")"\cf3 )\
						.postlnIfTrue( silent.not ); \};\
					\
			\}\
			\{ (\cf9 "String-moveTo: failed\\n\\t'"\cf3  ++ to ++ \
				\cf9 "' already exists or original was not found"\cf3  )\
				.postlnIfTrue( silent.not );\
				\}\
		^result == 0; \cf2 // returns true when succeeded\cf3 \
		\
		\}\
		\
	moveRename \{ \cf7 |newDir = "", newName, createIfNotThere = true, silent = false |\cf3 \
		\cf7 var\cf3  result, to, exists = \cf5 false\cf3 ;\
		to = newDir.standardizePath ++ \cf9 "/"\cf3  ++ (newName ? \cf6 this\cf3 .basename);\
		if(  to.pathExists( \cf5 false\cf3  ) )\
			\{ ^\cf6 this\cf3 .moveRename( newDir, \cf4 PathName\cf3 ( to.basename ).realNextName, \
				createIfNotThere, silent );  \}\
			\{ if( \cf6 this\cf3 .moveTo( newDir, newName, createIfNotThere: createIfNotThere, silent: silent ) )\
				\{ ^to \} \
				\{ ^\cf5 false\cf3  \};\
			\};\
		\}\
		\
	moveReplace \{ \cf7 |newDir = "", newName, createIfNotThere = true, \
		toTrash = true, ask = true, silent = false|\cf3 \
		( newDir.standardizePath ++ \cf9 "/"\cf3  ++ ( newName ? \cf6 this\cf3 .basename ) )\
			.removeFile( toTrash, ask, silent );\
		^\cf6 this\cf3 .moveTo( newDir, newName, createIfNotThere, silent );\
		\}\
	\
		\
	removeFile \{ \cf7 |toTrash = true, ask = true, silent = false|\cf3 \
		\cf2 // by default only moves to trash\cf3 \
		\cf2 // watch out with this one..\cf3 \
		\cf2 // also removes folders...\cf3 \
		\cf2 // does not ask when moving to trash\cf3 \
		\
		\cf7 var\cf3  result, exists, rmFunc;\
		exists = \cf6 this\cf3 .pathExists;\
		rmFunc = \{ result = (\cf9 "rm -R"\cf3  + \cf6 this\cf3 .standardizePath.quote).systemCmd; \
						(\cf9 "String-removeFile: removed file"\cf3  + \cf6 this\cf3 .basename.quote)\
						.postlnIfTrue( (result == 0) && silent.not );\
				 \};\
	\
		if(  exists != \cf5 false\cf3  )\
			\{ if( toTrash )\
				\{ ^\cf6 this\cf3 .moveRename( \cf9 "~/.Trash"\cf3 , silent: silent );  \}\
				\{ if( ask )\
					\{ \cf4 SCAlert\cf3 ( \cf9 "delete"\cf3  + \cf6 this\cf3 .basename.quote ++ \cf9 "?"\cf3 ,\
						[ \cf9 "cancel"\cf3 , \cf9 "ok"\cf3  ], [\cf5 nil\cf3 , rmFunc]);\
						\} \{ rmFunc.value \};\
				\};\
			\};\
		\}\
		\
		\
	\cf2 //// file compression and archiving\cf3 \
		\
	zip \{ \cf7 |newPath, includeInvisible = false, tmp = "/tmp"|\cf3  \
		\cf2 // makes zip archive (leaves original intact)\cf3 \
		\cf7 var\cf3  oldPath, exists, result;\
		oldPath = \cf6 this\cf3 .standardizePath;\
		newPath = newPath.standardizePath ? oldPath.removeExtension;\
		exists = \cf6 this\cf3 .pathExists;\
		if( exists != \cf5 false\cf3  )\
			\{ result = \
				( \cf9 "cd"\cf3  + oldPath.dirname.quote + \cf9 "\\n"\cf3 \
				\cf9 "zip -b"\cf3  + tmp +\
			 	(if( [\cf8 \\folder\cf3 , \cf8 \\bundle\cf3 ].includes(exists) ) \{ \cf9 "-r "\cf3  \} \{\cf9 ""\cf3 \}) ++\
			 	\cf2 //"-j" +  // -j is for losing the absolute path data\cf3 \
				(if( includeInvisible ) \{ \cf9 "-S "\cf3  \} \{\cf9 ""\cf3 \}) ++\
				newPath.quote + oldPath.basename.quote ).systemCmd;\
			if( result == 0 )\
				\{ (\cf9 "String-zip:\\n\\tcreated zip file  '"\cf3  ++ newPath ++ \cf9 ".zip'"\cf3 ).postln; \
					^newPath ++ \cf9 ".zip"\cf3 ; \}\
				\{ (\cf9 "String-zip: failed (result:"\cf3  ++ result ++ \cf9 ")"\cf3 ).postln; \};\
			\}\
			\{ \cf9 "String-zip: original path not found"\cf3 .postln; \};\
		\}\
		\
	unzip \{ \cf7 |to|\cf3 \
		\cf7 var\cf3  oldPath, exists, result;\
		oldPath = \cf6 this\cf3 .standardizePath.replaceExtension( \cf9 "zip"\cf3  );\
		exists = oldPath.pathExists;\
		to = to.standardizePath ? oldPath.dirname;\
		if( exists != \cf5 false\cf3  )\
			\{ result = (\cf9 "unzip"\cf3  + oldPath.quote + \cf9 "-d"\cf3  + to.quote ).systemCmd;\
			  if(result == 0)\
				\{ (\cf9 "String-unzip:\\n\\tunzipped file"\cf3  + oldPath.pad($') ).postln; \}\
				\{ (\cf9 "String-unzip: failed (result:"\cf3  ++ result ++ \cf9 ")"\cf3 ).postln; \};\
				\}\
			\{ \cf9 "String-zip:"\cf3  + oldPath.pad($') + \cf9 "not found"\cf3 .postln; \};\
		\}\
		\
	\cf2 // the following methods don't use internal check; systemCmd will fail when files or\cf3 \
	\cf2 // folders don't exist:\cf3 \
	\
	tar \{ \cf7 |newPath|\cf3 \
		\cf7 var\cf3  location, original, result;\
		original = \cf6 this\cf3 .standardizePath;\
		location = (newPath ? original).standardizePath;\
		if(location.extension != \cf9 "tar"\cf3  ) \{ location = location ++ \cf9 ".tar"\cf3 ; \};\
		\
		if( (\cf9 "cd"\cf3  + original.dirname.quote \
		+ \cf9 "\\n"\cf3  + \cf9 "tar cvf"\cf3  + location.quote + original.basename.quote\
			).systemCmd != 0 )\
			\{ \cf9 "String-tar: failed - might still have created an empty tar file"\cf3 .postln; \}\
			\{ ( \cf9 "String-tar:\\n\\tcreated tar file"\cf3  + location ).postln; \};\
		\
		^location;\
		\}\
		\
	untar \{ \cf7 var\cf3  location, result;\
		location = \cf6 this\cf3 .standardizePath;\
		if( (\cf9 "cd"\cf3  + location.dirname.quote \
		+ \cf9 "\\n"\cf3  + \cf9 "tar xvf"\cf3  + location.basename.quote\
			).systemCmd != 0 )\
			\{ \cf9 "String-untar: failed"\cf3 .postln; \}\
			\{ ( \cf9 "String-untar:\\n\\textracted tar file"\cf3  + location.pad($') ).postln; \};\
		^location.removeExtension; \cf2 // could be wrong if filename != stored folder/file name\cf3 \
		\}\
	\
	gz \{ \cf7 |speed = 6|\cf3  \cf2 // 1 = fast, 9 = best (don't expect very large differences here)\cf3 \
		\
		\cf2 //  use with care: deletes original\cf3 \
		\cf2 // for folders first use .tar\cf3 \
		\
		if ( (\cf9 "gzip"\cf3  + \cf9 "-"\cf3  ++ (speed.max(1).min(9).round(1)) +\
				\cf6 this\cf3 .standardizePath.quote).systemCmd != 0 )\
			\{ \cf9 "String-gz: failed"\cf3 .postln \}\
			\{ ( \cf9 "String-gz:\\n\\tcreated gzipped file"\cf3  + \
				( \cf6 this\cf3 .standardizePath ++ \cf9 ".gz"\cf3 ).pad($') ).postln; \};\
		^\cf6 this\cf3  ++ \cf9 ".gz"\cf3 ;\
		\}\
		\
	ungz \{\
		if ( (\cf9 "gunzip"\cf3  + \cf6 this\cf3 .standardizePath.quote).systemCmd != 0 )\
			\{ \cf9 "String-ungz: failed"\cf3 .postln \}\
			\{ ( \cf9 "String-ungz:\\n\\gunzipped file"\cf3  + \cf6 this\cf3 .standardizePath.pad($') ).postln; \};\
		^\cf6 this\cf3 .removeExtension;\
		\}\
		\
	targz \{  \cf7 |newPath, speed = 6|\cf3  \
		\cf7 var\cf3  tar;\
		tar = \cf6 this\cf3 .tar(newPath);\
		^tar.gz(speed);\
		\}\
		\
	tgz \{ \cf7 |newPath, speed = 6|\cf3  \
		\cf7 var\cf3  tar;\
		tar = \cf6 this\cf3 .tar(newPath);\
		^tar.gz(speed).renameTo( tar.basename.removeExtension.replaceExtension( \cf9 "tgz"\cf3  ) );\
		\}\
		\
	untgz \{ \cf7 arg\cf3  deleteTar=\cf5 false\cf3 ;\
	     \cf7 var\cf3  out; \
		\cf7 var\cf3  tar;\
		tar = \cf6 this\cf3 .ungz;\
		if( tar.extension != \cf9 "tar"\cf3  ) \{ tar = tar ++ \cf9 ".tar"\cf3 ; \}; \cf2 // .tar.gz support\cf3 \
		out = tar.untar;\
		if( deleteTar ) \{ tar.removeFile( \cf5 true\cf3 , \cf5 false\cf3  ) \};\
		^out\
		\}\
		\
	flac \{ \cf7 |level = 5, newDir, deleteInputFile = false, flacLocation = "/usr/local/bin/" |\cf3  \cf2 // 0-8\cf3 \
		\cf2 // needs flac to be installed \cf3 \
		\cf7 var\cf3  result, thisStd;\
				\
		thisStd = \cf6 this\cf3 .standardizePath;\
		\
		result = \cf9 "%flac% -%  %"\cf3 .format( \
				flacLocation,\
				(if( deleteInputFile ) \{ \cf9 " --delete-input-file"\cf3  \} \{ \cf9 ""\cf3  \}),\
				level,\
				thisStd.quote\
			).systemCmd;\
				\
		if( result != 0 ) \
			\{ \cf9 "String-flac: failed"\cf3 .postln; ^thisStd; \} \
			\{  (\cf9 "String-flac: created\\n\\t"\cf3  ++ \
				thisStd.replaceExtension( \cf9 "flac"\cf3  ) ).postln;\
			if( newDir.notNil )\
				\{ if( thisStd.replaceExtension( \cf9 "flac"\cf3  ).moveTo( newDir ) )\
						\{  ^(newDir.standardizePath ++ \cf9 "/"\cf3  ++ \
							thisStd.basename.replaceExtension( \cf9 "flac"\cf3  ) ); \}\
						\{  ^thisStd.replaceExtension( \cf9 "flac"\cf3  ); \}; \}\
				\{ ^thisStd.replaceExtension( \cf9 "flac"\cf3  ); \}; \
			\};\
		\}\
		\
	unflac \{ \cf7 |format = 'wav', newDir, deleteInputFile = false, flacLocation = "/usr/local/bin/" |\cf3  \
	\
		\cf2 // format: 'wav' or 'aiff'\cf3 \
		\cf2 // needs flac to be installed\cf3 \
		\
		\cf7 var\cf3  result, thisStd;\
				\
		thisStd = \cf6 this\cf3 .standardizePath;\
		\
		result = \cf9 "%flac -d % %"\cf3 .format(\
			flacLocation,\
			(if( format === \cf8 'aiff'\cf3  ) \
				\{ \cf9 "--force-aiff-format"\cf3  \} \
				\{\cf9 ""\cf3 \} ), \
			thisStd.quote ).systemCmd;\
				\
		if( result != 0 ) \
			\{ \cf9 "String-unflac: failed"\cf3 .postln; \}					\{ (\cf9 "String-unflac: created\\n\\t"\cf3  ++ \
				thisStd.replaceExtension( format.asString )).postln;\
			 if( newDir.notNil )\
				\{ if( thisStd.replaceExtension( format.asString ).moveTo( newDir ) )\
						\{  ^(newDir.standardizePath ++ \cf9 "/"\cf3  ++ \
							thisStd.basename.replaceExtension( format.asString ) ); \}\
						\{  ^thisStd.replaceExtension( format.asString ); \}; \}\
				\{ ^thisStd.replaceExtension( format.asString ); \};\
			\};\
		\}\
		\
	flacAll \{ \cf7 |level = 5, newDir, extensions, deleteInputFiles = false,  \
			flacLocation = "/usr/local/bin/" |\cf3 \
		\cf7 var\cf3  files, tdn, dirName, out = [];\
		\
		extensions = extensions ? [ \cf8 'wav'\cf3 , \cf8 'aif'\cf3 , \cf8 'aiff'\cf3 , \cf8 'sd2'\cf3  ];\
		dirName = \cf6 this\cf3 .standardizePath;\
		\
		files = dirName.folderContents.select(\{ \cf7 |item|\cf3 \
			extensions.includes( item.extension.asSymbol );\
			\});\
			\
		files = files.collect(\{ \cf7 |item|\cf3 \
			item[ (dirName.size + 1) ..];\
			\});\
		\
		files.do(\{ \cf7 |item|\cf3 \
			if( newDir.notNil )\
				\{ tdn = item.dirname;\
				  if( tdn.asSymbol === \cf8 '.'\cf3  ) \{ tdn = \cf9 ""\cf3  \};\
				 \
				out = out.add( (dirName ++ \cf9 "/"\cf3  ++ item).flac( level, \
					newDir ++ \cf9 "/"\cf3  ++ tdn,\
					deleteInputFile: deleteInputFiles,\
					flacLocation: flacLocation ) ); \}\
					\
				\{ out = out.add( (dirName ++ \cf9 "/"\cf3  ++ item).flac( level, \
					deleteInputFile: deleteInputFiles,\
					flacLocation: flacLocation ) ); \};\
			\});\
		\
		^out;\
		\}\
		\
	unflacAll \{ \cf7 |format = 'wav', newDir, deleteInputFiles = false,  \
			flacLocation = "/usr/local/bin/" |\cf3 \
		\cf7 var\cf3  files, tdn, dirName, out = [];\
		\
		dirName = \cf6 this\cf3 .standardizePath;\
		\
		files = dirName.folderContents.select(\{ \cf7 |item|\cf3 \
			item.extension.asSymbol === \cf8 'flac'\cf3 ;\
			\});\
			\
		files = files.collect(\{ \cf7 |item|\cf3 \
			item[ (dirName.size + 1) ..];\
			\});\
		\
		files.do(\{ \cf7 |item|\cf3 \
			if( newDir.notNil )\
				\{ tdn = item.dirname;\
				  if( tdn.asSymbol === \cf8 '.'\cf3  ) \{ tdn = \cf9 ""\cf3  \};\
				 \
				out = out.add( (dirName ++ \cf9 "/"\cf3  ++ item).unflac( format, \
					newDir ++ \cf9 "/"\cf3  ++ tdn,\
					deleteInputFile: deleteInputFiles,\
					flacLocation: flacLocation ) ); \}\
					\
				\{ out = out.add( (dirName ++ \cf9 "/"\cf3  ++ item).unflac( format, \
					deleteInputFile: deleteInputFiles,\
					flacLocation: flacLocation ) ); \};\
			\});\
		\
		^out;\
		\}\
		\
	openWith \{ \cf7 |appName = "SuperCollider"|\cf3 \
		(\cf9 "open -a"\cf3  + appName.asString.quote + \cf6 this\cf3 .standardizePath.quote ).systemCmd;\
		\}\
		\
	openWithID \{ \cf7 |id = "com.apple.safari"|\cf3 \
		(\cf9 "open -b"\cf3  + id + \cf6 this\cf3 .standardizePath.quote ).systemCmd;\
		\}\
		\
	openInFinder \{ (\cf9 "open"\cf3  + \cf6 this\cf3 .standardizePath.quote ).systemCmd; \}\
	\
	showInFinder \{ (\cf9 "open"\cf3  + \cf6 this\cf3 .standardizePath.dirname.quote ).systemCmd; \}\
	\
	downloadURL \{ \cf7 |to|\cf3  \cf2 // input should be valid web adress -- not finished\cf3 \
		if( to.isNil )\
			\{ \};\
		\}\
		\
	getHostIP \{\
		\cf7 var\cf3  out;\
		if ( (out = \{ \cf6 this\cf3 .gethostbyname.asIPString \}.try).isNil )\
			\{ \cf9 "String-getHostIP: host '%' not found\\n"\cf3 .postf( \cf6 this\cf3  );\
				^out \}\
			\{ ^out \};\
		\}\
		\
	afp \{ \cf7 |login, password, volume|\cf3 \
		\cf7 var\cf3  loginPassword, server;\
		\
		if( password.notNil )\
			\{ loginPassword = \cf9 ":"\cf3  ++ password.findReplaceAll( \cf9 " "\cf3 , \cf9 "%20"\cf3 ); \};\
			\
		if( login.notNil )\
			\{ loginPassword = login.findReplaceAll( \cf9 " "\cf3 , \cf9 "%20"\cf3 ) \
				++ ( loginPassword ? \cf9 ""\cf3  ) \
				++ \cf9 "@"\cf3 ; \}\
			\{ loginPassword = \cf9 ""\cf3  \};\
		\
		if( volume.notNil )\
			\{ volume = \cf9 "/"\cf3  ++ volume.findReplaceAll( \cf9 " "\cf3 , \cf9 "%20"\cf3 ); \}\
			\{ volume = \cf9 ""\cf3  \};\
			\
		server = \cf6 this\cf3 .findReplaceAll( \cf9 " "\cf3 , \cf9 "%20"\cf3 );\
			\
		\cf9 "open afp://%%%"\cf3 \
			.format( loginPassword, server, volume )\
			.systemCmd;\
	 \}\
	\
	openServer \{ \cf7 |login, password, volume|\cf3  \cf2 // by default opens volume with same name as server\cf3 \
		^( \cf6 this\cf3 .findReplaceAll( \cf9 " "\cf3 , \cf9 "-"\cf3  ) ++ \cf9 ".local"\cf3  )\
			.afp( login, password, volume ? \cf6 this\cf3  );\
		  \}\
		\
	\cf2 // old\cf3 \
	\
	downloadCVSSource \{ \cf7 | login = "anonymous", password = "", server = "cvs.sourceforge.net", \
			root = "/cvsroot/supercollider", repository = "SuperCollider3"|\cf3  \
		\cf7 var\cf3  dest;\
		if( \cf6 this\cf3  == \cf9 ""\cf3  )\
			\{ dest = \cf9 "~/dev"\cf3 ; \}\
			\{ dest = \cf6 this\cf3 ; \};\
		dest.makeDir;\
		(\cf9 "cd"\cf3  + dest.quote ++ \
			\cf9 "\\n"\cf3  ++\
			\cf9 "cvs -d:pserver:"\cf3  ++ login ++ \cf9 "@"\cf3  ++ server ++ \cf9 ":"\cf3  ++ root + \cf9 "login"\cf3  ++ \
			\cf9 "\\n"\cf3  ++\
			password ++ \cf9 "\\n"\cf3  ++  \cf2 // enter for password\cf3 \
			\cf9 "cvs -z3 -d:pserver:"\cf3  ++ login ++ \cf9 "@"\cf3  ++ server ++ \cf9 ":"\cf3  ++ root + \cf9 "co"\cf3  + repository ).unixCmd;\
		\}\
	\
	updateCVSSource \{  \cf2 // works?\cf3 \
		\cf7 var\cf3  dest;\
		if( \cf6 this\cf3  == \cf9 ""\cf3  )\
			\{ dest = \cf9 "~/dev/SuperCollider3/"\cf3 ; \}\
			\{ dest = \cf6 this\cf3 ; \};\
		dest.makeDir;\
		(\cf9 "cd"\cf3  + dest.quote ++ \cf9 "\\n"\cf3  ++ \cf9 "cvs -z3 update -dP"\cf3  ++ \cf9 "\\n"\cf3  ).unixCmd;\
		\}\
		\
	\cf2 // new	 \cf3 \
	\
	downloadSVNSource \{ \cf7 |folderName = "SuperCollider3",\
		repos = "https://svn.sourceforge.net/svnroot/supercollider/trunk"|\cf3 \
		\cf7 var\cf3  dest;\
		if( \cf6 this\cf3  == \cf9 ""\cf3  )\
			\{ dest = \cf9 "~/dev"\cf3 ; \}\
			\{ dest = \cf6 this\cf3 ; \};\
		dest.makeDir;\
		( \cf9 "cd"\cf3  + dest.quote ++ \
			\cf9 "\\n"\cf3  ++\
		  \cf9 "svn co"\cf3  + repos + folderName ).unixCMD;\
		\}\
\
	\}}