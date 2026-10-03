# CONTEXT.md — world/src/cultures/

One file per culture the story depicts: how a people lives, what it values and fears, how it is
governed, what it does at birth, marriage and death, and how it names its children and its
places. What the people are (body, lifespan, homelands) is in `world/src/peoples/`; a culture
file names its people. Characters from a culture link to its file, and `create-name` follows its
naming customs.

## Directory Tree

```text
world/src/cultures/
├── CONTEXT.md          ← this file
├── CLAUDE.md           ← operating rules and the file skeleton
├── example-culture.md  ← seeded once at generation: an invented example; yours to delete
└── <slug>.md           ← one culture, named for its registered name in kebab-case
```

## What's here

Each `<slug>.md` carries frontmatter `name`, `ipa`, `people` (the slug of its people file),
`homeland` (the slug of its place file) and `first_appears`, then nine sections in this order:

- `## Land and livelihood` — climate, food, work, trade, tools.
- `## Values and taboos` — what they prize, what shames them, what they fear.
- `## Beliefs and rites` — what they hold true; the rites of a life.
- `## Power and kinship` — who decides, how family is reckoned, how law is kept.
- `## Customs` — hospitality, greeting, dress, food, quarrel and reconciliation.
- `## Naming customs` — **how people and places are named; `create-name` reads this section.**
- `## Variety and neighbours` — factions, classes, dissenters; relations with other peoples.
- `## Role in the story` — the scenes the culture shapes.
- `## Continuity facts` — fixed details, each with its section once promoted prose uses it.

Language work reads four of these sections before it proposes anything: values (where
vocabulary runs deep), power and kinship (forms of address and honorifics), beliefs and rites
(sacred registers) and the materials and tools of land and livelihood (what a script is written
on, and with what).

A new project may hold `example-culture.md`, seeded once when the project was generated: an
invented culture with every section filled, the culture the example languages cite. **It is
yours to delete; `copier update` never brings it back.**

## Cross-references

- `world/workflows/05-create-a-culture/` — the procedure that writes these files.
- `world/docs/reference/cultures.md` — building a culture from ground to custom.
- `standards/risk/FICTION.md` — depiction risk when a culture borrows from a real one.
- `world/src/peoples/` — what the people who hold the culture are.
- `world/src/characters/` — the individuals who carry the culture onto the page.
