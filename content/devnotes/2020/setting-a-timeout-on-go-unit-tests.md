---
title: "Setting a timeout on go unit tests"
date: 2020-07-23
draft: false
---

There are multiple ways of ensuring that a test suite does not take too long to run. The first is simply by setting a timeout as an option with the go test command:<!-- more -->

```
go test -timeout 300ms
```

One can use any value that `time.ParseDuration` accepts.

The second is making use of a channel within the test itself:

```
func TestWithTimeOut(t *testing.T) {
  timeout := time.After(3 * time.Second)
  done := make(chan bool)

  go func() {

    // do your testing here
    testTheActualTest(t)

    done <- true
  }()

  select {
    case <-timeout:
      t.Fatal("test didn't finish in time")
    case <-done:
  }
}
```

I've found this to be useful in tests that cover concurrent code. Sometimes a bug in that code could cause the test to hang forever, so a backstop is needed. But if things go well, we don't want to add any artificial delays.

## Source

* [stackoverflow.com](https://stackoverflow.com/questions/24929790/how-to-set-the-go-timeout-flag-on-go-test)
