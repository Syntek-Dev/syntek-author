# CONTEXT.md — research/src/contested-readings/

Worked maps of passages serious Christians read more than one way. Where the book leans on such a
passage, it says so in the body: which reading it adopts, and what would change if another were
right. That promise cannot be kept from memory; it is kept from these maps. The map is where the
scholarship goes, so the chapter can stay light. Empty at generation.

## Directory Tree

```text
research/src/contested-readings/
├── CONTEXT.md            ← this file: the map format
├── CLAUDE.md             ← operating rules
└── <passage>.md          ← one map per passage, named for it (e.g. book-chapter-verses.md)
```

## What's here

**Each map carries:** the passage in the default translation named in
`standards/style/style-sheet.md`, with its context · the readings, each named as its holders name it
and stated so they would recognise it · who holds each and where it is argued, with sources · **what
each reading does to the book's argument** · where the readings agree · the reading the book adopts,
the reason, and what would change if another were right · original-language terms glossed, the
philology kept separable for a footnote · the chapters it serves.

```markdown
---
passage: "Book chapter:verses"
translation: ""          # the citation key of the translation quoted
serves: []               # chapter slugs that lean on this passage
adopted: ""              # empty until the author decides
last_updated: DD/MM/YYYY
---

# <Passage>

## The passage
## The readings
## Who holds them
## What each does to the argument
## Where they agree
## The reading adopted, and why
## Language notes
## History
```

## Cross-references

- `research/docs/reference/contested-readings.md` — the guide: the recognition test, what turns on
  it, a position without false balance.
- `research/workflows/03-map-a-contested-reading/` — the procedure that writes these maps.
- `planning/src/arguments/` — argument maps, which link to the maps here.
- `standards/method/THEOLOGY.md` — contested readings named in the body; the six claim categories.
