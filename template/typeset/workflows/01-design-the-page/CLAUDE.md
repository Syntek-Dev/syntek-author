@./CONTEXT.md

# CLAUDE.md — typeset/workflows/01-design-the-page/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `typeset/CONTEXT.md` →
`typeset/CLAUDE.md` → `typeset/workflows/CONTEXT.md` → `typeset/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (what it produces, imported above) → this file → `STEPS.md` (with
`CHECKLIST.md` open).

## Purpose (one line)

Settle every page-design choice with the author, one at a time, and record it where the print
reads it.

## How to work here

**Follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.** The model tags in the checklist
are authoritative.

- **Routing:** skill `typeset`, whose mode file adds this kind of book's choices; it is this
  procedure in skill form. Guide: `typeset/docs/reference/the-house-class.md`.
- **Model:** **Opus** throughout: every step is a recommendation or a record of a decision. The
  mechanical tier only for `make print` (`.claude/rules/syntek-author/05-model-allocation.md`).
- **One question at a time.** Ask about one choice, with the options, a recommendation and its
  reason, then wait. Trim first, because the rest follows from it.
- **Concrete steps:** gather constraints → ask each choice in order → record each answer in both
  files → print a sample → read it with the author → date the costly decisions.
- **Definition of done:** every choice the author made is recorded in `page-design.md` and set in
  `book.tex`; open choices keep their flags; the author has seen a printed sample.

## Guardrails

- **Recommend; never decide.** 'I recommend demy, because …' is the AI's part. 'Demy' in
  `page-design.md` is the author's.
- **Change both files together.** A choice in `page-design.md` that `book.tex` does not reflect is
  a choice the print ignores.
- **Only installed, licensed typefaces.** Check a typeface is installed before recommending it, and
  say plainly that the author must confirm its licence covers print and embedding.
- **The printer's specification wins** over taste; record it as the reason.
- **Never rewrite a recorded choice** without the author's word; supersede it with a dated row.

## Output & naming

- **Produces:** edits to `typeset/src/page-design.md` and `typeset/src/book.tex`; a sample print
  in `build/typeset/`; dated lines in `.claude/MEMORY.md` Decisions.
- **Touches nothing else.** No chapter, base or styled file changes in this procedure.
