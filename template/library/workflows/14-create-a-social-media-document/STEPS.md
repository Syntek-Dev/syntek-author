---
workflow: 14-create-a-social-media-document
phase: produce
skills: [social-media-documents, run-workflow, fact-check, grill-with-docs, draft-section, promote-section, tone]
model: opus
---

# STEPS.md — create a social media document

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for taking a new social media document from the author's request to
`final`. Each step names the skill and guide it uses. **Run in order** — the ordering is
load-bearing — and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). Load the
> `social-media-documents` skill before step 1; it is this family's half of the procedure.

## 1. Identify the document

> **Skill:** `social-media-documents` · **Guide:** `library/docs/reference/social-media-standards.md`

Confirm with the author the type, by the standard's table; whose it is (the business's or a
client's); the period; the platforms in scope; the reader; and the one thing each piece should
make them do. _Substantive._

## 2. Check what already exists

> **Skill:** `run-workflow` · **Guide:** `library/docs/reference/versioning-and-the-register.md`

Search `planning/src/document-register.md` and the folder for the current plan, calendar or guide
of the same kind. A new plan or calendar supersedes the last at its period's end; a revised guide
is a new version. Read the current one, and the brand voice in the brand folder
`00-project.md ## Paths` names. _Mechanical._

## 3. Gather the evidence and the permissions

> **Skill:** `fact-check` · **Guide:** `research/docs/reference/vetting-evidence.md`

List every claim the piece will make and find its evidence (`research/src/evidence/`), or mark it
to be cut. For every client to be named, quoted or shown, confirm that written permission is
recorded in the Approvals path (`00-project.md` `## Paths`; by default `planning/src/approvals/`);
without it, the client is not named. Check each platform's current limits and record the date
checked. _Substantive._

## 4. Decide the place and the name

> **Skill:** `social-media-documents` · **Guide:** `library/docs/reference/social-media-standards.md`

The business's own documents go at the family root; a client's in `client-docs/<client-slug>/`,
its facts read under `## Facts` in `library/src/business/client-docs/<client-slug>/CONTEXT.md`, or
the facts home `00-project.md ## Paths` names ('Client facts'). Name it to the standard's pattern,
the platform and the period in the name where the pattern asks. _Mechanical._

## 5. Plan it

> **Skill:** `grill-with-docs` · **Guide:** `library/docs/reference/document-anatomy.md`

Run `planning/workflows/01-plan-a-unit/`. The brief's sections cover the parts the standard
requires for the type: for a plan, the overview, the pillars, one section per platform, the KPIs;
for profiles, one section per platform. Nothing is drafted until V1 (idea → outlined) is dated.
_Substantive._

## 6. Write it, one section at a time

> **Skill:** `draft-section` · **Guide:** `library/docs/reference/drafting-with-ai.md`

For each planned section, in order: `library/workflows/01-draft-a-section/` (or the author drafts
and `library/workflows/03-improve-your-draft/` follows); the author's notes through
`library/workflows/02-adapt-a-draft/`; then, on the author's word,
`library/workflows/04-promote-a-section/`, into a `.tex` from the house skeleton
(`00-project.md ## Paths`) or a Markdown file for copy handed to a platform. _Substantive._

## 7. Review it to final

> **Skill:** `tone` · **Guide:** `library/docs/reference/the-status-ladders.md`

When every planned section is promoted, run `library/workflows/05-review-a-document/` in full. At
its fact check, every claim against its evidence; at its line edit, `tone` against the brand voice
(or, for a client's guide, the client's voice). Before `final`: platforms named as they name
themselves, emoji only in example copy, every named client permitted. _Substantive._

## 8. Hand back

> **Skill:** `social-media-documents` · **Guide:** `library/docs/reference/social-media-standards.md`

List the document in its folder's `CONTEXT.md`. Report its path, status, register ID where it has
one, every claim cut for want of evidence, and any step waived with its reason. Publishing,
scheduling and posting are the author's acts. _Mechanical._
