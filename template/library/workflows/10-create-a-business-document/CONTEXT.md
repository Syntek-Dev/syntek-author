# CONTEXT.md — library/workflows/10-create-a-business-document/

The front door for a new document in the business family: a proposal or quote, a statement of
work, a client guide, meeting notes, the business plan, a procedure or a template. It settles the
document's type, its client and its place; plans its sections from the parts
`library/docs/reference/business-standards.md` requires; then drives the shared loop section by
section, and the review, to an issued `final`. It never writes the document in one pass.

## Directory Tree

```text
library/workflows/10-create-a-business-document/
├── CHECKLIST.md            ← verification checklist before marking complete
├── CLAUDE.md               ← operating rules for this workflow
├── CONTEXT.md              ← this file (when to use, what it produces, the failure it prevents)
└── STEPS.md                ← ordered steps to execute
```

## When to use this

- The author asks for a new business document: 'write a proposal for…', 'draft a statement of
  work', 'put together an onboarding pack', 'write up the meeting'.
- The business now writes the same kind of document often enough to want a template for it.

Reach for a **different** procedure when: the document has been circulated and needs changing (a
new version, `library/docs/reference/versioning-and-the-register.md`, then the loop from
`library/workflows/02-adapt-a-draft/`); the document is planned and the author wants its next
section (`library/workflows/01-draft-a-section/`); the starting point is a document the business
already has (`library/workflows/08-ingest-an-existing-document/`); or the document belongs to
another family (that family's create procedure, where this project has it).

## What it produces, and where

- **A unit brief** at `planning/src/units/<unit-slug>.md`, its sections drawn from the parts the
  standard requires for the type.
- **A client folder** in `library/src/business/client-docs/`, with its pair and `## Facts`, when
  the client is new.
- **The document,** at `library/src/business/client-docs/<client-slug>/` (a client's), the family
  root (the business's own) or `library/src/business/templates/`, built section by section through
  the loop, reviewed to `final`, registered, with its issue PDF beside it.
- **A hand-back** at each pause: what is settled, every flag, the next procedure.

## The failure this procedure exists to prevent

**A whole document written in one pass.** A proposal drafted end to end reads as finished and
carries a dozen decisions nobody made: a scope boundary, a price, a date, a promise the business's
terms do not support. Planning the parts first and writing them one section at a time is what lets
the author see, and own, every promise in it.

## Cross-references

- `library/docs/reference/business-standards.md` — the types, parts, names and reviews.
- `planning/workflows/01-plan-a-unit/` — the brief this procedure plans.
- `library/workflows/01-draft-a-section/` to `library/workflows/05-review-a-document/` — the loop
  and the review it drives.
