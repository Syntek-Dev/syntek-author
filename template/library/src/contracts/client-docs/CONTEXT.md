# CONTEXT.md — library/src/contracts/client-docs/

Contract documents for one client at a time, in one folder per client, `<client-slug>/`: the
instruments agreed with one counterparty, their negotiation copies and signed copies. The slug is
short, kebab-case and the same in every family. This family is where each client's facts live: the
one place every other family cites them from.

## Directory Tree

```text
library/src/contracts/client-docs/
├── CONTEXT.md              ← this file (add a tree line for each client folder)
├── CLAUDE.md               ← operating rules
└── <client-slug>/          ← one folder per client, with its own CONTEXT.md and CLAUDE.md
```

## What's here

- Nothing yet. A client folder is created with the first document for that client.
- **Each client folder carries its pair.** Its `CONTEXT.md` lists the documents in it, one bullet
  each: the file, its register ID once it has one, its status and what it is. Its `CLAUDE.md`
  holds the rules particular to this client, such as a required format or a standing instruction.
- **The facts live here.** Each client folder's `CONTEXT.md` carries a `## Facts` section: the
  legal entity as the public register shows it, its registered number, the address for
  notices, the date and source of the check, and contacts by role as the author supplies them.
  Every other family cites this file and never copies it.

## Cross-references

- `library/src/CLAUDE.md` — one home per fact, and the rule for new client folders.
- `library/docs/reference/versioning-and-the-register.md` — versioned filenames in a client folder.
- `planning/src/document-register.md` — the register rows for the documents filed here.
