# CONTEXT.md — library/src/finance/

The finance family: the documents that state money. Invoices, receipts and credit notes, financial
reports, budgets and forecasts live here. Prose documents (a report, a forecast's narrative) go
through the section loop; forms (an invoice, a receipt) are filled from a template, field by field.
The books themselves (bank statements, ledgers kept in accounting software, identity documents)
are not documents this library produces and do not belong in the repository.

## Directory Tree

```text
library/src/finance/
├── CONTEXT.md              ← this file
├── CLAUDE.md               ← operating rules
├── templates/              ← invoice, receipt and report starting points
├── client-docs/            ← one <client-slug>/ folder per client, holding its invoices
└── drafts/                 ← section drafts, one <unit-slug>/ folder per report (README.md only)
```

## What's here

- **Invoices** — `invoice-<YYYY>-<NNN>.tex` in `client-docs/<client-slug>/`, numbered in one
  sequence per year across the whole family, never reused and never renumbered.
- **Receipts and credit notes** — `receipt-<YYYY>-<NNN>.tex`, `credit-note-<YYYY>-<NNN>.tex`,
  each citing the invoice it settles or corrects.
- **Financial reports** — `financial-report-<period>-v<major>-<minor>-<DD-MM-YYYY>.tex` at the
  family root, always versioned and registered.
- **Budgets and forecasts** — `budget-<period>-v<major>-<minor>-<DD-MM-YYYY>.tex` and
  `forecast-<period>-v<major>-<minor>-<DD-MM-YYYY>.tex`, every estimate labelled as one.
- **Registration.** Reports, budgets and forecasts are registered; individual invoices and
  receipts are not (their number is their record).

## Cross-references

- `standards/style/style-sheet.md` — currency, number and date formats.
- `standards/brand/disclaimers.md` — the notice a financial report or forecast carries.
- `library/src/proposals/` — the agreed prices an invoice must match.
- `library/src/contracts/client-docs/` — the client's legal name and address for invoices.
