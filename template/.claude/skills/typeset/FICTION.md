# FICTION.md — typeset, fiction mode

The domain for setting a novel for print: chapter openers, drop capitals, scene breaks, epigraphs,
maps, and words in a constructed language where the project has one.

## Paths and unit

- **Unit:** the chapter. Markdown `manuscript/src/NN-kebab-title/NN-kebab-title.md`; base
  `typeset/src/units/.base/NN-kebab-title.tex`; styled file `typeset/src/units/NN-kebab-title.tex`.
- **Extra reads before styling:** `manuscript/docs/reference/scene-craft.md` (why the scene breaks
  fall where they do) and `research/src/permissions.md` (every epigraph or quotation quoted from
  another work, and its clearance).
- **Maps** live in `assets/` and reach the page through `\housemap{…}`, where the author places
  them.
- **Constructed languages**, where the project has them: the conlang-in-print guide in
  `typeset/docs/reference/` covers the two marks, the fonts `make font` builds and restraint on the
  page.

## Additions to the steps

- **Step 2 — also give the chapter opener and the scene-break mark particular care**: they set a
  novel's voice on the page. Where the project has constructed languages, ask which words, if any,
  print in their native script, and whether a glossary goes in the back matter.
- **Step 5 — also open each chapter with a drop capital, if page design chose them**: split the
  first word of the chapter's first paragraph, `\dropcap{T}{he}`, keeping any opening quotation
  mark outside it. Place a map with `\housemap{assets/maps/…}` only where the author says.
- **Step 7 — also read for fiction:** every scene break where the Markdown put it, including one
  that falls at a page break (the mark must still show); the epigraph and its source; dialogue
  punctuation untouched; no widow on the last page of a chapter; every native-script word drawn
  (a missing glyph prints as nothing, and `make print` reports it), and no 'no font' warning
  unless the author accepted romanised italic.

## Domain rules

- **Scene breaks, epigraphs and chapter divisions are the author's structure.** They are marked
  in the Markdown and arrive in the base; the LaTeX never adds, moves or removes one.
- **Dialogue and dialect are the author's.** Never regularise a spelling, an elision or a
  quotation mark while styling; the check catches a changed word, and this rule covers intent.
- **An epigraph quoting another work needs its clearance recorded** in
  `research/src/permissions.md` before a release print; report any that lack it.
- **Restraint with invented languages on the page**: report density to the author, never cut a
  word yourself.

## Examples

A chapter opening, styled (invented prose):

```latex
% base
The river was louder in the dark.
% styled
\dropcap{T}{he river} was louder in the dark.
```

`make tex-check` passes: the two arguments of `\dropcap` print as one word, 'The'. Styling it as
`\dropcap{T}{he River}` fails: the case of a word outside small capitals changed.
