---
workflow: 13-create-an-accounting-document
phase: produce
skills: [accounting-documents, run-workflow, fact-check, grill-with-docs, draft-section, promote-section, build]
model: opus
---

# CHECKLIST.md — create an accounting document

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `library/docs/reference/accounting-standards.md` and the `accounting-documents` skill.
> Gates are those of `standards/verification/verification.md`, named by the transition they guard;
> this list never restates them.

## Pre-Conditions

- [ ] Read `.claude/CLAUDE.md` and `.claude/MEMORY.md`, then this folder's `CONTEXT.md` and `CLAUDE.md`. · _sonnet_
- [ ] `accounting-documents` loaded; `library/docs/reference/accounting-standards.md` read. · _sonnet_
- [ ] Confirmed with the author: the type, and so the route (form or report). · _opus_

## Execution Checklist

**Every route**

- [ ] Client's `## Facts` read for a client document. · _opus_
- [ ] **Every figure taken from the author, an agreed document or the books, its source named.** · _opus_
- [ ] A price differing from the agreement raised with the author before rendering. · _opus_
- [ ] Place and name set to the standard's pattern; nothing at that path overwritten. · _sonnet_

**Form route**

- [ ] Next number found across the whole family for the year, and confirmed by the author. · _sonnet_
- [ ] Started from the family template, or, where none exists yet, the LaTeX skeleton `00-project.md ## Paths` names, with every field the standard requires. · _sonnet_
- [ ] Every required field filled; tax line stated; durations in hours and minutes; two decimal places. · _opus_
- [ ] Every line and total recalculated. · _opus_
- [ ] Proof rendered and read through `library/workflows/06-build-a-proof/`. · _sonnet_
- [ ] Before `ISSUE=1`: `make flags SCOPE=<path>.tex` lists nothing, and no `\fillme`, `\dnote` or redline mark remains. · _sonnet_
- [ ] Number, amounts, tax line and due date confirmed by the author; status set to `final`; issue copy made with `ISSUE=1`. · _sonnet_

**Report route**

- [ ] Brief planned through `planning/workflows/01-plan-a-unit/`, covering the standard's parts. · _opus_
- [ ] Each section run through the loop and promoted on the author's word. · _opus_
- [ ] `library/workflows/05-review-a-document/` run in full; every estimate labelled; disclaimer present. · _opus_

**Hand-back**

- [ ] Listed in its folder's `CONTEXT.md`; handed back with every figure's source and anything to confirm. · _opus_

## Done When

- [ ] **Every figure traces to its source and every total recalculates.** · _opus_
- [ ] The author has confirmed the document, and its issue PDF sits beside the `.tex`. · _sonnet_
- [ ] No issued invoice was edited, and no number reused. · _sonnet_
