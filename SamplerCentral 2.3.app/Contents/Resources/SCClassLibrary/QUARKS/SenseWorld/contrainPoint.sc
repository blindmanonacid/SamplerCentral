+ Point{

	constrain{ |rect|
		if ( rect.contains( this ).not,
			{
				x = x.clip( rect.left, rect.left + rect.width );
				y = y.clip( rect.top, rect.left + rect.height );
			});
	}
}