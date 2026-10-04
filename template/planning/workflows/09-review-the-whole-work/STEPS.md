---
workflow: 09-review-the-whole-work
phase: review
skills: [structure-review, grill-with-docs]
model: opus
---

# STEPS.md — review the whole work

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for a structural review of the whole work, written as advice. Each step
names the skill and guide it uses. **Run in order** — the ordering is load-bearing — and tick
`CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The
> `structure-review` skill runs steps 3 and 4; read it and its mode file first.

## 1. Fix the scope and the question

> **Skill:** `structure-review` · **Guide:** `planning/docs/reference/reviews-are-advice.md`

Agree with the author what is under review (the whole work, one part, one family) and what they
most want to know. Name the scope as the review file will: `whole-work` or the part's name.
_Substantive._

## 2. Read the plan and the record

> **Skill:** `structure-review` · **Guide:** `planning/docs/reference/reviews-are-advice.md`

Read the project brief (`00-project.md` `## Paths`, 'Project brief') and the stated reader
(`00-project.md` `## Brief`), `.claude/MEMORY.md` (Decisions, Open questions, mapped in
`00-project.md` `## Memory headings`), `planning/src/outline.md`, every unit brief in scope, the
doc type's plans in `planning/src/`, open maps, and the most recent review of the same scope.
Note which units exist as prose and which only as plans. _Substantive._

## 3. Run the lenses

> **Skill:** `structure-review` · **Guide:** `planning/docs/reference/reviews-are-advice.md`

Run each lens the mode file names, in a forked context, over the content layer and the plans in
scope. Each lens reports what works and what does not, by location, without seeing the others'
verdicts first. _Substantive._

## 4. Synthesise, keeping the dissent

> **Skill:** `structure-review` · **Guide:** `planning/docs/reference/reviews-are-advice.md`

Gather the verdicts. Where lenses agree, state the finding once. Where they disagree, record both
under the honest dissent. Turn each finding that needs the author into a numbered open decision,
and each agreed remedy into a next step naming the procedure that would carry it out.
_Substantive._

## 5. Write the review

> **Skill:** `structure-review` · **Guide:** `planning/docs/reference/reviews-are-advice.md`

Write `planning/src/reviews/REVIEW-<scope>-DD-MM-YYYY.md` in the guide's shape, with the
advice-only status line, and name the earlier review it supersedes, if any. _Mechanical
(writing); the content is substantive._

## 6. Put the open decisions to the author

> **Skill:** `grill-with-docs` · **Guide:** `planning/docs/reference/reviews-are-advice.md`

Present the open decisions in order. For each, the author accepts, rejects or defers. Record what
passes the memory gate in `.claude/MEMORY.md`, dated and citing the review; deferred items go to
`Open questions` (mapped in `00-project.md` `## Memory headings`). Record nothing the author has
not decided. _Substantive._

## 7. Hand on

> **Skill:** `structure-review` · **Guide:** `planning/docs/reference/reviews-are-advice.md`

List the accepted next steps in order, each with its procedure: a re-plan through
`01-plan-a-unit`, a change of order in `planning/src/outline.md`, a decision map through
`wayfinder`, a revision through the content layer's workflows. Start none of them unless the
author asks. _Substantive._
