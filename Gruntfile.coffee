###
  取得带后缀的文件名
  通过\来分割文件路径，返回各个数组
  取得最后一个数组
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
	[srcScss, srcCss,srcCssmin,myCss,myCssmin] = [dirs.srcDir + '/scss',
		dirs.srcDir + '/css',
		dirs.srcDir + '/css/cssmin',
		dirs.srcDir + '/myCss',
		dirs.srcDir + '/myCss/cssmin',]
	[srcJs, srcJsCompress,srcImg,srcFonts] = [dirs.srcDir + '/js',
		dirs.srcDir + '/js/jsCompress',
		dirs.srcDir + '/img',
		dirs.srcDir + '/fonts']
	### 任务配置 ###
	grunt.config.init(
		pkg     :grunt.file.readJSON ( 'package.json' )
		imagemin:
			dynamic:
				options:
					optimizationLevel:3
				files  :[
					expand:true
					cwd   :srcImg
					src   :['**/*.{png,jpg,jpeg,gif}']
					dest  :destImg
				]
		sass    :
			srcScss:
				options:
					style:'expanded'
				files  :[
					expand :true
					cwd    :srcScss
					src    :['**/*.scss']
					dest   :myCss
					ext    :'.css'
					flatten:true
				]
		csslint :
			srcScss:
				options :
					csslintrc:'.csslintrc.json'
				checkCss:
					options:
						import:2
					src    :['<%= srcgruntCss %>/*.css']
		cssmin  :
			srcCss:
				files:[
					expand:true
					cwd   :srcCss
					src   :['*.css',
						'!**/*.min.css']
					dest  :srcCssmin
					ext   :'.min.css'
				]
			myCss :
				files:[
					expand:true
					cwd   :myCss
					src   :['*.css',
						'!**/*.map']
					dest  :myCssmin
					ext   :'.min.css'
				]
		concat  :
			options    :
				separator   :'/*****************!CONCAT*******************/'
				stripBanners:true
				banner      :'/*! <%= pkg.name %> - v<%= pkg.version %> - ' +
					'<%= grunt.template.today("yyyy-mm-dd") %> */\n'
			myCssConcat:
				src :[myCssmin + '/*.css']
				dest:srcCssmin + '/all.min.css'
		jshint  :
			options  :
				jshintrc:".jshintrc.json"
			js       :[srcJs + "/{**/,!**/}*.js"]
			Gruntfile:["Gruntfile.js"]
		uglify  :
			options   :
				stripBanners:true
				mangle      :false
				banner      :"/*! <%=pkg.name%>-<%=pkg.version%>.js <%= grunt.template.today('yyyy-mm-dd HH:MM') %> */\n"
			compressJS:
				files:[
					expand :true
					cwd    :srcJs,
					src    :'{**/,!**/}*.js'
					dest   :srcJsCompress
					ext    :'.js'
					flatten:true
				]
			minJS     :
				files:[
					expand:true
					cwd   :srcJsCompress
					src   :'{**/,!**/}*.js'
					dest  :destJs
					ext   :".min.js"
				]
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
		copy    :
			main  :
				files:[
					{ expand:true, cwd:srcFonts, src:['*'], dest:destFonts, flatten:true, filter:'isFile' }
					{ expand:true, cwd:dirs.srcDir, src:['*.html'], dest:dirs.destDir, flatten:true, filter:'isFile' }
					{ expand:true, cwd:srcImg, src:['*'], dest:destImg, flatten:true, filter:'isFile' }
				]
			cssmin:
				files:[
					{ expand:true, cwd:srcCssmin, src:['*'], dest:destCss, flatten:true, filter:'isFile' }
				]
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
		newer   :
			options:
				cache:'newer/cache/'
		watch   :
			options   :
					dateFormat:
						(time) ->
							grunt.log.writeln('监视耗时 ' + time + '毫秒，在' + (new Date()).toString());
							grunt.log.writeln('等待更多变化...');
							return;
			scss2css  :
				files:[srcScss + ' /{**/,!**/}*.scss']
				tasks:['newer:sass',
					'newer:cssmin:srcgruntCss',
					'newer:concat',
					'newer:copy:cssmin']
			js2minjs  :
				files:[srcJs + ' /{**/,!**/}*.js']
				tasks:['newer:uglify']
			imgmin    :
				files  :[srcImg + '/**/**/**/**/*']
				tasks  :['newer:imagemin']
				options:
					spawn:false
			livereload:
				options:
					livereload:'<%=connect.options.livereload%>'
				files  :[
					'./' + dirs.srcDir + '/!*.html'
					'./' + srcCss + '/{**!/,!**!/}*.css'
					'./' + srcScss + '/{**!/,!**!/}*.scss'
					'./' + srcJs + '/{**!/,!**!/}*.js'
					'./' + srcImg + '/{**!/,!**!/}*.{png,jpg}'
				]
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
			cssFile = myCss + cssFileN;
			cssMap = myCss + cssFileM;
			cssMin = myCssmin + cssFileMin;
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
				delFile(myCss, filepath, srcScss);
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

	grunt.registerTask('all', ['newer:sass',
		'newer:cssmin',
		'newer:uglify',
		'newer:concat',
		'newer:copy',
		'connect',
		'watch']);

	grunt.registerTask('sass', ['newer:sass',
		'newer:cssmin',
		'newer:concat:srcgruntCssmin',
		'newer:copy:cssmin',
		'watch:scss2css']);

	grunt.registerTask('js', ['newer:jshint',
		'newer:uglify',
		'watch:js2minjs']);

	return;