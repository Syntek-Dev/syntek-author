@./CONTEXT.md

# CLAUDE.md — planning/workflows/05-design-a-quest/

Read order: `standards/method/FICTION.md` → `.claude/CLAUDE.md` → `.claude/MEMORY.md` →
`planning/CONTEXT.md` → `planning/CLAUDE.md` → `planning/workflows/CONTEXT.md` →
`planning/workflows/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file →
`STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Plan one quest to an ending, with a cost, a reward and ties to the arcs, beats and world it
depends on.

## How to work here

- **Routing:** skill `design-quest`, with `causality` for the trigger and reversals and
  `chart-character-arc` for the arcs it moves; guide `planning/docs/reference/quest-design.md`.
- **Model:** **Opus** throughout (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.
- **Definition of done:** every part of the quest is filled or flagged, every tie points at a
  real arc, beat or world entry, and the author has agreed how it ends or why it stays open.

## Guardrails

- **The world's rules bind the quest.** Check every creature, culture, place and rule it relies
  on against its entry in `world/src/`; a rule bent for convenience is reported, not used.
- **No reward without a cost.** An empty `## Cost` is flagged for the author.
- **No silent loose ends.** A quest left open says why, and the author confirms it.
- **The author decides the ending.** Offer options; never settle it.
- **Never overwrite** a quest without confirming with the author.

## Output & naming

- **Produces:** `planning/src/quests/<slug>.md`, kebab-case, named for the quest.
- **Does not touch:** the prose in `manuscript/src/`, or the world entries (it reports
  conflicts with them).
