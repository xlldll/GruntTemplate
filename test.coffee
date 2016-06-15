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

sync:
main:
files: [{
cwd: 'src',
src: [
'**',
'!**/*.txt'
],
dest: 'bin'
}]
pretend: true
verbose: true