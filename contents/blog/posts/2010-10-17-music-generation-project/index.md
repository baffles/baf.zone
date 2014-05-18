---
template: blog-post.jade
title: Music Generation Project
date: '2010-10-17T12:37:42-04:00'
tags:
- programming
- school
tumblr_url: http://blog.baf.cc/post/1341288730/music-generation-project
---
As mentioned before, I am writing an application to generate some random music at runtime. I worked on this a bit today, and I’m considering tweaking my requirements a bit. I’m not sure yet if auralizing some data source is the best course of action.

I have written a bunch of code that lays out some random sounds, and it can generate some interesting tunes… most of it isn’t anything I would call music though. I need to decide if I should continue down the road of generating random music, or if I should see how various data sources sound when transformed into music. I need to experiment a little more with this and see where it leads - I’m thinking that I can just take a stream of text data (or whatever), split it up into chunks that are x-bits long (length depends on the range of frequency I want to have), and then generate noises like this.

I’ve got a whole jumble of ideas in my head, so this post is probably incomprehensible, but at least I’m having a little bit of fun playing around with it.