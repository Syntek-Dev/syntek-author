# CONTEXT.md — proposal/src/submissions/

The submission drive: the tracker of every agent queried, the tailored queries drafted for the
author to send, and what each agent asked for and said. Agents are chosen for the reason recorded in
their row, never in bulk. The tracker ships as an empty seed.

## Directory Tree

```text
proposal/src/submissions/
├── CONTEXT.md            ← this file
├── CLAUDE.md             ← operating rules
├── tracker.md            ← seed: the single source of truth for every query
└── drafts/               ← one tailored query per agent, awaiting the author; README.md only at first
```

## What's here

- `tracker.md` — one row per agent: agent, agency, why them, what their guidelines ask for, what
  was sent, when the author sent it, status, reply, next action and its date. **Read it before every
  query.** Statuses: `to query` · `queried` · `requested` · `passed` · `offer` · `withdrawn` ·
  `lapsed`.
- `drafts/` — one tailored query per agent, `<agent-slug>.md`, built from the master
  `proposal/src/query-letter.md` and the agency's own requirements. Never sent from here; every
  build excludes `drafts/`.

## Cross-references

- `proposal/docs/reference/query-package-anatomy.md` — the parts, agents' guidelines, the statuses.
- `proposal/docs/reference/approaching-readers.md` — the moves of a good approach.
- `proposal/workflows/02-approach-a-reader/` — drafting one query.
- `proposal/workflows/03-update-the-tracker/` — logging what happened.
