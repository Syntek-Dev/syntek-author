# CONTEXT.md — library/src/legal/client-docs/

Legal documents for one client at a time, in one folder per client, `<client-slug>/`: the
instruments agreed with one counterparty, their negotiation copies and signed copies, and the
letters served under them, every version kept. The slug is short, kebab-case and the same in every
family. The client's facts are not repeated here: they live once, under `## Facts` in
`library/src/business/client-docs/<client-slug>/CONTEXT.md` (or where `00-project.md ## Paths`
says).

## Directory Tree

```text
library/src/legal/client-docs/
├── CONTEXT.md              ← this file (add a tree line for each client folder)
├── CLAUDE.md               ← operating rules
└── <client-slug>/          ← one folder per client, with its own CONTEXT.md and CLAUDE.md
```

## What's here

- Nothing yet. A client folder is created with the first document for that client.
- **Each client folder carries its pair.** Its `CONTEXT.md` lists the documents in it, one bullet
  each: the file, its register ID once it has one, its status and what it is. Its `CLAUDE.md`
  holds the rules particular to this client, such as a required format or a standing instruction.
- **Every version stays.** A revised document is a new file beside the old one; the register and
  the Document Control block say which is current.
- **Signed copies stay beside their source.** The executed PDF, as received, is filed beside its
  `.tex` with `-signed` before the extension, and is never edited or re-rendered.

## Cross-references

- `library/src/CLAUDE.md` — one home per fact, and the rule for new client folders.
- `library/src/business/client-docs/` — where the client's facts live.
- `library/docs/reference/versioning-and-the-register.md` — versioned filenames in a client folder.
