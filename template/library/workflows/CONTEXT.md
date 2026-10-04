# CONTEXT.md — library/workflows/

The procedures that make a business document: the authoring loop every document runs, from
drafting one section to building a proof, and the create procedure of each document family this
project uses, which settles a new document's type, place and required parts and then drives the
loop. Each numbered folder holds four files: `CONTEXT.md` (when to use it),
`CLAUDE.md` (its rules), `STEPS.md` (the ordered procedure) and `CHECKLIST.md` (what to tick).
They are procedural instructions Claude follows, not human-facing guides. Planning a document and
keeping the register are procedures of `planning/workflows/`, not this folder.

## Directory Tree

```text
library/workflows/
├── CONTEXT.md                          ← this file
├── CLAUDE.md                           ← operating rules
├── 01-draft-a-section/                 ← the AI drafts one section from the unit brief
├── 02-adapt-a-draft/                   ← revise a draft from the author's notes or edits
├── 03-improve-your-draft/              ← the author drafted; the AI proposes changes as a diff
├── 04-promote-a-section/               ← on the author's word, move a section into the document
├── 05-review-a-document/               ← review a whole document, register it, make it final
├── 06-build-a-proof/                   ← render a PDF or Word copy and read it
├── 07-learn-from-your-edits/           ← turn the author's edits into voice notes
├── 08-ingest-an-existing-document/     ← bring an existing document into the library
├── 10-create-a-business-document/      ← a new proposal, statement of work, guide or plan
<: if DOC_TYPE == 'business' and 'legal' in BUSINESS_FAMILIES :>├── 11-create-a-legal-document/         ← a new agreement, NDA, DPA, terms or notice
<: endif :><: if DOC_TYPE == 'business' and 'email' in BUSINESS_FAMILIES :>├── 12-write-an-email/                  ← a new email to a client or a supplier
<: endif :><: if DOC_TYPE == 'business' and 'accounting' in BUSINESS_FAMILIES :>├── 13-create-an-accounting-document/   ← a new invoice, report, budget or forecast
<: endif :><: if DOC_TYPE == 'business' and 'social-media' in BUSINESS_FAMILIES :>├── 14-create-a-social-media-document/  ← a new plan, calendar, profile set or campaign
<: endif :><: if DOC_TYPE == 'business' and 'msp-scp' in BUSINESS_FAMILIES :>├── 15-create-an-msp-scp-document/      ← a new IT policy, runbook or service report
<: endif :>└── local/                              ← your own procedures; a same-named one overrides these
```

## What's here

| You want to… | Procedure |
|---|---|
| start a new proposal, statement of work, client guide or business plan | `10-create-a-business-document/` |
<: if DOC_TYPE == 'business' and 'legal' in BUSINESS_FAMILIES :>| start a new contract, NDA, data processing agreement, terms or notice | `11-create-a-legal-document/` |
<: endif :><: if DOC_TYPE == 'business' and 'email' in BUSINESS_FAMILIES :>| write an email to a client or a supplier | `12-write-an-email/` |
<: endif :><: if DOC_TYPE == 'business' and 'accounting' in BUSINESS_FAMILIES :>| raise an invoice, or start a financial report, budget or forecast | `13-create-an-accounting-document/` |
<: endif :><: if DOC_TYPE == 'business' and 'social-media' in BUSINESS_FAMILIES :>| start a social media plan, content calendar, profile set or campaign | `14-create-a-social-media-document/` |
<: endif :><: if DOC_TYPE == 'business' and 'msp-scp' in BUSINESS_FAMILIES :>| start an IT policy, runbook, service report or incident report | `15-create-an-msp-scp-document/` |
<: endif :>| have the AI write the next section of a document | `01-draft-a-section/` |
| revise an AI draft using your notes, or after editing it yourself | `02-adapt-a-draft/` |
| turn a template into a document for a client | `02-adapt-a-draft/` |
| have the AI suggest improvements to a section you wrote | `03-improve-your-draft/` |
| put an approved section into the document | `04-promote-a-section/` |
| check a finished document and make it final | `05-review-a-document/` |
| see how a document looks as a PDF or Word file | `06-build-a-proof/` |
| teach the AI your voice from the edits you have made | `07-learn-from-your-edits/` |
| bring in a document you already have (Word, PDF or LaTeX) | `08-ingest-an-existing-document/` |
| plan a new document before any of the above | `planning/workflows/01-plan-a-unit/` |
| review a live document that is due its scheduled review | `planning/workflows/06-run-a-review-cycle/` |

## Cross-references

- `library/workflows/local/` — your procedures, and the override rule.
- `library/docs/reference/drafting-with-ai.md` — the loop these procedures implement.
- `standards/verification/verification.md` — the gates the procedures' checklists cite.
