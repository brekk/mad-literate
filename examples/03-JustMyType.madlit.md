Types are where Madlib really shines.

If you've worked in Haskell before, these are _mostly_ the same types you're used to. See [[Coming from Haskell]] for a brief overview of the differences.

There is also a [[Coming From JavaScript]] page. If you're coming from TypeScript, welcome! You have a lot to unlearn.


# Types

Ok, so types are pretty magical. Let's go over some examples.

In something like JavaScript, you might well have a "magic" value that you compare things to while doing logic, and do different logic if that magic value is found.

```js
const MAGIC = '__magic_value_do_not_use__'
const gapFill = (xs) => xs.reduce(
  (agg, x) => [
    ...agg,
    x === MAGIC
      ? agg[agg.length - 1]
      : x
  ],
  []
)
// fill some gaps
const filled = gapFill([1, MAGIC, 2, MAGIC, MAGIC, 3, MAGIC])
console.log("FILLED", filled)

```

JS is fine with this, anything can be compared to anything, whatever might equal whatever, deal with the problem at runtime.

Madlib aims to fix this by using a strongly typed system that doesn't allow for variadic inputs, nor mixed types.

We can define our own `Magic` type.

For the above, we need some way of expressing a value that is special. We could try something like:

```madlib#declaration-magic.attempt-one
type Magic = Magic
```

But this would only allow us to work with Magic as a discrete value. ☝ The above expression effectively says to the compiler "There is a new type called `Magic`. It has only one constructor, which takes no arguments and is a singleton — this constructor is also named `Magic`".

In order to make this a more useful value, we can create what's called a discriminated union:


```madlib#declaration-magic.attempt-two
type Listable = Entry | Magic
```

The above effectively says to the compiler: "There is a new type called `Listable`. It has two constructors, both singletons, named `Entry` and `Magic`"

However, we still don't have a way of dealing with natural values yet, so we need to add some value _inside_ the Entry constructor. Otherwise, when we create a list, we will only have the options above:

```madlib#using-magic.attempt-two
list = [Entry, Magic, Entry, Magic, Magic]
```

That's easy to fix, we can define a Listable which is either a wrapped String or the magic value:

```madlib#declaration-magic.attempt-three
type Listable = Entry(String) | Magic
```

Now we have a working value, if we wanted to we could write

```madlib#using-magic.attempt-three
list = [Entry("1"), Magic]
```

However, the original example allows uses number literals, not strings, so how can we make that change? **By adding a type variable**.

```madlib#declaration-magic.final!
type Listable a = Entry(a) | Magic
```

Now we can use numbers how we'd expect

```madlib#using-magic.final!
list = [Entry(1), Magic, Entry(2), Magic, Magic, Entry(3)]
```

However, unlike JavaScript, you can't have a mixed list:

```madlib#_
syntaxError = ["this is invalid", 1]
```

This is a feature, not a bug. Mixed lists are an abomination. We will go over ways of encapsulating types in a future guide.

***

How do we complete the `gapFill` function above using Madlib?

```madlib#fillable-gaps-in-functional-form
gapFill :: List (Listable a) -> List (Listable a)
gapFill = (xs) = List.reduce(
  (agg, x) => where (x) {
    Entry(_x) => [...agg, _x]
    Magic => [...agg, List.last(agg)]
  }
)
```

Additionally, since our `Listable` type only has two constructors, we can use a single underscore to represent "any other case".

```madlib#fillable-gaps-in-functional-form.v2
gapFill :: List (Listable a) -> List (Listable a)
gapFill = (xs) = List.reduce(
  (agg, x) => where (x) {
    Entry(_x) => [...agg, _x]
    _ => [...agg, List.last(agg)]
  }
)
```


## Summary
- Types
- Type Inference
- Literal Types
- Aliases
- Pipe & Curry
