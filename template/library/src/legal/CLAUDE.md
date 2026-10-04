@./CONTEXT.md

# CLAUDE.md — library/src/legal/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/src/CONTEXT.md` → `library/src/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold the instruments that bind the business and its counterparties, and the notices served under
them.

## How to work here

- **Routing:** the `legal-documents` skill and `library/docs/reference/legal-standards.md`; a new
  instrument runs `library/workflows/11-create-a-legal-document/`, with `clause-consistency` and
  `obligation-check` at fact check. `adapt-section` turns a template into a client instrument.
  Plain-English tone work never touches an instrument's clauses: the formal register stays.
- **Model:** **Opus** throughout. Nothing in an instrument is mechanical except copying files.
- **Concrete steps:**
  1. Verify the counterparty against the public register for the jurisdiction, never its own
     website, and record the result under `## Facts` in
     `library/src/business/client-docs/<client-slug>/CONTEXT.md` with the date checked.
  2. Start from the matching template, or from the house skeleton with definitions first.
  3. Draft clause groups as sections; promote; review with every gate; execute only on the
     author's word.
- **Definition of done:** every defined term is defined once and used as defined; every
  cross-reference resolves; precedence is stated; every obligation is intended; governing law is
  stated; the disclaimer for the document's class is present; no `\dnote` survives; the author
  has approved it.

## Guardrails

- **'Shall' for an obligation, 'may' for a permission, 'must' for an absolute requirement.** Every
  one is intentional; an unbounded 'will' is a finding.
- **Defined terms are defined once, bolded once, capitalised every time,** and near-synonyms carry
  a sentence saying how they differ.
- **Never invent a statute or a section number.** Write 'applicable data protection legislation'
  unless the provision has been verified, with a `VERIFY` flag until it is.
- **The counterparty is the entity that can contract.** Where the reader and the counterparty
  differ, the instrument says so plainly.
- **Templates hold no counterparty and no agreed number:** negotiable values are bracketed
  placeholders until a client instrument fills them.
- **Executed means signed by every party, with the signed copy filed.** Never set Executed, in the
  register or the Document Control block, on anything less.
- **Every instrument is a starting point for professional review.** Its disclaimer is copied
  unchanged from the disclaimers file `00-project.md ## Paths` names; never paraphrased.

## Output & naming

- **Hand-written:** instruments, letters and templates (`.tex`), section drafts.
- **Received, never edited:** signed copies (`-signed.pdf`).
- **Generated (never hand-edit):** the issued PDF beside each `.tex`. A Word copy that is sent is
  copied from `build/` beside its source on the author's word, named as the issued PDF, and
  committed with it.
