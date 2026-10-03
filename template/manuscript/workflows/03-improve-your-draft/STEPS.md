---
workflow: 03-improve-your-draft
phase: produce
skills: [improve-section, spelling, grammar]
model: opus
---

# STEPS.md — improve the author's draft

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for proposing improvements to a section the author wrote: **structure, then
line, then mechanics**, reported as a numbered diff and applied only where accepted. Each step
names the skill and the guide it uses. Tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The
> `improve-section` skill is this procedure in skill form; read its mode file before step 1.
> **Report first; apply only what is agreed.**

## 1. Locate the draft and prepare its record

> **Skill:** `improve-section` · **Guide:** `manuscript/docs/reference/section-anatomy.md`

Find the section in the chapter's drafts folder. If the author pasted it in chat or wrote it without
frontmatter, save it as `<NN>-<section-slug>.md` with the frontmatter in
`manuscript/docs/reference/section-anatomy.md` (`status: author-draft`, `origin: author`), after
checking nothing will be overwritten. If it has no ledger entry, create one with `origin: author`
and an empty `## AI original`. _Mechanical._

## 2. Agree the strength

> **Skill:** `improve-section` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

Ask which strength the author wants: `light` (clarity, typos, slips), `edit` (rhythm, sentence
order, joins between paragraphs) or `rework` (restructure, keeping the argument or the events and
the section's one job). If the author names none, use `light` and say so. _Substantive._

## 3. Read it against its brief

> **Skill:** `improve-section` · **Guide:** `manuscript/docs/reference/section-anatomy.md`

Read the section's purpose in the chapter brief, then the draft. Does it do its one job? Note
anything promised and missing, and anything present that the brief did not ask for. At `light` and
`edit`, these become one-line notes for the author, not proposals. _Substantive._

## 4. Structural pass (`rework` only)

> **Skill:** `improve-section` · **Guide:** `manuscript/docs/reference/section-anatomy.md`

Propose any reordering, merging or splitting of paragraphs that would let the section do its job
better, keeping the argument or the events intact. Apply the structural checks the skill's mode
file adds. Each proposal names what moves and why. _Substantive._

## 5. Line pass (`edit` and `rework`)

> **Skill:** `improve-section` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

Run-ons, comma splices, sprawl, flat joins, repetition. Keep the author's voice markers from
`standards/style/voice-notes.md`, their deliberate fragments and dialect, and any hedge that is
doing honest work (check `standards/method/method.md` before proposing a cut). Never sterilise.
_Substantive._

## 6. Mechanics pass (every strength)

> **Skill:** `grammar` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

Run `grammar` and then `spelling` against `standards/style/style-sheet.md` and
`standards/style/terminology.md`: spelling, homophones, doubled words, punctuation, single
quotation marks, dates, one sentence per line. Report what and where, offer the correction, and
group recurring items. _Substantive._

## 7. Present the numbered diff

> **Skill:** `improve-section` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

One numbered proposal per change: location, before, after, a one-line reason, and its strength.
Group recurring items so one answer settles them all. List separately, as questions and never as
proposals, anything outside the lane: a figure, a date, a citation key, a quotation, a commitment,
the argument. Ask the author to accept all, none, or by number. _Substantive._

## 8. Apply only what the author accepts

> **Skill:** `improve-section` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

Apply exactly the accepted proposals to the draft and nothing else. Never change meaning while
styling. If an accepted change collides with another, ask. _Mechanical._

## 9. Log every decision

> **Skill:** `improve-section` · **Guide:** `manuscript/docs/reference/the-status-ladders.md`

Add every proposal to the ledger entry's `## Improvement decisions` table, accepted or rejected,
with the author's own words where they gave a reason. A rejection is the clearest evidence of the
author's voice there is. Set the draft's `status: improved` and `last_updated`, and mirror the
status in the brief. _Mechanical._

## 10. Hand back

> **Skill:** `improve-section` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

Report how many proposals were accepted and rejected, the questions still open, and every flag in
the draft. Offer the next move: another pass, or approval for promotion. **Leave the draft in
drafts.** _Substantive._
