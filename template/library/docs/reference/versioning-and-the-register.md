---
type: guide
skills: [promote-section, adapt-section, structure-review]
model: opus
---

# Versioning and the register — new files for new versions, and the record of what was issued

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** A document that has been circulated (sent, signed, published or adopted) is a
record of what its reader received. It is never rewritten. A change opens a new version in a new
file; the old file stays exactly as issued. The register then records which version is current.
Supersede, never rewrite: that one rule is what lets anyone answer 'what did we send them?' years
later.

## Version numbers

- Versions are `vMAJOR.MINOR`. The first release is always `v1.0`.
- **MAJOR** for a restructure, a change of position or of a commitment, or re-approval after a
  formal review. **MINOR** for corrections, clarifications and small additions that leave the
  position unchanged.
- Living documents (a business plan, a tracker), templates, meeting notes and emails carry no
  version: the register shows `—` for them, and an email's date in its filename is enough.

## Versioned filenames

`<doc-type>-<client-slug>-v<major>-<minor>-<DD-MM-YYYY>.tex` for a client document, and
`<doc-type>-v<major>-<minor>-<DD-MM-YYYY>.tex` for the business's own. The date is the day that
version's file was opened, and the name never changes afterwards: renaming breaks every pointer to
it. The issue date the reader sees lives in the Document Control block.

## Amend in place, or open a new version

| Situation | What to do |
|---|---|
| A change before the document has been circulated | amend in place; no new version |
| A typo or layout fix after circulation | new MINOR version |
| Any change a reader would notice after circulation | new version, MAJOR or MINOR as above |
| A different document replaces it | the new document gets its own register row; the old row is set to Superseded |

To open a new version: copy the issued `.tex` to its new versioned name; raise the Version in the
Document Control block and the brief's `version` (vMAJOR.MINOR); add a row to the version history
table; set the leading status block, and the brief's `status`, to `draft`. The previous file and
its issued PDF are never edited again. Revised sections go through the loop into the new file.

## What the register records

A document is registered before the issue proof, as the last step of line edit: a row in
`planning/src/document-register.md` with a permanent `DOC-NNN` identifier at Status `Draft`, and
a row in `planning/src/review-schedule.md` if it has a review cycle. A new version keeps its
identifier; its row's Version, File Path and dates move to the new file. Rows are never deleted.
Approval of an instrument or policy is recorded in `planning/src/approvals/`. The columns, Status
vocabulary and order of updates belong to `planning/docs/reference/the-document-register.md`.

## How we apply it here

- Before opening a new version, check the register: two live versions of one document is the
  commonest way a client signs the wrong one.
- Record the reason for a version in its history row in a sentence a client could read.
- Templates are reviewed, not versioned: a client instrument made from one names the template in
  its internal note.

## Who implements it

- **Skills:** `adapt-section` turns a template or an issued document into the next version's
  sections; `promote-section` fills the new file; `structure-review` checks the history table.
- **Workflows:** `library/workflows/05-review-a-document/` (finalisation and the register rows),
  `planning/workflows/08-update-the-register/`, `planning/workflows/07-record-an-approval/`.

## Governing standard

`standards/verification/verification.md` owns the gate a version passes to become `final`; the
planning guide owns the register's columns. This guide owns the file-level call: when a change is
a new version, and how the old one is kept.
