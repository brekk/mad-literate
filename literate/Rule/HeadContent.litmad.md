---
!library: true

Tuple: Tuple
Fn: Function
List: List
fromMaybe,: Maybe
String: String

Rule: spirit-gum/Rule
Transformer: spirit-gum/Rule/TransformerBody
BodyValidator, : spirit-gum/Rule/Validator

HEAD_MARKER, LIBRARY, : @/Constants
Headmatter: @/Headmatter
_List : @/List
---

This file defines the Headmatter rule. It will process content between the `---` / `HEAD_MARKER` delimiters in a source file.

    isHeadmark = Fn.equals(HEAD_MARKER)

By convention, we're prefixing things with _ when they would normally be private (but we're exporting them for testing).

We assume (because it is ultimately enforced in the validator) that the first line we're given is a headmarker, so we simply chop it off.

    export _findTailHeadmark = pipe(
      _List.chop(1),
      List.find(
        pipe(
          Tuple.snd,
          isHeadmark,
        ),
      ),
      map(Tuple.fst),
      fromMaybe(-1),
    )


This takes our function above and lifts it into a Transformer which we can use with `spirit-gum`

    export _findHeadmarker = Transformer.ofBodyState(
      (meta, lines) => ({ ...meta, headmarker: _findTailHeadmark(lines) }),
    )

This gives us a slight wrapper for the `processHead`, but we need to remove the trailing headmarker, drop the line numbers first.

    export _processHeadcontent = pipe(
      map(Tuple.snd),
      Headmatter.processHead,
    )

Here we're processing the imports and adding them to the state record. One of the only complications is supporting library files, which don't have a `main` and aren't runnable on their own.

    export _checkLibraryFile = List.any(pipe(Tuple.snd, String.contains(LIBRARY)))

    export _processFauxImports = Transformer.ofBodyRaw(
      (meta, lines) => {
        hasHeadmarker = meta.headmarker > -1
        isLibrary = _checkLibraryFile(lines)
        headlines = List.slice(1, meta.headmarker - 1, lines)
        imports = (hasHeadmarker ? _processHeadcontent(headlines) : meta.imports)
        return #[{ ...meta, isLibrary, imports }, hasHeadmarker ? _List.chop(meta.headmarker + 1, lines) : lines]
      },
    )

You're allowed to have no headmatter content (if all the code is local, ostensibly), but if you have one headmatter mark, you must have a second one.

    export _hasTwoOrZeroHeadmarks = BodyValidator(
      (_, b) => {
        lines = String.lines(b)
        first = _List.findIndex(isHeadmark, lines)
        second = _List.findIndexAfter(first, isHeadmark, lines)
        return (first == 0 && second > 0) || (first == -1 && second == -1)
      },
    )

This is the core export, a `spirit-gum` body rule. 

    export rule = Rule.bodyRule(
      false,
      "mad-literate/headmarker",
      [_hasTwoOrZeroHeadmarks],
      [_findHeadmarker, _processFauxImports],
    )
