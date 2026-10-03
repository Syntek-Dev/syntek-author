# CONTEXT.md — proposal/docs/

The proposal layer's guides: short, practical notes on the judgement calls in making the pitch.
What does each part of the package have to achieve? Is that a real differentiator? Who do we ask
first, and how? Each guide defers to a standard rather than restating it. No pitch copy, emails or
tracker rows live here; they live in `proposal/src/`.

## Directory Tree

```text
proposal/docs/
├── CONTEXT.md            ← this file
├── CLAUDE.md             ← operating rules for the guides
├── reference/            ← template-owned guides, replaced by `copier update`
└── project/              ← your own guides; a same-named file here overrides reference/
```

## What's here

- `reference/` — the template's guides. **Template-owned:** never edit them in place, because
  `copier update` replaces this folder. `reference/CONTEXT.md` lists the guides this project has,
  including the anatomy of its package.
- `project/` — the author's guides, empty at generation. **A same-named guide here overrides the
  reference guide.**

## Cross-references

- `proposal/docs/reference/CONTEXT.md` — the reference guides in this project, one line each.
- `.claude/rules/syntek-author/01-layout-and-routing.md` — the reference/project ownership split.
- `proposal/workflows/CONTEXT.md` — the procedures that cite these guides step by step.
