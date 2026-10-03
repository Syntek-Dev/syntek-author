---
workflow: 07-record-an-approval
phase: plan
skills: []
model: opus
---

# CHECKLIST.md — record an approval

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `planning/docs/reference/the-document-register.md` and
> `planning/src/approvals/CONTEXT.md`. Gates are cited from
> `standards/verification/verification.md` by number (V1, V2 …) and never restated here.

## Pre-Conditions

- [ ] Read `.claude/CLAUDE.md` and `.claude/MEMORY.md`, then this folder's `CONTEXT.md` and `CLAUDE.md`. · _sonnet_
- [ ] The event confirmed as one that qualifies: a signing by every party, a policy approved as `Active`, or a notice issued. · _opus_
- [ ] The document has a register row, or `08-update-the-register` has been run first. · _sonnet_

## Execution Checklist

**Confirmation**

- [ ] Document name, `DOC-NNN`, version and event date confirmed by the author. · _sonnet_
- [ ] Full name, role and organisation of every approver confirmed by the author. · _opus_
- [ ] Scope stated in a sentence or two, and the method and any reference confirmed. · _opus_
- [ ] Conditions, caveats and linked documents noted. · _opus_

**Record**

- [ ] Record written at `planning/src/approvals/approval-<doc-type>-DD-MM-YYYY.md`, dated by the event. · _sonnet_
- [ ] **No field guessed and no placeholder left.** · _sonnet_
- [ ] No secret recorded: no password, access code or signature image. · _sonnet_

**Register and schedule**

- [ ] Register row set to `Executed` or `Active`, Last Reviewed set where it was a formal review, the record named in `Notes`. · _sonnet_
- [ ] `Last Updated` changed in the register. · _sonnet_
- [ ] Review schedule updated where the event sets a date, or the skip stated. · _sonnet_

## Done When

- [ ] **The record has been read back to the author and every field is theirs.** · _opus_
- [ ] The register shows the status the event produced. · _sonnet_
