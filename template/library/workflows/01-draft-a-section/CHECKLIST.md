---
workflow: 01-draft-a-section
phase: produce
skills: [draft-section, grill-with-docs, fact-check, spelling]
model: opus
---

# CHECKLIST.md — draft a section of a document

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `library/docs/reference/section-anatomy.md` and the `draft-section` skill. Gates are
> those of `standards/verification/verification.md`, named by the transition they guard; this list
> never restates them.

## Pre-Conditions

- [ ] Read `.claude/CLAUDE.md` and `.claude/MEMORY.md`, then this folder's `CONTEXT.md` and `CLAUDE.md`. · _sonnet_
- [ ] Confirmed with the author which document and which section: slug and `order` from the brief's `sections:` list. · _opus_
- [ ] The brief's status is not `idea` (V1 dated); otherwise stopped: the brief is not agreed (`planning/workflows/01-plan-a-unit/`). · _sonnet_
- [ ] Unit brief read: Scope, What this unit does, Sections, Obligations and defined terms, Draws on, Draft notes. · _opus_
- [ ] Family folder pair and family standard read; for a client document, the client's facts (`## Facts` in `library/src/business/client-docs/<client-slug>/CONTEXT.md`, or where `00-project.md ## Paths` says) read. · _opus_

## Execution Checklist

**Before drafting a word**

- [ ] **The five questions answered in the brief:** legal name, jurisdiction, audience, existing material, tone. · _opus_
- [ ] Standards read: `standards/method/` (with `BUSINESS.md`), the style trio, samples; brand voice for running copy; precedence for an instrument. · _opus_
- [ ] Every document the section must agree with read, including the document's already-promoted sections. · _opus_
- [ ] **Every figure, date, name and reference sourced before drafting:** from the author, MEMORY, the client's facts, or `fact-check` into `research/src/evidence/`. · _opus_
- [ ] No existing draft or ledger entry will be clobbered; if one exists, stopped and confirmed with the author. · _sonnet_
- [ ] Draft file and ledger entry created with complete frontmatter. · _sonnet_

**Drafting**

- [ ] The section the brief planned, and only that: the point first, then the detail, the limit, the way forward. · _opus_
- [ ] One sentence per line; heading present if the section starts a new part of the document. · _opus_
- [ ] Defined terms used exactly as defined; in an instrument, every 'shall', 'may' and 'must' intended. · _opus_
- [ ] **No price, date, service level, statute or client detail supplied by the AI:** each gap flagged `AUTHOR TO CONFIRM` or `VERIFY`. · _opus_
- [ ] Any authorised deviation recorded in an internal note under the frontmatter. · _opus_
- [ ] Register right: formal for an instrument or policy, brand voice for running copy, the business's person. · _opus_

**Recording and hand-back**

- [ ] `spelling` and `grammar` run; the draft's own slips fixed; no em dashes in client copy. · _sonnet_
- [ ] AI original copied verbatim into the ledger entry; `drafted` date set. · _sonnet_
- [ ] Brief updated: section at `ai-draft`; document moved from `outlined` to `draft` if this is its first section. · _sonnet_
- [ ] Handed back: path, word count, every flag with its reason, open questions, any step waived and why, the suggested next procedure. · _opus_

## Done When

- [ ] **A single draft sits at `library/src/<family>/drafts/<unit-slug>/<NN>-<section-slug>.md` at `ai-draft`, doing the job the brief gave it.** · _opus_
- [ ] Every fact in it is sourced, and every gap is flagged rather than filled. · _opus_
- [ ] The ledger entry holds the AI original exactly as handed to the author. · _sonnet_
- [ ] The draft has not been promoted; promotion waits for the author's word. · _opus_
