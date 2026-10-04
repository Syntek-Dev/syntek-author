# THEOLOGY.md — adapt-section, theology mode

The domain for revising a section of a work of Christian theology from the author's notes, and
for turning the author's earlier writing into a chapter's accessible prose.

## Paths and unit

- **Unit:** a chapter. **Section:** one step of the argument.
- **Procedure:** `manuscript/workflows/02-adapt-a-draft/`.
- **Draft:** `manuscript/src/NN-kebab-title/drafts/<NN>-<section-slug>.md`; its brief is
  `planning/src/units/NN-kebab-title.md` and its argument map
  `planning/src/arguments/NN-kebab-title.md`.
- **Kinds of source this project adapts (step 7):** the author's own earlier academic or teaching
  writing (a dissertation, lecture notes, a sermon, an article), quarried into a chapter's main
  text for the reader the book is written for.
- **Guides:** `manuscript/docs/reference/drafting-with-ai.md`,
  `manuscript/docs/reference/the-status-ladders.md` and
  `manuscript/docs/reference/main-text-and-footnotes.md`.
- **Method:** `standards/method/THEOLOGY.md`.

## Additions to the steps

- **Step 3 — also put back any note that moves the argument.** A note that would concede an
  objection the brief has not conceded, leave one standing, or change a claim's category is a
  decision about the argument: put it to the author as a question, and if they agree, it changes
  the brief and the argument map first.
- **Step 5 — also keep each claim in its category.** A revised sentence keeps the category it had
  unless the note is about the category, and it still signals that category in the prose. Update
  the matching lines of the trailing `CLAIM CATEGORIES` block for every sentence changed, and
  never touch a Scripture quotation or reference unless the note is about it.
- **Step 6 — also the holding line is the original.** Leave the original line in the draft until
  the author chooses between the alternatives.
- **Step 7 — also move depth to the footnotes, never out of the argument.** When adapting the
  author's academic writing, keep the argument in the main text and move the apparatus
  (scholarly debate, original-language detail, bibliography) to footnotes, as
  `manuscript/docs/reference/main-text-and-footnotes.md` sets out. A contested reading stays named
  in the body. Every Scripture reference and original-language claim brought across from the
  source is checked again (`fact-check`), because the source's own checking is not this book's.
- **Step 8 — also run the categories.** Re-read the trailing block against the revised prose: a
  sentence whose category drifted in the revision is reported for `category-check`.

## Domain rules

- **The six categories are never silently collapsed** (`standards/method/THEOLOGY.md` Sections 1
  and 2), not even to make a note's change read better.
- **Concessions stay ahead of their responses** (Section 5), and **an objection left standing stays
  standing** unless the author says otherwise (Section 7).
- **Scripture and original languages are checked, never recalled** (Section 9), including in text
  quarried from the author's own earlier work.
- **The reader named in `00-project.md` `## Brief` sets the register** of the main text; the
  footnotes may carry the academic register, and the two are never mixed in one sentence.

## Examples

An invented note and its alternatives (step 6), with the original left in place:

```text
Note 3: 'The last sentence claims more than the passage shows.'
  1. Narrow it: 'On this reading, the passage leaves the question open.' (interpretive inference)
  2. Own it: 'I take the passage to leave the question open.' (the author's conclusion)
  3. Cut it, and let the next section draw the conclusion.
```

An invented internal note naming a quarried source (step 7):

```markdown
<!-- INTERNAL NOTE: adapted from the author's 2019 lecture notes, part 2, pages 4–6 (path and date
     as the author gave them); the Greek word study moved to footnote 3. -->
```
