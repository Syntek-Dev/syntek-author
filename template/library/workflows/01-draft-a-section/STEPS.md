---
workflow: 01-draft-a-section
phase: produce
skills: [draft-section, grill-with-docs, fact-check, spelling]
model: opus
---

# STEPS.md — draft a section of a document

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for taking one section of a document from its unit brief to an `ai-draft`
the author can read. Each step names the skill and guide it uses. **Run in order** — the ordering
is load-bearing — and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The
> `draft-section` skill is this procedure in skill form; read its `BUSINESS.md` mode file too.

## 1. Confirm the section and read its brief

> **Skill:** `run-workflow` · **Guide:** `library/docs/reference/section-anatomy.md`

Confirm with the author which document and which section: its slug and `order` from the brief's
`sections:` list in `planning/src/units/<unit-slug>.md`. Read the brief's `## Scope`,
`## What this unit does`, `## Sections`, `## Obligations and defined terms`, `## Draws on` and
`## Draft notes`. If the brief's `status:` is still `idea` (V1 not dated), stop: the brief is not
agreed, and `planning/workflows/01-plan-a-unit/` settles it. Then read the family folder's pair,
the family's standard (`library/docs/reference/<family>-standards.md`) and, for a client document,
the client's facts: `## Facts` in `library/src/business/client-docs/<client-slug>/CONTEXT.md`, or
where `00-project.md ## Paths` says. _Substantive._

## 2. Settle the five questions

> **Skill:** `grill-with-docs` · **Guide:** `library/docs/reference/drafting-with-ai.md`

If the brief does not yet answer them, settle the five questions in chat, one round at a time,
each with a recommended answer: the counterparty's full legal name; the jurisdiction; the audience
(internal or external, and who exactly); the existing material (earlier versions, related
documents, the template); and the tone (the formal register or running copy). The legal name is
checked against the public register (step 4), never the counterparty's website. Record the answers
in the brief so they are asked once per document, not once per section. _Substantive._

## 3. Read the standards, the guides and the neighbours

> **Skill:** `draft-section` · **Guide:** `library/docs/reference/document-anatomy.md`

Read `standards/method/method.md` with its `BUSINESS.md`, the style trio in `standards/style/`
(`style-sheet.md`, `voice-notes.md`, `terminology.md`) and two or three of the author's own pieces
in `standards/style/samples/`. For running copy, read the brand voice in the brand folder
`00-project.md ## Paths` names; for an instrument, read `planning/src/precedence.md` and every
document in its family that this section must agree with. Read any sections of the same document
already promoted. _Substantive._

## 4. Gather every fact — before drafting

> **Skill:** `fact-check` · **Guide:** `research/docs/reference/vetting-evidence.md`

List every figure, date, name, statute, framework and entity detail the section will state. Take
each from the author, `.claude/MEMORY.md` `## Facts`, the client's facts, or an agreed document;
verify anything else with `fact-check` into `research/src/evidence/`, recording two dates (when
the fact was established, when it was checked). **Prices, dates and service levels come only from
the author.** Whatever cannot be sourced is listed for step 8, never written from memory.
_Substantive._

## 5. Confirm you will not clobber a draft

> **Skill:** — · **Guide:** `library/docs/reference/section-anatomy.md`

Check whether `library/src/<family>/drafts/<unit-slug>/<NN>-<section-slug>.md` or its ledger entry
`standards/style/ledger/<unit-slug>--<section-slug>.md` already exists. If either does, stop and
confirm with the author before going on; never overwrite silently. A confirmed redraft keeps its
ledger entry: before the old draft is replaced, record the author's work in it as
`standards/style/ledger/CLAUDE.md` sets out. _Mechanical._

## 6. Create the draft file and its ledger entry

> **Skill:** `draft-section` · **Guide:** `library/docs/reference/section-anatomy.md`

Create the drafts folder for the document if it is missing, then the draft with its frontmatter:
`unit`, `section`, `order`, `status: ai-draft`, `origin: ai`, `words_target` (from the brief, or
400), `ledger` and `last_updated`. Create the ledger entry with its frontmatter (`learned: false`,
`format: 2`) and its empty sections, in the format `standards/style/ledger/CONTEXT.md` gives; on a
redraft, keep the existing entry. _Mechanical._

## 7. Draft the section

> **Skill:** `draft-section` · **Guide:** `library/docs/reference/section-anatomy.md`

Write the section the brief planned, and only that: the point first; then the detail that makes
it checkable; then the limit, stated honestly; then the way forward. Open with a heading if the
section starts a new part of the document. One sentence per line. Use defined terms exactly as
`terminology.md` and the brief define them; in an instrument, 'shall', 'may' and 'must' each
intended; write as 'I' or 'we', whichever `00-project.md ## Brief` sets for the
business. Aim at the word target, but never cut an obligation to meet it. _Substantive._

## 8. Flag every gap

> **Skill:** `draft-section` · **Guide:** `library/docs/reference/drafting-with-ai.md`

Mark each gap where it falls: `<!-- AUTHOR TO CONFIRM: … -->` for a decision only the author can
make, `<!-- VERIFY: … -->` for a checkable claim not yet checked. A field the author must supply
in a form stays `[AWAITING USER INPUT]`. A deliberate departure from a standard goes in an
internal note under the frontmatter, so a later pass does not 'correct' it. _Substantive._

## 9. Check the house style before hand-over

> **Skill:** `spelling` · **Guide:** `library/docs/reference/section-anatomy.md`

Run `spelling` and `grammar` over the draft against `standards/style/style-sheet.md`: en_GB
spelling, single quotation marks, dates as DD/MM/YYYY, the currency format, no em dashes in client
copy, no filler intensifiers. Fix the draft's own slips now: it is still the AI's text, and the
author should be shown its best version. Nothing is recorded in the ledger here: step 10 records
the result as the AI original. _Mechanical._

## 10. Record the AI original

> **Skill:** `draft-section` · **Guide:** `library/docs/reference/drafting-with-ai.md`

Copy the draft's body, exactly as it now stands, into the ledger entry's `## AI original`, and set
its `drafted` date. On a redraft, first move the earlier record into the superseded comment, as
`standards/style/ledger/CLAUDE.md` sets out, so the new chain starts here. This is the baseline
every later change is measured against; it is never edited afterwards. _Mechanical._

## 11. Update the unit brief

> **Skill:** `draft-section` · **Guide:** `library/docs/reference/the-status-ladders.md`

Set the section's status to `ai-draft` in the brief's `sections:` list. If this is the document's
first drafted section, move the brief's `status` from `outlined` to `draft`: the move has no gate
of its own (V1 still holds), so nothing is dated in `verified:`. _Mechanical._

## 12. Hand back; never promote

> **Skill:** `draft-section` · **Guide:** `library/docs/reference/drafting-with-ai.md`

Report the draft's path, its word count against the target, every flag with the reason it was
raised, any question the brief left open, and any step waived with its reason. Suggest the next
move: the author's notes through `library/workflows/02-adapt-a-draft/`, or promotion through
`library/workflows/04-promote-a-section/` when the author approves it as it stands. **Leave the
draft where it is:** promotion is the author's call. _Substantive._
