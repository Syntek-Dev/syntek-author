# BUSINESS.md — handoff, business mode

What a document library's handoff must never drop: anything unsent, unregistered, unrendered or
contradictory, because that is where the real hazards of business writing live.

## Paths and unit

- **Unit:** a document in `library/src/<family>/`, the family being one this project selected
  (`business`, `legal`, `email`, `accounting`, `social-media`, `msp-scp`), with its section drafts
  in `library/src/<family>/drafts/<unit-slug>/`; its brief is
  `planning/src/units/<document-slug>.md`.
- **Client facts:** the client facts path in `00-project.md` `## Paths` (by default
  `library/src/business/client-docs/<client-slug>/CONTEXT.md`, under `## Facts`).
- **Anchors** for in-flight work point into the section draft, the `.tex` deliverable between its
  `% section:` markers, the brief, or the document's row in `planning/src/document-register.md`.

## Additions to the steps

- **Step 1 — also** record a client fact the session learned under the client's `## Facts`, and a
  new or changed document in the register, before writing the handoff.
- **Step 4 — also** say which draft is live and which is superseded, by path, for every document
  touched.
- **Step 5 — also carry what is unsent or unregistered.** The part is headed
  `## Unsent or unregistered` and names, each with its path and what blocks it:
  - every drafted message not yet sent;
  - every document without its `DOC-NNN` row, or whose row is out of date;
  - every `.tex` whose PDF has not been rebuilt since its last edit;
  - every approval still awaited;
  - every contradiction between two drafts, or between a draft and a signed instrument.
- **Step 8 — also** never paste a client's contact details, credentials, figures or private
  correspondence; name and locate them.

## Domain rules

- **A stale PDF is a hazard, not a detail.** A rendered document that no longer matches its source
  will be sent by someone; list it.
- **Two contradicting unsent messages** are the most dangerous state a library can be in; they
  head the list.
- **Prices and dates are referenced, never restated.** The handoff points at the line that holds
  them, so a figure cannot drift between the document and the handoff.

## Examples

```markdown
## Unsent or unregistered

- Unsent: the cover note for the support proposal
  (library/src/business/drafts/support-proposal/01-cover-note.md); it contradicts the
  proposal's own timeline on the start date. Resolve before either is sent.
- Unregistered: the support proposal has no DOC-NNN row yet (planning/src/document-register.md).
- Unrendered: library/src/business/templates/statement-of-work.tex edited after its last PDF.
- Awaiting approval: the pricing, planning/src/approvals/ (none recorded yet).
```
