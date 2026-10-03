---
workflow: 08-update-the-register
phase: plan
skills: []
model: opus
---

# CHECKLIST.md — update the register

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `planning/docs/reference/the-document-register.md` and the writing rules in
> `planning/src/document-register.md`. A document needs its register row before gate V6.2 can
> pass. Gates are cited from `standards/verification/verification.md` by number (V1, V2 …) and
> never restated here.

## Pre-Conditions

- [ ] Read `.claude/CLAUDE.md` and `.claude/MEMORY.md`, then this folder's `CONTEXT.md` and `CLAUDE.md`. · _sonnet_
- [ ] The change confirmed with the author: new document, status change, new version or retirement. · _opus_
- [ ] The document's name and its path under `library/src/` confirmed. · _sonnet_

## Execution Checklist

**The row**

- [ ] Register read in full; the highest ID ever issued noted. · _sonnet_
- [ ] Row found by ID, or created with the next ID under the right family heading. · _sonnet_
- [ ] **Every column filled in order with accepted values; nothing deleted; no ID reused.** · _sonnet_
- [ ] A new version kept its ID, with Version, File Path and dates moved to the new file. · _sonnet_
- [ ] A superseded or retired row carries its status and a note naming what replaced it. · _sonnet_
- [ ] `Last Updated` changed in the register. · _sonnet_

**What follows from it**

- [ ] Stated precedence mirrored in `planning/src/precedence.md` with its clause; conflicts reported, not resolved. · _opus_
- [ ] Review schedule row added, changed or retired as the author decided. · _sonnet_
- [ ] For a new registration, the unit brief's `number` set to the `DOC-NNN`, and the `DOC-NNN` handed back for the Document Control reference before the issue proof. · _sonnet_

## Done When

- [ ] **The author has confirmed the changed rows, and no placeholder or unknown value remains.** · _opus_
- [ ] The register, the schedule and the precedence table agree with one another. · _sonnet_
