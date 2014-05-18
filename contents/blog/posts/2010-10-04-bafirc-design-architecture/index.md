---
template: blog-post.jade
title: ! 'BAFIRC: Design Architecture'
date: '2010-10-04T14:00:26-04:00'
tags:
- bafirc
- programming
project: bafirc
tumblr_url: http://blog.baf.cc/post/1243437011/bafirc-design-architecture
---
I’ve made a very important design decision in regards to BAFIRC and how processing of IRC actions (and, really, most anything else) will be handled. Perhaps some of you are familiar with \*nix, and how, generally, everything is treated as a file. I’m adopting a similar approach - everything is a plugin.

Handling user registration and server ping/pongs? A plugin. Handling CTCP requests and replies? A plugin. Handling DCC? A plugin. Organizing messages into their respective user/channel buffers? You guessed it, a plugin.

I will implement a basic API that allows the plugins to interact with and control most anything in the core/client. Beyond that, a plugin will handle the rest. This allows me to keep everything very modular, and have no problems with figuring out where certain control logic fits in. The various layers in the code (such as the IRC layer) will be very minimal, and anything beyond the most basic of functionality will be implemented in a plugin.

I have, on paper, sketched out how some various pieces will look like, but nothing has been set in stone. I will implement my base plugin system using MEF (which, if I am not mistaken, was added to .NET as of 4.0). Plugins will be able to act on the core or on the client. There will be a basic API that will be the same whether the plugin is on the core or on the client, and there will be specific API extensions for core- and client- specific plugins. An example of a core-specific plugin would be the logging plugin, whereas an example of a client-specific plugin would be a /sysinfo or /winamp type of deal. It is also conceivable that a plugin could run on both the core and the client, and establish a communication channel between the two.

I have not yet decided how I am going to implement the core/client communications, but I do plan on supporting named channels between the two, so that plugins may talk with themselves, and other similar uses. I may just go with an XML channel, but I need to analyze whether or not this will fit my needs without being too wasteful. It’s an obvious solution for ease in developing clients for different platforms, but there is a bit of overhead, both in the XML itself, and the construction/parsing of it on either end.

DCC will be handled by the core and the client. I will likely support DCC proxying from the core, and for performance sake, support direct connection to the client in some cases. The core will be configurable with a default action, and clients will be able to override this action. I haven’t decided on how the client will be able to do this yet - whether there will be a notion of an ‘active client’ where the most recently used client can either handle or defer it to someone else, or if it will be more of a race, first client to respond gets it. In the case that all clients defer or none respond within a certain timeout (or if no clients are connected), the core performs its default action. Files can be sent from/received to either the core or the client (and transferred to/from core storage), though chats will likely always be proxied through the core.

I may have written down more things than I am remembering right now, but this is all that comes to mind. Perhaps I’ll be able to muster up the time to do some more coding tonight.