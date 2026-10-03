---
workflow: 01-design-the-page
phase: plan
skills: [typeset]
model: opus
---

# CHECKLIST.md — design the page

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `typeset/docs/reference/the-house-class.md` and the `typeset` skill with its mode file.
> Proofs are ungated (`standards/verification/verification.md` Section 5); this list never
> restates a gate.

## Pre-Conditions

- [ ] Read this folder's `CONTEXT.md` and `CLAUDE.md`, and the house-class guide. · _sonnet_
- [ ] Read `typeset/src/page-design.md` and `.claude/MEMORY.md` Decisions: settled and open choices known. · _opus_
- [ ] Asked the author for any printer's or publisher's specification. · _opus_

## Execution Checklist

- [ ] **Each open choice asked one at a time, with the options, a recommendation and its reason.** · _opus_
- [ ] Trim settled (or deferred) before margins and type size. · _opus_
- [ ] Every typeface recommended was checked as installed; licence for print left to the author. · _opus_
- [ ] Each answer recorded in `page-design.md` (value, reason, date), its flag removed, a decisions row added. · _opus_
- [ ] The matching class option set in `book.tex` in the same change. · _sonnet_
- [ ] Deferred choices keep their `AUTHOR TO CONFIRM` flag. · _sonnet_
- [ ] `make print` run; its warnings read; no typeface fell back unnoticed. · _sonnet_
- [ ] The sample read with the author: opener, text page, scene break, footnote, drop capital. · _opus_

## Done When

- [ ] **Every recorded choice is one the author made, and both files agree.** · _opus_
- [ ] Costly decisions (the trim above all) dated in `.claude/MEMORY.md` Decisions. · _opus_
- [ ] The author has the sample's path and the list of choices still open. · _sonnet_
