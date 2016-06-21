require.config( {
	//返回到html的上层目录./src
	baseUrl : '../',
	//成为index.js里的require路径
	//paths中声明模块
	paths   : {
		'knockout'       : 'bowerJs/knockout/knockout',
		'angular'        : 'bowerJs/angular/angular',
		'main-call'      : 'jsRequire/index/viewmodels/main_call',
		'main-viewmodel' : 'jsRequire/index/viewmodels/main_viewmodel',
		'app'            : 'js2Min/app'//用于放我们自己的业务代码app.js
	},
	//配置不兼容的模块
	//exports值（输出的变量名），表明这个模块外部调用时的名称；
	//deps数组，表明该模块的依赖性。
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
		//由于angularjs并不是按requirejs的模块方式组织代码的
		//Angularjs会在全局域中添加一个名为 angular 的变量
		//必须在 shim 中显式把它暴露出来，才能通过模块注入的方式使用它
		angular         : { exports : 'angular' }
	}
} );

