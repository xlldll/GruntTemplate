module.exports = (grunt) ->
	### 开发目录与发布目录 ###
	dirs =
		destDir:'dest'
		srcDir :'src'
	### 发布目录文件夹 ###
	[destHtml,destJs,destCss,destImg,destFonts] = [
		dirs.destDir + '/html',
		dirs.destDir + '/js',
		dirs.destDir + '/css',
		dirs.destDir + '/img',
		dirs.destDir + '/fonts'
	]
	[destCssMin,destCssMult,destJsMin,destJsMult] = [
		destCss + '/css2MinSync',
		destCss + '/css2MultSync',
		destCss + '/js2MinSync',
		destCss + '/js2MultSync'
	]

	### 开发主页、图片、格式 ###
	[srcHtml,srcImg,srcImgMin,srcFonts] = [
		dirs.srcDir + '/html',
		dirs.srcDir + '/img',
		dirs.srcDir + '/imgMin',
		dirs.srcDir + '/fonts'
	]

	### 一一按目录压缩Css ###
	[css2Min, css2MinSync] = [
		dirs.srcDir + '/css2Min',
		dirs.srcDir + '/css2MinSync'
	]
	### 多合一Css ###
	[css2Mult, css2MultSync] = [
		dirs.srcDir + '/css2Mult',
		dirs.srcDir + '/css2MultSync'
	]
	### bower ###
	[bower, bowerJs,bowerCss,bowerImg] = [
		dirs.srcDir + '/bower',
		dirs.srcDir + '/bowerJs',
		dirs.srcDir + '/bowerCss',
		dirs.srcDir + '/bowerImg'
	]
	### requireJs指定引用合并 ###
	[jsRequire] = [
		dirs.srcDir + '/jsRequire'
	]
	### 一一按目录压缩JS ###
	[js2Min, js2MinSync] = [
		dirs.srcDir + '/js2Min',
		dirs.srcDir + '/js2MinSync'
	]
	### 多合一Js ###
	[js2Mult, js2MultSync] = [
		dirs.srcDir + '/js2Mult',
		dirs.srcDir + '/js2MultSync'
	]

	### 任务配置 ###
	grunt.config.init(
		pkg     :grunt.file.readJSON ( 'package.json' )
		### 1.图片压缩到发布目录 ###
		imagemin:
			srcImg:
				options:
					optimizationLevel:3
				files  :[
					expand:true
					cwd   :srcImg
					src   :['**/*.{png,jpg,jpeg,gif}']
					dest  :destImg
				]
		htmlmin :
			html:
				options:
					removeComments    :true
					collapseWhitespace:true
				files  :[
					expand:true
					cwd   :srcHtml
					src   :['**/*.html']
					dest  :destHtml
				]
		### 2.SCSS本地编译 ###
		sass    :
			css2Min:
				options:
					style:'expanded'
				files  :[
					expand :true
					cwd    :css2Min
					src    :['**/*.scss']
					dest   :css2Min
					ext    :'.css'
					flatten:false
				]
			css2Mult:
				options:
					style:'expanded'
				files  :[
					expand :true
					cwd    :css2Mult
					src    :['**/*.scss']
					dest   :css2Mult
					ext    :'.css'
					flatten:false
				]
			bowerCss:
				options:
					style:'expanded'
				files  :[
					expand :true
					cwd    :bower
					src    :['**/*.scss']
					dest   :bower
					ext    :'.css'
					flatten:false
				]
		### 3.CSS格式检查  ###
		csslint :
			css:
				options :
					csslintrc:'.csslintrc.json'
				checkCss:
					options:
						import:2
					src    :[
						css2Mult + '*{,**/}*.css',
						css2Min + '{,**/}*.css'
					]
		### 4.CSS本地压缩  ###
		cssmin  :
			options:
				shorthandCompacting: false
				roundingPrecision: -1

			css2MinSync:
				files:[{
					expand:true
					cwd   :css2MinSync
					src   :[
						'**/*.css',
						'!**/*.map'
					]
					dest  :destCssMin
					ext   :'.css'
				}]
			css2MultSync :
				files:'dest/css/css2MultSync/css2MultSync.min.css': [css2MultSync + '/{,**/}*.css']
		### 5.单纯拼接合并CSS以及JS到发布目录，并没有压缩处理效果 ###
		concat  :
			options:
				separator   :'/*****************!CONCAT*******************/'
				stripBanners:true
				banner      :'/*! <%= pkg.name %> - v<%= pkg.version %> - ' +
					'<%= grunt.template.today("yyyy-mm-dd") %> */\n'
		### 6.js2Mult本地编译  ###
		### 注意src的斜杠格式 ###
		coffee  :
			js2Min :
				expand :true
				flatten:false
				cwd    :js2Min
				src    :['{,**/}*.coffee']
				dest   :js2Min
				ext    :'.js'
			js2Mult:
				expand :true
				flatten:false
				cwd    :js2Mult
				src    :['{,**/}*.coffee']
				dest   :js2Mult
				ext    :'.js'
		### 7.JS检查  ###
		jshint  :
			options  :
				jshintrc:'.jshintrc.json'
			coffee2Js:[
				js2Min + '{,**/}*.js',
				js2Mult + '{,**/}*.js'
			]
			Gruntfile:['Gruntfile.js']
		### 8.JS压缩 ###
		uglify  :
			options :
				banner          :"/*! <%=pkg.name%>-<%=pkg.version%>.js 压缩于：<%= grunt.template.today('yyyy-mm-dd HH:MM') %> */\n"
				footer          :'\n/*! <%= pkg.name %> 最后修改于： <%= grunt.template.today("yyyy-mm-dd") %> */'
				preserveComments:true
			### 按原目录下的每个文件结构压缩至新文件夹中 ###
			js2MinSync:
				options:
					mangle:true
					report:"gzip"
				files  :[
					expand :true
					cwd    :js2MinSync,
					src    :'{,**/}*.js'
					dest   :destJsMin
					ext    :'.js'
					flatten:false
				]
			### 多合一JS压缩 ###
			js2MultSync :
				options:
					mangle:true
				files  :
					'dest/js/js2MultSync/js2MultSync.min.js':[js2MultSync + '/{,**/}*.js']
		### 8.清除文件夹 ###
		clean: {
			js2MinSync: [destJsMin],
			css2MinSync: [destCssMin],
			folder_v2: ['path/to/dir/**'],
			contents: ['path/to/dir/*'],
			subfolders: ['path/to/dir/*/'],
			css: ['path/to/dir/*.css'],
			all_css: ['path/to/dir/**/*.css']
		}
		### requireJs合并兼压缩 ###
        ### index.js里的require(indexCfg)路径由paths告知 ###
		requirejs:
			index:
				options:
					baseUrl       :'./' + dirs.srcDir
					paths         :
						'indexCfg'     :'jsRequire/index/indexCfg'
						'main-call'     :'jsRequire/index/viewmodels/main_call'
						'main-viewmodel':'jsRequire/index/viewmodels/main_viewmodel'
					### 公共JS路径设置 ###
					mainConfigFile:'rjsGrunt.js'
					name          :'jsRequire/index/index'
					include       :[
						'requireJs',
						'knockout',
						'main-call',
						'main-viewmodel'
					]
					out           :destJs + '/requireJs.js'
					uglify2       :
						output  :
							beautify:false
						compress:
							sequences  :false
							global_defs:
								DEBUG:false
						warnings:true
						mangle  :true
					
		### 9.Bower管理引入文件  ###
		bower    :
			install:
				options:
					targetDir     :'./src/bower'
					layout        :'byType',
					install       :true
					verbose       :false
					cleanTargetDir:true
					cleanBowerDir :false
					bowerOptions  :{}
		### 10.转移开发文件到发布文件夹  ###
		copy     :
			### html、字体 ###
			main:
				files:[
					{ expand:true, cwd:dirs.srcDir, src:['*.html'], dest:dirs.destDir, flatten:true, filter:'isFile' }
				]
		### 11.建立网站连接  ###
		connect  :
			options:
				open      :
					target  :'http://127.0.0.1:9080'
					appName :'chrome'
					callback:()->
				port      :9080
				hostname  :'127.0.0.1'
				livereload:35729
			server :
				options:
					open:true
					base:[
						'./' + srcHtml
					]
		### 12.文件历史缓存  ###
		newer    :
			options:
				cache:'newer/'
		### 13.同步开发文件的删除添加重命名 ###
		sync     :
			htmls:
				files          :[
					{ cwd:srcHtml, src:['{,**/}*.html'], dest:destHtml }
				]
				pretend        :false
				verbose        :true
				updateAndDelete:true
			imgs :
				files          :[
					{ cwd:srcImg, src:['**'], dest:destImg }
				]
				pretend        :false
				verbose        :true
				updateAndDelete:true
			fonts:
				files          :[
					{ cwd:srcFonts, src:['**'], dest:destFonts }
				]
				pretend        :false
				verbose        :true
				updateAndDelete:true
			css2MinSync:
				files:[
					{
						cwd :css2Min,
						src :[
							'{,**/}*.css',
							'!{,**/}*.map'
						]
						dest:css2MinSync
					}
				]
				pretend        :false
				verbose        :true
				updateAndDelete:true
			css2MultSync:
				files:[
					{
						cwd :css2Mult,
						src :[
							'{,**/}*.css',
							'!{,**/}*.map'
						]
						dest:css2MultSync
					}
				]
				pretend        :false
				verbose        :true
				updateAndDelete:true
			js2MinSync:
				files:[
					{
						cwd :js2Min
						src :[
							'{,**/}*.js',
							'!{,**/}*.coffee'
						]
						dest:js2MinSync
					}
				]
				pretend        :false
				verbose        :true
				updateAndDelete:true
			js2MultSync:
				files:[
					{
						cwd :js2Mult,
						src :[
							'{,**/}*.js',
							'!{,**/}*.coffee'
						]
						dest:js2MultSync
					}
				]
				pretend        :false
				verbose        :true
				updateAndDelete:true
			bowerJs:
				files:[
					{
						cwd :bower,
						src :[
							'{,**/}*.js',
							'!{,**/}*.coffee'
						]
						dest:bowerJs
					}
				]
				pretend        :false
				verbose        :true
				updateAndDelete:true
		### 14.监视变动  ###
		watch   :
			options   :dateFormat:(time) ->
						grunt.log.writeln('监视耗时 ' + time + '毫秒' + (new Date()).toString());
						grunt.log.writeln('等待更多变化...');
						return;
			### 1.gruntfile自动重新加载 ###
			configFiles:
				files: [ 'Gruntfile.js' ]
				options:reload: true
			### 2.多合一CSS ###
			css2Mult:
				files:[css2Mult + '/{,**/}*.{css,scss,map}']
				tasks:[
					'newer:sass:css2Mult',
					'sync:css2MultSync',
					'newer:cssmin:css2MultSync'
				]
			### 3.一一压缩css ###
			css2Min:
				files:[css2Min + '/{,**/}*.{css,scss,map}']
				tasks:[
					'newer:sass:css2Min',
					'sync:css2MinSync',
					'clean:css2MinSync',
					'newer:cssmin:css2MinSync'
				]
			### 4.一一压缩JS ###
			js2Min:
				files:[js2Min + '/{,**/}*.{coffee,js}']
				tasks:[
					'newer:coffee:js2Min',
					'sync:js2MinSync',
					'clean:js2MinSync',
					'newer:uglify:js2MinSync'
				]

			### 5.多合一Js ###
			### 编译coffeeJs，同步到cf2Mult文件夹，多合一压缩到发布目录 ###
			js2Mult:
				files:[js2Mult + '/{,**/}*.{coffee,js}']
				tasks:[
					'newer:coffee:js2Mult',
					'sync:js2MultSync',
					'newer:uglify:js2MultSync'
				]

			### 6.图片压缩 ###
			imgmin :
				files:[srcImg + '/{,**/}*']
				tasks:['newer:imagemin',
					'sync:imgs']
			htmlmin:
				files:[srcHtml + '/{,**/}*']
				tasks:['newer:htmlmin',
					'sync:htmls']
			### 7.格式文件 ###
			fonts:
				files:[srcFonts + '/{,**/}*']
				tasks:['sync:fonts']
			### 8.实时修改 ###
			livereload:
				options:
					livereload:'<%=connect.options.livereload%>'
				files  :[
					'./' + srcHtml + '/{,**/}*.html',
					'./' + css2Min + '/{,**/}*.css',
					'./' + js2Min + '/{,**/}*.js',
					'./' + js2Mult + '/{,**/}*.js',
					'./' + srcImg + '/{,**/}*.{png,jpg}'
				]
			### 10.bower ###
			bower:
				files:[bower + '/{,**/}*']
				tasks:[
					'sync:bowerJs'
				]
	)
	require('load-grunt-tasks')(grunt, {
		pattern:['grunt-*',
			'@*/grunt-*']
	})

	### 所有 ###
	grunt.registerTask('all',[ 'newer:sass','newer:cssmin','newer:coffee','newer:uglify','newer:concat','newer:copy','connect','watch' ]);

	### JS ###
	grunt.registerTask('jsss', [ 'newer:coffee','newer:uglify','watch:js2Mult']);
	### CSS ###
	grunt.registerTask('csss', [ 'newer:sass','newer:cssmin','watch']);
	### 检查格式 ###
	grunt.registerTask('chkCSS', [ 'csslint']);
	grunt.registerTask('chkJS', [ 'jshint']);
	### 实时修改 ###
	grunt.registerTask('live', [ 'connect','watch']);
	### 文件压缩 ###
	grunt.registerTask('minify', [ 'imagemin','cssmin','uglify','htmlmin']);
	### 文件合并 ###
	grunt.registerTask('cat', [ 'concat']);
	### 引入文件 ###
	grunt.registerTask('bowerFile', [ 'bower:install','sync:bowerJs','watch:bower']);
	### requireJs ###
	grunt.registerTask('rjs', [ 'bower:install','sync:bowerJs','watch:bower']);

	return;