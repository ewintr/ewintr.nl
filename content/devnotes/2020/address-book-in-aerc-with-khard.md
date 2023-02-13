---
title: "Address book in aerc with khard"
date: 2020-05-23
draft: false
---

In line with the Unix philosophy, Aerc does not implement any feature to store mail addresses of contacts. Instead it has an option to retrieve them from an external address book.<!-- more --> I already synced my contacts together with my calendar items through Vdirsyncer and Radicale, but this was more for backup purposes. My phone does not play nice with any CardDav server.

But with Khard I can put the address book to good use. Khard is a command line program for contacts that understands the CardDav format. To configure Aerc to use Khard for mail address completion, look up the line in `aerc.conf` that starts with `address-book-cmd=` and fill it in like this to make it usable for Aerc:

```
address-book-cmd=khard email --parsable --search-in-source-files --remove-first-line %s
```

* `--parsable` lets it return a tab delimited line as required.
* `--search-in-source-files` makes it faster with large address books.
* `--remove-first-line` removes the "searching for..." line in the response. Appearantly this line is required for Mutt, but it is not for Aerc.

## Debian Buster

I just installed Khard through apt and copy/pasted the default configuration that is provided in the docs. If you do so and you run khard, you'll be greeted by this error message:

```
$ khard
Traceback (most recent call last):
  File "/usr/bin/khard", line 11, in <module>
    load_entry_point('khard==0.13.0', 'console_scripts', 'khard')()
  File "/usr/lib/python3/dist-packages/khard/khard.py", line 1753, in main
    args = parse_args(argv)
  File "/usr/lib/python3/dist-packages/khard/khard.py", line 1715, in parse_args
    config = Config(args.config)
  File "/usr/lib/python3/dist-packages/khard/config.py", line 74, in __init__
    self.editor = find_executable(os.path.expanduser(self.editor))
  File "/usr/lib/python3.7/posixpath.py", line 235, in expanduser
    path = os.fspath(path)
TypeError: expected str, bytes or os.PathLike object, not list
```

The standard Debian version is probably too old and they probably changed the configuration options for the editor. The current format accepts a comma separated list with options, but the old one does not. Changing the editor option line in `~/.config/khard/khard.conf` from

```
editor = vim, -i, NONE
```

to

```
editor = nvim
```

lets everything work as intended.

## Sources

* [todo.sr.ht](https://todo.sr.ht/~sircmpwn/aerc2/19)
* [github.com](https://github.com/scheibler/khard)
* [khard.readthedocs.io](https://khard.readthedocs.io/en/latest/)
