# CONTEXT.md — research/workflows/03-map-a-contested-reading/

The procedure for mapping a passage serious Christians read more than one way, **before** a chapter
leans on it. It sets out the passage, states each reading in its holders' own terms, records who
holds it and where, says what each reading does to the book's argument, notes where the readings
agree, and recommends the reading to adopt, for the author to decide. The map is where the
scholarship goes, so the chapter can stay light.

## Directory Tree

```text
research/workflows/03-map-a-contested-reading/
├── CONTEXT.md        ← this file: when to use it, what it produces
├── CLAUDE.md         ← how to run it; guardrails
├── STEPS.md          ← the ordered procedure
└── CHECKLIST.md      ← tick as you go; model-tagged
```

## When to use this

- A chapter's brief or argument map leans on a passage where serious Christians differ. **Before
  drafting**, not after.
- A draft names a passage as settled when it is not, and `category-check` or `tradition-check` has
  flagged it.
- The author asks how a passage is read across traditions.

The list of passages is never closed: if drafting reaches for any passage where serious Christians
differ, it goes through here first.

Reach for a **different** procedure when the disputed thing is empirical
(`research/workflows/02-verify-a-claim/`, which reports disagreement rather than mapping it), or
when a commentary simply needs reading (`research/workflows/01-ingest-a-source/`).

## What it produces, and where

- **A map** at `research/src/contested-readings/<passage>.md`, named for the passage because maps
  are shared, in the format in `research/src/contested-readings/CONTEXT.md`.
- **A recommendation** for the reading to adopt, with its reason; the decision is the author's, and
  the map carries an `AUTHOR TO CONFIRM` flag until it is made.
- **Citation rows** for every commentary and article cited, where the project keeps the citation
  database.

## The failure this procedure exists to prevent

A chapter that caricatures a reading it disagrees with, written from memory. By the time anyone
notices, the caricature looks researched, and the readers who hold that view stop trusting the
rest of the book. The recognition test, applied here before any prose exists, is the defence.

## Cross-references

- `research/docs/reference/contested-readings.md` — the guide this procedure enacts.
- `standards/method/THEOLOGY.md` — contested readings named in the body; the claim categories.
- `planning/src/arguments/` — argument maps that link to the finished map.
- `.claude/skills/tradition-check/SKILL.md` — how readers from other traditions would push back.
