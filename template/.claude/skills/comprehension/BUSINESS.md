# BUSINESS.md — comprehension in a business document

A business document has a named reader who must decide or do something, often a busy one who will
read the first page and the last line. This pass reads as that person: can they find what they must
decide, what it costs, what they must do, and what happens if something goes wrong?

## Paths and unit

- **The unit** is a document in one of the families this project selected, under
  `library/src/<family>/` (`business`, `legal`, `email`, `accounting`, `social-media`, `msp-scp`): a
  `.tex` deliverable or Markdown copy such as an email, read as it will render.
- **Family skill:** read the family's skill, `<family>-documents`, as well as this file: the
  family's required sections and conventions.
- **The pass** is step 8 of `library/workflows/05-review-a-document/`.
- **The reader** is the one the unit brief's `audience_note` names, within the audience in
  `00-project.md` `## Brief` (client, staff, board or public).
- **Extra reads:** `library/docs/reference/document-anatomy.md` (the reader's map, and the parts by
  family); `standards/method/BUSINESS.md` rule 5 (lead with the point); the document's definitions
  clause; Section 2 of the brand voice, the registers (`brand-voice.md` in the brand folder
  `00-project.md` `## Paths` names; by default `standards/brand/brand-voice.md`).

## Additions to the steps

- **Step 1 — also:** the brief's reader is often a person who passes the document on (an
  operations lead who forwards a proposal to the person who signs). Read as each in turn; the one
  who decides must be able to decide from the document alone.
- **Step 3 — also:** every defined term can be found from where it is used (the definitions clause
  comes first, or the term is defined at first use); every acronym is spelt out once; every piece of
  the business's own jargon is replaced or explained for a client reader.
- **Step 4 — also, the question map:** list the questions this reader will ask (what do I get, what
  does it cost, when, what must I do, what if it goes wrong, how do I get out) and check each is
  answered and can be found. An unanswered question is blocking; one answered only in a schedule the
  reader is not told about is friction.
- **Step 5 — also:** a long document opens with its reader's map ('How to read this document', then
  a summary holding everything needed to decide, every price included, then the contents); a
  missing map is a finding. The first paragraph says what the document is for and what the reader
  must decide or do.

## Domain rules

- **The register is set by the reader, and an instrument stays formal.** A non-lawyer reading a
  contract is helped by its summary and its reader's map, never by softening its clauses.
- **Never suggest cutting an obligation, a condition, a limit or a date for clarity**
  (`standards/method/BUSINESS.md` rule 2); suggest explaining it.
- **A price the reader must calculate is a finding.** The total and its basis are stated where the
  reader decides.

## Examples

> **Blocking.** The example proposal: the fee appears only in the `investment` section, on page 4;
> the summary says 'see investment'. The person who signs reads the summary. Suggested remedy: the
> fee and the payment terms in the summary.

> **Friction.** Clause 2: '**SLA**' used before it is defined in clause 1.4 and never spelt out.
> Suggested remedy: spell it out at first use, with the defined term in brackets.

> **Question map.** 'How do I get out?' is answered in clause 11, which the summary never mentions.
> Suggested remedy: one line in the summary pointing to it.
