module.exports = (grunt) ->

	aws = grunt.file.readJSON './grunt-aws.json'

	grunt.initConfig
		clean:
			build: [ 'build' ]
		wintersmith:
			build: {}
			preview:
				options:
					action: 'preview'
		imagemin:
			dist:
				options:
					optimizationLevel: 3
				files: [
						expand: true
						cwd: 'build/'
						src: [ '**/*.jpg' ]
						dest: 'build/'
					,
						expand: true
						cwd: 'build/'
						src: [ '**/*.png' ]
						dest: 'build/'
				]
		htmlmin:
			html:
				options:
					removeComments: true
					collapseWhitespace: true
					conservativeCollapse: true
					minifyJS: true
					minifyCSS: true
				files: [
					expand: true
					cwd: 'build/'
					src: [ '**/*.html' ]
					dest: 'build/'
				]
			xml:
				options:
					removeComments: true
					collapseWhitespace: true
				files: [
					expand: true
					cwd: 'build/'
					src: [ '**/*.xml' ]
					dest: 'build/'
				]
		cssmin:
			dist:
				expand: true
				cwd: 'build/css'
				src: [ '**/*.css' ]
				dest: 'build/css'
		uglify:
			dist:
				files: [
					expand: true
					cwd: 'build/'
					src: [ 'js/**/*.js', '!componenents/**' ]
					dest: 'build/'
				]
		hashres:
			options:
				encoding: 'utf8'
				fileNameFormat: '${name}.${hash}.cache.${ext}'
				renameFiles: true
			css:
				options: {}
				src: 'build/css/**/*.*'
				dest: [
					'build/**/*.html',
					'build/**/*.css'
				]
			js:
				options: {}
				src: 'build/js/**/*.js'
				dest: 'build/**/*.html'
			bower:
				options: {}
				src: 'build/components/**/*.js'
				dest: [
					'build/components/**/*.js'
					'build/**/*.html'
				]
			images:
				options: {}
				src: [
					'build/**/*.png'
					'build/**/*.jpg'
				]
				dest: [
					'build/**/*.html'
					'build/**/*.js'
					'build/**/*.css'
					'build/**/*.md'
				]
		s3:
			options:
				key: aws.key
				secret: aws.secret
				access: 'public-read'
			staging:
				options:
					bucket: 'staging.baf.zone'
				upload: [
					src: 'build/**/*.*'
					dest: '/'
					rel: 'build'
				]
			production:
				options:
					bucket: 'baf.zone'
				upload: [
					# hashres'd files get 2 year max-age. gzip css, js, and css/js in components.
						src: 'build/css/**/*.*'
						dest: '/'
						rel: 'build'
						options:
							gzip: true
							headers: { 'Cache-Control': 'max-age=630720000, public' }
					,
						src: 'build/js/**/*.*'
						dest: '/'
						rel: 'build'
						options:
							gzip: true
							headers: { 'Cache-Control': 'max-age=630720000, public' }
					,
						src: 'build/components/**/*.{css,js}'
						dest: '/'
						rel: 'build'
						options:
							gzip: true
							headers: { 'Cache-Control': 'max-age=630720000, public' }
					,
						src: [ 'build/components/**/*.*', '!build/components/**/*.{css,js}' ]
						dest: '/'
						rel: 'build'
						options:
							headers: { 'Cache-Control': 'max-age=630720000, public' }
					, # allow blog posts and permalinks themselves to be cached. we can invalidate things if required
						src: [ 'build/blog/posts/**/*.*', 'build/post/**/*.*' ]
						dest: '/'
						rel: 'build'
						options:
							gzip: true
							gzipExclude: [ '.jpg', '.png' ]
							headers: { 'Cache-Control': 'max-age=630720000, public' }
					, # by default, the rest won't be cached, since it's mutable. any stray css/js/html/json will be gzipped
						src: [ 'build/**/*.{css,js,json,html}', '!build/{components,css,js,post}/**/*.*', '!build/blog/page/**/*.*' ]
						dest: '/'
						rel: 'build'
						options:
							gzip: true
							headers: { 'Cache-Control': 'max-age=0, public' }
					,
						src: [ 'build/**/*.*', '!build/**/*.{css,js,json,html}', '!build/{components,css,js,post}/**/*.*', '!build/blog/page/**/*.*' ]
						dest: '/'
						rel: 'build'
						options:
							headers: { 'Cache-Control': 'max-age=0, public' }
				]


	# loading grunt-s3 from a submodule for now (I made some bugfixes related to globbing)
	grunt.loadNpmTasks task for task in [ 'grunt-contrib-clean', 'grunt-wintersmith', 'grunt-contrib-imagemin', 'grunt-contrib-htmlmin', 'grunt-contrib-cssmin', 'grunt-contrib-uglify', 'grunt-hashres' ] #, 'grunt-s3'
	grunt.loadTasks 'grunt-s3/tasks'

	grunt.registerTask 'preview', 'wintersmith:preview'

	grunt.registerTask 'pre-build', [ 'clean' ]
	grunt.registerTask 'post-build', [ 'imagemin', 'htmlmin', 'cssmin', 'uglify', 'hashres' ]
	grunt.registerTask 'build', [ 'pre-build', 'wintersmith:build', 'post-build' ]

	grunt.registerTask 'deploy-staging', [ 'build', 's3:staging' ]
	grunt.registerTask 'deploy-production', [ 'build', 's3:production' ]
