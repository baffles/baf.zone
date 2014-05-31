fs = require 'fs'
path = require 'path'

markdownpdf = require 'markdown-pdf'
duplexer = require 'duplexer'
split = require 'split'
through = require 'through'

typogr = require 'typogr'

module.exports = (env, callback) ->
	### PDF plugin

	This plugin provides a view (env.plugins.MarkdownPdfView) that can render markdown to PDF.
	The view expects a @filepath instance var pointing to the markdown source file. Calls `callback`
	with the PDF output.
	###

	defaults =
		css: 'pdf/pdf.css'
		paperFormat: 'Letter'
		paperOrientation: 'portrait'
		pageBorder: '1in'
		renderDelay: 500

	options = env.config.pdf or {}
	for key, value of defaults
		options[key] ?= defaults[key]

	env.registerView 'markdown-pdf', (env, locals, contents, templates, callback) ->
		mdFile = @filepath.full
		baseDir = path.dirname mdFile

		preProcessMd = () ->
			# pre-process the markdown input to resolve image URLs to absolute paths
			splitter = split()
			replacer = through (data) ->
				line = data.replace /\!\[(.*?)\]\(([^"']+)([^)]*)\)/gi, (match, altText, imgPath, trailingTitle) -> "![#{altText}](#{path.resolve baseDir, imgPath}#{trailingTitle})"
				@queue "#{line}\n"

			splitter.pipe replacer
			duplexer splitter, replacer

		preProcessHtml = () ->
			# post-process the HTML output by running it through typogrify
			splitter = split()
			replacer = through (data) ->
				if /[^\s]/.test data
					@queue typogr.typogrify(data)
				else
					@queue data
				@queue '\n'

			splitter.pipe replacer
			duplexer splitter, replacer

		markdownpdfOpts =
			cssPath: path.resolve options.css
			paperFormat: options.paperFormat
			paperOrientation: options.paperOrientation
			pageBorder: options.pageBorder
			renderDelay: options.renderDelay
			preProcessMd: preProcessMd
			preProcessHtml: preProcessHtml

		markdownpdf(markdownpdfOpts)
			.from(mdFile)
			.to.buffer(callback)

	callback()