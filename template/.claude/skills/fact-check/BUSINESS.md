# BUSINESS.md — fact-check in a business document

In a business document a wrong fact is not an embarrassment; it is a term someone can rely on. The
checks here are the ones a counterparty, a client's solicitor or an auditor makes: who exactly the
parties are, what the law actually says, and whether every price, date and service level traces to
something the author has agreed.

## Paths and unit

- **The unit** is a document in a family under `library/src/<family>/`: a `.tex` deliverable with
  its sections between `% section:` markers, or Markdown correspondence. Section drafts sit in
  `library/src/<family>/drafts/<unit-slug>/`.
- **The sweep** is step 5 of `library/workflows/05-review-a-document/`. A scheduled review sends
  every claim about the outside world here from step 4 of `planning/workflows/06-run-a-review-cycle/`.
- **Flags:** `\dnote{VERIFY: …}` in a `.tex` file, `<!-- VERIFY: … -->` in Markdown.
- **A client's facts** live once, under `## Facts` in the client folder's `CONTEXT.md` in
  `library/src/contracts/client-docs/<client-slug>/`. Check against them and update them through
  that file; never copy them elsewhere.
- **Extra reads:** `standards/method/BUSINESS.md` rule 7; `standards/risk/BUSINESS.md` rule 5;
  `standards/verification/BUSINESS.md` (V5.1 and V5.2 follow this sweep);
  `planning/src/precedence.md`; `standards/brand/disclaimers.md`; the jurisdiction in
  `.claude/CLAUDE.md` Section 1.

## Additions to the steps

- **Step 2 — also queue:** every legal entity named (its exact legal name, company or charity
  number, registered office); every statute, regulation, standard or framework cited; every price,
  fee, rate, date, deadline, period and service level; every certification, accreditation,
  insurance or compliance claim; every claim of track record or results; every figure in a finance
  document.
- **Step 5 — also, for an entity:** the public register for the jurisdiction, never the entity's
  own website, letterhead or email signature. For England and Wales: Companies House for companies
  and limited liability partnerships, and the Charity Commission's register for charities. Record
  the registered name exactly, the number, the status (active, dissolved, in administration or
  liquidation), the registered office and the date checked, in the client's `## Facts`.
- **Step 5 — also, for law:** the official legislation database for the jurisdiction (for the
  United Kingdom, legislation.gov.uk), with the section read in the version in force on the date
  that matters, and its commencement and amendments checked. Never a section number from memory,
  from a summary or from a model's answer.
- **Step 5 — also, for a price, date or service level:** the source is the author's own record (a
  signed instrument, a quotation sent, the schedule, the author's written instruction). A figure
  that traces to one is verified against it. A figure that traces to nothing is not a fact to
  check but a decision: flag it `AUTHOR TO CONFIRM` and hand it to `obligation-check`.
- **Step 5 — also, for a certification or accreditation:** the certifying body's own public
  record, with the certificate's scope and expiry date.
- **Step 6 — also check these conflations:** a trading name or group company taken for the
  contracting entity; a dissolved or renamed entity; a repealed, amended or not yet commenced
  section; the law of England and Wales stated for Scotland or Northern Ireland; a bill,
  consultation or guidance quoted as law; a price with and without VAT; calendar days and working
  days; a target quoted as a guarantee; last year's price list.
- **Step 7 — also:** a legal, tax or financial statement is verified as information with its date,
  never turned into advice (`standards/risk/BUSINESS.md` rule 5).
- **Step 9 — also:** an unfilled field stays `[AWAITING USER INPUT]`; a value found by the check is
  offered to the author, never written into the field unasked.
- **Step 10 — also:** corrections the author accepts are applied in the `.tex` directly and listed
  in the hand-back (`library/workflows/05-review-a-document/` step 5); each is also made in the
  section's draft and logged in its ledger entry, and `make section-check` is re-run (that
  workflow's 'Applying agreed fixes'). A change of substance reopens its section through the
  library's authoring loop. Clause-level findings (a defined term,
  a cross-reference, a modal verb) go to `clause-consistency` and `obligation-check`, which run
  next.

## Domain rules

- **Never the entity's own site.** An entity is what the public register says it is, on the date
  checked.
- **No invented section numbers.** A statute is cited by its short title and the section that was
  read.
- **Every price, date and service level is verified against its source,** or flagged; none is
  verified against the author's memory of a conversation.
- **One home per fact.** A client's legal name, number and address are verified into the client
  folder's `## Facts` and cited from there.
- **Confidentiality.** An evidence entry about a client cites the client folder by path and holds
  only what the check needs (`.claude/rules/syntek-author/06-global-rules.md` Section 10).
- **Claims of experience and results** ('fixed within one working day') need the record behind
  them (`standards/method/BUSINESS.md` rule 1) or come out.

## Examples

Invented claims, shown as report lines; bracketed parts stand for real details.

> **Parties clause.** 'Example Client Ltd (company number [number])'. The public register gives the
> registered name as 'Example Client Limited', active, with that number, checked [date].
> `verified-with-caveat`: the parties clause and the signature block must use the registered name
> exactly. Client `## Facts` updated with the check.

> **Clause [N].** '[Act], section [M] requires the client to…'. The section read in the version in
> force on [date] imposes the duty on the service provider, not the client. `unsupported` as
> written; recommend redrafting with the author, flag kept.

> **`investment` section.** The fee in the proposal differs from the quotation the author sent on
> [date]. Reported as blocking; the author says which figure stands; flag kept until the prose
> matches.

> **`scope` section.** 'Response within four hours.' No clause in the current agreement and no
> written instruction carries it. Not a verdict: flagged `AUTHOR TO CONFIRM` as a new commitment
> and handed to `obligation-check`.
