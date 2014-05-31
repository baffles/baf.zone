async = require 'async'
fs = require 'fs'
path = require 'path'
url = require 'url'

yaml = require 'js-yaml'

module.exports = (env, callback) ->
	### Projects Plugin

	This plugin handles project page/writeup functionality. This includes generating a project
	listing page, generating "home pages" for each project, and generating PDF and HTML versions of
	the	project writeup.

	For project listing purposes, projects are assumed to be organized into subdirectories in the
	projects folder. There can be an index.project file in the subdirectory to render a normal
	project homepage, or some other form of index file to customize the project page. There should
	be metadata attached, however, giving the project information.

	Project homepages will be generated from the template as a landing page for the project.
	Any other subpages may be included in the subdirectory (and subsequently linked to).
	###

	defaults =
		projectListTemplate: 'project-list.jade' # template that renders the master project list
		projectPageTemplate: 'project.jade' # template that renders project homepages
		projects: 'projects' # directory containing projects

	options = env.config.projects or {}
	for key, value of defaults
		options[key] ?= defaults[key]

	class ProjectPage extends env.plugins.Page
		constructor: (@filepath, @metadata, @projectContents) ->

		@property 'directory', 'getDirectory'
		getDirectory: () ->
			full: path.dirname @filepath.full
			relative: path.dirname @filepath.relative

		getLocation: (base=env.config.baseUrl) ->
			uri = @getUrl base
			uri[0..uri.lastIndexOf('/')]

		getProjDir: (contents) ->
			# find the project directory in `contents`
			dir = @directory.relative
			projDir = contents
			projDir = projDir[folder] for folder in dir.split path.sep
			projDir

		getSummary: (contents) ->
			# find the project summary, if there is one, in `contents`
			if @metadata.summary
				projDir = @getProjDir contents
				projDir[@metadata.summary]

		@property 'writeup', 'getWriteup'
		getWriteup: () ->
			# generate project writeup URLs
			if @metadata.writeup
				baseUrl = @getLocation()
				writeup = path.basename(@metadata.writeup, path.extname(@metadata.writeup))
				html: url.resolve baseUrl, "#{writeup}.html"
				pdf: url.resolve baseUrl, "#{writeup}.pdf"

	ProjectPage.fromFile = (filepath, callback) ->
		async.waterfall [
			(callback) ->
				# first, load the metadata file
				fs.readFile filepath.full, { encoding: 'UTF-8' }, callback
			(metadataContents, callback) ->
				# then, process the metadata
				ProjectPage.loadMetadata(metadataContents, callback)
			(metadata, callback) =>
				# now, actually create the project
				metadata.template = options.projectPageTemplate
				project = new this filepath, metadata
				callback null, project
		], callback

	ProjectPage.loadMetadata = (content, callback) ->
		try
			callback null, yaml.load(content) or {}
		catch error
			if error.problem? and error.problemMark?
				lines = error.problemMark.buffer.split '\n'
				markerPad = (' ' for [0...error.problemMark.column]).join('')
				error.message = """YAML: #{ error.problem }

					#{ lines[error.problemMark.line] }
					#{ markerPad }^

				"""
			else
				error.message = "YAML Parsing error #{ error.message }"
			callback error

	env.registerContentPlugin 'pages', path.join(options.projects, '*', '*.project'), ProjectPage

	getProjects = (contents, sort, filter) ->
		# helper that returns a list of projects
		projects = contents
		projects = projects[folder] for folder in options.projects.split '/'
		projects = projects._.directories.map (dir) -> dir.index
		projects = projects.filter (project) -> project.metadata?.project?
		projects.sort (a, b) -> a.metadata.project.localeCompare(b.metadata.project, { sensitivity: 'accent' }) if sort ? true
		if filter?
			projects.filter filter
		else
			projects

	env.helpers.getProjects = getProjects

	env.registerGenerator 'project-html', (contents, callback) ->
		projects = getProjects(contents, false, (project) -> project.metadata.writeup?)

		contentTree = { projects: { html: {} } }
		for project in projects
			file =
				full: path.join(project.directory.full, project.metadata.writeup)
				relative: path.join(project.directory.relative, project.metadata.writeup)
			contentTree.projects.html[project.metadata.project] = new ProjectWriteupPdf file, project.metadata

		callback null, contentTree

	class ProjectWriteupPdf extends env.ContentPlugin
		### Project PDF; renders markdown to PDF using markdown-pdf ###
		constructor: (@filepath, @metadata) ->

		getFilename: ->
			dirname = path.dirname @filepath.relative
			basename = path.basename @filepath.relative
			file = env.utils.stripExtension basename
			filename = file + '.pdf'
			path.join dirname, filename

		getView: -> 'markdown-pdf'

	env.registerGenerator 'project-pdf', (contents, callback) ->
		projects = getProjects(contents, false, (project) -> project.metadata.writeup?)

		contentTree = { projects: { pdfs: {} } }
		for project in projects
			file =
				full: path.join(project.directory.full, project.metadata.writeup)
				relative: path.join(project.directory.relative, project.metadata.writeup)
			contentTree.projects.pdfs[project.metadata.project] = new ProjectWriteupPdf file, project.metadata

		callback null, contentTree

	callback()