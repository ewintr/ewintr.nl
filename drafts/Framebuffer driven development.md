#schrijven 

**Executive summary:** By utilizing the framebuffer present on a Linux system, it is possible to guide the developer towards a more focused and productive workflow. This article elaborates on the reasoning behind FDD, some examples of steps to take and some experiences gained by following these steps in the field. This all to answer the main question: is this satire, or is it not. The answer turns out to be... it's complicated.

## OK.. So what is a framebuffer anyway?

A framebuffer is what you get if you take a laptop with Linux (and presumably other systems) and remove all graphical capabilities. On most laptops it can easily be experienced by pressing something like Ctrl-Alt-F1, Ctrl-Alt-F2. One can switch back to ones cosy desktop in solarized dark with Ctrl-Alt-F8 (or Ctrl-Alt-F7, depending on your distro).

If you do that, you will be greeted with a sober login prompt. If you login with yor normal username and password, you will have the same thing as if you opened a normal terminal window. The difference is nly that you can have only one. It will always be maximized. Your mouse does not work. An you only have 16 colors, instead of the normal gazzilion. One of them is bright black.

## How came this experiment to be?

Two things came together. The first one is that I am old. Being old priviliges you with a sense of nostalgia. Looking back to the pat with rose tinted glasses and deciding that things used to be so much better, because you didn't want to remember the bad sides of it and you forgot them. It is with this sense that I liked reading about the retro computer challenge. In this experiment some people tried to only use old, limited hardware to do all their computing needs, including work. 

If you read the reports, you will find that almost everyone found it a very positive experience. Making their computer more limited, also limited the things they could do with it. If you are bored for a moment, and yu want t look at some tweet for distraction, you think twice if that means that switching from one program to the other takes five minutes.

Despite all this positivity, none of the participants report that they keep using their old gear and will sell their modern laptops. So the limitations are good, but too limiting is not good.

The other is much more down to earth. I wanted a small and light laptop for traveling. Just for some writing, nothing fancy. I also had no money, and... I miscalculatd. For 25 euro's I bought this Asus EEE PC from 2009. I spent another 25 euros on a new battery. And then I installed a no-nonsense Linux distro called Debian Stable. But, even withouth any any fancy tooling, like an text editor based on a browser, just booting up and logging in took way too long to be useable.

Being old helps you also with another experience. Maybe you look at the past with rose tinted glasses, but even though things were limited compared to the present day, you know for a fact that the world still revolved around the sun at the same speed as it does now adn you also know that society functioned just fine, people did their work, writers wrote, programmers programmed. It was all very much possible back then.

So, to make the tiny laptop useable again, I reinstaled Debian again, but this time without any graphics.

_As a side note, I found this doing this will also not install the Wifi that you set up during the install process. This leaves you with a fully functional system that cannot do any graphics or networking. So basically you can do nthing, asyou can't install any programs, unless you fiddle with downloading the packages on another computers, including their dependencies and transfer them with a usb stick. A simpler way is to boot with the installer again, go to rescue mode and install something like nmtui. This is a terminal interface for NetworkManager._ 

## Why should this work anyway?

Deep work, Hammock Driven Development. Tha lamenting of looking up eveything on Stackoverflow.

one can unlearn bad habits by making it harder to follow them. If you don't want to eat as much cookies anymore, its bestto just stop buying them. It is n0t impossible, only harder and this helps you. Of course, this won't work with a real addiction. Consult a professional for that.

We all know methods of limiting email, blocking reddit, etc. It is better just just have an immesive environment.



## Hw to set it up.

tmux


Pomodoro: 20 minutes of framebuffer, 5 minutes of answering 

Don't replicate all the noise of your ormal environment in text. That just makes for a lot of noisy text ad that is worse.
