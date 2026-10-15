# BUSINESS.md — to-questionnaire, business mode

Who a business asks when the author cannot settle a decision alone, and the rule that a client's
intake belongs to its family skill, not here.

## Paths and unit

- **Questionnaires:** `planning/src/questionnaires/QUESTIONNAIRE-<SLUG>-DD-MM-YYYY.md`, with the
  returned copy beside it as `QUESTIONNAIRE-<SLUG>-DD-MM-YYYY-RETURNED.md`. This folder holds the
  questions the business itself must answer before a document can be settled; a client's intake
  is a deliverable, and is filed with the client.
- **The decision it unblocks** usually sits in a document's brief,
  `planning/src/units/<document-slug>.md` (its `## Obligations and defined terms`), or in a row of
  `planning/src/document-register.md`.
- **Recipients:** an accountant, a solicitor or another professional adviser; a supplier; a
  colleague or collaborator; a client, on a decision that is not their intake.
- **Voice:** the brand folder `00-project.md` `## Paths` names (by default `standards/brand/`, with
  `brand-voice.md`), and the voice person in `00-project.md` `## Brief`.

## Additions to the steps

- **Step 1 — also route these elsewhere.** A new client's intake questionnaire is a document type of
  `business-documents`, filed in the client's folder in `library/src/business/client-docs/`, never
  here. A vendor's security or service assessment belongs to the managed-service family's skill,
  where the project has it, under its vendor assessment report. An entity's legal name, number or
  address comes from the official register through `research`, never from a questionnaire.
- **Step 1 — also settle what the recipient may see.** One client's facts, prices or terms never
  appear in a questionnaire to anyone else (`.claude/rules/syntek-author/06-global-rules.md`
  Section 10); an adviser receives only what the question needs.
- **Step 2 — also ask an adviser for their position, not for a document.** A questionnaire to a
  solicitor or an accountant asks how a term or a treatment applies to the business's facts, and
  states those facts as context for them to correct.
- **Step 5 — also trace what comes back.** A figure, a rate or a treatment an adviser returns is
  checked through `fact-check` before a document relies on it, and a term it settles is recorded
  in the brief's `## Obligations and defined terms`.

## Domain rules

| Recipient | Register, and what to ask |
|---|---|
| A professional adviser | Formal and exact; name the jurisdiction (`00-project.md` `## Brief`) and the date the facts hold at |
| A supplier | Plain and specific; ask for the terms, limits and dates the document must state |
| A colleague or collaborator | The house voice, plain; ask for the decision they own, by when |
| A client (not their intake) | The house voice; ask only what the document in hand needs from them |

- **Never ask for a figure the author has set.** A price or rate already in a signed instrument
  is looked up; a new one is the author's decision.
- **A returned answer is not advice to the client.** It informs the business's own decision; a
  document never quotes an adviser without the author's word.

## Examples

```text
# VAT treatment of the support retainer (proposal DOC-014)

**Purpose:** the proposal's price table cannot be finalised until the treatment is confirmed.
**From:** the author · **To:** the business's accountant · **By:** 28/11/2026
**Status:** draft

## The retainer
### How should a monthly support retainer billed in advance be treated for VAT?
The retainer, its billing and the client's location are set out in the context above.

1. Standard-rated, invoiced monthly in advance
2. Another treatment — please name it and the basis

**Recommended:** 1 — it is how the business has invoiced retainers so far; correct it if wrong.

> <answer stub>
```
