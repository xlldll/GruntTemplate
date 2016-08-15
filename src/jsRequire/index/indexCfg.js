requirejs.config( {
	//data-main已经指定了baseUrl：../jsRequire/index/
	//不过在有config的情况下，baseUrl以config配置的为准
	//如果没有显式指定config及data-main，则默认的baseUrl为包含RequireJS的那个HTML页面的所属目录。
	//By default load any module IDs from ../ 也就是index.html的上一层目录src
	baseUrl : '../',
	//paths中声明模块，路径相对于baseUrl即src
	paths   : {
		'knockout'       : 'bowerJs/knockout/knockout',
		'main-call'      : 'jsRequire/index/viewmodels/main_call',
		'main-viewmodel' : 'jsRequire/index/viewmodels/main_viewmodel',
		'angular'        : 'bowerJs/angular/angular',
		//用于放我们自己的业务代码app.js
		'app'            : 'js2Min/app'
	},
	//配置不兼容的模块
	//deps数组，表明该模块的依赖性
	//exports值（输出的变量名），表明这个模块外部调用时的名称
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
		//Angularjs会在全局域中添加一个名为angular的变量
		//必须在shim中显式把它暴露出来，才能通过模块注入的方式使用它
		angular         : { exports : 'angular' }
	}
} );

