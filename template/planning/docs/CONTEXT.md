# CONTEXT.md — planning/docs/

The planning layer's guides: short explanations of how planning is done in this project, each
answering one question. Guides explain and route; the rules they serve live in `standards/`, and
the procedures that apply them live in `planning/workflows/`. No plan is written here.

## Directory Tree

```text
planning/docs/
├── CONTEXT.md        ← this file
├── CLAUDE.md         ← operating rules
├── reference/        ← template-owned guides, updated by `copier update`
└── project/          ← your own guides; a same-named file overrides reference/
```

## What's here

- `reference/` — **the guides that ship with the template.** Never edit them in place:
  `copier update` merges template changes into them, and a local edit turns every update into a
  merge conflict. Extend or override them in `project/` instead.
- `project/` — **guides written for this project.** A file here with the same name as one in
  `reference/` overrides it; a new name adds a guide. The template ships only this folder's pair.

## Cross-references

- `planning/docs/reference/CONTEXT.md` — the guide index for this doc type.
- `.claude/rules/syntek-author/01-layout-and-routing.md` — the ownership classes behind the
  split.
