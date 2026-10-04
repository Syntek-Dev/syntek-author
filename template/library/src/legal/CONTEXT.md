# CONTEXT.md — library/src/legal/

The legal family: the instruments that bind the business and its counterparties. Agreements and
master services agreements, non-disclosure agreements, data processing agreements, service level
agreements, terms and conditions, privacy notices, amendments and variations live here, and so do
the formal letters served under them: a notice of termination, a payment plan, a demand. A notice
served under a contract is an instrument, never correspondence. The client's facts are cited from
`library/src/business/client-docs/<client-slug>/CONTEXT.md`, never copied here.

## Directory Tree

```text
library/src/legal/
├── CONTEXT.md              ← this file
├── CLAUDE.md               ← operating rules
├── templates/              ← counterparty-neutral instruments, template-<doc-type>.tex
├── client-docs/            ← one <client-slug>/ folder per counterparty
└── drafts/                 ← section drafts, one <unit-slug>/ folder per document (README.md only)
```

## What's here

- **Client instruments** — `<doc-type>-<client-slug>-v<major>-<minor>-<DD-MM-YYYY>.tex` in
  `client-docs/<client-slug>/`, the document type spelled out in kebab-case
  (master-services-agreement, nda, data-processing-agreement, service-level-agreement and so on).
- **Negotiation copies** — `<doc-type>-<client-slug>-redline-v<major>-<minor>-<DD-MM-YYYY>.tex`,
  carrying `\ins`, `\del` and `\cmt` marks; never the version that is signed.
- **Signed copies** — the executed PDF as received, beside its `.tex`, with `-signed` before the
  extension. It is the record of execution and is never edited or re-rendered.
- **Letters under an instrument** — `<letter-type>-<client-slug>-<DD-MM-YYYY>.tex`, unversioned.
- **The business's own instruments** (its standard terms, its privacy notice) at the family root.
- **Types, parts, naming and review cycles** are in
  `library/docs/reference/legal-standards.md`.

## Cross-references

- `library/docs/reference/legal-standards.md` — this family's standard.
- `library/workflows/11-create-a-legal-document/` — the procedure that makes an instrument here.
- `library/docs/reference/latex-deliverables.md` — the `clause` list, labels and `\ref`.
- `planning/src/precedence.md` — the order of governance in each family of instruments.
- `planning/workflows/07-record-an-approval/` — recording execution.
