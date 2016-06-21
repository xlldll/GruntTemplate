require.config( {
	paths : {
		'requireJs' : 'bowerJs/requirejs/require',
		'knockout'  : 'bowerJs/knockout/knockout',
		'jquery'    : 'bowerJs/jquery/jquery',
		'angular'    : 'bowerJs/angular/angular'
	},
	shim    : {
		'underscore'    : {
			exports : '_'
		},
		'backbone'      : {
			deps    : [ 'underscore','jquery' ],
			exports : 'Backbone'
		},
		'jquery.scroll' : {
			deps    : [ 'jquery' ],
			exports : 'jQuery.fn.scroll'
		},
		angular         : { exports : 'angular' }
	}
} );

