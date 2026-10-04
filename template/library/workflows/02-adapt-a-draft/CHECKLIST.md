---
workflow: 02-adapt-a-draft
phase: produce
skills: [adapt-section, obligation-check]
model: opus
---

# CHECKLIST.md — adapt a draft from the author's notes

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `library/docs/reference/drafting-with-ai.md` and the `adapt-section` skill. Gates are
> those of `standards/verification/verification.md`, named by the transition they guard; this list
> never restates them.

## Pre-Conditions

- [ ] Read `.claude/CLAUDE.md` and `.claude/MEMORY.md`, then this folder's `CONTEXT.md` and `CLAUDE.md`. · _sonnet_
- [ ] Confirmed which draft and which job: notes, the author's own edits, or a template for a named client. · _opus_
- [ ] Draft, ledger entry (AI original and earlier decisions), brief line and internal note read. · _opus_

## Execution Checklist

**Before changing a word**

- [ ] Author's hand edits, if any, found against the ledger's last recorded state, listed, recorded as an `author` revision, and the draft set to `author-revised` first. · _sonnet_
- [ ] Notes numbered, each mapped to the sentences it reaches; unclear notes asked about, one question each. · _opus_
- [ ] **Notes asking the AI to decide a commitment, a price or a date put back to the author as questions.** · _opus_

**Revising**

- [ ] Only the sentences the notes reach changed; every other sentence word for word. · _opus_
- [ ] Facts the author supplied written in exactly; the flags they answer removed. · _opus_
- [ ] Two or three alternatives offered for each contested line; the most conservative wording left in place. · _opus_
- [ ] One sentence per line and the house style kept. · _opus_

**Template adaptations only**

- [ ] One draft per section of the new document, placeholders filled only from the author or the client's facts. · _opus_
- [ ] Template clause order and labels kept; every instructed change to a term listed for `obligation-check`. · _opus_
- [ ] Template name and review date recorded in each draft's internal note; each draft as first written recorded under `## Author original`. · _sonnet_

**Checking and recording**

- [ ] **No figure, date, price, scope boundary, defined term or obligation changed except by a numbered note.** · _opus_
- [ ] Status set to `adapted`; `last_updated` set; brief mirrored. · _sonnet_
- [ ] One ledger row per note (`author-note`) and per alternative (`accepted` or `rejected`; empty while open); the AI original untouched. · _sonnet_
- [ ] Revisions appended: the notes as `author-note`, the alternatives as `ai`, each with its rows; the last matches the draft. · _sonnet_
- [ ] Handed back: each note and its outcome, alternatives, questions, reversions, open flags, next move. · _opus_

## Done When

- [ ] **Every note is answered by a change, an alternative or a question, and nothing else in the draft has moved.** · _opus_
- [ ] No commitment has changed without the author's numbered note. · _opus_
- [ ] The ledger records each note and what was done. · _sonnet_
- [ ] The draft stays in its drafts folder; promotion waits for the author's word. · _opus_
