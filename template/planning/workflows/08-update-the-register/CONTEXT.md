# CONTEXT.md — planning/workflows/08-update-the-register/

The procedure for adding, changing or retiring a row in `planning/src/document-register.md`, and
for carrying the same change into the review schedule and the precedence table where it
reaches them. It keeps the register what it must be: one true line per document, with an ID
that never changes and a history that is never deleted.

## Directory Tree

```text
planning/workflows/08-update-the-register/
├── CONTEXT.md          ← this file (when to use, what it produces)
├── CLAUDE.md           ← operating rules for this workflow
├── STEPS.md            ← ordered steps to execute
└── CHECKLIST.md        ← verification checklist before marking complete
```

## When to use this

- A document has finished its line edit and needs its `DOC-NNN` before the issue proof (the
  business gate V6.2 requires the row; `library/workflows/05-review-a-document/` calls this
  procedure there).
- A document's status, version or review dates change outside a review cycle.
- A document is retired, superseded or terminated.
- A newly registered instrument states an order of precedence.

Reach for a **different** procedure when: the change comes from a scheduled review
(`06-run-a-review-cycle` updates the register as its own step); or it comes from a signing or
approval (`07-record-an-approval`).

## What it produces, and where

- A new or updated row in `planning/src/document-register.md`.
- Where applicable, a row in `planning/src/review-schedule.md` and rows in
  `planning/src/precedence.md`.
- For a new registration, the document's `DOC-NNN` in its unit brief's `number`.

## The failure this procedure exists to prevent

A register that drifts from the library: a final document that was never registered, an ID
reused after a deletion, a row still pointing at the file of an old version. Each looks small; together
they mean the register can no longer answer the one question it exists for — which version of
what is current.

## Cross-references

- `planning/docs/reference/the-document-register.md` — IDs, columns, statuses and versions.
- `planning/src/document-register.md` — the register and its writing rules.
- `planning/src/precedence.md` — the stated order between instruments.
