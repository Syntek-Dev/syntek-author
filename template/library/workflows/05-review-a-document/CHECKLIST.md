---
workflow: 05-review-a-document
phase: review
skills: [structure-review, fact-check, clause-consistency, obligation-check, comprehension, flow, tone, grammar, spelling, build]
model: opus
---

# CHECKLIST.md — review a document to final

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `library/docs/reference/the-status-ladders.md`, `standards/verification/BUSINESS.md` and
> the skills in the frontmatter. Gates are those of `standards/verification/verification.md`, named
> by the transition they guard; this list never restates them.

## Pre-Conditions

- [ ] Read `.claude/CLAUDE.md` and `.claude/MEMORY.md`, then this folder's `CONTEXT.md` and `CLAUDE.md`. · _sonnet_
- [ ] Every planned section `promoted` with zero flags, every marker pair filled, and the document renders. · _sonnet_
- [ ] Brief, client's facts, precedence, related documents and any previous version read. · _opus_

## Execution Checklist

**Structure (`draft → structural-review → fact-check`)**

- [ ] V2 and V3 (draft → structural-review) dated; status moved to `structural-review` in the brief and the `.tex` block together. · _sonnet_
- [ ] `structure-review` run, forked, with the business lenses; synthesis written to `planning/src/reviews/`, marked advice only. · _opus_
- [ ] Findings put to the author; each agreed change reopened through `02-adapt-a-draft` or `03-improve-your-draft` and promoted again through `04-promote-a-section`. · _opus_
- [ ] A material change cleared its gate and every later one, and stepped the status back (`standards/verification/verification.md` Section 3); any other reopened section had the stages already passed run again over it. · _opus_
- [ ] V4 (structural-review → fact-check) dated; status moved to `fact-check`. · _sonnet_

**Facts (`fact-check → line-edit`)**

- [ ] **Every figure, date, price, service level, entity detail, statute and framework reference verified or flagged `VERIFY`.** · _opus_
- [ ] Evidence entries written in `research/src/evidence/`; counterparty checked against the public register. · _opus_
- [ ] `clause-consistency` run: terms defined once, references resolve, precedence stated. · _opus_
- [ ] `obligation-check` run: every modal intended, every commitment traced or flagged new, no unbounded 'will'. · _opus_
- [ ] Findings resolved with the author; V5 (fact-check → line-edit), V5.1 and V5.2 dated; status moved to `line-edit`. · _sonnet_

**The line (`line-edit → final`)**

- [ ] `comprehension` run as the brief's reader; findings reported by location. · _opus_
- [ ] `flow` run; agreed changes applied. · _opus_
- [ ] `tone` run; **no figure, date, scope boundary or commitment changed by it.** · _opus_
- [ ] `grammar` and `spelling` run as a supportive report; accepted corrections applied. · _opus_
- [ ] Every correction applied in the `.tex` directly also made in its section's draft and logged in its ledger entry; `make section-check` clean for that section. · _sonnet_

**The register, then the issue proof**

- [ ] Registered before the issue proof via `planning/workflows/08-update-the-register/`: `DOC-NNN` issued, row at Status `Draft`, review-schedule row where the document has a cycle. · _sonnet_
- [ ] The `DOC-NNN` written into the Document Control Reference and the brief's `number`. · _sonnet_
- [ ] `make flags SCOPE=<path>.tex` empty; no `\dnote`, `\fillme`, redline mark or `[AWAITING USER INPUT]` left. · _sonnet_
- [ ] Disclaimer matches the disclaimers file (`00-project.md ## Paths`) word for word; Document Control and version history complete; register row present (V6.2). · _opus_
- [ ] Issue proof rendered and read in full. · _opus_

**Final**

- [ ] **The author's word, in words: final.** · _opus_
- [ ] V6 (line-edit → final), V6.1 and V6.2 dated; `final` set in the brief and the `.tex` block; Document Control Status as the author confirmed. · _sonnet_
- [ ] The author's word, dated, added to `.claude/MEMORY.md` `## Status`. · _sonnet_
- [ ] Issue PDF placed beside the `.tex`, same basename (`make pdf FILE=<path>.tex ISSUE=1`, never `FORCE=1` without the author's word); none for an authored email. · _sonnet_
- [ ] Approval recorded via `planning/workflows/07-record-an-approval/` where the document is approved or executed; the register Status moved on from `Draft` only on the author's word. · _sonnet_
- [ ] Handed back: status, paths, register ID, review file, corrections, reopened sections, waivers; sending left to the author. · _opus_

## Done When

- [ ] **Every gate from `draft` to `final` has passed in order and is dated in the brief.** · _opus_
- [ ] The author made the document `final` in words, and zero flags remain. · _opus_
- [ ] The issue PDF sits beside the `.tex`, and the register records the document. · _sonnet_
- [ ] Nothing has been sent, signed or published on the author's behalf. · _opus_
