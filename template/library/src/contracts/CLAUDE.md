@./CONTEXT.md

# CLAUDE.md — library/src/contracts/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/src/CONTEXT.md` → `library/src/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold the instruments that bind the business and its counterparties, and the one authoritative
record of each client's facts.

## How to work here

- **Routing:** the loop in `library/workflows/`, with `clause-consistency` and `obligation-check`
  at fact check; `adapt-section` turns a template into a client instrument. Plain-English tone work
  never touches an instrument's clauses: the formal register stays.
- **Model:** **Opus** throughout. Nothing in an instrument is mechanical except copying files.
- **Concrete steps:**
  1. Verify the counterparty against the public register for the jurisdiction (in England and
     Wales, Companies House or the Charity Commission), never its own website, and record the
     result in the client folder's `CONTEXT.md` with the date checked.
  2. Start from the matching template, or from the house skeleton with definitions first.
  3. Draft clause groups as sections; promote; review with every gate; execute only on the
     author's word.
- **Definition of done:** every defined term is defined once and used as defined; every
  cross-reference resolves; precedence is stated; every obligation is intended; governing law is
  the last clause; no `\dnote` survives; the author has approved it.

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
- **Precedence is stated, never implied,** in the instrument and in `planning/src/precedence.md`.

## Output & naming

- **Hand-written:** instruments and templates (`.tex`), client folder pairs, section drafts.
- **Received, never edited:** signed copies (`-signed.pdf`).
- **Generated (never hand-edit):** the issued PDF and any Word copy beside each `.tex`.
