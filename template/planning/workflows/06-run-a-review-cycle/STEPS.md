---
workflow: 06-run-a-review-cycle
phase: review
skills: [structure-review, fact-check]
model: opus
---

# STEPS.md — run a review cycle

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for reviewing the registered documents that are due. Each step names the
skill and guide it uses. **Run in order** — the ordering is load-bearing — and tick
`CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The
> `structure-review` skill runs step 4.

## 1. Find what is due

> **Skill:** none · **Guide:** `planning/docs/reference/the-document-register.md`

Read `planning/src/review-schedule.md` in full. List every row whose Next Review Date is today or
earlier and whose Status is `Scheduled` or `Overdue`. Report the `Overdue` rows to the author
first, then confirm which documents are in scope for this cycle. _Mechanical (listing); the
scope is the author's call._

## 2. Read each document and its record

> **Skill:** none · **Guide:** `planning/docs/reference/the-document-register.md`

For each document in scope, read its register row (path, version, status) and then the document
at that path under `library/src/`, including its Document Control block and version history.
_Mechanical._

## 3. Read what governs it

> **Skill:** none · **Guide:** `planning/docs/reference/the-document-register.md`

Read its family's standard, `library/docs/reference/<family>-standards.md`, and the other guides
in `library/docs/reference/` that cover it (and any override in `library/docs/project/`),
`standards/method/BUSINESS.md`, and, where the document carries a disclaimer,
`standards/brand/disclaimers.md` (or the file `00-project.md` `## Paths` names instead). Where no
guide covers the family, say so in the review. _Substantive._

## 4. Review it

> **Skill:** `structure-review` · **Guide:** `planning/docs/reference/reviews-are-advice.md`

Assess the document for content that is no longer true (services, prices, contacts,
legislation, entities, suppliers), for structure against its guide, and for a present and
correct Document Control block, version history and disclaimer. Every claim about the outside
world goes to `fact-check` and carries `VERIFY` until checked. Write the result to
`planning/src/reviews/REVIEW-<document-slug>-DD-MM-YYYY.md`, advice only. _Substantive._

## 5. Put the review to the author

> **Skill:** `structure-review` · **Guide:** `planning/docs/reference/reviews-are-advice.md`

Present the findings and the open decisions. The author decides, item by item: no change,
change, or defer. Record decisions that pass the memory gate in `.claude/MEMORY.md` through
`grill-with-docs`. _Substantive._

## 6. Carry agreed changes into a new version

> **Skill:** none · **Guide:** `planning/docs/reference/the-document-register.md`

If the author agreed changes, decide with them whether the new version is MAJOR or MINOR, open
it as `library/docs/reference/versioning-and-the-register.md` describes, and revise its sections
through the library's authoring loop (`library/workflows/02-adapt-a-draft/` or
`library/workflows/03-improve-your-draft/`, then `library/workflows/04-promote-a-section/`). The
new version then passes the review, `library/workflows/05-review-a-document/`, before it is
issued; its register step moves the row to the new file. If nothing changes, the document is
confirmed current as it stands. _Substantive._

## 7. Update the register

> **Skill:** none · **Guide:** `planning/docs/reference/the-document-register.md`

In `planning/src/document-register.md`, update the row by its ID: Last Reviewed, Next Review
Date, and Status if it changed. A new version's Version and File Path were moved by the review's
register step; confirm they name the new file. The ID does not change with the version. Update
`Last Updated`. _Mechanical._

## 8. Update the review schedule

> **Skill:** none · **Guide:** `planning/docs/reference/the-document-register.md`

In `planning/src/review-schedule.md`, set Last Review Date to today, Next Review Date by the
row's cycle, and Status to `Completed`. Update `Last Updated`. _Mechanical._

## 9. Record a re-approval, and hand back

> **Skill:** none · **Guide:** `planning/docs/reference/the-document-register.md`

If the review ended in formal re-approval, run `07-record-an-approval`. Report to the author
what was reviewed, what changed, what was deferred and when each document is next due.
_Substantive._
