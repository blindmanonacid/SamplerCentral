+ SoundFile {
Ê Ê Ê Ê plot { |name(path.basename), w, bounds, startFrame = 0, numFrames = -1|

			w ?? { w= Window(name, bounds) };
			bounds ?? { bounds= Rect(100, 100, 800, 200 * numChannels)};
Ê Ê Ê Ê Ê Ê Ê if(numFrames < 0) { numFrames = this.numFrames };
Ê Ê Ê Ê Ê Ê Ê ^SoundFileView(w, bounds)
Ê Ê Ê Ê Ê Ê Ê .resize_(5)
Ê Ê Ê Ê Ê Ê Ê .soundfile_(this)
Ê Ê Ê Ê Ê Ê Ê .readWithTask(startFrame, numFrames, doneAction: { w.front });
Ê Ê Ê Ê }
}
