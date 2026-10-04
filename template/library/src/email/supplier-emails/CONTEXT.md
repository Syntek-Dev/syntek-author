# CONTEXT.md — library/src/email/supplier-emails/

Correspondence with suppliers: the businesses this business buys from or asks to quote. A sibling
of `client-emails/`, filed by **matter** rather than by supplier: a quote round is read as a
comparison, so its emails belong side by side, one folder per matter, `<matter-slug>/`. Suppliers
are not clients: they have no folder in `library/src/business/client-docs/`, so each matter
folder's `CONTEXT.md` holds the verified details of the suppliers it writes to.

## Directory Tree

```text
library/src/email/supplier-emails/
├── CONTEXT.md              ← this file (add a tree line for each matter folder)
├── CLAUDE.md               ← operating rules
└── <matter-slug>/          ← one folder per matter (a quote round, a purchase), with its pair
```

## What's here

- Nothing yet. A matter folder is created with the first email that needs it.
- **No family leaf.** In `client-emails/` the leaf names the governing standard; here the matter
  folder's `CONTEXT.md` states it (buying equipment or a service is usually a business matter).
- **Supplier facts.** Each matter folder's `CONTEXT.md` carries the suppliers' details under
  `## Facts`, with the date and source of every fact.
- **The consequence to hold:** one supplier's correspondence on two matters sits in two folders.
  A business that would rather file by supplier records that choice in `00-project.md`
  `## Overrides` before the second matter is opened.

## Cross-references

- `library/docs/reference/email-standards.md` — anatomy, subject lines and naming.
- `library/src/email/client-emails/` — the client correspondence beside this folder.
