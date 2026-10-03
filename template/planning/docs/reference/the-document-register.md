---
type: guide
skills: [structure-review, promote-section, clause-consistency]
model: opus
---

# The document register — registers, versions, reviews and approvals

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** Four records in `planning/src/` track every document's life after it is
written: the register (`document-register.md`), the review schedule (`review-schedule.md`), the
approval records (`planning/src/approvals/`) and the stated precedence between instruments
(`precedence.md`). Together they answer, for any document, what it is, which version is
current, who approved it, when it is next reviewed and what it gives way to.

## Two lifecycles, never merged

The **writing status** lives in the unit brief and climbs the unit ladder to `final`. The
**register Status** is the publication lifecycle, and it starts at registration, just before
`final`: `Draft` from registration until the document is approved, signed or issued, then
`Active`, `Executed` or `Completed`, and later `Under Review`, `Superseded`, `Archived` or
`Terminated`.

## The register

- IDs are `DOC-NNN`, assigned in sequence, permanent and never reused.
- A document is registered at the end of its line edit, before the issue proof
  (`library/workflows/05-review-a-document/`), with Status `Draft`; the business gate V6.2
  requires its row. Its `DOC-NNN` goes into the brief's `number` and the document's Document
  Control reference then, so the issued file carries it.
- Rows are never deleted; a retired document is set to `Archived`, `Superseded` or `Terminated`.
- Rows are grouped by family, in the order the register's headings give.
- Registered: instruments, policies, proposals, plans, reports, procedures, notices, templates
  and correspondence. Not registered: individual invoices, receipts, bank statements and raw
  data exports, which are financial records.

## Versions in the register

`library/docs/reference/versioning-and-the-register.md` owns when a change is a new version and
how its file is named. The register records the result: a new version keeps its `DOC-NNN`, and
the row's Version, File Path and dates move to the new file. A document replaced by a different
document is set to `Superseded`, and its `Notes` name the replacement. After a new version,
update in this order: Document Control version, Last Reviewed, Next Review, the version-history
row, then the register row, then the review-schedule row.

## Reviews and approvals

- Review cycles: `Quarterly`, `Bi-Annual` (every six months), `Annual`, `As-Required`. A row
  whose Next Review Date has passed without completion is `Overdue`, and is reported to the
  author before anything else is done.
- An approval record, `planning/src/approvals/approval-<doc-type>-DD-MM-YYYY.md`, is made
  when an instrument is signed by all parties, a policy is approved as `Active`, or a notice is
  issued; never for templates, drafts, proposals, invoices or reports. It names each approver,
  the date, the version, the scope and the method, and leaves no field guessed.

## How we apply it here

- Every edit to a register file updates its `Last Updated` line.
- Precedence is stated in the instruments themselves; `precedence.md` mirrors them and never
  settles a conflict the instruments leave open. That is an `AUTHOR TO CONFIRM` flag.
- Owner and approver names come from the author, never from inference.

## Who implements it

- **Workflows:** `planning/workflows/06-run-a-review-cycle/`,
  `planning/workflows/07-record-an-approval/` and `planning/workflows/08-update-the-register/`;
  the library's review workflow registers a document before its issue proof.
- **Skills:** `structure-review` reviews a due document; `promote-section` fills a new version's
  file; `clause-consistency` checks stated precedence.

## Governing standard

`standards/method/BUSINESS.md` owns stated precedence and the drafting principles;
`standards/verification/verification.md` owns the `final` gate. The standards own the
requirement; this guide owns the record-keeping that runs from registration onwards.
