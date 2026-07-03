---
IO
List
Fn: Function
---

# Madlib Literate Syntax
It's [Markdown](markdown) but also the code ends up being used as the body of a runnable / `main` Madlib function.

    a = 100
    b = 33



This content exists before the `main` declaration, because of the magic `***` delimiter. Markdown will simply treat this as a horizontal rule.

    type RGB a = Red(a) | Blue(a) | Green(a)
    type Knowledge a = Unknown | Known(a) | Learned(a)


***

## Headmatter
The Headmatter mark, three dashes in a row (`***`) is a magic delimiter which allows for automatic imports with minimal effort
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
        Fn.ifElse((x) => x % 2 == 0, Red, Blue),
        IO.pTrace(`What color is ${show(i)}?`),
      )(i),
    )([a, b])

There's nothing required to close the `main` function, regardless of whether you're using the magic `***` delimiter or not.
