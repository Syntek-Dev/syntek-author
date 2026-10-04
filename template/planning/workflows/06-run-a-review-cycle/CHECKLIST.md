---
workflow: 06-run-a-review-cycle
phase: review
skills: [structure-review, fact-check]
model: opus
---

# CHECKLIST.md — run a review cycle

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `planning/docs/reference/the-document-register.md`,
> `planning/docs/reference/reviews-are-advice.md` and the `structure-review` skill. A new version
> passes the unit gates again through the library's workflows. Gates are cited from
> `standards/verification/verification.md` by number (V1, V2 …) and never restated here.

## Pre-Conditions

- [ ] Read `.claude/CLAUDE.md` and `.claude/MEMORY.md`, then this folder's `CONTEXT.md` and `CLAUDE.md`. · _sonnet_
- [ ] Read `planning/src/review-schedule.md` in full. · _sonnet_
- [ ] **`Overdue` rows reported to the author before anything else.** · _sonnet_
- [ ] Scope of this cycle confirmed with the author. · _opus_

## Execution Checklist

**Reading**

- [ ] Each document's register row and the document itself read, including Document Control and version history. · _sonnet_
- [ ] The family's standard and guides, `standards/method/BUSINESS.md` and, where relevant, the disclaimers (`standards/brand/disclaimers.md`, or the file `00-project.md` `## Paths` names) read; missing guides noted. · _sonnet_

**Review**

- [ ] Content checked for anything no longer true: services, prices, contacts, legislation, entities, suppliers. · _opus_
- [ ] Every claim about the outside world sent to `fact-check` or flagged `VERIFY`. · _opus_
- [ ] Structure, Document Control, version history and disclaimer checked against the guides. · _opus_
- [ ] Review written to `planning/src/reviews/`, marked advice only. · _sonnet_
- [ ] Author's decisions taken item by item; those that pass the memory gate recorded. · _opus_

**Changes and records**

- [ ] MAJOR or MINOR agreed with the author for any change. · _opus_
- [ ] Changes made as a new version through the library's authoring workflows; nothing circulated edited in place. · _opus_
- [ ] The new version passed `library/workflows/05-review-a-document/` before issue, its register step moving the row to the new file. · _opus_
- [ ] Register row updated by its unchanged ID (Last Reviewed, Next Review Date, Status; Version and File Path checked) and `Last Updated` changed. · _sonnet_
- [ ] Schedule row updated (Last Review Date, Next Review Date, `Completed`) and `Last Updated` changed. · _sonnet_
- [ ] Approval record made where the review ended in formal re-approval. · _sonnet_

## Done When

- [ ] **Every document in scope is confirmed current or replaced by an agreed new version, and the register and schedule say so.** · _opus_
- [ ] The hand-back lists what changed, what was deferred and when each document is next due. · _opus_
