# CONTEXT.md — manuscript/workflows/10-steelman-the-objections/

The **good-faith audit**. A theology book that asks its readers for intellectual honesty has to
show its own: objections stated so their holders would recognise them, costs conceded before they
are answered, contested readings named in the body, the author's own stake declared, and claims kept
in their proper categories. This procedure checks a chapter against those commitments and reports.
It is a review, never a rewrite: the author and the section procedures make every change.

## Directory Tree

```text
manuscript/workflows/10-steelman-the-objections/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, what it produces, the one thing that matters)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

- `manuscript/workflows/05-review-a-chapter/` reaches the structural gates, and
  `standards/verification/THEOLOGY.md` names the steelman gate among them.
- The author asks whether a passage is fair, whether a concession is real, or whether the chapter
  argues in good faith.
- A new chapter might have answered an objection the book has chosen to leave standing.

Reach for a **different** procedure when: the issue is prose quality
(`manuscript/workflows/03-improve-your-draft/`, or the line stage of the review); the argument's
structure itself needs mapping (`planning/workflows/02-map-the-argument/`); a disputed passage has
not been mapped yet (`research/workflows/03-map-a-contested-reading/`); or a claim's truth is the
question (`research/workflows/02-verify-a-claim/`).

## What it produces, and where

- **A prioritised report**, blocking first: exact location, which check fails, why, a suggested
  fix, and the procedure that owns the fix.
- **Three verdicts, stated even when they pass:** steelman (pass or fail, naming the weakest
  objection); conceded before rebutted (pass or fail, naming any inversion); left standing (still
  standing, answered at a named location, or none designated).
- **A dated gate entry** in the chapter brief's `verified:` record when the audit runs as the review
  gate and passes.
- **A flag to the author** when an objection the book leaves standing has been answered, and, once
  the author decides, a dated entry in `.claude/MEMORY.md` Decisions.

## What it must never do

- **Never rewrite the author's argument or conclusions.** It reports.
- **Never weaken a response to make an objection look stronger.** The fix for a weak steelman is a
  stronger statement of the objection, not a softer answer.
- **Never invent an objection nobody holds.** A steelman is the best version of a view someone
  actually has.
- **Never re-designate an objection left standing.** If a chapter has answered it, the author
  decides whether the chapter changes or the designation does.

## Cross-references

- `standards/method/THEOLOGY.md` — the six claim categories, contested readings, concede before
  rebut, the recognition test, and the objection that may be left standing.
- `planning/src/arguments/` — the chapter's argument map, with its objections and concessions.
- `research/src/contested-readings/` — the maps of disputed passages.
- `manuscript/docs/reference/main-text-and-footnotes.md` — the four things never put in a note.
