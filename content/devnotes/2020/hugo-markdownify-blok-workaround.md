---
title: "Hugo markdownify block workaround"
date: 2020-03-22
draft: false
---

Like other static site generators, Hugo has an option to pass markdown content though a markdown processor to interpret it and convert it to HTML. Also, like other generators, this has the incredibly confusing name markdownify,<!-- more --> as the end result would be something that is converted into markdown, rather than markdown that gets interpreted into something else. The documentation just states "Runs the provided string through the Markdown processor" and that does not really help.

But unlike other generators, there is something else that can trip you up and that is that whenever a single paragraph of text is passed to this function, it interprets this as some kind of inline mode and the result is that you get a HTML paragraph without the `<p>` tags around it. If, however, you pass multiple paragraphs of text, the `<p>` tags are added as expected. This means that if you don't know the amount of pragraphs beforehand, you need this workaround in your template to be sure that the elements that are printed are wrapped into the block elements that you expected:

```
{{- $content := .Content | markdownify -}}
{{- if not ( findRE "<[h|p][^>]*>" $content ) -}}
  <p>{{- $content -}}</p>
{{- else -}}
    {{- $content -}}
{{- end -}}
```

## Sources

* [gohugo.io](https://gohugo.io/functions/markdownify/)
* [dev.to](https://dev.to/smnh/the-tale-of-markdownify-4lcl)
* [github.com](https://github.com/gohugoio/hugo/issues/3040)
