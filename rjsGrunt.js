require.config( {
	paths : {
		'indexCfg'       : 'jsRequire/index/indexCfg',
		'main-call'      : 'jsRequire/index/viewmodels/main_call',
		'main-viewmodel' : 'jsRequire/index/viewmodels/main_viewmodel',
		'requireJs'      : 'bowerJs/requirejs/require',
		'knockout'       : 'bowerJs/knockout/knockout',
		'jquery'         : 'bowerJs/jquery/jquery',
		'angular'        : 'bowerJs/angular/angular',
		'app'            : 'js2Min/app'
	},
	shim  : {
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

