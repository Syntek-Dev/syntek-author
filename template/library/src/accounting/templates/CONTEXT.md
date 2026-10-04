# CONTEXT.md — library/src/accounting/templates/

Reusable starting points for accounting documents: for example an invoice, a credit note, a
financial report, a budget. Each is a `.tex` file built from the house skeleton (the one
`00-project.md ## Paths` names), holding the structure and standard wording a new document starts
from, with every client-specific value left as a placeholder. A template holds no client's data and
no agreed number; a document made from one lives in `library/src/accounting/client-docs/`.

## Directory Tree

```text
library/src/accounting/templates/
├── CONTEXT.md                  ← this file (add a tree line for each template)
├── CLAUDE.md                   ← operating rules
└── template-<doc-type>.tex     ← one per reusable document type (none yet)
```

## What's here

- Nothing yet. A template earns its place when the same kind of document has been written twice.
- **Placeholders.** `[BRACKETED]` fields for facts; negotiable numbers as `{[}value{]}` in LaTeX,
  which renders as `[value]`, so no placeholder can be mistaken for an agreed term.
- **Registered, not versioned.** A template is listed in the register with version `—` and reviewed
  on its cycle: yearly, or when the law or the business's standard position changes.
- **The invoice template carries every required field** of
  `library/docs/reference/accounting-standards.md`. The business's own details and bank details
  are entered in it by the author, and appear nowhere else in the repository.

## Cross-references

- `library/docs/reference/latex-deliverables.md` — the skeleton every template starts from.
- `library/workflows/02-adapt-a-draft/` — turning a template into a client document.
- `library/docs/reference/accounting-standards.md` — the parts a template must carry.
