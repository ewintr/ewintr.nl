---
title: "Conversions with iota in go"
date: 2020-04-17
draft: false
---

`iota` is a helpful way to enumerate constants in Go:<!-- more -->

```
const (
  c0 = iota
  c1
  c2
)

func main() {
  fmt.Println(c0, c1, c2) // "0 1 2"
}
```

But it is more flexible than just defining a constant to be an integer. According to the specification: _"A constant value is represented by a rune, integer, floating-point, imaginary, or string literal, an identifier denoting a constant, a constant expression, a conversion with a result that is a constant, or the result value of some built-in functions such as unsafe.Sizeof applied to any value, cap or len applied to some expressions, real and imag applied to a complex constant and complex applied to numeric constants."_

So we are allowed to use expressions and conversions on the right hand side of the `=` sign in a constant declaration. That means we can use `iota` in an expression or a conversion. A common use case for expression is creating a bitmask with the bit shift operator.

However, although less seen, conversions can be pretty useful as well:
```
type Priority string

const (
	_ = Priority("P" + string(iota+48))
	P1     // "P1"
	P2     // "P2"
	P3     // "P3"
	...
)
```

It is not possible to use `strconv` functions in the `const` block because, well, they're functions. According to the specification: _"A constant value x can be converted to type T if x is representable by a value of T. As a special case, an integer constant x can be explicitly converted to a string type using the same rule as for non-constant x."_

And that rule is: _"Converting a signed or unsigned integer value to a string type yields a string containing the UTF-8 representation of the integer. Values outside the range of valid Unicode code points are converted to "\uFFFD"."_

The first 128 characters of UTF-8 are the same as the ASCII characters, prefixed with a `0`. In ASCII the characters 0 to 9 are encoded sequentially from `48` until `57`, so `string(49)` converts to `"1"`. The letters of the alphabet are encoded sequentially as well, so a range of constants representing grades from A to F could be declared in the same fashion:

```
type Grade string

const (
  A = Grade(string(iota+65))
  B
  C
)
```

## Sources

* [golang.org](https://golang.org/ref/spec#Constants)
* [golang.org](https://golang.org/doc/effective_go.html#constants)
* [golang.org](https://golang.org/ref/spec#Conversions)
* [golang.org](https://golang.org/ref/spec#Conversions_to_and_from_a_string_type)
* [nl.wikipedia.org](https://nl.wikipedia.org/wiki/UTF-8)
* [en.wikipedia.org](https://en.wikipedia.org/wiki/ASCII#Printable_characters)
