
module.exports = (grunt) ->
	### 开发目录与发布目录 ###
	dirs =
		destDir:'dest'
		srcDir :'src'
	### 发布目录文件夹 ###
	[destJs,destCss,destImg,destFonts] = [dirs.destDir + '/js',
		dirs.destDir + '/css',
		dirs.destDir + '/img',
		dirs.destDir + '/fonts']
	### 开发图片、格式 ###
	[srcImg,srcImgMin,srcFonts] = [dirs.srcDir + '/img',
		dirs.srcDir + '/imgMin',
		dirs.srcDir + '/fonts']
	### 开发CSS ###
	[srcCss, cssmin] = [dirs.srcDir + '/css',
		dirs.srcDir + '/cssmin',]
	### 开发SCSS ###
	[scss, scssmin] = [dirs.srcDir + '/scss',
		dirs.srcDir + '/scssmin',]
	### 开发JS ###
	[srcJs, jsmin] = [dirs.srcDir + '/js',
		dirs.srcDir + '/jsmin']
	### 开发CoffeeJs ###
	[cfjs, cfjsmin] = [dirs.srcDir + '/cfjs',
		dirs.srcDir + '/cfjsmin']

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
		### 2.SCSS本地编译 ###
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
		### 3.CSS格式检查  ###
		csslint :
			scss2css:
				options :
					csslintrc:'.csslintrc.json'
				checkCss:
					options:
						import:2
					src    :[scss+'**/*.css']
		### 4.CSS本地压缩  ###
		cssmin  :
			css:
				files:[
					expand:true
					cwd   :srcCss
					src   :['**/*.css']
					dest  :cssmin
					ext   :'.css'
				]
			scss:
				files:[
					expand:true
					cwd   :scss
					src   :['**/*.css','!**/*.map']
					dest  :scssmin
					ext   :'.css'
				]
		### 5.合并压缩的CSS以及JS到发布目录 ###
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
		### 6.cfjs本地编译  ###
		### 注意src的斜杠格式 ###
		coffee:
			cfJs:
				expand: true
				flatten: false
				cwd: cfjs
				src: ['{,**/}*.coffee']
				dest: cfjs
				ext: '.js'
		### 7.JS检查  ###
		jshint  :
			options  :
				jshintrc:".jshintrc.json"
			coffee2Js:[cfjs + "{,**/}*.js"]
			Gruntfile:["Gruntfile.js"]
		### 8.JS压缩 ###
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
		### 9.Bower管理引入文件  ###
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
		### 11.建立网站连接  ###
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
		### 12.文件历史缓存  ###
		newer   :
			options:cache:'newer/'
		### 13.同步开发文件的删除添加重命名 ###
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
					{ cwd: srcCss, src: ['{,**/}*.css'], dest: cssmin }
				]
				pretend: false
				verbose: true
				updateAndDelete: true
			scss:
				files: [
					{ cwd: scss, src: ['{,**/}*.css'], dest: scssmin }
				]
				pretend: false
				verbose: true
				updateAndDelete: true
			srcJs:
				files: [
					{ cwd: srcJs, src: ['{,**/}*.js'], dest: jsmin }
				]
				pretend: false
				verbose: true
				updateAndDelete: true
			cfJs:
				files: [
					{ cwd: cfjs, src: ['{,**/}*.js','!{,**/}*.coffee'], dest: cfjsmin }
				]
				pretend: false
				verbose: true
				updateAndDelete: true

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
			### 2.公共CSS ###
			css :
				files:[srcCss + '/{,**/}*.css']
				tasks:[
					'newer:cssmin:css',
					'sync:css',
					'concat:cssCat']
			### 3.个人SCSSs ###
			scss  :
				files:[scss + '/{,**/}*.scss',scss + '/{,**/}*.css']
				tasks:['newer:sass:scss',
					'newer:cssmin:scss',
					'sync:scss',
					'concat:scssCat']
			### 4.公共JS ###
			srcJs  :
				files:[srcJs + '/{,**/}*.js']
				tasks:['newer:uglify:srcJs','sync:srcJs','concat:jsCat']
			### 5.个人JS ###
			cfJs     :
				files:[cfjs + '/{,**/}*.coffee',cfjs + '/{,**/}*.js']
				tasks:['newer:coffee:cfJs','newer:uglify:cfJs','sync:cfJs','concat:cfjsCat']
			### 6.图片压缩 ###
			imgmin    :
				files  :[srcImg + '/{,**/}*']
				tasks  :['newer:imagemin','sync:imgs']
			### 7.格式文件 ###
			fonts    :
				files  :[srcFonts + '/{,**/}*']
				tasks  :['sync:fonts']
			### 8.实时修改 ###
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
			### 9.HTML文件 ###
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

	### 所有 ###
	grunt.registerTask('all',[ 'newer:sass','newer:cssmin','newer:coffee','newer:uglify','newer:concat','newer:copy','connect','watch' ]);
	### 图片 ###
	grunt.registerTask('img', [ 'imagemin']);
	### JS ###
	grunt.registerTask('jsss', [ 'newer:coffee','newer:uglify','watch']);
	### CSS ###
	grunt.registerTask('csss', [ 'newer:sass','newer:cssmin','watch']);
	return;