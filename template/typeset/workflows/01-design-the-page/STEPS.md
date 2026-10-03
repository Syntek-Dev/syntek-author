---
workflow: 01-design-the-page
phase: plan
skills: [typeset]
model: opus
---

# STEPS.md — design the page

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for settling the printed book's page design with the author. Each step names
the skill and the guide it uses. **Run in order**: trim comes first because margins, type size and
page count follow from it. Tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The `typeset`
> skill is this procedure in skill form; read its mode file before step 1.

## 1. Gather the constraints

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-house-class.md`

Read `typeset/src/page-design.md` (what is settled, what is open) and `.claude/MEMORY.md`
Decisions. Ask the author whether a printer or publisher has a specification: trim, minimum
margins, bleed, font embedding. A specification fixes the choices it covers; record it as their
reason. _Substantive._

## 2. Ask each open choice, one at a time

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-house-class.md`

In order: trim size → margins → body typeface and size → heading typeface → chapter opener and
its label → scene-break mark → footnote style → drop capitals → any choice the mode file adds.
For each: the options, a recommendation with its reason (genre conventions, the reader named in
`.claude/CLAUDE.md` Section 1, the printer's limits), then wait for the author's answer. Before
recommending a typeface, check it is installed (`fc-list`), and say the author must confirm its
licence covers print. _Substantive (the author's call)._

## 3. Record each answer in both files

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-house-class.md`

Under the choice's heading in `typeset/src/page-design.md`: the value, the reason, the date
(DD/MM/YYYY); remove its `AUTHOR TO CONFIRM` flag; add a row to the decisions table. In the same
change, set the class option in `typeset/src/book.tex`. A choice the author defers keeps its flag.
_Substantive._

## 4. Print a sample

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-typesetting-pipeline.md`

```sh
make print
```

If no chapter is typeset yet, typeset one first (`typeset/workflows/02-typeset-a-chapter/`), or
print the seeded example. Read the warnings `make print` echoes: a typeface it could not find has
fallen back, and the sample is not the design. _Mechanical._

## 5. Read the sample with the author

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-house-class.md`

Look at a chapter opening, a full text page, a scene break, a footnote and a page with a drop
capital. Ask what the author would change; go back to step 2 for anything they do. _Substantive
(the author's call)._

## 6. Date the costly decisions

> **Skill:** `typeset` · **Guide:** `typeset/docs/reference/the-house-class.md`

Add a dated line to `.claude/MEMORY.md` Decisions for any choice that is expensive to reverse:
the trim (it sets the page count and the cover), and any typeface a cover designer will match.
Report back: what was settled, what is still open, and the sample's path. _Substantive._
