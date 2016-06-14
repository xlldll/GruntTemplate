###
  取得带后缀的文件名
  通过\来分割文件路径，返回各个数组
  取得最后一个数
###
getFileName = (o) ->
	url = o.split ( "\\" )
	urll = url.length - 1
	url[urll]
module.exports = (grunt) ->
	### 目录路径 ###
	dirs =
		destDir:'dest'
		srcDir :'src'
	[destJs, destCss,destImg,destFonts] = [dirs.destDir + '/js',
		dirs.destDir + '/css',
		dirs.destDir + '/img',
		dirs.destDir + '/fonts']
	[srcScss, srcCss,srcCssmin,scss2css,scss2cssmin] = [dirs.srcDir + '/scss',
		dirs.srcDir + '/css',
		dirs.srcDir + '/css/cssmin',
		dirs.srcDir + '/scss2css',
		dirs.srcDir + '/scss2css/cssmin',]
	[srcJs, srcJsCompress,srcImg,srcFonts] = [dirs.srcDir + '/js',
		dirs.srcDir + '/js/jsCompress',
		dirs.srcDir + '/img',
		dirs.srcDir + '/fonts']
	[coffeeJs, coffee2Js] = [dirs.srcDir + '/coffeeJs',
		dirs.srcDir + '/coffee2Js']

	### 任务配置 ###
	grunt.config.init(
		pkg     :grunt.file.readJSON ( 'package.json' )
		### 1.图片压缩和转移 ###
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
		### 2.scss编译 ###
		sass    :
			srcScss:
				options:
					style:'expanded'
				files  :[
					expand :true
					cwd    :srcScss
					src    :['**/*.scss']
					dest   :scss2css
					ext    :'.css'
					flatten:true
				]
		### 3.检查css  ###
		csslint :
			scss2css:
				options :
					csslintrc:'.csslintrc.json'
				checkCss:
					options:
						import:2
					src    :[scss2css+'/*.css']
		### 4.压缩css  ###
		cssmin  :
			css:
				files:[
					expand:true
					cwd   :srcCss
					src   :['*.css',
						'!**/*.min.css']
					dest  :srcCssmin
					ext   :'.min.css'
				]
			scss2css :
				files:[
					expand:true
					cwd   :scss2css
					src   :['*.css',
						'!**/*.map']
					dest  :scss2cssmin
					ext   :'.min.css'
				]
			cssimport :
				files:[
					expand:true
					cwd   :srcCss
					src   :['*.css',
						srcCssmin+'!*.min.css']
					dest  :srcCssmin
					ext   :'.min.css'
				]
		### 5.合并scss2cssmin中的所有的css到srcCssmin，叫做scss2cssConcat ###
		concat  :
			options    :
				separator   :'/*****************!CONCAT*******************/'
				stripBanners:true
				banner      :'/*! <%= pkg.name %> - v<%= pkg.version %> - ' +
					'<%= grunt.template.today("yyyy-mm-dd") %> */\n'
			scss2cssConcat:
				src :[scss2cssmin + '/*.css']
				dest:srcCssmin + '/scss2cssConcat.min.css'
		### 6.coffeeJs编译  ###
		coffee:
			coffeeJs:
				expand: true
				flatten: true
				cwd: coffeeJs
				src: ['*.coffee']
				dest: coffee2Js
				ext: '.js'
		### 7.JS检查  ###
		jshint  :
			options  :
				jshintrc:".jshintrc.json"
			coffee2Js       :[coffee2Js + "/{**/,!**/}*.js"]
			Gruntfile:["Gruntfile.js"]
		### 8.压缩srcJs和coffee2Js中的js到srcJsCompress ###
		uglify  :
			options   :
				stripBanners:true
				mangle      :false
				banner      :"/*! <%=pkg.name%>-<%=pkg.version%>.js <%= grunt.template.today('yyyy-mm-dd HH:MM') %> */\n"
			srcJs:
				files:[
					expand :true
					cwd    :srcJs,
					src    :'{**/,!**/}*.js'
					dest   :srcJsCompress
					ext    :'.min.js'
					flatten:true
				]
			coffee2Js:
				files:[
					expand :true
					cwd    :coffee2Js,
					src    :'{**/,!**/}*.js'
					dest   :srcJsCompress
					ext    :'.min.js'
					flatten:true
				]
		### 9.bower管理引入文件  ###
		bower   :
			install:
				options:
					targetDir     :srcJs
					layout        :'byComponent'
					install       :true
					verbose       :false
					cleanTargetDir:false
					cleanBowerDir :false
					bowerOptions  :{}
		### 10.转移开发文件到发布文件夹  ###
		copy    :
			### html、字体 ###
			main  :
				files:[
					{ expand:true, cwd:srcFonts, src:['*'], dest:destFonts, flatten:true, filter:'isFile' }
					{ expand:true, cwd:dirs.srcDir, src:['*.html'], dest:dirs.destDir, flatten:true, filter:'isFile' }
				]
			cssmin:
				files:[
					{ expand:true, cwd:srcCssmin, src:['*'], dest:destCss, flatten:true, filter:'isFile' }
				]
			srcJsCompress:
				files:[
					{ expand:true, cwd:srcJsCompress, src:['*'], dest:destJs, flatten:true, filter:'isFile' }
				]
		### 10.建立网站连接  ###
		connect :
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
					base   :[
						'./' + dirs.srcDir
					]
		### 11.文件历史缓存  ###
		newer   :
			options:cache:'newer/'
		### 12.监视  ###
		watch   :
			options   :dateFormat:(time) ->
						grunt.log.writeln('监视耗时 ' + time + '毫秒' + (new Date()).toString());
						grunt.log.writeln('等待更多变化...');
						return;
			### 1.gruntfile自动重新加载 ###
			configFiles:
				files: [ 'Gruntfile.js' ]
				options:reload: true
			### 2.个人scss ###
			scss2css  :
				files:[srcScss + '/**/*.scss']
				tasks:['newer:sass',
					'newer:cssmin:scss2css',
					'newer:concat:scss2cssConcat',
					'newer:copy:cssmin']
			### 3.外部引入css ###
			importCss  :
				files:[srcCss + '/{,**/}*.css',srcCssmin + ' /!*.min.css']
				tasks:[
					'newer:cssmin:cssimport',
					'newer:copy:cssmin']
			### 4.外部引入js ###
			sourceJs  :
				files:[srcJs + '/{,**/}*.js']
				tasks:['newer:uglify:srcJs','newer:copy:srcJsCompress']
			### 5.个人js ###
			cfeJs  :
				files:[coffeeJs + '/{,**/}*.coffee']
				tasks:['newer:coffee:coffeeJs','newer:uglify:coffee2Js','newer:copy:srcJsCompress']
			### 6.图片压缩 ###
			imgmin    :
				files  :[srcImg + '/**/*']
				tasks  :['newer:imagemin']
			### 7.实时修改 ###
			livereload:
				options:
					livereload:'<%=connect.options.livereload%>'
				files  :[
					'./' + dirs.srcDir + '/*.html',
					'./' + srcCssmin + '/{,**/}*.min.css',
					'./' + srcJs + '/{,**/}*.js',
					'./' + coffee2Js + '/{,**/}*.js',
					'./' + srcImg + '/{,**/}*.{png,jpg}'
				]
			### 8.转移其他文件###
			copyFile  :
				files:[srcFonts + '/*',dirs.srcDir+'/*.html']
				tasks:['newer:copy:main']

			###
			csscheck :
			files : [ '<%= personDir %>/gruntCss/!*.css','<%= personDir %>/css/!*.css' ]
			tasks : [ 'csslint' ]
			options :
				spawn : false
			miniCss :
			files : [ '<%= srcgruntCss %>/!*.css','<%= srcCss %>/!*.css' ]
			tasks : [ 'cssmin' ]
			options :
				spawn : false
			###

	)
	require('load-grunt-tasks')(grunt, {
		pattern:['grunt-*',
			'@*/grunt-*']
	})

	delFile = (deldir, files, srcdir) ->
		file = files.substring(srcdir.length);
		fileN = getFileName(files);
		if( files.substr(-2) == 'js' )
			minjsN = fileN + '.min.js';
			jsF = srcdir + file;
			minJs = deldir + minjsN;
			if( grunt.file.exists(jsF) )
				grunt.file.delete(jsF);
				grunt.file.delete(minJs);
				return false;
		else if( files.substr(-4) == 'scss' )
			cssFileN = fileN + '.css';
			cssFileM = fileN + '.css.map';
			cssFileMin = fileN + '.min.css';
			cssFile = scss2css + cssFileN;
			cssMap = scss2css + cssFileM;
			cssMin = scss2cssmin + cssFileMin;
			if( grunt.file.exists(cssFile) )
				grunt.file.delete(cssFile);
				grunt.file.delete(cssMap);
				grunt.file.delete(cssMin);
				return false;
		else if( files.substr(-3) == 'png' )
			pngFile = deldir + file;
			if( grunt.file.exists(pngFile) )
				grunt.file.delete(pngFile);
				return false;

	grunt.event.on('watch', (action, filepath, target) ->
		grunt.log.writeln(filepath + '文件已经' + action + '并触发了' + target + '任务');
		if( target == 'imgmin' )
			if( action == 'deleted' || action == 'renamed' )
				delFile(destImg, filepath, srcImg);
				if( action == 'deleted' )
					return false;
		else if( target == 'scss2css' )
			if( action == 'deleted' || action == 'renamed' )
				delFile(scss2css, filepath, srcScss);
				if( action == 'deleted' )
					return false;
		else if( target == 'js2minjs' )
			if( action == 'deleted' || action == 'renamed' )
				delFile(destJs, filepath, srcJsCompress);
				if( action == 'deleted' )
					return false;
	)

	grunt.registerTask('build', 'require demo', () ->
		tasks = ['requirejs'];
		srcDir = 'src';
		destDir = 'dest';
		grunt.config.set('config', {
			srcDir :srcDir,
			destDir:destDir
		});
		taskCfg = grunt.file.readJSON('requireJsCfg.json')
		options = taskCfg.requirejs.main.options
		platformCfg = options.web
		includes = platformCfg.include
		paths = options.paths
		pos = -1
		requireTask = taskCfg.requirejs
		options.path    = paths
		options.out     = platformCfg.out
		options.include = includes
		grunt.task.run(tasks)
		grunt.config.set("requirejs", requireTask)
	)
	grunt.registerTask('all',[ 'newer:sass','newer:cssmin','newer:coffee','newer:uglify','newer:concat','newer:copy','connect','watch' ]);
	return;