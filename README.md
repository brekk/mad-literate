---
IO: IO
List: List
Fn: Function
---

# mad-literate

[![Madlib Project Badge](https://img.shields.io/badge/madlib-purple?logo=github&logoSize=auto)](//github.com/madlib-lang/madlib) <!-- $MADLIB.projectBadge -->
[![mad-literate v0.0.1](https://img.shields.io/badge/v0.0.1-purple?label=version)](//github.com/brekk/mad-literate) <!-- $MADLIB.json.version -->

[Literate programming](//en.wikipedia.org/wiki/Literate_programming) for Madlib. 

## Command-Line Tool

Installs the `madlit` tool

### read and transform a `.madlit.md` file

By default `./Example.madlit.md` will be transformed into `./Example.literate.mad`

```bash
madlit -i ./Example.madlit.md
madlit --input ./Example.madlit.md
```

This output can be customized with the output (`-o`, `--output`) flag:
```bash
madlit -i ./Example.madlit.md -o ./CustomMain.mad
madlit --input ./Example.madlit.md --output ./CustomMain.mad
```

### run a `.madlit.md` file

Creates `./Example.literate.mad` and runs it
Equivalent to `madlit -i ./Example.madlit.md && madlib run ./Example.literate.mad`

```bash
madlit -i ./Example.madlit.md --run
```

Can be customized with the output flag!
Equivalent to `madlit -i ./Example.madlit.md -o ./CustomMain.mad && madlib run ./CustomMain.mad`

```bash
madlit -i ./Example.madlit.md -o ./CustomMain.mad -r
```

## Literate Madlib syntax

```madlit.md
---
IO: IO
List: List
Fn: Function
---
```
# Madlib Literate Syntax
It's [Markdown](markdown) but also the code ends up being used as the body of a runnable / `main` Madlib function.

    a = 100
    b = 33


This content exists before the `main` declaration, because of the magic `***` delimiter. Markdown will simply treat this as a horizontal rule.

    type RGB a = Red(a) | Blue(a) | Green(a)
    type Knowledge a = Unknown | Known(a) | Learned(a)


***

## Headmatter

The Headmatter mark, three dashes in a row (`---`) is a magic delimiter which allows for automatic imports with minimal effort
`mad-literate` expects either zero or two Headmatter marks that wrap the potential imports, one per line.
For each line between these headmatter marks: 

 1. A line with a single value with no spaces and no colons, such as `IO`, is evaluated to an implicit named import: `import IO from "IO"`
 2. A line with a colon-delimited value, such as `Fn: Function`, is evaluated to an explicit aliased named import `import Fn from "Function"`
 3. A line with both a colon-delimited value and vertical bars on the left side, such as `fromMaybe | Just | Nothing : Maybe`, is evaluated as an import declaration `import {fromMaybe, Just, Nothing} from "Maybe"`
 4. A line with a two-colon-delimited value, such as `Maybe :: Maybe` is a type import expression: `import type { Maybe } from "Maybe"`
 5. A line with both a two-colon-delimited value and vertical bars on the left side, such as `Stream | Message :: Stream` is evaluated as a named member type import: `import type { Stream, Message } from "Stream"`

(NB: Only rule 1 / the implicit named import is technically invalid according to many Markdown parsers which allow for headmatter. We support it for ease-of-use, but if you want to make your .litmad.md files most portable, you should avoid using it)


This very file has headmatter imports, which means that we can execute this file and the following expression:

    map(
      (i) => pipe(

As long as we keep a minimum of 4 spaces, we can even comment across code lines

        Fn.ifElse((x) => x % 2 == 0, Red, Blue),

Which is pretty cool

        IO.pTrace(`What color is ${show(i)}?`),
        Learned
      )(i),
    )([a, b])

There's nothing required to close the `main` function, regardless of whether you're using the magic `***` delimiter or not.

> See the `./examples` directory for more complex examples!
