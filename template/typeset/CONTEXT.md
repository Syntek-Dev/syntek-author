# CONTEXT.md — typeset/

The printed book. The author writes in Markdown in `manuscript/src/`; this layer turns the
promoted chapters into a print-ready PDF through LaTeX and the house class,
`tooling/latex/housebook.cls`. Three rules hold it together: **the words come from Pandoc, never
retyped**; styling uses the house class's macros and nothing else; and `make tex-check` proves
that every word of the Markdown is still there, in order, before anything is printed. What does
**not** live here: the prose and its plan (`manuscript/`, `planning/`), the quick proof
(`make pdf` renders the Markdown straight to `build/`), and anything generated (`build/`).

## Directory Tree

```text
typeset/
├── CONTEXT.md            ← this file
├── CLAUDE.md             ← operating rules for the layer
├── docs/                 ← guides: reference/ (template-owned) and project/ (the author's)
├── src/                  ← page-design.md, book.tex, front and back matter, the styled chapters
└── workflows/            ← design the page, typeset a chapter, re-typeset after edits, the book
```

## What's here

- `typeset/docs/` — the pipeline, the house class, the fidelity check and the semantic Markdown
  the author may use. `typeset/docs/reference/` is template-owned; `typeset/docs/project/` is the
  author's, and **a same-named guide there overrides the reference one**.
- `typeset/src/` — the book as it will be printed: `typeset/src/page-design.md` (the author's
  page-design choices), `typeset/src/book.tex` (the master file), the front and back matter, and
  `typeset/src/units/`, which holds one styled `.tex` per chapter beside its Pandoc base in
  `typeset/src/units/.base/`.
- `typeset/workflows/` — four procedures: design the page, typeset a chapter, re-typeset a
  chapter after its Markdown changes, typeset the whole book. `typeset/workflows/local/` holds the
  author's own; **a local procedure with the same folder name wins**.

## Key concepts

- **The base and the styled file.** `make tex` writes Pandoc's LaTeX for a chapter to
  `typeset/src/units/.base/NN-kebab-title.tex`. That base is never edited. The styled file
  `typeset/src/units/NN-kebab-title.tex` starts as a copy of it and gains house macros (a drop
  capital, small capitals, a page-fitting nudge); its words never change by hand.
- **The fidelity check.** `make tex-check` strips the styled file back to words and compares them
  with the Markdown's. One word inserted, deleted or changed fails the check.
- **The three-way carry-forward.** When a chapter's Markdown changes, `make tex` writes a new base,
  and `git merge-file` carries the styling from the old base to the new one. A clash is resolved
  by taking the new words and re-applying the styling, then checked again.
- **Page design is the author's.** Trim, typefaces, chapter openers, scene-break marks, footnotes
  and drop capitals are chosen by the author and recorded in `typeset/src/page-design.md`; the AI
  recommends, with reasons, and never decides.
- **Two proofs.** `make pdf` is the quick proof of the Markdown at any moment. `make print` is the
  typeset book from `typeset/src/book.tex`, the one a printer receives.

## Cross-references

- `.claude/rules/syntek-author/03-authorship.md` — who decides what, and never fabricating.
- `.claude/rules/syntek-author/04-build-pipeline.md` — every `make` target.
- `typeset/docs/reference/the-typesetting-pipeline.md` — the pipeline on one page.
- `standards/verification/verification.md` — Section 5: proofs are ungated; release is not.
- `manuscript/src/` — the chapters this layer prints.
