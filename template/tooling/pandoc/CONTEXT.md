# CONTEXT.md — tooling/pandoc/

The house Pandoc filter. Every Pandoc run the `Makefile` makes passes through `house.lua`, which
turns what the author marked in Markdown (an epigraph, a scene break, small capitals, a word in
another language) into the right construct for the output being written: the house macros for
a printed book, the matching styles in Word, classes in an e-book, and the bare words for the
fidelity check. So one Markdown source serves every format, and no format needs the author to
write layout.

## Directory Tree

```text
tooling/pandoc/
├── CONTEXT.md            ← this file
├── CLAUDE.md             ← operating rules
└── house.lua             ← the filter: semantic Markdown in, the right construct for each output
```

## What's here

- `house.lua` — its header lists every mark it reads, what each becomes in each output, and the
  three modes the `Makefile` sets as metadata: `house-class` (the printed book's macros),
  `house-book` (in a book, a horizontal rule is a scene break) and `house-refs-only` (the
  reference list alone, for the back of a printed book). An author never sets a mode.
- **What it never does:** change a word. It wraps, renames and drops markup; the words reach every
  output as the author wrote them, which is what lets the fidelity check compare a LaTeX file's
  words with the Markdown's through this same filter.

## Cross-references

- `Makefile` — every Pandoc run, and the metadata each passes to the filter.
- `tooling/defaults.yaml` — the Pandoc settings the filter runs alongside.
- `.claude/rules/syntek-author/04-build-pipeline.md` — where the filter sits in the pipeline.
