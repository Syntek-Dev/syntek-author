@./CONTEXT.md

# CLAUDE.md — typeset/src/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `typeset/CONTEXT.md` →
`typeset/CLAUDE.md` → this folder's `CONTEXT.md` (the files and their owners, imported above) →
this file → the `CONTEXT.md` and `CLAUDE.md` of the subfolder you are working in.

## Purpose (one line)

Hold everything the printed book needs around the author's words, so that `make print` makes the
whole book from one master file.

## How to work here

- **Routing:** never start work here. Start from the matching procedure in `typeset/workflows/`;
  the `typeset` skill is those procedures in skill form.
- **Model:** **Opus** for page design, styling and anything in `book.tex`; the mechanical tier for
  running `make tex`, `make tex-check` and `make print`
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps when a choice in `page-design.md` is settled:**
  1. Record it under its heading: the value, the reason and the date (DD/MM/YYYY), and remove its
     `AUTHOR TO CONFIRM` flag.
  2. Set the matching class option in `book.tex` in the same change.
  3. Add a row to the decisions table at the foot of `page-design.md`.
- **Concrete steps when a chapter is added to the book:** add one
  `\houseinput{units/NN-kebab-title}` line to `book.tex`, in the order of `planning/src/outline.md`.
- **Definition of done:** `page-design.md` and the class options in `book.tex` agree; `book.tex`
  lists the chapters in plan order; every styled chapter passes `make tex-check`.

## Guardrails

- **The words come from the Markdown.** Never type a sentence into a styled chapter, and never
  compose front or back matter: ask the author for the words.
- **Page design is the author's.** Never change a class option, or record a choice, that the
  author has not made.
- **Never edit `units/.base/`.** It is written by `make tex` and is the ancestor of every
  carry-forward.
- **Never overwrite a styled chapter** without the author's confirmation.
- **`page-design.md` and `book.tex` are the author's once seeded.** `copier update` will not
  bring a template change into them; a change here is a decision, so date it.

## Output & naming

- **Hand-written (with the author):** `page-design.md`, `book.tex`, `frontmatter/*.tex`,
  `backmatter/*.tex`, and the styling in `units/NN-kebab-title.tex`.
- **Generated (never hand-edit):** `units/.base/NN-kebab-title.tex`, written by `make tex`;
  `build/typeset/`, written by `make tex` and `make print`.
