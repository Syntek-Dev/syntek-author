# CONTEXT.md — typeset/workflows/02-typeset-a-chapter/

The procedure for setting one chapter for print for the first time. Pandoc writes the chapter's
LaTeX from its Markdown (the base); a copy of the base becomes the styled chapter, which gains
house macros and nothing else; `make tex-check` proves every word is still the author's; the
chapter joins `book.tex` in plan order; and `make print` produces a proof that is read before
anything is reported done.

## Directory Tree

```text
typeset/workflows/02-typeset-a-chapter/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, what it produces, the one thing that matters)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

- A chapter's sections are promoted and the author wants to see it as it will be printed.
- The author asks to typeset, set or lay out a chapter for print.
- A chapter is in the outline but has no styled file in `typeset/src/units/` yet.

Reach for a **different** procedure when: the chapter already has a styled file and its Markdown
has changed (`typeset/workflows/03-retypeset-after-edits/`); the page design is still open and the
author wants to settle it first (`typeset/workflows/01-design-the-page/`); or a quick look at the
prose is all that is wanted (`make pdf`, in `manuscript/workflows/06-build-a-proof/`).

## What it produces, and where

| File | What |
|---|---|
| `typeset/src/units/.base/NN-kebab-title.tex` | the Pandoc base, written by `make tex` |
| `typeset/src/units/NN-kebab-title.tex` | the styled chapter: the base plus house macros |
| `typeset/src/book.tex` | one new `\houseinput` line, in plan order |
| `build/typeset/book.pdf` | the proof, read before reporting |

## The failure this procedure exists to prevent

**A word that changed on the way to print.** A styled chapter is the author's text in LaTeX; if a
model retypes a sentence while styling it, the change hides among thousands of macros. So the
words come only from Pandoc, styling only adds macros, and the check proves it before the print.

## Cross-references

- `typeset/docs/reference/the-typesetting-pipeline.md` — the stages this procedure runs.
- `typeset/docs/reference/the-house-class.md` — the macros the styling may add.
- `typeset/docs/reference/the-fidelity-check.md` — reading the check.
- `typeset/docs/reference/semantic-markdown.md` — what the Markdown has already marked.
