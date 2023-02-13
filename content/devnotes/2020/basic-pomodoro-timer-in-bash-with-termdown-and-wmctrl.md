---
title: "Basic pomodoro timer in bash with termdown and wmctrl"
date: 2020-03-22
draft: false
---

Like many other systems that aim to add some structure in the chaos of todo-items that we all struggle with, the Pomodoro Technique has some good parts and ideas, but one must be careful not to drive it to far.<!-- more --> Neither by forcing every life problem in the system (if all you have is hammer...), nor by a too rigid application of the rules of the system. The same goes for the apps and tools that come with it.

After some failed attempts to install `i3-pomodoro`, where I first had to upgrade my `i3status` to `i3blocks`, with its own configuration and all, I realized I just wanted one very simple thing from Pomodoro: a timer that lets me do some focused work for a certain period of time. Nothing more. For simple things, Bash is still the best:

```
#!/bin/bash
MINUTES=25
if [ "$1" == "break" ]; then
  MINUTES=5
fi
wmctrl -N "Pomodoro" -r :ACTIVE:
termdown --no-figlet --no-seconds --no-window-title ${MINUTES}m 
wmctrl -b add,demands_attention -r "Pomodoro"
```

This runs a terminal timer that counts down to zero from a specified amount of minutes and then lets the window manager draw attention to it in it's native way. In default i3 this means the border turns red, as well as the workspace indicator in the status bar.

* `wmctrl` handles the part of drawing the attention. The trick here is to make sure that attention is drawn to the right window. This is done setting the window title of the active window, the one we run the script in, to something known beforehand. This way, we can find it back later at the end of the countdown:
* `-N "Pomodoro"` sets the title of the window to "Pomodoro".
* `-r :ACTIVE:` selects the currently active window.

Then the timer `termdown` is started:

* `--no-figlet`: don't fill the terminal with large numbers that do the countdown. We want some time focused on our task, so we need as little distraction as possible.
* `--no-seconds`: for the same reason, don't show the seconds.
* `--no-window-title`: by default `termdown` also displays the time left in the window title. This is even more distraction, but also removes the title we just set. This option disables that.

After the countdown, we let `wmctrl` draw the attention:

* `-b add,demands_attention` adds the property `demands_attention` to the window.
* `-r "Pomodoro"` selects the window that has "Pomodoro" as title.

## Sources

* [en.wikipedia.org](https://en.wikipedia.org/wiki/Pomodoro_Technique)
* [gitlab.com](https://gitlab.com/moritz-weber/i3-pomodoro)
* [github.com](https://github.com/i3/i3status)
* [github.com](https://github.com/vivien/i3blocks)
* [linux.die.net](https://linux.die.net/man/1/wmctrl)
* [github.com](https://github.com/trehn/termdown)
* [askubuntu.com](https://askubuntu.com/questions/40463/is-there-any-way-to-initiate-urgent-animation-of-an-icon-on-the-unity-launcher)
