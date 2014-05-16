module.exports = (env, callback) ->
	# Generate static HTML pages reflecting the tumblr permalinks that redirect to the proper location

	defaults =
		articles: 'articles' # directory containing articles
		template: 'tumblr-permalink.jade' # template for a permalink redirect page

	options = env.config.tumblr or {}
	for key, value of defaults
		options[key] ?= defaults[key]

	getArticles = (contents) ->
		# helper that returns a list of articles containing a tumblr permalink
		articles = contents[options.articles]._.directories.map (item) -> item.index
		articles.filter (item) -> item.metadata.tumblr_url

	class RedirectPage extends env.plugins.Page
		constructor: (@permalink, @article) ->
		getFilename: -> @permalink + '/index.html'
		getView: -> (env, locals, contents, templates, callback) ->
			template = templates[options.template]
			if not template?
				return callback new Error "unknown tumblr-permalink template '#{ options.template }'"

			ctx =
				postUrl: @article.url

			env.utils.extend ctx, locals

			template.render ctx, callback

	env.registerGenerator 'tumblr-permalinks', (contents, callback) ->
		pages = for article in getArticles contents
			permalink = article.metadata.tumblr_url.replace options.tumblrBase, ''
			new RedirectPage permalink, article

		rv = { pages: {} }
		for page in pages
			rv.pages["#{ page.permalink }.permalink"] = page

		callback null, rv

	callback()
