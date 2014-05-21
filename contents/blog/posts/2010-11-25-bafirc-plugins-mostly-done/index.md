---
template: blog-post.jade
title: ! 'BAFIRC Plugins: Mostly Done?'
date: '2010-11-25T02:17:49-05:00'
tags:
- bafirc
- programming
project: bafirc
tumblr_url: http://blog.baf.cc/post/1678263016/bafirc-plugins-mostly-done
---
So, after a lengthy hiatus on BAFIRC, I finally got around to doing some more work on it tonight. I worked more on the plugin system - implementing plugin enumeration using the composition provided by MEF. I'm not going to worry about the issues I brought up in the last post or two, rather, I'll just see what happens as I move along. I also have implemented a permissions system with the plugins, which is probably overkill for the use BAFIRC will see, but it doesn't hurt.

I'm somewhat happy with the path the plugins have taken. I also began to work on an IRC management plugin - a plugin wrapper for all of my base IRC things which manages multiple connections, reconnection, identities, etc. It has a slew of permissions to allow other plugins to interact on different levels. Once I've finished implementing that, I can go ahead and wrap a GUI around it and have it work. Or, create my own bot out of it.

I've been considering making a bot using all of this base code as well. One interesting approach to take would be to make the GUI a plugin itself, and then have the main BAFIRC executable just load plugins - and only load the GUI when it's being used as an app (and on the end machine). This would let me do fancy things like conceivably have different UI implementations as well as do crazy things like inject the UI into a running bot. The bot could take advantage of the bouncer architecture as well - running all of the useful plugins in the "client." This allows me to then ‘restart' the client whenever necessary to unload/reload plugins, and not have the bot drop offline. Same idea with using it as an IRC client as well. This way, only your core plugins (which are less likely to change often) will require a total restart/reconnection.

Anyway, enough rambling for tonight. Still loaded to the brim with school work, so progress may still be slow yet for a few more weeks. Happy Thanksgiving!