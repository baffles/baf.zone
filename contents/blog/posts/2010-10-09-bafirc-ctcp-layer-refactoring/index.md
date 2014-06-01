---
template: blog-post.jade
title: ! 'BAFIRC: CTCP Layer Refactoring'
date: '2010-10-09T17:33:00-04:00'
tags:
- bafirc
- programming
project: bafirc
tumblr_url: http://blog.baf.cc/post/1278526770/bafirc-ctcp-layer-refactoring
---
So, I've refactored the CTCP interaction in the core IRC connections - mostly to just neaten things up and do them in a way I feel is much more cleanly done. This didn't change functionality at all.

I also added some helper methods to get IObservables for the main IRC events, which just wrap the existing event handlers. This is purely added functionality, allowing .NET RX to be used much more easily, rather than having to manually calculate the observables from the events yourself. There are also some extra methods that allow filtering on command type (so with one function call, you get an observable for only one type of message (e.g., privmsg) that you can then subscribe to, or filter further).

To go along with this, I did end up creating another CTCP layer that sits on top of the IRC layer. The core layer still differentiates between regular privmsg/notice and ctcp/ntctp, and the CTCP layer just extends the functionality by making the data easier to access, reply to, and work with. Also featured in this layer are some extension methods that allow you to get CTCP events - notably CTCP received and CTCP sent, along with some extra filtering options (mimicking those in the irc layer).

These changes are mostly minor, but they do enable you to do more powerful event filtering easier and with less boilerplate code. For example, before these additions, in order to reply to a CTCP PING, you would have to write the following code:

```cs
// given IrcConnection conn;
conn.MessageReceived += (s, e) =>
{
	if (e.Message.Command == IrcCommand.Ctcp && e.Message.Parameters[1].Equals("ping", StringComparison.OrdinalIgnoreCase))
		conn.SendMessage(IrcMessage.NCtcp(e.Message.From.Nick, "PING", e.Message.Parameters[2]));
};
```

With these additions, responding to a CTCP ping is simple:

```cs
var pingRequest = conn.GetCtcpMessageReceived(CtcpMessageType.Request).Where(request => request.Command.Equals("ping", StringComparison.OrdinalIgnoreCase));
pingRequest.Subscribe(ping => conn.SendMessage(ping.CreateReply(ping.Data)));
```

The main strength, at least from what I've seen so far, is that you gain the ability to filter and join events using LINQ. So in this case, we filter down a CTCP Request (and, the GetCtcpMessageReceived() function just filters the more generic MessageReceived event from the irc layer, using LINQ) down to a PING request, and then subscribe to that specific event, and handle it by sending an appropriate ping reply.

I will definitely be exposing all events to the plugins like this. Depending on what turns out to be easier, I may keep the same event model for firing events, but the Observable wrappers over these events are very powerful and make the code much more concise (just like LINQ does).

Note that the LINQ code is, as most LINQ code usually ends up being, much more dense. I usually tend to split things up over lines to ease in readability, and help keep individual lines short (I usually create a new line at each part of the chain). There's also the LINQ syntax, which looks more like SQL than C#, which is just turned into these chained function calls by the compiler anyway. The LINQ-ified code can be harder to read, especially when you're not familiar with LINQ, but I find it tends to be more result-oriented. Rather than looking at a bunch of if statements and crap, you're being much more declarative in what you want. Rather than saying "give me everything, and if some condition holds, do this," you're saying "I don't care how you do it, but give me things for a certain condition, and then do this." The example I gave above was trivial, but I've seen some much more complex examples involving sequencing that make the LINQ code *much* easier to write and less messy - such as [this](http://stackoverflow.com/questions/1596158/good-introduction-to-the-net-reactive-framework/1749252#1749252).

I got way off on a non-BAFIRC related tangent, but LINQ is awesome. It's one of those things that seems questionable or even useless, but once you start using it and thinking in terms of ‘how can I do this with LINQ' it becomes much more useful. I find that it encourages you to think in abstract steps, rather than focus on how to actually implement what you're doing, and then you can stay at those abstract steps and let LINQ figure the rest out.