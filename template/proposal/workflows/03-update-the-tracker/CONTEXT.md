# CONTEXT.md — proposal/workflows/03-update-the-tracker/

The short procedure for keeping the tracker true: every approach, reply, request, chase and lapse
logged, with the next action and the date it falls due. The tracker is the single source of truth
for who has been asked what; nothing else in the repository knows. Its path, its columns and its
status vocabulary are in the tracker itself and in `proposal/src/CONTEXT.md`; this procedure is the
same for an endorsement drive and an agent submission.

## Directory Tree

```text
proposal/workflows/03-update-the-tracker/
├── CONTEXT.md        ← this file: when to use it, what it produces
├── CLAUDE.md         ← how to run it; guardrails
├── STEPS.md          ← the ordered procedure
└── CHECKLIST.md      ← tick as you go; model-tagged
```

## When to use this

Every time something happens with a reader:

- the author has sent an approach;
- a reply, a request, a pass, a yes or an offer has come in;
- a chase falls due, or a response time has passed;
- an earlier entry turns out to be wrong.

Reach for a **different** procedure when the task is drafting an approach
(`proposal/workflows/02-approach-a-reader/`) or changing the package
(`proposal/workflows/01-assemble-the-proposal/`).

## What it produces, and where

- **An updated tracker**, with the row created or changed and its next action dated.
- **Anything received, kept verbatim**, where the package anatomy guide says it lives.
- **A hand-back** of one line per change, and everything falling due soon.

## The distinction that matters most

**A drafted approach is not an approach.** The status moves on from its first value only when the
author has sent it, and the date recorded is the date the author sent it. A tracker that confuses
the two claims someone was asked when they were not, which is exactly how a second first approach
happens.

## Cross-references

- `proposal/src/CONTEXT.md` — where the tracker lives.
- `proposal/docs/reference/CONTEXT.md` — the package anatomy guide: statuses and the chase rule.
- `proposal/workflows/02-approach-a-reader/` — the procedure that ends by handing over to this one.
