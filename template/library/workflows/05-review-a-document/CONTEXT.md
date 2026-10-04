# CONTEXT.md — library/workflows/05-review-a-document/

The procedure for taking a document whose sections are all promoted through structural review,
fact check and line edit, into the register, and to `final` on the author's word. Each stage runs
its skills, records the date its gate passed in the unit brief's `verified:` map, and moves the
document's status in the brief and in the `.tex` status block together. It is the only route to
`final`.

## Directory Tree

```text
library/workflows/05-review-a-document/
├── CHECKLIST.md            ← verification checklist before marking complete
├── CLAUDE.md               ← operating rules for this workflow
├── CONTEXT.md              ← this file (when to use, what it produces, the order that matters)
└── STEPS.md                ← ordered steps to execute
```

## When to use this

- Every planned section of a document has been promoted and the author asks whether it is ready:
  'review the proposal', 'check the agreement before I send it'.
- A new version of a circulated document has all its revised sections promoted.

Reach for a **different** procedure when: a live document is due its scheduled review
(`planning/workflows/06-run-a-review-cycle/`); the whole library needs a structural look
(`planning/workflows/09-review-the-whole-work/`); a single section needs work
(`library/workflows/02-adapt-a-draft/` or `library/workflows/03-improve-your-draft/`); or the
author only wants to see a proof (`library/workflows/06-build-a-proof/`).

## What it produces, and where

- **A structural review** at `planning/src/reviews/REVIEW-<scope>-DD-MM-YYYY.md`, marked advice
  only; decisions enter `.claude/MEMORY.md` only when the author dates them.
- **Evidence entries** in `research/src/evidence/` for every claim checked.
- **Corrections** in the `.tex`, and any section reopened through `02-adapt-a-draft` or
  `03-improve-your-draft` and promoted again through `04-promote-a-section`.
- **Status and gate dates** in the unit brief and the `.tex` status block, stage by stage.
- **At the end of the line edit, before the issue proof:** a register row at Status `Draft` and,
  where the document has a review cycle, a review-schedule row; the `DOC-NNN` in the Document
  Control block and the brief.
- **At `final`:** the issue PDF beside the `.tex`; the author's dated word in `.claude/MEMORY.md`
  `## Status`; an approval record when the document is approved or executed.

## The order that matters most

**Structure, then facts, then the line.** Polishing sentences that a structural change will cut
wastes the author's attention, and a tone pass run before the fact check can smooth a wrong figure
into a confident one. Each stage assumes the one before it has passed; running them out of order
makes the later passes worthless.

## Cross-references

- `library/docs/reference/the-status-ladders.md` — the stages and what each status means.
- `standards/verification/verification.md` and `standards/verification/BUSINESS.md` — the gates.
- `planning/docs/reference/reviews-are-advice.md` — why a review never edits the document itself.
- `planning/workflows/08-update-the-register/` — the register rows, written before the issue
  proof.
