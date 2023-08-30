---
title: "Some comments on my Synology DS923+"
date: 2023-08-29
draft: true
---

A couple of months ago I bought a Synology DS923+ NAS with the intention of turning it into a home server with reasonable energy consumption and ample safe (as in RAID 5) storage. Although it turned out to be a fine machine,  not everything worked as I had imagined.<!-- more -->

## Docker and Virtual Machines

I maxed out the RAM with the idea of running a couple of Docker containers and Virtual Machines. This works as advertised, but for the VM's it is good to know that you are also limited by the amount of CPU cores. So even if you have the RAM, you still can't run eight VM's. See [kb.synology.com](https://kb.synology.com/en-global/DSM/tutorial/How_many_virtual_machines_can_I_run_on_my_Synology_NAS) for guidance. 

The built in reverse proxy sucks if you want to do anything more than the most basic of things. My solution for this was to create a small Debian VM with nginx and direct incoming traffic to that instead. This works perfectly, but comes at the cost of the resources needed to run the VM, which are limited as mentioned earlier.

Overall it performs well enough to run VM's, but be aware that some specific actions were agonizingly slow. In my case, actions like running Debian's apt to upgrade the system or building a Docker container forced me to take coffee breaks again and again. I didn't investigate, but I my guess is that these actions force often filesystem syncs and that is probably is a slow operation on a device like this due to caching, calculations for the RAID setup, etc.

## Automatic shutdown and wake up

I wanted to save energy by having it automatically switch off when it is not in use and start it up with WakeOnLan when needed. The term "in use" is a bit ambiguous for a server that runs all kinds of background stuff. However I was surprised at the list of things that needed to be disabled for this to work: [kb.synology.com](https://kb.synology.com/en-us/DSM/tutorial/What_stops_my_Synology_NAS_from_entering_System_Hibernation)

In the end I decided to prioritize automated shutdown and wake up, so I removed all containers and VM's. The goal then shifted to have it start up when accessing a file share, in my case, mounting a folder in Linux over NFS. This process has some gotchas and I plan to write a blog post about them, but a good one is already available here: [dj-does.medium.com](https://dj-does.medium.com/nfs-mounts-and-wake-on-lan-25c0c1d55c90)

