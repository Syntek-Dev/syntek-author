# CONTEXT.md — library/src/contracts/

The contracts family: the instruments that bind the business and its counterparties. Agreements,
statements of work, non-disclosure agreements, data processing agreements, service level
agreements, amendments and variations live here. This family is also the **home of each client's
facts**: every client folder here holds, in its `CONTEXT.md`, the legal entity, registered number,
address for notices and contacts by role that every other family cites. Letters about a contract
live in `library/src/correspondence/`.

## Directory Tree

```text
library/src/contracts/
├── CONTEXT.md              ← this file
├── CLAUDE.md               ← operating rules
├── templates/              ← counterparty-neutral instruments, template-<doc-type>.tex
├── client-docs/            ← one <client-slug>/ folder per counterparty; its CONTEXT.md holds the facts
└── drafts/                 ← section drafts, one <unit-slug>/ folder per instrument (README.md only)
```

## What's here

- **Client instruments** — `<doc-type>-<client-slug>-v<major>-<minor>-<DD-MM-YYYY>.tex` in
  `client-docs/<client-slug>/`, where the document type is spelled out in kebab-case
  (master-services-agreement, statement-of-work, nda, data-processing-agreement and so on).
- **Negotiation copies** — `<doc-type>-<client-slug>-redline-v<major>-<minor>-<DD-MM-YYYY>.tex`,
  carrying `\ins`, `\del` and `\cmt` marks; never the version that is signed.
- **Signed copies** — the executed PDF as received, beside its `.tex`, with `-signed` before the
  extension. It is the record of execution and is never edited or re-rendered.
- **The business's own instruments** (its standard terms, for example) at the family root.
- **Parts.** Parties, background, definitions and interpretation, numbered clauses, precedence,
  signature block, schedules: `library/docs/reference/document-anatomy.md`.

## Cross-references

- `library/docs/reference/latex-deliverables.md` — the `clause` list, labels and `\ref`.
- `planning/src/precedence.md` — the order of governance in each family of instruments.
- `planning/workflows/07-record-an-approval/` — recording execution.
- `standards/style/terminology.md` — defined terms shared across the family of documents.
