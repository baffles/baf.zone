# My Website

This is the source to my website.

TODO: document the gruntfile tasks, wintersmith plugins, etc

## grunt-s3

I've made a bugfix to `grunt-s3` related to globbing. Until the fix gets merged upstream (and
subsequently released), I'm loading the s3 tasks via a submodule reference to my bugfix branch.

For this to work properly, you'll need to:

* `git submodule init` in the root of the repo
* `npm install --production` in the grunt-s3 subfolder

Afterwards, grunt will work properly.