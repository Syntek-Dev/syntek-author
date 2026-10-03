# CONTEXT.md — world/src/history/

The world's long past: the eras in order, and one file per major event that moved, mixed or
divided its peoples (a migration, a conquest, first contact, a split, a founding). World history
explains why things are as they are when the story opens: why two peoples share words, why one
language became two, why a script looks borrowed. The story's own days are not here; they live
in `planning/src/timeline.md`, in story-time order.

## Directory Tree

```text
world/src/history/
├── CONTEXT.md          ← this file
├── CLAUDE.md           ← operating rules and the event skeleton
├── eras.md             ← seed: the eras, oldest first, one row each; every event hangs on one
└── <slug>.md           ← one major event, named for what the story calls it, in kebab-case
```

## What's here

- `world/src/history/eras.md` — **the spine of the history:** one row per era, with its span,
  what defines it, the peoples in it, the language stage they spoke, and the events in it. It
  ships empty and is never replaced by `copier update`.
- `<slug>.md` — one event. Frontmatter `name`, `kind`, `era`, `when`, `peoples`, `places` and
  `first_appears`, then seven sections in this order:
  - `## What happened` — the event as it really happened, in a few sentences.
  - `## Causes` — what drove it: hunger, ambition, a failed harvest, a new road.
  - `## Who it changed, and how` — each people involved, and what they lost or gained.
  - `## Linguistic consequences` — **loanwords (which way they travelled and in what domains),
    splits (which speech divided, and which sound changes date from after it) and script
    borrowing (who took whose writing, and how badly it fitted).** Language work reads this
    section to place each word and each change in time.
  - `## What each people remembers` — each people's version, marked as belief, not fact.
  - `## Role in the story` — the scenes or the backstory the event serves.
  - `## Continuity facts` — fixed details, each with its section once promoted prose uses it.

## Cross-references

- `world/workflows/11-chart-the-world-history/` — the procedure that writes the eras and events.
- `world/docs/reference/world-history.md` — eras, events, and the marks events leave in language.
- `world/src/peoples/` — the peoples each event moved or mixed.
- `planning/src/timeline.md` — the story's own days, and the calendar the eras' reckoning meets.
- `planning/src/maps/` — the decision map, when the history is too large for one sitting.
