# BUSINESS.md — grammar in a business document

In a business document a few words are not grammar at all but obligations: 'shall', 'may', 'must',
'will', the 'and' or 'or' that ends a list of conditions, and every defined term. A grammar pass
reports around them and never through them. This mode also enforces the house rule that client
copy carries no em dash.

## Paths and unit

- **The unit** is a document in one of the families this project selected, under
  `library/src/<family>/` (`business`, `legal`, `email`, `accounting`, `social-media`, `msp-scp`): a
  `.tex` deliverable or Markdown copy such as an email. In a `.tex` file only the text is checked,
  never macros, labels or `\ref` keys.
- **Family skill:** read the family's skill, `<family>-documents`, as well as this file: the
  family's required sections and conventions.
- **The pass** is step 11 of `library/workflows/05-review-a-document/`, before `spelling`.
- **Extra reads:** the brand voice, in the brand folder `00-project.md` `## Paths` names (by
  default `standards/brand/brand-voice.md`: the two registers and the marks of running copy);
  `standards/method/BUSINESS.md` rules 2, 4 and 7; the house person ('I' or 'we'), the voice
  person in `00-project.md` `## Brief`, and `standards/style/voice-notes.md`.
- **Where corrections go:** accepted corrections are applied in the `.tex` or Markdown file
  directly and listed in the hand-back (`library/workflows/05-review-a-document/` step 11). A
  correction inside a promoted section is also made in its draft and logged in its ledger entry,
  and `make section-check` is re-run (that workflow's 'Applying agreed fixes'), so a later
  re-promotion cannot undo it. A change of substance reopens its section through `library/workflows/02-adapt-a-draft/` or
  `library/workflows/03-improve-your-draft/`, then `library/workflows/04-promote-a-section/`.

## Additions to the steps

- **Step 2 — also:** scope the check to the document in hand, `make lint SCOPE=<the document's
  path>`, never the whole library: an unscoped run reports every older document too, and is not
  this document's gate. It reports every em dash in client-facing copy; there must be none before
  issue (gate V6.2 in `standards/verification/BUSINESS.md`). For each, offer the mark that
  keeps the sentence's meaning: a full stop, a comma, a colon or brackets.
- **Step 3 — also:** 'shall', 'may', 'must' and 'will' are never changed by a grammar correction;
  a doubt about one is reported and handed to `obligation-check`. The 'and' or 'or' that joins a
  list of conditions or obligations is never changed; a doubt is reported to the author.
- **Step 3 — also:** a defined term keeps its exact form; a correction never replaces it with a
  pronoun or a near-synonym ('it', 'they', 'the company' for 'the **Client**'). A word that is part
  of a defined term is not filler.
- **Step 3 — also:** one document holds one house person; a mix of 'I' and 'we' is reported.
- **Step 4 — also:** numbered clause lists are punctuated as the house preamble lays them out;
  amounts, dates and times follow the style sheet and `00-project.md` `## Brief` (the currency
  and its format, DD/MM/YYYY, the 24-hour clock).
- **Step 5 — also:** the formal register of an instrument or a policy ('the Client shall…', long
  conditional sentences) is the register working as designed; it is checked for grammar, not
  softened.

## Domain rules

- **No em dash in client-facing copy.** Internal notes and `%` comment lines are exempt.
- **Grammar never changes an obligation.** Modal verbs, list conjunctions, numbers and defined terms
  are reported, never corrected in passing.
- **The register is set by the reader:** formal for an instrument, plain and direct for a proposal
  or a letter (the brand voice's Section 2).

## Examples

> **Em dash.** `scope` section, line 3: 'The review covers the handbook — not the contract.' →
> 'The review covers the handbook, not the contract.' One of three, listed.

> **Reported, not corrected.** Clause 5.2: 'The Client shall provide access and the Provider will
> attend' mixes 'shall' and 'will'. Handed to `obligation-check`; no change made.

> **Defined term.** Clause 3.1: 'If it fails to pay…' where 'it' could be either party. Offered:
> 'If the **Client** fails to pay…'; applied once accepted.
