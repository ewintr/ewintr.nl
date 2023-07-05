---
title: "Matrix-FeedReader"
date: 2023-06-14
draft: false
---

A very simple bot that posts new entries from a [Miniflux](https://miniflux.app/) RSS reader to a [Matrix](https://matrix.org) room.<!-- more -->

Miniflux already has a Matrix integration and can post the entries itself, but this bot adds two things:

* After posting it marks the entry as read in Miniflux.
* It posts every entry as a separate message, which makes it easier to create other bots that can interact with them.

Code is [here](https://code.ewintr.nl/ewintr/matrix-feedreader).