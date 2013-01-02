+ Collection {
	detectAll { | function| // variation on select
		var res = Array.new(this.size);
		this.do {|elem, i| if (function.value(elem, i)) { res.add(i) } }
		^res;
	}
}
