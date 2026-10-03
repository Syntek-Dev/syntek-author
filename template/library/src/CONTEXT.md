# CONTEXT.md — library/src/

The documents themselves: the only human-facing files in the library. Every proposal, contract,
policy, letter, financial document and piece of marketing copy the business produces lives here,
filed by family. Section drafts live here too, in each family's drafts folder, until the author
promotes them. Plans, registers and research do not: they live in `planning/` and `research/`.

## Directory Tree

```text
library/src/
├── CONTEXT.md              ← this file
├── CLAUDE.md               ← operating rules
├── proposals/              ← proposals, quotes, tender responses
├── contracts/              ← agreements, statements of work, NDAs, amendments; client facts
├── policies/               ← the business's own policies and procedures; client policy suites
├── correspondence/         ← letters (.tex) and authored emails (.md)
├── finance/                ← invoices, financial reports, budgets, forecasts
└── marketing/              ← marketing plans, website and campaign copy, case studies, posts
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

## What's here

- **The family folders.** A document belongs to the family of its purpose, not its format: a
  letter terminating a contract is correspondence; the variation it attaches is a contract.
- **Client folders.** A client has the same `<client-slug>` in every family. The client's facts
  (legal entity, registered number, address for notices, contacts by role) live once, in
  `library/src/contracts/client-docs/<client-slug>/CONTEXT.md`, and every other folder cites it.
- **Drafts.** A section draft is a Markdown file at
  `library/src/<family>/drafts/<unit-slug>/<NN>-<section-slug>.md`. A drafts folder carries only
  its `README.md` and the drafts; it has no pair and is excluded from every build.
- **Derived files.** A rendered PDF sits beside its `.tex` under the same basename once issued;
  a Word copy likewise if one was sent. An ingested original has its reading copy beside it as
  `<name>.reading.md`. None is ever edited by hand.
- **Drive copies.** Where the project syncs with Google Drive, a pull never overwrites a file here:
  a Drive copy that differs is saved beside it as `<name>.drive-DD-MM-YYYY.<ext>` for the author
  to compare. It is never pushed, built or promoted; the author decides what to keep, then deletes
  it.

## Cross-references

- `library/docs/reference/document-anatomy.md` — the parts every document carries, by family.
- `library/docs/reference/versioning-and-the-register.md` — versioned filenames and superseding.
- `library/docs/reference/latex-deliverables.md` — the skeleton, the markers and rendering.
- `planning/src/units/` — the unit brief each document here is written from.
- `planning/src/precedence.md` — which document wins when two in a family disagree.
