# CONTEXT.md — world/src/creatures/

The bestiary: one entry per creature the story uses, recording its ecology and body, how it
behaves, what people believe about it, and above all the rules and limits the plot will rely
on. A creature's part in a quest is planned in `planning/src/quests/`; its names are
registered in `world/src/names-register.md`.

## Directory Tree

```text
world/src/creatures/
├── CONTEXT.md          ← this file
├── CLAUDE.md           ← operating rules and the entry skeleton
└── <slug>.md           ← one creature, named for its registered name in kebab-case
```

## What's here

Each `<slug>.md` carries frontmatter `name`, `ipa`, `kind` (beast, bird, swimmer, swarm,
spirit, construct, other) and `first_appears`, then eight sections in this order:

- `## Ecology` — habitat, diet, predators, life cycle, numbers.
- `## Anatomy` — body plan, size, senses, movement.
- `## Behaviour` — hungry, threatened, mating, wounded, alone.
- `## Lore and names` — each culture's beliefs and names, marked as belief, not fact.
- `## Role in the story` — the scenes it serves.
- `## Rules and limits` — **what it can never do, and what its abilities cost.**
- `## Weaknesses` — what stops it, and where the book plants that.
- `## Continuity facts` — fixed details, each with its section once promoted prose uses it.

## Cross-references

- `world/workflows/04-create-a-creature/` — the procedure that writes these entries.
- `world/docs/reference/creatures.md` — why ecology and limits come first.
- `planning/src/quests/` — quests a creature takes part in.
- `planning/src/causality.md` — where each weakness is set up before it pays off.
