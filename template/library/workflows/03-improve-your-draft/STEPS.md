---
workflow: 03-improve-your-draft
phase: produce
skills: [improve-section, spelling, grammar]
model: opus
---

# STEPS.md — improve a section the author wrote

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for proposing improvements to the author's own section, as a numbered diff
with a reason per change, and applying only what the author accepts. Each step names the skill
and guide it uses. **Run in order** — the ordering is load-bearing — and tick `CHECKLIST.md` as
you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The
> `improve-section` skill is this procedure in skill form; read its `BUSINESS.md` mode file too.

## 1. Confirm the draft and the strength

> **Skill:** `improve-section` · **Guide:** `library/docs/reference/drafting-with-ai.md`

Confirm which section, and the strength: `light` (clarity, slips, mechanics), `edit` (rhythm,
order, structure within the section) or `rework` (restructure, the substance intact). If the
author has not said, ask, recommending `light`. _Substantive._

## 2. Make sure the draft is on record

> **Skill:** `improve-section` · **Guide:** `library/docs/reference/section-anatomy.md`

If the author's text is not yet a draft file (pasted into chat, or written elsewhere), create it at
`library/src/<family>/drafts/<unit-slug>/<NN>-<section-slug>.md` with `status: author-draft` and
`origin: author`, and its ledger entry with `format: 2`, `## AI original` left empty and the
draft's body, as saved, under `## Author original`. Check first that neither exists; never
overwrite. In an existing `format: 2` entry, first record what `standards/style/ledger/CLAUDE.md`
requires before a change: a missing Author original, then any hand-edits since the last recorded
state as an `author` revision. _Mechanical._

## 3. Read the brief, the voice and the neighbours

> **Skill:** `improve-section` · **Guide:** `library/docs/reference/section-anatomy.md`

Read the section's line in the unit brief, `standards/style/voice-notes.md` (especially its
`## Learned` section), `standards/style/terminology.md`, the author's samples, and the sections
either side of this one. Read the ledger's earlier decisions, so a change the author has already
rejected is not proposed again. _Substantive._

## 4. Structural pass (edit and rework only)

> **Skill:** `improve-section` · **Guide:** `library/docs/reference/section-anatomy.md`

Does the section do the job the brief gave it? Does it lead with its point, state its limit and
end with the way forward? Is anything in it that belongs in another section, or missing that the
brief promised? At `edit`, propose moves within the section; at `rework`, propose a new order,
keeping every point and every obligation. _Substantive._

## 5. Register pass

> **Skill:** `improve-section` · **Guide:** `library/docs/reference/document-anatomy.md`

Check the register against the document's kind: formal for an instrument or a policy, the brand
voice for running copy, terse for microcopy; the business's 'I' or 'we' throughout. Propose only
where the text leaves its register, not where it differs from how you would write it. _Substantive._

## 6. Line pass and the numbered diff

> **Skill:** `improve-section` · **Guide:** `library/docs/reference/drafting-with-ai.md`

Write each proposal as a numbered item: the original line, the proposed line, and one line of
reason. Keep the author's idiom and any hedge that is doing honest work. **Never propose a change
to a figure, a date, a price, a scope boundary, a defined term or a commitment:** list each such
concern separately, as a question for the author. _Substantive._

## 7. Supportive proofreading report

> **Skill:** `spelling` · **Guide:** `library/docs/reference/drafting-with-ai.md`

Run `spelling` and `grammar` against `standards/style/style-sheet.md` and `terminology.md`. Report
what and where, offer each correction, and group recurring items ('three dates in the wrong
format, lines 4, 9 and 12'). A report, not a rewrite: nothing is changed yet. _Substantive._

## 8. The author decides

> **Skill:** `improve-section` · **Guide:** `library/docs/reference/drafting-with-ai.md`

Hand the numbered diff, the questions and the proofreading report to the author and wait. Accept
the author's answer in any form ('all but 3 and 7', 'yes to the spelling'); ask only if an answer
is ambiguous. The decision is the author's alone. _Substantive._

## 9. Apply the accepted changes

> **Skill:** `improve-section` · **Guide:** `library/docs/reference/section-anatomy.md`

Apply exactly the accepted proposals and corrections, and nothing else. Keep one sentence per line.
_Mechanical._

## 10. Log every decision

> **Skill:** `improve-section` · **Guide:** `library/docs/reference/drafting-with-ai.md`

Add a row to the ledger's `## Improvement decisions` for every proposal: number, proposal, reason,
accepted or rejected, and the author's note if they gave one. Rejections matter most: they are the
clearest evidence of the author's voice. If anything was accepted, append the draft as it now
stands as an `ai` revision, `improve-section (<strength>)`, with this pass's rows. Set
`status: improved` (or leave it if nothing was accepted), set `last_updated`, and mirror the
status in the brief. _Mechanical._

## 11. Hand back

> **Skill:** `improve-section` · **Guide:** `library/docs/reference/drafting-with-ai.md`

Report how many proposals were accepted and rejected, the questions still open, and any flag left
in the draft. Suggest the next move: another pass, or promotion through
`library/workflows/04-promote-a-section/` when the author approves it. _Substantive._
