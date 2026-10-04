# CONTEXT.md — library/workflows/06-build-a-proof/

The procedure for rendering a document to PDF, or to a Word copy, and **reading** what was
rendered. A proof is a working copy for checking how the document looks and whether it builds;
it is ungated, so any document at any status can be proofed. The issue copy of a `final` document
is made at the end of `library/workflows/05-review-a-document/`, not here.

## Directory Tree

```text
library/workflows/06-build-a-proof/
├── CHECKLIST.md            ← verification checklist before marking complete
├── CLAUDE.md               ← operating rules for this workflow
├── CONTEXT.md              ← this file (when to use, what it produces, the failure it prevents)
└── STEPS.md                ← ordered steps to execute
```

## When to use this

- The author asks to see a document as a PDF, or needs a Word copy for a reviewer who does not use
  LaTeX.
- A change to a document (a promotion, a correction) needs proving before anything else happens.
- An invoice or other form filled from its template is ready to be looked at.

Reach for a **different** procedure when: the document is ready to be made `final` and issued
(`library/workflows/05-review-a-document/`); the build fails because of the house preamble or the
`Makefile` themselves (report it to the author: both are template-owned); or the request is to
change the document's words (`library/workflows/02-adapt-a-draft/`).

## What it produces, and where

- **A PDF proof** in `build/`, rendered from the `.tex` with XeLaTeX, twice, so references resolve.
- **A Word copy** in `build/`, when asked for: from Markdown copy through Pandoc, or from a `.tex`
  only through a lossless converter the author has chosen; checked against the PDF for lost text.
- **A proof report:** what was built, from which file, what was checked, and every defect found,
  with its location.

## The failure this procedure exists to prevent

**A build that 'worked' but was never read.** A PDF can render with a `??` where a clause number
should be, a table running off the page, a drafting note still showing, or a disclaimer missing.
`make` reporting success says nothing about any of them. A proof that has not been read has not
been proofed.

## Cross-references

- `library/docs/reference/latex-deliverables.md` — the skeleton, the macros and the build targets.
- `.claude/rules/syntek-author/04-build-pipeline.md` — every `make` target and what it runs.
- `library/workflows/05-review-a-document/` — where the issue copy is made.
