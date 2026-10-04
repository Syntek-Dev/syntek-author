@./CONTEXT.md

# CLAUDE.md — library/src/accounting/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/src/CONTEXT.md` → `library/src/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold the documents that state money, so that every figure in them can be traced to its source.

## How to work here

- **Routing:** the `accounting-documents` skill and
  `library/docs/reference/accounting-standards.md`, through
  `library/workflows/13-create-an-accounting-document/`. A report, budget or forecast goes through
  the loop, with `fact-check` on every figure. An invoice or receipt is filled from `templates/`
  directly and rendered with `library/workflows/06-build-a-proof/`; it has no sections to draft.
- **Model:** **Opus** for every figure and every sentence about one; the mechanical tier only for
  copying a template and rendering.
- **Concrete steps:**
  1. Take every figure from the author, an agreed proposal or contract, or the books, never from
     memory or estimate.
  2. For an invoice, find the highest number issued this year anywhere in this family, propose the
     next one, and confirm it with the author before writing it.
  3. Check every total by recalculating it; state the tax line explicitly.
  4. Render, read the proof, and hand back for the author to issue.
- **Definition of done:** every figure traces to its source, every total recalculates, every
  estimate is labelled, the tax line is stated, the disclaimer is present on a financial report,
  and the author has approved the document.

## Guardrails

- **Never invent, round or estimate a figure silently.** An estimate is labelled as one, with its
  basis; a figure the author has not given is `\dnote{AUTHOR TO CONFIRM: …}`.
- **Invoice numbers are never reused, skipped without a note, or renumbered.** A mistake on an
  issued invoice is corrected by a credit note, never by editing the invoice.
- **The tax line is never blank:** state the amount, or state that none is charged.
- **Durations are hours and minutes, never decimal hours,** with the decimal in brackets only
  where it multiplies a rate. Currency follows `standards/style/style-sheet.md`.
- **Bank details appear only in the fields of the invoice template, entered by the author.** Never
  copy them into a draft, a note, a guide or any other document.
- **An invoice matches its agreement.** A price that differs from the proposal or contract is
  flagged for the author before the invoice is rendered.
- **A generated file is regenerated, never hand-edited.** Where a model's tables come from a
  script, change the script and run it again.

## Output & naming

- **Hand-written:** invoices, receipts, credit notes, reports, budgets, forecasts (`.tex`) and
  pricing models, named to the patterns in `library/docs/reference/accounting-standards.md`.
- **Generated (never hand-edit):** the issued PDF beside each `.tex`.
