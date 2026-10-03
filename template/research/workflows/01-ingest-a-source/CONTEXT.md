# CONTEXT.md — research/workflows/01-ingest-a-source/

The procedure for getting a work from a passing mention to a note the project can cite: route it,
read it at its origin, record what it argues and where it disagrees, capture quotable passages with
page numbers, and key it, all in one pass, so nobody has to read it twice.

## Directory Tree

```text
research/workflows/01-ingest-a-source/
├── CONTEXT.md        ← this file: when to use it, what it produces
├── CLAUDE.md         ← how to run it; guardrails
├── STEPS.md          ← the ordered procedure
└── CHECKLIST.md      ← tick as you go; model-tagged
```

## When to use this

- A book, paper, report, judgment or article needs reading into the evidence base.
- The author supplies a source and asks for it to be recorded.
- A unit needs grounding that is an argument or a position rather than a checkable claim.

Reach for a **different** procedure when: the source gives a figure, a date, a study finding or a
legal statement the work will state (`research/workflows/02-verify-a-claim/`, the gate, which this
procedure never replaces); or the routing table in `research/src/CONTEXT.md` sends the material to a
specialist folder with its own procedure, listed in `research/workflows/CONTEXT.md`. A reference
whose details are already known and checked needs only the add-reference skill, where the project keeps the
citation database.

## What it produces, and where

- **A note** in the folder the routing table names: usually `research/src/sources/`, sometimes
  split across two folders, never duplicated.
- **A citation key**, written in the same pass as the note, where the project keeps the citation
  database; otherwise complete bibliographic details in the note itself.
- **A hand-back:** the key, the note's location, the units it serves, and the disagreement it found.

## The two things this procedure exists to force

- **Reading the primary source.** Coverage citing a report citing a study is three chances for a
  claim to drift, and the drift always runs towards whatever is quotable. Follow the chain back.
- **Recording the disagreement.** A note that harvests only agreeable quotations produces a work
  that cites people who would not endorse its conclusion, and leaves every later review with
  nothing to test the argument against. Where a source resists the work, *how* it resists is the
  most valuable line in the note.

## Cross-references

- `research/docs/reference/ingesting-sources.md` — the guide this procedure enacts.
- `research/src/CONTEXT.md` — the routing table.
- `research/src/sources/CONTEXT.md` — the source-note format.
- `research/workflows/02-verify-a-claim/` — the gate for anything checkable.
- `.claude/skills/research/SKILL.md` — the skill that reads and searches.
