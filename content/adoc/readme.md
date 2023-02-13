---
title: "README.adoc"
date: 2022-04-06
draft: false
---

The beginnings of a parser for the Asciidoc markup language.<!-- more -->

## Example

[Run the snippet below on the Go Playground](https://go.dev/play/p/hF2wn_GdkBK)

```
package main

import (
  "fmt"
  "strings"

  "ewintr.nl/adoc"
)

func main() {
  sourceDoc := `= This is the title

And this is the first paragraph. With some text. Lists are supported too:

* Item 1
* Item 2
* Item 3

And we also have things like *bold* and _italic_.`

  par := adoc.NewParser(strings.NewReader(sourceDoc))
  doc := par.Parse()

  htmlDoc := adoc.NewHTMLFormatter().Format(doc)
  fmt.Println(htmlDoc)

  // output:
  //
  // <!DOCTYPE html>
  // <html>
  // <head>
  // <title>This is the title</title>
  // </head>
  // <body>
  // <p>And this is the first paragraph. With some text. Lists are supported too:</p>
  // <ul>
  // <li>Item 1</li>
  // <li>Item 2</li>
  // <li>Item 3</li>
  // </ul>
  // <p>And we also have things like <strong>bold</strong> and <em>italic</em>.</p>
  // </html>
}
```
