---
title: "App: daemon for inbox processing and generating recurring tasks"
date: 2022-09-26
draft: false
---

There are two scripts that need to be executed on a regular basis:<!-- more -->

* Processing newly arrived emails
* Generating new instances of recurring tasks

This can be done by the cli app, but that requires a manual action. Generating new instances of recurring tasks should happen only once a day, but the processing of new emails is ideally done as often as every couple of minutes. One can use a cron job to do this, but that requires a machine that is switched on for the majority of the day, at least during waking hours, to make sure changes are reflected. At that point we might as well have a real service, with proper logging, etc. The `gte-daemon` is just that. The cli can still be used as a fallback though.

In the past it has run as a systemd service, but now there is a simple Docker container for portability between hosting providers. See `Dockerfile.daemon` in the repository. It is a simple service and does not require much.

## Parameters and configuration

The Dockerfile is configured with the following environment variables:

```
IMAP_URL            # IMAP hostname including port number, for instance: imap.example.com:993
IMAP_USER
IMAP_PASSWORD
IMAP_FOLDER_PREFIX  # To be used if combined with a normal email account, for instance: GTE/
SMTP_URL            # SMTP hostname, including port number, for instance: smtp.example.com:465
SMTP_USER
SMTP_PASSWORD
GTE_TO_NAME         # Name of recipient when sending mails for tasks, for instance: gte
GTE_TO_ADDRESS      # Address of recipient when sending mails for tasks, for instance: gte@example.com
GTE_FROM_NAME       # Name of sender when sending mails for tasks, fot instance: gte
GTE_FROM_ADDRESS    # Address of recipient when sending mails for tasks, for instance: gte@example.com
GTE_DAYS_AHEAD      # Number of days in the future for which recurring tasks must be instantiated, for example: 6
```       
