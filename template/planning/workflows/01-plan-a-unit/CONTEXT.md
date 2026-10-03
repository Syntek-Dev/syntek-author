# CONTEXT.md — planning/workflows/01-plan-a-unit/

The procedure for turning a unit from an idea into a brief the author has agreed: its scope, its
job, its sections in plan order, the positions it commits to and what it draws on. It ends with
the brief agreed, at `status: outlined` with V1 (idea → outlined) recorded, ready for its first
section. It drafts no prose and creates nothing in the content layer.

## Directory Tree

```text
planning/workflows/01-plan-a-unit/
├── CONTEXT.md          ← this file (when to use, what it produces)
├── CLAUDE.md           ← operating rules for this workflow
├── STEPS.md            ← ordered steps to execute
└── CHECKLIST.md        ← verification checklist before marking complete
```

## When to use this

- Before the first section of any unit is drafted. Drafting without a brief is drafting from
  memory.
- When a unit's scope or section plan has to change materially: re-plan the existing brief with
  this procedure, never start a second one.
- When the outline gains a unit that will be drafted next.

Reach for a **different** procedure when: the question is the order or shape of the whole work
(`09-review-the-whole-work`); a body of decisions is too big for one sitting (the `wayfinder`
skill); the brief is agreed and the next job is prose (the content layer's
`01-draft-a-section`); or the unit needs its doc type's structural plan (the companion
procedure listed in `planning/workflows/CLAUDE.md`).

## What it produces, and where

- `planning/src/units/<unit>.md` — the brief, at `status: outlined`, with `V1` dated in
  `verified`.
- A row in `planning/src/outline.md`, added or confirmed.
- For a re-plan, a report of any section markers in the content layer that no longer match the
  brief, for the author to settle there.
- Decisions that pass the memory gate, recorded in `.claude/MEMORY.md`; new or sharpened terms
  in `standards/style/terminology.md`.

## The failure this procedure exists to prevent

A unit drafted from a plan that lived only in the conversation. The next session cannot see it,
sections drafted out of order contradict each other, and the contradiction surfaces at
structural review, when it is most expensive to repair. A written, agreed brief is what lets a
fresh session draft section 4 without re-deciding what sections 1 to 3 committed to.

## Cross-references

- `planning/docs/reference/unit-briefs.md` — the brief's shape and the two status ladders.
- `.claude/skills/grill-with-docs/SKILL.md` — the questioning, the lookup order and the memory
  gate.
- `standards/verification/verification.md` — the gates the unit will pass after this.
