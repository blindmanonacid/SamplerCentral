+ SoundFile {
� � � � plot { |name(path.basename), w, bounds, startFrame = 0, numFrames = -1|

			w ?? { w= Window(name, bounds) };
			bounds ?? { bounds= Rect(100, 100, 800, 200 * numChannels)};
� � � � � � � if(numFrames < 0) { numFrames = this.numFrames };
� � � � � � � ^SoundFileView(w, bounds)
� � � � � � � .resize_(5)
� � � � � � � .soundfile_(this)
� � � � � � � .readWithTask(startFrame, numFrames, doneAction: { w.front });
� � � � }
}
