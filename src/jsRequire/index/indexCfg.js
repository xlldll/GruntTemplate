require.config( {
	//返回到html的上层目录./src
	baseUrl : '../',
	//成为index.js里的require路径
	paths   : {
		'knockout'  : 'bowerJs/knockout/knockout',
		'main-call'  : 'jsRequire/index/viewmodels/main_call',
		'main-viewmodel':'jsRequire/index/viewmodels/main_viewmodel'
	}
} );

