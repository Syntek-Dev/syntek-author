@./CONTEXT.md

# CLAUDE.md — typeset/workflows/04-typeset-the-book/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `typeset/CONTEXT.md` →
`typeset/CLAUDE.md` → `typeset/workflows/CONTEXT.md` → `typeset/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (what it produces, imported above) → this file → `STEPS.md` (with
`CHECKLIST.md` open).

## Purpose (one line)

Assemble, prove and print the whole book, and read it before anyone else does.

## How to work here

**Follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.** The model tags in the checklist
are authoritative.

- **Routing:** skill `typeset` for every stage, dispatching procedures 02 and 03 for chapters that
  need them; `build` for the quick proofs and the references export. The `typeset` skill is this
  procedure in skill form.
- **Model:** the **mechanical tier** for the `make` runs; **Opus** for every chapter's styling,
  every judgement about readiness and the full read of the proof
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** take stock → bring every chapter up to date → front and back matter →
  `book.tex` in plan order → check every chapter → print → read the whole book → fit pages →
  report.
- **Definition of done:** every chapter in the outline is in `book.tex` and passes
  `make tex-check`; the PDF prints without an error; the whole proof has been read; every warning
  and every open flag is reported.

## Guardrails

- **A release is the author's decision.** Never send the PDF out, or call it final, on your own
  judgement. Release needs every chapter `final` (`standards/verification/verification.md`
  Section 5) and the author's explicit word.
- **No unchecked chapter in a release print.** Run `make tex-check` over the whole book
  immediately before the print you hand over.
- **Front and back matter are the author's words.** Ask for them; never compose a dedication, an
  acknowledgement or a biography, and never invent an ISBN or a permission.
- **Read every page.** A full print with one unread chapter is a proof of the other chapters.

## Output & naming

- **Produces:** updated bases and styled chapters in `typeset/src/units/`, `typeset/src/book.tex`,
  front and back matter files, and `build/typeset/book.pdf`.
- **Never produces:** a PDF anywhere but `build/`. Where the issued copy is kept is the author's
  decision.
