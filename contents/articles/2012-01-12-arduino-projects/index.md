---
template: article.jade
title: Arduino Projects
date: '2012-01-12T00:18:54-05:00'
tags:
- programming
- arduino
- motorcycle
project: bikeac
tumblr_url: http://blog.baf.cc/post/15711334291/arduino-projects
---
I’ve been playing a bit with Arduino lately. My current project actually involves creating some hardware to go with it. I dislike the heat, which makes riding my motorcycle uncomfortable at times in the summer, especially on the really hot days. I stumbled upon the concept of a cooling vest - one style of which involves flowing cold water through tubes in a vest to cool down the core of your body. All commercially produced systems using this, however, require that you load a cooler with ice to provide the cold liquid to circulate through the system.

This got me thinking. I don’t want to have to screw around with ice, especially if I’m on a long ride or something. How much cooler would it be to be able to cool the water in some other way?

I’ll go into more details about this project at a later point, but right now, I’ve got a peltier unit sandwiched between a CPU heatsink/fan and a CPU water block. This, coupled with a water pump, allows me to remove heat from the water. This cooled water would be stored in an insulated container, and used to circulate through a cooling vest. As the water warms up from body heat, it can be re-cooled by the peltier unit again. To bring this project full circle, I am planning on controlling every aspect of the system using an Arduino. As mentioned before, I’ll delve into deeper details on this at a later point, but things such as monitoring temperatures, controlling water pump speed and peltier output, and even estimating cooling capacity and power consumption are the target of this system.

In the pursuit of this target, I’ve dumped a few hundred dollars buying Arduino parts and a bunch of miscellaneous sensors. I’ve begun to play with the system as a whole - which really isn’t too hard to pick up. My last foray into microcontrollers involved PICs and writing assembly code, so the familiar gcc compiler and community provided libraries for the Arduino family is a nice change of pace.

While playing around with Arduino, though, I’ve begun to think of several other projects that I may tackle at some point. They all sound fun:

A DIY weather station setup. Given a bunch of sensors, I could record weather data in my backyard, and even submit to Weather Underground. Bonus points for solar powered sensors that communicate wirelessly to a central Arduino brain, which can then use ethernet or wifi to report the info directly online, with no computer required.

An LED cube. They’re just plain awesome. Even cooler would be an RGB LED cube, though that presents some interesting issues (due to the fact that I want full PWM control of each voxel in the cube). Multiplexing a digital, single color cube isn’t a big deal, but when going to RGB in this fashion, you now have to control three times as much hardware, and deal in analog as well.

Remote car starter. Not the car starter itself, but an extension to it. Using one of the fancy GSM modules for Arduino, it would be cool to be able to start my car remotely over the internet. The only thing holding me back here is that my current vehicle doesn’t have a remote starter.

LED brake/tail light and blinkers for my bike. Use Arduino to control them, so I can add some attention getting features (such as strobing the brakes and/or blinkers when I tap the brakes). This was actually a project I was envisioning doing with some sort of microcontroller, before the cooler idea and before I knew much about Arduino.

A bright RGB light for my room. Doesn’t necessarily need to have individually addressable pixels, but it would be cool to replace the ceiling mounted light in my room with such a beast. The challenge here is getting the thing bright enough to light the room, and doing it affordably (these challenges rise from the desire for full RGB).

I’m sure I’ve had other cool ideas that I’ve forgotten about. These are the cool ones that come to mind right now.

Anyhow, look for more posts on this subject later. In tandem with my current Arduino project, I’ll likely be reimplementing community-sourced libraries for hardware interfacing that I’d like to see done a different way. This includes a library for text LCD control, for interfacing the 1-wire temperature sensors I’ve purchased, and a library for handling buttons for a user interface.