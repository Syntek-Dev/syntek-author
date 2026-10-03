@./CONTEXT.md

# CLAUDE.md — manuscript/src/01-example-chapter/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `manuscript/src/CONTEXT.md` →
`manuscript/src/CLAUDE.md` → this folder's `CONTEXT.md` (what the example shows, imported above)
→ this file.

## Purpose (one line)

Show a chapter mid-way through the authoring loop, so the author can see the files before writing
a real chapter, then get out of the way.

## How to work here

- **Routing:** the example is for reading. To practise the loop on it, use the normal procedures
  in `manuscript/workflows/`; to start a real chapter, plan it with
  `planning/workflows/01-plan-a-unit/` and draft with `manuscript/workflows/01-draft-a-section/`.
- **Model:** **Opus** for any prose; the mechanical tier for deleting the example
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps to practise on it:**
  1. Read the two ledger entries: `opening`'s records a section the author drafted and promoted;
     `the-turn`'s AI original is the draft's body, as `draft-section` would have written it.
  2. Give notes on `manuscript/src/01-example-chapter/drafts/02-the-turn.md` and run
     `manuscript/workflows/02-adapt-a-draft/`.
  3. Resolve every flag, then promote it with `manuscript/workflows/04-promote-a-section/`. The
     register `standards/style/ledger/provenance.md` ships empty, so add the `opening` row as well
     as the `the-turn` row, then run `python3 tooling/provenance.py check`.
  4. With both sections promoted, open the review with `manuscript/workflows/05-review-a-chapter/`:
     V2 holds, because every planned section is promoted with a complete ledger entry.
- **Concrete steps to remove it:** with the author's agreement, delete this folder,
  `planning/src/units/01-example-chapter.md`<: if DOC_TYPE == 'theology' :>,
  `planning/src/arguments/01-example-chapter.md`<: endif :>,
  `standards/style/ledger/01-example-chapter--opening.md` and
  `standards/style/ledger/01-example-chapter--the-turn.md`, together with any other ledger entries
  and `standards/style/ledger/provenance.md` rows created while practising.
- **Definition of done:** the author has seen what a chapter, a draft and a marker look like, and
  the example is gone before the real first chapter takes its number.

## Guardrails

- **Not part of the book.** Never cite the example's prose, count it in a word total, or let it
  reach a proof sent to anyone. It builds like any chapter while it exists.
- **Never let it shape the real first chapter.** Its title, characters and wording are invented
  placeholders, not suggestions.
- **Deleting it is the author's call**, and once deleted it stays deleted.

## Output & naming

- **Hand-written:** nothing new; this folder only demonstrates the naming in
  `manuscript/src/CLAUDE.md`.
- **Generated (never hand-edit):** any proof of it under `build/`.
