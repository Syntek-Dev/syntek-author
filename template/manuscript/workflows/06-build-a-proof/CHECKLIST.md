---
workflow: 06-build-a-proof
phase: publish
skills: [build, fact-check]
model: sonnet
---

# CHECKLIST.md — build a proof

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `.claude/rules/syntek-author/04-build-pipeline.md` and the `build` skill with its mode
> file. Proofs are ungated; this list never restates a gate.

## Pre-Conditions

- [ ] Read this folder's `CONTEXT.md` and `CLAUDE.md`, and the build pipeline rules. · _sonnet_
- [ ] At the repository root, the folder holding the `Makefile`. · _sonnet_
- [ ] Scope decided: one chapter or the whole manuscript; **asked the author if the request was ambiguous**. · _opus_
- [ ] Format decided: `.docx`, `.pdf`, `.epub`, or `.docx` and `.pdf` for a plain 'build'. · _sonnet_
- [ ] With the references option on: the references database exists, or stopped and told the author to run `make init`. · _sonnet_

## Execution Checklist

- [ ] **For an editorial or publisher export only:** claims last checked more than about twelve months ago re-checked with `fact-check`; anything stale reported to the author. · _opus_
- [ ] `make refs` run cleanly (references option only). · _sonnet_
- [ ] The format target(s) run without errors. · _sonnet_
- [ ] **The echoed file list checked: anything missing traced to drafts, and the exclusion not worked around.** · _opus_
- [ ] Proof read: citations resolved, no raw `[@key]`. · _opus_
- [ ] Proof read: reference list present; a short entry traced to its reference record, not treated as a build fault. · _opus_
- [ ] Proof read: footnotes in place; headings, chapter order and breaks correct; no marker or internal note visible. · _opus_
- [ ] Proof read: special characters render. · _opus_
- [ ] Nothing under `build/` hand-edited to fix a rendering problem. · _sonnet_
- [ ] Reported back: output paths, scope, format, stale-claim flags, and what the proof revealed, each problem with its owning procedure. · _opus_

## Done When

- [ ] The requested scope built to the requested format(s) without errors. · _sonnet_
- [ ] **The proof has been read, not merely produced.** · _opus_
- [ ] Every problem found is fixed at source and rebuilt, or handed to the procedure that owns it. · _opus_
- [ ] For an editorial export, claim currency was checked and reported. · _opus_
- [ ] The author has the output path(s). · _sonnet_
