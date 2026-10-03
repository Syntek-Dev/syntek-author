@./CONTEXT.md

# CLAUDE.md — typeset/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (the layer's
shape and key concepts, imported above) → this file → the `CONTEXT.md` and `CLAUDE.md` of the
sublayer you are about to work in.

## Purpose (one line)

Print the author's chapters exactly as written, set the way the author chose, with proof that not
one word was changed on the way.

## How to work here

- **Routing:** start every task from a procedure in `typeset/workflows/`; the `run-workflow` skill
  resolves 'typeset chapter 3' or 'make the print PDF' to one, looking in
  `typeset/workflows/local/` first. The `typeset` skill is those procedures in skill form, and its
  mode file adds this project's kind of book.
- **Model:** **Opus** for page-design recommendations, styling and resolving a merge clash; the
  mechanical tier for running `make tex`, `make tex-check` and `make print`
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps for a chapter:**
  1. Confirm the chapter's sections are promoted in `manuscript/src/NN-kebab-title/`; typeset the
     Markdown as it stands, never a draft.
  2. `make tex SCOPE=manuscript/src/NN-kebab-title` writes the base.
  3. The first time, copy the base to `typeset/src/units/NN-kebab-title.tex`; after a Markdown
     change, carry the styling forward with `git merge-file`
     (`typeset/workflows/03-retypeset-after-edits/`).
  4. Style with house macros only, then `make tex-check UNIT=NN-kebab-title`.
  5. `make print`, and read the proof.
- **Definition of done:** the styled chapter passes `make tex-check`, sits in `book.tex` in plan
  order, prints without an XeLaTeX error, and the proof has been read with every warning
  accounted for.

## Guardrails

- **Never retype a word.** Every word in a styled file arrived through Pandoc. A change to the
  words is made in the Markdown, through the section procedures, and re-typeset.
- **House macros only.** Styling uses what `tooling/latex/housebook.cls` defines and the few
  page-fitting commands `typeset/docs/reference/the-house-class.md` lists. Anything else is
  reported by the check and taken out.
- **Never edit a base.** `typeset/src/units/.base/` is written by `make tex` alone; it is the
  ancestor every carry-forward depends on.
- **Page design is the author's decision.** Recommend, give the reason, and record only what the
  author chose, in `typeset/src/page-design.md` and `typeset/src/book.tex` together.
- **Never fix the Markdown to make the check pass.** A failing check means the styled file is
  wrong.
- **Never overwrite a styled file** without the author's confirmation; it holds styling work.

## Output & naming

- **Hand-written (with the author):** `typeset/src/page-design.md`, `typeset/src/book.tex`, the
  front and back matter, and the styling in `typeset/src/units/NN-kebab-title.tex`.
- **Generated (never hand-edit):** `typeset/src/units/.base/NN-kebab-title.tex` (by `make tex`,
  committed beside its styled file) and everything under `build/`, including the print PDF.
