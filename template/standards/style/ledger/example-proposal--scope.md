---
unit: example-proposal
section: scope
origin: ai              # ai | author
drafted: <%DATE%>
promoted:               # DD/MM/YYYY, set by promote-section
change_ratio:           # 0.00 to 1.00, computed at promotion; empty for author-drafted
learned: false          # set true by learn-voice once promoted and mined
---

<!-- WORKED EXAMPLE: the ledger entry for the example proposal's AI draft,
     library/src/business/drafts/example-proposal/02-scope.md, shipped once by the template so
     that the draft's ledger: key resolves and the loop can be practised on it from the first
     session. Its AI original is the draft's body exactly as shipped. It is not a real document.
     Delete it with the example proposal, together with any provenance.md row added while
     practising; it will not come back. -->

## AI original

<!-- INTERNAL NOTE: Worked example shipped once by the template. Example Client Ltd, its handbook and every detail below are invented. It shows a section draft's frontmatter, both flags, one sentence per line, and the shape of a scope section. Delete this folder, its unit brief planning/src/units/example-proposal.md and its ledger entry standards/style/ledger/example-proposal--scope.md when you no longer need them: they will not come back. -->

## Scope of work

This proposal covers the review and rewrite of the Example Client Ltd staff handbook, and nothing beyond it.
The boundary is deliberate: anything not listed under In scope is out of scope until both parties agree a change in writing.

### In scope

- A review of the current handbook, reported in a short note of what is out of date, missing or contradictory.
- A rewrite of the six chapters the review identifies as most in need of it, in plain English, for every member of staff.
- Two rounds of review by Example Client Ltd, each answered within five working days of receiving its comments. <!-- AUTHOR TO CONFIRM: two review rounds, or three? -->
- The final handbook as a PDF and as an editable Word copy.

### Out of scope

- Legal advice.
  Example Client Ltd's own solicitor reviews the rewritten handbook before it is issued to staff.
- Advice on any individual employment case.
- Translation, printing and distribution.
- Changes to the client's systems, forms or contracts of employment.

### What the work depends on

<: if BUSINESS_VOICE_PERSON == 'plural' :>We<: else :>I<: endif :> need the current handbook, and every policy change agreed since its last edition, by the start date.
Each review round assumes one consolidated set of comments from Example Client Ltd, not separate comments from each reader.
Where a chapter must reflect a change in the law, the rewrite states the law as it stands on the date of delivery. <!-- VERIFY: which legal changes since the last edition the client expects the rewrite to cover -->

### Changes to scope

A change to this scope is agreed in writing before work on it begins, with its effect on the timeline and the investment stated.
<: if BUSINESS_VOICE_PERSON == 'plural' :>We<: else :>I<: endif :> do not start out-of-scope work on a spoken request, however small it seems.

## Author final

## Improvement decisions

| # | Proposal | Reason | Decision | Author's note |
|---|---|---|---|---|
