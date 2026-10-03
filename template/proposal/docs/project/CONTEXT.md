# CONTEXT.md — proposal/docs/project/

The author's own proposal guides, empty at generation. A guide here records how this project makes
its pitch where that differs from, or goes further than, the template's practice in
`proposal/docs/reference/`: a publisher's own proposal format, say, or an agent list built a
particular way. The template seeds only this pair, once, and never writes here again: the pair is
yours to edit, and `copier update` never touches anything in this folder.

## Directory Tree

```text
proposal/docs/project/
├── CONTEXT.md            ← this file
├── CLAUDE.md             ← operating rules for project guides
└── <guide>.md            ← your guides; a same-named file overrides proposal/docs/reference/
```

## What's here

- **Override guides** — a file with the same name as a reference guide replaces it for this
  project. Keep the reference guide's shape; its `## How we apply it here` section is where the
  project's practice goes.
- **New guides** — a guide for a recurring judgement call the template has no guide for.

## Cross-references

- `proposal/docs/reference/CONTEXT.md` — the template's guides, which these override or extend.
- `.claude/rules/syntek-author/01-layout-and-routing.md` — the reference/project ownership split.
