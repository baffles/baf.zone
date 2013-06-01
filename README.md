# My Website

This is the source to my website. It is written with Jade, Stylus/Nib, and
CoffeeScript, and designed to be statically compiled and hosted via Amazon S3
and/or CloudFront.

## Third Party Code

I'm using [Font Awesome](http://fontawesome.github.com/Font-Awesome/) by David
Gandy for several icons on the site. This exists as a submodule in this
repository.

I'm making use of [CoffeeScript](http://coffeescript.org/) (running on
[node.js](http://nodejs.org/)), both for JavaScript on the site, and for
building the site.

* CoffeeScript must be installed and in the path to build the site.
* The [jade](http://jade-lang.com/) `v0.28.x`,
  [stylus](http://learnboost.github.com/stylus/) `v0.32.x`,
  [nib](https://github.com/visionmedia/nib) `v0.9.x`,
  [fs-extra](https://github.com/jprichardson/node-fs-extra) `v0.3.x`,
  [uglify-js](https://github.com/mishoo/UglifyJS2) `v2.2.x`, and
  [marked](https://github.com/chjj/marked) `v0.2.x` node packages must be
  installed to build the site. You can install these locally by running
  `npm install jade@0.28.x stylus@0.32.x nib@0.9.x fs-extra@0.3.x
  uglify-js@2.2.x marked@0.2.x`.
* The [knox](https://github.com/LearnBoost/knox) `v0.4.x` node package must be
  installed to deploy the site to S3. You can install this locally by running
  `npm install knox@0.4.x`.
* To fetch submodules, be sure to run `git submodule init` and
  `git submodule update`.

## Building

To build, run `cake build`. To build without minifying/compressing content,
pass the `-d` flag (`cake -d build`). Run `cake` to view other options; these
may also be specified using config.json.

To run a watcher that automatically recompiles files as they are edited, run
`cake watch`. As with before, pass the `-d` flag to build edited content
without minification/compression (`cake -d watch`).

To remove the output files, run `cake clean`.

## Deploying

To deploy, you'll need to specify S3 information. This can either be done via
`config.json` (see `config.json.sample`) or via command line (run `cake` to
view the options).

The actual deployment process is accomplished by running `cake deploy`.
