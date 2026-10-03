# CONTEXT.md — proposal/src/endorsements/

The endorsement drive: the tracker of everyone approached, the approach emails drafted for the
author to send, and the endorsements that come back, kept exactly as they arrive. Its job is to
turn the reach described in `proposal/src/book-proposal/07-endorsements-and-reach.md` into real
names, real approaches and real replies. The tracker ships as an empty seed.

## Directory Tree

```text
proposal/src/endorsements/
├── CONTEXT.md                      ← this file
├── CLAUDE.md                       ← operating rules
├── tracker.md                      ← seed: the single source of truth for every approach
├── drafts/                         ← approach emails awaiting the author; README.md only at first
└── received-<reader-slug>.md       ← each endorsement, verbatim, attributed and dated
```

## What's here

- `tracker.md` — one row per person: name, affiliation, tier, why them, the ask, what was sent,
  when the author sent it, status, reply, next action and its date. **Read it before every
  approach.** Statuses: `to approach` · `approached` · `chasing` · `yes` · `no` · `lapsed`.
- `drafts/` — one email per person, `<reader-slug>.md`, under 250 words, never sent from here.
  Every build excludes `drafts/`.
- `received-<reader-slug>.md` — an endorsement as it arrived, with who gave it and the date. It is
  their words and their name: never edited for length or polish without their agreement.

## Cross-references

- `proposal/docs/reference/book-proposal-anatomy.md` — endorsers by reach, and the tracker's rules.
- `proposal/docs/reference/approaching-readers.md` — the moves of a good approach.
- `proposal/workflows/02-approach-a-reader/` — drafting one approach.
- `proposal/workflows/03-update-the-tracker/` — logging what happened.
