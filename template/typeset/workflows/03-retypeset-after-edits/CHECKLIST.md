---
workflow: 03-retypeset-after-edits
phase: publish
skills: [typeset]
model: opus
---

# CHECKLIST.md — re-typeset a chapter after edits

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `typeset/docs/reference/the-typesetting-pipeline.md` and the `typeset` skill with its
> mode file. Proofs are ungated (`standards/verification/verification.md` Section 5).

## Pre-Conditions

- [ ] Read this folder's `CONTEXT.md` and `CLAUDE.md`, and the pipeline guide. · _sonnet_
- [ ] The chapter named; its revision promoted in the Markdown. · _opus_
- [ ] A styled file exists for it (otherwise procedure 02). · _sonnet_

## Execution Checklist

- [ ] `make tex SCOPE=manuscript/src/NN-kebab-title` reported `updated` and kept the old base. · _sonnet_
- [ ] **The old base is the one the styled file was made from** (kept by `make tex`, or the base committed with the styled file). · _opus_
- [ ] `git merge-file --diff3` run on styled, old base and new base, in that order. · _sonnet_
- [ ] **Every clash resolved with the new base's words, the styling re-applied, no word typed.** · _opus_
- [ ] No conflict marker left in the styled chapter. · _sonnet_
- [ ] `make tex-check UNIT=NN-kebab-title` passes. · _sonnet_
- [ ] `make print` run; the pages around each change read, earlier page-fits re-checked. · _opus_

## Done When

- [ ] **The styled chapter carries the revised words, keeps its styling, and passes the check.** · _opus_
- [ ] `build/typeset/NN-kebab-title.old-base.tex` deleted. · _sonnet_
- [ ] The author has the clash count, how each was resolved and the proof's path. · _opus_
- [ ] The new base and the styled file are ready to commit together. · _sonnet_
