@./CONTEXT.md

# CLAUDE.md — planning/workflows/08-update-the-register/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `planning/CONTEXT.md` →
`planning/CLAUDE.md` → `planning/workflows/CONTEXT.md` → `planning/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Keep one true register row per document, and carry each change into the schedule and the
precedence table.

## How to work here

- **Routing:** no skill; `promote-section` may call this procedure's rules when it creates a new
  version. Guide `planning/docs/reference/the-document-register.md`; `clause-consistency` checks
  the precedence rows against the instruments.
- **Model:** **Opus** for deciding what changed and what follows from it; the mechanical tier
  for writing the agreed row (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.
- **Definition of done:** the row is correct in every column, the schedule and precedence table
  agree with it, and the author has confirmed the change.

## Guardrails

- **IDs are permanent.** The next ID is one more than the highest ever issued; never reuse a
  retired number.
- **Never delete a row.** Retire it with a status and a note naming what replaced it.
- **No unknown values.** A column the author cannot fill is `—` where the guide allows it, and
  otherwise stops the change.
- **Precedence is mirrored, never decided.** An order the instruments do not state is an
  `AUTHOR TO CONFIRM` flag in the instrument.
- **Never overwrite** a row without confirming with the author.

## Output & naming

- **Writes:** rows in `planning/src/document-register.md`, `planning/src/review-schedule.md` and
  `planning/src/precedence.md`; the unit brief's `number`.
- **Does not touch:** any document in the library.
