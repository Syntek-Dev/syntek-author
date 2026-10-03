# CONTEXT.md — proposal/workflows/01-assemble-the-proposal/

The procedure for building the package a reader receives: a book proposal for a work of
non-fiction, a query package for a novel. It checks what is decided and what exists, drafts each
part with the author in the book's voice, verifies every comparable title and claim, points at the
sample, proofreads, and builds a proof that is read before anything is handed back. Which parts the
package has, and what each must achieve, is set by the package anatomy guide in
`proposal/docs/reference/`; this procedure is the same for both.

## Directory Tree

```text
proposal/workflows/01-assemble-the-proposal/
├── CONTEXT.md        ← this file: when to use it, what it produces
├── CLAUDE.md         ← how to run it; guardrails
├── STEPS.md          ← the ordered procedure
└── CHECKLIST.md      ← tick as you go; model-tagged
```

## When to use this

- The package, or any part of it, needs drafting or revising.
- Comparable titles or market claims need refreshing before a submission.
- The author asks for the package, or one part of it, to be built.

Reach for a **different** procedure when the task is one approach to one reader
(`proposal/workflows/02-approach-a-reader/`), a tracker entry
(`proposal/workflows/03-update-the-tracker/`), or anything that belongs in the manuscript: fix the
chapter there, then come back.

## What it produces, and where

- **The parts of the package**, drafted or revised, at the paths `proposal/src/CONTEXT.md` lists.
- **The sample index** (`proposal/src/sample/sample-index.md`), pointing at the units the author
  chose, each with every section promoted, and the choice recorded in `.claude/MEMORY.md`.
- **Evidence entries** for any claim the pitch makes, in `research/src/evidence/`.
- **A proof** of each part, built with `make docx` and read.
- **A hand-back** naming what is drafted, what is blocked, and on whose decision.

## The failure this procedure exists to prevent

A pitch that promises a different book from the one the sample delivers. An overheated pitch for a
measured book, or a synopsis that has drifted from the story, sets up a disappointment within ten
pages of the sample, and the sample is what decides it. Every part is written in the book's voice,
from the book as it actually stands.

## Cross-references

- `proposal/docs/reference/CONTEXT.md` — the package anatomy guide this project ships.
- `proposal/docs/reference/comp-titles.md` — building the comparable-titles list.
- `proposal/src/CONTEXT.md` — the parts, and where each lives.
- `research/workflows/02-verify-a-claim/` — the gate for every claim the pitch makes.
- `.claude/skills/build/SKILL.md` — building and reading the proof.
