---
workflow: 08-ingest-an-existing-document
phase: convert
skills: [adapt-section, fact-check, grill-with-docs]
model: opus
---

# CHECKLIST.md — ingest an existing document

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `library/docs/reference/versioning-and-the-register.md` and the `adapt-section` skill.
> Gates are those of `standards/verification/verification.md`, named by the transition they guard;
> this list never restates them.

## Pre-Conditions

- [ ] Read `.claude/CLAUDE.md` and `.claude/MEMORY.md`, then this folder's `CONTEXT.md` and `CLAUDE.md`. · _sonnet_
- [ ] Confirmed with the author: what the document is, who wrote it, and whether it is a record, a working source or a template seed. · _opus_

## Execution Checklist

**Filing**

- [ ] Folder chosen and house kebab-case name set, keeping any version and date the document states. · _sonnet_
- [ ] No existing file of that name; if there was one, stopped and asked. · _sonnet_
- [ ] **Original copied in byte for byte, never re-saved,** and listed in the folder's `CONTEXT.md`. · _sonnet_

**Reading copy**

- [ ] Reading copy made beside the original as `<name>.reading.md` (`pandoc` for `.docx`, `pdftotext -layout` for `.pdf`), or none needed for `.tex` or `.md`. · _sonnet_
- [ ] A scanned PDF with no text layer reported; no retyping from an image. · _sonnet_
- [ ] Reading copy checked against the original part by part; every loss listed in its internal note. · _opus_

**A record**

- [ ] Register row written via `planning/workflows/08-update-the-register/` with the author's confirmation; Executed only with a signed copy filed. · _sonnet_
- [ ] Approval recorded via `planning/workflows/07-record-an-approval/` for an executed instrument. · _sonnet_

**A working source or template seed**

- [ ] Unit brief planned via `planning/workflows/01-plan-a-unit/`: original in `## Draws on`, parts mapped to the house order, the five questions answered. · _opus_
- [ ] One draft per planned section, text copied word for word, at `author-draft` with `origin: author` and an internal note naming source and writer. · _sonnet_
- [ ] Ledger entry created for each draft with an empty `## AI original`. · _sonnet_
- [ ] **Every figure, date, entity detail, statute and framework reference verified or flagged `VERIFY`.** · _opus_
- [ ] Drafts brought into the house form through `library/workflows/02-adapt-a-draft/`; every change to a term listed for `obligation-check`. · _opus_

**Hand-back**

- [ ] Handed back: filing paths, conversion losses, and the register row or the brief, drafts, flags and next procedure. · _opus_

## Done When

- [ ] **The original sits unchanged in its family, with its reading copy and every loss noted beside it.** · _opus_
- [ ] A record is registered, or a working source has a brief and section drafts ready for the loop. · _sonnet_
- [ ] No claim from the ingested document is relied on unverified. · _opus_
