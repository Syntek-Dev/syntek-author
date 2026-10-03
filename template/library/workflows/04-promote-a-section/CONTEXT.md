# CONTEXT.md — library/workflows/04-promote-a-section/

The procedure for moving an approved section out of its drafts folder and into its document. On the
author's explicit word, the section's gates are checked, the Markdown draft is converted into
LaTeX and inserted into the `.tex` between its `% section: <slug>` markers, a word-check proves
nothing was lost or added, and the author's final text and change ratio are recorded in the
ledger. Promotion never makes a document `final`; that
takes the review in workflow 05 and the author's word again.

## Directory Tree

```text
library/workflows/04-promote-a-section/
├── CHECKLIST.md            ← verification checklist before marking complete
├── CLAUDE.md               ← operating rules for this workflow
├── CONTEXT.md              ← this file (when to use, what it produces, the failure it prevents)
└── STEPS.md                ← ordered steps to execute
```

## When to use this

- The author says, in words, that a named section is ready: 'promote the scope', 'that clause
  group can go in'.
- A section already in the document has been revised through the loop and the author approves the
  new text (a re-promotion).

Reach for a **different** procedure when: the author has notes on the section
(`library/workflows/02-adapt-a-draft/`) or wants suggestions
(`library/workflows/03-improve-your-draft/`); every section is in and the document needs checking
(`library/workflows/05-review-a-document/`); or the document has already been circulated, in which
case a new version is opened first (`library/docs/reference/versioning-and-the-register.md`).

## What it produces, and where

- **The section in the deliverable**, between its markers in the document's `.tex` (or `.md` for
  an authored email or web copy); the `.tex` created from `tooling/latex/skeleton.tex` if this is
  the document's first promotion.
- **The ledger entry completed:** `## Author final` holding the approved text, the `promoted` date
  and the `change_ratio`.
- **A row in `standards/style/ledger/provenance.md`.**
- **Status updates:** the draft at `promoted`; the section's line in the unit brief; a line in
  `.claude/MEMORY.md` `## Status`.
- **A working proof** in `build/` showing the section in place.

## The failure this procedure exists to prevent

**A section the author never approved reaching a client.** Drafts look finished long before they
are, and a model asked to 'tidy up the document' will happily paste them in. Promotion happens
only on the author's word, only for the section named, and only after its flags are cleared, so
the document holds nothing the author has not accepted.

## Cross-references

- `library/docs/reference/latex-deliverables.md` — markers, conversion and the house macros.
- `library/docs/reference/the-status-ladders.md` — what `promoted` does and does not mean.
- `tooling/provenance.py` — how the change ratio is measured.
