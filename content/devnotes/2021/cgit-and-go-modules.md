---
title: "Cgit and go modules"
date: 2021-05-19
draft: false
---

Recently I started to self host my public git repositories. There are several options to choose from if you want that sort of thing, like [Gitea](https://gitea.com/) or [Gogs](https://gogs.io/) and others. These all look like fine applications, but they all try to imitate the big hosted platforms like Github and GitLab.<!-- more --> They do more that making your repositories available to the web, they also include issue trackers, users, project management, etc. That's a bit too much for me. I only want to offer the code of my personal projects that I write about, nothing more.

Fortunately I found [cgit](https://git.zx2c4.com/cgit/about/). Cgit does just that. No collaboration features, but it does its job in a fast, simple and clean way. If its good enough for the [Linux kernel](https://git.kernel.org/pub/scm/), it's good enough for me. [This blogpost](https://blog.stefan-koch.name/2020/02/16/installing-cgit-nginx-on-debian) covers how to set it up on Debian.

If you use this for hosting Go projects, there is however an extra step you should take. The location for remote Go modules are indicated by import strings at the top of your code and in your `go.mod` file that indicate an url. But a string alone is not enough to make everything work smoothly in the background, if you for instance use `go get`, or `go mod tidy`. There are different types of version control systems, different protocols to transport the data, like `http(s)` and `ssh`. Did you know that git even has its own protocol for serving repositories? (See [git-dameon](https://git-scm.com/book/en/v2/Git-on-the-Server-Git-Daemon) for that. It's even lighter than cgit, but insecure, so `go get` doesn't want to download over it without extra confirmation, which is a hassle.)

The extra ingredient necessary for making `go get` work with a remote repository is an extra `<meta>` tag in the header of the repository's website. See the documentation [here](https://golang.org/cmd/go/#hdr-Remote_import_paths) for the details.

Luckily, someone [already modified](https://mygit.katolaz.net/katolaz/cgit-70/commit/b522a302c9c4fb9fd9e1ea829ee990afc74980ca) `cgit` with an option to provide this tag: `extra-head-content`. We can pass the necessary `<meta>` tag unmodified through this setting. For instance, this is the configuration of one of the repositories on my instance:

```
repo.url=go-kit
repo.owner=Erik Winter
repo.path=/var/repo/public/go-kit/
repo.desc=a small, personal collection of useful go packages
repo.extra-head-content=<meta name="go-import" content="git.ewintr.nl/go-kit git https://git.ewintr.nl/go-kit">
```

## Sources

* [git.zx2c4.com](https://git.zx2c4.com/cgit/about/)
* [blog.stefan-koch.name](https://blog.stefan-koch.name/2020/02/16/installing-cgit-nginx-on-debian)
* [golang.org](https://golang.org/cmd/go/#hdr-Remote_import_paths)
* [mygit.katolaz.net](https://mygit.katolaz.net/katolaz/cgit-70/commit/b522a302c9c4fb9fd9e1ea829ee990afc74980ca)
