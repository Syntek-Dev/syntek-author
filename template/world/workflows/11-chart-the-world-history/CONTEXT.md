# CONTEXT.md — world/workflows/11-chart-the-world-history/

The procedure for charting the world's long past: how years are reckoned, the eras in order,
and a file for each major event that moved, mixed or divided the peoples (a migration, a
conquest, first contact, a split). For each event it traces the marks left in language
(loanwords, splits, borrowed scripts) so that every people, culture and language can say when
it came to be as it is. Where the history is too large for one sitting, it charts a decision
map first and works the frontier over several sessions.

## Directory Tree

```text
world/workflows/11-chart-the-world-history/
├── CHECKLIST.md        ← model-tagged checklist; tick it as you go
├── CLAUDE.md           ← operating rules for this procedure
├── CONTEXT.md          ← this file: when to use it, what it produces
└── STEPS.md            ← the ordered steps, each naming its skill and guide
```

## When to use this

- Two peoples share words, a language must split into daughters, or a script must look
  borrowed, and the story needs to know when and why.
- A people or culture file names a migration, conquest or contact that has no event file yet.
- The backstory has grown past what fits in characters' memories, and its order is in doubt.

Reach for a **different** procedure when the events are the story's own, told on the page in
story-time order (`planning/workflows/03-chart-the-causality/`, which keeps
`planning/src/timeline.md`), or when the job is one people (`world/workflows/10-create-a-people/`).

## What it produces, and where

- **Rows in `world/src/history/eras.md`**: the reckoning, then one row per era, oldest first.
- **Event files** at `world/src/history/<slug>.md`, with frontmatter and the seven sections:
  What happened, Causes, Who it changed and how, Linguistic consequences, What each people
  remembers, Role in the story, Continuity facts.
- **A decision map** in `planning/src/maps/`, only when the history is too large for one sitting.
- **A list of language work to do:** each split, loan and borrowed script, handed on so the
  author can decide how it shows in the words.

## The failure this procedure exists to prevent

The history assembled from backstory one fact at a time, with nothing to put the facts in
order. Two peoples who 'have always traded' turn out to have been conquered by each other in
different chapters; a language splits before the migration that split it; a loanword enters a
language before its speakers ever met the lenders. Fixing the eras first, then placing each
event and its consequences inside one, keeps the past in one order that every later fact can be
checked against.

## Cross-references

- `world/docs/reference/world-history.md` — eras, events, and the marks events leave in language.
- `world/src/history/` — where the eras and events live, and the event skeleton.
- `planning/src/timeline.md` — the story's own days, and the calendar the reckoning meets.
- `planning/docs/reference/decision-maps.md` — when a map earns its place.
