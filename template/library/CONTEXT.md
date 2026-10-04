# CONTEXT.md — library/

The library is this project's content layer: every document the business sends, signs, publishes
or keeps on file lives here, with the guides and standards that explain how it is made and the
procedures that make it. A **unit** here is a document (a proposal, an agreement, an email, a
report, a policy). A **section** is one small passage of it, typically 300–500 words, drafted,
revised and approved on its own. What does **not** live here: a document's plan (its unit brief,
in `planning/src/units/`), the register and review schedule (`planning/src/`), research notes
(`research/src/`) and the rules every document obeys (`standards/`).

## Directory Tree

```text
library/
├── CONTEXT.md              ← this file
├── CLAUDE.md               ← operating rules
├── docs/                   ← guides and standards: reference/ (template-owned), project/ (yours)
├── src/                    ← the documents, one folder per family
│   ├── business/           ← proposals, statements of work, client guides; the clients' facts
<: if DOC_TYPE == 'business' and 'legal' in BUSINESS_FAMILIES :>│   ├── legal/              ← contracts, NDAs, data processing agreements, terms, notices
<: endif :><: if DOC_TYPE == 'business' and 'email' in BUSINESS_FAMILIES :>│   ├── email/              ← client and supplier correspondence
<: endif :><: if DOC_TYPE == 'business' and 'accounting' in BUSINESS_FAMILIES :>│   ├── accounting/         ← invoices, expenses, financial reports, budgets
<: endif :><: if DOC_TYPE == 'business' and 'social-media' in BUSINESS_FAMILIES :>│   ├── social-media/       ← social media plans, calendars, profiles
<: endif :><: if DOC_TYPE == 'business' and 'msp-scp' in BUSINESS_FAMILIES :>│   ├── msp-scp/            ← IT policies, plans and reports for managed-service clients
<: endif :>│   └── CONTEXT.md · CLAUDE.md
└── workflows/              ← the authoring loop, a create procedure per family, and local/
```

## What's here

- `docs/` — guidance Claude reads before writing; never human-facing. `docs/reference/` ships with
  the template and is updated by `copier update`; it holds the six library guides and the
  standard of each family. `docs/project/` is yours, and a same-named guide there overrides the
  reference one.
- `src/` — the documents themselves, the only human-facing files in this layer. Each family holds
  the business's own documents at its root, reusable templates in `src/<family>/templates/`, one
  folder per client (`client-docs/<client-slug>/`; correspondence files by correspondent instead),
  and `src/<family>/drafts/` for sections not yet promoted.
- `workflows/` — the numbered procedures: the authoring loop every document runs, from drafting a
  section to building a proof, and the create procedure of each family, which settles the
  document's type, place and parts and then drives the loop. Your own procedures go in
  `workflows/local/`.

## Key concepts

- **How a document is made.** Its family's create procedure settles its type and place; it is
  planned in a unit brief (`planning/workflows/01-plan-a-unit/`), written section by section in its
  family's drafts folder (`library/workflows/01-draft-a-section/`, then
  `library/workflows/02-adapt-a-draft/` or `library/workflows/03-improve-your-draft/`), promoted
  into its deliverable on the author's word (`library/workflows/04-promote-a-section/`), then
  reviewed (`library/workflows/05-review-a-document/`): entered in the register at the end of its
  line edit, and made `final` on the author's word.
- **The deliverable.** A LaTeX `.tex` file built from the house skeleton `00-project.md ## Paths`
  names, rendered to PDF; authored emails and copy for a platform are Markdown. Section drafts are
  always Markdown with frontmatter.
- **Three lifecycles.** A section's status, a document's status and a register row's Status are
  different things; `library/docs/reference/the-status-ladders.md` keeps them apart.
- **Supersede, never rewrite.** A circulated document is a record; a change opens a new version
  file (`library/docs/reference/versioning-and-the-register.md`).

## Cross-references

- `.claude/rules/syntek-author/01-layout-and-routing.md` — every layer, the pair rule and its
  exceptions, ownership classes and read order.
- `.claude/rules/syntek-author/03-authorship.md` — who decides what, the two flags, provenance.
- `planning/src/units/` — the unit briefs every document here is written from.
- `planning/src/document-register.md` — where a finished document is recorded.
- `standards/method/BUSINESS.md` — the drafting principles every document here obeys.
