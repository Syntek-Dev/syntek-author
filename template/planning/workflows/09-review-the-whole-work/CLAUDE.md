@./CONTEXT.md

# CLAUDE.md — planning/workflows/09-review-the-whole-work/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `planning/CONTEXT.md` →
`planning/CLAUDE.md` → `planning/workflows/CONTEXT.md` → `planning/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Give the author a durable, structural verdict on the whole work, kept separate from the
decisions they make about it.

## How to work here

- **Routing:** skill `structure-review` in its whole-work mode (forked context; the mode file
  names the lenses); `grill-with-docs` records the author's decisions; guide
  `planning/docs/reference/reviews-are-advice.md`.
- **Model:** **Opus** throughout; a structural verdict is judgement from first lens to last
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.
- **Definition of done:** the review file exists with the advice-only status line; the author
  has seen the open decisions; only the decisions they made are in MEMORY.

## Guardrails

- **Advice only.** This procedure edits no unit, brief, outline, map or standard. Every change
  the author accepts is made later by the procedure that owns the artefact.
- **Keep the dissent.** Where lenses disagree, the review says so; never average them into a
  verdict no lens gave.
- **Read what exists.** Judge the work on the page and the plans in `planning/src/`, not on
  what a unit was meant to say. A gap between plan and prose is a finding.
- **Flag, do not assert.** Anything brought in from outside the repository goes under claims to
  verify, flagged `VERIFY`.
- **Never edit an earlier review**; supersede it.

## Output & naming

- **Writes:** `REVIEW-<scope>-DD-MM-YYYY.md` in `planning/src/reviews/`; dated MEMORY entries
  through `grill-with-docs`.
- **Does not touch:** anything else.
