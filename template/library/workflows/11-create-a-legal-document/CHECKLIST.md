---
workflow: 11-create-a-legal-document
phase: produce
skills: [legal-documents, run-workflow, fact-check, grill-with-docs, draft-section, promote-section, clause-consistency, obligation-check]
model: opus
---

# CHECKLIST.md — create a legal document

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `library/docs/reference/legal-standards.md` and the `legal-documents` skill. Gates are
> those of `standards/verification/verification.md`, named by the transition they guard; this list
> never restates them.

## Pre-Conditions

- [ ] Read `.claude/CLAUDE.md` and `.claude/MEMORY.md`, then this folder's `CONTEXT.md` and `CLAUDE.md`. · _sonnet_
- [ ] `legal-documents` loaded; `library/docs/reference/legal-standards.md` read. · _sonnet_
- [ ] Confirmed with the author: the type, the parties, what it must achieve, and its family of instruments. · _opus_

## Execution Checklist

**Before planning**

- [ ] Register, briefs and the counterparty's folders searched; a sent instrument opened as a new version instead. · _sonnet_
- [ ] Every instrument this one must agree with, and `planning/src/precedence.md`, read. · _opus_
- [ ] **Counterparty verified on the public register, never its website;** `## Facts` recorded with dates and sources. · _opus_
- [ ] Place and name set to the standard's pattern; nothing at that path overwritten. · _sonnet_

**Planning**

- [ ] Brief planned through `planning/workflows/01-plan-a-unit/`: one section per clause group, definitions first. · _opus_
- [ ] Every intended term and obligation listed in the brief; every negotiable value from the author. · _opus_
- [ ] Governing law settled; precedence recorded where the instrument belongs to a family. · _opus_
- [ ] V1 (idea → outlined) dated before any drafting; starting point chosen (template or skeleton). · _sonnet_

**Writing and review**

- [ ] Each clause group run through the loop and promoted on the author's word; clauses cited by `\ref`. · _opus_
- [ ] `library/workflows/05-review-a-document/` run in full, with `clause-consistency` and `obligation-check`. · _opus_
- [ ] **No statute, section number or requirement left unverified.** · _opus_
- [ ] Disclaimer at the top, unchanged; Document Control complete; signature block present. · _opus_

**Execution and hand-back**

- [ ] Handed back: path, register ID, status, any step waived and why. · _opus_
- [ ] On signature by every party: signed copy filed as `-signed.pdf`; approval recorded; Executed set. · _sonnet_

## Done When

- [ ] **The instrument is `final` on the author's word, with every part its type requires and every obligation intended.** · _opus_
- [ ] The register row exists and the issue PDF sits beside the `.tex`. · _sonnet_
- [ ] Executed is set only with every signature filed. · _sonnet_
