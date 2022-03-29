+ Collection {
	removeEqualDups {	// output a new collection without any duplicate values
		var result;
		result = this.species.new(this.size);
		this.do({ arg item;
			result.includesEqual(item).not.if({ result.add(item) });
		});
		^result
	}	
}