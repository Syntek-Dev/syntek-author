# CONTEXT.md — planning/workflows/05-design-a-quest/

The procedure for planning one quest from its trigger to its ending: the goal, the stakes, the
obstacles and reversals, what it costs and what it gives, tied to the arcs it moves, the
causality beats it rests on and the rules of the world it relies on. It writes
`planning/src/quests/<slug>.md` before the quest's first beat is drafted, so no quest is left
dangling and no reward arrives without a price.

## Directory Tree

```text
planning/workflows/05-design-a-quest/
├── CONTEXT.md          ← this file (when to use, what it produces)
├── CLAUDE.md           ← operating rules for this workflow
├── STEPS.md            ← ordered steps to execute
└── CHECKLIST.md        ← verification checklist before marking complete
```

## When to use this

- When a quest is first conceived, main or side, before the chapter that triggers it is
  drafted.
- When a quest's ending changes, or a quest is merged, split or cut.
- When the last chapters are planned: every quest still `open` is checked here.

Reach for a **different** procedure when: the question is a single beat's cause
(`03-chart-the-causality`); a character's change (`04-chart-a-character-arc`); or a creature or
culture the quest needs does not exist yet (`world/workflows/04-create-a-creature/`,
`world/workflows/05-create-a-culture/`).

## What it produces, and where

- `planning/src/quests/<slug>.md` — the quest, in the guide's shape.
- New causality beats for the trigger and reversals, charted through `03-chart-the-causality`.
- Updated arcs in `planning/src/arcs/`, where the quest moves a character.

## The failure this procedure exists to prevent

The dangling quest: a search announced with fanfare in chapter 4 that the book forgets, or
resolves offstage in a sentence. Close behind it is the free reward, won without loss, which
teaches the reader that nothing in this world costs anything. Both are cheap to catch on a
plan and expensive to repair in a finished draft.

## Cross-references

- `planning/docs/reference/quest-design.md` — the parts of a quest and the file's shape.
- `world/src/` — the creatures, cultures and places the quest must obey.
- `standards/method/FICTION.md` — the story engine.
