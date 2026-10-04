---
workflow: 15-create-an-msp-scp-document
phase: produce
skills: [msp-scp-documents, run-workflow, grill-with-docs, fact-check, draft-section, promote-section, obligation-check, build]
model: opus
---

# CHECKLIST.md — create a managed-service document

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `library/docs/reference/msp-scp-standards.md`, `MSP-SCP-POLICY-SUITE.md` and the
> `msp-scp-documents` skill. Gates are those of `standards/verification/verification.md`, named by
> the transition they guard; this list never restates them.

## Pre-Conditions

- [ ] Read `.claude/CLAUDE.md` and `.claude/MEMORY.md`, then this folder's `CONTEXT.md` and `CLAUDE.md`. · _sonnet_
- [ ] `msp-scp-documents` loaded; the standard and its sub-document read. · _sonnet_
- [ ] Confirmed with the author: the type and its route, and whose it is. · _opus_

## Execution Checklist

**Every route**

- [ ] Register and review schedule searched; a policy due review routed to `planning/workflows/06-run-a-review-cycle/`. · _sonnet_
- [ ] **Whom it binds, owner, approver, classification and today's practice confirmed with the author.** · _opus_
- [ ] Place, suite number and name set to the standard's pattern; nothing overwritten. · _sonnet_

**Policy route**

- [ ] Brief planned through `planning/workflows/01-plan-a-unit/` to the policy structure; V1 dated. · _opus_
- [ ] Each rule area run through the loop and promoted on the author's word. · _opus_
- [ ] Every rule auditable; every framework and legal reference verified or flagged `VERIFY`. · _opus_
- [ ] `library/workflows/05-review-a-document/` run in full; classification (in the running header too), review-date notice and version history present. · _opus_
- [ ] Approval recorded through `planning/workflows/07-record-an-approval/` before Active; review-schedule row written. · _sonnet_

**Report route**

- [ ] Started from the family template, or, where none exists yet, the LaTeX skeleton `00-project.md ## Paths` names, with every part the report requires. · _sonnet_
- [ ] Template filled from the author's records; nothing invented. · _opus_
- [ ] Proof read through `library/workflows/06-build-a-proof/`. · _sonnet_
- [ ] Before `ISSUE=1`: `make flags SCOPE=<path>.tex` lists nothing, and no `\fillme`, `\dnote` or redline mark remains. · _sonnet_
- [ ] Author confirmed; status set to `final`; issue copy made with `ISSUE=1`. · _sonnet_

**Hand-back**

- [ ] Listed in its folder's `CONTEXT.md`; handed back with status, approval, next review and open flags. · _opus_

## Done When

- [ ] **The document carries the structure its type requires, and says only what the business actually does.** · _opus_
- [ ] A policy is Active only with its approval recorded. · _sonnet_
- [ ] Its issue PDF sits beside the `.tex`. · _sonnet_
