# CONTEXT.md — proposal/workflows/

The proposal layer's ordered procedures: assembling the package, approaching one reader, and
keeping the tracker true. Where `proposal/docs/` explains the judgement calls and `proposal/src/`
holds the package, this folder holds the steps. The three procedures are the same for every book;
everything that differs between a book proposal and a query package lives in the package anatomy
guide in `proposal/docs/reference/` and in `proposal/src/CONTEXT.md`, which the steps defer to.

## Directory Tree

```text
proposal/workflows/
├── CONTEXT.md                  ← this file: the index
├── CLAUDE.md                   ← operating rules; 'You want to… | Procedure'
├── 01-assemble-the-proposal/   ← draft, source, proofread and build the package
├── 02-approach-a-reader/       ← one tailored approach, drafted for the author to send
├── 03-update-the-tracker/      ← log every approach, reply, chase and lapse
└── local/                      ← your own procedures; a same-slug one overrides
```

## What's here

- `01-assemble-the-proposal/` — check what is decided and what exists, draft each part with the
  author, verify every comparable title and claim, point at the sample, proofread, build and read
  the proof. **Nothing is sent.**
- `02-approach-a-reader/` — read the tracker, confirm why this reader, tailor the approach, check
  nothing is invented, hand it to the author. **Draft, never send.**
- `03-update-the-tracker/` — record what actually happened, set the next action and its date,
  append corrections. **The tracker is the single source of truth.**
- `local/` — the author's procedures, in their own numbering; a same-slug one replaces the
  template's, and `run-workflow` looks there first.

Every procedure folder holds four files: `CONTEXT.md`, `CLAUDE.md`, `STEPS.md` and
`CHECKLIST.md`. **Numbering is frozen and append-only.**

## Cross-references

- `proposal/docs/reference/CONTEXT.md` — the guides, including this project's package anatomy.
- `proposal/src/CONTEXT.md` — where each part of the package and the tracker live.
- `.claude/skills/run-workflow/SKILL.md` — resolves an intent to a procedure, local first.
- `manuscript/src/` — what is being offered, and what actually exists.
