---
workflow: 02-adapt-a-draft
phase: produce
skills: [adapt-section, spelling, fact-check]
model: opus
---

# CHECKLIST.md — adapt a draft from the author's notes

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `manuscript/docs/reference/drafting-with-ai.md` and the `adapt-section` skill with its
> mode file. Gates are cited from `standards/verification/verification.md`; this list never
> restates them.

## Pre-Conditions

- [ ] Read `.claude/CLAUDE.md` and `.claude/MEMORY.md`, then this folder's `CONTEXT.md` and `CLAUDE.md`. · _sonnet_
- [ ] Draft, ledger entry and brief entry located; status and origin noted. · _sonnet_
- [ ] Earlier decisions in the ledger read, so no settled choice is offered again. · _opus_
- [ ] `standards/style/voice-notes.md` and the `adapt-section` mode file read. · _opus_

## Execution Checklist

**The notes**

- [ ] Every note restated as a numbered list; ambiguous notes asked about before any change. · _opus_
- [ ] The author's hand-edits identified against the ledger's last recorded state, kept verbatim, and recorded as an `author` revision first. · _opus_
- [ ] Each note scoped to the lines it touches; any note that changes the section's job raised, not acted on. · _opus_

**The revision**

- [ ] **Only flagged lines changed; every other sentence is exactly as it was.** · _opus_
- [ ] Facts, figures, dates, names, citation keys, quotations and flags kept unless a note was about them. · _opus_
- [ ] Two or three alternatives, different in kind, offered for each open note; the original left until chosen. · _opus_
- [ ] Deliberate oddities preserved, or asked about. · _opus_
- [ ] Source material (when asked) quarried, not pasted; source named in an internal note; result read against the source. · _opus_

**Checking and recording**

- [ ] `spelling` run over the changed lines. · _sonnet_
- [ ] New claims checked with `fact-check` or flagged `VERIFY`. · _opus_
- [ ] One ledger row per note applied (`author-note`) and per alternative offered (`accepted` or `rejected`; empty while open). · _sonnet_
- [ ] Revisions appended: the notes as `author-note`, the chosen alternatives as `ai`, each with its rows; the last matches the draft. · _sonnet_
- [ ] Draft at `status: adapted`, `last_updated` set, status mirrored in the brief. · _sonnet_

## Done When

- [ ] **Every note is applied, offered as alternatives, or raised as out of scope, and nothing unflagged changed.** · _opus_
- [ ] Every choice is recorded in the ledger. · _sonnet_
- [ ] The draft is still in drafts and nothing was promoted. · _opus_
