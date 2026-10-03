---
workflow: 01-draft-a-section
phase: produce
skills: [draft-section, grill-with-docs, research, fact-check, spelling]
model: opus
---

# STEPS.md — draft a section, end to end

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for taking one section from the chapter's plan to an AI draft in the
chapter's drafts folder, with its ledger entry written. Each step names the skill and the guide it
uses. **Run in order** (the ordering is load-bearing) and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The
> `draft-section` skill is this procedure in skill form; read its mode file before step 1.

## 1. Fix the section

> **Skill:** `draft-section` · **Guide:** `manuscript/docs/reference/section-anatomy.md`

Confirm with the author which chapter and which section. 'The next section' means the first entry
in the brief's `sections:` list, in order, that is neither promoted nor already drafted. Confirm
the filename `<NN>-<section-slug>.md`, where `<NN>` is the section's `order`. If the chapter has no
brief in `planning/src/units/`, or the brief does not list the section, stop: the plan comes first
(`planning/workflows/01-plan-a-unit/`). If the brief's `status:` is still `idea` (V1 not dated),
stop: the brief is not agreed, and `planning/workflows/01-plan-a-unit/` settles it. If the
section's purpose is too thin to draft from, settle its one job with the author using
`grill-with-docs` before going on. _Substantive._

## 2. Read the plan, the voice and the method

> **Skill:** `draft-section` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

Read the chapter's brief whole: its scope, what it does, its sections, its settled-positions
section, what it draws on and its draft notes. Read whatever further plan the skill's mode file
names. Read `standards/style/voice-notes.md`, the samples in `standards/style/samples/`,
`standards/style/style-sheet.md` and `standards/style/terminology.md`; then
`standards/method/method.md` and its mode file. Read the chapter folder's own pair, and the
sections either side of this one (promoted text in the chapter file, or their drafts), so the new
section joins them. _Substantive._

## 3. Gather the material, before drafting

> **Skill:** `research` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

List what the section needs: sources, evidence, readings, established facts. Read each from
`research/src/` and the plan, not from memory. If the mode file requires something to exist before
drafting and it does not, stop and say so; run the research or planning procedure that makes it
rather than drafting around the gap. **Draft from notes, never from memory.** _Substantive._

## 4. Check every claim, before drafting

> **Skill:** `fact-check` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

For each checkable claim the section will make, run `fact-check` and file the verdict in
`research/src/evidence/` (the full procedure is `research/workflows/02-verify-a-claim/`). A claim
that cannot be checked now either goes into the draft carrying a `VERIFY` flag or stays out; decide
which with the author's brief in mind. Never write a figure, date, quotation or reference from
memory. _Substantive._

## 5. Confirm you will not clobber a draft

> **Skill:** `draft-section` · **Guide:** `manuscript/docs/reference/section-anatomy.md`

Check whether `drafts/<NN>-<section-slug>.md` already exists, and whether the chapter file already
holds text under this section's marker. If either does, stop and ask the author: never overwrite
silently. If the chapter folder does not exist yet, create it now, with its `CONTEXT.md` and
`CLAUDE.md` (see `manuscript/src/CLAUDE.md`) and `drafts/README.md` in the four-line pattern every
chapter uses. _Mechanical._

## 6. Draft the section

> **Skill:** `draft-section` · **Guide:** the guide for this kind of book in `manuscript/docs/reference/`

Draft **one** section into `drafts/<NN>-<section-slug>.md`, with the frontmatter set out in
`manuscript/docs/reference/section-anatomy.md`: `status: ai-draft`, `origin: ai`, the `order`,
the `words_target` from the brief (400 if it gives none) and the `ledger` path. Write to the
section's one job, at its target length, one sentence per line, in the voice of the notes and
samples, and joining the sections either side. Apply whatever the skill's mode file adds at this
step. _Substantive._

## 7. Flag what is unchecked or undecided

> **Skill:** `draft-section` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

Put `<!-- VERIFY: … -->` at each claim not yet checked, saying what needs checking, and
`<!-- AUTHOR TO CONFIRM: … -->` at each decision only the author can make, saying what the choice
is. Cite checked sources inline with their existing keys (`[@authorYYYY]`) when the references
option is on; never invent one. A deviation the author has authorised goes in an
`<!-- INTERNAL NOTE: … -->` under the frontmatter. _Substantive._

## 8. Spelling pass

> **Skill:** `spelling` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

Run `spelling` over the draft against `standards/style/style-sheet.md` and
`standards/style/terminology.md`. Apply its fixes directly: this is the AI's own text, so there is
nothing of the author's to protect yet. _Mechanical._

## 9. Write the ledger entry

> **Skill:** `draft-section` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

Create `standards/style/ledger/<unit-slug>--<section-slug>.md` with frontmatter `unit`, `section`,
`origin: ai`, `drafted` (today, DD/MM/YYYY), empty `promoted` and `change_ratio`, and
`learned: false`. Copy the draft's body, exactly as it will be handed back, under `## AI original`;
leave `## Author final` empty and start `## Improvement decisions` as an empty table. Never edit the
AI original afterwards. _Mechanical._

## 10. Update the brief and hand back

> **Skill:** `draft-section` · **Guide:** `manuscript/docs/reference/the-status-ladders.md`

Set the section's status in the brief's `sections:` list to `ai-draft`. If the chapter was
`outlined`, this first section moves it: set the brief's `status: draft`. The move has no gate of
its own in `standards/verification/verification.md` (V1 still holds), so nothing is dated in
`verified:`. Then report: the draft's path and length; every flag, with its question; the sources
used; anything that could not be checked; any step waived and why; and the author's options (give
notes, edit it, or approve it for promotion). **Leave the draft in drafts.** _Substantive._
