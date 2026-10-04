# BUSINESS.md — spelling in a business document

In a business document some spellings carry legal weight: a counterparty's registered name, a
defined term, a trading or product name in its exact casing. Those are checked against their
sources, not against a dictionary, and a slip in one is a finding for the skill that owns it.

## Paths and unit

- **The unit** is a document in one of the families this project selected, under
  `library/src/<family>/` (`business`, `legal`, `email`, `accounting`, `social-media`, `msp-scp`): a
  `.tex` deliverable or Markdown copy such as an email. In a `.tex` file only the text is checked;
  macros, labels, `\ref` keys, `\fillme` and `[AWAITING USER INPUT]` fields are left alone (they are
  issue-readiness items).
- **Family skill:** read the family's skill, `<family>-documents`, as well as this file: the
  family's required sections and conventions.
- **The pass** is step 11 of `library/workflows/05-review-a-document/`, after `grammar`.
- **The project's own words:** the defined terms in the document's definitions clause, exactly as
  bolded there; the terms shared across the document family in `standards/style/terminology.md`;
  the trading name exactly as `00-project.md` `## Brief` gives it and the disclaimers print it
  (by default `standards/brand/disclaimers.md`), and product and service names in their recorded
  casing in `standards/style/terminology.md` (the brand voice's Section 5); each counterparty's
  legal name exactly as recorded under `## Facts` in its client folder, at the client facts path
  in `00-project.md` `## Paths` (by default
  `library/src/business/client-docs/<client-slug>/CONTEXT.md`).
- **Where corrections go:** accepted corrections are applied in the `.tex` or Markdown file
  directly and listed in the hand-back (`library/workflows/05-review-a-document/` step 11). A
  correction inside a promoted section is also made in its draft and recorded in its ledger
  entry, and `make section-check` is re-run (that workflow's 'Applying agreed fixes'), so a later
  re-promotion cannot undo it. In a section draft, it goes in the draft, recorded in its ledger
  entry (step 7).

## Additions to the steps

- **Step 2 — also add to the known words:** every defined term, every family term, the trading and
  product names, and each counterparty's registered name, each in its exact form and casing.
- **Step 3 — also scope the mechanical pass** to the document in hand:
  `make lint SCOPE=<the document's path>`, never the whole library, whose older documents would
  bury this one's findings.
- **Step 3 — also:** a counterparty's name spelt differently from its registered name (in the
  parties clause, the signature block, the cover or the body) is reported as blocking and handed to
  `fact-check`, because the registered form is a checked fact, not a house choice.
- **Step 3 — also:** a defined term written in another form ('the services' for 'the **Services**')
  is not a spelling slip: report it and hand it to `clause-consistency`.
- **Step 3 — also:** amounts, dates and times are reported only where they are written two ways
  (the style sheet and `00-project.md` `## Brief` set the currency and its format); whether a
  figure is right is `fact-check`'s.
- **Step 5 — also:** a client's or supplier's own spelling of its name or product (a US spelling in a
  registered name, an unusual capital) is kept exactly.

## Domain rules

- **The register beats the dictionary for a name;** the definitions clause beats it for a term.
- **Never change a figure, a date, a price or a modal verb while correcting spelling.**
- **Licence and license, practice and practise** follow en_GB (noun with c, verb with s) in the
  author's prose; a quoted statute or a counterparty's own document keeps its form.
- **Client copy is checked as it will be read.** A heading, a table cell and a footnote are prose;
  so is the subject line of an email.

## Examples

> **Blocking.** 'Example Client Ltd' in the signature block; 'Example Client Limited' in the
> parties clause and in the client's `## Facts`. Handed to `fact-check`; the registered form is
> offered for both places.

> **'license' (noun) → 'licence'.** Four places in the services schedule, listed. The verb 'to
> license' in clause 7.2 is correct and not reported.

> **Handed to `clause-consistency`.** 'the services' in lower case twice in clause 4, where the
> defined term is '**Services**'.
