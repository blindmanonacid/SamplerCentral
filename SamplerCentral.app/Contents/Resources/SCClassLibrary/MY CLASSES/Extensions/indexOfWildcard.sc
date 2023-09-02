+ ArrayedCollection{

indexOfWildcard { arg item;
	var index;
	if (item.class == Symbol, { item= item.asString });
	if (item.isString, {
		this.do({|it, i|
			if (it.class == Symbol, { it= it.asString });
			if (it.isString, {
				if (it.contains(item), {index= i});
			});
		});
	});
	^index
}

}