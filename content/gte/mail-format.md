---
title: "Mail format"
date: 2022-10-13
draft: false
---

The mails that are sent back and forth are in plain text and contain key-value pairs, one per line:<!-- more -->

```
key: value
```

The quote prefix `>` is stripped before evaluating. These keys are also valid:

```
> key1: value 1
>> key2: value 2
```

Lines are evaluated from bottom to top. If a key occors multiple times, later keys overwrite previous ones. So lines on top overwrite lines at the bottom.

## Fields

Recognized fields are:

* `action` - a string.
* `project` - a string. It is not required that the project is defined or declared elsewhere.
* `due` - date string. See below.
* `recur` - recur string, See below.
* `done` - boolean. The word "true" evaluates to `true`, everything else evaluates to `false`.

## Date string

There are several options to specify a date. The general form is `YYYY-MM-DD`. In addition to that `today` and `tomorrow` are also understood, as are the days of the week: `monday`, `tuesday`, `wednesday`, `friday`, `saturday`, `sunday` and their abbreviations `tod`, `tom`, `mon`, `tue`, `wed`, `thu`, `fri`, `sat` and `sun`. Those indicate the first occurence of that weekday after the current day. Unrecognized values will erase the field.

## Recur string

The recur string consists of two to three parts, separated by a comma. The first is the start date and follows the same semantics as a date string. The second specifies the period and the third can contain optional parameters.

The date format as `YYYY-MM-DD (weekday)` is also permitted, to facilitate processing replies and forwards of tasks. The weekday will be ignored in that case.

For the second part, the following periods are available:

* `daily`
* `every N days`, where `N` is an integer.
* `weekly`, with the weekdays specified in the third part, separated by & signs. For example, this recurrer starts today and recurs every Monday and Wednesday: `today, weekly, monday & wednesday`.
* `biweekly`, like `weekly`, but recurs only every other week.
* `every N weeks`, where `N` is an integer.
* `every N months`, where `N` is an integer.
