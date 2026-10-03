@./CONTEXT.md

# CLAUDE.md — typeset/workflows/02-typeset-a-chapter/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `typeset/CONTEXT.md` →
`typeset/CLAUDE.md` → `typeset/workflows/CONTEXT.md` → `typeset/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (what it produces, imported above) → this file → `STEPS.md` (with
`CHECKLIST.md` open).

## Purpose (one line)

Set one chapter for print from its Markdown, styled with house macros only, and prove its words
unchanged before printing it.

## How to work here

**Follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.** The model tags in the checklist
are authoritative.

- **Routing:** skill `typeset`, whose mode file adds this kind of book's styling; it is this
  procedure in skill form. Guides: the pipeline, the house class and the fidelity check, all in
  `typeset/docs/reference/`.
- **Model:** the **mechanical tier** for `make tex`, the copy, `make tex-check` and `make print`;
  **Opus** for styling, reading the proof and fitting pages
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** confirm the chapter → `make tex` → copy the base → style → check → add to
  `book.tex` → print → read → fit pages if needed → report.
- **Definition of done:** the styled chapter passes `make tex-check`, `book.tex` includes it in
  plan order, `make print` succeeds, and the proof has been read.

## Guardrails

- **Never type a word into the styled file.** Insert macros around words already there. If a
  word is wrong, report it; it is fixed in the Markdown and re-typeset.
- **House macros only**, as listed in `typeset/docs/reference/the-house-class.md`. The check
  warns about anything else; take it out.
- **Never add or remove a scene break, an epigraph or a section in LaTeX.** They are the author's
  marks, made in the Markdown; the check cannot see them, so this rule is the only guard.
- **Never edit the base**, and never overwrite an existing styled file: if one exists, this is the
  wrong procedure (03 carries styling forward).
- **Fit pages last.** Page-fitting commands go in after the proof shows the need, one at a time.

## Output & naming

- **Produces:** `typeset/src/units/.base/NN-kebab-title.tex` (generated) and
  `typeset/src/units/NN-kebab-title.tex` (styled), named as the chapter's folder; one line in
  `typeset/src/book.tex`; the proof in `build/typeset/`.
- **Touches nothing else.** The Markdown, the chapter's brief and the ledger are not edited here.
