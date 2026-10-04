---
workflow: 04-promote-a-section
phase: produce
skills: [promote-section, build]
model: opus
---

# CHECKLIST.md — promote a section into its chapter

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `manuscript/docs/reference/section-anatomy.md` and the `promote-section` skill with its
> mode file. Gates are cited from `standards/verification/verification.md`; this list never
> restates them.

## Pre-Conditions

- [ ] Read `.claude/CLAUDE.md` and `.claude/MEMORY.md`, then this folder's `CONTEXT.md` and `CLAUDE.md`. · _sonnet_
- [ ] **The author's explicit word for this named section, recorded with the date.** · _opus_
- [ ] Draft, ledger entry and brief entry located. · _sonnet_

## Execution Checklist

**Before touching the chapter**

- [ ] Zero `AUTHOR TO CONFIRM` and zero `VERIFY` flags in the draft; any settled by the author applied. · _opus_
- [ ] Any section gate in `standards/verification/verification.md` run and passed. · _opus_
- [ ] Chapter file exists, or created from the brief: H1 and one marker per section, in order. · _sonnet_
- [ ] Markers match the brief; any disagreement reported, not guessed. · _opus_
- [ ] For a re-promotion: the text to be replaced shown to the author and confirmed. · _opus_

**Promotion**

- [ ] Prose inserted directly under its marker, without frontmatter, internal note or draft-only comments. · _sonnet_
- [ ] Nothing else in the chapter file changed. · _sonnet_

**Records**

- [ ] Ledger: author final copied, `promoted` dated, `change_ratio` set by `tooling/provenance.py`; on a re-promotion, `learned: false`. · _sonnet_
- [ ] Row added or updated in `standards/style/ledger/provenance.md`. · _sonnet_
- [ ] Draft at `status: promoted`; brief's section entry `promoted`; chapter `status:` unchanged. · _sonnet_
- [ ] Chapter's Status line in `.claude/MEMORY.md` (mapped in `00-project.md` `## Memory headings`) superseded with the new count. · _sonnet_

**Reading and hand-back**

- [ ] Section read in place beside its neighbours; seams reported, not fixed. · _opus_
- [ ] Handed back: section, whose word, change ratio, seams, sections remaining. · _opus_

## Done When

- [ ] **The section's prose sits under its own marker, in plan order, and the chapter's status has not moved.** · _opus_
- [ ] The draft, ledger, provenance table, brief and `.claude/MEMORY.md` all agree. · _sonnet_
- [ ] The author knows how many sections remain, and whether the chapter is ready for review. · _opus_
