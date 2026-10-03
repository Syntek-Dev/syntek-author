# CONTEXT.md — planning/src/units/

One brief per unit — the plan a chapter or a document is drafted from. A brief carries the
unit's scope, its job, its sections in plan order, the positions it commits to and what it draws
on, and its frontmatter records where the unit and each of its sections stand. The prose is not
here: it lives in the content layer, assembled from promoted sections.

## Directory Tree

```text
planning/src/units/
├── CONTEXT.md          ← this file
├── CLAUDE.md           ← operating rules
└── <unit>.md           ← one brief per unit, named for the unit in the content layer
```

## What's here

- `<unit>.md` — a brief. For a chapter the name matches its folder, `NN-kebab-title.md`; for a
  document, the document's slug. **The shape is fixed by `planning/docs/reference/unit-briefs.md`**:
  frontmatter `title`, `slug`, `number`, `version`, `status`, `audience_note`, `sources`,
  `verified`, `sections`, then `## Scope` · `## What this unit does` · `## Sections` · the
  settled-positions slot · `## Draws on` · `## Draft notes`.
- A generated project may hold one worked example brief; delete it, with every example file its
  removal note names, once you no longer need it, and none of them will come back.

## Cross-references

- `planning/docs/reference/unit-briefs.md` — the brief's shape and the two status ladders.
- `planning/workflows/01-plan-a-unit/` — the procedure that writes a brief.
- `planning/src/outline.md` — the order the briefs sit in.
- `standards/verification/verification.md` — the gates recorded in `verified`.
