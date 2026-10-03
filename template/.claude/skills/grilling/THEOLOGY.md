# THEOLOGY.md — grilling, theology mode

The domain for grilling a work of Christian non-fiction: its surfaces, where the answers already
live, and the rule that a conclusion is never grilled without its category.

## Paths and unit

- **Unit:** a chapter, `manuscript/src/NN-kebab-title/`; its brief is
  `planning/src/units/NN-kebab-title.md`, whose settled-positions slot is
  `## Claims and categories`; its argument map is `planning/src/arguments/NN-kebab-title.md`.
- **Lookup order (step 1):** `.claude/MEMORY.md` → the brief, the argument map and
  `planning/src/outline.md` → `research/src/contested-readings/` (has this passage been mapped?)
  → `research/src/evidence/` and `research/src/notes/` → `research/src/sources/` → the citation
  database, where the project keeps one (what is already cited) → `standards/method/THEOLOGY.md`
  and `standards/risk/THEOLOGY.md`.
- **Procedures that open with a grilling pass:** `planning/workflows/02-map-the-argument/` and
  `research/workflows/03-map-a-contested-reading/`, besides the shared planning procedures.

## Additions to the steps

- **Step 1 — also place every conclusion in its category before grilling it.** For each position
  the unit will take, name which of the six claim categories it is (Biblical text, textual
  observation, interpretive inference, historical interpretation, the author's theological
  conclusion, pastoral application; `standards/method/THEOLOGY.md` Section 1). A question that
  turns on a silent collapse (an inference presented as the text) opens the round.
- **Step 1 — also set aside every question about the text itself.** What a verse says, what a
  Greek or Hebrew word means, what a council decided: these are empirical, and go to `fact-check`
  or `research` (Section 9 of the same standard). Never settle one from either party's memory.
- **Step 2 — also state every contested option so its holders would recognise it.** An option
  that names a reading the author disagrees with is written at full strength, not as a straw man.
- **Step 3 — also ask what changes if the other reading is right.** For each contested reading
  adopted, record what the argument loses if it falls; that is the concession the unit owes.
- **Step 4 — also confirm the standing commitments** in the summary: the objection the book
  leaves standing, if this unit touches it, and whether the bias disclosure needs restating here.

## Domain rules

| Surface | The decisions it turns on |
|---|---|
| A unit's argument | the precise question (split it if compound); each conclusion's category; the concession, stated at full strength and placed before the response; the objection the unit must survive; what it deliberately leaves unsettled |
| A contested reading | which readings are live, who holds them, what each does to the argument, which the book adopts and why, what changes if another is right |
| Evidence strategy | what claim the unit needs, what would count as its primary source, the basis a figure must carry, and what the book does if the evidence comes back against it |
| First-person material | what a disclosure must state, how much of the author's own practice belongs on the page, what stays confidential |
| The pitch | where a proposal is in hand: the hook, the reader, the difference from comparable books, what it must not over-promise |

- **Sycophancy costs more here than anywhere.** The book's claim is that it argues in good faith;
  a grilling session that flatters the author's preferred reading is the first place that claim
  fails. Recommend honestly, then record the author's decision.
- **Bias is declared, not neutralised** (`standards/method/THEOLOGY.md` Section 8): a
  recommendation may name the author's tradition as a reason, openly.
- **At least one objection may be left standing** (Section 7). Grilling does not exist to answer
  every objection; it exists to decide which ones the book answers.
- **Variant anti-pattern:** grilling a conclusion without its category. If the question is 'what
  does this passage require of a church?', the first move is to settle whether the answer is
  interpretive inference, the author's conclusion or pastoral application.

## Examples

```text
**Settled — Chapter 3's question:** 'Is rest commanded or commended?' (planning/src/units/03-sabbath-rest.md:18)
**Settled — Translation:** the default key in the style sheet (standards/style/style-sheet.md:22)

**Q1 — The category of the chapter's main conclusion**

1. **Interpretive inference** — from the text of the commandment; strongest claim, narrowest reach
2. **The author's theological conclusion** — across the canon; honest about the step it takes
3. **Pastoral application** — what churches might do; leaves the doctrine to others

**Recommendation: 2** — the argument draws on more than one passage, and naming the step keeps
category-check from finding a silent collapse later.
```

Set aside, not asked: 'What does the Hebrew verb in the commandment mean?' goes to `fact-check`,
and Q2 (which reading of the verb the chapter adopts) waits for its answer.
