---
workflow: 04-promote-a-section
phase: produce
skills: [promote-section, build]
model: opus
---

# CHECKLIST.md — promote a section into its document

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `library/docs/reference/latex-deliverables.md` and the `promote-section` skill. Gates
> are those of `standards/verification/verification.md`, named by the transition they guard; this
> list never restates them.

## Pre-Conditions

- [ ] Read `.claude/CLAUDE.md` and `.claude/MEMORY.md`, then this folder's `CONTEXT.md` and `CLAUDE.md`. · _sonnet_
- [ ] **The author's word heard, in words, naming this section.** · _opus_

## Execution Checklist

**Gates**

- [ ] Zero `AUTHOR TO CONFIRM`, `VERIFY` and `[AWAITING USER INPUT]` in the draft. · _sonnet_
- [ ] Draft frontmatter complete; any section gate in `standards/verification/` passed. · _sonnet_
- [ ] Bound for a `.tex`: no citation key (`[@`) in the draft; if there was one, stopped for the author to write the reference in full. · _sonnet_
- [ ] Document not yet circulated; if it has been, stopped and a new version opened first. · _opus_

**Into the document**

- [ ] Deliverable found by its `% unit:` line, or created from the house skeleton (`00-project.md ## Paths`) with its status block and one marker pair per planned section. · _sonnet_
- [ ] On a re-promotion, the author shown the text to be replaced and confirmed. · _opus_
- [ ] Draft converted to LaTeX per the guide's table: every approved word, nothing added, one sentence per line. · _opus_
- [ ] Text inserted only between `% section: <slug>` and `% end section: <slug>`; no marker deleted, renamed or moved. · _sonnet_
- [ ] **`make section-check FILE=<path>.tex SECTION=<slug> DRAFT=<draft>.md` passed before anything was recorded**; any difference fixed in the conversion. · _sonnet_
- [ ] `make pdf FILE=<path>.tex` run; the section read in the proof: no error, no raw Markdown, no missing word. · _opus_

**Records**

- [ ] Ledger: `## Author final` written, `promoted` date and `change_ratio` set; on a re-promotion, `learned: false`. · _sonnet_
- [ ] Row added or updated in `standards/style/ledger/provenance.md`. · _sonnet_
- [ ] Draft at `promoted`; brief's `sections:` list mirrored; dated line in `.claude/MEMORY.md` `## Status`. · _sonnet_
- [ ] Document status left unchanged. · _sonnet_
- [ ] Handed back: section, paths, change ratio, sections remaining, readiness for review. · _opus_

## Done When

- [ ] **The approved text sits between the section's markers, converted without loss or addition, and the document renders.** · _opus_
- [ ] The ledger and the provenance table record exactly what the author approved. · _sonnet_
- [ ] The document's status has not moved; `final` waits for the review and the author's word. · _opus_
