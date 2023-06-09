---
title: "App: command line interface"
date: 2022-10-28
draft: false
---

The Taskwarrior inspired cli app allows for quick and flexible access to the tasks. It uses an Sqlite database that can be synchonized in the background by a cron job.<!-- more --> See the paragraph on Configuration below.

## Commands

### Synchronisation

```
$ gte fetch
```

Fetches all tasks from the remote mailbox and updates the local database.

```
$ gte send
```

Sends local updates as emails to the mailbox.

```
$ gte sync
```

Combines `fetch` and `send` in one convenient command with the aim to make two way synchronisation fluent. Due to the delays inherent to transporting data with emails, results can look confusing when the `send` and `fetch` commands are used in quick succession without thought. For instance, a just created task might disappear temporarily when doing a `fetch` right after a `send`, because the new task did not arrive at its final destination in the remote mailbox yet. For the local app, it is not possible to distinguish between a task that is not yet created and a task that was created, but was already deleted by another app. There is no data lost, the new task will magically come back later, but it looks confusing.

To smoothen this, the `sync` command always sends new updates, but fetches the contents of the remote mailbox only if the latest `send` was more than 2 minutes ago and the latest `fetch` was more than 15 minutes ago. The latter condition is to ease the load on the mail server.

### Listing due tasks

```
$ gte today
```

Show all tasks that are due today, or that are overdue.

```
$ gte tomorrow
```

Shows all tasks that are due tomorrow.

```
$ gte week
```

Shows all tasks that are due this week.

### Task management

```
$ gte projects
```

Show all projects.

```
$ gte project [PROJECT]
```

Show all tasks in project with name `[PROJECT]`.

```
$ gte folder [FOLDER]
```

Show all tasks in folder with name `[FOLDER]`. Can be `new`, `recurring`, `planned` or `unplanned`.

### Single task operations

```
$ gte new [TASK STRING]
```

Create a new task. See below for specifiying a task string. Fields that are not specified will be left empty.

```
$ gte [LID]
```

Show details a task with local id `[LID]`. See below for information on local id's.

```
$ gte [LID] mod [TASK STRING]
```

Update task with id `[LID]` with `[TASK STRING]`. See below for information on local id's and task strings. Fields that are not specified will keep their original value.

```
$ gte [LID] done
```

The thing it is all about: marking a task done.

```
$ gte [LID] del
```

Deleting a task. Under the hood this is the exact same operation as marking a task done. The field `done` will be set to `true` (as in "I'm done with this") and the task will be removed. Altough the outcome is exactly the same, it feels very wrong to mark a task done that you did not actually do and this alias helps with that.

## Local ID's

Under the hood, tasks are identified by UUID's, but those are long and cumbersome to type on the command line. The app therefore generates local id's that don't have that problem. The local id's are simple numbers. They start with `1` for the first task and count to `2`, `3`, etc. for each next task that enters the application. This means that the same task can have different numbers on different devices. That are only meant to make sense in the context of that particular device.

There are two "rules" used keep them short and useable. The first is that once a task has a number, that number will not change. So deleting a task, or marking a task as done will remove it's id, but that will not cause a re-iteration of the other tasks and that number will not be re-used right away. The next new task that enters the system will get the id of the last id issued, incremented with `1`.

To prevent the numbers from getting too high after running for a few weeks, months or years, the app will try to find an unused id before adding a decimal. So if there are `9` tasks, and all numbers from `1` to `9` are taken, the next task will get `10`. But if there are four tasks, with id's `1`, `2`, `5` and `9`, the next new task will get `3`.

In practice this means a maximum of three digits for a local id, which is easy to type and to recognize.

## Task strings

Both `new` and `mod` use additional parameters for creating or updating the task. They follow the format of `prefix:value` where `prefix` indicates the fields for setting the project (`project` or `p`), the due date (`due` or `d`), or the pattern for recurring (`recur` or `r`). The text without any prefix is used to set the action. The order of the parameters does not matter.

Dates and recur patterns are the same as in the mail format. The recur pattern often needs quotes to prevent the shell from parsing characters like `&`.

Example:

```
$ gte new project:groceries due:tomorrow get milk
```

Same task, but shorter:

```
$ gte new get milk d:tom p:groceries
```

## Configuration

The app needs a configuration file. The path of that file is indicated by setting the environment variable `GTE_CONFIG`. The file itself has .ini-style formatting with the following key-value pairs:

```
imap_url = imap.example.com:993
imap_username = ewintr@example.com
imap_password = xxxxxxx
imap_folder_prefix = GTE/

smtp_url = smtp.example.com:465
smtp_username = ewintr@example.com
smtp_password = xxxxxxx

to_name = gte
to_address = gte@example.com

from_name = gte
from_address = gte@example

local_db_path = /home/ewintr/.local/share/gte/gte.db
```
