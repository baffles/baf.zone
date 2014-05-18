---
template: article.jade
title: ! 'BAFIRC Plugins: More Thoughts'
date: '2010-10-19T00:22:25-04:00'
tags:
- programming
- bafirc
project: bafirc
tumblr_url: http://blog.baf.cc/post/1348986760/bafirc-plugins-more-thoughts
---
I didn’t have much free time tonight, so I didn’t write any new code for BAFIRC, however, I did sit down with a pen and paper and think through more specific details of how the plugin system will work, with respect to loading plugins.

The list of imports provided by MEF will be used as a list of available plugins. This isn’t exactly the way MEF was designed to be used (from what I can gather), but it is an acceptable use case. We can look at all available plugins along with their metadata, and determine which ones to load. They will automatically be loaded and instantiated once we try to access the value; so this is fully automated. \[Note: I am looking at the underlying APIs, most notably the catalogs and related functions. I may be able to create my own implementation that is similar to CompositionContainer, which will allow me to view types and such. I am undecided as to how detailed of data I need in order to display to the user — i.e., do I want to know the filename? fully qualified class name? trust the name reported in the metadata? what about duplicates? These issues still need to be thought out. The more I think about it, the more I think that it is a good idea to enumerate all the pieces myself and to build my own metadata.].

Any time the imports are satisfied, I can refresh my list of available plugins, and load any unloaded plugins that are trusted, have the same permissions trusted as they are requesting, and are unloaded. Once I take an instance, I store that in a separate loaded plugins area for future reference. Unloaded plugins only have their metadata stored - therefore the user can authorize and load the plugin at will. Plugins can either be loaded one time, or set for auto load (with auto loading caching the permissions granted. If the plugin changes to require more permissions, it will be put into another list, for the user to re-authorized). 

MEF requires a different fundamental thinking of the plugin system. MEF composes using ‘parts’ - where one dll may contain many ‘parts.’ For our purposes, a plugin is one part, so one dll may, in fact, contain many different ‘plugins.’ This is mostly a semantics issue that may need more investigation as well - I’m not sure. I think that for the most part, it won’t matter much. The only difficulty will be in identifying what file each piece comes from, should the information be displayed to the user.

Another thing to note is that, due to the nature of Assembly loading in C#, once I load a plugin I cannot unload it without restarting the app. This issue can be ameliorated by creating a separate AppDomin and marshalling between the domains for all plugin interaction. This will cause a performance hit, however, so it may not be worth it.