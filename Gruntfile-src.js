module.exports = function ( grunt ) {
	//路径
	var dirs           = {
		    destDir : 'dest',
		    srcDir  : 'src'
	    },
	    //发布路径
	    destJs         = dirs.destDir + '/js',
	    destCss        = dirs.destDir + '/css',
	    destImg        = dirs.destDir + '/img',
	    destFonts      = dirs.destDir + '/fonts',
	    //生产路径
	    srcScss        = dirs.srcDir + '/scss',
	    srcCss         = dirs.srcDir + '/css',
	    srcCssmin      = dirs.srcDir + '/css/cssmin',
	    srcgruntCss    = dirs.srcDir + '/gruntCss',
	    srcgruntCssmin = dirs.srcDir + '/gruntCss/cssmin',
	    srcJs          = dirs.srcDir + '/js',
	    srcJsCompress  = dirs.srcDir + '/js/jsCompress',
	    srcImg         = dirs.srcDir + '/img',
	    srcFonts       = dirs.srcDir + '/fonts';
	grunt.config.init ( {
		pkg      : grunt.file.readJSON ( 'package.json' ),
		//IMAGE
		imagemin : {
			/* 压缩图片大小 */
			dynamic : {
				options : {
					optimizationLevel : 3 //定义 PNG 图片优化水平
				},
				files   : [ {
					expand : true,
					cwd    : srcImg,
					src    : [ '**/*.{png,jpg,jpeg,gif}' ], // 优化 img 目录下所有 png/jpg/jpeg/gif图片
					dest   : destImg  // 优化后的图片保存位置，覆盖旧图片，并且不作提示
				} ]
			}
		},
		//CSS
		sass     : {
			srcScss : {
				files   : [ {
					expand  : true,
					cwd     : srcScss,
					src     : [ '**/*.scss' ],
					dest    : srcgruntCss,
					ext     : '.css',
					flatten : true
				} ],
				options : {
					style : 'expanded'
				}
			}
		},
		csslint : {
		 options  : {
		 csslintrc : '.csslintrc.json'
		 },
		 checkCss : {
		 options : {
		 import : 2
		 },
		 src : [ '<%= srcgruntCss %>/*.css' ]
		 }
		 },
		cssmin   : {
			srcCss      : {
				files : [ {
					expand : true,
					cwd    : srcCss,
					src    : [ '*.css','!**/*.min.css' ],
					dest   : srcCssmin,
					ext    : '.min.css'
				} ]
			},
			srcgruntCss : {
				files : [ {
					expand : true,
					cwd    : srcgruntCss,
					src    : [ '*.css','!**/*.map' ],
					dest   : srcgruntCssmin,
					ext    : '.min.css'
				} ]
			}
		},
		//合并已压缩好min.css文件，要分别指定
		concat   : {
			options        : {
				separator    : '/*****************!CONCAT*******************/',
				stripBanners : true,
				banner       : '/*! <%= pkg.name %> - v<%= pkg.version %> - ' +
				               '<%= grunt.template.today("yyyy-mm-dd") %> */\n'
			},
			srcgruntCssmin : {
				src  : [ srcgruntCssmin + '/hover.min.css',srcgruntCssmin + '/Nav1.min.css',srcgruntCssmin + ' /1.min.css' ],
				dest : srcCssmin + '/all.min.css'
			}
		},
		//JS
		jshint   : {
			options   : {
				jshintrc : ".jshintrc.json"
			},
			js        : [ srcJs + "/{**/,!**/}*.js" ],
			Gruntfile : [ "Gruntfile.js" ]
		},
		//先压缩js后优化成min.js
		uglify   : {
			options    : {
				stripBanners : true,
				mangle       : false,
				banner       : "/*! <%=pkg.name%>-<%=pkg.version%>.js <%= grunt.template.today('yyyy-mm-dd HH:MM') %> */\n"
			},
			compressJS : {
				files : [ {
					expand  : true,
					cwd     : srcJs,
					src     : '{**/,!**/}*.js',
					dest    : srcJsCompress,
					ext     : '.js',
					flatten : true
				} ]
			},
			minJS      : {
				files : [ {
					expand : true,
					cwd    : srcJsCompress,
					src    : '{**/,!**/}*.js',
					dest   : destJs,
					ext    : ".min.js"
				} ]
			}
		},
		//按照组件安装jquery，angular等等
		bower    : {
			install : {
				options : {
					targetDir      : srcJs,
					layout         : 'byComponent',
					install        : true,
					verbose        : false,
					cleanTargetDir : false,
					cleanBowerDir  : false,
					bowerOptions   : {}
				}
			}
		},
		//拷贝范围文件到指定目录
		copy     : {
			main   : {
				files : [
					{ expand : true,cwd : srcFonts,src : [ '*' ],dest : destFonts,flatten : true,filter : 'isFile' },
					{ expand : true,cwd : dirs.srcDir,src : [ '*.html' ],dest : dirs.destDir,flatten : true,filter : 'isFile' },
					{ expand : true,cwd : srcImg,src : [ '*' ],dest : destImg,flatten : true,filter : 'isFile' }
				]
			},
			cssmin : {
				files : [
					//将src/css/cssmin/目录下的所有文件都复制到dest/css目录下publicDir
					{ expand : true,cwd : srcCssmin,src : [ '*' ],dest : destCss,flatten : true,filter : 'isFile' }
				]
			}
		},
		//建立服务器
		connect  : {
			options : {
				open       : {
					target   : 'http://127.0.0.1:9080', // target url to open
					appName  : 'chrome', // name of the app that opens, ie: open, start, xdg-open
					callback : function () {} // called when the app has opened
				},
				port       : 9080,
				hostname   : '127.0.0.1', //默认就是这个值，可配置为本机某个 IP，localhost 或域名
				livereload : 35729  //声明给 watch 监听的端口
			},
			server  : {
				options : {
					open : true, //自动打开网页 http://
					base : [
						'./' + dirs.srcDir   //主目录
					]
				}
			}
		},
		//更新
		newer    : {
			options : {
				cache : 'newer/cache/'
			}
		},
		watch    : {
			options     : {
				dateFormat : function ( time ) {
					grunt.log.writeln ( '监视耗时 ' + time + '毫秒，在' + (new Date ()).toString () );
					grunt.log.writeln ( '等待更多变化...' );
				}
			},
			/*configFiles : {
				files   : [ 'Gruntfile.js','config/!*.js' ],
				options : {
					reload : false
				}
			},*/
			scss2css    : {
				files : [ srcScss + ' /{**/,!**/}*.scss' ],
				tasks : [ 'newer:sass','newer:cssmin:srcgruntCss','newer:concat','newer:copy:cssmin' ]
			},
			/*csscheck : {
			 files : [ '<%= personDir %>/gruntCss/!*.css','<%= personDir %>/css/!*.css' ],
			 tasks : [ 'csslint' ],
			 options : {
			 spawn : false
			 }
			 },*/
			/*miniCss : {
			 files : [ '<%= srcgruntCss %>/!*.css','<%= srcCss %>/!*.css' ],
			 tasks : [ 'cssmin' ],
			 options : {
			 spawn : false
			 }
			 },*/
			js2minjs    : {
				files : [ srcJs + ' /{**/,!**/}*.js' ],
				tasks : [ 'newer:uglify']
			},
			imgmin      : {
				files   : [ srcImg + '/**/**/**/**/*' ],
				//files   : [ srcImg + '/{**/,!**/}*.{png,jpg,jpeg,gif}' ],
				//files   : [ srcImg + '/**/*' ],
				tasks   : [ 'newer:imagemin' ],
				options : {
					spawn : false
				}
			}
			//实时修改
			/*livereload  : {
				options : {
					//监听前面声明的端口  35729
					livereload : '<%=connect.options.livereload%>'
				},
				files   : [
					'./' + dirs.srcDir + '/!*.html',
					'./' + srcCss + '/{**!/,!**!/}*.css',
					'./' + srcScss + '/{**!/,!**!/}*.scss',
					'./' + srcJs + '/{**!/,!**!/}*.js',
					'./' + srcImg + '/{**!/,!**!/}*.{png,jpg}'
				]
			}*/
		}
	} );
	// load all grunt tasks matching the ['grunt-*', '@*/grunt-*'] patterns
	require ( 'load-grunt-tasks' ) ( grunt,{ pattern : [ 'grunt-*','@*/grunt-*' ] } );
	var delFile;
	//'dist/js/'=deldir
	//'src/js/*.js'=files 控制台中变动事件的路径
	//'src/js/'=srcdir
	delFile = function ( deldir,files,srcdir ) {
		//fileName.js
		var file = files.substring ( srcdir.length );
		//fileName
		//var fileN = getFileName ( file );
		var fileN = getFileName ( files );
		//删除源JS的时候，删除发布路径中的minjs以及原路径中的jsCompress
		if ( files.substr ( -2 ) === 'js' ) {
			//*.min.js
			var minjsN = fileN + '.min.js';
			var jsF,minJs;
			jsF = srcdir + file;
			minJs = deldir + minjsN;
			if ( grunt.file.exists ( jsF ) ) {
				grunt.file.delete ( jsF );
				grunt.file.delete ( minJs );
				return false;
			}
			//删除源scss的时候，删除发布路径中的csss以及mincss
		} else if ( files.substr ( -4 ) === 'scss' ) {
			var cssFileN = fileN + '.css';
			var cssFileM = fileN + '.css.map';
			var cssFileMin = fileN + '.min.css';
			var cssFile,cssMap,cssMin;
			//dist/css/*.css
			cssFile = srcgruntCss + cssFileN;
			//dist/css/*.css.map
			cssMap = srcgruntCss + cssFileM;
			//dist/css/cssmin/*.min.css
			cssMin = srcgruntCssmin + cssFileMin;
			if ( grunt.file.exists ( cssFile ) ) {
				grunt.file.delete ( cssFile );
				grunt.file.delete ( cssMap );
				grunt.file.delete ( cssMin );
				return false;
			}
		} else if ( files.substr ( -3 ) === 'png' ) {
			var pngFile;
			//dest/img/*.png
			pngFile = deldir + file;
			if ( grunt.file.exists ( pngFile ) ) {
				grunt.file.delete ( pngFile );
				return false;
			}
		}
	};
	grunt.event.on ( 'watch',function ( action,filepath,target ) {
		grunt.log.writeln ( filepath + '文件已经' + action + '并触发了' + target + '任务' );
		//src\img\logo-transparen4t.png文件已经deleted并触发了livereload任务
		//grunt.log.writeln(filepath.substr(-2));
		if ( target === 'imgmin' ) {
			if ( action === 'deleted' || action === 'renamed' ) {
				delFile ( destImg,filepath,srcImg );
				if ( action === 'deleted' ) {
					return false;
				}
			}
		} else if ( target === 'scss2css' ) {
			//filepath=src/sass/*.scss
			if ( action === 'deleted' || action === 'renamed' ) {
				//删除dist/sass/*.scss
				delFile ( srcgruntCss,filepath,srcScss );
				//删除的话则
				if ( action === 'deleted' ) {
					return false;
				}
			}
		} else if ( target === 'js2minjs' ) {
			if ( action === 'deleted' || action === 'renamed' ) {
				delFile ( destJs,filepath,srcJsCompress );
				if ( action === 'deleted' ) {
					return false;
				}
			}
		}
	} );
	//grunt.registerTask ( 'default',[ 'sass','csslint','cssmin','concat','copy','connect','watch' ] );
	//自定义任务-打包发布合并JS文件为一个
	grunt.registerTask ( 'build','require demo',function () {
		//任务列表
		var tasks = [ 'requirejs' ];
		//源码文件
		var srcDir = 'src';
		//目标文件
		var destDir = 'dest';
		//设置参数
		grunt.config.set ( 'config',{
			srcDir  : srcDir,
			destDir : destDir
		} );
		//设置requireJs的信息
		var taskCfg = grunt.file.readJSON ( 'requireJsCfg.json' );
		var options     = taskCfg.requirejs.main.options,
		    platformCfg = options.web,
		    includes    = platformCfg.include,
		    paths       = options.paths;
		var pos = -1;
		var requireTask = taskCfg.requirejs;
		options.path = paths;
		options.out = platformCfg.out;
		options.include = includes;
		//运行任务
		grunt.task.run ( tasks );
		grunt.config.set ( "requirejs",requireTask );
	} );
	//'all'
	grunt.registerTask ( 'all',[ 'newer:sass','newer:cssmin','newer:uglify','newer:concat','newer:copy','connect','watch' ] );
	//sass
	grunt.registerTask ( 'sass',[ 'newer:sass','newer:cssmin','newer:concat:srcgruntCssmin','newer:copy:cssmin','watch:scss2css' ] );
	//js
	grunt.registerTask ( 'js',[ 'newer:jshint','newer:uglify','watch:js2minjs'] );
};
/*function getFileName( o ) {
 var pos = o.lastIndexOf ( '.' );
 return o.substring ( 0,pos );
 }*/
function getFileName( o ) {
	var url = o.split ( "\\" );//这里要将 \ 转义一下
	return url[ url.length - 1 ];
}