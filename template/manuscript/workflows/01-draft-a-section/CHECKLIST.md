---
workflow: 01-draft-a-section
phase: produce
skills: [draft-section, grill-with-docs, research, fact-check, spelling]
model: opus
---

# CHECKLIST.md — draft a section, end to end

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `manuscript/docs/reference/` and the `draft-section` skill with its mode file. Gates are
> cited from `standards/verification/verification.md`; this list never restates them.

## Pre-Conditions

- [ ] Read `.claude/CLAUDE.md` and `.claude/MEMORY.md`, then this folder's `CONTEXT.md` and `CLAUDE.md`. · _sonnet_
- [ ] Section confirmed with the author: chapter, section slug, order and the filename `<NN>-<section-slug>.md`. · _opus_
- [ ] The brief's status is not `idea` (V1 dated); otherwise stopped: the brief is not agreed (`planning/workflows/01-plan-a-unit/`). · _sonnet_
- [ ] Chapter brief read whole, including the section's purpose and the settled-positions section. · _opus_
- [ ] Voice read: `standards/style/voice-notes.md`, `standards/style/samples/`, the style sheet and the terminology list; an empty samples folder noted for the hand-back. · _opus_
- [ ] `standards/method/method.md`, its mode file and the `draft-section` mode file read. · _opus_

## Execution Checklist

**Before drafting a word**

- [ ] Material gathered from `research/src/` and the plan, not recalled; anything the mode file requires before drafting is in place. · _opus_
- [ ] **Every checkable claim run through `fact-check` before drafting**, or marked for a `VERIFY` flag. · _opus_
- [ ] No existing draft or promoted text will be clobbered; if one exists, stopped and asked. · _sonnet_
- [ ] Chapter folder, its pair and `drafts/README.md` exist. · _sonnet_

**Drafting**

- [ ] One section drafted, doing the one job the brief gives it, within its target length. · _opus_
- [ ] Mode-file additions for the drafting step applied. · _opus_
- [ ] Joins the sections either side; sounds like the voice notes and samples. · _opus_
- [ ] One sentence per line. · _sonnet_

**Flags and records**

- [ ] `VERIFY` at every unchecked claim; `AUTHOR TO CONFIRM` at every author decision. · _opus_
- [ ] No invented quotation, citation key, reference, figure or date. · _opus_
- [ ] `spelling` pass applied to the AI's own text. · _sonnet_
- [ ] Draft frontmatter complete: unit, section, order, status, origin, words target, ledger, last updated. · _sonnet_
- [ ] Ledger entry created (or, on a redraft, its chain restarted), the AI original copied verbatim, `learned: false`, `format: 2`. · _sonnet_
- [ ] Section status set to `ai-draft` in the brief. · _sonnet_
- [ ] For a chapter's first section: status moved from `outlined` to `draft` (no gate of its own; V1 still holds). · _sonnet_

**Hand-back**

- [ ] Handed back: path, length, every flag and its question, sources, anything unchecked, any step waived and why, and the author's options. · _opus_

## Done When

- [ ] **A single `<NN>-<section-slug>.md` sits in the chapter's drafts folder at `status: ai-draft`, and nothing was promoted.** · _opus_
- [ ] Every claim in it is backed by an evidence entry or carries a `VERIFY` flag. · _opus_
- [ ] The ledger holds the AI original verbatim. · _sonnet_
- [ ] The author knows what there is to decide. · _opus_
