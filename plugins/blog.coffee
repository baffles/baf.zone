async = require('async')
path = require('path')
_ = require('underscore')

module.exports = (env, callback) ->
	### Blog Plugin

	Loosely based on paginator.coffee from the wintersmith blog example. This plugin handles a
	bunch of blog functionality. This includes pagination (like paginator.coffee), generation of
	paginator JSON files (for infinite scrolling), and fulfilling old tumblr permalinks from
	imported content.

	tumblrBase must be specified in config.json, containing the 'base url' of the tumblr blog, if
	permalinks are to be fulfilled. tumblr_url in the post metadata is what is used for figuring
	out the permalink.

	Posts are assumed to be organized into subdirectories in the posts folder. The post content
	itself should be index.
	###

	defaults =
		pageTemplate: 'index.jade' # template that renders pages
		pageDynamicTemplate: 'index-dynamic.jade' # template that renders JUST the posts, for infinite scroll
		permalinkTemplate: 'tumblr-permalink.jade' # template for rendering permalink redirects
		tagPageTemplate: 'tag.jade' # template for page
		posts: 'posts' # directory containing the posts
		first: 'index.html' # filename/url for first page
		page: 'page/$page/index.html' # filename for pages
		pageJson: 'page/$page.json' # filename for generated page JSON
		tagFirst: 'tag/$tag/index.html' # filename/url for first tag page
		tagPage: 'tag/$tag/$page/index.html'  # filename for subsequent tag pages
		perPage: 2 # number of articles per page

	# assign defaults for any options not set in the config file
	options = env.config.blog or {}
	for key, value of defaults
		options[key] ?= defaults[key]

	getPosts = (contents, sort, filter) ->
		# helper that returns a list of blog posts found in `contents`, sorted if `sort` is true
		# (or undefined), and filtered by the optional `filter`
		posts = contents
		posts = posts[folder] for folder in options.posts.split '/'
		posts = posts._.directories.map (post) -> post.index
		posts.sort (a, b) -> b.date - a.date if sort ? true
		if filter?
			posts.filter filter
		else
			posts

	getTags = (contents) ->
		# helper that looks through all contents to collect a list of tags
		posts = contents
		posts = posts[folder] for folder in options.posts.split '/'
		posts = posts._.directories.map (post) -> post.index
		_(posts).chain().map((post) -> post.metadata.tags).flatten().uniq().value()

	class PaginatorPage extends env.plugins.Page
		# A page has a number and a list of posts
		constructor: (@pageNum, @posts) ->

		getFilename: ->
			if @pageNum is 1
				options.first
			else
				options.page.replace '$page', @pageNum

		getView: -> (env, locals, contents, templates, callback) ->
			# simple view to pass posts and pagenum to the paginator template
			# note that this function returns a funciton

			# get the pagination template
			template = templates[path.normalize(options.pageTemplate)]
			if not template?
				return callback new Error "unknown blog page template '#{ options.pageTemplate }'"

			# setup the template context
			ctx = {@posts, @prevPage, @nextPage}

			# extend the template context with the enviroment locals
			env.utils.extend ctx, locals

			# finally render the template
			template.render ctx, callback

	class PaginatorDynamicPage extends env.plugins.Page
		# A page has a number and a list of posts
		constructor: (@pageNum, @posts) ->

		getFilename: -> options.pageJson.replace '$page', @pageNum

		getView: -> (env, locals, contents, templates, callback) ->
			# simple view that JSON-ifies the data for the page
			template = templates[path.normalize(options.pageDynamicTemplate)]
			if not template?
				return callback new Error "unknown dynamic blog page template '#{ options.pageDynamicTemplate }'"

			ctx = {@posts, @prevPage, @nextPage}
			env.utils.extend ctx, locals

			async.waterfall [
				(cb) -> template.render ctx, cb
				(html, cb) =>
					page =
						page: @pageNum
						html: html.toString()

					callback null, new Buffer JSON.stringify page
			], callback

	# register a generator, 'blog' here is the content group generated content will belong to
	# i.e. contents._.blog
	env.registerGenerator 'blog', (contents, callback) ->

		# find all posts
		posts = getPosts contents

		# populate pages
		numPages = Math.ceil posts.length / options.perPage
		pages = []
		dynamicPages = []
		for i in [0...numPages]
			pagePosts = posts.slice i * options.perPage, (i + 1) * options.perPage
			pages.push new PaginatorPage i + 1, pagePosts
			dynamicPages.push new PaginatorDynamicPage i, pagePosts

		# add references to prev/next to each page
		for page, i in pages
			page.prevPage = pages[i - 1]
			page.nextPage = pages[i + 1]

		# create the object that will be merged with the content tree (contents)
		# do _not_ modify the tree directly inside a generator, consider it read-only
		contentTree = { pages: { json: {} } }
		for page in pages
			contentTree.pages["#{ page.pageNum }.page"] = page # file extension is arbitrary
		contentTree['index.page'] = pages[0] # alias for first page
		for dynPage in dynamicPages
			contentTree.pages.json["#{ dynPage.pageNum }.json"] = dynPage

		# callback with the generated contents
		callback null, contentTree

	class PermalinkPage extends env.plugins.Page
		constructor: (@permalink, @post) ->
		getFilename: -> @permalink + '/index.html'
		getView: -> (env, locals, contents, templates, callback) ->
			template = templates[path.normalize(options.permalinkTemplate)]
			if not template?
				return callback new Error "unknown blog permalink template '#{ options.permalinkTemplate }'"

			ctx =
				postUrl: @post.url

			env.utils.extend ctx, locals

			template.render ctx, callback

	env.registerGenerator 'blog', (contents, callback) ->
		permalinks = for post in (getPosts contents, false, (post) -> post.metadata.tumblr_url?)
			permalink = post.metadata.tumblr_url.replace options.tumblrBase, ''
			new PermalinkPage permalink, post

		contentTree = { permalinks: {} }
		for permalink in permalinks
			contentTree.permalinks["#{ permalink.permalink }"] = permalink

		callback null, contentTree

	class TagPage extends env.plugins.Page
		# A tag page has a tag, a number, and a list of posts
		constructor: (@tag, @pageNum, @posts) ->

		getFilename: ->
			if @pageNum is 1
				options.tagFirst.replace '$tag', @tag
			else
				options.tagPage.replace('$tag', @tag).replace('$page', @pageNum)

		getView: -> (env, locals, contents, templates, callback) ->
			# simple view to pass posts and pagenum to the paginator template
			# note that this function returns a funciton

			# get the pagination template
			template = templates[path.normalize(options.tagPageTemplate)]
			if not template?
				return callback new Error "unknown blog page template '#{ options.tagPageTemplate }'"

			# setup the template context
			ctx = {@tag, @posts, @prevPage, @nextPage}

			# extend the template context with the enviroment locals
			env.utils.extend ctx, locals

			# finally render the template
			template.render ctx, callback

	env.registerGenerator 'blog-tags', (contents, callback) ->
		# find all posts and tags
		posts = getPosts contents
		tags = getTags contents

		contentTree = { tags: {} }

		for tag in tags
			pages = []

			# populate pages
			taggedPosts = posts.filter (post) -> _(post.metadata.tags).contains(tag)
			numPages = Math.ceil taggedPosts.length / options.perPage
			for i in [0...numPages]
				pagePosts = taggedPosts.slice i * options.perPage, (i + 1) * options.perPage
				pages.push new TagPage tag, i + 1, pagePosts

			# add references to prev/next to each page
			for page, i in pages
				page.prevPage = pages[i - 1]
				page.nextPage = pages[i + 1]

			contentTree.tags[tag] = { pages: {} }
			for page in pages
				contentTree.tags[page.tag].pages["#{ page.pageNum }.page"] = page # file extension is arbitrary

		# callback with the generated contents
		callback null, contentTree

	# add the post helper to the environment so we can use it later
	env.helpers.getBlogPosts = getPosts

	env.helpers.tagHref = (tag) -> "/#{ options.tagFirst.replace '$tag', tag }".replace /index\.html$/, ''

	# tell the plugin manager we are done
	callback()