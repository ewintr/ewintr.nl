---
title: "Quick go test clycle with reflex"
date: 2020-01-04
draft: false
---

While you are working on some piece of code, it is nice to have some feedback about whether you broke or fixed something by running the relevant unit tests. To automate this I usually have a terminal window open with the following command:<!-- more -->

```
$ reflex -r '\.go$' -- sh -c 'clear && go test -v ./web/model --run TestEvent'
```

* `reflex` is a small utilty that watches for changes on the file system.
* `-r` indiates that it should only watch changes in files that satisfy the following regex pattern.
* `'\.go$'` the regex tells to only watch change in go files.
* `--` signifies the end of reflex options.
* `sh` shell to interpret the command we want to run.
* `-c` tell sh to listen to commands entered after, not to standard input.
* `clear` first clear the terminal window.
* `go test` run the test in verbose mode.
* `-v` will produce a more verbose output with PASS/FAIL for each test and the output fom t.Log,
* `./web/model` only test files in the web/model package.
* `-run TestEvent` only run test with names that satisfy the regext TestEvent.

Remember, `reflex` is only triggered by _changes_ on the filesystem. After entering the command, nothing happens until you save a `.go` file.

## Sources

* [github.com](https://github.com/cespare/reflex)
* [unix.stackexchange.com](https://unix.stackexchange.com/questions/11376/what-does-double-dash-mean)
* `man sh`
* [blog.alexellis.io](https://blog.alexellis.io/golang-writing-unit-tests/)
* [golang.org](https://golang.org/cmd/go/#hdr-Testing_flags)
