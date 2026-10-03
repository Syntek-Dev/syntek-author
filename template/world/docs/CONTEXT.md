# CONTEXT.md — world/docs/

The guides for the world layer: how to build a story bible that a novel can be checked against,
and how to name the things in it. Guides explain the everyday calls; they never outrank a
standard, and they hold no world facts (those live in `world/src/`).

## Directory Tree

```text
world/docs/
├── CONTEXT.md          ← this file
├── CLAUDE.md           ← operating rules
├── reference/          ← template-owned guides, updated by copier update; do not edit
└── project/            ← your own guides; a same-named file here overrides reference/
```

## What's here

- `world/docs/reference/` — the guides the template ships, one per question a world-building
  job raises. **Template-owned:** an edit here is lost on the next `copier update`.
- `world/docs/project/` — guides you write for this book (your naming customs, your map
  conventions, a house style for invented words). **Author-owned:** the template never touches
  them. A project guide with the same filename as a reference guide replaces it; the
  `## How we apply it here` section is the usual place to extend one instead.

## Cross-references

- `.claude/rules/syntek-author/01-layout-and-routing.md` — the reference/project split and the
  override rule, stated once for every layer.
- `world/workflows/` — the procedures that cite these guides step by step.
- `standards/method/FICTION.md` — the standard the guides serve.
