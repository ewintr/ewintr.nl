---
title: "My default go directory structure"
date: 2021-02-11
draft: false
---

Go is very flexible and there are a lot of ways one can set up a project. Files can be placed anywhere and there are very few rules on what packages one can import. People like having certain rules and conventions though, because once a best way to do something is figured out, it saves time to encode it in best practises and to not thave to rethink it for each project again and again.<!-- more -->

After getting some experience, this is my best practise on how to structure the files and packages in a project folder:

```
├── cmd       // the different programs/services
├── internal  // decoupled packages specific to this repository
└── pkg       // decoupled packages that may be imported by other projects
```

With the following limitations:

* `cmd` can import from `internal` and `pkg`.
* `cmd` cannot be imported by any package in the tree.
* `internal` can only import from `pkg`.
* `internal` can only be imported by `cmd`.
* `pkg` cannot import from any package within the project.
* `pkg` can be imported by all other packages.

## /cmd

All the programs/services that belong to the project. One folder for each binary, each folder contains a `main.go` or a `service.go`.

## /internal

Packages that provide functionality that is shared between the different programs, but that is specific to the project. For instance models and workflows.

Why name it internal? Because the go compiler will not allow the packages inside that folder to be imported by packages outside the parent folder. In other words, the go command will enforce that these project specific packages cannot be used outside of the project.

## /pkg

All packages that can be decoupled from the rest. From the project perspective, these packages are standalone. Data comes in, data goes out, but they are not linked to one-other or dependent on each other.
Sources

* [golang.org](https://golang.org/doc/go1.4#internalpackages)
* [github.com](https://github.com/golang-standards/project-layout)
