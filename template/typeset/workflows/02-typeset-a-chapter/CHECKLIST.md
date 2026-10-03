---
workflow: 02-typeset-a-chapter
phase: publish
skills: [typeset]
model: opus
---

# CHECKLIST.md — typeset a chapter

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `typeset/docs/reference/` and the `typeset` skill with its mode file. Proofs are
> ungated (`standards/verification/verification.md` Section 5); this list never restates a gate.

## Pre-Conditions

- [ ] Read this folder's `CONTEXT.md` and `CLAUDE.md`, and the pipeline guide. · _sonnet_
- [ ] At the repository root, the folder holding the `Makefile`. · _sonnet_
- [ ] The chapter named with the author; its sections promoted. · _opus_
- [ ] No styled file exists for it yet (otherwise procedure 03). · _sonnet_
- [ ] Open page-design choices noted from `typeset/src/page-design.md`. · _sonnet_

## Execution Checklist

- [ ] `make tex SCOPE=manuscript/src/NN-kebab-title` run; its output and any filter warning read. · _sonnet_
- [ ] The base copied to `typeset/src/units/NN-kebab-title.tex`; nothing else created it. · _sonnet_
- [ ] **Styling uses house macros only, around words already there; no word typed, moved or corrected.** · _opus_
- [ ] No scene break, epigraph or section added or removed in LaTeX. · _opus_
- [ ] The difference from the base read: every change is a macro. · _opus_
- [ ] **`make tex-check UNIT=NN-kebab-title` passes; every warning dealt with.** · _sonnet_
- [ ] `\houseinput{units/NN-kebab-title}` added to `book.tex` in outline order. · _sonnet_
- [ ] `make print` run; every warning it echoed read and explained. · _sonnet_
- [ ] Proof read: opener, epigraph, scene breaks, drop capital, footnotes, and the mode file's items. · _opus_
- [ ] Page-fitting, if any, done one command at a time, with the check and the print run again. · _opus_

## Done When

- [ ] **The styled chapter passes `make tex-check`.** · _sonnet_
- [ ] The chapter prints in its place in the book, and the proof has been read. · _opus_
- [ ] The author has the proof's path, the warnings and any open page-design choice. · _opus_
- [ ] The base and the styled file are ready to commit together. · _sonnet_
