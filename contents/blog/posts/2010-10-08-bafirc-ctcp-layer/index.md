---
template: blog-post.jade
title: ! 'BAFIRC: CTCP Layer'
date: '2010-10-08T03:38:02-04:00'
tags:
- bafirc
- programming
project: bafirc
tumblr_url: http://blog.baf.cc/post/1267900622/bafirc-ctcp-layer
---
So, I was working on the CTCP layer tonight. I had planned to keep it a separate entity, and then debate ensued over how to actually implement ‘CtcpMessage' - whether it should subclass IrcMessage, or be composed of it. After a lengthy discussion, I decided to just add it into the core IRC layer, with two new pseudo IRC Commands - CTCP and NCTCP, CTCP being for requests/extended data messages (like ACTION) sent via privmsg, and NCTCP being for replies sent via NOTICE.

I'm not totally sure if I like how I actually implemented this, I'll have to sleep on it and see in the morning. I created a CtcpHelper class that looks at IrcMessage objects and maps back and forth the commands. When parsing a message, it checks if it's actually CTCP, and if it is, forges the command type appropriately (it also rebuilds the parameter list, privmsg/notice only have two parameters, a destination and a message, but CTCP/NCTCP have three, destination, ctcp command, and ctcp data). This isn't too bad.

The part I'm still not totally sure on is constructing it back to a string that can be sent to the IRC server. In here, I added another path to my if statements that maps the command back if it's a CTCP message, and then when I actually print the parameters out, it calls another function in CtcpHelper to "unbuild" the array, dumping it back to destination/message and formatting the message into CTCP format.

Anyway, this is probably about as clear as mud. I'm pretty tired right now, and I was even making some stupid mistakes while coding. I'm going to go to bed and sleep a good long while (until I wake up, rather than until the alarm wakes me). If need be, I'll revise or rewrite this post tomorrow.