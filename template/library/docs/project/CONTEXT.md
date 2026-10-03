# CONTEXT.md — library/docs/project/

The author's own guides for this library: how this business handles its recurring documents, its
house positions, and the lessons that outgrew a single document's internal note. The template
ships only this pair; everything else here is written for this project and is never touched by
`copier update`. Rules belong in `standards/`, and plans belong in `planning/`; this folder holds
guidance only.

## Directory Tree

```text
library/docs/project/
├── CONTEXT.md              ← this file (add a tree line for each guide you write)
└── CLAUDE.md               ← operating rules
```

## What's here

- Nothing yet. Add a guide when the same explanation has been given twice: once is an answer,
  twice is a guide.
- **Overrides.** A guide here with the same filename as one in `library/docs/reference/` replaces
  it for this project. To extend a reference guide rather than replace it, write a same-named file
  whose `## How we apply it here` section adds to the reference guide and says so in its opening
  line.

## Cross-references

- `library/docs/reference/` — the template's guides, and the format to follow.
- `library/docs/CLAUDE.md` — the guide format, line by line.
- `standards/` — where a rule goes instead of a guide.
