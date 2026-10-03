# CONTEXT.md — research/src/setting/

Setting notes: the real world the novel borrows, gathered so that every departure from it is a
choice. One note per subject (a place, a period, a trade, a procedure), each recording what is true,
where that comes from and how the book uses or departs from it.
Empty at generation<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>, apart from the example languages' notes<: endif :>.
Invented facts belong to the story bible in `world/src/`; a fact the prose states plainly is
checked into `research/src/evidence/` as well.

## Directory Tree

```text
research/src/setting/
├── CONTEXT.md            ← this file: the note format
├── CLAUDE.md             ← operating rules
<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>├── example-model-*.md    ← seeded once with the example languages: yours to delete
<: endif :>└── <subject>.md          ← one note per place, period, trade or procedure
```

## What's here

**Each note carries:** the subject and the period it covers · what is true, as texture the prose
can use (sights, sounds, routines, vocabulary) · the source of each detail, with dates; a
first-hand account named by role unless its giver agrees to be named · **the book's departures from
the real world**, each deliberate and logged in `planning/src/continuity.md` · the chapters it
serves.

```markdown
---
subject: "A place, period, trade or procedure"
period: ""               # the years the note is true for
serves: []               # chapter slugs
checked: DD/MM/YYYY
---

# <Subject>

## What is true
## Sources
## Departures
## History
```

<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>A new project may hold `example-model-*.md`, seeded once with the example languages: the
research behind each of their real-world models. Their Wikipedia points are kept as leads, not
citations, each with a `VERIFY` flag, to show the difference. **They are yours to delete with the
example languages; `copier update` never brings them back.**

<: endif :>## Cross-references

- `research/docs/reference/real-world-detail.md` — the guide: what counts, deliberate departures.
- `research/workflows/01-ingest-a-source/` — reading a source into a note.
- `research/workflows/02-verify-a-claim/` — for a detail the prose will state plainly.
- `planning/src/continuity.md` — where departures are logged so `continuity` can hold the book to
  them.
- `research/src/permissions.md` — any quoted passage the setting brings with it.
