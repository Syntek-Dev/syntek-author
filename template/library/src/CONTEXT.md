# CONTEXT.md — library/src/

The documents themselves: the only human-facing files in the library. Every document the business
produces lives here, filed by family: proposals, statements of work and client guides in
`business/`<: if DOC_TYPE == 'business' and 'legal' in BUSINESS_FAMILIES :>;
contracts, NDAs, data processing agreements and terms in `legal/`<: endif :><: if DOC_TYPE == 'business' and 'email' in BUSINESS_FAMILIES :>;
client and supplier correspondence in `email/`<: endif :><: if DOC_TYPE == 'business' and 'accounting' in BUSINESS_FAMILIES :>;
invoices, expenses and financial reports in `accounting/`<: endif :><: if DOC_TYPE == 'business' and 'social-media' in BUSINESS_FAMILIES :>;
social media plans, content calendars and profiles in `social-media/`<: endif :><: if DOC_TYPE == 'business' and 'msp-scp' in BUSINESS_FAMILIES :>;
IT policies, plans and reports for managed-service clients in `msp-scp/`<: endif :>.
Section drafts live here too, in each family's drafts folder, until the author promotes them.
Plans, registers and research do not: they live in `planning/` and `research/`.

## Directory Tree

```text
library/src/
├── CONTEXT.md              ← this file
├── CLAUDE.md               ← operating rules
<: if DOC_TYPE == 'business' and 'legal' in BUSINESS_FAMILIES :>├── legal/                  ← contracts, NDAs, data processing agreements, terms, notices
<: endif :><: if DOC_TYPE == 'business' and 'email' in BUSINESS_FAMILIES :>├── email/                  ← client and supplier correspondence, authored and archived
<: endif :><: if DOC_TYPE == 'business' and 'accounting' in BUSINESS_FAMILIES :>├── accounting/             ← invoices, expenses, financial reports, budgets, forecasts
<: endif :><: if DOC_TYPE == 'business' and 'social-media' in BUSINESS_FAMILIES :>├── social-media/           ← social media plans, content calendars, profiles and bios
<: endif :><: if DOC_TYPE == 'business' and 'msp-scp' in BUSINESS_FAMILIES :>├── msp-scp/                ← IT policies, plans and reports for managed-service clients
<: endif :>└── business/               ← always: proposals, statements of work, client guides; clients' facts
```

Every family has the same shape:

```text
library/src/<family>/
├── CONTEXT.md · CLAUDE.md  ← the family's documents, naming and rules
├── <document>.tex          ← the business's own documents, at the family root
├── templates/              ← reusable starting points, template-<doc-type>.tex
├── client-docs/            ← one <client-slug>/ folder per client, each with its own pair
└── drafts/                 ← section drafts, one <unit-slug>/ folder per document; README.md
```

<: if DOC_TYPE == 'business' and 'email' in BUSINESS_FAMILIES :>The email family files by correspondent instead of by client document: in
`email/client-emails/` and `email/supplier-emails/`.

<: endif :>## What's here

- **The family folders.** A document belongs to the family of its purpose, not its format, and
  each family's standard is `library/docs/reference/<family>-standards.md`. The families this
  project uses were chosen when it was generated (`BUSINESS_FAMILIES`); `business` is always one.
- **Client folders.** A client has the same `<client-slug>` in every family. The client's facts
  (legal entity, registered number, address for notices, contacts by role) live once, under
  `## Facts` in `library/src/business/client-docs/<client-slug>/CONTEXT.md`, or wherever
  `00-project.md ## Paths` names instead, and every other folder cites them.
- **Drafts.** A section draft is a Markdown file at
  `library/src/<family>/drafts/<unit-slug>/<NN>-<section-slug>.md`. A drafts folder carries only
  its `README.md` and the drafts; it has no pair and is excluded from every build.
- **Derived files.** A rendered PDF sits beside its `.tex` under the same basename once issued.
  A Word copy that is sent is copied from `build/` beside its source on the author's word, named
  as the issued PDF, and committed with it. An ingested original has its reading copy beside it as
  `<name>.reading.md`. None is ever edited by hand.
- **Drive copies.** Where the project syncs with Google Drive, a pull never overwrites a file here:
  a Drive copy that differs is saved beside it as `<name>.drive-DD-MM-YYYY.<ext>` for the author
  to compare. It is never pushed, built or promoted; the author decides what to keep, then deletes
  it.

## Cross-references

- `library/docs/reference/document-anatomy.md` — the parts every document carries.
- `library/docs/reference/versioning-and-the-register.md` — versioned filenames and superseding.
- `library/docs/reference/latex-deliverables.md` — the skeleton, the markers and rendering.
- `library/workflows/` — the create workflow for each family, and the loop every document runs.
- `planning/src/precedence.md` — which document wins when two in a family disagree.
