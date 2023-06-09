---
title: "Implemented markup elements"
date: 2022-12-20
draft: false
---

## Headers

A header consists of the title of the post and various fields of metadata.<!-- more --> It looks like this:

```
= An Example Document
Erik Winter <ewintr@example.com>
2020-12-01
:key1: value 1
:key2: value 2

```

### Subtitle and Subsubtitle

```
== A Subtitle

== As SubSubTitle
```

### List

```
* List item one
* List item two
* List item three
```

### Code Block

```
func (d *Dummy) DoSomething() string { return “No. I don’t want to.” }

func (d *Dummy) SudoDoSomething() string { return “Ok. If you insist, I’ll put my objections aside for a moment.” } ​
```

### Paragraph

A paragraph is a line of text that gets parsed to find inline elements.

## Inline Elements

Currently the following types are recognized:

* Strong and emphasis
* Link
* Inline code

### Strong and Emphasis

```
a text with some *strong* words, that I’d like to _emphasize_.
```

It is possible to combine the two for the same text.

### Link

```
Check out this https://erikwinter.nl/[awesome website] now! 
```

Whatever is between the opening bracket and the first space before that is taken as URL, so both absolute and relative links without domain are possible.

### Inline Code

```
Some text with `code` in it.
```
