---
workflow: 07-record-an-approval
phase: plan
skills: []
model: opus
---

# STEPS.md — record an approval

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for recording one approval event and bringing the register into step.
Each step names the guide it uses. **Run in order** — the ordering is load-bearing — and tick
`CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). No skill runs
> this procedure; every value in it comes from the author.

## 1. Confirm the event qualifies

> **Skill:** none · **Guide:** `planning/docs/reference/the-document-register.md`

Confirm with the author what happened: a signing by every party, a policy approved as `Active`,
or a notice issued. If the document is a template, a draft, a proposal, an invoice or a report,
stop: no record is made. _Substantive._

## 2. Confirm the document

> **Skill:** none · **Guide:** `planning/docs/reference/the-document-register.md`

Find the document's row in `planning/src/document-register.md` and confirm with the author its
name, its `DOC-NNN`, the version approved (or `—`) and the date of the event. If it has no row,
run `08-update-the-register` first. _Mechanical._

## 3. Confirm who approved it

> **Skill:** none · **Guide:** `planning/docs/reference/the-document-register.md`

Ask the author for the full name, role and organisation of each approver or signatory. Never
take a name from a draft, a signature block or an earlier record without the author confirming
it for this event. _Substantive._

## 4. Confirm the scope and the method

> **Skill:** none · **Guide:** `planning/docs/reference/the-document-register.md`

Ask the author what exactly was approved, in a sentence or two, and how: `E-signature`,
`In-person`, `Email` or `Review sign-off`, with any reference the e-signature service gave.
Note any condition, caveat or linked document. _Substantive._

## 5. Write the record

> **Skill:** none · **Guide:** `planning/docs/reference/the-document-register.md`

Create the record in the Approvals path (`00-project.md` `## Paths`; by default
`planning/src/approvals/approval-<doc-type>-DD-MM-YYYY.md`), dated by the event, in the shape
that folder's `CONTEXT.md` gives (where it has none, `planning/src/approvals/CONTEXT.md`): the
heading, the date line, the `Field | Detail` table, and a `## Documents Approved` table for a
batch. Leave no field guessed and no placeholder. _Mechanical._

## 6. Update the register

> **Skill:** none · **Guide:** `planning/docs/reference/the-document-register.md`

In the document's register row, set Status to `Executed` or `Active` as the event warrants, set
Last Reviewed where the approval was a formal review, and note the record's filename in `Notes`.
Update `Last Updated`. _Mechanical._

## 7. Update the review schedule, if the event sets a date

> **Skill:** none · **Guide:** `planning/docs/reference/the-document-register.md`

If the approval starts or changes a review cycle, add or update the document's row in
`planning/src/review-schedule.md` and its `Last Updated`. Otherwise, skip this step and say so.
_Mechanical._

## 8. Hand back

> **Skill:** none · **Guide:** `planning/docs/reference/the-document-register.md`

Read the record back to the author, and report the register and schedule changes made.
_Substantive._
