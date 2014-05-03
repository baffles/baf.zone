---
template: article.jade
title: BAFIRC Progress
date: '2010-10-09T02:39:01-04:00'
tags:
- bafirc
- programming
project: bafirc
tumblr_url: http://blog.baf.cc/post/1274397627/bafirc-progress
---
I was lazy today and didn’t do any work on BAFIRC. I did start looking at the new .NET 4 features, on a tangent, while I was refreshing myself on MEF (I’ve used MEF before, and now it’s integrated in .NET 4).

One new feature I stumbled upon is the new event system, with IObserver/IObservable and the fact that these can be push or pull events. It’s described as being LINQ for events. I’m considering refactoring my IRC layer to use the new event model, though I need to do some more research. It seems really powerful and neat, with one line of code, the consumer can subscribe to only private message events, for example. This should cut down on boilerplate code in event handlers to pick and choose what to respond to.