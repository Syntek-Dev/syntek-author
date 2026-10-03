@./CONTEXT.md

# CLAUDE.md — planning/workflows/02-map-the-argument/

Read order: `standards/method/THEOLOGY.md` → `.claude/CLAUDE.md` → `.claude/MEMORY.md` →
`planning/CONTEXT.md` → `planning/CLAUDE.md` → `planning/workflows/CONTEXT.md` →
`planning/workflows/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file →
`STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Map a chapter's argument and audit it before drafting, so every claim has a category and a
support, every objection is fairly stated, and every concession comes before its answer.

## How to work here

- **Routing:** skills `category-check` (labels) and `argument-audit` (support and open moves);
  guide `planning/docs/reference/argument-maps.md`; standard `standards/method/THEOLOGY.md`.
- **Model:** **Opus** throughout; placing a claim in its category and judging its support is
  the least mechanical work in the project (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.
- **Definition of done:** every claim carries one category and named support, or sits under
  open moves; every objection passes the recognition test or is flagged; every concession is
  placed ahead of its answer; the author has agreed the claims.

## Guardrails

- **Never fabricate.** No scripture reference, quotation, original-language definition or
  historical attribution is written from memory. Until checked, it carries `VERIFY`.
- **Never collapse a category silently.** If a claim fits two categories, it is two claims.
- **Report, never rewrite the argument.** The audit finds gaps; the author decides how the
  argument changes. Anything marked as the author's own conclusion is theirs alone.
- **The left-standing objection is the author's.** Mark a candidate; never designate one.
- **Never overwrite** an existing map without confirming with the author.

## Output & naming

- **Produces:** `planning/src/arguments/<unit>.md`.
- **Also writes:** the brief's `## Claims and categories` and `sources:`.
- **Does not touch:** the prose in `manuscript/src/`, the contested-reading entries in
  `research/src/contested-readings/` (it links to them), or the standards.
