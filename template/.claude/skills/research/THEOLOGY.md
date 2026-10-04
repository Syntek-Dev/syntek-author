# THEOLOGY.md — research, theology mode

Where a theology book's research goes, and what counts as a primary source for it.

## Paths and unit

- **Contested readings:** `research/src/contested-readings/<kebab-passage>.md`, made through
  `research/workflows/03-map-a-contested-reading/`, for a passage serious Christians read more
  than one way.
- **Question-led notes:** `research/src/notes/`; **reading notes:** `research/src/sources/`;
  **checked claims:** `research/src/evidence/`, through `fact-check`.
- **Serves:** chapter slugs from `planning/src/units/`, and the argument maps in
  `planning/src/arguments/` that cite the note.

## Additions to the steps

- **Step 2 — also route a disputed passage** to `research/workflows/03-map-a-contested-reading/`
  rather than a note: a reading is mapped, not concluded.
- **Step 3 — also name the translation** a scriptural question is asked in (the project's default
  is named in `00-project.md` `## Brief`), and whether the question is about the text, an
  original-language word, the history of interpretation or a church's teaching: each has its own
  primary source.
- **Step 4 — also, the primary sources:** the biblical text in its original languages from a
  standard critical edition, and the translation used; standard lexicons and grammars for a
  word's meaning; a church's confessions, catechisms and council texts from their official
  editions; a historical theologian's own writings, not a summary of them; for an empirical
  claim, the study or the official statistics. Commentaries are scouts that point at these.
- **Step 6 — also,** keep each claim in its category: a note that reports what a text says, what
  an interpreter inferred and what a tradition concluded keeps the three apart.

## Domain rules

- **Scripture is quoted from the text, never recalled**, and an original-language point is never
  taught from memory (`standards/method/THEOLOGY.md` Section 9).
- **Each reading is stated so its holders would recognise it**, from their own writings, and
  named; a note that represents a tradition from its critics has used a scout as the source.
- **Correct against the work's interest.** Where the evidence tells against the argument, the note
  says so first.
- **Where the project keeps the citation database,** each source is keyed in the same pass as its
  note, through the add-reference skill; otherwise the note's bibliographic details are complete
  enough for a stranger to find the work.

## Examples

```markdown
---
question: "How did the early church read the fourth commandment: as binding on Christians, or not?"
checked: DD/MM/YYYY
feeds: [03-sabbath-rest]
---

## Verdict
<two or three sentences, each claim below cited to a primary text>
## Claims
- <claim> — <primary text, edition, section>; checked DD/MM/YYYY
## Conflicts
- <two readings of one source, both stated, and which governs and why>
```
