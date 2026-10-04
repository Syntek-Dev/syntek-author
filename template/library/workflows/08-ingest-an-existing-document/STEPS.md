---
workflow: 08-ingest-an-existing-document
phase: convert
skills: [adapt-section, fact-check, grill-with-docs]
model: opus
---

# STEPS.md — ingest an existing document

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for bringing an existing document into the library: file the original
unchanged, make a reading copy, then register it as a record or bring it into the house form
through the loop. Each step names the skill and guide it uses. **Run in order** — the ordering is
load-bearing — and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The
> `adapt-section` skill carries this procedure's conversion and adaptation; read its `BUSINESS.md`
> mode file too.

## 1. Establish what the document is, and what it is for

> **Skill:** `adapt-section` · **Guide:** `library/docs/reference/versioning-and-the-register.md`

Ask the author three things: what the document is (its family and type); who wrote it (the author,
a client, a third party); and what it is for: a **record** to keep as it stands, a **working
source** to revise into a new version or a new document, or a **template seed** to turn into a
reusable template. _Substantive._

## 2. Decide where it lives, and check nothing is overwritten

> **Skill:** — · **Guide:** `library/docs/reference/versioning-and-the-register.md`

Choose its folder: the family root for the business's own document,
`library/src/<family>/templates/` for a template seed, or
`library/src/<family>/client-docs/<client-slug>/` for a client's; the email family files by
correspondent instead (its folder's CONTEXT.md sets the layout). Name it to the house kebab-case
pattern, keeping any version and date the document itself states. Check that no file of that name
exists; if one does, stop and ask. _Mechanical._

## 3. File the original unchanged

> **Skill:** — · **Guide:** `library/docs/reference/document-anatomy.md`

Copy the original into place, byte for byte. Never open and re-save it. Add it to the folder's
`CONTEXT.md` listing, with its original filename if it was renamed. _Mechanical._

## 4. Make the reading copy

> **Skill:** `adapt-section` · **Guide:** `library/docs/reference/latex-deliverables.md`

Beside the original, under the same basename with the suffix `.reading.md`:

```sh
pandoc <name>.docx -t markdown -o <name>.reading.md
pdftotext -layout <name>.pdf <name>.reading.md
```

The suffix marks it as derived, never issued: Drive sync, where the project has it, never pushes
or pulls a `.reading.md` file. A `.tex` or `.md` original is already text and needs no reading
copy. If the tool is missing, say so and stop. A scanned PDF with no text layer yields an empty
file: delete it, and ask the author for a text source; never retype from an image. _Mechanical._

## 5. Check the reading copy against the original

> **Skill:** `adapt-section` · **Guide:** `library/docs/reference/document-anatomy.md`

Compare them part by part: headings, clause numbering, tables, footnotes, every figure and date,
signatures and dates of execution. Write an internal note at the top of the reading copy,
`<!-- INTERNAL NOTE: … -->`, naming the original and listing everything the conversion lost or
garbled, by location. Never repair a loss from memory. _Substantive._

## 6. A record: register it, and stop

> **Skill:** — · **Guide:** `library/docs/reference/versioning-and-the-register.md`

For a record, run `planning/workflows/08-update-the-register/` with the details the document
states, confirmed by the author; its Status is the author's call, and Executed only with a signed
copy filed. For an executed instrument, also run `planning/workflows/07-record-an-approval/`. Then
hand back (step 11). _Mechanical._

## 7. A working source or template seed: plan the unit

> **Skill:** `grill-with-docs` · **Guide:** `library/docs/reference/document-anatomy.md`

Run `planning/workflows/01-plan-a-unit/`. The brief names the original in `## Draws on`, maps its
parts onto planned sections in the house order of `document-anatomy.md`, notes any part the house
form requires that the original lacks, and answers the five questions. _Substantive._

## 8. Split it into section drafts

> **Skill:** `adapt-section` · **Guide:** `library/docs/reference/section-anatomy.md`

Write one draft per planned section in the family's `drafts/<unit-slug>/`, its text copied word
for word from the reading copy: `status: author-draft`, `origin: author`, and an internal note
naming the source file and who wrote the text. Create each ledger entry with `## AI original`
empty. A planned section with no counterpart in the original is left for
`library/workflows/01-draft-a-section/`. _Mechanical._

## 9. Check what it claims

> **Skill:** `fact-check` · **Guide:** `research/docs/reference/vetting-evidence.md`

Verify the figures, dates, entity details, statutes and framework references the drafts carry
before anything relies on them; an old document's facts may have been true once. Flag each claim
not verified with `<!-- VERIFY: … -->` in its draft. _Substantive._

## 10. Bring it into the house form

> **Skill:** `adapt-section` · **Guide:** `library/docs/reference/document-anatomy.md`

Run `library/workflows/02-adapt-a-draft/` on each draft, with the author's instructions: bring it
into the house parts and order, the house terminology and the style sheet; for a template seed,
replace every client value with a placeholder. Every change to a term or an obligation is listed
for `obligation-check` and the author. Promotion (`library/workflows/04-promote-a-section/`) and
review (`library/workflows/05-review-a-document/`) follow as for any document.
_Substantive._

## 11. Hand back

> **Skill:** `adapt-section` · **Guide:** `library/docs/reference/versioning-and-the-register.md`

Report where the original and its reading copy were filed, every conversion loss, and then either
the register row written (a record) or the brief and drafts created, the claims flagged and the
next procedure (a working source or template seed). _Substantive._
