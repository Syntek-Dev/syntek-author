---
workflow: 10-create-a-business-document
phase: produce
skills: [business-documents, run-workflow, grill-with-docs, fact-check, draft-section, promote-section, build]
model: opus
---

# STEPS.md — create a business document

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for taking a new business-family document from the author's request to an
issued `final`. Each step names the skill and guide it uses. **Run in order** — the ordering is
load-bearing — and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). Load the
> `business-documents` skill before step 1; it is this family's half of the procedure.

## 1. Identify the document

> **Skill:** `business-documents` · **Guide:** `library/docs/reference/business-standards.md`

Confirm with the author what the document is, by the standard's types table; whom it is for; and
what it must achieve. A document that belongs to another family goes to that family's create
procedure; one that fits no family goes back to the author before anything is written.
_Substantive._

## 2. Check what already exists

> **Skill:** `run-workflow` · **Guide:** `library/docs/reference/versioning-and-the-register.md`

Search `planning/src/document-register.md`, `planning/src/units/` and the client's folder for a
document of the same type for the same client. If one has been circulated, this is a new version
of it: open the version as the guide says and continue from step 6 with its brief. Read any earlier
document to the same client: it is the voice and the terms this one must agree with. _Mechanical._

## 3. Settle the client and its facts

> **Skill:** `fact-check` · **Guide:** `research/docs/reference/vetting-evidence.md`

For a client document, find the client's folder in `library/src/business/client-docs/`, or the
facts home `00-project.md ## Paths` names. For a new client, confirm the slug with the author,
create the folder with its pair, and fill `## Facts` from the public register and the author, each
fact with its date and source. Never take an entity detail from the client's own website.
_Substantive._

## 4. Decide the place and the name

> **Skill:** `business-documents` · **Guide:** `library/docs/reference/business-standards.md`

A client's document goes in `client-docs/<client-slug>/`, the business's own at the family root, a
template in `templates/`. Name it to the standard's pattern: `v1-0` for a new versioned document,
no version for a living one. Confirm nothing at that path will be overwritten. _Mechanical._

## 5. Plan it

> **Skill:** `grill-with-docs` · **Guide:** `library/docs/reference/document-anatomy.md`

Run `planning/workflows/01-plan-a-unit/`. The brief's `sections:` list covers every body part the
standard requires for the type, in its order; the parts filled from data (Document Control, the
disclaimer, the signature block) are noted, not planned as sections. Settle scope, price and dates
with the author now: they are the author's, never the AI's. Nothing is drafted until V1
(idea → outlined) is dated. _Substantive._

## 6. Choose the starting point

> **Skill:** `business-documents` · **Guide:** `library/docs/reference/latex-deliverables.md`

If a template in `library/src/business/templates/` fits, the document starts from it, and each
section is adapted through `library/workflows/02-adapt-a-draft/`. Otherwise it starts from the
house skeleton `00-project.md ## Paths` names, which `library/workflows/04-promote-a-section/`
copies at the first promotion, with the status block and one marker pair per planned section.
_Mechanical._

## 7. Write it, one section at a time

> **Skill:** `draft-section` · **Guide:** `library/docs/reference/drafting-with-ai.md`

For each planned section, in order: `library/workflows/01-draft-a-section/` (or the author drafts
it and `library/workflows/03-improve-your-draft/` follows); the author's notes through
`library/workflows/02-adapt-a-draft/`; then, on the author's word,
`library/workflows/04-promote-a-section/`. Hand back after each section. Every price, date and
service level stays flagged until the author gives it. _Substantive._

## 8. Review it to final

> **Skill:** `run-workflow` · **Guide:** `library/docs/reference/the-status-ladders.md`

When every planned section is promoted, run `library/workflows/05-review-a-document/` in full: it
checks the structure, the facts and the line, registers the document, and makes it `final` only
on the author's word. At its structural review, check the standard's required parts for the type;
at its fact check, every commitment against the instrument that will carry it; before `final`,
the disclaimer where the class carries one. _Substantive._

## 9. Hand back

> **Skill:** `business-documents` · **Guide:** `library/docs/reference/business-standards.md`

Confirm the issue PDF made at the end of the review sits beside the `.tex`, and list the document
in its client folder's `CONTEXT.md`. Report its path, register ID, status, anything outstanding and
any step waived with the author's reason. Sending, signing and publishing are the author's acts;
where the project syncs with Google Drive, only the issued copy is ever pushed. _Mechanical._
