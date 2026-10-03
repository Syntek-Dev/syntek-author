# BUSINESS.md — grilling, business mode

The domain for grilling business, legal and client documents: their surfaces, the lookup order
before any question, and the order in which document decisions block one another.

## Paths and unit

- **Unit:** a document in `library/src/<family>/`, where the families are `proposals`,
  `contracts`, `policies`, `correspondence`, `finance` and `marketing`; its brief is
  `planning/src/units/<document-slug>.md`, whose settled-positions slot is
  `## Obligations and defined terms`.
- **Lookup order (step 1):** `.claude/MEMORY.md` (house rules, client facts, past corrections) →
  the target folder's `CONTEXT.md` then `CLAUDE.md`, and the client's facts in
  `library/src/contracts/client-docs/<client-slug>/CONTEXT.md` → `planning/src/document-register.md`
  and `planning/src/review-schedule.md` (does this document exist, at what version and status?) →
  the document's previous version and any covering email beside it → `planning/src/precedence.md`
  → the house standard: `standards/method/BUSINESS.md`, `standards/brand/` and
  `library/docs/reference/document-anatomy.md` → an official register, through `research`, for
  any entity detail that will appear on an instrument or invoice.
- **Procedures that open with a grilling pass:** `planning/workflows/06-run-a-review-cycle/`,
  `library/workflows/01-draft-a-section/` (when a section's job is thin) and
  `library/workflows/08-ingest-an-existing-document/`, besides the shared planning procedures.

## Additions to the steps

- **Step 1 — also start from the floor.** The five clarifying facts in
  `standards/method/BUSINESS.md` Section 6 (the counterparty's exact legal name and number, the
  jurisdiction, internal or external audience, existing content or precedent, the register) are
  settled from the record where it holds them and asked where it does not. Never ask one whose
  answer sits in a folder `CONTEXT.md`.
- **Step 1 — also wire the blocking order.** Document decisions block in predictable ways: the
  entity is verified before an instrument names it; the master agreement before the schedules
  under it; the price before the payment terms; the package structure before what each package
  contains; who signs before what they sign. A question on the wrong side of that order is
  front-loading.
- **Step 1 — also set aside every figure that already exists.** A price, rate or date already in
  a signed instrument or an earlier version is looked up; a new price or term is the author's
  decision and is asked.
- **Step 4 — also confirm what the document must deliberately not say**, and where that content
  goes instead, in the summary.

## Domain rules

| Surface | The decisions it turns on |
|---|---|
| Proposal | the reader and what they already know; the scope boundary, in and out; the price, what it buys, and whether it is packaged; the objection being pre-empted; validity period; how acceptance happens |
| Legal instrument | the counterparty as its verified legal entity and who may sign; its tier (master agreement, service levels, statement of work, schedule); term and termination; liability cap; IP and licence on exit; payment, suspension and withdrawal triggers; precedence; conditions precedent |
| Correspondence | the single ask; what the recipient's last message obliges; what must be flagged up front rather than found; whether it contradicts another unsent message; whether it needs a register number |
| Policy | who and what it applies to; the standard and control it aligns to; the owner; the review cadence; the evidence that proves compliance |
| Finance | the period and the basis; the rounding rule and who takes the residue; tax treatment; which generator owns the numbers |
| Structural | where the document lives; whether a client needs a folder; what the register row says |

- **Never ask for a fact a register holds.** Entity details come from the official register for
  the jurisdiction, never from the entity's own website or from memory.
- **Variant anti-pattern:** a commitment the instruments do not carry. A promise settled in a
  proposal grilling that no clause will honour is the most expensive decision to discover late.

## Examples

```text
**Settled — Counterparty:** Example Client Ltd, verified (library/src/contracts/client-docs/example-client/CONTEXT.md:12)
**Settled — Register:** DOC-014 at v1.0, Draft (planning/src/document-register.md:9)

**Q1 — How the support is sold**

1. **Inside the monthly retainer** — simpler to buy; harder to bound
2. **As a separate, priced schedule** — bounded and renewable; one more document to sign
3. **Ad hoc, at the day rate** — no commitment either way; no predictability for the client

**Recommendation: 2** — the master agreement's precedence clause already expects schedules, and
a schedule keeps the service levels out of the retainer.
```

Held for the next round: what the schedule's service levels are, because Q1 decides whether they
exist.
