# CONTEXT.md — typeset/src/units/

The styled chapters: one `NN-kebab-title.tex` per chapter, named exactly as the chapter's folder
in `manuscript/src/`. Each began as a copy of its Pandoc base and differs from it only by house
macros. The bases sit in `typeset/src/units/.base/`, written by `make tex` and never edited,
because each is the common ancestor that lets styling be carried onto a chapter's new words.

## Directory Tree

```text
typeset/src/units/
├── CONTEXT.md                ← this file
├── CLAUDE.md                 ← operating rules
├── NN-kebab-title.tex        ← a styled chapter: the base plus house macros (none yet)
└── .base/                    ← Pandoc's base for each chapter; README.md, no pair
    ├── README.md             ← what the folder is for
    └── NN-kebab-title.tex    ← written by make tex; never edited by hand
```

## What's here

- `NN-kebab-title.tex` — **a styled chapter.** Its words are the Markdown's, through Pandoc;
  `make tex-check UNIT=NN-kebab-title` proves it. Its styling is the house macros listed in
  `typeset/docs/reference/the-house-class.md`. `typeset/src/book.tex` brings it into the book.
- `.base/NN-kebab-title.tex` — **the base**, exactly what Pandoc wrote for the chapter as it
  stood at the last `make tex`. Committed with its styled file, so the next carry-forward has the
  right ancestor even after `make clean`.

**How a chapter changes here:** the Markdown changes first, through the section procedures; then
`make tex` writes a new base and keeps the old one in `build/typeset/`, and `git merge-file`
carries the styling across (`typeset/workflows/03-retypeset-after-edits/`).

## Cross-references

- `typeset/docs/reference/the-typesetting-pipeline.md` — base, styled file and carry-forward.
- `typeset/docs/reference/the-fidelity-check.md` — what `make tex-check` compares.
- `manuscript/src/` — the source of every word here.
