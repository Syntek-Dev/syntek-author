---
name: accounting-documents
description: >-
  Create an accounting document, or check that one has everything its type requires: an invoice,
  credit note or receipt, an expense report, a financial report, a budget forecast, a pricing
  model, or an accounting table or CSV. Holds each type's required sections, the currency, VAT
  and numbering conventions, the UK tax-year, trading-disclosure and HMRC references to verify,
  the disclaimer rule and the pre-issue checklist (net plus VAT equals gross, every total foots),
  and routes to the create workflow and the accounting standard. Use when the author says 'raise
  an invoice for…', 'credit that invoice', 'write up my expenses for…', 'prepare the quarterly
  report', 'build a budget forecast', 'is this invoice right?' or 'does the VAT add up?'. Never
  supplies a price, rate or figure. Not pricing a proposal (`business-documents`); not verifying
  a rate or statute (`fact-check`); not payment terms in a contract (`obligation-check`).
---

# Skill: Accounting documents (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

The accounting family is the business's money on paper: what it charges, what it spends, and how
it is doing. This skill owns the family's domain: which document types exist, what each must
contain, and the conventions that make every figure traceable and every total correct. The
procedure of record is the create workflow. Whenever another skill works on a document in
`library/src/accounting/`, the conventions and checklist here bind it too. Nothing here is
accounting or tax advice: the author's accountant decides treatment, and every rate is checked at
the date it applies.

## Governing procedures (route here — do not restate at length)

- `library/workflows/13-create-an-accounting-document/` — the procedure of record for a new
  accounting document; this skill is its domain in skill form. Run its `STEPS.md` with
  `CHECKLIST.md` open. Where this file and the procedure disagree, the procedure wins and the
  disagreement is reported to the author. An alias in `00-project.md` `## Workflow aliases`, then a
  same-named folder in `library/workflows/local/`, replaces it (`run-workflow`).
- `library/docs/reference/accounting-standards.md` — the family standard: naming, numbering
  patterns, document control rows and review cycle. Route there; do not restate it.
- `.claude/rules/syntek-author/00-project.md` — `## Brief` (trading name, jurisdiction, currency)
  and `## Paths` (disclaimers, client facts, LaTeX skeleton, brand folder). It outranks every other
  rules file; take those values from it.
- `.claude/rules/syntek-author/03-authorship.md` Sections 4 and 7 (never fabricate; no figure is
  invented or changed), `standards/method/BUSINESS.md` rule 7 and `standards/risk/BUSINESS.md`
  rules 2, 3 and 5.
- `library/docs/reference/document-anatomy.md` (forms are filled, not drafted) and
  `library/docs/reference/versioning-and-the-register.md`.

## Document types and required sections

### Invoice

