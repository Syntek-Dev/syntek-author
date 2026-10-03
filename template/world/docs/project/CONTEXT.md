# CONTEXT.md — world/docs/project/

The author's own guides for this book's world: the naming customs of its peoples, the
conventions of its maps, a house style for invented words, anything that recurs and that the
template's reference guides do not cover. The template ships only this pair; everything else
here is yours, and `copier update` never touches it.

## Directory Tree

```text
world/docs/project/
├── CONTEXT.md          ← this file
├── CLAUDE.md           ← operating rules
└── <question>.md       ← one guide per recurring question, kebab-case
```

## What's here

- Nothing yet, until you add a guide. **A guide here with the same filename as one in
  `world/docs/reference/` replaces it** for this project; a guide with a new name adds to the
  set.
- Typical project guides: the naming customs of one people, a calendar and its holidays, a
  currency and its coins, the conventions of the book's maps.

## Cross-references

- `world/docs/reference/` — the template's guides, which this folder can override.
- `.claude/rules/syntek-author/01-layout-and-routing.md` — the override rule for every layer.
- `world/src/` — where the facts the guides talk about are recorded.
