# CONTEXT.md — planning/workflows/09-review-the-whole-work/

The procedure for reading the whole work at once — every unit, the outline and the doc type's
plans — through a panel of structural lenses, and writing what the panel finds as advice. It is
the only procedure that looks at the shape of the work rather than at one unit: whether the order
holds, whether the parts carry their weight, whether what the early units promise the later ones
deliver. It changes nothing; the author decides, and the owning procedures act.

## Directory Tree

```text
planning/workflows/09-review-the-whole-work/
├── CONTEXT.md          ← this file (when to use, what it produces)
├── CLAUDE.md           ← operating rules for this workflow
├── STEPS.md            ← ordered steps to execute
└── CHECKLIST.md        ← verification checklist before marking complete
```

## When to use this

- When enough of the work exists to have a shape: a full outline with several units drafted, or
  a library with several documents in one family.
- Before a milestone that commits the structure: a submission, a sample, a release.
- When the author senses the work has drifted from its brief and cannot say where.

Reach for a **different** procedure when: the question is one unit's structure (the content
layer's review workflow); one unit's plan (`01-plan-a-unit`); or a body of open decisions that
need settling in order rather than reviewing (the `wayfinder` skill).

## What it produces, and where

- `planning/src/reviews/REVIEW-whole-work-DD-MM-YYYY.md` — the panel's synthesis, advice only.
  A narrower scope, such as one part or one family, names itself instead of `whole-work`.
- Dated decisions in `.claude/MEMORY.md`, only for the items the author decides.
- A list of next steps, each naming the procedure that would carry it out.

## The two failures this procedure prevents

The first is a structural problem found too late: an order that does not hold, discovered when
every unit has been polished. The second is advice mistaken for decision: a confident panel's
verdict acted on by the next session as if the author had chosen it. The review is written
early enough to matter, and marked so that it cannot be mistaken.

## Cross-references

- `planning/docs/reference/reviews-are-advice.md` — the review file and the advice line.
- `.claude/skills/structure-review/SKILL.md` — the lenses, run in a forked context; its mode
  file names this doc type's lens set.
- `planning/src/outline.md` — the order under review.
