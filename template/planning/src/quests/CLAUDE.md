@./CONTEXT.md

# CLAUDE.md — planning/src/quests/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `planning/CONTEXT.md` →
`planning/CLAUDE.md` → `planning/src/CONTEXT.md` → `planning/src/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Plan every quest to an ending, so each one costs something, changes someone and closes.

## How to work here

- **Routing:** quests are written by `design-quest` through
  `planning/workflows/05-design-a-quest/`; `causality` checks the trigger and reversals;
  `chart-character-arc` updates the arcs a quest moves.
- **Model:** **Opus** throughout (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** read the arcs and causality beats the quest will touch and the world
  entries it relies on; write or update the quest; set its `status` honestly.
- **Definition of done:** every part of the quest is filled or flagged; every tie points at a
  real arc, beat or world entry; the ending is planned or its openness explained.

## Guardrails

- **The world's rules bind the quest.** A creature, culture or place that behaves differently
  for the quest's convenience is a continuity fault; report it.
- **No reward without a cost.** A quest whose `## Cost` is empty is flagged for the author.
- **No silent loose ends.** A quest still `open` at the last unit says why under `## Ending`, and
  the author confirms it.
- **Never overwrite** a quest without confirming with the author.

## Output & naming

- **Written by `design-quest` (with the author):** `<slug>.md`, kebab-case, named for the quest.
