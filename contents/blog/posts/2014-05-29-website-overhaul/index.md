---
template: blog-post.jade
date: '2014-05-29T22:53:00-04:00'
tags:
- programming
- website
- web
project: website
title: Website Overhaul
---
It's been a long time coming, but I've finally overhauled my site! Actually,
I've only just begun the process of doing so, but it's in a state of being able
to show it off. I've still got some more things I'd like to do with it, but it's
off to a good start already.

I'll begin by giving a quick overview of the current state of things. I'll dive
into deeper details about everything in future posts.

## What I've Done

The most glaring change is the new design. It still needs some work, but in its
current state, it's a pretty close cousin to the [Pure CSS blog layout] [1].
I'll be tweaking and refining it as I add new features.

  [1]: http://purecss.io/layouts/blog/

Perhaps more subtle is the fact that the site is 100% statically generated now.
My old homepage (at baf.cc) was statically generated and hosted using Amazon S3
and CloudFront, but that was just a simple contact card page. My blog was hosted
with Tumblr.

Now my blog posts are stored right in the [git repository] [2] where the rest of
the site content is stored, and all of the blog content is rendered to HTML at
deployment time. This greatly simplifies the hosting of the site. I can retain
full control over the site itself while still being very flexible on how and
where it is hosted.

  [2]: https://github.com/baffles/baf.zone

Another upside to how I've done things is that I gain full version control for
all of the site content, and retain absolute control and ownership of the
content. I don't need to worry about what happens if Tumblr disappears, nor am I
locked in to their infrastructure anymore.

As far as the name, you may notice the new domain name (baf.zone). I've used the
name 'BAFZone' on and off before for my personal site, and with the new `.zone`
TLD, it seemed like a perfect fit. I've pointed baf.cc and blog.baf.cc at
baf.zone and have made sure that any old Tumblr permalinks will continue to
work. I'll discuss the specifics of that later.

## What I Plan to Do

I'd like to extend the site to include information on all my projects. I have a
[separate site] [3] right now where I was trying to write up information on
projects, but this has proven to be too isolated and difficult to maintain.

Moving forward, I'm going to implement a projects section right on this site,
with whatever writeups and information I generate for the project, as well as
having it all linked in with blog posts. I've already added the appropriate tags
to all of the imported blog posts to make this possible.

## More Details

I'll dive deeper into all of this in future posts, so if you're at all
interested in what I've done or how I've done it, be sure to stay tuned!