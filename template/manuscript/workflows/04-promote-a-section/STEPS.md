---
workflow: 04-promote-a-section
phase: produce
skills: [promote-section, build]
model: opus
---

# STEPS.md — promote a section into its chapter

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for moving one approved section from its draft into the chapter file, and
recording what happened. Each step names the skill and the guide it uses. **Run in order**: the
checks come before the insertion for a reason. Tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The
> `promote-section` skill is this procedure in skill form; read its mode file before step 1.

## 1. Confirm the author's word

> **Skill:** `promote-section` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

The author must name the section, or plainly confirm it when asked. If the request is general
('promote what's ready') or casual ('looks fine'), name each candidate section and ask. Record whose
word it was and when, for the hand-back. _Substantive (the author's call)._

## 2. Check the gates and the flags

> **Skill:** `promote-section` · **Guide:** `manuscript/docs/reference/the-status-ladders.md`

Search the draft for `AUTHOR TO CONFIRM` and `VERIFY` (`make flags` lists every flag in the
project). Any flag stops the promotion: the author may settle an `AUTHOR TO CONFIRM` now, and the
flag is removed with their answer applied; a `VERIFY` goes through `fact-check` or the claim comes
out, then the author confirms again. Run any gate `standards/verification/verification.md` sets for
promoting a section. _Substantive._

## 3. Check the chapter file and the marker

> **Skill:** `promote-section` · **Guide:** `manuscript/docs/reference/section-anatomy.md`

If the chapter file does not exist, create it: an H1 holding the brief's title, then one
`<!-- section: <slug> -->` marker per entry in the brief's `sections:` list, in order, each on its
own line with a blank line between. If this section's marker is missing, or the markers disagree
with the brief, stop and report. If text already sits under the marker (a re-promotion), show the
author what will be replaced and confirm.
_Mechanical (creating the file); a disagreement is substantive._

## 4. Insert the section

> **Skill:** `promote-section` · **Guide:** `manuscript/docs/reference/section-anatomy.md`

Copy the draft's prose (without its frontmatter, internal note, or any working comment the skill's
mode file marks as draft-only) into the chapter file, directly under the marker, ending before the
next marker, with one blank line either side. Change nothing else in the file. _Mechanical._

## 5. Record provenance

> **Skill:** `promote-section` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

In the ledger entry: copy the promoted text under `## Author final`; set `promoted` to today
(DD/MM/YYYY); set `change_ratio` with `tooling/provenance.py`, which compares the AI original with
the author final (for an author-drafted section there is no AI original to compare). On a
re-promotion, set the entry's `learned: false`, so `learn-voice` mines the new edits. Add or update
the section's row in `standards/style/ledger/provenance.md`: Unit, Section, Origin, Change ratio,
Promoted. _Mechanical._

## 6. Update the statuses

> **Skill:** `promote-section` · **Guide:** `manuscript/docs/reference/the-status-ladders.md`

Set the draft's `status: promoted` and `last_updated`. Set the section's entry in the brief's
`sections:` list to `promoted`. **Leave the chapter's own `status:` where it is.** Bring the
chapter's line under Status in `.claude/MEMORY.md` (mapped in `00-project.md` `## Memory headings`)
up to date (for example, how many of its sections are promoted), superseding the previous line
rather than deleting it. Apply any extra records the
skill's mode file names. _Mechanical._

## 7. Read it in place

> **Skill:** `build` · **Guide:** `manuscript/docs/reference/section-anatomy.md`

Read the section in the chapter file alongside its neighbours: does it join them? Report any seam
rather than fixing it; joins are judged in the review's flow pass. A proof
(`make pdf SCOPE=manuscript/src/NN-kebab-title`) is ungated and optional here; see
`manuscript/workflows/06-build-a-proof/`. _Substantive._

## 8. Hand back

> **Skill:** `promote-section` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

Report what was promoted and on whose word, the change ratio, any seam noticed, and how many of the
chapter's sections remain. When every planned section is promoted, say so and offer
`manuscript/workflows/05-review-a-chapter/`. _Substantive._
