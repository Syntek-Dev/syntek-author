# CONTEXT.md — proposal/workflows/02-approach-a-reader/

The procedure for drafting one approach to one reader whose yes the book needs: an endorser for a
work of non-fiction, an agent for a novel. It reads the tracker, confirms why this person, checks
what they ask for and what exists to send, tailors the approach, checks that nothing is invented,
proofreads it, and hands it to the author, who sends it. Who the readers are, what they expect and
when to chase are set by the package anatomy guide in `proposal/docs/reference/`.

## Directory Tree

```text
proposal/workflows/02-approach-a-reader/
├── CONTEXT.md        ← this file: when to use it, what it produces
├── CLAUDE.md         ← how to run it; guardrails
├── STEPS.md          ← the ordered procedure
└── CHECKLIST.md      ← tick as you go; model-tagged
```

## When to use this

- The author wants to approach someone new.
- A first approach needs revising before the author sends it.
- A reply has not come and the chase rule allows one chase.

Reach for a **different** procedure when the task is logging something that has already happened
(`proposal/workflows/03-update-the-tracker/`), or building the package the approach will offer
(`proposal/workflows/01-assemble-the-proposal/`).

## What it produces, and where

- **One draft approach** in the `drafts/` folder beside the tracker, named for the reader; both
  paths are listed in `proposal/src/CONTEXT.md`.
- **A hand-back** to the author: the draft's location, why this reader, the ask, what is offered
  and by when, and anything needing the author's confirmation.
- **A tracker row**, through `03-update-the-tracker`, once the author has sent it.

## The failure this procedure exists to prevent

A template sent untailored, or a second first approach to someone already asked. The first reads
as a mail-merge and is the commonest reason a good reader declines; the second is entirely
preventable and entirely embarrassing. Reading the tracker first, and naming the specific reason it
is this person, prevents both.

## Cross-references

- `proposal/docs/reference/approaching-readers.md` — the moves of a good approach.
- `proposal/docs/reference/CONTEXT.md` — the package anatomy guide: who the readers are.
- `proposal/src/CONTEXT.md` — where the tracker and the drafts live.
- `.claude/skills/approach-a-reader/SKILL.md` — this procedure in skill form.
