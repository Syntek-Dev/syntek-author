@./CONTEXT.md

# CLAUDE.md — planning/workflows/01-plan-a-unit/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `planning/CONTEXT.md` →
`planning/CLAUDE.md` → `planning/workflows/CONTEXT.md` → `planning/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Plan one unit with the author and leave a brief that any later session can draft from.

## How to work here

- **Routing:** skill `grill-with-docs` (its mode file names the doc type's settled-positions
  slot and recording targets); guide `planning/docs/reference/unit-briefs.md`; gates
  `standards/verification/verification.md`.
- **Model:** **Opus** for every judgement: scope, positions, sections. The mechanical tier only
  for writing the agreed brief and ticking boxes
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.
- **Definition of done:** the author has agreed the brief, and a fresh session could draft its
  first section without asking what the unit is for.

## Guardrails

- **One unit per run.** Planning every unit at once produces a shelf of briefs and no prose;
  plan the next unit to be drafted.
- **The author decides scope and positions.** Ask; never infer a position from earlier units
  and write it down as settled. An undecided point is an `AUTHOR TO CONFIRM` flag.
- **Ask nothing the repository can answer.** Read MEMORY, the outline, the neighbouring briefs
  and the research notes first; settle empirical questions with `fact-check`, never by asking.
- **No prose in the brief.** A brief says what a section must do; sample sentences belong in a
  draft.
- **Never overwrite** an existing brief. Re-plan it in place with the author's confirmation,
  keeping every section slug that already has a ledger entry.

## Output & naming

- **Produces:** `planning/src/units/<unit>.md`, named for the unit in the content layer.
- **Also writes:** the outline row; MEMORY entries and terminology, through `grill-with-docs`.
- **Does not touch:** anything in the content layer (folders, drafts, unit files or their
  markers), or the standards.
