# CONTEXT.md — library/docs/reference/

The template's own guides for the business library: six short answers to the questions every
document raises, from 'how big is a section?' to 'when does a change need a new version?', and one
standard for each document family this project uses. They are template-owned and updated by
`copier update`. Project-specific guidance does not live here; it goes in `library/docs/project/`.

## Directory Tree

```text
library/docs/reference/
├── CONTEXT.md                        ← this file
├── CLAUDE.md                         ← operating rules
├── section-anatomy.md                ← what one section is, its draft file, its shape
├── drafting-with-ai.md               ← the loop, who decides what, the five questions, the record
├── the-status-ladders.md             ← section status, document status, register Status
├── document-anatomy.md               ← the parts of a business document, in order
├── latex-deliverables.md             ← house preamble, section markers, promotion, rendering
├── versioning-and-the-register.md    ← vMAJOR.MINOR, new files for new versions, the register
<: if DOC_TYPE == 'business' and 'legal' in BUSINESS_FAMILIES :>├── legal-standards.md                ← instruments: types, required parts, clauses, names
<: endif :><: if DOC_TYPE == 'business' and 'email' in BUSINESS_FAMILIES :>├── email-standards.md                ← correspondence: artefacts, filing, subject lines
├── EMAIL-ANATOMY-AND-NAMING.md       ← its sub-document: the four parts, naming, the checklist
<: endif :><: if DOC_TYPE == 'business' and 'accounting' in BUSINESS_FAMILIES :>├── accounting-standards.md           ← invoices, reports, budgets: types, fields, names
<: endif :><: if DOC_TYPE == 'business' and 'social-media' in BUSINESS_FAMILIES :>├── social-media-standards.md         ← plans, calendars, profiles: parts, platforms, names
<: endif :><: if DOC_TYPE == 'business' and 'msp-scp' in BUSINESS_FAMILIES :>├── msp-scp-standards.md              ← the policy suite and operational documents: types, names
├── MSP-SCP-POLICY-SUITE.md           ← its sub-document: the suite's order, policy structure
<: endif :>└── business-standards.md             ← proposals, statements of work, guides: types, parts, names
```

## What's here

- `section-anatomy.md` — the small passage the loop works on, the draft file and its frontmatter,
  and the shape of a good business section.
- `drafting-with-ai.md` — the authoring loop in table form, who decides which facts, the five
  questions every document answers first, and the provenance record.
- `the-status-ladders.md` — the three lifecycles kept apart: a section's status, a document's
  status (in the unit brief and the `.tex` comment block) and the register's publication Status.
- `document-anatomy.md` — the parts every deliverable carries, in order.
- `latex-deliverables.md` — the house preamble and skeleton, the `% section:` markers, converting
  a Markdown draft on promotion, and rendering twice.
- `versioning-and-the-register.md` — version numbers, versioned filenames, superseding a
  circulated document, and what the register records.
- **The family standards,** `<family>-standards.md`, one for each family in `library/src/`: the
  family's document types, the parts each must carry, its names and its review cycles. A standard
  longer than a guide keeps its detail in a `SCREAMING-CASE.md` sub-document beside it, which it
  names.

## Cross-references

- `library/docs/project/` — your guides; a same-named file there overrides one here.
- `library/workflows/` — the procedures that apply these guides step by step.
- `standards/method/BUSINESS.md` and `standards/verification/BUSINESS.md` — the rules and gates
  these guides serve.