1. Supplier: trading name and address, with the trading disclosures the business's legal form
   requires (a company's registered name, number and office; a sole trader or partnership trading
   under another name, the owners' names and an address for service), as the Companies Act 2006
   and the Company, Limited Liability Partnership and Business (Names and Trading Disclosures)
   Regulations 2015 require
2. VAT registration number, where registered
3. Invoice number in the standard's sequence: unique, sequential, never reused
4. Invoice date, the time of supply where it differs, and the due date
5. Customer: legal name and address, from the client's facts file
6. Line items in the standard's columns (Category · Description · Hours or quantity · Price)
7. Net subtotal; VAT at each rate, or the statement of VAT status; gross total
8. Payment terms as the agreement states them, and the customer's order reference where given
9. Payment details and the reference to use, as the author entered them in the invoice template
10. For a business customer, where the author uses one: the statement of the right to interest and
    compensation under the Late Payment of Commercial Debts (Interest) Act 1998

### Credit note

1. Supplier details and VAT number, as on the invoice
2. Credit note number, from its own sequence
3. The invoice it credits (number and date) and the reason
4. The lines credited, the VAT adjusted, and the totals
5. How the credit is settled (refund, or set against a later invoice)

### Receipt

The receipt number; the date; the payer; what was paid for, and the invoice it settles; the amount
and how it was paid.

### Expense report

1. Claimant, role, period (DD/MM/YYYY to DD/MM/YYYY), date submitted, approver by role
2. Summary: total claimed; total approved (completed by the approver)
3. Itemised claims (# · Date · Description · Category · Amount · VAT · Receipt reference · Status)
4. Totals by category
5. Mileage, where claimed: journeys, miles and the rate, at HMRC's approved mileage allowance
   payment rates for the tax year of the journey, checked on GOV.UK (`VERIFY` until checked)
6. The claimant's declaration that each claim is genuine, business-related and receipted
7. Approval: approved, part-approved or rejected, by whom, and the date
8. Policy notes from the business's own expenses policy: what is reimbursable, receipts, limits

### Financial report

1. Entity, period, prepared by, date, and the basis of preparation (management figures unless the
   author's accountant prepared them)
2. Summary: the headline figures and what changed
3. Profit and loss: revenue by category, direct costs, gross profit and margin, overheads,
   operating profit, interest and tax, net profit
4. Balance sheet: assets, liabilities, net assets and equity
5. Cash flow: operating, investing, financing, net change in cash
6. Key indicators, each defined on first use
7. Notes: the source of every figure and the basis of every estimate

### Budget forecast

1. Entity, horizon, period, stage, prepared by, date
2. Summary, with the three scenarios (best · expected · worst) side by side
3. Assumptions, numbered, each with a value per scenario
4. Revenue by stream, monthly for the first year and annual after
5. Costs by category, on the same basis
6. Capital expenditure (Item · Planned date · Cost · Depreciation period)
7. Cash flow: opening cash, receipts, payments, closing cash, monthly for the first year
8. Sensitivity: each key assumption at −20%, −10%, base, +10% and +20%
9. Multi-year summary, where the horizon passes one year

### Pricing or costing model

1. What is priced, and for whom
2. The basis: costs, hours, rates and margins, each with its source and date
3. The resulting prices, each saying whether it includes tax
4. The assumptions, and the model it supersedes, labelled as superseded

### Accounting table or CSV

A header row of clear column names; no merged cells; a labelled totals row; every formula
described in a note (or a `%` comment in a `.tex` table); one currency format throughout; dates
DD/MM/YYYY unless the software it feeds needs another form, recorded in the note; and a notes
section naming the source of the data and every assumption.

## House conventions

- **Format.** Reports and forecasts are LaTeX deliverables from the skeleton `00-project.md`
  `## Paths` names (by default `tooling/latex/skeleton.tex`). An invoice, credit note or expense
  report is a form filled from its template in `library/src/accounting/templates/`, never drafted
  section by section. Every table is `tabularx`, amounts right-aligned, totals in bold under a rule.
- **Where it lives.** A client's invoices and credit notes in
  `library/src/accounting/client-docs/<client-slug>/`; the business's own expenses, reports and
  forecasts at the family root; templates in `templates/`.
- **Currency.** The house currency in `00-project.md` `## Brief`, in the format of
  `standards/style/style-sheet.md` (symbol first, two decimal places, comma thousands). Every
  amount says whether it includes VAT. A second currency shows both amounts, the rate, its source
  and its date.
- **VAT.** The business's VAT status, and the rate for each supply, come from the author and
  their accountant; never assume the standard rate. Registered: the VAT number, the rate and VAT
  per line or rate, then net, VAT and gross. Not registered: no VAT line, and 'Not VAT
  registered'. Zero-rated: the 0% line shown. Exempt: 'Exempt', with the reason. Outside the scope
  of UK VAT or reverse charge: the wording the accountant confirms. HMRC's current invoice
  requirements are checked on GOV.UK (`VERIFY` until checked).
- **Numbering.** Sequential and never reused, in the patterns the standard gives. A wrong invoice
  is corrected by a credit note and a new invoice, never edited, deleted or renumbered once sent.
- **Periods.** The UK tax year runs 6 April to 5 April; a company's financial year ends on its own
  accounting reference date. Every report and forecast says which it uses.
- **Figures.** Every figure comes from the author, a record in the family, or the accountant, and
  carries `VERIFY` until traced. The arithmetic is checked by recomputing it: line totals, net
  plus VAT equals gross, columns foot, the cash flow closes to the balance sheet.
- **Register.** Neutral and factual; third person in reports; terms such as EBITDA or capital
  expenditure defined for a non-financial reader. Brand voice does not reach figures; the
  letterhead does.
- **Disclaimer.** A report, forecast or summary prepared for another reader takes the financial
  class's wording, copied unchanged from the disclaimers file `00-project.md` `## Paths` names (or
  `\dnote{AUTHOR TO CONFIRM: …}` until it has one). An invoice or credit note carries none unless
  that file gives one for it.
- **Payment details.** The business's own details and bank details live only in the invoice
  template, entered there by the author; this skill never types them from memory, another document
  or a chat, and a missing one stays `\fillme`. Time worked is shown as the standard sets it.

## How to create an accounting document

1. **Fix the type and its home.** Agree with <%AUTHOR_FIRST_NAME%> the type from the lists above,
   for whom, the period or date it covers, and whether it replaces or corrects an earlier one.
   Check `planning/src/document-register.md` and the family folder for the last number used in
   the sequence. Name the file from `library/docs/reference/accounting-standards.md`.
   *Complete when:* the type, the customer or reader, the path, the filename and (for an invoice
   or credit note) the next number are agreed.

2. **Settle the facts and the figures.** Read `00-project.md` `## Brief` and `## Paths`, the
   client's facts file (by default `library/src/business/client-docs/<client-slug>/CONTEXT.md`
   under `## Facts`), and the agreement, statement of work or quotation the figures come from. Ask
   what is still unknown, with a recommended answer each, as `06-global-rules.md` Section 8 says
   unless `00-project.md` `## Overrides` sets another style: the currency, the VAT status and the
   rate for each supply, the payment terms, the period, and for a forecast the assumptions.
   Prices, rates and amounts come only from the author or a traced record. *Complete when:* every
   figure is traced, or stands as `[AWAITING USER INPUT]` or a `VERIFY` flag.

3. **Plan a report as a unit.** A financial report, budget forecast or pricing model is planned
   through `planning/workflows/01-plan-a-unit/`, with one section per required section above. An
   invoice, credit note, receipt, expense report or table is a form and goes straight to step 4.
   *Complete when:* the brief is agreed (V1 dated), or the document is confirmed to be a form.

4. **Start or fill the document.** Copy the family template, or the skeleton, to the agreed path.
   Fill a form's fields from the facts and figures of step 2, leaving `\fillme` for anything still
   missing; for a report, fill the title block, disclaimer slot, Document Control rows and one
   `% section:` marker pair per brief section. *Complete when:* `make pdf FILE=<path>.tex` renders
   it and no field holds a guess.

5. **Write the prose through the loop.** A report's or forecast's commentary goes section by
   section through `draft-section`, `adapt-section` or `improve-section`, then `promote-section`
   on the author's word. Commentary explains the figures; it never changes them. *Complete when:*
   every section is promoted, or the document is a form and has none.

6. **Check every figure and the family's rules.** Recompute every line, subtotal, VAT amount and
   total, and reconcile the report's statements with each other. Run `fact-check` on every rate,
   threshold and statute named, and `obligation-check` on payment terms that restate an
   agreement. Work the checklist below with `make flags SCOPE=<path>` and `make lint
   SCOPE=<path>`. *Complete when:* the arithmetic is confirmed and every item is ticked or
   reported open with its location.

7. **Register it and hand back.** Add its row through `planning/workflows/08-update-the-register/`
   and list it in its folder's `CONTEXT.md`. Put the number, the amounts, the tax line and the due
   date to the author explicitly; issue only on their word: `make pdf FILE=<path>.tex ISSUE=1`
   writes the PDF beside the source and refuses to overwrite an issued one. Hand back the totals as
   recomputed, every open flag, and the next step (send, file, or pass to the accountant).
   *Complete when:* the register row is written and the author has the hand-back.

## Pre-issue checklist

- [ ] Currency confirmed and used throughout; VAT inclusion stated on every amount.
- [ ] VAT status and rates confirmed with the author; the VAT treatment shown correctly.
- [ ] Every required section or field for the type present.
- [ ] Trading disclosures and the VAT number on invoices and credit notes.
- [ ] Number in sequence, unique, never reused; a due date on every invoice.
- [ ] Payment details as the author entered them in the template, or `\fillme` reported open.
- [ ] Every line, subtotal and total recomputed: net plus VAT equals gross; columns foot.
- [ ] Mileage, thresholds and statutory figures checked for the period, with the date.
- [ ] The financial disclaimer on a report or forecast, verbatim, or the waiver recorded.
- [ ] No `\fillme`, `[AWAITING USER INPUT]`, `\dnote` or open flag in an issued document.
- [ ] en_GB, DD/MM/YYYY; register row written.

## Anti-patterns

- **Supplying a figure.** A price, rate, hour count or amount the author did not give is a guess
  on a document someone will pay or rely on.
- **Assuming the standard rate of VAT**, or VAT registration, or a reverse charge.
- **Quoting a rate from memory.** Mileage rates, thresholds and statutory interest change.
- **Editing a sent invoice.** Credit it and issue a new one; the sent file stays as sent.
- **Reusing or skipping a number** to tidy a sequence.
- **Copying bank details** from another document or a conversation.
- **Commentary that moves a figure.** Words explain numbers; they never round, restate or adjust
  them.
- **Treating management figures as statutory accounts.** Say which a report is.

## Cross-references

- `library/docs/reference/accounting-standards.md` — the family standard.
- `library/workflows/13-create-an-accounting-document/` — the procedure of record.
- `.claude/rules/syntek-author/00-project.md` — the project's values and paths.
- `standards/style/style-sheet.md` — the currency and number formats.
- `standards/method/BUSINESS.md`, `standards/risk/BUSINESS.md`.
- `planning/src/document-register.md` — numbers and versions issued.
- `.claude/skills/fact-check/SKILL.md` — rates, thresholds and statutes checked at their date.
- `.claude/skills/obligation-check/SKILL.md` — payment terms against the agreement.
- `.claude/skills/business-documents/SKILL.md` — the proposals and quotations prices come from.
