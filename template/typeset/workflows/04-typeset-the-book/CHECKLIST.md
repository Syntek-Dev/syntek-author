---
workflow: 04-typeset-the-book
phase: publish
skills: [typeset, build]
model: opus
---

# CHECKLIST.md — typeset the book

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `typeset/docs/reference/` and the `typeset` skill with its mode file. Proofs are ungated;
> release is not (`standards/verification/verification.md` Section 5). This list never restates a
> gate.

## Pre-Conditions

- [ ] Read this folder's `CONTEXT.md` and `CLAUDE.md`, and the pipeline guide. · _sonnet_
- [ ] Working proof or release print: settled with the author. · _opus_
- [ ] Chapters and their statuses listed from the outline and the briefs; gaps reported. · _opus_
- [ ] `make flags SCOPE=typeset/src` run; open page-design choices known. · _sonnet_

## Execution Checklist

- [ ] `make tex` run over the whole manuscript; every new or updated chapter taken through procedure 02 or 03. · _sonnet_
- [ ] Front and back matter set with words the author supplied; nothing composed or invented. · _opus_
- [ ] `book.tex` lists every chapter in outline order; the example's line gone if the example is. · _opus_
- [ ] For a release print only, and on the author's word: the `final` option set. · _opus_
- [ ] **`make tex-check` passes for every styled chapter.** · _sonnet_
- [ ] `make print` run; every warning read and explained. · _sonnet_
- [ ] **The whole proof read, every page in order.** · _opus_
- [ ] Page-fitting done one command at a time; the check and the print run again; moved pages read. · _opus_

## Done When

- [ ] Every chapter in the outline prints, passes the check, and was read. · _opus_
- [ ] The author has the PDF's path, the page count, the warnings, open flags and unfinished chapters. · _opus_
- [ ] Nothing was sent out or called final without the author's explicit word. · _opus_
