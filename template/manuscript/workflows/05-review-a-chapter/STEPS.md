---
workflow: 05-review-a-chapter
phase: review
skills: [structure-review, fact-check, comprehension, flow, grammar, spelling, run-workflow]
model: opus
---

# STEPS.md — review a chapter, stage by stage

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for reviewing one chapter from `draft` to `final`: **structure, then facts,
then the line**, with the gates of each stage passed before the next begins. Each step names the
skill and the guide it uses. Tick `CHECKLIST.md` as you go; a review may stop at the end of any
stage and continue later from the status in the brief.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`), then
> `standards/verification/verification.md` and its mode file. **Report first; apply only what is
> agreed**, as set out under 'Applying agreed fixes' below.

## 1. Fix the scope and find the stage

> **Skill:** `run-workflow` · **Guide:** `manuscript/docs/reference/the-status-ladders.md`

Confirm the chapter with the author. Read its brief: its `status:` and its `verified:` record say
which stage the review starts at. A chapter at `draft` starts at step 3; at `structural-review`, at
step 4; at `fact-check`, at step 6; at `line-edit`, at step 7. _Substantive._

## 2. Read the gates for the stages ahead

> **Skill:** `run-workflow` · **Guide:** `manuscript/docs/reference/the-status-ladders.md`

From `standards/verification/verification.md` and its mode file, list the gates for every move
still ahead, from V2 and V3 (draft → structural-review) up to V6 (line-edit → final), with every
sub-gate the mode file numbers under V4 to V6 and the skill each names. This list is the
review's spine; this procedure never restates it. _Mechanical._

## 3. Open the review

> **Skill:** `run-workflow` · **Guide:** `manuscript/docs/reference/section-anatomy.md`

Check every planned section in the brief is promoted with zero flags and the chapter's markers
match the brief: V2 (draft → structural-review). Build a proof of the whole chapter and read it
(`manuscript/workflows/06-build-a-proof/`): V3 (draft → structural-review). When both pass, date
V2 and V3 in `verified:` and set the brief's `status: structural-review`. If a section is missing,
stop: the chapter is still being written. _Mechanical (the checks); a missing section is the
author's call._

## 4. Structural review

> **Skill:** `structure-review` · **Guide:** `manuscript/docs/reference/section-anatomy.md`

Run `structure-review` over the chapter file against its brief and the chapter's place in
`planning/src/outline.md`. Write its synthesis to
`planning/src/reviews/REVIEW-<scope>-DD-MM-YYYY.md`, marked advice only. Then run the further
structural sub-gates the mode file numbers under V4. Deliver one prioritised report, blocking
first; apply what the author agrees, as below. _Substantive._

## 5. Pass the structural gates

> **Skill:** `structure-review` · **Guide:** `manuscript/docs/reference/the-status-ladders.md`

Re-run any structural gate the fixes touched. When V4 (structural-review → fact-check) and every
sub-gate under it pass, set `status: fact-check` and date each gate in `verified:`. _Substantive._

## 6. Fact check

> **Skill:** `fact-check` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

Sweep the chapter for every checkable claim and verify each against its primary source, filing
verdicts in `research/src/evidence/` (the full procedure is `research/workflows/02-verify-a-claim/`).
Run the fact sub-gates the mode file numbers under V5. Anything not verified carries a `VERIFY`
flag or comes out, with the author's agreement. When V5 (fact-check → line-edit) and its sub-gates
pass, set `status: line-edit` and date them. _Substantive._

## 7. Comprehension

> **Skill:** `comprehension` · **Guide:** the guide for this kind of book in `manuscript/docs/reference/`

Read the chapter as the reader named in `.claude/CLAUDE.md` Section 1. Report undefined terms,
leaps, buried points and lost orientation, by location. Report only. _Substantive._

## 8. Flow

> **Skill:** `flow` · **Guide:** `manuscript/docs/reference/section-anatomy.md`

Report on transitions, paragraph order, rhythm and repetition, and above all the seams between
sections drafted at different times: one voice across the whole chapter. Report only.
_Substantive._

## 9. Grammar

> **Skill:** `grammar` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

Report grammar and punctuation against `standards/style/style-sheet.md`, including single quotation
marks and one sentence per line, respecting deliberate fragments and dialect. Report only.
_Substantive._

## 10. Spelling

> **Skill:** `spelling` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

Report spelling against `standards/style/style-sheet.md` and `standards/style/terminology.md`:
what and where, the correction offered, recurring items grouped, no remark on the author. Report
only. _Substantive._

## 11. Run the line-edit gates and deliver one report

> **Skill:** the gate skills `standards/verification/` names · **Guide:** `manuscript/docs/reference/the-status-ladders.md`

Run the line-edit sub-gates the mode file numbers under V6. Combine steps 7 to 10 and these into one
prioritised report: blocking first, exact locations, what fails, why, a suggested fix, and the
procedure that owns each fix. Apply what the author agrees, as below. _Substantive._

## 12. Final, on the author's word

> **Skill:** `run-workflow` · **Guide:** `manuscript/docs/reference/the-status-ladders.md`

Confirm zero `AUTHOR TO CONFIRM` and zero `VERIFY` in the chapter
(`make flags SCOPE=manuscript/src/NN-kebab-title`) and every condition of V6 (line-edit → final)
and its sub-gates met but the author's word. Where the project has the sensitive-content option
and the chapter touches a subject recorded in `.claude/MEMORY.md` `## Sensitivities`, the
sensitivity pass runs over it before this step, and every item it raises is answered. Then ask
the author. Only on their explicit word set `status: final` and date V6 in `verified:`; then add
the author's word, with its date, to `.claude/MEMORY.md` `## Status`
(`standards/verification/verification.md` Section 2). _Substantive (the author's call)._

## 13. Hand back

> **Skill:** `run-workflow` · **Guide:** `manuscript/docs/reference/the-status-ladders.md`

Report the stage reached, the gates passed and their dates, the review file's path, open items and
remaining flags, and what the next stage needs. Offer a proof (`manuscript/workflows/06-build-a-proof/`).
_Substantive._

## Applying agreed fixes

Each case follows `standards/verification/verification.md` Section 3.

- **Wording changes** go back through the section: copy the chapter's current text for that section
  into its draft, set `author-revised`, revise through `manuscript/workflows/02-adapt-a-draft/` or
  `manuscript/workflows/03-improve-your-draft/`, and promote it again through
  `manuscript/workflows/04-promote-a-section/`.
- **A material change** (a section rewritten, a claim added, the argument restructured) also
  clears the date of the gate it reopens and of every later gate in the brief's `verified:`, and
  sets `status:` back to the rung the standard names. The review resumes from that rung.
- **Any other agreed wording change** in a chapter past `draft` has the stages already passed run
  again over its section before the chapter moves on.
- **Accepted spelling and punctuation corrections** may be applied in the chapter file directly,
  each logged as a row in that section's ledger entry. They reopen only V6.
