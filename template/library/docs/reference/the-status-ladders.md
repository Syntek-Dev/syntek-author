---
type: guide
skills: [promote-section, structure-review, run-workflow]
model: opus
---

# The status ladders — where a section, a document and a register row stand

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** Three lifecycles run through every document, kept apart on purpose. A **section**
moves from first draft to promoted; a **document**, the unit here, from idea to final through
review; then the **register** Status tracks the issued document. Mixing them is how a draft gets
sent: a promoted section does not make a document final, and a final document is not yet issued.

## The section ladder

| Status | Means | Set by |
|---|---|---|
| `ai-draft` | the AI drafted it from the brief | `draft-section` |
| `author-draft` | the author drafted it | the author |
| `adapted` | revised from the author's notes or edits | `adapt-section` |
| `improved` | the author accepted some proposed improvements | `improve-section` |
| `author-revised` | the author edited it by hand since the last AI pass | the author |
| `promoted` | it sits in the document between its markers | `promote-section` |

It lives in the draft's frontmatter; the brief's `sections:` list mirrors it.

## The document ladder

| Status | The document is… | It leaves when… |
|---|---|---|
| `idea` | a name and a purpose in `planning/src/outline.md` | the author agrees its brief: V1 (idea → outlined) |
| `outlined` | planned: brief, sections, the five questions answered | its first section is drafted (no gate of its own) |
| `draft` | being written, section by section | every planned section is promoted, zero flags, and it renders: V2 and V3 (draft → structural-review) |
| `structural-review` | under structural review | the agreed structural changes are in: V4 (structural-review → fact-check) |
| `fact-check` | having its figures, terms and obligations checked | every claim is verified or cut: V5 (fact-check → line-edit) |
| `line-edit` | read for its reader, flow, tone and mechanics | the line edit passes, flags at zero, on the author's word: V6 (line-edit → final) |
| `final` | approved by the author, ready to issue | — |

The gates are numbered in `standards/verification/verification.md` and its `BUSINESS.md`; each
date goes in the brief's `verified:` map. `stub` is an alias of `outlined`, rewritten on first
touch. Only the review procedure and the author's word make a document `final`.

## Where the document status lives

The unit brief's frontmatter in `planning/src/units/` is the record. A `.tex` deliverable has no
frontmatter, so its first lines repeat the status in a comment block: `% unit: <unit-slug>`,
`% status: line-edit`, `% last_updated: DD/MM/YYYY`. A Markdown deliverable (web copy) carries
`unit:` and `status:` in its frontmatter; Drive sync, where the project has it, sends one only at
`status: final`. Each changes with the brief; where they disagree, the brief wins. An email keeps
its own `**Status:**` line (draft, then sent), which only the author moves.

## The register: a third lifecycle

A document is registered at the end of its line edit, before the issue proof (V6.2 needs the
row): a row in `planning/src/document-register.md` at Status `Draft`, and one in
`planning/src/review-schedule.md` if it has a review cycle. The row's Status then records what
happened to the issued document (Active, Executed, Superseded), and the Document Control block
prints it. `planning/docs/reference/the-document-register.md` owns that vocabulary; only the
author's word moves it.

## How we apply it here

- Never move a status two steps at once; a waived gate is recorded in the brief with its reason.
- Reopening a promoted section follows `standards/verification/verification.md` Section 3: a
  material change (a section rewritten, a claim added, the structure changed) clears that gate's
  date and every later one and steps the status back; any other agreed wording change is promoted
  again, and the stages already passed are run again over it.
- A new version of a circulated document starts at `draft`; the issued file keeps `final`.

## Who implements it

- **Skills:** `promote-section` sets `promoted`; the review chain runs `draft` to `final`, the
  last on the author's word; `run-workflow` reads the status to choose a procedure.
- **Workflows:** `library/workflows/04-promote-a-section/`,
  `library/workflows/05-review-a-document/`.

## Governing standard

`standards/verification/verification.md` owns the gates; this guide owns what each status means.
