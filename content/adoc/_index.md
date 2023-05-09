+++
title = "AsciiDoc parser"
page_template = "post.html"
sort_by = "date"
extra.icon = "document.svg"
extra.language = "en"
extra.short = "adoc"
extra.goimport = "https://code.ewintr.nl/ewintr/adoc.git"
+++

It started with some lines of throwaway code, held together by staples and duct tape in my little [Shitty SSG](@/shitty-ssg/_index.md) project and it kept evolving. A long time ago I decided that I liked [AsciiDoc](https://powerman.name/doc/asciidoc) better than [Markdown](https://commonmark.org/help/) when it comes to simple markup languages.

On the surface they are very similar, both are very easy to write and read and can be used in their "raw" form. You don't need to render a page before you can read it comfortably, unlike, for instance, [HTML](https://developer.mozilla.org/en-US/docs/Web/HTML).

The difference becomes clear when you write texts that longer than the typical short comment or snippet. AsciiDoc is much more complete. You can write a whole book in it. I never did that, but I did notice that I started using it everywhere I could. Unfortunately there wasn't a really good library for Go available.

So I started one myself. The AsciiDoc specification is big and I started implementation with the features I use myself. It's far from complete, but [here](https://codeberg.org/ewintr/adoc) is the code.
