---
workflow: 06-build-a-proof
phase: publish
skills: [build]
model: opus
---

# CHECKLIST.md — build a proof and read it

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `library/docs/reference/latex-deliverables.md` and the `build` skill. Proofs are ungated;
> the gates in `standards/verification/verification.md` apply to `final`, not to a proof.

## Pre-Conditions

- [ ] Read `.claude/CLAUDE.md` and `.claude/MEMORY.md`, then this folder's `CONTEXT.md` and `CLAUDE.md`. · _sonnet_
- [ ] The document's `.tex` path and the format confirmed with the author. · _sonnet_

## Execution Checklist

**Building**

- [ ] `make pdf FILE=<path>.tex` run; on failure, the first error in the log read and its cause found. · _sonnet_
- [ ] The echoed source is the file the author meant; the output in `build/` is newer than it. · _sonnet_
- [ ] Word copy only if asked for: a `.tex` through `make docx FILE=<path>.tex`, which uses `DOCX_CONVERTER` from `tooling/project.mk`; only where that is empty, the author asked for a lossless converter, or the PDF sent instead; Markdown copy through `make docx FILE=<path>.md`. · _sonnet_

**Reading**

- [ ] **The proof read end to end.** · _opus_
- [ ] No `??` or `[?]`; no raw Markdown; drafting notes only on a document not yet `final`. · _opus_
- [ ] Disclaimer present where the class needs one; Document Control block complete. · _opus_
- [ ] Tables inside the margins; no stranded headings; the parts in order. · _opus_
- [ ] Word copy compared with the PDF: nothing lost; if anything was, stopped and reported. · _opus_

**Reporting**

- [ ] Proof path, source and status, checks made, defects by page and section, and the procedure that fixes each. · _opus_
- [ ] A Word copy that is sent copied from `build/` beside its source on the author's word, named as the issued PDF, and committed with it. · _sonnet_

## Done When

- [ ] **A proof built from the intended file sits in `build/` and has been read in full.** · _opus_
- [ ] Every defect is reported with its location; no derived file was edited by hand. · _opus_
