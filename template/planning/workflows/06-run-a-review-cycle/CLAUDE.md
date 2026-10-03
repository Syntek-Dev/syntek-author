@./CONTEXT.md

# CLAUDE.md — planning/workflows/06-run-a-review-cycle/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `planning/CONTEXT.md` →
`planning/CLAUDE.md` → `planning/workflows/CONTEXT.md` → `planning/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Review each due document against what governs it, and leave the register and schedule telling
the truth about it.

## How to work here

- **Routing:** skill `structure-review` for the review itself, with `fact-check` for any claim
  about the outside world; guides `planning/docs/reference/the-document-register.md` and
  `planning/docs/reference/reviews-are-advice.md`; changes go through the library's authoring
  workflows.
- **Model:** **Opus** for the review and every judgement; the mechanical tier for the register
  and schedule edits the author has agreed (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.
- **Definition of done:** each document in scope is either confirmed current or replaced by an
  agreed new version, and its register and schedule rows say so, dated today.

## Guardrails

- **Report `Overdue` rows first**, before any other work with the schedule.
- **Advice before action.** The review is written and the author decides before any document,
  register or schedule changes.
- **Never edit a circulated version in place.** A change is a new version, made through the
  library's authoring loop; only a typo fixed before circulation is amended in place.
- **Never change a figure, date, scope or commitment on your own judgement.** Flag it `VERIFY`
  or `AUTHOR TO CONFIRM`, and let the author decide.
- **Never overwrite** a register or schedule row without confirming with the author.

## Output & naming

- **Writes:** `REVIEW-<document-slug>-DD-MM-YYYY.md` in `planning/src/reviews/`; rows in the
  register and the schedule.
- **Does not touch:** the document itself; any change to it is made by the library workflows.
