# CONTEXT.md — planning/src/arcs/

One arc per character who changes: the shape of that change across the story, mapped to the
chapters and sections where each shift happens. Who the character is — want, need, wound, voice
— lives in their entry in `world/src/characters/`; this folder records how they move.

## Directory Tree

```text
planning/src/arcs/
├── CONTEXT.md          ← this file
├── CLAUDE.md           ← operating rules
└── <slug>.md           ← one arc per character, named for the character's entry
```

## What's here

- `<slug>.md` — an arc: frontmatter `character`, `arc_type` (`positive` · `negative` · `flat`)
  and `world_entry`, then `## Shape` · `## The truth` · `## Beats` · `## The turn` · `## Open`.
  **The shape is fixed by `planning/docs/reference/character-arcs.md`.** Each beat names the
  causality beat in `planning/src/causality.md` that forces it.

## Cross-references

- `planning/docs/reference/character-arcs.md` — arc types and the arc's shape.
- `planning/workflows/04-chart-a-character-arc/` — the procedure that writes an arc.
- `world/src/characters/` — the character entries the arcs cite.
- `planning/src/causality.md` — the beats each arc rests on.
