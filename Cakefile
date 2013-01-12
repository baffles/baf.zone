# cakefile to build site
{exec} = require 'child_process'
fs = require 'fs-extra'
path = require 'path'

jade = require 'jade'
stylus = require 'stylus'
nib = require 'nib'
uglifyjs = require 'uglify-js'

option '-d', '--dev', 'Developer mode (prettyprint, no compression)'
option '-c', '--config [FILE]', 'Configuration File, defaults to config.json'
option '-o', '--output [OUTDIR]', 'Output directory for build, defaults to compiled'
option '-k', '--key [KEY]', 'S3 API Key'
option '-s', '--secret [SECRET]', 'S3 API Secret'
option '-b', '--bucket [BUCKET]', 'S3 Destination Bucket'
option '-p', '--path [PATH]', 'S3 Destination Path, defaults to /stable/'

getConfig = (options) ->
	configFile = options.config ? 'config.json'
	
	try
		config = fs.readJSONFileSync configFile
	catch err
		console.log "Error reading #{configFile}; skipping: #{err}"
		console.log ''
		config = null
	
	effectiveConfig =
		dev: options.dev ? config?.dev ? false
		output: options.output ? config?.output ? './compiled'
		key: options.key ? config?.key
		secret: options.secret ? config?.secret
		bucket: options.bucket ? config?.bucket
		path: options.path ? config?.path ? '/stable/'

buildDir = (options, sourceDir, destDir) ->
	fs.mkdirsSync destDir if not fs.existsSync destDir
	
	for entry in fs.readdirSync sourceDir
		stat = fs.statSync path.join sourceDir, entry
		if stat.isDirectory()
			buildDir options, path.join(sourceDir, entry), path.join(destDir, entry)
		else if stat.isFile()
			buildFile options, sourceDir, entry, destDir

buildFile = (options, sourceDir, sourceFile, destDir) ->
	switch path.extname sourceFile
		when '.jade'
			outFile = path.join destDir, sourceFile.replace /\.jade$/, '.html'
			console.log "Building #{outFile} [jade]..."
			
			html = jade.compile(fs.readFileSync(path.join(sourceDir, sourceFile), 'utf8'), { pretty: options.dev })()
			fs.writeFileSync outFile, html, 'utf8'
		when '.styl'
			outFile = path.join destDir, sourceFile.replace /\.styl$/, '.css'
			console.log "Building #{outFile} [stylus]..."
			
			css = stylus(fs.readFileSync(path.join(sourceDir, sourceFile), 'utf8'))
				.set('filename', sourceFile)
				.set('compress', not options.dev)
				.use(do nib)
				.render (err, css) ->
					throw err if err?
					fs.writeFileSync outFile, css, 'utf8'
		when '.coffee'
			outFile = path.join destDir, sourceFile.replace /\.coffee$/, '.js'
			console.log "Building #{outFile} [coffee]..."
			
			exec "coffee -cp #{path.join sourceDir, sourceFile}", (err, stdout, stderr) ->
				throw err if err?
				console.log stderr if stderr?
				
				if stdout?
					# it worked
					if options.dev
						fs.writeFileSync outFile, stdout, 'utf8'
					else
						# compress with uglify
						minified = uglifyjs.minify stdout, { fromString: true }
						fs.writeFileSync outFile, minified.code, 'utf8'
		else
			console.log "Skipping #{sourceFile}"

watchDir = (options, sourceDir, destDir) ->
	fs.mkdirsSync destDir if not fs.existsSync destDir

	for entry in fs.readdirSync sourceDir
		stat = fs.statSync path.join sourceDir, entry
		if stat.isDirectory()
			watchDir options, path.join(sourceDir, entry), path.join(destDir, entry)
		else if stat.isFile()
			watchFile options, sourceDir, entry, destDir

watchFile = (options, sourceDir, sourceFile, destDir) ->
	fs.watchFile path.join(sourceDir, sourceFile), (cur, prev) ->
		if +cur.mtime isnt +prev.mtime
			console.log "#{sourceFile} changed, rebuilding..."
			buildFile options, sourceDir, sourceFile, destDir

sources = [
	{ source: 'html', destination: '.' }
	{ source: 'css', destination: 'css' }
	{ source: 'js', destination: 'js' }
]

thirdParty = [
	{ source: 'fontawesome', destination: 'lib/fontawesome', paths: [ 'css', 'font' ] }
]

task 'build', 'build site', (options) ->
	options = getConfig options
	
	for sourceDir in sources
		buildDir options, sourceDir.source, path.join options.output, sourceDir.destination
	
	for pkg in thirdParty
		for p in pkg.paths
			sourcePath = path.join pkg.source, p
			destPath = path.join options.output, pkg.destination, p
			fs.mkdirsSync destPath
			console.log "Copying third party #{destPath}..."
			fs.copy sourcePath, destPath, (err) -> console.log "Error copying #{destPath}: #{err}" if err?

task 'watch', 'watches for changes in source files', (options) ->
	console.log 'Fresh build...'
	invoke 'build'
	
	options = getConfig options
	
	for sourceDir in sources
		watchDir options, sourceDir.source, path.join options.output, sourceDir.destination
	
	console.log 'Watching for changes...'

###
task 'upload', 'upload to S3', (options) ->
	path = require 'path'
	knox = require 'knox'
	
	gotOpts = true
	options = getConfig options
	
	if not options.key?
		console.log 'S3 API Key required'
		gotOpts = false
	if not options.secret?
		console.log 'S3 API Secret required'
		gotOpts = false
	if not options.bucket?
		console.log 'S3 Bucket required'
		gotOpts = false
	
	if not gotOpts
		console.log 'Run `cake` to view all available options.'
		process.exit 1
	
	console.log "Uploading accjs to #{path.join "[#{options.bucket}]", options.path}"
	
	client = knox.createClient
		key: options.key
		secret: options.secret
		bucket: options.bucket
	
	console.log 'Uploading accjs.js...'
	client.putFile 'bin/accjs.js', path.join(options.path, 'accjs.js'), { 'x-amz-acl': 'public-read', 'Cache-Control': 'no-cache' }, (err, res) ->
		console.log "Error uploading accjs.js: #{err}" if err?
		if res.statusCode is 200
			console.log 'Uploaded accjs.js.'
		else
			console.log "Error uploading accjs.js. [#{res.statusCode}]"
	
	console.log 'Uploading accjs.min.js...'
	client.putFile 'bin/accjs.min.js', path.join(options.path, 'accjs.min.js'), { 'x-amz-acl': 'public-read', 'Cache-Control': 'no-cache' }, (err, res) ->
		console.log "Error uploading accjs.min.js: #{err}" if err?
		if res.statusCode is 200
			console.log 'Uploaded accjs.min.js.'
		else
			console.log "Error uploading accjs.min.js. [#{res.statusCode}]"
###
