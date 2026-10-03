# BUSINESS.md — research, business mode

Where a document library's research goes, and what counts as a primary source for a clause, a
figure, a compliance claim or an entity detail.

## Paths and unit

- **Question-led notes:** `research/src/notes/<topic>.md`, for what the law requires, what a
  regulator's guidance says, who a counterparty legally is, or what a standard's control demands.
- **Checked claims:** `research/src/evidence/`, through `fact-check`; **reading notes:**
  `research/src/sources/`.
- **Feeds:** the document's brief in `planning/src/units/` and its `DOC-NNN` in
  `planning/src/document-register.md`; a client fact found is recorded once, in the client's
  `CONTEXT.md` `## Facts` under `library/src/contracts/client-docs/`.

## Additions to the steps

- **Step 1 — also** read the client's `CONTEXT.md` and the register first: an entity detail or a
  document status already recorded is a lookup, not research.
- **Step 3 — also name the jurisdiction and the date** a legal or regulatory question must hold
  for; the default jurisdiction is in `.claude/rules/syntek-author/06-global-rules.md` Section 1.
- **Step 4 — also, the primary sources:** the legislation itself, from the official legislation
  site for the jurisdiction, never a summary of it; the regulator's own guidance (for England and
  Wales, for example, the data-protection regulator, the tax authority, the register of
  companies and the register of charities); the standard itself from its standards body; the
  counterparty's own filings on the official register; a vendor's own documentation. A law
  firm's briefing, a directory listing or the entity's own website is a scout.
- **Step 5 — also,** where two registers disagree (an address, a name, a number), record both,
  say which governs and why, and flag the detail `VERIFY` until the author confirms it.

## Domain rules

- **Verify an entity against its official register**, never against its own website or a
  directory: a wrong legal name or number on an instrument is a defect a signature cannot cure.
- **Never cite a section number not read in the statute itself**, and say plainly where the law
  is unsettled.
- **Every claim carries the date it was checked**: guidance, rates and records change, and a
  figure a client relies on must be traceable to its date.
- **No figure reaches a client-facing document without a traceable source**
  (`standards/method/BUSINESS.md` Section 7).

## Examples

```markdown
---
question: "What must a privacy notice tell a customer whose data the business collects directly?"
checked: DD/MM/YYYY
feeds: [privacy-notice]
---

## Verdict
<two or three sentences>
## Claims
- <each required item> — <the statute's article and paragraph, read on the official site>; checked DD/MM/YYYY
## Conflicts
- <the regulator's guidance against the statute's wording, both stated; the statute governs>
```
