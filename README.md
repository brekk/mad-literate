# mad-literate

literate madlib!

## Command-Line Tool

Installs the `madlit` tool

### read and transform a `.litmad` file

By default `./Example.litmad` will be transformed into `./Example.literal.mad`

```bash
madlit -i ./Example.litmad
madlit --input ./Example.litmad
```

This output can be customized with the output (`-o`, `--output`) flag:
```bash
madlit -i ./Example.litmad -o ./CustomMain.mad
madlit --input ./Example.litmad --output ./CustomMain.mad
```

### run a `.litmad` file

Creates `./Example.literal.mad` and runs it
Equivalent to `madlit -i ./Example.litmad && madlib run ./Example.literal.mad`

```bash
madlit -r ./Example.litmad
```

Can be customized with the output flag!
Equivalent to `madlit -i ./Example.litmad -o ./CustomMain.mad && madlib run ./CustomMain.mad`

```bash
madlit -r ./Example.litmad -o ./CustomMain.mad
```

## Literate Madlib syntax

```litmad
IO
Fn: Function
---

This is content becomes a comment, but indented code

  a = 10

becomes the body of a `main` function

  IO.pTrace("what is a?", a)

The magic values before the triple-dash above `---` allow for dynamic imports with minimal effort

A line with a single value such as `IO` with no colon is implied to be: `IO: IO`
A line with a colon-delimited value, such as `Fn: Function` is compiled as `import Fn from "Function"`

```

See the `./Example.litmad` file for a more complex example!
