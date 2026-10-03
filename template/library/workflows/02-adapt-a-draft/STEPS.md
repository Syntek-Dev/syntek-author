---
workflow: 02-adapt-a-draft
phase: produce
skills: [adapt-section, obligation-check]
model: opus
---

# STEPS.md — adapt a draft from the author's notes

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for revising a section draft from the author's notes or edits, or for
adapting a template into one client's document. Each step names the skill and guide it uses.
**Run in order** — the ordering is load-bearing — and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The
> `adapt-section` skill is this procedure in skill form; read its `BUSINESS.md` mode file too.

## 1. Confirm the draft and the kind of adaptation

> **Skill:** `adapt-section` · **Guide:** `library/docs/reference/drafting-with-ai.md`

Confirm which draft, and which of three jobs this is: notes on a draft, a draft the author has
edited by hand, or a template to adapt for a named client. For a template, confirm the template,
the client and the new document's unit brief; if there is no brief, plan it first
(`planning/workflows/01-plan-a-unit/`). _Substantive._

## 2. Read the draft, its ledger entry and its brief

> **Skill:** `adapt-section` · **Guide:** `library/docs/reference/section-anatomy.md`

Read the draft in full, its ledger entry (the AI original and every earlier decision, so a
rejected change is not proposed again), the section's line in the unit brief, and any internal
note under the draft's frontmatter: a deviation recorded there is deliberate. _Substantive._

## 3. Record the author's own edits first

> **Skill:** — · **Guide:** `library/docs/reference/the-status-ladders.md`

If the author has edited the draft by hand since the last AI pass, compare it with the last
version you produced, list what the author changed, and set `status: author-revised` before
adapting anything. Their words are now the baseline; treat them as approved. _Mechanical._

## 4. Map each note to the lines it reaches

> **Skill:** `adapt-section` · **Guide:** `library/docs/reference/drafting-with-ai.md`

Number the author's notes. For each, name the sentences it reaches. A note whose reach is unclear
('make it warmer') gets one question in chat, with your reading of it as the recommended answer.
A note that asks you to decide a commitment, a price or a date is put back to the author as a
question; it is not answered by drafting. _Substantive._

## 5. Revise only what was flagged

> **Skill:** `adapt-section` · **Guide:** `library/docs/reference/section-anatomy.md`

Make each change the notes call for, in the sentences they reach, and nowhere else. Keep one
sentence per line and the house style. Where the author supplied a fact in a note, write it in
exactly and remove any flag it answers. If the notes together amount to a rewrite, stop and ask
whether to re-draft through `library/workflows/01-draft-a-section/` instead. _Substantive._

## 6. Offer alternatives for contested lines

> **Skill:** `adapt-section` · **Guide:** `library/docs/reference/drafting-with-ai.md`

Where a note leaves the wording open, or a line carries weight (a guarantee, a limit, an
apology), offer two or three alternatives in the hand-back, each with one line on what it changes:
the strength of the commitment, the tone, the length. Put the most conservative wording in the
draft until the author chooses. _Substantive._

## 7. Adapt a template for one client (template adaptations only)

> **Skill:** `adapt-section` · **Guide:** `library/docs/reference/versioning-and-the-register.md`

Write one draft per section of the new document from the matching part of the template. Fill each
placeholder only from the author or the client's facts; leave any other as `[AWAITING USER INPUT]`.
Keep the template's clause order and labels. Every change the author instructs to a term is
listed for `obligation-check` against the template's standard position. Record the template's name
and review date in each draft's internal note. Set `origin: author` and leave the ledger's
`## AI original` empty: the wording is the template's, already approved, and every change made to
it is logged in step 9. _Substantive._

## 8. Check what must not change

> **Skill:** `obligation-check` · **Guide:** `library/docs/reference/drafting-with-ai.md`

Compare the revised draft with the version before this pass: every figure, date, price, scope
boundary, defined term and obligation must be unchanged unless a numbered note changed it. Any
other difference is reverted, or raised with the author as a question. _Substantive._

## 9. Save and log

> **Skill:** `adapt-section` · **Guide:** `library/docs/reference/drafting-with-ai.md`

Set `status: adapted` and `last_updated`. Add one row per note to the ledger entry's
`## Improvement decisions` table: the note, what was done, the reason, and the decision. A note
the author gave that was applied is logged `author-note`, never `accepted`: it was the author's
call, not an AI suggestion. Each alternative offered is logged `accepted` or `rejected`
(`pending` until the author chooses). Mirror the section's status in the unit brief. Never edit the ledger's
`## AI original`. _Mechanical._

## 10. Hand back

> **Skill:** `adapt-section` · **Guide:** `library/docs/reference/drafting-with-ai.md`

Report each note and what was done about it, the alternatives offered, the questions put back to
the author, anything reverted in step 8, and any flag still open. Suggest the next move: more
notes (repeat this procedure), or promotion through `library/workflows/04-promote-a-section/`.
_Substantive._
