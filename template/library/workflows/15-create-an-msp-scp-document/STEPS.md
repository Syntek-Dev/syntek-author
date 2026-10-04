---
workflow: 15-create-an-msp-scp-document
phase: produce
skills: [msp-scp-documents, run-workflow, grill-with-docs, fact-check, draft-section, promote-section, obligation-check, build]
model: opus
---

# STEPS.md — create a managed-service document

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for a new managed-service document, on its policy route or its report route.
Each step names the skill and guide it uses. **Run in order** — the ordering is load-bearing — and
tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). Load the
> `msp-scp-documents` skill before step 1; it is this family's half of the procedure.

## 1. Identify the document and its route

> **Skill:** `msp-scp-documents` · **Guide:** `library/docs/reference/msp-scp-standards.md`

Confirm with the author the type, by the standard's table, and so the route: a policy or an
operational document (the loop) or a report (filled from its template). Confirm whose it is: the
business's suite, or a client's (its facts read under `## Facts` in
`library/src/business/client-docs/<client-slug>/CONTEXT.md`, or the facts home
`00-project.md ## Paths` names ('Client facts')). _Substantive._

## 2. Check what already exists

> **Skill:** `run-workflow` · **Guide:** `library/docs/reference/versioning-and-the-register.md`

Search `planning/src/document-register.md` and `planning/src/review-schedule.md`. A live policy due
its review goes to `planning/workflows/06-run-a-review-cycle/`; an approved policy that must change
gets a new version. Read every policy in the suite this one must agree with. _Mechanical._

## 3. Settle who it binds and who owns it

> **Skill:** `grill-with-docs` · **Guide:** `library/docs/reference/MSP-SCP-POLICY-SUITE.md`

Confirm with the author whom the document binds, who owns it, who approves it, its classification,
and what the business (or the client) actually does today. A gap between practice and the rule the
author wants is raised now, never papered over in the text. _Substantive._

## 4. Decide the place and the name

> **Skill:** `msp-scp-documents` · **Guide:** `library/docs/reference/msp-scp-standards.md`

The business's suite goes at the family root; a client's documents in `client-docs/<client-slug>/`
and its reports in `client-docs/<client-slug>/reports/`. A policy takes its suite number from
`MSP-SCP-POLICY-SUITE.md`; name it to the standard's pattern; confirm nothing will be overwritten.
_Mechanical._

## 5. Policy route: plan it

> **Skill:** `grill-with-docs` · **Guide:** `library/docs/reference/document-anatomy.md`

Run `planning/workflows/01-plan-a-unit/`. The brief's sections follow the policy structure: purpose
and scope; one section per rule area; roles and responsibilities; compliance and enforcement;
review and approval. The Document Control block, the review-date notice and the version history
are filled from data. Nothing is drafted until V1 (idea → outlined) is dated. _Substantive._

## 6. Policy route: write it, one rule area at a time

> **Skill:** `draft-section` · **Guide:** `library/docs/reference/drafting-with-ai.md`

For each planned section, in order: `library/workflows/01-draft-a-section/` (or a template in
`library/src/msp-scp/templates/` adapted through `library/workflows/02-adapt-a-draft/`); then, on
the author's word, `library/workflows/04-promote-a-section/`, into a `.tex` from the house skeleton
(`00-project.md ## Paths`). Every rule is a must or shall statement; every alignment note names a
control verified against the framework's current edition. _Substantive._

## 7. Policy route: review, approve, schedule

> **Skill:** `obligation-check` · **Guide:** `library/docs/reference/the-status-ladders.md`

Run `library/workflows/05-review-a-document/` in full, with `obligation-check` on every
must-statement and `fact-check` on every framework and legal reference. Before `final`:
classification in the Document Control block and in the running header, set with
`\houseclassification{<level>}` after `\begin{document}`; the review-date notice; the version
history. Then `planning/workflows/07-record-an-approval/`; the policy becomes Active only once the
approval is recorded, with its row in `planning/src/review-schedule.md`. _Substantive._

## 8. Report route: fill, proof and confirm it

> **Skill:** `build` · **Guide:** `library/docs/reference/MSP-SCP-POLICY-SUITE.md`

Copy the family template from `library/src/msp-scp/templates/`, or, where none exists yet, the
LaTeX skeleton `00-project.md ## Paths` names (by default `tooling/latex/skeleton.tex`), carrying
every part `MSP-SCP-POLICY-SUITE.md` lists for the report. Fill each from the records the author
supplies: no figure, time or cause invented. Render and read it through
`library/workflows/06-build-a-proof/`. Before issue, `make flags SCOPE=<path>.tex` lists nothing,
and no `\fillme`, `\dnote` or redline mark remains; only then, on the author's confirmation, set
its status to `final` and make the issue copy with `make pdf FILE=<path>.tex ISSUE=1`.
_Mechanical._

## 9. Hand back

> **Skill:** `msp-scp-documents` · **Guide:** `library/docs/reference/msp-scp-standards.md`

List the document in its folder's `CONTEXT.md`. Report its path, status, register ID, approval and
next review date, every `VERIFY` resolved or left, and any step waived with its reason. Sending a
report or a policy to a client is the author's act. _Mechanical._
