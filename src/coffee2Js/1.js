(function() {
  var getFileName;

  getFileName = function(o) {
    var url, urll;
    url = o.split("\\");
    urll = url.length - 1;
    return url[urll];
  };

  module.exports = function(grunt) {
    var coffee2Js, coffeeJs, delFile, destCss, destFonts, destImg, destJs, dirs, ref, ref1, ref2, ref3, scss2css, scss2cssmin, srcCss, srcCssmin, srcFonts, srcImg, srcJs, srcJsCompress, srcScss;
    dirs = {
      destDir: 'dest',
      srcDir: 'src'
    };
    ref = [dirs.destDir + '/js', dirs.destDir + '/css', dirs.destDir + '/img', dirs.destDir + '/fonts'], destJs = ref[0], destCss = ref[1], destImg = ref[2], destFonts = ref[3];
    ref1 = [dirs.srcDir + '/scss', dirs.srcDir + '/css', dirs.srcDir + '/css/cssmin', dirs.srcDir + '/scss2css', dirs.srcDir + '/scss2css/cssmin'], srcScss = ref1[0], srcCss = ref1[1], srcCssmin = ref1[2], scss2css = ref1[3], scss2cssmin = ref1[4];
    ref2 = [dirs.srcDir + '/js', dirs.srcDir + '/js/jsCompress', dirs.srcDir + '/img', dirs.srcDir + '/fonts'], srcJs = ref2[0], srcJsCompress = ref2[1], srcImg = ref2[2], srcFonts = ref2[3];
    ref3 = [dirs.srcDir + '/coffeeJs', dirs.srcDir + '/coffee2Js'], coffeeJs = ref3[0], coffee2Js = ref3[1];
    grunt.config.init({
      pkg: grunt.file.readJSON('package.json'),
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
      sass: {
        srcScss: {
          options: {
            style: 'expanded'
          },
          files: [
            {
              expand: true,
              cwd: srcScss,
              src: ['**/*.scss'],
              dest: scss2css,
              ext: '.css',
              flatten: true
            }
          ]
        }
      },
      csslint: {
        scss2css: {
          options: {
            csslintrc: '.csslintrc.json'
          },
          checkCss: {
            options: {
              "import": 2
            },
            src: ['<%= scss2css %>/*.css']
          }
        }
      },
      cssmin: {
        css: {
          files: [
            {
              expand: true,
              cwd: srcCss,
              src: ['*.css', '!**/*.min.css'],
              dest: srcCssmin,
              ext: '.min.css'
            }
          ]
        },
        scss2css: {
          files: [
            {
              expand: true,
              cwd: scss2css,
              src: ['*.css', '!**/*.map'],
              dest: scss2cssmin,
              ext: '.min.css'
            }
          ]
        }
      },
      concat: {
        options: {
          separator: '/*****************!CONCAT*******************/',
          stripBanners: true,
          banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - ' + '<%= grunt.template.today("yyyy-mm-dd") %> */\n'
        },
        scss2cssConcat: {
          src: [scss2cssmin + '/*.css'],
          dest: srcCssmin + '/scss2cssConcat.min.css'
        }
      },
      coffee: {
        coffeeJs: {
          expand: true,
          flatten: true,
          cwd: coffeeJs,
          src: ['*.coffee'],
          dest: coffee2Js,
          ext: '.js'
        }
      },
      jshint: {
        options: {
          jshintrc: ".jshintrc.json"
        },
        coffee2Js: [coffee2Js + "/{**/,!**/}*.js"],
        Gruntfile: ["Gruntfile.js"]
      },
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
              src: '{**/,!**/}*.js',
              dest: srcJsCompress,
              ext: '.js',
              flatten: true
            }
          ]
        },
        coffee2Js: {
          files: [
            {
              expand: true,
              cwd: coffee2Js,
              src: '{**/,!**/}*.js',
              dest: srcJsCompress,
              ext: '.js',
              flatten: true
            }
          ]
        },
        minJs: {
          files: [
            {
              expand: true,
              cwd: srcJsCompress,
              src: '{**/,!**/}*.js',
              dest: destJs,
              ext: ".min.js"
            }
          ]
        }
      },
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
      copy: {
        main: {
          files: [
            {
              expand: true,
              cwd: srcFonts,
              src: ['*'],
              dest: destFonts,
              flatten: true,
              filter: 'isFile'
            }, {
              expand: true,
              cwd: dirs.srcDir,
              src: ['*.html'],
              dest: dirs.destDir,
              flatten: true,
              filter: 'isFile'
            }, {
              expand: true,
              cwd: srcImg,
              src: ['*'],
              dest: destImg,
              flatten: true,
              filter: 'isFile'
            }
          ]
        },
        cssmin: {
          files: [
            {
              expand: true,
              cwd: srcCssmin,
              src: ['*'],
              dest: destCss,
              flatten: true,
              filter: 'isFile'
            }
          ]
        },
        scss2css: {
          files: [
            {
              expand: true,
              cwd: scss2cssmin,
              src: ['*'],
              dest: destCss,
              flatten: true,
              filter: 'isFile'
            }
          ]
        }
      },
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
            open: true
          },
          base: ['./' + dirs.srcDir]
        }
      },
      newer: {
        options: {
          cache: 'newer/cache/'
        }
      },
      watch: {
        options: {
          dateFormat: function(time) {
            grunt.log.writeln('监视耗时 ' + time + '毫秒，在' + (new Date()).toString());
            grunt.log.writeln('等待更多变化...');
          }
        },
        scss2css: {
          files: [srcScss + ' /{**/,!**/}*.scss'],
          tasks: ['newer:sass', 'newer:cssmin', 'newer:concat', 'newer:copy:cssmin', 'newer:copy:scss2css']
        },
        srcJs: {
          files: [srcJs + ' /{**/,!**/}*.js'],
          tasks: ['newer:uglify:srcJs']
        },
        coffeeJs: {
          files: [coffee2Js + ' /{**/,!**/}*.js'],
          tasks: ['newer:uglify:coffee2Js']
        },
        imgmin: {
          files: [srcImg + '/**/**/**/**/*'],
          tasks: ['newer:imagemin'],
          options: {
            spawn: false
          }
        },
        livereload: {
          options: {
            livereload: '<%=connect.options.livereload%>'
          },
          files: ['./' + dirs.srcDir + '/!*.html', './' + srcCss + '/{**!/,!**!/}*.css', './' + srcScss + '/{**!/,!**!/}*.scss', './' + srcJs + '/{**!/,!**!/}*.js', './' + coffee2Js + '/{**!/,!**!/}*.js', './' + srcImg + '/{**!/,!**!/}*.{png,jpg}']
        }
      }
    });
    require('load-grunt-tasks')(grunt, {
      pattern: ['grunt-*', '@*/grunt-*']
    });
    delFile = function(deldir, files, srcdir) {
      var cssFile, cssFileM, cssFileMin, cssFileN, cssMap, cssMin, file, fileN, jsF, minJs, minjsN, pngFile;
      file = files.substring(srcdir.length);
      fileN = getFileName(files);
      if (files.substr(-2) === 'js') {
        minjsN = fileN + '.min.js';
        jsF = srcdir + file;
        minJs = deldir + minjsN;
        if (grunt.file.exists(jsF)) {
          grunt.file["delete"](jsF);
          grunt.file["delete"](minJs);
          return false;
        }
      } else if (files.substr(-4) === 'scss') {
        cssFileN = fileN + '.css';
        cssFileM = fileN + '.css.map';
        cssFileMin = fileN + '.min.css';
        cssFile = scss2css + cssFileN;
        cssMap = scss2css + cssFileM;
        cssMin = scss2cssmin + cssFileMin;
        if (grunt.file.exists(cssFile)) {
          grunt.file["delete"](cssFile);
          grunt.file["delete"](cssMap);
          grunt.file["delete"](cssMin);
          return false;
        }
      } else if (files.substr(-3) === 'png') {
        pngFile = deldir + file;
        if (grunt.file.exists(pngFile)) {
          grunt.file["delete"](pngFile);
          return false;
        }
      }
    };
    grunt.event.on('watch', function(action, filepath, target) {
      grunt.log.writeln(filepath + '文件已经' + action + '并触发了' + target + '任务');
      if (target === 'imgmin') {
        if (action === 'deleted' || action === 'renamed') {
          delFile(destImg, filepath, srcImg);
          if (action === 'deleted') {
            return false;
          }
        }
      } else if (target === 'scss2css') {
        if (action === 'deleted' || action === 'renamed') {
          delFile(scss2css, filepath, srcScss);
          if (action === 'deleted') {
            return false;
          }
        }
      } else if (target === 'js2minjs') {
        if (action === 'deleted' || action === 'renamed') {
          delFile(destJs, filepath, srcJsCompress);
          if (action === 'deleted') {
            return false;
          }
        }
      }
    });
    grunt.registerTask('build', 'require demo', function() {
      var destDir, includes, options, paths, platformCfg, pos, requireTask, srcDir, taskCfg, tasks;
      tasks = ['requirejs'];
      srcDir = 'src';
      destDir = 'dest';
      grunt.config.set('config', {
        srcDir: srcDir,
        destDir: destDir
      });
      taskCfg = grunt.file.readJSON('requireJsCfg.json');
      options = taskCfg.requirejs.main.options;
      platformCfg = options.web;
      includes = platformCfg.include;
      paths = options.paths;
      pos = -1;
      requireTask = taskCfg.requirejs;
      options.path = paths;
      options.out = platformCfg.out;
      options.include = includes;
      grunt.task.run(tasks);
      return grunt.config.set("requirejs", requireTask);
    });
    grunt.registerTask('all', ['newer:sass', 'newer:cssmin', 'newer:uglify', 'newer:concat', 'newer:copy', 'connect', 'watch']);
    grunt.registerTask('sass', ['newer:sass', 'newer:cssmin', 'newer:concat:srcgruntCssmin', 'newer:copy:cssmin', 'watch:scss2css']);
    grunt.registerTask('js', ['newer:jshint', 'newer:uglify', 'watch:js2minjs']);
  };

}).call(this);
