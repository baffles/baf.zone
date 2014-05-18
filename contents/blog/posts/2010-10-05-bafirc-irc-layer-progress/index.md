---
template: blog-post.jade
title: ! 'BAFIRC: IRC Layer Progress'
date: '2010-10-05T00:13:32-04:00'
tags:
- bafirc
- programming
project: bafirc
tumblr_url: http://blog.baf.cc/post/1247197138/bafirc-irc-layer-progress
---
I spent a chunk of time working on my IRC layer some more tonight. I did the busy work of ensuring my list of commands and replies was fairly exhaustive according to the RFCs, and implemented static functions for almost every possible command/parameter combination allowed by the RFC. This was not strictly necessary, just more of syntactic sugar for use in plugins/etc, but it makes the interface a lot nicer - i.e., rather than calling ‘new IrcMessage(IrcCommand.Privmsg, “#channel”, “hi”);’ you can call ‘IrcMessage.Privmsg(“#channel”, “hi”);’). This makes it easier to use without any knowledge of the RFC, and less error prone.

After completing that, I moved on to begin laying the framework for the IrcConnection class. I did a rough layout of the class and its members and methods, and began implementing a little. The guts of the connection management thread still need to be filled in, as do the relevant chunks of code to handle the management thread itself. Other than that, I wrote the event management system. So far, there are only four events (remember, this is a very thin layer above the IRC protocol) - ConnectionStateChanged, MessageReceived, MessageSent, and MessageSending. Note the difference between the sent and sending events - MessageSent is fired after a message is queued for sending, whereas MessageSending is fired before the message is queued, giving plugins the chance to review the message, possibly editing it or throwing it away all together. This may sound risky from a security standpoint, but remember, plugins should already be trusted by you anyway. They’re compiled code running on your machine, and have access to all messages sent and received anyway.

Hopefully I will have time tomorrow night to finish implementing what needs to be done on the connection class. It will support SSL and binding to a particular local IP, and will have configurable queuing settings. I haven’t figured out what these configurations will consist of, but likely will involve a flag to turn on or off queuing, and some values to specify what the maximum sustained rate of sending and burst rates are. I’m thinking number of messages (or bytes?) per second will be the values. It will track how much you are sending, and once you exceed the burst rate, it will kick in and throttle messages back to the sustained rate, until the queue is empty (and perhaps, a configurable penalty time has passed).

That’s all for now! Once I’ve implemented my IRC layer (and implementing, or at least stubbing out, the CTCP and DCC layers) and tested it a bunch, I will begin building the plugin system, implementing the pieces required for dealing with IRC.