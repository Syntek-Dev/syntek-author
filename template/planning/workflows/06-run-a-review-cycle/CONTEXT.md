# CONTEXT.md — planning/workflows/06-run-a-review-cycle/

The procedure for reviewing the documents that are due: finding them in
`planning/src/review-schedule.md`, reading each against what governs it, writing the review as
advice, and — once the author has decided — either confirming the document as current or
carrying the agreed changes into a new version, then bringing the register and the schedule
into step. A review never edits a document in place.

## Directory Tree

```text
planning/workflows/06-run-a-review-cycle/
├── CONTEXT.md          ← this file (when to use, what it produces)
├── CLAUDE.md           ← operating rules for this workflow
├── STEPS.md            ← ordered steps to execute
└── CHECKLIST.md        ← verification checklist before marking complete
```

## When to use this

- When a row in `planning/src/review-schedule.md` reaches its Next Review Date, or is
  `Overdue`.
- When the author asks for a specific registered document to be reviewed.
- When something a document relies on changes: legislation, a service, a price, a contact, a
  supplier.

Reach for a **different** procedure when: the document has never reached `final` (the
library's own review workflow, `library/workflows/05-review-a-document/`); the whole library's
structure is in question (`09-review-the-whole-work`); or only the register needs a change
(`08-update-the-register`).

## What it produces, and where

- `planning/src/reviews/REVIEW-<document-slug>-DD-MM-YYYY.md` — the review, advice only.
- Either a confirmed-current document, or a new version made through the library's authoring
  workflows; never an in-place edit of a circulated version.
- Updated rows in `planning/src/document-register.md` and `planning/src/review-schedule.md`.
- An approval record, where the review ends in formal re-approval (`07-record-an-approval`).

## The failure this procedure exists to prevent

A document that is still `Active` in the register but no longer true: a policy naming a
retired service, a template quoting superseded legislation, a contact who left. Nobody reads a
document that is not in trouble, so it rots silently; the schedule exists to make someone read
it, and this procedure makes the reading count.

## Cross-references

- `planning/docs/reference/the-document-register.md` — cycles, versions and the two lifecycles.
- `planning/docs/reference/reviews-are-advice.md` — the review file and the advice line.
- `library/docs/reference/` — each family's standard (`<family>-standards.md`) and the guides it
  is reviewed against.
