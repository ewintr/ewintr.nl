---
title: "Faster transfers between go services with ndjson"
date: 2021-05-27
draft: false
---

A lot of services have the job to query other services for data and the most straightforward way to do that is to use JSON over a REST API. If the data consists of a big list of things, that means sending over a large JSON array with objects.<!-- more -->

Marshalling and unmarshalling the data can become quite expensive if there is enough of it. A simple way to cut down on a part of those costs is to not use a big array for all those items, but to send them just one by one, each one starting on a new line.

Let's say normally the body of your response would like this:

```
[
  {...},
  {...},
  {...}
]
```

You could change that to the following without losing information:

```
{...}
{...}
{...}
```

Separating each JSON object with a newline. ndJSON means: newline delimited JSON. This avoids creating (and interpreting) the large structure that binds all the objects together. They already are in the same response body so it didn't add much information anyway.

## Example

In pseudo code. Let's say we have a list of Things:

### Sending service

```
body := []byte{}
switch c.Request.Header.Get("Accept") {
  case "application/octet-stream":   // simple content negotiation, send only if the receiver understands it
    for _, thing := range things {
      jsonThing, err := json.Marshal(thing)
      if err != nil {
        // do something about it
      }
      body = append(ndJson, jsonThing...)
      body = append(ndJson, []byte("\n")...)
    }
  default:	    // normal json marshaling for those who don't expect anything special
    body, err = json.Marshal(things)
}
```

### Receiving service

At the place where you interpret the response body:

```
  defer respo.Body.Close()
  jsonThings, err := getLinesFromBody(resp.Body)
  if err != nil {
    // do something
  }

  var things = []*Thing{}
  for _, jsonThing := range jsonThings {
    var thing *Thing
    if err := json.Unmarshal([]byte(jsonThing), thing); err != nil {
      // do something
    }

    things = append(things, thing)
  }
```

Use the standard `bufio.Scanner` to transform the body in a slice of strings:

```
func getLinesFromBody(r io.Reader) ([]string, error) {
  var lines []string
  scanner := bufio.Scanner(r)
  scanner.Buffer([]byte{}, 1024*1024) // if necessary, increase max buffer size from default 64kb to 1mb
  for scanner.Scan() {
    lines = append(lines, scanner.Text())
  }
  if err := scanner.Err(); err != nil {
    return []string{}, err
  }

  return lines, nil
}
```

