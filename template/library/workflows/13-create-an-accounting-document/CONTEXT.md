# CONTEXT.md — library/workflows/13-create-an-accounting-document/

The front door for a new document in the accounting family. It runs one of two routes. A **form**
(an invoice, a credit note, a receipt, an expense report) is filled from its template field by
field, every total recalculated, and issued on the author's confirmation. A **report** (a financial
report, a budget, a forecast, a pricing model) is planned from the parts
`library/docs/reference/accounting-standards.md` requires and driven through the shared loop and
the review to `final`. On either route, every figure traces to a source the author can name.

## Directory Tree

```text
library/workflows/13-create-an-accounting-document/
├── CHECKLIST.md            ← verification checklist before marking complete
├── CLAUDE.md               ← operating rules for this workflow
├── CONTEXT.md              ← this file (when to use, what it produces, the failure it prevents)
└── STEPS.md                ← ordered steps to execute
```

## When to use this

- The author asks for an invoice, a credit note or a receipt: 'invoice them for…', 'raise a credit
  note against…'.
- The author asks for a financial report, a budget, a forecast or a new pricing model.

Reach for a **different** procedure when: an issued invoice is wrong (a credit note, through this
procedure, never an edit to the invoice); the author only wants to see how a document looks
(`library/workflows/06-build-a-proof/`); or the document is a proposal that states prices (the
business family's create procedure).

## What it produces, and where

- **A form** at `library/src/accounting/client-docs/<client-slug>/` (an invoice, a credit note, a
  receipt) or the family root (an expense report), filled from its template, with its issue PDF.
- **A report, budget, forecast or pricing model** at the family root: a unit brief, sections
  through the loop, a review to `final`, a register row and its issue PDF.
- **A hand-back** naming every figure's source and anything the author must still confirm.

## The failure this procedure exists to prevent

**A figure nobody can trace.** A total that does not recalculate, an hour billed as a decimal the
client reads differently, a price that differs from the agreement, an invoice number used twice:
each one costs trust that no apology repairs. Taking every figure from a named source, and
confirming the number, the amounts and the due date with the author before issue, is what
prevents it.

## Cross-references

- `library/docs/reference/accounting-standards.md` — the types, fields, parts, names and reviews.
- `standards/style/style-sheet.md` — currency, number and date formats.
- `library/workflows/06-build-a-proof/` — rendering and reading a form.
