---
template: blog-post.jade
title: ! 'BAFIRC: The IRC Layer'
date: '2010-10-03T22:43:43-04:00'
tags:
- bafirc
- programming
project: bafirc
tumblr_url: http://blog.baf.cc/post/1239982855/bafirc-the-irc-layer
---
The first piece of BAFIRC is going to be the IRC communication layer. This layer will be totally standalone, making it easy to write first and test. There are several standalone pieces, but moving beyond that, everything will build on what has come before it.

I have thrown together IRC connection layers many times, using several languages. I could pull in one I’ve written before, but I’m starting from a totally clean slate and attempting to take advantage of the latest language features.

The IRC layer is fairly simple. The basic layer will support basic RFC IRC, including message parsing, message sending, message queuing (including a throttling layer to prevent you from flooding out the server and getting killed), all RFC defined commands and responses, and likely CTCP support. I am still undecided as to whether or not to include CTCP support in the base layer, as it is sort of an addon. DCC support will be separate, so I may make CTCP separate as well. I will provide hooks for these “addon” layers to plug in to, just to keep everything clean and modular.

I think I’m going to adopt an architecture similar to cbots as far as processing messages goes. I’m planning on having a single background thread that will manage both waiting to receive messages and sending messages (timer-based, to support message queuing). Once a complete IRC message is received incoming, it will be parsed down into an object and sent off to event handlers. Events will be fired for everything, giving a place for the core (or plugins, or any other non-BAFIRC uses) to plug in to and control anything.

That’s about all that comes to mind right now. The layer needs to be standalone enough that I can write a simple test program to get it on IRC. Once that is complete, I can begin working on other parts of the client, including the core server, web-chat support, logging system, etc.