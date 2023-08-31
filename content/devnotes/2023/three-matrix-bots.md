---
title: "Three simple bots for the Matrix network"
date: 2023-07-28
draft: false
---

[Matrix](https://matrix.org) is an open source, decentralized, end-to-end encrypted communication network. It's sort of a combination of Discord and Mastodon. I created a few bots for this network to perform various small tasks.<!-- more -->

The benefit of having a bot on a network like this is that you only need to run it once and then it is immediately available on all your devices, with a shared, searchable history. A Matrix channel can be viewed as a synchronized terminal, with clients available for virtually any device. A bot is analogous to a bash script in that terminal.

## Matrix-GPTZoo

Code is here: [code.ewintr.nl](https://code.ewintr.nl/ewintr/matrix-gptzoo)

A ChatGPT interface with multiple configurable prompts.

Each prompt will have the bot log in with a different user, enabling the creation of a chat room full of AI assistants to answer your questions.

Bots will only answer questions specifically addressed to them, but it is also possible to configure one to answer questions that are not addressed to a specific bot. Continuing a conversation can be done by replying to an answer.

## Matrix-FeedReader

Code is here: [code.ewintr.nl](https://code.ewintr.nl/ewintr/matrix-feedreader)

This is a bot simply posts new entries from a [Miniflux](https://miniflux.app/) RSS reader to a Matrix room.

Miniflux already has a Matrix integration and can post the entries itself, but this bot adds two things:

* After posting it marks the entry as read in Miniflux.
* Each entry is posted as a separate message, which makes it easier to create other bots that can interact with them.

## Matrix-KagiSum

Code is here: [code.ewintr.nl](https://code.ewintr.nl/ewintr/matrix-kagisum)

A quick and dirty bot that summarizes web content from a link. It uses the [Kagi Universal Summarizer](https://blog.kagi.com/universal-summarizer).

To use it, just react to a message with a 🗒️ emoji and the bot will reply with a summary of the linked content.

