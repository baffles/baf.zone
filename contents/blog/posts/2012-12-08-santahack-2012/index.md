---
template: article.jade
title: SantaHack 2012
date: '2012-12-08T14:36:08-05:00'
tags:
- santahack
- programming
project: santahack
tumblr_url: http://blog.baf.cc/post/37493791389/santahack-2012
---
Following SantaHack 2011, the site needed a bit of work. Namely, support for hosting the competition across multiple years (and allowing prior years data to be shown), and to clean up the backend code, which was some pretty crappy PHP based on Symfony (which was hugely overkill for a site of this magnitude).

Not much at all has remained the same. The new system is written in Coffeescript (which compiles down to JavaScript and is then run on Node.js). MongoDB is the database of choice now, and all of this is hosted on Heroku. It’s also my first major foray into Git, as Heroku uses Git for pushing new code to be hosted. I’ve got properly separated dev, staging, and production environments now (before, I had separate codebases, but it usually went back to the same database). The pages are all templated using Jade. CSS is written using Stylus, and all JavaScript is written in Coffeescript. I’m also using Twitter Bootstrap for some of pieces of styling, and jQuery for a bunch of the dynamic/AJAX stuff. I’m using numerous Node packages on the serverside; I may elaborate more on that later.

The site itself also much more dynamic. Wishlists are saved via AJAX and votes are stored instantly via AJAX. I have yet to write the entry submission page, but that will be dynamic as well. I’m also planning on adding a blogging feature, which allows participants to blog as they write their entries. Blogs will be private during the event, and made public at the same time their entry is. User supplied content (aside from data that is stored in the database), like entries and blog screenshots, will be stored on S3. And, since I know there are some folks in the community who like to block JavaScript, all of the JS addons are simply upgrades. If JavaScript is disabled, the site still functions fine in a more traditional way.

The code is much cleaner this time around, which is surprising given this is my first time using most of the technology at play here. About the only thing I have prior experience with is HTML, CSS, and to some extent, JavaScript.

Anyhow, I’m liking these new technologies so far, and look forward to working with them in the future.