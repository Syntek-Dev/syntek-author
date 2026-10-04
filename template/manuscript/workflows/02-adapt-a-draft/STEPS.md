---
workflow: 02-adapt-a-draft
phase: produce
skills: [adapt-section, spelling, fact-check]
model: opus
---

# STEPS.md — adapt a draft from the author's notes

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for revising one section draft to the author's notes or hand-edits. Each step
names the skill and the guide it uses. **Run in order** and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The
> `adapt-section` skill is this procedure in skill form; read its mode file before step 1.

## 1. Locate the draft and its record

> **Skill:** `adapt-section` · **Guide:** `manuscript/docs/reference/the-status-ladders.md`

Open the section draft in the chapter's drafts folder, its ledger entry (named in the draft's
`ledger:` key) and the section's entry in the chapter brief. Note the draft's status and origin, and
read the ledger's earlier decisions so a choice the author has already made is not offered again.
_Mechanical._

## 2. Collect the author's notes, exactly

> **Skill:** `adapt-section` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

Notes may come in chat, as comments in the draft, or as the author's own edits to the file. For
edits, compare the draft with the ledger's last recorded state (`standards/style/ledger/CONTEXT.md`;
in an older entry without `format: 2`, the AI original or the last commit) to see exactly what the
author changed; those changes are decisions, recorded as an `author` revision before anything else
changes (`standards/style/ledger/CLAUDE.md`). Restate every note as a numbered list. Where a note
is ambiguous, ask before changing anything. _Substantive._

## 3. Scope the change

> **Skill:** `adapt-section` · **Guide:** `manuscript/docs/reference/section-anatomy.md`

For each note, mark the lines it touches. Everything else is out of scope and stays as it is. If a
note would change what the section is for, or move material to another section, stop and say so:
that is a change to the chapter's brief, and the author decides it there. _Substantive._

## 4. Revise only what was flagged

> **Skill:** `adapt-section` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

Change the flagged lines and nothing else. Keep the author's hand-edits verbatim. Keep every fact,
figure, date, name, citation key, quotation and flag unless a note is about it. Write in the voice
of `standards/style/voice-notes.md`, one sentence per line, and apply whatever the skill's mode file
adds at this step. _Substantive._

## 5. Offer alternatives for open notes

> **Skill:** `adapt-section` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

Where a note names a problem but not a fix ('this is flat', 'not sure about the ending'), offer two
or three alternatives in chat, numbered, each with a one-line note on what it does differently.
Make them differ in kind (shorter, plainer, more concrete), not three wordings of one idea. Leave
the original line in the file until the author chooses, then apply the choice. _Substantive._

## 6. Adapt source material, only when asked

> **Skill:** `adapt-section` · **Guide:** `manuscript/docs/reference/section-anatomy.md`

When the author asks for a section to be made from their own earlier material, treat the source as
read-only. Quarry it, never paste it: keep the argument or the events, change the register to the
reader named in `00-project.md` `## Brief`, and cut what this section's one job does not need.
Name the source (path and date) in an `<!-- INTERNAL NOTE: … -->` under the frontmatter. Then read
the result against the source: nothing in it may claim more than the source did. The words are the
AI's, so the result is recorded as the section's AI original (`origin: ai`), as
`manuscript/workflows/01-draft-a-section/` step 9 does; over an existing draft, it is a redraft.
_Substantive._

## 7. Check what you touched

> **Skill:** `spelling` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

Run `spelling` over the changed lines. Any new checkable claim goes through `fact-check` or carries
a `VERIFY` flag. Confirm every flag that was in the draft is still there, or was resolved by the
author's own note. _Mechanical._

## 8. Record the decisions

> **Skill:** `adapt-section` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

Add one row per note applied and one per alternative offered to the ledger entry's
`## Improvement decisions` table: the proposal, its reason, the decision, and the author's own
words where they gave any. A note the author gave (or a hand-edit) that was applied is logged
`author-note`, never `accepted`: it was the author's call, not an AI suggestion. Each alternative
is logged `accepted` or `rejected`, its decision cell left empty until the author chooses. Rejected
alternatives matter most: they are the clearest evidence of the author's voice. Then append the
revisions: the text after the notes as `author-note`, then the text after the chosen alternatives
as `ai`, each with its rows (one revision if only one kind of change was made). Set the draft's
`status: adapted` and `last_updated`, and mirror the status in the brief. _Mechanical._

## 9. Hand back

> **Skill:** `adapt-section` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

Report what changed, note by note; the alternatives still waiting for a choice; anything raised as
out of scope; every open flag. Offer the next move: more notes, or approval for promotion.
**Leave the draft in drafts.** _Substantive._
