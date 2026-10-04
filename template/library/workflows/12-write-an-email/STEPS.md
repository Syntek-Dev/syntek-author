---
workflow: 12-write-an-email
phase: produce
skills: [email-documents, business-documents, run-workflow, grill-with-docs, draft-section, promote-section, tone, obligation-check]
model: opus
---

# STEPS.md — write an email

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for taking one email from the author's request to an authored email waiting
at Draft. Each step names the skill and guide it uses. **Run in order** — the ordering is
load-bearing — and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). Load
> `email-documents` before step 1, then, at step 1, the skill of the family that governs the
> email's substance.

## 1. Identify the correspondent and the governing family

> **Skill:** `email-documents` · **Guide:** `library/docs/reference/email-standards.md`

Confirm with the author whom the email is to, what it is about, and the one thing it asks or
tells. Decide the family leaf by the engagement that owns the matter (a covering email for a
proposal goes under the business leaf), load that family's skill (`<family>-documents`), and note
the call in the internal note when it is not obvious. A formal notice under a contract is an
instrument: route it to the legal family where this project has that family; otherwise raise it
with the author. _Substantive._

## 2. Read the record

> **Skill:** `email-documents` · **Guide:** `library/docs/reference/email-standards.md`

Read the correspondent's facts (a client's under `## Facts` in
`library/src/business/client-docs/<client-slug>/CONTEXT.md`, or the facts home
`00-project.md ## Paths` names ('Client facts'); a supplier's in its matter folder),
its folder's `CLAUDE.md` for any recorded preference, the archived threads on the matter, and
**every other unsent email to the same correspondent, together**. List any contradiction for the
author before writing a word. _Substantive._

## 3. Settle the folder

> **Skill:** `email-documents` · **Guide:** `library/docs/reference/EMAIL-ANATOMY-AND-NAMING.md`

Find `library/src/email/client-emails/<client-slug>/<family>/` or
`library/src/email/supplier-emails/<matter-slug>/`. A missing client folder, family leaf or matter
folder is created only with the author's confirmation, with its pair at once and the client's slug
from its business folder. _Mechanical._

## 4. Plan the one section

> **Skill:** `grill-with-docs` · **Guide:** `library/docs/reference/section-anatomy.md`

Run `planning/workflows/01-plan-a-unit/` in its shortest form: one section, `body`; the brief
records the correspondent, the matter, the ask, every fact the email will state with its source,
and what it must not promise. Nothing is drafted until V1 (idea → outlined) is dated. _Substantive._

## 5. Write the body

> **Skill:** `draft-section` · **Guide:** `library/docs/reference/drafting-with-ai.md`

Run `library/workflows/01-draft-a-section/` for the body (or the author writes it and
`library/workflows/03-improve-your-draft/` follows), and the author's notes through
`library/workflows/02-adapt-a-draft/`. Lead with the decision or the ask; answer what the reader
would ask anyway; a follow-up recites no undertaking, counts no time and denies no chasing.
_Substantive._

## 6. Settle the subject line and write the file's fixed parts

> **Skill:** `email-documents` · **Guide:** `library/docs/reference/EMAIL-ANATOMY-AND-NAMING.md`

Settle the subject (the matter first, 50 characters or fewer, 60 at most), name the file from it,
and create the authored email at its path: the frontmatter, the title, the metadata block with
`**Status:**` at Draft, the internal note (decisions, dated sources, departures, anything to
resolve), the rule, the subject, and the empty `body` marker pair. _Mechanical._

## 7. Promote the body

> **Skill:** `promote-section` · **Guide:** `library/docs/reference/section-anatomy.md`

On the author's word, run `library/workflows/04-promote-a-section/`: the body goes between its
markers, and its ledger entry is completed. _Mechanical._

## 8. Review it

> **Skill:** `tone` · **Guide:** `library/docs/reference/email-standards.md`

Run `library/workflows/05-review-a-document/` on the email: its stages are short for one section.
`obligation-check` traces every commitment to its instrument; `tone` reads it as its recipient
will; the email checklist in `EMAIL-ANATOMY-AND-NAMING.md` is worked through; the email is
registered. An email has no issue PDF: its step for the issue copy is recorded as not applying.
_Substantive._

## 9. Hand back

> **Skill:** `email-documents` · **Guide:** `library/docs/reference/email-standards.md`

Read every other unsent email to the same correspondent once more beside this one. List the email
in its folder's `CONTEXT.md`; regenerate any paste copy the project makes. Report the path, the
subject line, every flag and any contradiction found. The email waits at Draft: sending, and
moving `**Status:**` to sent, are the author's. _Mechanical._
