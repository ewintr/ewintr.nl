---
title: "Shared environment variables for make, bash and docker"
date: 2020-01-07
draft: false
---

It is possible to define a set of variables and share them in Make, Bash and the Docker containers that are orchestrated by `docker-compose`.<!-- more -->

Docker-compose can use an `.env` file to substitute variables in a `docker-compose.yml` file in the same directory. In this `docker-compose.yml` they can be exported to the containers.

Incuding this `.env` file in your `Makefile` makes hem available there as well, but they are not automatically exported to the Bash shells that are spawned by `make` to execute the targets. This can be changed by adding the `.EXPORTALLVARIABLES:` target to your `Makefile`.

```
# .env
VAR1=this
VAR2=that
VAR3=those
```

```
# Makefile
include .env

.EXPORT_ALL_VARIABLES:

task:
  @echo "VAR1 is ${VAR1}"
  @some_command           # some_command can use $VAR1, $VAR2 and $VAR3
  @docker-compose up
```

```
# docker-compose.yml
...
app:
  image: "registry/the_app:${VAR2}"
  environment:
    - VAR3=${VAR3}
```

## Sources

* [vsupalov.com](https://vsupalov.com/docker-arg-env-variable-guide/#the-dot-env-file-env)
* [www.gnu.org](https://www.gnu.org/software/make/manual/html_node/Special-Targets.html#Special-Targets)
