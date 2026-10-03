# CONTEXT.md — library/src/contracts/templates/

Reusable starting points for contract documents: for example a master services agreement, a
statement of work, a non-disclosure agreement, a data processing agreement. Each is a `.tex` file
built from `tooling/latex/skeleton.tex`, holding the structure and standard wording a new document
starts from, with every client-specific value left as a placeholder. A template holds no client's
data and no agreed number; a document made from one lives in `library/src/contracts/client-docs/`.

## Directory Tree

```text
library/src/contracts/templates/
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
- **Counterparty-neutral.** The parties appear as placeholders. A template states the
  business's standard position, and every departure from it in a client instrument is flagged
  for `obligation-check` and the author.

## Cross-references

- `tooling/latex/skeleton.tex` — the skeleton every template starts from.
- `library/workflows/02-adapt-a-draft/` — turning a template into a client document.
- `library/docs/reference/document-anatomy.md` — the parts a template must carry.
