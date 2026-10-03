# THEOLOGY.md — promote-section, theology mode

The domain for promoting a section of a work of Christian theology into its chapter: where the
chapter file and its markers live, what is draft-only, and what is checked against the plan.

## Paths and unit

- **Unit:** a chapter. **Procedure:** `manuscript/workflows/04-promote-a-section/`.
- **Draft:** `manuscript/src/NN-kebab-title/drafts/<NN>-<section-slug>.md`.
- **Unit file:** `manuscript/src/NN-kebab-title/NN-kebab-title.md`, holding an H1 with the brief's
  title and one `<!-- section: <slug> -->` marker per planned section, in plan order, each on its
  own line with a blank line between. No frontmatter: the chapter's metadata lives in its brief.
- **Brief:** `planning/src/units/NN-kebab-title.md` (its `## Claims and categories`), and the
  argument map `planning/src/arguments/NN-kebab-title.md`.
- **Review procedure (step 9):** `manuscript/workflows/05-review-a-chapter/`.
- **Guides:** `manuscript/docs/reference/section-anatomy.md` and
  `manuscript/docs/reference/the-status-ladders.md`.

## Additions to the steps

- **Step 3 — also create the chapter file when it is missing:** the H1, then the markers in the
  brief's order, and nothing else. `promote-section` is the only skill that creates it.
- **Step 4 — also strip the draft-only blocks.** The trailing `<!-- CLAIM CATEGORIES … -->` block
  is draft-only: it never enters the chapter. The internal note stays in the draft. Before
  stripping the block, compare its categories with the brief's `## Claims and categories`; a claim
  whose category differs, or a claim the brief lacks, is reported in the hand-back and never
  silently carried into the brief.
- **Step 5 — also insert directly under the marker.** The section's text runs from its
  `<!-- section: <slug> -->` line to the next marker; the marker itself is never edited.
- **Step 6 — also record the chapter text.** `## Author final` holds the text exactly as inserted
  into the chapter, without the categories block, so the change ratio compares prose with prose.
- **Step 8 — also read for the argument's seams.** Read the section with the one before and after
  it: does the argument step from one to the next, and does each concession still sit ahead of its
  response once the sections are joined? Report what you find for `argument-audit` at review.

## Domain rules

- **The chapter holds only approved prose.** No claim label, no working comment and no unchecked
  Scripture reaches it (`standards/method/THEOLOGY.md` Section 9).
- **A category settled in the draft is not settled in the plan** until the author agrees; drift
  between the two is reported, not reconciled by this skill.
- **Promotion never moves the chapter's status**; the steelman, category and argument checks run
  at structural review (`standards/verification/verification.md` and its mode file).

## Examples

An invented chapter file after its first section is promoted:

```markdown
# A Day Kept Empty

<!-- section: opening -->

The shop on the corner had closed on Sundays for forty years.
Nobody in the street could remember why.

<!-- section: the-objection -->

<!-- section: the-turn -->
```

An invented hand-back line for category drift:

```text
Category drift: 'On this reading, the commandment ties rest to creation' is labelled interpretive
inference in the draft, but the brief's C5 lists it as the author's conclusion. Which is meant?
```
