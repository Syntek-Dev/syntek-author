---
workflow: 11-create-a-legal-document
phase: produce
skills: [legal-documents, run-workflow, fact-check, grill-with-docs, draft-section, promote-section, clause-consistency, obligation-check]
model: opus
---

# STEPS.md — create a legal document

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for taking a new instrument from the author's request to `final` and, on the
author's word, execution. Each step names the skill and guide it uses. **Run in order** — the
ordering is load-bearing — and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). Load the
> `legal-documents` skill before step 1; it is this family's half of the procedure.

## 1. Identify the instrument

> **Skill:** `legal-documents` · **Guide:** `library/docs/reference/legal-standards.md`

Confirm with the author the type, by the standard's table; the parties; what the instrument must
achieve; and whether it belongs to a family of instruments (an agreement, its statements of work,
its service levels). A covering email or a proposal is not an instrument: route it to its own
family. _Substantive._

## 2. Check what already exists

> **Skill:** `run-workflow` · **Guide:** `library/docs/reference/versioning-and-the-register.md`

Search `planning/src/document-register.md`, `planning/src/units/` and the counterparty's folders
for an instrument of the same type. If one has been sent, this is a new version: open it as the
guide says and continue from step 6. Read every instrument this one must agree with, and
`planning/src/precedence.md`. _Mechanical._

## 3. Verify the counterparty

> **Skill:** `fact-check` · **Guide:** `research/docs/reference/vetting-evidence.md`

Check the counterparty's legal name, registered number and registered address against the public
register for its jurisdiction, never its website, and record them, each with its date and source,
under `## Facts` in `library/src/business/client-docs/<client-slug>/CONTEXT.md`, or the facts home
`00-project.md ## Paths` names ('Client facts'); a new client's folder is created with its pair,
the slug confirmed with the author. Where the reader and the entity that can contract differ, say
so to the author now. _Substantive._

## 4. Decide the place and the name

> **Skill:** `legal-documents` · **Guide:** `library/docs/reference/legal-standards.md`

A client's instrument or letter goes in `client-docs/<client-slug>/`, the business's own at the
family root, a template in `templates/`. Name it to the standard's pattern; confirm nothing at
that path will be overwritten. _Mechanical._

## 5. Plan it

> **Skill:** `grill-with-docs` · **Guide:** `library/docs/reference/document-anatomy.md`

Run `planning/workflows/01-plan-a-unit/`. One section per clause group, definitions first, in the
order the standard gives; the brief's `## Obligations and defined terms` lists every term and every
obligation the author intends. Settle every negotiable value with the author, and the governing law
(the jurisdiction in `00-project.md ## Brief` unless the author decides otherwise). Record the
order of precedence in `planning/src/precedence.md` when the instrument belongs to a family. Nothing
is drafted until V1 (idea → outlined) is dated. _Substantive._

## 6. Choose the starting point

> **Skill:** `legal-documents` · **Guide:** `library/docs/reference/latex-deliverables.md`

If a template in `library/src/legal/templates/` fits, each clause group is adapted from it through
`library/workflows/02-adapt-a-draft/`, every placeholder filled from the author or the facts.
Otherwise the instrument starts from the house skeleton `00-project.md ## Paths` names, which
`library/workflows/04-promote-a-section/` copies at the first promotion. _Mechanical._

## 7. Write it, one clause group at a time

> **Skill:** `draft-section` · **Guide:** `library/docs/reference/drafting-with-ai.md`

For each planned section, in order: `library/workflows/01-draft-a-section/` (or the author drafts
and `library/workflows/03-improve-your-draft/` follows); the author's notes through
`library/workflows/02-adapt-a-draft/`; then, on the author's word,
`library/workflows/04-promote-a-section/`. Clauses use the house `clause` list and cite each other
by `\ref`, never by a typed number. _Substantive._

## 8. Review it to final

> **Skill:** `clause-consistency` · **Guide:** `library/docs/reference/legal-standards.md`

When every clause group is promoted, run `library/workflows/05-review-a-document/` in full, with
`clause-consistency` and `obligation-check` at its fact check. Before `final`: the disclaimer for
legal instruments at the top, copied unchanged; Document Control complete; governing law stated;
the signature block present; no `\dnote` left. _Substantive._

## 9. Execution and hand-back

> **Skill:** `obligation-check` · **Guide:** `library/docs/reference/versioning-and-the-register.md`

Report the instrument's path, register ID and status, and any step waived with its reason; sending
and signing are the author's acts. When the counterparty proposes changes, they come back as a
negotiation copy and a new version. When every party has signed, file the signed copy beside the
`.tex` with `-signed` before `.pdf` and run `planning/workflows/07-record-an-approval/`; Executed is
set only then. _Mechanical._
