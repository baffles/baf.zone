---
template: article.jade
title: BAFIRC Tweaks
date: '2010-10-15T03:43:25-04:00'
tags:
- programming
- bafirc
tumblr_url: http://blog.baf.cc/post/1318937415/bafirc-tweaks
---
I was reading a random article on the minor threading differences in .NET 4.0, and learned that Thread.Interrupt (what BAFIRC was using to kill its threads) was just as horrid as Thread.Abort. .NET 4 adds new cancellation methods which make it quite easy to enable your thread to be cleanly signaled to exit, so I went ahead and did some minor refactoring to fix the threading model used by the connection class.

Tomorrow, if I end up having enough free time around all the other crap I need to get done, I will lay down some new code. Right now, I am torn as to where the network/channel tracking will fit in. Part of me wants to use a plugin to manage the channels, which I am thinking I will do, but I need to figure out how exactly I want this interaction to work.

I also need to lay down the threading system. Using MEF of course, I will lay down a basic plugin model that I have in my mind and see how that works out.