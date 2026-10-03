# CONTEXT.md — planning/src/maps/

Decision maps: `MAP-<TOPIC>.md` files charting a body of work too big to settle in one grilling
session. A map is a low-resolution index of open decisions in dependency order, not a store of
answers: the detail lives in the brief, research note, plan or `.claude/MEMORY.md` decision
each entry links to. Written and resolved by the `wayfinder` skill.

This file is seeded once and is yours from then on: `wayfinder` appends a row to the index below
for each map it charts, and `copier update` never changes it (delete it and the next update
writes back an empty index).

## Directory Tree

```text
planning/src/maps/
├── CONTEXT.md          ← this file (seeded once, then yours), with the map index below
├── CLAUDE.md           ← operating rules
└── MAP-<TOPIC>.md      ← one map per body of work
```

## What's here

The index, one row per map. `wayfinder` appends a row when it charts a map and updates only that
row's `Frontier open?` as its nodes are resolved; a closed map keeps its row as the record.

| Map | Destination | Frontier open? | Charted |
|---|---|---|---|

*No maps yet.*

## Cross-references

- `planning/docs/reference/decision-maps.md` — when a map earns its place, and where settled
  decisions go.
- `.claude/skills/wayfinder/SKILL.md` — the procedure and the map format.
- `.claude/MEMORY.md` — `Open questions` that a map must reckon with, and `Decisions` that
  settled nodes graduate to.
