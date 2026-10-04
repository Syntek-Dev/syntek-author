---
workflow: 05-review-a-chapter
phase: review
skills: [structure-review, fact-check, comprehension, flow, grammar, spelling, run-workflow]
model: opus
---

# CHECKLIST.md — review a chapter, stage by stage

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `standards/verification/verification.md` and its mode file, and
> `manuscript/docs/reference/the-status-ladders.md`. Gates are cited from the standard by number
> and the move they guard, as 'V2 (draft → structural-review)'; this list never restates them.

## Pre-Conditions

- [ ] Read `.claude/CLAUDE.md` and `.claude/MEMORY.md`, then this folder's `CONTEXT.md` and `CLAUDE.md`. · _sonnet_
- [ ] Chapter confirmed with the author; its brief's `status:` and `verified:` read to find the starting stage. · _opus_
- [ ] Gates for every move still ahead listed from `standards/verification/verification.md` and its mode file. · _opus_

## Execution Checklist

**Opening (`draft → structural-review`)**

- [ ] Every planned section promoted with zero flags; markers match the brief: V2 (draft → structural-review). · _sonnet_
- [ ] A proof of the whole chapter built and read: V3 (draft → structural-review). · _sonnet_
- [ ] V2 and V3 dated; status set to `structural-review`. · _sonnet_

**Structure (`structural-review → fact-check`)**

- [ ] `structure-review` run; synthesis written to `planning/src/reviews/`, marked advice only. · _opus_
- [ ] Structural sub-gates the mode file numbers under V4 run. · _opus_
- [ ] One prioritised report delivered; agreed fixes applied through the sections. · _opus_
- [ ] **V4 (structural-review → fact-check) and its sub-gates passed before any fact checking began**; status set and each gate dated. · _opus_

**Facts (`fact-check → line-edit`)**

- [ ] Every checkable claim verified against its primary source, verdicts filed in `research/src/evidence/`. · _opus_
- [ ] Fact sub-gates the mode file numbers under V5 run. · _opus_
- [ ] Anything unverified flagged `VERIFY` or removed with the author's agreement. · _opus_
- [ ] V5 (fact-check → line-edit) and its sub-gates passed; status set and dated. · _sonnet_

**The line (`line-edit → final`)**

- [ ] `comprehension` run as the reader in `00-project.md` `## Brief`. · _opus_
- [ ] `flow` run, with the seams between sections checked for one voice. · _opus_
- [ ] `grammar` run against the style sheet. · _opus_
- [ ] `spelling` run: supportive, recurring items grouped. · _opus_
- [ ] Line-edit sub-gates the mode file numbers under V6 run. · _opus_
- [ ] One combined report delivered, blocking first, each fix with its owning procedure. · _opus_
- [ ] Agreed fixes applied through the sections; accepted spelling or punctuation corrections logged in the section's ledger. · _opus_
- [ ] Each section corrected in the chapter file has its ledger entry brought up to date: in a `format: 2` entry the previous author final (unless the last state already equals it), any hand-edits since and the correction appended as revisions; in every entry the new author final, `learned: false`, a recomputed ratio, its `provenance.md` row, and `provenance.py check` clean. · _sonnet_
- [ ] A material change cleared its gate and every later one and set the status back (`standards/verification/verification.md` Section 3); any other reopened section had the stages already passed run again over it. · _opus_

**Final**

- [ ] Zero `AUTHOR TO CONFIRM` and zero `VERIFY` in the chapter (`make flags SCOPE=manuscript/src/NN-kebab-title`). · _sonnet_
- [ ] Where the project has the sensitive-content option and the chapter touches a recorded sensitivity, the sensitivity pass run and every item answered. · _opus_
- [ ] **`status: final` set only on the author's explicit word**: V6 (line-edit → final) dated. · _opus_
- [ ] The author's word, with its date, added to `.claude/MEMORY.md` `## Status` (mapped in `00-project.md` `## Memory headings`). · _sonnet_

## Done When

- [ ] The chapter stands at the stage its gates have earned, and every move is dated in its brief. · _opus_
- [ ] Every report was delivered before anything changed, and only agreed fixes were applied. · _opus_
- [ ] Any waived gate is dated with the author's reason. · _sonnet_
- [ ] The author knows the stage reached and what the next one needs. · _opus_
