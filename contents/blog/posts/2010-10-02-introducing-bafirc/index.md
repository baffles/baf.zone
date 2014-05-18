---
template: article.jade
title: ! 'Introducing: BAFIRC'
date: '2010-10-02T19:49:00-04:00'
tags:
- programming
- bafirc
project: bafirc
tumblr_url: http://blog.baf.cc/post/1231252181/introducing-bafirc
---
Man, I’m doing it again - putting off my school work. That’s alright, because I’m just going to do a braindump, and then start on the work I need to get done (unless other distractions present themselves, like fixing and eating dinner).

Anyhow, I was just talking with Sevalecan, and we got into an interesting discussion. Both of us, for many years, have always talked about creating our own IRC clients. Both of us, however, never manage to actually finish them. I guess the fact that it’s sort of a dreamy personal project takes its toll. My personal experience (and, I would bet the same thing that happens to Sevalecan) is that I end up wanting everything to be perfect. Analysis paralysis, as it’s called. You code one portion of the project (or, worse yet, don’t even finish coding it before scrapping it), and find some flaw in it and decide to rewrite it. This happens over and over again, and, as its name implies, it paralyzes you.

I have a pretty lengthy feature list for BAFIRC, and I really would like to have it finished. I’ve sort of lost interest in the project, which may actually be a blessing in disguise, insofar as I won’t be concerned with it being 100% perfect. But at the end of the day, I really would like the project to be complete.

I was inspired by the movie The Social Network and was intrigued to see Zuckerberg blogging his progress of creating facesmash (this may or may not be true, the movie is highly dramatized). At any rate, I’ve seen other people doing the same thing on their projects, and it finally seems like both an interesting and useful idea to me. So I’m going to give it a try.

Whew. Now that we’ve got that out of the way, let’s lay the groundwork for BAFIRC. I have a list of features in mind that would create a pretty awesome IRC client that totally owns anything out there today. I’m going to attempt to list all the features here, though I am sure I will miss some. BAFIRC will be coded in C#, likely with .NET 4.0. I will likely use either Forms or WPF for this, I haven’t decided which yet, but I’m leaning towards WPF if only for the learning experience.

## Proposed Features:

- Core/client architecture - built in bouncer, similar to Quassel (the IRC client I currently use). The idea here is that you toss the core server in one place (such as a dedicated/colo’d/virtual server someplace) and then connect to it from everywhere else. This keeps you IRCing from one nickname, lets you see all your logs no matter where you are, and makes it easier for others to get a hold of you on IRC.
- DCC support - one area where Quassel fails is with DCC support. Meaning, it doesn’t support it at all. I am not quite sure how I am going to solve this problem, but BAFIRC needs to support DCC.
- Plugin support - another area where Quassel fails is that it doesn’t support plugins. I’m not really sure what plugins mean to BAFIRC, but there does seem to be two classes of plugins to support - server side plugins which affect the core, and client side plugins. Server and client plugins can talk to each other as well.
- Bouncer support? One thing that CGamesPlay and I discussed when we were talking about creating an IRC client at one point was to use a modified IRC protocol to handle client/core communications, and in the process, allowing any vanilla IRC client to connect as well. This is an interesting feature - I’m not sure if I will implement it right off, but it does seem like something that would be neat.
- Webchat support - one idea I’ve always liked is having a built in minimal HTTP server. This way, I could connect to my BAFIRC core from a web browser (with an interface like CGI:IRC or mibbit.com) and view/search logs, chat, etc. I’m not totally sure on how this will be implemented yet, but it is something I would like.
- All standard IRC client functionality - all standard functionality for an IRC client needs to be there as well. Logging, nick highlighting, colors, CTCP support, etc. Oh, and a good UI as well. Of course, this is all of concern on the client side, and sort of a given, but it is worth mentioning.
- Multiple network support - I frequent multiple IRC networks, so I definitely need support for being on multiple networks. This shouldn’t be very hard to manage at all.
- Logging - I’ve alluded to this already, but I do need a good logging system. I’m unsure if I want to log to a database (seems wasteful), or just plain text logs, but I want fully searchable logs. An infinite scroll-back would be nice too (like Quassel has), where as you scroll up, more and more back logs are loaded to fill the buffer. The ability to import and de-duplicate old logs would be nice too, but far from a necessity.
- Best client ever - This needs to be the best IRC client ever. :) It needs to pound everything else into the ground.

I’m sure I’ve missed several things, but I can always amend the list as I go. At this point, I need to move ahead with laying out some sort of design for how everything will be split up and fit together, and then start laying down some code. I’m going to (hopefully) blog everything as I go, in the hopes that it will keep me motivated and help me actually accomplish things. Time is fairly tight with school and work right now, so no promises on what sort of time frame I’ll complete anything in though.

-edit-

Sev mentioned another great feature that I didn’t list - youtube embedding. Quassel shows you a preview of the webpage on hover. Embedding youtube links directly into the video would be an awesome feature, along with hovering over URLs to see a preview. Another useful feature? Clicking on shortened URLs shows you the actual destination before you click (or possibly on hover - just make the HTTP request and show the final destination URL in a tooltip).