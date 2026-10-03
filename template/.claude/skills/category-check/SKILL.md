---
name: category-check
description: >-
  Label every substantive sentence of a theology draft, chapter or map with one of the six claim
  categories in standards/method/THEOLOGY.md (Biblical text, textual observation, interpretive
  inference, historical interpretation, the author's theological conclusion, pastoral
  application), and flag silent collapses (inference presented as text, conclusion as history,
  application as exegesis) and unsignalled moves from one passage to systematic theology. Use at
  structural review (gate V4.2), when labelling the claims on an argument map, when checking a
  contested-reading map keeps reading apart from text, or when the author asks 'which kind of
  claim is this?', 'am I saying the text says more than it does?', 'check the categories in
  chapter 2', 'am I overclaiming here?' or 'is this exegesis or application?'. Reports, and never
  rewrites. Not whether the argument's support holds (`argument-audit`); not whether a quotation
  or fact is accurate (`fact-check`); not how other traditions read the passage
  (`tradition-check`).
---

# Skill: Category check (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

Readers grant different authority to what a passage says, what it suggests, what a tradition has
made of it, what the author concludes and what a church might do. This skill keeps those apart:
it gives every substantive sentence exactly one of the six categories, checks that the prose
signals which one it is making, and reports every place where one category borrows another's
authority without saying so. It **labels and reports**; the author decides every change.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`.
These are the procedure of record — do not restate them at length here.

- `manuscript/workflows/05-review-a-chapter/` — the structural stage, where this skill is gate
  V4.2 (`standards/verification/THEOLOGY.md`).
- `planning/workflows/02-map-the-argument/` — steps 3 and 4: split compound claims and give each
  claim its category.
- `research/workflows/03-map-a-contested-reading/` — steps 6, 8 and 10: what each reading does
  to the argument, the passage read whole, and the recommended reading labelled as interpretation.
- `manuscript/workflows/10-steelman-the-objections/` — step 7: answers kept in the right
  category under pressure.
- `standards/method/THEOLOGY.md` — rules 1 and 2 (the categories and the collapses) and rule 9
  (Scripture and original languages): the standard this skill applies.
- `manuscript/docs/reference/main-text-and-footnotes.md` — a move between categories is signalled
  in the body, never only in a footnote.

## How to check the categories

1. **Fix the scope and the use.** Agree with <%AUTHOR_FIRST_NAME%> what is being checked: one
   section draft, a promoted chapter (gate V4.2), the claims on an argument map, a contested-
   reading map, or the answers to objections during the steelman audit. Read
   `standards/method/THEOLOGY.md` rules 1, 2 and 9, the chapter brief's `## Claims and
   categories`, and the argument map in `planning/src/arguments/`. *Complete when:* the scope and
   use are stated and the labels already given (in the brief, the map, or a draft's trailing
   `CLAIM CATEGORIES` comment block) are in hand to compare against.

2. **Find the substantive sentences.** Read the scope whole once. A sentence is substantive when a
   reader could agree or disagree with it; a transition, a question or a signpost is not. A
   sentence that makes two claims is split into two, as `planning/workflows/02-map-the-argument/`
   step 3 does for the map. *Complete when:* every substantive sentence is listed by location and
   opening words, compound sentences split.

3. **Give each one exactly one category.** Label by what the sentence does, not by how it sounds:
   'the text shows' introducing an inference is an inference. Where a draft's trailing block, the
   brief or the map already labels the sentence, compare; a disagreement is a finding, and the
   reason is stated. *Complete when:* every listed sentence carries one category, and every
   disagreement with an existing label is recorded.

4. **Check the signal.** For each sentence, check the prose tells the reader which category it is
   in, as the table in method rule 1 sets: the reference and the translation for the text; an
   observation anyone can check; 'this suggests' or its equivalent for an inference; the tradition
   or writer named and cited for a historical interpretation; the author's own voice for a
   conclusion; the reader addressed for an application. A correctly categorised sentence with no
   signal is still a finding. *Complete when:* every sentence is marked signalled or unsignalled.

5. **Find the silent collapses.** Flag each of the four in method rule 2: inference presented as
   text; conclusion presented as history ('the Church has always held'); application presented as
   exegesis; and an unsignalled move from one passage to systematic theology, where a conclusion
   drawn from one text is stated as though the whole canon had been weighed. When checking answers
   to objections, also flag an answer given in the wrong category: an exegetical objection met
   with application, or a reading defended as the text's plain sense. *Complete when:* every
   collapse is listed with the two categories involved and the words that carry it.

6. **Check that the text claims are checkable.** Every Biblical-text sentence names its reference
   and translation and is quoted, not paraphrased as if quoted; every claim about a Hebrew, Aramaic
   or Greek word cites a lexicon or grammar (method rule 9). Where either is missing, the sentence
   carries `<!-- VERIFY: … -->` until `fact-check` closes it; never supply the wording or the
   gloss from memory. *Complete when:* every text and observation claim has its reference, or a
   `VERIFY` flag is proposed for it.

7. **Report and hand back.** Deliver the report below. Change nothing in a promoted chapter. For a
   draft, offer corrections to its trailing `CLAIM CATEGORIES` block, applied only once accepted.
   Run as gate V4.2, hand the verdict to the review workflow, which dates the gate in the brief's
   `verified:` map once every blocking finding is resolved. *Complete when:* the report is
   delivered and, for a gate run, the review workflow has the verdict.

## The report

Two parts. First, **the labels**: a compact list by section, one line per substantive sentence —
location · opening words · category · signalled or not. The labels live in the report, never in
the chapter file.

Second, **the findings**, blocking first. A finding is blocking when it borrows the text's
authority for a reading, conclusion or application, or when a text claim cannot be checked. For
each:

- **Location** and the sentence's opening words.
- **Kind** — silent collapse (naming both categories) · unsignalled category · label disagreement
  · move from one passage to systematic theology · text claim without reference or source.
- **Why** — what a reader would take the sentence to claim, and what it can support.
- **A suggested signal** — the few words that would mark the category ('on this reading', 'as
  [tradition] has read it', 'I conclude'), offered as a phrase, never as a rewritten sentence.

Group recurring patterns, so one decision fixes many. Close with a verdict: **V4.2 pass or fail**.

## Anti-patterns

- **Rewriting the sentence.** The fix for a collapse is the author's; the report offers a signal,
  not new prose.
- **Labelling by vocabulary.** 'Scripture says' does not make a sentence Biblical text, and 'I
  think' does not make one a conclusion; label what the sentence does.
- **Two categories for one sentence.** A sentence carrying two claims is split, not double-labelled.
- **Treating pastoral application as lesser.** It is the most contestable move, not an
  afterthought; it needs its conclusion as visibly as any inference needs its observation.
- **Settling a reading.** Which reading is right is the author's call through the contested-
  reading map; this skill checks only that a reading is presented as a reading.
- **Accepting a remembered verse or gloss.** A quotation or word-meaning not checked against its
  source keeps its `VERIFY` flag.

## Cross-references

- `standards/method/THEOLOGY.md` — rules 1, 2 and 9.
- `standards/verification/THEOLOGY.md` — gate V4.2.
- `planning/docs/reference/argument-maps.md` — the six categories on the map.
- `research/docs/reference/contested-readings.md` — a reading is interpretation, never the text.
- `.claude/skills/argument-audit/SKILL.md` — whether each claim's support holds.
- `.claude/skills/fact-check/SKILL.md` — closes the `VERIFY` flags on quotations and glosses.
- `.claude/skills/draft-section/SKILL.md` — writes the trailing `CLAIM CATEGORIES` block this
  skill checks.
- `.claude/rules/syntek-author/03-authorship.md` — Section 7, the categories never silently
  collapsed.
