---
title: "Three Matrix bots"
date: 2023-08-29
draft: true
---

Matrix is an open source, decentralized, end-to-end encrypted communication network. Kind of a combination of Discord and Mastodon. I created a few bots for various small personal stuff.<!-- more -->

The benefit of bots like this is that you need run them only once and then they are available on all your devices, synchronized and with searchable history. A Matrix channel can be seen as a synchronized terminal with clients available for any device that you can imagine.

## Matrix-GPTZoo

A ChatGPT interface with multiple configurable prompts.

The bot will log in with a different user for each prompt, making it possible to create a chat room full of AI assistants that you can ask questions.

Bots will only answer questions specifically addressed to them, but it is also possible to configure one to answer questions that are not addressed to a specific bot. Continuing a conversation can be done by replying to an answer.

![screenshot](/image/gptzoo-screenshot.png)

Code is here: [code.ewintr.nl](https://code.ewintr.nl/ewintr/matrix-gptzoo)

## Matrix-FeedReader

A very simple bot that posts new entries from a [Miniflux](https://miniflux.app/) RSS reader to a Matrix room.

Miniflux already has a Matrix integration and can post the entries itself, but this bot adds two things:

* After posting it marks the entry as read in Miniflux.
* It posts every entry as a separate message, which makes it easier to create other bots that can interact with them.

Code is here: [code.ewintr.nl](https://code.ewintr.nl/ewintr/matrix-feedreader)

## Matrix-KagiSum

Quick and dirty bot that summarizes web content from a link. It uses the [Kagi Universal Summarizer](https://blog.kagi.com/universal-summarizer).

Just react to a message with a 🗒️ emoji and the bot will reply with a summary of the linked content.

Code is here: [code.ewintr.nl](https://code.ewintr.nl/ewintr/matrix-kagisum)