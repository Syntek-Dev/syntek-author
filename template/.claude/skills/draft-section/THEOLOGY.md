# THEOLOGY.md — draft-section, theology mode

The domain for drafting a section of a work of Christian theology: where it lives, what to read
beside the brief, and how a section signals the kind of claim each sentence makes.

## Paths and unit

- **Unit:** a chapter. **Section:** one step of the argument, typically 300–500 words.
- **Procedure:** `manuscript/workflows/01-draft-a-section/`.
- **Brief:** `planning/src/units/NN-kebab-title.md`, whose settled-positions section is
  `## Claims and categories`. **Argument map:** `planning/src/arguments/NN-kebab-title.md`, holding
  the same claims under the same IDs.
- **Draft:** `manuscript/src/NN-kebab-title/drafts/<NN>-<section-slug>.md`. The unit slug in the
  draft and in the ledger is the chapter folder's name, number included (`03-kebab-title`).
- **A new chapter folder (step 5)** gets its `CONTEXT.md` and `CLAUDE.md` as
  `manuscript/src/CLAUDE.md` describes, and `drafts/README.md` in the four-line pattern every
  chapter uses. The chapter file itself is left to `promote-section`.
- **Guides:** `manuscript/docs/reference/section-anatomy.md`,
  `manuscript/docs/reference/drafting-with-ai.md` and
  `manuscript/docs/reference/main-text-and-footnotes.md` (the two registers).
- **Method:** `standards/method/THEOLOGY.md`. **Contested readings:**
  `research/src/contested-readings/`.

## Additions to the steps

- **Step 2 — also read the argument.** Read the chapter's argument map, the brief's
  `## Claims and categories`, the contested-reading entries the brief draws on, and
  `manuscript/docs/reference/main-text-and-footnotes.md`. Note which claims this section makes,
  by ID, and which objection, if any, it concedes or answers.
- **Step 3 — also stop on an unmapped move.** If the section reads a passage with more than one
  live reading and no entry maps it, stop for `research/workflows/03-map-a-contested-reading/`.
  If it makes a claim the argument map does not hold, stop for
  `planning/workflows/02-map-the-argument/`.
- **Step 4 — also check Scripture and the original languages.** Check every reference to the
  verse and every quotation word for word against the named translation; the default
  translation's citation key is in `standards/style/style-sheet.md`. A claim about a Hebrew,
  Aramaic or Greek word cites a lexicon or grammar. Until checked, each carries `VERIFY`.
- **Step 6 — also make each claim's category audible.** Signal the category in the prose ('the
  passage repeats…', 'on this reading…', 'I hold…'). State an objection so that those who hold
  it would recognise it, and place any concession ahead of the response to it. Name a contested
  reading in the main text, never only in a footnote; keep the apparatus in the footnotes and the
  argument in the main text.
- **Step 6 — also end with the categories block.** After the prose, add a trailing
  `CLAIM CATEGORIES` HTML comment (format under Examples): one numbered line per substantive
  sentence, quoting its opening words and naming its category. It is draft-only:
  `promote-section` strips it, and it is never cited as part of the text.
- **Step 6 — also declare the author's stake where it first bears.** Where `.claude/MEMORY.md`
  `Decisions` records the author's stake (the bias disclosure) and this section is where the
  argument first depends on it, declare it once, plainly (`standards/method/THEOLOGY.md`
  Section 8); where that is unclear, flag `AUTHOR TO CONFIRM` instead of guessing.
- **Step 7 — also flag the author's calls.** `AUTHOR TO CONFIRM` wherever the section concedes,
  answers or leaves standing an objection the brief has not settled; which objection stands is
  the author's decision (`standards/method/THEOLOGY.md` Section 7).
- **Step 10 — also report the categories.** Name any sentence whose category was hard to call and
  any claim the argument map lacks. `category-check` and `argument-audit` are the later checks;
  this report tells them where to look.

## Domain rules

- **The six categories are never silently collapsed** (`standards/method/THEOLOGY.md` Sections 1
  and 2): an inference is never written as the text, a conclusion as history, or an application
  as exegesis, and a move from one passage to systematic theology is said aloud.
- **Scripture and the original languages are checked, never recalled** (Section 9). A verse
  quoted from memory is a fabrication even when it happens to be right.
- **Concede before rebutting, and steelman or do not bother** (Sections 5 and 6). **An objection
  may be left standing** (Section 7), and only the author designates it.
- **The author's conclusion is owned in the first person** (Section 1, the theological-conclusion
  category): 'I hold…', never passed off as a consensus. **Bias is declared, not neutralised**
  (Section 8): a stake is stated plainly, neither hedged nor performed.
- **Every tradition's reading is stated so that its holders would recognise it**, and named in the
  body (Section 4).

## Examples

An invented trailing block, as it ends a draft:

```markdown
<!-- CLAIM CATEGORIES
1. 'The passage repeats the same verb three times' — textual observation.
2. 'On this reading, the repetition marks a change of speaker' — interpretive inference.
3. 'Writers in more than one tradition have read it otherwise' — historical interpretation (placeholder; see the VERIFY flag).
4. 'I hold that rest is commended, not commanded' — the author's theological conclusion.
-->
```

An invented quotation still waiting for its check:

```markdown
The passage reads: '[quotation to be supplied from the default translation]'.
<!-- VERIFY: the reference, the translation and the exact wording before anything is quoted. -->
```
