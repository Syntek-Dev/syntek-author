# CONTEXT.md — proposal/src/sample/

The sample: an **index** pointing at the manuscript units a reader will receive, with the reason
each earns its place. It holds no manuscript prose, and that constraint is the whole design. A
copied chapter drifts: the manuscript is edited, the copy is not, and eventually a reader receives a
version nobody meant to send. The index ships as an empty seed.

## Directory Tree

```text
proposal/src/sample/
├── CONTEXT.md            ← this file
├── CLAUDE.md             ← operating rules
└── sample-index.md       ← seed: one row per sample unit, pointing into manuscript/src/
```

## What's here

- `sample-index.md` — one row per unit in the sample: its order, its canonical path in
  `manuscript/src/`, the date its last section was promoted, and the reason it is in the sample
  (what it shows the reader: the voice, the method, the story's pull).
- **The selection is the author's call,** recorded in `.claude/MEMORY.md` (Decisions). The package
  anatomy guide says what kind of sample this project's readers expect.
- **Only units whose sections are all promoted:** a file still in a unit's `drafts/` has not had
  the author's word, and every build excludes `drafts/` by design.

## Cross-references

- `manuscript/src/` — the single source of truth for every unit's prose.
- `proposal/docs/reference/CONTEXT.md` — the package anatomy guide this project ships.
- `proposal/workflows/01-assemble-the-proposal/` — where the sample is chosen and built.
- `.claude/rules/syntek-author/04-build-pipeline.md` — how a unit is built to `.docx` or `.pdf`.
