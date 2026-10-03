# CONTEXT.md — planning/src/quests/

One plan per quest: the goal, the stakes, what sets it going, what stands in the way, what it
costs and what it gives, tied to the arcs it moves, the causality beats it rests on and the parts
of the world it relies on. A quest is planned here before its first beat is drafted, so none is
left dangling.

## Directory Tree

```text
planning/src/quests/
├── CONTEXT.md          ← this file
├── CLAUDE.md           ← operating rules
└── <slug>.md           ← one plan per quest
```

## What's here

- `<slug>.md` — a quest: frontmatter `title`, `slug`, `kind` (`main` · `side`) and `status`
  (`open` · `resolved` · `left-open`), then the goal, stakes, trigger, obstacles, reversals,
  cost, reward, ties and ending. **The shape is fixed by
  `planning/docs/reference/quest-design.md`.**

## Cross-references

- `planning/docs/reference/quest-design.md` — the parts of a quest and its file's shape.
- `planning/workflows/05-design-a-quest/` — the procedure that writes a quest.
- `planning/src/arcs/` and `planning/src/causality.md` — what each quest ties to.
- `world/src/creatures/`, `world/src/cultures/` — rules of the world a quest must obey.
