---
title: "Depend less on dependencies with the adapter pattern in go"
date: 2021-03-31
draft: false
---

The package management in Go is pretty convenient. Just run `go get` and you have another nice library installed on your computer. Just for you to use, saving you hours of developing end debugging the functionality yourself.<!-- more --> But there is a downside to it, apart from the fact that downloading and running arbitrary code from the internet is generally not a smart thing to do, and that is that your program has now become dependent on this external library.

This is obvious and intended, you might say. The library was created to make use of and you imported it do exactly that. Let’s say you implicitly trust the authors of the library not to infect your program with viruses, backdoors and other malware, although we would rather not like to think too much about these things when we do our daily work. Another potential problem is that the library project has a lifecycle of its own. It has its own release schedule, bugs are fixed at their convenience. Perhaps the library develops in a direction you don’t want it to, or maybe it gets abandoned and does not get developed anymore at all. Then you’re stuck with it. This gets us to the most ignored risk of using external code and that is: tight coupling.

It is all too convenient to follow the directions in the documentation and get things working in record time. But by doing so you rely on the path that the library developers have set out for you, both in the abstract model-of-the-world sense and in the concrete these-are-the-names-of-the-methods-thou-shallt-use sense. If you integrated this in your code without planning, chances are that you’ve now painted yourself into a corner. It is not that the provided directions are necessarily bad in themselves. But if you follow them and end up somewhere unpleasant, there should be an easy way back. Tight coupling can be a big problem then.

The solution is to implement the adapter pattern. An adapter is a piece of code that can bridge one type of interface (or API, or set of methods, or...) to another and so make the code that uses those interfaces compatible. By using it, we are stating beforehand that the librabry is incompatible with our code. We keep it separate and use the adapter as a bridge to make it work. If for some reasing we don’t like the library anymore, we can make a new adapter and use another. As a bonus, having this explicit bridge also gives the opportunity to add a version suitable for testing. Just bridge to some mock code. This comes in handy in the case the library we are using is a client for a webservice, or a database driver, that normally is hard to mock.

One interface in this story is that of the library. The other is the one your program uses. What is the interface my program uses? you might ask. The answer to that is: what an excellent question! That is something you have to come up with yourself. Start thinking what it is that your program needs, instead of what the library provides. The major benefit of using this pattern is that you can structure your own code the way it fits best with the problem it tries to solve.

## Steps to take

How does this work? Just follow these simple steps:

* Create a separate package for this interface, for instance `/pkg/thing`.
* Add the types and interface you need for your functionality, for instance in `/pkg/thing/thing.go`. Remember, interfaces in Go should be as small as possible for flexibility and composability. Favor multiple small interfaces over one big one. Ignore all the grandiose ideas in the library, only put in here what makes sense for your project
* Add an in-memory implementation of this interface, for instance in `/pkg/thing/memory.go`. With tests for it in `/pkg/thing/memory_test.go`. If the abstractions made sense, you should be able to get full coverage without much sweat.
* Start using this in-memory implementation in the rest of the program and its tests. This will help you decide whether this interface is really the one you need, or that it needs some tweaking. It will also make it easier to set up tests for more complicated functionality.
* When you are happy with it, make an implementation with the actual library. For instance in `/pkg/libraryname.go`. This will probably be pretty hard to unit test, as libraries get often used to communicate with other systems like databases, web services, etc. This will need coverage from integration tests. Fortunately, you have now isolated this difficulty to a small corner of the code.

## Example

An example of what this looks like in practice is the `log` package in my small personal [go kit](https://code.ewintr.nl/ewintr/go-kit) repository. There is an interface definition in `log.go`, together with two implementations, one for [Logrus](https://github.com/Sirupsen/logrus) and one for the [gokit.io](https://gokit.io/) log package, and an implemention suitable for use in testing.

Both libraries have their own structure and their own set of features, but changing one for the other is easy. 
