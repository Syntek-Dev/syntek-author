---
workflow: 13-create-an-accounting-document
phase: produce
skills: [accounting-documents, run-workflow, fact-check, grill-with-docs, draft-section, promote-section, build]
model: opus
---

# STEPS.md — create an accounting document

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for a new accounting document, on its form route or its report route. Each
step names the skill and guide it uses. **Run in order** — the ordering is load-bearing — and tick
`CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). Load the
> `accounting-documents` skill before step 1; it is this family's half of the procedure.

## 1. Identify the document and its route

> **Skill:** `accounting-documents` · **Guide:** `library/docs/reference/accounting-standards.md`

Confirm with the author the type, by the standard's table, and so the route: a form (invoice,
credit note, receipt, expense report) or a report (financial report, budget, forecast, pricing
model). For a client document, confirm the client and read its facts, under `## Facts` in
`library/src/business/client-docs/<client-slug>/CONTEXT.md`, or the facts home
`00-project.md ## Paths` names ('Client facts'). _Substantive._

## 2. Gather every figure

> **Skill:** `fact-check` · **Guide:** `research/docs/reference/vetting-evidence.md`

List every figure the document will state and take each from the author, an agreed proposal or
contract, or the books, naming the source. A price that differs from the agreement goes to the
author now. Time worked is recorded in hours and minutes. Nothing is estimated silently.
_Substantive._

## 3. Number it, for a numbered form

> **Skill:** `accounting-documents` · **Guide:** `library/docs/reference/accounting-standards.md`

Find the highest number issued this year anywhere in the family for the form's type, propose the
next, and confirm it with the author before writing it. A gap or a reuse is never made silently.
_Mechanical._

## 4. Decide the place and the name

> **Skill:** `accounting-documents` · **Guide:** `library/docs/reference/accounting-standards.md`

A client's form goes in `client-docs/<client-slug>/`; reports, budgets, forecasts, pricing models
and expense reports at the family root. Name it to the standard's pattern; confirm nothing at that
path will be overwritten. _Mechanical._

## 5. Form route: fill it from its template

> **Skill:** `accounting-documents` · **Guide:** `library/docs/reference/accounting-standards.md`

Copy the family template from `library/src/accounting/templates/`, or, where none exists yet, the
LaTeX skeleton `00-project.md ## Paths` names (by default `tooling/latex/skeleton.tex`), carrying
every field the standard requires for the type. Fill every field: none blank; the tax line as an
amount or the statement that none is charged; durations in hours and minutes; two decimal places.
Recalculate every line and every total. A field only the author can supply stays `\fillme` until
they supply it at step 6; none survives to issue. _Substantive._

## 6. Form route: proof it and confirm it

> **Skill:** `build` · **Guide:** `library/docs/reference/latex-deliverables.md`

Render and read it through `library/workflows/06-build-a-proof/`. Put the number, the amounts, the
tax line, the due date and every open `\fillme` to the author explicitly, and write in their
answers. Before issue, `make flags SCOPE=<path>.tex` lists nothing, and no `\fillme`, `\dnote` or
redline mark remains; only then, on the author's confirmation, set the leading status to `final`
and make the issue copy with `make pdf FILE=<path>.tex ISSUE=1`. _Mechanical._

## 7. Report route: plan and write it

> **Skill:** `grill-with-docs` · **Guide:** `library/docs/reference/drafting-with-ai.md`

Run `planning/workflows/01-plan-a-unit/`, its sections covering the parts the standard requires;
then each section through `library/workflows/01-draft-a-section/` (or
`library/workflows/03-improve-your-draft/`) and, on the author's word,
`library/workflows/04-promote-a-section/`. Figures go in tables; every estimate is labelled; every
figure's source goes in the notes to the figures. _Substantive._

## 8. Report route: review it to final

> **Skill:** `fact-check` · **Guide:** `library/docs/reference/the-status-ladders.md`

Run `library/workflows/05-review-a-document/` in full. At its fact check, every figure is traced
and every total recalculated; before `final`, the disclaimer for financial documents is present,
copied unchanged from the disclaimers file `00-project.md ## Paths` names. _Substantive._

## 9. Hand back

> **Skill:** `accounting-documents` · **Guide:** `library/docs/reference/accounting-standards.md`

List the document in its folder's `CONTEXT.md`. Report its path, its number or register ID, every
figure's source and anything still to confirm, and any step waived with its reason. Sending an
invoice and filing a report are the author's acts. _Mechanical._
