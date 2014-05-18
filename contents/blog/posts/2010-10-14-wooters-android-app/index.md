---
template: blog-post.jade
title: Wooters Android App
date: '2010-10-14T00:14:00-04:00'
tags:
- android
- wooters
- programming
tumblr_url: http://blog.baf.cc/post/1310896204/wooters-android-app
---
In addition to working on BAFIRC, I’ve also been contemplating what needs to be done on the Android client for Wooters.us.

The short todo list:

* Proper notifications - sound/vibrate/etc, all configurable
* Add polling configuration options and enable poll support (aimed for battery saving)
* Get proper app icon, release update to Market

Beyond that, I have also been doing a little bit of reading up on Google’s Cloud to Device Messaging (C2DM) framework. This is, for example, what ChromeToPhone uses for pushing messages to the phone.

I have been granted trial/development access to further explore and develop on C2DM for the Wooters app, so I guess all that’s left now is to actually code make it work. One concern is that Google sets strict quotas on the number of messages we can send, so reducing and optimizing for resource usage will be of utmost concern. I will work on the Wooters app, and begin exploring C2DM during the next Wooters.us Hackathon (which may happen as early as this coming Sunday)!

Keep your eyes peeled for any updates on this.