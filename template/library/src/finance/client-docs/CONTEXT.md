# CONTEXT.md — library/src/finance/client-docs/

Finance documents for one client at a time, in one folder per client, `<client-slug>/`: a client's
invoices, receipts and credit notes, numbered in the family's yearly sequence. The slug is short,
kebab-case and the same in every family. The client's facts are not repeated here: they live once,
in `library/src/contracts/client-docs/<client-slug>/CONTEXT.md`.

## Directory Tree

```text
library/src/finance/client-docs/
├── CONTEXT.md              ← this file (add a tree line for each client folder)
├── CLAUDE.md               ← operating rules
└── <client-slug>/          ← one folder per client, with its own CONTEXT.md and CLAUDE.md
```

## What's here

- Nothing yet. A client folder is created with the first document for that client.
- **Each client folder carries its pair.** Its `CONTEXT.md` lists the documents in it, one bullet
  each: the file, its register ID once it has one, its status and what it is. Its `CLAUDE.md`
  holds the rules particular to this client, such as a required format or a standing instruction.
- **An issued invoice is never edited.** A correction is a credit note filed beside it.

## Cross-references

- `library/src/CLAUDE.md` — one home per fact, and the rule for new client folders.
- `library/docs/reference/versioning-and-the-register.md` — versioned filenames in a client folder.
- `planning/src/document-register.md` — the register rows for the documents filed here.
