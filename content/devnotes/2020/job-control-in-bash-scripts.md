---
title: "Job control in bash scripts"
date: 2020-01-06
draft: false
---

One should be careful when considering an option like this. Sending processes to the background in a script, are you sure this is what you want?<!-- more -->

However, sometimes ducktape is the only thing that works. Like here, in the case of an old Mongo Docker image that had no working way of importing a seed database at the startup of the container. The `RUN` command had to start Mongo, wait for it to become ready and import the seed data. The container would abort after the command was done, so the two processes had to be managed within the script.

After some failed attempts with `bg` and `fg`, it turned out that bash does not allow job control in scripts, unless you set the `-m` option.

The working result:

```
#!/bin/bash
set -m

echo "Starting Mongo..."
mongod &

echo "Waiting for Mongo to accept connections..."
RESULT=1
while [ $RESULT -ne 0 ]; do
  mongo --eval "db.stats()" >/dev/null 2>&1
  RESULT=$?
  sleep .5
done

echo "Run database fixture script..."
mongo /scripts/mongo_init.js

echo "Bringing back Mongo..."
fg
```

## Sources

* [stackoverflow.com](https://stackoverflow.com/questions/690266/why-cant-i-use-job-control-in-a-bash-script)
* [stackoverflow.com](https://stackoverflow.com/questions/16542372/shell-script-check-mongod-server-is-running#16546193)
