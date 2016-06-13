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
		csslint :
			scss2css:
				options :
					csslintrc:'.csslintrc.json'
				checkCss:
					options:
						import:2
					src    :[scss2css+'/*.css']
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
		### 合并scss2cssmin中的所有的css到srcCssmin，叫做scss2cssConcat ###
		concat  :
			options    :
				separator   :'/*****************!CONCAT*******************/'
				stripBanners:true
				banner      :'/*! <%= pkg.name %> - v<%= pkg.version %> - ' +
					'<%= grunt.template.today("yyyy-mm-dd") %> */\n'
			scss2cssConcat:
				src :[scss2cssmin + '/*.css']
				dest:srcCssmin + '/scss2cssConcat.min.css'
		coffee:
			coffeeJs:
				expand: true
				flatten: true
				cwd: coffeeJs
				src: ['*.coffee']
				dest: coffee2Js
				ext: '.js'
		jshint  :
			options  :
				jshintrc:".jshintrc.json"
			coffee2Js       :[coffee2Js + "/{**/,!**/}*.js"]
			Gruntfile:["Gruntfile.js"]
		### 压缩srcJs和coffee2Js中的js到srcJsCompress ###
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
			scss2cssmin:
				files:[
					{ expand:true, cwd:scss2cssmin, src:['*'], dest:destCss, flatten:true, filter:'isFile' }
				]
			srcJsCompress:
				files:[
					{ expand:true, cwd:srcJsCompress, src:['*'], dest:destJs, flatten:true, filter:'isFile' }
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
			options:cache:'newer/'
		watch   :
			imgmin    :
				files  :[srcImg + '/**/*']
				tasks  :['imagemin']
	)
	require('load-grunt-tasks')(grunt, {
		pattern:['grunt-*',
			'@*/grunt-*']
	})
	grunt.registerTask( 'we',['watch'] );
	return;