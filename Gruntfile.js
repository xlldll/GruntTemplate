// Generated by CoffeeScript 1.10.0
(function() {
  module.exports = function(grunt) {

    /* 开发目录与发布目录 */
    var cfjs, cfjsmin, cssmin, destCss, destFonts, destHtml, destImg, destJs, dirs, jsmin, ref, ref1, ref2, ref3, ref4, ref5, scss, scssmin, srcCss, srcFonts, srcHtml, srcImg, srcImgMin, srcJs;
    dirs = {
      destDir: 'dest',
      srcDir: 'src'
    };

    /* 发布目录文件夹 */
    ref = [dirs.destDir + '/html', dirs.destDir + '/js', dirs.destDir + '/css', dirs.destDir + '/img', dirs.destDir + '/fonts'], destHtml = ref[0], destJs = ref[1], destCss = ref[2], destImg = ref[3], destFonts = ref[4];

    /* 开发主页、图片、格式 */
    ref1 = [dirs.srcDir + '/html', dirs.srcDir + '/img', dirs.srcDir + '/imgMin', dirs.srcDir + '/fonts'], srcHtml = ref1[0], srcImg = ref1[1], srcImgMin = ref1[2], srcFonts = ref1[3];

    /* 开发CSS */
    ref2 = [dirs.srcDir + '/css', dirs.srcDir + '/cssmin'], srcCss = ref2[0], cssmin = ref2[1];

    /* 开发SCSS */
    ref3 = [dirs.srcDir + '/scss', dirs.srcDir + '/scssmin'], scss = ref3[0], scssmin = ref3[1];

    /* 开发JS */
    ref4 = [dirs.srcDir + '/js', dirs.srcDir + '/jsmin'], srcJs = ref4[0], jsmin = ref4[1];

    /* 开发CoffeeJs */
    ref5 = [dirs.srcDir + '/cfjs', dirs.srcDir + '/cfjsmin'], cfjs = ref5[0], cfjsmin = ref5[1];

    /* 任务配置 */
    grunt.config.init({
      pkg: grunt.file.readJSON('package.json'),

      /* 1.图片压缩到发布目录 */
      imagemin: {
        srcImg: {
          options: {
            optimizationLevel: 3
          },
          files: [
            {
              expand: true,
              cwd: srcImg,
              src: ['**/*.{png,jpg,jpeg,gif}'],
              dest: destImg
            }
          ]
        }
      },
      htmlmin: {
        html: {
          options: {
            removeComments: true,
            collapseWhitespace: true
          },
          files: [
            {
              expand: true,
              cwd: srcHtml,
              src: ['**/*.html'],
              dest: destHtml
            }
          ]
        }
      },

      /* 2.SCSS本地编译 */
      sass: {
        scss: {
          options: {
            style: 'expanded'
          },
          files: [
            {
              expand: true,
              cwd: scss,
              src: ['**/*.scss'],
              dest: scss,
              ext: '.css',
              flatten: false
            }
          ]
        }
      },

      /* 3.CSS格式检查 */
      csslint: {
        css: {
          options: {
            csslintrc: '.csslintrc.json'
          },
          checkCss: {
            options: {
              "import": 2
            },
            src: [scss + '*{,**/}*.css', srcCss + '{,**/}*.css']
          }
        }
      },

      /* 4.CSS本地压缩 */
      cssmin: {
        css: {
          files: [
            {
              expand: true,
              cwd: srcCss,
              src: ['**/*.css'],
              dest: cssmin,
              ext: '.css'
            }
          ]
        },
        scss: {
          files: [
            {
              expand: true,
              cwd: scss,
              src: ['**/*.css', '!**/*.map'],
              dest: scssmin,
              ext: '.css'
            }
          ]
        }
      },

      /* 5.单纯拼接合并CSS以及JS到发布目录，并没有压缩处理效果 */
      concat: {
        options: {
          separator: '/*****************!CONCAT*******************/',
          stripBanners: true,
          banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - ' + '<%= grunt.template.today("yyyy-mm-dd") %> */\n'
        },
        cssCat: {
          src: [cssmin + '/**/*.css'],
          dest: destCss + '/srcAllCss.min.css'
        },
        scssCat: {
          src: [scssmin + '/**/*.css'],
          dest: destCss + '/srcAllScss.min.css'
        }
      },

      /* 6.cfjs本地编译 */

      /* 注意src的斜杠格式 */
      coffee: {
        cfJs: {
          expand: true,
          flatten: false,
          cwd: cfjs,
          src: ['{,**/}*.coffee'],
          dest: cfjs,
          ext: '.js'
        }
      },

      /* 7.JS检查 */
      jshint: {
        options: {
          jshintrc: ".jshintrc.json"
        },
        coffee2Js: [cfjs + "{,**/}*.js"],
        Gruntfile: ["Gruntfile.js"]
      },

      /* 8.JS压缩 */
      uglify: {
        options: {
          stripBanners: true,
          mangle: false,
          banner: "/*! <%=pkg.name%>-<%=pkg.version%>.js <%= grunt.template.today('yyyy-mm-dd HH:MM') %> */\n"
        },
        srcJs: {
          files: [
            {
              expand: true,
              cwd: srcJs,
              src: '{,**/}*.js',
              dest: jsmin,
              ext: '.js',
              flatten: false
            }
          ]
        },
        cfJs: {
          files: [
            {
              expand: true,
              cwd: cfjs,
              src: '{,**/}*.js',
              dest: cfjsmin,
              ext: '.js',
              flatten: false
            }
          ]
        }
      },

      /* 8.JS合并兼压缩 */
      requirejs: {
        compile: {
          options: {
            baseUrl: "./",
            include: ["src/main.js"],
            out: "path/to/optimized.js"
          }
        }
      },

      /* 9.Bower管理引入文件 */
      bower: {
        install: {
          options: {
            targetDir: srcJs,
            layout: 'byComponent',
            install: true,
            verbose: false,
            cleanTargetDir: false,
            cleanBowerDir: false,
            bowerOptions: {}
          }
        }
      },

      /* 10.转移开发文件到发布文件夹 */
      copy: {

        /* html、字体 */
        main: {
          files: [
            {
              expand: true,
              cwd: dirs.srcDir,
              src: ['*.html'],
              dest: dirs.destDir,
              flatten: true,
              filter: 'isFile'
            }
          ]
        }
      },

      /* 11.建立网站连接 */
      connect: {
        options: {
          open: {
            target: 'http://127.0.0.1:9080',
            appName: 'chrome',
            callback: function() {}
          },
          port: 9080,
          hostname: '127.0.0.1',
          livereload: 35729
        },
        server: {
          options: {
            open: true,
            base: ['./' + srcHtml]
          }
        }
      },

      /* 12.文件历史缓存 */
      newer: {
        options: {
          cache: 'newer/'
        }
      },

      /* 13.同步开发文件的删除添加重命名 */
      sync: {
        htmls: {
          files: [
            {
              cwd: srcHtml,
              src: ['{,**/}*.html'],
              dest: destHtml
            }
          ],
          pretend: false,
          verbose: true,
          updateAndDelete: true
        },
        imgs: {
          files: [
            {
              cwd: srcImg,
              src: ['**'],
              dest: destImg
            }
          ],
          pretend: false,
          verbose: true,
          updateAndDelete: true
        },
        fonts: {
          files: [
            {
              cwd: srcFonts,
              src: ['**'],
              dest: destFonts
            }
          ],
          pretend: false,
          verbose: true,
          updateAndDelete: true
        },
        css: {
          files: [
            {
              cwd: srcCss,
              src: ['{,**/}*.css'],
              dest: cssmin
            }
          ],
          pretend: false,
          verbose: true,
          updateAndDelete: true
        },
        scss: {
          files: [
            {
              cwd: scss,
              src: ['{,**/}*.css'],
              dest: scssmin
            }
          ],
          pretend: false,
          verbose: true,
          updateAndDelete: true
        },
        srcJs: {
          files: [
            {
              cwd: srcJs,
              src: ['{,**/}*.js'],
              dest: jsmin
            }
          ],
          pretend: false,
          verbose: true,
          updateAndDelete: true
        },
        cfJs: {
          files: [
            {
              cwd: cfjs,
              src: ['{,**/}*.js', '!{,**/}*.coffee'],
              dest: cfjsmin
            }
          ],
          pretend: false,
          verbose: true,
          updateAndDelete: true
        }
      },

      /* 14.监视变动 */
      watch: {
        options: {
          dateFormat: function(time) {
            grunt.log.writeln('监视耗时 ' + time + '毫秒' + (new Date()).toString());
            grunt.log.writeln('等待更多变化...');
          }

          /* 1.gruntfile自动重新加载 */
        },
        configFiles: {
          files: ['Gruntfile.js'],
          options: {
            reload: true
          }
        },

        /* 2.公共CSS */
        css: {
          files: [srcCss + '/{,**/}*.css'],
          tasks: ['newer:cssmin:css', 'sync:css', 'concat:cssCat']
        },

        /* 3.个人SCSSs */
        scss: {
          files: [scss + '/{,**/}*.scss', scss + '/{,**/}*.css'],
          tasks: ['newer:sass:scss', 'newer:cssmin:scss', 'sync:scss', 'concat:scssCat']
        },

        /* 4.公共JS */
        srcJs: {
          files: [srcJs + '/{,**/}*.js'],
          tasks: ['newer:uglify:srcJs', 'sync:srcJs', 'concat:jsCat']
        },

        /* 5.个人JS */
        cfJs: {
          files: [cfjs + '/{,**/}*.coffee', cfjs + '/{,**/}*.js'],
          tasks: ['newer:coffee:cfJs', 'newer:uglify:cfJs', 'sync:cfJs', 'concat:cfjsCat']
        },

        /* 6.图片压缩 */
        imgmin: {
          files: [srcImg + '/{,**/}*'],
          tasks: ['newer:imagemin', 'sync:imgs']
        },
        htmlmin: {
          files: [srcHtml + '/{,**/}*'],
          tasks: ['newer:htmlmin', 'sync:htmls']
        },

        /* 7.格式文件 */
        fonts: {
          files: [srcFonts + '/{,**/}*'],
          tasks: ['sync:fonts']
        },

        /* 8.实时修改 */
        livereload: {
          options: {
            livereload: '<%=connect.options.livereload%>'
          },
          files: ['./' + srcHtml + '/{,**/}*.html', './' + srcCss + '/{,**/}*.css', './' + srcJs + '/{,**/}*.js', './' + cfjs + '/{,**/}*.js', './' + srcImg + '/{,**/}*.{png,jpg}']
        }
      }
    });
    require('load-grunt-tasks')(grunt, {
      pattern: ['grunt-*', '@*/grunt-*']
    });

    /* 所有 */
    grunt.registerTask('all', ['newer:sass', 'newer:cssmin', 'newer:coffee', 'newer:uglify', 'newer:concat', 'newer:copy', 'connect', 'watch']);

    /* JS */
    grunt.registerTask('jsss', ['newer:coffee', 'newer:uglify', 'watch']);

    /* CSS */
    grunt.registerTask('csss', ['newer:sass', 'newer:cssmin', 'watch']);

    /* 检查格式 */
    grunt.registerTask('chkCSS', ['csslint']);
    grunt.registerTask('chkJS', ['jshint']);

    /* 实时修改 */
    grunt.registerTask('live', ['connect', 'watch']);

    /* 文件压缩 */
    grunt.registerTask('minify', ['imagemin', 'cssmin', 'uglify', 'htmlmin']);

    /* 文件合并 */
    grunt.registerTask('cat', ['concat']);

    /* 自定义任务 */
    grunt.registerTask('reqJs', 'requireJS', function() {
      var options, platformCfg, requireTask, taskCfg, tasks;
      taskCfg = grunt.file.readJSON('rjsGrunt.json');
      requireTask = taskCfg.requirejs;
      options = requireTask.main.options;
      platformCfg = options.web;
      options.include = platformCfg.include;
      options.name = platformCfg.name;
      options.out = platformCfg.out;
      options.paths = options.paths;
      options.mainConfigFile = options.mainConfigFile;
      grunt.config.set("requirejs", requireTask);
      tasks = ['requirejs'];
      return grunt.task.run(tasks);
    });
  };

}).call(this);

//# sourceMappingURL=Gruntfile.js.map
