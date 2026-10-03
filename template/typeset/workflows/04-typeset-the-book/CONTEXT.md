# CONTEXT.md — typeset/workflows/04-typeset-the-book/

The procedure for making the whole printed book ready for a printer or publisher: every chapter
typeset and current, the front and back matter in place with words the author supplied, every
styled chapter proved against its Markdown, and one PDF printed from `typeset/src/book.tex` and
read from the first page to the last. Printing is a proof and runs at any time; sending the PDF
out is a release, and waits for the author's word and the chapters' `final` status.

## Directory Tree

```text
typeset/workflows/04-typeset-the-book/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, what it produces, the one thing that matters)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

- The author wants the print-ready PDF, or a full print proof of the book as it stands.
- A printer, publisher or early reader needs the typeset book.
- Several chapters have changed since the last full print.

Reach for a **different** procedure when: one chapter needs typesetting
(`typeset/workflows/02-typeset-a-chapter/`) or re-typesetting
(`typeset/workflows/03-retypeset-after-edits/`); or the page design is still being decided
(`typeset/workflows/01-design-the-page/`).

## What it produces, and where

- **Every styled chapter** current with its Markdown and passing `make tex-check`.
- **`typeset/src/book.tex`** listing the front matter, every chapter in plan order, and the back
  matter.
- **`build/typeset/book.pdf`**, read in full, with every warning accounted for.
- For a release print only: the `final` class option set, so an open flag stops the print.

## The one thing that matters most

**A release print is the author's book, word for word, in the author's design.** That is three
proofs at once: `make tex-check` for every chapter, zero open flags, and a full read of the PDF.
Any one missing, and what goes to the printer is a guess.

## Cross-references

- `typeset/docs/reference/the-typesetting-pipeline.md` — the stages, and the two kinds of proof.
- `standards/verification/verification.md` — Section 5, proofs and release; V6 (line-edit → final).
- `typeset/src/frontmatter/CONTEXT.md` and `typeset/src/backmatter/CONTEXT.md` — the pages around
  the text.
