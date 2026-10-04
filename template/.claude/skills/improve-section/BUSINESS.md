# BUSINESS.md — improve-section, business mode

The domain for proposing improvements to a section of a business document that the author wrote:
the house shape, the register, and the commitments that never enter the diff.

## Paths and unit

- **Unit:** a document. **Section:** one clause group, one part of a proposal or letter, or one
  rule area of a policy.
- **Procedure:** `library/workflows/03-improve-your-draft/`.
- **Draft:** `library/src/<family>/drafts/<unit-slug>/<NN>-<section-slug>.md`, in one of the
  families this project selected (`business`, `legal`, `email`, `accounting`, `social-media`,
  `msp-scp`); its brief is `planning/src/units/<unit-slug>.md`.
- **Family skill:** read the family's skill, `<family>-documents`, as well as this file: the
  family's document types, required sections, conventions and checks.
- **Project paths:** the 'Brand folder' and 'Disclaimers' rows of `00-project.md` `## Paths` say
  where those live; this file names the template defaults.
- **Registers:** formal for an instrument or a policy; the brand voice (by default
  `standards/brand/brand-voice.md`) for running copy such as proposals, letters, emails and social
  media posts; terse and action-first for microcopy.
- **Guides:** `library/docs/reference/section-anatomy.md` and
  `library/docs/reference/document-anatomy.md`. **Method:** `standards/method/BUSINESS.md`.

## Additions to the steps

- **Step 3 — also read the commitments:** the brief's `## Obligations and defined terms`, and for
  an instrument `planning/src/precedence.md`.
- **Step 4 — also propose moves at `edit`.** At `edit`, propose moves within the section; at
  `rework`, a new order. Either way, check the house shape: the point first, then the detail that
  makes it checkable, then the limit, then the way forward; nothing that belongs in another
  section, and nothing missing that the brief promised. Every point and every obligation survives
  any reordering.
- **Step 5 — also run a register pass.** Check the register against the document's kind, and the
  voice person in `00-project.md` `## Brief` ('I' or 'we') throughout. Propose only where the text
  leaves its register. No em dash in client copy; no filler intensifier.
- **Step 7 — also keep out of the lane:** a price, a scope boundary, a defined term, a service
  level, a deadline, 'shall', 'may' or 'must', and a disclaimer's wording. Each concern about
  these is a question; `obligation-check` and `clause-consistency` own them at review.

## Domain rules

- **Shorten the writing, never the obligation** (`standards/method/BUSINESS.md` Section 2): a
  tighter sentence that drops a condition has changed the contract.
- **Defined terms are used exactly as defined** (Section 4), capitalised every time and bolded only
  where defined; a synonym for a defined term is not a style improvement.
- **Specificity over superlatives** (Section 1): a proposal may replace a superlative with a
  checkable detail only when the author supplies the detail.
- **Disclaimers are verbatim** from the disclaimers file (by default
  `standards/brand/disclaimers.md`); they are never edited for style.

## Examples

An invented proposal and an invented out-of-lane question:

```text
3. Paragraph 2, line 1 · edit
   Before: 'We are absolutely committed to providing a truly excellent service.'
   After:  [the sentence removed]
   Reason: specificity over superlatives; a replacement detail is the author's to supply.

Questions (outside the lane):
- Paragraph 2, line 1: do you want to state a response time here? If so, which?
- Line 5 says the fee 'includes all expenses'. Is that a commitment you mean to make?
```
