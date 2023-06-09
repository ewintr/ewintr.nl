---
title: "Simple log file analysis for your kubernetes pods on the command line"
date: 2021-01-23
draft: false
---

Recently at my current job there was a lot of complaining about how terribly slow our instance of Kibana was. We use that, as many teams do, to view and analyse the log files generated by the services that run on our Kubernetes cluster.<!-- more --> The root cause was that the logs were simply too large, because we logged a lot of stuff that wasn’t necessary. During the conversation, I commented that I never noticed any problem with Kibana, because I never used it. To me the tool feels complicated, cumbersome and, even when it functions properly, way to slow. The natural followup question was what I used instead and the answer was: simple tools that work in the shell and have existed for ages.

This led to me writing a quick guide on these tools and how to use them. I figured more people might be interested, so I put up here too. With this background information, it is probably understandable that the tips below are focused on a specific, narrow use case. Reading further is most useful if you:

* Have seen a shell before, but are not terribly comfortable in using it.
* Have a Kubernetes cluster and want to check the logs from the services running on it.
* Have ssh access, or another way to run kubectl in a shell.
* Have JSON structured logs.

The information is broken down into the following sections (click on them to jump):

* [General Principles](#general-principles)
* [Environment setup (not required)](#environment-setup-not-required)
* [Working with plain text: grep](#working-with-plain-text-grep)
* [Working with JSON: jq](#working-with-json-jq)
* [Sorting, counting and grouping](#sorting-counting-and-grouping)
* [Examples](#examples)

_Note: later I discovered that the same techniques can be used for your webserver statistics too. Check [this note](@/devnotes/2021/json-structured-logging-with-nginx.md) to see how you can get Nginx to produce the same kind of structured logging as is discussed here._

## General Principles

### SSH

Probably every developer working at this level knows what `ssh` is and has set up proper key based authentication for it. That is, you can do the following and not get an error message:

```
$ ssh username@remote.server
```

If you do get an error, ask your local devops person how to fix it. If you are the local devops person, search the internet for “ssh key setup”.

What might be less known, is that with `ssh`, you can run commands on a remote server transparently from your laptop. Just type the command you would want to run on the remote machine after the `ssh` command and press enter. This command on your local machine:

```
$ ssh username@remote.server ls
```

will give you the contents of your home folder on the remote server. Together with a proper alias for the `ssh` part (see below), this gives lightning fast access for simple operations.

## Kubectl

The main command for interacting with the Kubernetes cluster is `kubectl`. Of course, interacting with a cluster is a complex subject matter that requires careful study to become proficient with, but for our purposes we can make do with a few commands like `kubectl get pods` to get a list of pods running in an environment and `kubectl logs XXX` to get the logs of XXX.

Useful options for kubectl logs are:

* `-l<query>` for combining log of multiple pods and containers. For instance -lapp=user-management-app gives logs for all running instances of the user-management-app in that environment.
* `--since=YY` gives only output from the last YY where YY is a period like `3s`, `5m` or `24h`.

```
$ kubectl logs -lapp=some-service --since=5m
```

will give you all logs from all instances of `some-service` service from the last five minutes.

See kubectl `help logs` for more.

### Directing input and output

Shell commands are designed to work with lines of text. That means that the output of a command is often a bunch of text lines (separated with a newline), but also that it accepts a bunch of text lines (again, separated with newline characters) as input. This means that we can easily chain multiple commands without having to deal with the intermediate results. This chaining is done with the pipe symbol: `|`.

ls gives the contents of a folder and sort can sort lines in alphabetical order. So `ls | sort` also gives the contents of a folder, but sorted. (This is actually not very useful, because `ls` output is already sorted by default. To make it more interesting, try `ls | sort -r` The `-r` option specifies reverse sorting.)

Sometimes you do want to save the intermediate results to a file. Get the information while it’s fresh, store it and do some analysis later. To save the output to a file, use `command > filename`. The file does not need to exist. If it does exist, this command will overwrite it without warning. Use `>>` instead of `>` to append the new output at the end of the file.

Use `cat` to read lines from a file. The following will give the same output as the `ls | sort -r` from above, but now this also stores the (intermediate) results in files:

```
$ ls > contents.txt
$ cat contents.txt | sort -r > sorted_contents.txt
$ cat sorted_content.txt
```

### Limiting output

Log files by their nature are very long and having them scroll though your terminal window in their entirety is a sure way to get bored and confused at the same time. An easy way to test the output of your command without the risk of a data overload are `head` and `tail`. By default, these commands limit the output to the first (`head`) or last (`tail`) 10 lines. Both have a parameter `-n` that can be used for a different number of lines:

```
$ cat long_file.log | tail -n 5
```

`tail` also has the parameter `-f` for following. After the last x amount of lines are shown, the program does not exit, but waits until more lines come and then prints them. This can be helpful when doing some live debugging. Set up a pipe that only prints the lines you are interested in and close it with `tail -f`. Then you can watch the log as you perform different actions in the app without being distracted by log lines you’re not interested in flying by.

### Splitting long commands over multiple lines

With all this chaining of commands it is possible that they become less readable, specially when the lines in your terminal start to wrap. There are two ways to spread your commands over multiple lines. The first one is with a `\` at the end of the line:

```
$ my-command-with-lots-of-args \
> --arg1=a \
> --arg2=b \
> --arg3=c
```

The `>` is shown to indicate that more input is expected.

But if we use pipes, we don’t need to do that, as the pipe itself already signals bash that there is more to come:

```
$ command-1 | command-2 |
> command-3 |
> command-4
```

If your prompt wants more input after pressing enter, but you did not use any of the two mentioned symbols, then you probably forgot to close a quoted string somewhere.

## Environment setup (not required)

As mentioned, this is not required, but using your `.bashrc` (or mac equivalent, I don’t know if it is called the same there) in combination with the `alias` command can be great time saver. `alias` lets you define abbreviations, `.bashrc` is a place for things you want to run each time after you open a terminal and login.

At the beginning of this document it was mentioned that `ssh` can be used to run command on a remote server. But typing in the `ssh username@remote.server` over and over again to run something on the other server can become tedious. If you add this line to your `.bashrc` on your laptop you can do it much quicker:

```
alias servername='ssh username@remote.server'
```

From now on, you only have to use servername to login to that server and

```
$ servername ls
```

gives you the contents of your home folder on that server. If you use this often, you could shorten it to `s`.

(Note that you have to open a new shell for this to work, because `.bashrc` is only read when the shell is started. If you don’t want to do that, you can do `source ~/.bashrc` to process the file right in the current shell without logging in again.)

This trick can be used on both your laptop and the remote server. Some suggestions for aliases are:

```
alias acc='command to switch to acceptance environment'
alias prod='command to switch to production environment'
alias k=kubectl
alias kn='kubectl -n "namespace"'
alias x=exit
```

## Working with plain text: grep

If the logs are stored in JSON, processing them with pure text tools does not give the best results. See the next section on how to proper deal with JSON. But, often we don’t need to do advanced things and some text tools can be very helpful for some off-the-cuff filtering of log files.

Most people know that using `grep` is a simple way to filter lines that contain some text:

```
$ echo $'one\ntwo\nTHREE' | grep "two"
two
```

(`echo` sends out text, the `$'...'` notation converts `\n` to a newline.)

But it is good to also know some options:

Ignore case with `-i`:

```
$ echo $'one\ntwo\nTHREE' | grep -i "three"
THREE
```

Inverse the search with `-v`:

```
$ echo $'one\ntwo\nTHREE' | grep -v "two"
one
THREE
```

Only whole words with `-w`:

```
$ echo $'one\ntwo\ntwoandahalf' | grep "two"
two
twoandahalf
$ echo $'one\ntwo\ntwoandahalf' | grep -w "two"
two
```

Count the results with `-c`:

```
$ echo $'one\ntwo\ntwoandahalf' | grep -c "two"
2
```

Use regular expressions with `-E`:

```
$ echo $'one\ntwo\nthree' | grep -E "^[a-z]{3}$"
one
two
```

There are a lot more tools available for manipulating and transforming lines of text, but they don’t work that well for lines of JSON, so we’ll skip them here.

## Working with JSON: jq

For manipulating JSON on the command line there is only one tool you need, because it is like a Swiss army knife. It can do anything you might think of. Even just piping a piece of JSON through `jq` is useful, as it will pretty print it by default and makes it readable:

```
$ echo '{"some":"stuff"}' | jq .
{
  "some": "stuff"
}
```

As is to be expected, this short introduction covers only a fraction of the available functionality. Most examples and tutorials on the internet will discuss `jq` in the context of large JSON strings with deep nested structures. But in this case we are dealing with lots of lines of text with short pieces of JSON that are pretty flat. Most of the time, it is only a list of key-value pairs.

We probably want to feed the results into a next program, so what comes in on one line, must go out on one line. The `-c` option keeps `jq` from spreading the structure over multiple lines.

### Selecting fields

`jq` uses a path-like syntax to select fields:

```
$ echo '{"one":1, "two":2, "three":[4, 5, 6]}' | jq -c .one
1
$ echo '{"one":1, "two":2, "three":[4, 5, 6]}' | jq -c .three
[4,5,6]
$ echo '{"one":1, "two":2, "three":[4, 5, 6]}' | jq -c .three[1]
5
```

### Grouping fields

`[..]` and `{..}` can be used to group multiple results into an array or an object:

```
$ echo '{"one":1, "two":2, "three":[4, 5, 6]}' | jq -c '[ .three[1], .two ]'
[5,2]
$ echo '{"one":1, "two":2, "three":[4, 5, 6]}' | 
> jq -c '{ thing: .three[1], another: .two }'
{"thing":5,"another":2}
```

### Filtering values

We can also select lines based on the values of the fields:

```
$ echo $'{"thing":5, "another":2}\n{"thing":6,"another":1}' | 
> jq -c 'select(.another < 2)'
{"thing":6,"another":1}
```

And at the risk of making things confusing, `jq` has its own piping mechanism that uses the same symbol as bash. For instance, we can combine the select with a grouping like this:

```
$ echo $'{"thing":5, "another":2}\n{"thing":6,"another":1}' | 
> jq -c '{field: .another} | select(.field < 2)'
{"field":1}
```

Comparisons work on strings too. This makes it possible to filter on timestamps, as they are represented as strings with integers ranging from most to least significant:

```
$ echo $'{"time":"2021-01-01T00:00:00Z"}\n{"time":"2021-01-02T00:00:00Z"}\n{"time":"2021-01-03T00:00:00Z"}' | 
jq -c 'select(.time > "2021-01-01T00:00:00Z" and .time < "2021-01-03T00:00:00Z")' 
{"time":"2021-01-02T00:00:00Z"}
```

This is a bit sensitive to typos though. For instance, if you accidentally forget a `-` or replace the `T` in one string with a space, but not the other, the sorting still works and no error will be shown. But it will not do what you expect.

## Sorting, counting and grouping

As mentioned, all these tools work on a line by line basis. But there are a few programs that operate on multiple lines too. Most notably: `sort` and `uniq`. They can, as is indicated by their names, sort things and filter unique values. The caveat for `uniq` is that it only compares the current with the previous line and thus only eliminates adjacent doubles. This is solved by sorting them first. The nice thing about `uniq` is that it can count how may occurrences of a line were present. To get a ranking, we can sort again:

```
$ echo $'A\nB\nA\nA\nC\nB' | sort | uniq -c | sort -rn
      3 A
      2 B
      1 C
```

`-c` adds the count on uniq, `-rn` means sort reverse on numbers for `sort`.

Combined with `head` you can make a top ten list.

## Examples

Armed with all this knowledge, it is not hard to construct commands that answer the simple questions that come up a lot when dealing with logs:

Show me the latest errors for a product with this id on that service:
```
$ kubectl logs -lapp=THAT_SERVICE | 
> grep 'UUID' | 
> grep -v "err:null" |
> tail
```

How often did this message appear and for what users:

```
$ kubectl logs POD_NAME |
> grep "MESSAGE" |
> jq -c .userId |
> sort | uniq -c | sort -rn
```
