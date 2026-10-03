# THEOLOGY.md — improve-section, theology mode

The domain for proposing improvements to a section of a work of Christian theology that the
author wrote: what a structural pass checks, which hedges are doing work, and what stays out of
the diff.

## Paths and unit

- **Unit:** a chapter. **Section:** one step of the argument.
- **Procedure:** `manuscript/workflows/03-improve-your-draft/`.
- **Draft:** `manuscript/src/NN-kebab-title/drafts/<NN>-<section-slug>.md`; its brief is
  `planning/src/units/NN-kebab-title.md` and its argument map
  `planning/src/arguments/NN-kebab-title.md`.
- **Registers:** the main text for every reader, the footnotes for the scholarly apparatus
  (`manuscript/docs/reference/main-text-and-footnotes.md`).
- **Method:** `standards/method/THEOLOGY.md`.

## Additions to the steps

- **Step 3 — also read the argument map** for the claims this section makes, by ID, so a
  structural proposal never reorders the argument away from its map.
- **Step 4 — also check the shape of the argument.** At `rework`, check that each claim's category
  is signalled in the prose; that a concession sits ahead of the response to it; that a contested
  reading is named in the body, not only in a footnote; and that no sentence moves from one
  passage to systematic theology without saying so. Report a problem with the argument itself as
  a question for `argument-audit`, never as a proposal. At `edit`, these are notes, not proposals.
- **Step 5 — also keep the category signals.** 'On this reading', 'the text says', 'I hold' and
  their kin mark which kind of claim a sentence makes; they are not padding, and cutting one
  collapses a category. Keep the main text and the footnotes in their own registers: a proposal
  may move apparatus into a footnote, never argument out of the main text.
- **Step 7 — also keep out of the lane:** a Scripture reference or quotation, the translation
  named, an original-language gloss, a claim's category, which objection is conceded or left
  standing, and the author's stated conclusion. Each concern about these is a question.

## Domain rules

- **Never collapse a category to tighten a sentence** (`standards/method/THEOLOGY.md` Sections 1
  and 2).
- **Concede before rebutting** (Section 5): a reordering that puts the response ahead of the
  concession is not an improvement, whatever it does for the rhythm.
- **The author's conclusion stays in the first person** (Section 1, the theological-conclusion
  category): never soften it into an impersonal consensus, and never hedge a declared stake
  (Section 8).
- **Scripture wording is checked, never 'improved'** (Section 9): a quotation is corrected only
  against its named translation, and that is a `fact-check` matter, not a line proposal.

## Examples

An invented proposal and an invented out-of-lane question, as they appear in the diff:

```text
4. Paragraph 2, line 3 · edit
   Before: 'Which is to say that the passage, read carefully and in its context, may suggest…'
   After:  'Read in its context, the passage suggests…'
   Reason: the hedge 'may' is doing no work here; 'read in its context' carries the caution.

Questions (outside the lane):
- Line 7 quotes the passage; the wording differs from the default translation. Check it, or is
  another translation intended?
```
