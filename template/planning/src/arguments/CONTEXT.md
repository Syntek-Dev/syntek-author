# CONTEXT.md — planning/src/arguments/

One argument map per chapter, beside the chapter's brief in `planning/src/units/`. A map lays
out the chapter's thesis, the claims that carry it with their categories, what supports each
claim, the contested readings it leans on, the objections it faces and the concessions it makes.
It is the structure the prose will argue, checked before a word is drafted.

## Directory Tree

```text
planning/src/arguments/
├── CONTEXT.md          ← this file
├── CLAUDE.md           ← operating rules
└── <unit>.md           ← one map per chapter, named exactly as the chapter's brief
```

## What's here

- `<unit>.md` — an argument map: frontmatter `unit` and `last_updated`, then `## Thesis` ·
  `## Claims` · `## Contested readings` · `## Objections` · `## Concessions` · `## Open moves`.
  **The shape is fixed by `planning/docs/reference/argument-maps.md`.** Claim IDs (`C1` …),
  objection IDs (`O1` …) and concession IDs (`K1` …) match those in the brief's
  `## Claims and categories`.
- A generated project may hold one worked example map, written with placeholder claims and
  `VERIFY` flags; delete it once you no longer need it, and it will not come back.

## Cross-references

- `planning/docs/reference/argument-maps.md` — the six categories and the map's shape.
- `planning/workflows/02-map-the-argument/` — the procedure that writes a map.
- `research/src/contested-readings/` — where each contested reading is mapped in full.
- `standards/method/THEOLOGY.md` — the method the map is checked against.
