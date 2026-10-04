# BUSINESS.md — draft-section, business mode

The domain for drafting a section of a business, legal or client document: where it lives, the
facts it may state, and the drafting discipline every commitment needs.

## Paths and unit

- **Unit:** a document. **Section:** one clause group, one part of a proposal or letter, or one
  rule area of a policy, typically 300–500 words (`library/docs/reference/section-anatomy.md`
  lists what counts as one).
- **Procedure:** `library/workflows/01-draft-a-section/`.
- **Brief:** `planning/src/units/<unit-slug>.md`, whose settled-positions section is
  `## Obligations and defined terms`. The unit slug is the brief's name, with no number.
- **Draft:** `library/src/<family>/drafts/<unit-slug>/<NN>-<section-slug>.md`, the family being
  one this project selected: `business`, `legal`, `email`, `accounting`, `social-media` or
  `msp-scp` (`library/src/CONTEXT.md` lists them). Step 5 creates the document's own folder under
  the family's `drafts/` when it is missing, never a family folder; the deliverable `.tex` is left
  to `promote-section`.
- **Family skill:** read the family's skill, `<family>-documents`, as well as this file: the
  family's document types, required sections, conventions and checks.
- **Project paths:** the 'Client facts', 'Brand folder', 'Disclaimers' and 'LaTeX skeleton' rows of
  `00-project.md` `## Paths` say where those live; this file names the template defaults.
- **Client facts:** one home per client, by default
  `library/src/business/client-docs/<client-slug>/CONTEXT.md`, under `## Facts`; every other
  family cites it and never copies it, and no family gets a client folder just to hold facts.
- **Guides:** `library/docs/reference/section-anatomy.md`,
  `library/docs/reference/document-anatomy.md`, `library/docs/reference/drafting-with-ai.md` and
  `library/docs/reference/latex-deliverables.md` (how a promoted draft becomes LaTeX).
- **The deliverable's shape:** the LaTeX skeleton (by default `tooling/latex/skeleton.tex`), the
  house skeleton every `.tex` document starts from; its title block, disclaimer, Document Control
  and signature block are filled from data and are never sections.
- **Method:** `standards/method/BUSINESS.md`. **Brand:** the brand folder's voice and the
  disclaimers (by default `standards/brand/brand-voice.md` and `standards/brand/disclaimers.md`).
  **Precedence:** `planning/src/precedence.md`.

## Additions to the steps

- **Step 1 — also settle the five questions.** If the brief does not yet answer them, settle them
  with `grill-with-docs`, one round at a time, each with a recommended answer: the counterparty's
  full legal name; the jurisdiction; the audience; the existing material; the tone. Record the
  answers in the brief, so they are asked once per document, not once per section.
- **Step 2 — also read the commitments.** Read the brief's `## Obligations and defined terms`,
  the client's facts, the brand voice for running copy, and, for an instrument,
  `planning/src/precedence.md` and every document in the family that this section must agree with.
  Read two or three of the author's own pieces in `standards/style/samples/`.
- **Step 4 — also take every fact from its owner.** Every figure, date, name and entity detail
  comes from the author, the `Facts` heading of `.claude/MEMORY.md` (mapped in `00-project.md`
  `## Memory headings`), the client's facts or an agreed document. **Prices, dates and service
  levels come only from the author.** A legal name is checked against the public register, never
  the counterparty's website; a statute is cited with its jurisdiction and date, never a section
  number from memory.
- **Step 6 — also draft to the house shape.** The point first; then the detail that makes it
  checkable; then the limit, stated honestly; then the way forward. Open with a `##` heading if
  the section starts a new part of the document. Use each defined term exactly as the brief
  defines it; choose 'shall', 'may' and 'must' deliberately, and leave no 'will' unbounded; write
  as 'I' or 'we', whichever `00-project.md` `## Brief` gives as the voice person; no em dashes in
  client copy. Never cut an obligation to meet the word target.
- **Step 6 — also write Markdown the skeleton can carry.** Use only what the conversion table in
  `library/docs/reference/latex-deliverables.md` maps (`##` and `###` headings, emphasis, lists,
  tables); numbered clauses are a numbered list, so `promote-section` can set them in the house
  `clause` list. Never write raw LaTeX in a draft.
- **Step 7 — also mark what only the author can supply.** A form field the author must fill stays
  `[AWAITING USER INPUT]`. A commitment the brief's obligations table does not carry gets
  `AUTHOR TO CONFIRM` as new. A disclaimer is quoted verbatim from the disclaimers file
  (`00-project.md` `## Paths`), never paraphrased.
- **Step 8 — also run `grammar`** with `spelling`: single quotation marks, DD/MM/YYYY, the
  currency format in the style sheet, no em dashes, no filler intensifiers.
- **Step 10 — also list the commitments.** Name every commitment the section makes, each traced
  to a row of the brief's obligations table or marked new. `obligation-check` and
  `clause-consistency` run on the whole document at review.

## Domain rules

- **Obligations are never invented** (`.claude/rules/syntek-author/03-authorship.md` Section 7):
  never add, strengthen, soften or reword a commitment, price, date, service level or scope
  boundary on the AI's own initiative.
- **Specificity over superlatives; shorten the writing, never the obligation**
  (`standards/method/BUSINESS.md` Sections 1 and 2).
- **Stated precedence, and defined terms defined once** (Sections 3 and 4).
- **The clarifying questions are the floor** (Section 6), and **every figure, date and commitment
  is traceable** (Section 7).
- **Confidentiality:** a client's facts are cited from their file, never pasted into a handoff, a
  map or another working file.

## Examples

Invented lines from a proposal's scope, each gap left visible:

```markdown
- Two rounds of review, each answered within five working days. <!-- AUTHOR TO CONFIRM: two review rounds, or three? -->
- The fee for this work is [AWAITING USER INPUT]. <!-- VERIFY: the fee, from the author's quotation, before it appears in any draft -->
```

An invented section that opens a new part of an instrument:

```markdown
## Fees and payment

The Client shall pay each invoice within the period stated in the Order. <!-- VERIFY: the payment period in the signed Order -->
```
