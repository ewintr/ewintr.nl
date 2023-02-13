---
title: "Channel with infinite buffer in go"
date: 2020-07-09
draft: false
---

n Golang we have buffered and unbuffered channels. Buffered channels can hold an x amount of values "in transit" before the channel is blocked from writing. It is necessary to read a value from the other end first, to "make room", before more can be put in.<!-- more --> That amount x has to be specified and is limited.

Sometimes one wants the readers and the writers of the cannel to be completely independent from each other, so it is always possible to write, regardless of the speed of reading. For that to happen with a buffered channel, x would have to be very, very large. This is undesirabele.

Jon Bodner described a much better solution in this article on Medium, that uses two channels with a slice in between. There are some tricky details, so go read it before you copy and paste the final result shown below. I save it here to make sure it stays up and that I can find it again in a few years from now. Also, the text below is actual text that you can copy and paste.

One does not need to use an empty interface like he did, of course. In general channels have a type as you know what will flow through it beforehand. Here we will pretend that the channel is of type `*Thing` and that `Thing` has an id of type `string` that we can get by calling `Thing.Id()`. Because that happens to be the usecase I have in front of me right now.

Also, there needs to be some locking to make it thread safe.

```
package thing

type Queue struct {
	inQueue []*Thing
	in      chan *Thing
	out     chan *Thing
}

func NewQueue() *Queue {
	q := &Queue{
		inQueue: []*Thing{},
		in:      make(chan *Thing),
		out:     make(chan *Thing),
	}

	go func() {
		outCh := func() chan *Thing {
			if q.Count() == 0 {
				return nil
			}

			return q.out
		}

		cur := func() *Thing {
			if q.Count() == 0 {
				return nil
			}

			return q.inQueue[0]
		}

		for len(q.inQueue) > 0 || q.in != nil {
			select {
			case oc, ok := <-q.in:
				if !ok {
					q.in = nil
				} else {
					q.Append(oc)
				}
			case outCh() <- cur():
				if q.out != nil {
					q.Unshift()
				}
			}
		}
		close(q.out)
	}()

	return q
}

func (q *Queue) In() chan *Thing {
	return q.in
}

func (q *Queue) Out() chan *Thing {
	return q.out
}

func (q *Queue) Close() {
	close(q.in)
}

func (q *Queue) Append(oc *Thing) {
	lock.Lock()
	defer lock.Unlock()

	q.inQueue = append(q.inQueue, oc)
}

func (q *Queue) Unshift() {
	lock.Lock()
	defer lock.Unlock()

	q.inQueue = q.inQueue[1:]
}

func (q *Queue) Count() int {
	lock.RLock()
	defer lock.RUnlock()

	return len(q.inQueue)
}
```

And the corresponding tests:

```
package thing_test

func TestNewQueue(t *testing.T) {
	count := 10
	idFormat := "id-%d"
	for _, tc := range []struct {
		name       string
		writeDelay bool
		readDelay  bool
	}{
		{
			name: "no delay",
		},
		{
			name:       "slow write",
			writeDelay: true,
		},
		{
			name:      "slow read",
			readDelay: true,
		},
		{
			name:       "slow read and write",
			writeDelay: true,
			readDelay:  true,
		},
	} {
		t.Run(tc.name, func(t *testing.T) {
			queue := thing.NewQueue()
			var lastIntId int
			lastId := fmt.Sprintf(idFormat, lastIntId)

			var wg sync.WaitGroup
			wg.Add(1)

			go func() {
				for o := range queue.Out() {
					if tc.readDelay {
						time.Sleep(50 * time.Millisecond)
					}
					lastIntId += 1
					lastId = fmt.Sprintf(idFormat, lastIntId)
					test.Equals(t, lastId, o.CaseId())
				}
				wg.Done()
			}()

			for i := 1; i <= count; i++ {
				if tc.writeDelay {
					time.Sleep(50 * time.Millisecond)
				}
				queue.In() <- newThing(fmt.Sprintf(idFormat, i))
			}
			queue.Close()
			wg.Wait()

			test.Equals(t, fmt.Sprintf(idFormat, count), lastId)
		})
	}
}

func TestQueueCount(t *testing.T) {
	for _, tc := range []struct {
		name  string
		count int
	}{
		{
			name: "empty",
		},
		{
			name:  "one",
			count: 1,
		},
		{
			name:  "two",
			count: 2,
		},
		{
			name:  "many",
			count: 50,
		},
	} {
		t.Run(tc.name, func(t *testing.T) {
			queue := thing.NewQueue()
			for i := 0; i < tc.count; i++ {
				queue.In() <- newThing(fmt.Sprintf("id-%d", i))
			}
			queue.Close()

			time.Sleep(50 * time.Millisecond)
			test.Equals(t, tc.count, queue.Count())
		})
	}
}
```

## Source

* [medium.com](https://medium.com/capital-one-tech/building-an-unbounded-channel-in-go-789e175cd2cd)
