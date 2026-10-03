---
workflow: 08-update-the-register
phase: plan
skills: []
model: opus
---

# STEPS.md — update the register

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for adding, changing or retiring one register row and carrying the change
into the schedule and the precedence table. Each step names the guide it uses. **Run in order**
— the ordering is load-bearing — and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`), then the writing
> rules at the top of `planning/src/document-register.md`.

## 1. Name the change

> **Skill:** none · **Guide:** `planning/docs/reference/the-document-register.md`

Confirm with the author what happened: a new document, a status change, a new version, or a
retirement. Confirm the document's name and its path under `library/src/`. _Substantive._

## 2. Read the register

> **Skill:** none · **Guide:** `planning/docs/reference/the-document-register.md`

Read `planning/src/document-register.md` in full. Note the highest `DOC-NNN` ever issued,
including retired rows, and the family heading the document belongs under. _Mechanical._

## 3. Find or create the row

> **Skill:** none · **Guide:** `planning/docs/reference/the-document-register.md`

For an existing document, find its row by ID. For a new one, issue the next ID and add a row
under its family's heading, with `Draft` status until it is approved, signed or issued.
_Mechanical._

## 4. Apply the change

> **Skill:** none · **Guide:** `planning/docs/reference/the-document-register.md`

Fill every column in order, with the values the guide accepts. A new version keeps its ID: move
the row's Version, File Path and dates to the new file. For a retirement, set `Archived`,
`Superseded` or `Terminated` and say in `Notes` why, and what replaced it. Delete nothing.
Update `Last Updated`. _Mechanical._

## 5. Mirror any stated precedence

> **Skill:** none · **Guide:** `planning/docs/reference/the-document-register.md`

If the document is an instrument that states an order of precedence, add or update the rows in
`planning/src/precedence.md`, each citing the clause that states it. If the order it states
conflicts with another instrument, report it to the author; do not resolve it here. The
`clause-consistency` skill checks these rows against the instruments at the document's next
review. _Substantive._

## 6. Update the review schedule

> **Skill:** none · **Guide:** `planning/docs/reference/the-document-register.md`

For a new document with a review cycle, add its row to `planning/src/review-schedule.md`. For a
changed date, update the row. For a retirement, ask the author whether to mark the row `N/A` or
remove it. Update `Last Updated` if anything changed. _Mechanical._

## 7. Link the brief, and hand back

> **Skill:** none · **Guide:** `planning/docs/reference/unit-briefs.md`

For a new registration, set `number` in the document's unit brief to its `DOC-NNN`, and hand
the `DOC-NNN` back to the procedure that called this one, which writes it into the document's
Document Control reference before the issue proof. Read the changed rows back to the author and
confirm them. _Mechanical (the edit); the confirmation is substantive._
