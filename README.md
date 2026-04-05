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
