---
title: "Basic flow"
date: 2022-02-24
draft: false
---

In the [previous post](@/gte/email-based-task-management.md) I described my whish list for a task management system based on email and IMAP. After some experimenting, I came to s simple system that made it work.<!-- more --> At minimium, it consists of the following parts:

* A central IMAP account with an email address.
* A flow to process mails that are sent to that account.
* A format for the mails that can describe a task.

The above was enough to the ball rolling, but since then I added:

* A sync mechanism for a local Sqlite database through IMAP and SMTP.
* A [taskwarrior](https://taskwarrior.org/) inspired cli app for quick manipulation of tasks.

More local apps are in the works.

## Central IMAP account

Naturally, the `INBOX` folder is the place where all emails come in and that is the place where we need some sorting to be done. This process is automated and can be triggered from multiple places. See 'Remote vs local' to get a sense how the different applications of this project can work together for a smooth experience.

On a functional level, there are two types of mails that can come in:

* New tasks. These don't necessarily have the the right format yet.
* Updates on existing tasks.

There will be another doc with details off the format of the mails, but the simple summary is that a task is a plain text mail with key-value pairs on separate lines.

In principle, we have the following folders:

```
INBOX/
├── New
├── Planned
├── Recurring
└── Unplanned
```

I say in principle, because after a while, I realized that I don't need to keep a separate mail account for this. It can also work with a regular account that is already being used for personal email, if the above is put into a subfolder and a forwarding rule is added: "send all mails to gte@example.com to the folder GTE/INBOX".

Now we have:

```
INBOX/              # Normal inbox for personal account
Archive/
Spam/
...
GTE/
└── INBOX/          # Inbox for tasks
    ├── New
    ├── Planned
    ├── Recurring
    └── Unplanned
```

So all mails arrive in `GTE/INBOX`. From there the following can happen:

* If the mail is new, or not recognized as an update, it is put in `New`.
* If the mail is recognized as an update, it is put in `Planned`, `Recurring` or `Unplanned`. Existing mails with older versions of the task are removed.
* Tasks with a `recur` field go in `Recurring`, tasks with a `due` field go in `Planned` and the the rest goes to `Unplanned`. `recur` takes precedence over due.
* Shortcut: if a new mail has a `project` specified, it skips `New` and is put into one of the other folders right away.

That last rule is because sometimes you just want to jot something down and refine it later, but other times you want to specify the whole task right away and not having to go to the trouble of updating it later. Anything in `New` will stay there until there is some manual intervention. This takes inspiration from the [GTD](https://en.wikipedia.org/wiki/Getting_Things_Done) method, where gathering "stuff" and converting it into tasks are two separate actions.
Updating a task

Everything is put together in such a way that the systems even works from a normal (web)mail app. Updates are done by forwarding of, or replying to the mail with the task you want to update. The original mail is then quoted in the body and you just put the fields you want to update with the new values above this. (Yes, essentially top posting. A sin in certain parts of the internet. I planned to make this configurable, but almost all mail clients I use do it like this by default.)

Let's say we have the following task that we want to update:

```
To: todo@example.com
From: todo@example.com
Subject: 2022-01-01 (saturday) - resolutions - change system to disallow top posting

action:  change system to disallow top posting
project: resolutions
due:     2022-01-01 (saturday)
id:      416aad43-eec6-4ad2-8a3c-b84482e34c3c
version: 2 
```

The update: be less harsch about it and postpone it a year. To do this, forward the mail and add two lines above the quoted original one:

```
To: todo@example.com
From: your_account@example.com
Subject: FWD: 2022-01-01 (saturday) - resolutions - change system to disallow top posting

action: make quote style configurable
due: 2023-01-01

> action: change system to disallow top posting
> project: resolutions
> due: 2022-01-01 (saturday)
> id: 416aad43-eec6-4ad2-8a3c-b84482e34c3c
> version: 2 
```

After processing, this will lead to the following mail in the `Planned` folder:

```
To: todo@example.com
From: todo@example.com
Subject: 2023-01-01 (sunday) - resolutions - make quote style configurable

action:  make quote style configurable
project: resolutions
due:     2023-01-01 (sunday)
id:      416aad43-eec6-4ad2-8a3c-b84482e34c3c
version: 3
```

If there are no update lines, the task will stay the same. This means it is very easy to move the data when you want to switch providers. Just forward all tasks to the new mail account and you're done!

## Marking a task done

Simply delete the email.

To facilitate local clients that can only communicate by sending more mails to the address, it is also possible to add a field like this:

```
done: true
```

The central sorting process will then remove the mail for you.

## Navigating the folders

As can be seen from the examples above, part of the content is repeated in the subject line. This is to help navigating the tasks in a mail client. Simply sort the folder on subject.

Tasks with a due date get:

```
yyyy-mm-dd (weekday) - project - action
```

So if the `Planned` folder is sorted on subject, tasks of the same project on the same day get grouped together.

Tasks without a due date behave similar. They have:

```
project - action
```

## Recurring tasks

In addition to the process that processes new incoming mails, there is a process that generates new planned tasks based on the recurring tasks.

Currently there is no relation between the task that has a recurring rule and the individual tasks that get spawned as a result. There simply hasn't been a need for it yet. Instead, there is a process that runs daily and that checks if any of the tasks in the Recur folder recur x amount of days in the future. If so, it will create an instance for that date. x here is configurable. 6 days seems to work for me.

## Remote vs local

So far this document has been a bit fuzzy over where exactly these automated processes live. That is because it actually doesn't matter. The IMAP box is the central source of thruth and will reside somewhere on a server of your email provider. To manage it, there are currently two options. A long running daemon, or a local client. The latter perhaps triggered by a cron job.

Both of these options involve logging in to the IMAP account to do perform actions, so both can be done from anywhere. They can both run on a VPS, or on your laptop.

Local clients maintain copies of the tasks in the IMAP account, for speed and to be able to use the system when there is no internet connection. For sending and receiving updates, they too use IMAP and SMTP. A local client uses the same format of mails and the same process as a user would with a webmail client. 
