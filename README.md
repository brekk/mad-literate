# mad-literate

literate madlib!

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
madlit -r ./Example.madlit.md
```

Can be customized with the output flag!
Equivalent to `madlit -i ./Example.madlit.md -o ./CustomMain.mad && madlib run ./CustomMain.mad`

```bash
madlit -r ./Example.madlit.md -o ./CustomMain.mad
```

## Literate Madlib syntax

```madlit.md
---
IO: IO
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
See the `./examples` directory for more complex examples!
