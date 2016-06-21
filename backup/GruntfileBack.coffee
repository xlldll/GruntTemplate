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
	[destJs,destCss,destImg,destFonts] = [dirs.destDir + '/js',
		dirs.destDir + '/css',
		dirs.destDir + '/img',
		dirs.destDir + '/fonts']
	[srcImg,srcImgMin,srcFonts] = [dirs.srcDir + '/img',
		dirs.srcDir + '/imgMin',
		dirs.srcDir + '/fonts']
	[srcCss, cssmin] = [dirs.srcDir + '/css',
		dirs.srcDir + '/cssmin',]
	[scss, scssmin] = [dirs.srcDir + '/scss',
		dirs.srcDir + '/scssmin',]
	[srcJs, jsmin] = [dirs.srcDir + '/js',
		dirs.srcDir + '/jsmin']
	[cfjs, cfjsmin] = [dirs.srcDir + '/cfjs',
		dirs.srcDir + '/cfjsmin']

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
			scss:
				options:
					style:'expanded'
				files  :[
					expand :true
					cwd    :scss
					src    :['**/*.scss']
					dest   :scss
					ext    :'.css'
					flatten:false
				]
		### 3.检查css  ###
		csslint :
			scss2css:
				options :
					csslintrc:'.csslintrc.json'
				checkCss:
					options:
						import:2
					src    :[scss+'**/*.css']
		### 4.压缩css  ###
		cssmin  :
			css:
				files:[
					expand:true
					cwd   :srcCss
					src   :['*.css']
					dest  :cssmin
					ext   :'.css'
				]
			scss:
				files:[
					expand:true
					cwd   :scss
					src   :['*.css','!**/*.map']
					dest  :scssmin
					ext   :'.css'
				]
		### 5.合并scss2cssmin中的所有的css到srcCssmin，叫做scss2cssConcat ###
		concat  :
			options    :
				separator   :'/*****************!CONCAT*******************/'
				stripBanners:true
				banner      :'/*! <%= pkg.name %> - v<%= pkg.version %> - ' +
					'<%= grunt.template.today("yyyy-mm-dd") %> */\n'
			cssCat:
				src :[cssmin + '/**/*.css']
				dest:destCss + '/srcAllCss.min.css'
			scssCat:
				src :[scssmin + '/**/*.css']
				dest:destCss + '/srcAllScss.min.css'
			jsCat:
				src :[jsmin + '/**/*.js']
				dest:destJs + '/srcAllJs.min.js'
			cfjsCat:
				src :[cfjsmin + '/**/*.js']
				dest:destJs + '/cfAllJs.min.js'
		### 6.cfjs编译  ###
		coffee:
			cfJs:
				expand: true
				flatten: true
				cwd: cfjs
				src: ['*.coffee']
				dest: cfjs
				ext: '.js'
		### 7.JS检查  ###
		jshint  :
			options  :
				jshintrc:".jshintrc.json"
			coffee2Js:[cfjs + "/{,**/}*.js"]
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
					src    :'{,**/}*.js'
					dest   :jsmin
					ext    :'.js'
					flatten:false
				]
			cfJs:
				files:[
					expand :true
					cwd    :cfjs,
					src    :'{,**/}*.js'
					dest   :cfjsmin
					ext    :'.js'
					flatten:false
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
					{ expand:true, cwd:dirs.srcDir, src:['*.html'], dest:dirs.destDir, flatten:true, filter:'isFile' }
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
		### 12.同步文件 ###
		sync      :
			imgs:
				files: [
					{ cwd: srcImg, src: ['**'], dest: destImg }
				]
				pretend: false
				verbose: true
				updateAndDelete: true
			fonts:
				files: [
					{ cwd: srcFonts, src: ['**'], dest: destFonts }
				]
				pretend: false
				verbose: true
				updateAndDelete: true
			css:
				files: [
					{ cwd: srcCss+'/', src: ['{,**/}*.css'], dest: cssmin }
				]
				pretend: false
				verbose: true
				updateAndDelete: true
			scss:
				files: [
					{ cwd: scss+'/', src: ['{,**/}*.css'], dest: scssmin }
				]
				pretend: false
				verbose: true
				updateAndDelete: true
			srcJs:
				files: [
					{ cwd: srcJs+'/', src: ['{,**/}*.js'], dest: jsmin }
				]
				pretend: false
				verbose: true
				updateAndDelete: true
			cfJs:
				files: [
					{ cwd: cfjs+'/', src: ['{,**/}*.js','!{,**/}*.coffee'], dest: cfjsmin }
				]
				pretend: false
				verbose: true
				updateAndDelete: true

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
			### 3.外部引入css ###
			css :
				files:[srcCss + '/{,**/}*.css']
				tasks:[
					'newer:cssmin:css',
					'sync:css',
					'concat:cssCat']
			### 2.个人scss ###
			scss  :
				files:[scss + '/{,**/}*.scss',scss + '/{,**/}*.css']
				tasks:['newer:sass:scss',
					'newer:cssmin:scss',
					'sync:scss',
					'concat:scssCat']
			### 4.外部引入js ###
			srcJs  :
				files:[srcJs + '/{,**/}*.js']
				tasks:['newer:uglify:srcJs','sync:srcJs','concat:jsCat']
			### 5.个人js ###
			cfJs     :
				files:[cfjs + '/{,**/}*.coffee',cfjs + '/{,**/}*.js']
				tasks:['newer:coffee:cfJs','newer:uglify:cfJs','sync:cfJs','concat:cfjsCat']
			### 6.图片压缩 ###
			imgmin    :
				files  :[srcImg + '/{,**/}*']
				tasks  :['newer:imagemin','sync:imgs']
			### 6.图片压缩 ###
			fonts    :
				files  :[srcFonts + '/{,**/}*']
				tasks  :['sync:fonts']
			### 7.实时修改 ###
			livereload:
				options:
					livereload:'<%=connect.options.livereload%>'
				files  :[
					'./' + dirs.srcDir + '/*.html',
					'./' + srcCss + '/{,**/}*.css',
					'./' + srcJs + '/{,**/}*.js',
					'./' + cfjs + '/{,**/}*.js',
					'./' + srcImg + '/{,**/}*.{png,jpg}'
				]
			### 8.转移其他文件###
			copyFile  :
				files:[dirs.srcDir+'/*.html']
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
			cssFile = srcCss + cssFileN;
			cssMap = srcCss + cssFileM;
			cssMin = srcCss + cssFileMin;
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

	###
	grunt.event.on('watch', (action, filepath, target) ->
		grunt.log.writeln(filepath + '文件已经' + action + '并触发了' + target + '任务');
	)
	###


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


	### 自定义requireJS任务 ###
	grunt.registerTask('reqJs', 'requireJS', (arg1) ->

		taskCfg = grunt.file.readJSON('rjsGrunt.json')
		requireTask = taskCfg.requirejs
		options = requireTask.main.options
		if (arguments.length == 0)
			platformCfg = options.web
		else
			platformCfg = options.arg1
		options.include = platformCfg.include
		options.name = platformCfg.name
		options.out = platformCfg.out
		options.paths = options.paths
		options.mainConfigFile = options.mainConfigFile
		grunt.config.set('requirejs', requireTask)
		tasks = ['requirejs'];
		grunt.task.run(tasks)
	)

	grunt.registerTask('all',[ 'newer:sass','newer:cssmin','newer:coffee','newer:uglify','newer:concat','newer:copy','connect','watch' ]);
	grunt.registerTask('sy', [ 'sync','watch']);
	grunt.registerTask('img', [ 'imagemin']);
	grunt.registerTask('jsss', [ 'newer:coffee','newer:uglify','watch']);
	grunt.registerTask('csss', [ 'newer:sass','newer:cssmin','watch']);
	return;