# CONTEXT.md — library/src/accounting/

The accounting family: the documents that state money. Invoices, credit notes and receipts,
expense reports, financial reports, budgets and forecasts, and the business's pricing and costing
models live here. Prose documents (a report, a forecast's narrative) go through the section loop;
forms (an invoice, an expense claim) are filled from a template, field by field. The books
themselves (bank statements, ledgers kept in accounting software, identity documents) are not
documents this library produces, and records that hold bank or personal details stay out of the
repository, or in a folder git ignores, which no tool here reads.

## Directory Tree

```text
library/src/accounting/
├── CONTEXT.md              ← this file
├── CLAUDE.md               ← operating rules
├── templates/              ← invoice, credit note, report and budget starting points
├── client-docs/            ← one <client-slug>/ folder per client, holding its invoices
└── drafts/                 ← section drafts, one <unit-slug>/ folder per report (README.md only)
```

## What's here

- **Invoices** — `invoice-<YYYY>-<NNN>.tex` in `client-docs/<client-slug>/`, numbered in one
  sequence per year across the whole family, never reused and never renumbered.
- **Receipts and credit notes** — `receipt-<YYYY>-<NNN>.tex`, `credit-note-<YYYY>-<NNN>.tex`,
  each citing the invoice it settles or corrects.
- **Financial reports, budgets and forecasts** —
  `<doc-type>-<period>-v<major>-<minor>-<DD-MM-YYYY>.tex` at the family root, always versioned
  and registered, every estimate labelled as one.
- **Pricing and costing models** at the family root: internal references, each dated, stating
  the currency and whether prices include tax.
- **Registration.** Reports, budgets, forecasts and pricing models are registered; individual
  invoices and receipts are not (their number is their record).
- **Types, fields, naming and review cycles** are in
  `library/docs/reference/accounting-standards.md`.

## Cross-references

- `library/docs/reference/accounting-standards.md` — this family's standard.
- `library/workflows/13-create-an-accounting-document/` — the procedure that makes a document here.
- `standards/style/style-sheet.md` — currency, number and date formats.
- `library/src/business/client-docs/` — the client's legal name and address for invoices.
