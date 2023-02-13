---
title: "Simple CI/CD with bash and git"
date: 2021-11-29
draft: false
---

A simple way to run a pipeline after an update of a project is to put the actions in a bash script and to let git trigger it.<!-- more -->

To do so, add a `post-receive` script in the `hooks` folder on the repository on the server:

```
#!/bin/bash
TARGET="/home/webuser/deploy-folder"
GIT_DIR="/home/webuser/www.git"
BRANCH="master"

while read oldrev newrev ref
do
  # only checking out the master (or whatever branch you would like to deploy)
  if [[ $ref = refs/heads/$BRANCH ]];
  then
    echo "Ref $ref received. Deploying ${BRANCH} branch to production..."
    git --work-tree=$TARGET --git-dir=$GIT_DIR checkout -f
  else
    echo "Ref $ref received. Doing nothing: only the ${BRANCH} branch may be deployed on this server."
  fi
done
```

This will deploy straight to the target folder from the repository by doing a checkout there.

## With staging area

A slightly more advanced version is to have the `master` branch deploy to the production folder and all other branches to a test or staging folder that can be viewed by you, but not by the public. So the result of the changes can be reviewed before putting them live.

Whenever automations become more complicated, it is wise to put them in a separate script

`post-receive` script:

```
#!/bin/bash

while read oldrev newrev ref
do
  if [[ $ref = refs/heads/master ]];
  then
    echo "deploying to production from post-receive hook..."
    /path/to/deploy-prod.sh
  else
    echo "deploying test from post-receive hook..."
    /path/to/deploy-test.sh'
  fi
done
```

`deploy-prod.sh`:

```
#!/bin/bash
SRCDIR=/tmp/deploy
RESULTDIR=/tmp/deploy/public
TARGETDIR=/var/www/html/my-website.nl

echo "* checkout project"
mkdir $SRCDIR && cd $SRCDIR && git checkout master && git pull

echo "* generate html"
cd $SRCDIR && [commands that put result in $RESULTDIR]

echo "* deploy to webserver"
rm -r $TARGETDIR/*
mv $RESULTDIR/* $TARGETDIR/

echo "* done"
```

`deploy-test.sh` is trickier, because it needs to figure out which branch was pushed and needs to be deployed. One could probably pass some arguments, but if there are not too many people working on it, it is also an option to just pull whatever branch was updated last:

```
echo "* checkout site"
cd $SRCDIR && git fetch && git checkout $(git rev-parse $(git branch -r --sort=-committerdate | head -1))
```

## Users and permissions

Speaking of users, while we are talking about simple projects here, one should keep privileges separated and use system accounts for trivial automations. Let's say the repository hooks run as user `git`, but that the deployment script is owned by `web`. 

One option is to use `sudo` in the post receive script to let `git` impersonate `web` and to configure `sudo` so that these, but only these deploy commands may be issued by `git` as `web` without having to enter a password.

Start `visudo` and add the following line to the config:

```
# User privileges specification

git ALL=(web)	NOPASSWD:/path/to/deploy-prod.sh,/path/to/deploy-test.sh
```

After saving that the deploy scripts can be triggered in the `post-receive` hook by:

```
sudo -u web /path/to/deploy-prod.sh
sudo -u web /path/to/deploy-test.sh
```

## Sources

* [stackoverflow.com](https://stackoverflow.com/questions/28106011/understanding-git-hook-post-receive-hook)
* [stackoverflow.com](https://stackoverflow.com/questions/2427288/how-to-get-back-to-the-latest-commit-after-checking-out-a-previous-commit)
* [www.baeldung.com](https://www.baeldung.com/linux/run-as-another-user)
