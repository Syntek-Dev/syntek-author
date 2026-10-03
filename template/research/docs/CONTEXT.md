# CONTEXT.md — research/docs/

The research layer's guides: short, practical notes on the judgement calls that sit between the
rules in `standards/` and the ordered steps in `research/workflows/`. Is this source usable? What
does this study not show? May we publish this? Each guide defers to a standard rather than
restating it. No evidence, notes or maps live here; they live in `research/src/`.

## Directory Tree

```text
research/docs/
├── CONTEXT.md            ← this file
├── CLAUDE.md             ← operating rules for the guides
├── reference/            ← template-owned guides, replaced by `copier update`
└── project/              ← your own guides; a same-named file here overrides reference/
```

## What's here

- `reference/` — the template's guides. **Template-owned:** never edit them in place, because
  `copier update` replaces this folder. `reference/CONTEXT.md` lists the guides this project has.
- `project/` — the author's guides, empty at generation. **A same-named guide here overrides the
  reference guide**; its `## How we apply it here` section is where a project extends the
  template's practice.

## Cross-references

- `research/docs/reference/CONTEXT.md` — the reference guides in this project, one line each.
- `.claude/rules/syntek-author/01-layout-and-routing.md` — the reference/project ownership split.
- `research/workflows/CONTEXT.md` — the procedures that cite these guides step by step.
