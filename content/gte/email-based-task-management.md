---
title: "Email based task management"
date: 2021-05-11
draft: false
---

It’s a rough estimate, but I think there about at least a billion apps and systems out there that can help you organize your daily tasks. All of them suck. Task management apparently is a very personal thing.<!-- more -->

Since I too am a person with things to do, I tried a lot of them, but none of them would fit me well enough to just pick it and leave it at that. I kept trying new ones and configure them to my tastes, over and over again. Some call it “productivity porn”, spending more time with the system then with actually doing stuff. There may be some truth in that, but a task management system should fit you. Just like a pairs of shoes should fit your feet. If they don’t, over time the agony will build up and at one point your feet hurt so much that they all feel wrong. When that happens, the only thing you can do is lie down on a couch for a while with your feet suspended in the air. After that, you want to get something that is tailormade for you. And since I am also a developer, the only natural next step is to be my own cobbler and build it myself.
Requirements

* Open source/own my own data.
* Works on all my devices, with native apps for the ones I use daily.
* Does not cost a ridiculous amount of money.
* Is synced, but can handle asynchronous life.

The first two points seem kind of obvious to me, but in practice they already eliminate every existing solution out there. A lot of companies charge money and try to make things “easier” by building “special” apps and services that can work together seamless. However, that only works if you stick to their plan and their plan only involves the kind of people they consider normal or mainstream. Or just the subgroup of them that wants to spend money on these kind of things.

My devices are: a few Linux laptops and one or two phones. On the laptops I spend most of my time in terminals. My daily phone runs SailfishOS. My soon-to-be daily phone is a Pinephone and runs Mobian, so Linux again. Both can run terminals, but have quite a different form factor. An app would be nice there. This combination alone already rules out everything I encountered.

For the money part, I am not against paying for a service and in fact I have paid for some of the ones I tried for a longer time. However, I felt cheated each time. A task is basically a line of text. A bit more if you add a description and metadata, but it should occupy less than a speck of dust on our gigantic hard drives. Still, companies charge a couple of euros a monh for this, which doesn't sound like a lot, unless you start to compare it to other types of services. Take Netflix, for instance, which is in the same ballpark, but is able to deliver multiple streams of non-stop HD video for that money. Try counting the bytes on that and see how many tasks you could fit in there. Or take the subject of this project: email. You can get gigabytes of email storage for free, or almost free if you don't want to be exploited. Aside from storage there is spam filtering, interoperability, a web interface, etc. Email hosting sounds a lot more complicated than hosting a few lines of text with some checkboxes you can tick. Yet most of the time, the latter costs more.

The last item, handle asyncronous life, is not something that I had many problems with so far. Most existing solutions can handle this. What I mean by that is that it should be possible to be offline for a while, while working with the app and then, when connectivity is restored, all changes get synced between the devices. All solutions rely on a central server to manage the recurring tasks, conflict resolution, etc. to manage this. It could be nice if the system worked without a central server. But in any case, if there is a need to synchronize and somehow this leads to conflicts, I would like to have a basic interface to resolve them.
Email is the (almost) solution

When you think about it, in light of the above, tasks map really well to emails:

* Both are a collection of separate units with a title and a description.
* Every device on the planet has a client for it.
* Synchronisation and resilience is built in.
* Lots of options for hosting, can be free or nearly free.
* Easy integration, most tools have a way of sending a mail on a trigger.
* Organizable in folders.
* Can potentially have attachments.
* Easy coorperation. Can have joint task lists with a separate account, can also send to lists of other people.

Drawbacks

The more you think about it, the more logical it seems to store your tasks as emails. There are a couple of things to figure out however and of course there are drawbacks:

* User interface. How to update a task?
* Encryption.

Creating tasks seems easy, just send an email to an account and it's there. Delete it after you've done the thing and it's gone. But often, especially when you follow a GTD-style approach with an inbox for "stuff", you want to separate the creating of the tasks from editing and finalizing the tasks. This can't be done directly. Although some email programs and webapps have a "Drafts" folder with emails that you can edit before you send them out, there is no standard way of doing this and it is not always possible to do this on every system or protocol. The trick of getting this to work is to figure out a way to edit emails that works in every email client.

Another thing that is certainly not possible with every random email client is encryption. There is no way to encrypt an email that works with every client without a lot of error-prone user interaction and configuration. So having the requirement that it works everywhere rules out the possibility of storing your tasks encrypted. This is unfortunate, but this is a trade-off that can't be worked around, I think. At least for the moment.
First version

With the above ideas in mind, I created a very, very limited prototype and I have been using it exclusively for some time now. I am convinced that this is something that could work well, so I am going to continue developing it. Code is [here](https://codeberg.org/ewintr/gte). Stay tuned.
