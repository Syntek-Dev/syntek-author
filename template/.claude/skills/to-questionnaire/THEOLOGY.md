# THEOLOGY.md — to-questionnaire, theology mode

Who a work of Christian non-fiction asks when the author cannot settle a decision alone, and the
rule that a scholar's view informs a decision but never replaces a checked source.

## Paths and unit

- **Questionnaires:** `planning/src/questionnaires/QUESTIONNAIRE-<SLUG>-DD-MM-YYYY.md`, with the
  returned copy beside it as `QUESTIONNAIRE-<SLUG>-DD-MM-YYYY-RETURNED.md`.
- **The decision it unblocks** usually sits in a chapter's brief,
  `planning/src/units/NN-kebab-title.md` (its `## Claims and categories`), in the argument map
  `planning/src/arguments/NN-kebab-title.md`, or in a contested-reading map in
  `research/src/contested-readings/`.
- **Recipients:** a scholar of the passage, period or tradition in question; a practitioner (a
  pastor, a chaplain, a counsellor) on how a pastoral application lands; a reader from another
  tradition; a beta reader from the book's stated audience (`00-project.md` `## Brief`).
- **Voice:** `standards/style/voice-notes.md`.

## Additions to the steps

- **Step 1 — also route these elsewhere.** What a verse says, what a Greek or Hebrew word means,
  what a council decided: empirical, so `fact-check` or `research` (`standards/method/THEOLOGY.md`
  Section 9), never a questionnaire. An approach to a prospective endorser is the proposal kit's
  approach skill, where the project has it. A request to quote or reproduce another work is a
  permission letter, recorded under the `Open questions` heading until it is granted, not a
  questionnaire. A sensitivity reader for first-person or sensitive material, and what they review:
  the sensitive-content skill, where the project has it.
- **Step 1 — also settle what the recipient may see.** A pastoral conversation or a church's
  internal matter in a draft is named and located for the author, never put in front of a
  recipient (`.claude/rules/syntek-author/06-global-rules.md` Section 10).
- **Step 2 — also state each contested reading so its holders would recognise it.** A question
  that asks a scholar to weigh two readings presents both at full strength, with no hint of the
  one the author prefers.
- **Step 5 — also label what comes back.** A scholar's answer that changes a claim names the
  claim's category in the brief before it is recorded, and any reference or original-language
  point in it goes to `fact-check` before the chapter relies on it.

## Domain rules

| Recipient | Register, and what to ask |
|---|---|
| A scholar | Precise, in their discipline's terms; ask how a reading is held and argued, never for a verdict the book then borrows as authority |
| A practitioner | Plain and pastoral; ask how an application would land with the people they serve, never for a confidence about them |
| A reader from another tradition | Respectful, in their tradition's own terms; ask whether the book states their reading so they would recognise it |
| A beta reader | Plain; ask where they followed, stumbled or stopped, never whether the theology is right |

- **Never fabricate a source to frame a question.** A reference, page number or quotation in the
  context paragraph is one the project has checked; otherwise it carries a `VERIFY` flag and is
  left out of the questionnaire.
- **A view is not evidence.** A scholar's reply may decide which reading the book adopts; the
  reading itself is still cited to a checked source.

## Examples

```text
# Which reading of the rest commandment chapter 3 should engage

**Purpose:** chapter 3 must engage one reading in depth; your view decides which.
**From:** the author · **To:** an Old Testament scholar · **By:** 14/11/2026
**Status:** draft

## The readings
### Which of the two readings in the attached map is the stronger as its holders argue it?
The map states both readings as their holders argue them, with the sources each relies on.
*Why this matters: the chapter concedes to the stronger one before it responds.*

1. The creation reading — rest grounded in the pattern of the seventh day
2. The redemption reading — rest grounded in release from slavery

**Recommended:** 1 — the argument map leans on it most; say so if it is the weaker of the two.

> <answer stub>
```
