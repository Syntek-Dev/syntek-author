---
title: "Example Proposal"
slug: example-proposal
number: ""              # the document's DOC-NNN once it is registered
version: "v1.0"         # the vMAJOR.MINOR in progress
status: draft           # idea | outlined | draft | structural-review | fact-check | line-edit | final
audience_note: "Written for Example Client Ltd's operations lead, who will forward it unchanged to the person who signs."
sources: []
verified: {V1: <%DATE%>}
sections:
  - {slug: summary, purpose: "Say in one paragraph what is proposed, for whom, and what the client decides next.", status: ""}
  - {slug: scope, purpose: "State what the handbook review and rewrite includes, what it excludes, and what it depends on.", status: ai-draft}
  - {slug: timeline, purpose: "Give each phase a start condition and a duration, not a promised date.", status: ""}
  - {slug: investment, purpose: "State the fee and the payment terms, and that a signed contract prevails if anything differs.", status: ""}
  - {slug: next-steps, purpose: "End with the single action the client takes to proceed.", status: ""}
---

# Example Proposal

<!-- WORKED EXAMPLE: a seeded brief that shows the shape of a unit brief for a document. It is
     not a real proposal. Example Client Ltd and every detail below are invented, and every
     figure is left for you to supply. Delete this file, the example proposal in
     library/src/business/drafts/ and its ledger entry,
     standards/style/ledger/example-proposal--scope.md, once your first real document is
     planned; they will not come back. -->

## Scope

In: a proposal from <%TRADING_NAME%> to Example Client Ltd to review its staff handbook and rewrite the chapters most in need of it.
Out: legal advice, which the client's own solicitor gives; the contract terms, which belong in the statement of work that follows acceptance; translation, printing and distribution.

## What this unit does

The operations lead can read it in five minutes and forward it unchanged, and the person who signs can say yes or no without a meeting.

## Sections

1. `summary`: the whole proposal in one paragraph; a reader who stops here still knows what to decide.
2. `scope`: what is in, what is out and what the work depends on, with the exclusions as specific as the inclusions.
3. `timeline`: phase durations, each starting on a stated condition.
4. `investment`: the fee, the payment terms and the precedence line.
5. `next-steps`: one action, one contact.

## Obligations and defined terms

| # | Commitment | Bounded by | Instrument clause |
|---|---|---|---|
| 1 | Review the current Handbook and report what is out of date, missing or contradictory. | The Handbook and agreed policy changes, supplied by the start date. | none yet: flagged as new |
| 2 | Rewrite the six chapters the review identifies as most in need of it. | The exclusions in `scope`. | none yet: flagged as new |
| 3 | Answer each of the Client's review rounds within five working days. | [two or three rounds] <!-- AUTHOR TO CONFIRM: the number of review rounds --> | none yet: flagged as new |
| 4 | Deliver the final Handbook as a PDF and an editable Word copy. | The two formats named, and no others. | none yet: flagged as new |
| 5 | Hold the quoted Fee for a fixed period. | [AWAITING USER INPUT] <!-- VERIFY: the validity period of the quote --> | none yet: flagged as new |

| Term | Meaning | Defined in |
|---|---|---|
| **the Client** | Example Client Ltd, the invented company this example is written for. | `summary` |
| **the Handbook** | The Client's staff handbook, in the edition current on the start date. | `scope` |
| **the Fee** | [AWAITING USER INPUT] <!-- VERIFY: the fee, in <%CURRENCY%>, before it appears in any draft --> | `investment` |

Precedence: if this proposal and a later signed contract differ, the contract prevails; `investment` says so in one sentence.

## Draws on

- [Placeholder: notes from the first meeting with the Client, in `research/src/notes/`.]
- `planning/src/precedence.md`: the order between a proposal and the contract that follows it.

## Draft notes

- `scope` is an AI draft waiting for the author's notes; it carries the same question about review rounds.
- Plain English throughout; no em dashes in client copy.
