module.exports = (grunt) ->

	aws = grunt.file.readJSON '../../grunt-aws.json'

	grunt.initConfig
		s3:
			options:
				key: aws.key
				secret: aws.secret
				access: 'public-read'
			projects:
				options:
					bucket: 'projects.baf.cc'
				upload: [
						src: 'index.html'
						dest: '/index.html'
						rel: '.'
					,
						src: 'pdf/motorcycle/1125chargingsystem.html'
						dest: '/pdf/motorcycle/1125chargingsystem.pdf'
						options:
							headers:
								'Content-Type': 'text/html'
				]

	# loading grunt-s3 from a submodule for now (I made some bugfixes related to globbing)
	grunt.loadNpmTasks 'grunt-s3'
	grunt.registerTask 'default', 's3:projects'
