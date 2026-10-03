# CONTEXT.md — typeset/docs/project/

The author's own typesetting guides for this book: practices that belong to this project alone,
and overrides of template guides. The template ships only this pair; everything else here is
written by, or with, the author, and `copier update` never touches it. A guide here with the same
filename as one in `typeset/docs/reference/` overrides that guide. Page-design choices do not live
here: they belong in `typeset/src/page-design.md`.

## Directory Tree

```text
typeset/docs/project/
├── CONTEXT.md            ← this file
├── CLAUDE.md             ← operating rules
└── kebab-question.md     ← one guide per recurring question (none yet)
```

## What's here

- Nothing yet beyond this pair. When a guide is added, list it here with the question it answers,
  and add it to the tree above.
- **Overrides** carry the same filename as the reference guide they replace. Mark each one in this
  list as an override, with the date and the reason.

## Cross-references

- `typeset/docs/reference/` — the template's guides; read them before writing a new one.
- `typeset/docs/CLAUDE.md` — the guide format and the steps for adding a guide.
- `.claude/MEMORY.md` — where a decision to override a reference guide is dated.
