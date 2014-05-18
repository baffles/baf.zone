---
template: blog-post.jade
title: BAFIRC Plugins
date: '2010-10-17T22:10:31-04:00'
tags:
- bafirc
- programming
project: bafirc
tumblr_url: http://blog.baf.cc/post/1340736231/bafirc-plugins
---
I was working some more on BAFIRC tonight, most notably, on the plugin system. I am going to be using MEF as a basis for my system.

The fundamental idea is that almost everything will be a plugin. There are still some unresolved issues that I need to think out, mainly in dealing with the ability to unload/reload plugins at runtime, but I can leave these features disabled until I’ve worked out what exactly will be happening.

Plugins themselves shall implement the IPlugin interface, which currently just defines an Initialize function that allows the pluginmanager to pass in a management object. This management object will know certain things about the plugin (and, therefore, a new one will be created for each plugin loaded) - including what permissions the plugin has been granted. The plugin is also tagged with an attribute, defining the plugin’s name, description, permissions requested, and some information about an optional interface, if it provides one (more on this shortly). This attribute makes up the metadata as used by the MEF system.

The permissions system is simply a list of permission names (along with a friendly name and description, to be shown to the user, and a trust level, declaring how ‘dangerous’ that permission is). Plugins that provide an interface can also provide a list of permissions that they export, and plugins that need permissions reference them by name in their metadata. The idea is that there will be an interface abstraction that takes into account the permissions granted to it, and can then throw exceptions or ignore certain actions that have not been authorized. There will be some sort of UI where the user will see all permissions required by a plugin and then be able to authorize or deny them to the plugin.

A plugin can also provide an interface, such that other plugins can interface with it. In this capacity, they also define permissions that can be used to restrict how other plugins can do things. An interface type is provided (which is just a C# interface that creates the external view of that plugin). Plugins which provide an interface should also implement another interface, `IPluginInterfaceProvider&lt;InterfaceType&gt;`, which allow functions to be implemented that return a list of exported permissions, and for an interface to be returned (given a set of granted permissions). The plugin should internally implement a class that fulfills their interface (taking into account permissions granted, if applicable) and then return copies whenever asked.

The plugin’s view to the outside world is just their individual plugin manager access layer. From this layer, they will be able to perform tasks such as gaining an interface to another plugin (from the `GetInterface&lt;T&gt;()` method). Permissions are tracked outside the scope of the plugin, within the interfaces.

I’ve implemented a good chunk of this already, what remains mostly pertains to the plugin manager access layer and the permission tracking. I have a few other kinks to work out as well, as mentioned above.

Once this system is done, I will write my first substantial plugin - one that manages IRC connections. Connections will be split up into ‘networks’ which then track their own channels, users, etc. This will be the basis for much of the other plugin functionality, so I’m sure the plugin manager will see some refactoring and tweaking while writing this.