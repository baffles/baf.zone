---
template: blog-post.jade
title: ! 'BAFIRC: IRC Message Parser'
date: '2010-10-04T01:04:12-04:00'
tags:
- programming
- bafirc
project: bafirc
tumblr_url: http://blog.baf.cc/post/1240785286/bafirc-irc-message-parser
---
I began working on the IRC layer tonight. Part of that was implementing an IRC message parser.

I tested out the use regular expressions in writing it. I have a fairly complex expression that can capture the values from any RFC-compliant message. Works great!

I put this up against a non-regular expression implementation (from cbots) to benchmark. The non-regex version is roughly two times faster than my new regex version. I am currently debating if I should keep the regular expression parser (which has cleaner looking code, coupled with an ugly expression) or adopt an approach similar to what cbots does (which gives uglier code, but is faster). On my machine, the difference, in practice, is negligible. Regular expression parsing takes 77ms to parse 11000 messages, whereas the same set run through the cbots parser takes 33ms. Performance will be good enough in either case.
So it comes down to which implementation I should use, and I’m not sure what I’m going to do.

On a side note, with school and work, it may be a few more nights before I can set aside enough time to make any more notable progress.