# FICTION.md — to-questionnaire, fiction mode

Who a novelist asks when the author cannot settle a decision alone, and the rule that a beta
reader is asked about the reading, never about the plan.

## Paths and unit

- **Questionnaires:** `planning/src/questionnaires/QUESTIONNAIRE-<SLUG>-DD-MM-YYYY.md`, with the
  returned copy beside it as `QUESTIONNAIRE-<SLUG>-DD-MM-YYYY-RETURNED.md`.
- **The decision it unblocks** usually sits in a chapter's brief,
  `planning/src/units/NN-kebab-title.md`, in the plan files (`planning/src/causality.md`,
  `planning/src/timeline.md`, `planning/src/arcs/`) or in the story bible in `world/src/`.
- **Recipients:** a specialist in a craft, trade, place or period the novel depicts; a beta
  reader from the book's stated audience (`00-project.md` `## Brief`); a collaborator such as an
  illustrator or a map-maker.
- **Voice:** `standards/style/voice-notes.md`.

## Additions to the steps

- **Step 1 — also route these elsewhere.** A fact about a real place, period, language or script:
  `research`, cited in `research/src/setting/`, never a questionnaire. Permission to quote an
  epigraph, a lyric or a poem: a row in the permissions register, `research/src/permissions.md`, and
  a letter, never a questionnaire. A query to a literary agent: the proposal kit's approach skill,
  where the project has it. A sensitivity reader, and what they review: the sensitive-content skill,
  where the project has it; otherwise the author's decision, recorded under the `Open questions`
  heading.
- **Step 1 — also settle what a reader may read.** Name the chapters they receive, and whether the
  questionnaire may mention anything past them: a beta reader asked about the ending before they
  have read to it cannot give the answer the author needs.
- **Step 2 — also keep a reader's questions open.** Ask where they were confused, bored, ahead of
  the story or behind it, and which character they would follow, with no options and no
  recommended answer; never a leading question that names the effect the author hopes for.
- **Step 5 — also check what comes back against the story bible.** A specialist's correction to
  the world is a proposed change, reported with both sources (`standards/method/FICTION.md`
  Section 6), never a silent edit to a story-bible file.

## Domain rules

| Recipient | Register, and what to ask |
|---|---|
| A specialist | Precise, in their trade's terms; ask what would really happen, what would be noticed, what a practitioner would never do |
| A beta reader | Plain, with no craft terms; ask about the experience of reading, chapter by chapter |
| A collaborator | Plain and practical; ask for what the brief needs, by when |

- **A reader's reaction is evidence about the draft, not a decision.** The author decides what to
  change; the questionnaire never promises a reader that a change will be made.
- **Never send prose a reader was not meant to see**, and never a draft with open `VERIFY` flags
  on a depiction of a real people or place.

## Examples

```text
# How a tidal ford was crossed on foot (chapters 4 and 9)

**Purpose:** two crossings hang on how long the ford stays open; your answer sets the timing.
**From:** the author · **To:** a coastal guide · **By:** 21/11/2026
**Status:** draft

## The crossing
### On a falling tide, how long would a sandbar crossing like this one stay passable on foot?
The ford is a sandbar about a mile long between a salt marsh and a tidal island.

1. Under an hour — the chase in chapter 9 must be tight
2. Two to three hours — the chase has room for the fall in chapter 9

**Recommended:** 2 — chapter 4 has a whole conversation on the sand; correct it if it is wrong.

> <answer stub>
```
