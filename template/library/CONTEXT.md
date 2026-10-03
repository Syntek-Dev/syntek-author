# CONTEXT.md — library/

The library is this project's content layer: every document the business sends, signs, publishes
or keeps on file lives here, with the guides that explain how it is made and the procedures that
make it. A **unit** here is a document (a proposal, a contract, a policy, a letter). A **section**
is one small passage of it, typically 300–500 words, drafted, revised and approved on its own.
What does **not** live here: a document's plan (its unit brief, in `planning/src/units/`), the
register and review schedule (`planning/src/`), research notes (`research/src/`) and the rules
every document obeys (`standards/`).

## Directory Tree

```text
library/
├── CONTEXT.md              ← this file
├── CLAUDE.md               ← operating rules
├── docs/                   ← guides: reference/ (template-owned) and project/ (yours)
├── src/                    ← the documents, one folder per family
│   ├── proposals/          ← proposals, quotes, tender responses
│   ├── contracts/          ← agreements, statements of work, NDAs, amendments
│   ├── policies/           ← the business's own policies and client policy suites
│   ├── correspondence/     ← letters (.tex) and emails (.md)
│   ├── finance/            ← invoices, financial reports, budgets, forecasts
│   └── marketing/          ← plans, website and campaign copy, case studies
└── workflows/              ← procedures 01–08, plus local/ for your own
```

## What's here

- `docs/` — guidance Claude reads before writing; never human-facing. `docs/reference/` ships with
  the template and is updated by `copier update`; `docs/project/` is yours, and a same-named guide
  there overrides the reference one.
- `src/` — the documents themselves, the only human-facing files in this layer. Each family holds
  the business's own documents at its root, reusable templates in `src/<family>/templates/`, one
  `src/<family>/client-docs/<client-slug>/` folder per client, and `src/<family>/drafts/` for
  sections not yet promoted.
- `workflows/` — the numbered procedures that run the authoring loop on a document, from drafting a
  section to building a proof. Your own procedures go in `workflows/local/`.

## Key concepts

- **How a document is made.** It is planned in a unit brief
  (`planning/workflows/01-plan-a-unit/`), written section by section in its family's drafts folder
  (workflows 01–03), promoted into its deliverable on the author's word (04), then reviewed (05):
  entered in the register at the end of its line edit, and made `final` on the author's word.
- **The deliverable.** A LaTeX `.tex` file built from `tooling/latex/skeleton.tex`, rendered to PDF;
  authored emails are Markdown. Section drafts are always Markdown with frontmatter.
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
