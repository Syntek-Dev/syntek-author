# CONTEXT.md — planning/workflows/03-chart-the-causality/

The procedure for charting why each beat of a unit happens: every beat recorded in
`planning/src/causality.md` with the beat, decision or rule that causes it and what it makes
necessary next, its place in story time in `planning/src/timeline.md`, and the facts it will
establish proposed for `planning/src/continuity.md`. It makes the chain visible before the prose
is written, so a scene that merely happens next is caught at the cost of a row.

## Directory Tree

```text
planning/workflows/03-chart-the-causality/
├── CONTEXT.md          ← this file (when to use, what it produces)
├── CLAUDE.md           ← operating rules for this workflow
├── STEPS.md            ← ordered steps to execute
└── CHECKLIST.md        ← verification checklist before marking complete
```

## When to use this

- After a chapter's brief is agreed and before its first section is drafted.
- When a chapter's beats change: a scene cut, moved or added. Re-chart the affected beats and
  every beat that cited them.
- When a reader, an editor or the `causality` skill reports that something 'just happens'.

Reach for a **different** procedure when: the question is how a character changes across the
book (`04-chart-a-character-arc`); the prose is drafted and the question is whether it matches
the facts (`continuity`, at the content layer's review workflow); or the order of the chapters
themselves is in doubt (`09-review-the-whole-work`).

## What it produces, and where

- New and updated rows in `planning/src/causality.md`, under `## Chain` and `## Open setups`.
- New and updated rows in `planning/src/timeline.md`.
- Facts the beats will establish, under `## Proposed` in `planning/src/continuity.md`.
- The brief's `## Continuity facts`, brought into step.

## The failure this procedure exists to prevent

A plot that advances by 'and then'. Each scene reads well on its own, but nothing forces the
next, coincidence rescues the protagonist, and a setup planted in chapter 2 is never paid off.
Readers feel it as a sagging middle and cannot say why. On the chain, each fault is a cell left
empty.

## Cross-references

- `planning/docs/reference/causality-chains.md` — the columns, coincidence, setup and payoff.
- `standards/method/FICTION.md` — the story engine the chain records.
- `world/src/` — the rules of the world that a beat may cite as its cause.
