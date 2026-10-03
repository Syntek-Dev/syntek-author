# CONTEXT.md — planning/workflows/02-map-the-argument/

The procedure for laying out a chapter's argument before it is drafted: the thesis, the claims
that carry it with their categories, what supports each claim, the contested readings it leans
on, the objections it must face and where it concedes. It writes the argument map beside the
chapter's brief and audits it, so the prose argues a structure whose gaps have already been
found. It is a plan and an audit; it drafts no prose.

## Directory Tree

```text
planning/workflows/02-map-the-argument/
├── CONTEXT.md          ← this file (when to use, what it produces)
├── CLAUDE.md           ← operating rules for this workflow
├── STEPS.md            ← ordered steps to execute
└── CHECKLIST.md        ← verification checklist before marking complete
```

## When to use this

- After a chapter's brief is agreed (`01-plan-a-unit`) and before its first section is drafted.
- When a chapter's structure changes: a claim added or dropped, a section reordered, an
  objection newly found. Re-audit the existing map; never start a second one.
- Before structural review, to check the map still matches what the chapter now argues.

Reach for a **different** procedure when: a passage is read more than one way and has not been
mapped (`research/workflows/03-map-a-contested-reading/` comes first); a single claim needs
checking against its source (`research/workflows/02-verify-a-claim/`); the draft exists and the
question is whether it argues in good faith (`manuscript/workflows/10-steelman-the-objections/`).

## What it produces, and where

- `planning/src/arguments/<unit>.md` — the argument map, named exactly as the chapter's brief.
- The brief's `## Claims and categories`, updated with the agreed claims and their IDs.
- A report of open moves: unsupported claims, missing premises, conclusions beyond their
  evidence.

## The failure this procedure exists to prevent

A chapter whose conclusion arrives before its support, or whose inference is presented as the
text itself. Both are easy to write and hard to see in finished prose, because good sentences
hide a missing step. Found on the map, each costs a line; found at structural review, a
rewrite.

## Cross-references

- `planning/docs/reference/argument-maps.md` — the six categories and the map's shape.
- `standards/method/THEOLOGY.md` — the method the map is audited against.
- `planning/src/arguments/` — where maps live.
