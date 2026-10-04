# CONTEXT.md — library/src/business/client-docs/

Business documents for one client at a time, in one folder per client, `<client-slug>/`: the
client's proposals, quotes, statements of work, guides and meeting notes, every version kept. The
slug is short, kebab-case and the same in every family. This folder is where each client's facts
live: the one place every other family, and every skill, reads them from.

## Directory Tree

```text
library/src/business/client-docs/
├── CONTEXT.md              ← this file (add a tree line for each client folder)
├── CLAUDE.md               ← operating rules
└── <client-slug>/          ← one folder per client, with its own CONTEXT.md and CLAUDE.md
```

## What's here

- Nothing yet. A client folder is created the first time a client appears in any family.
- **The facts live here.** Each client folder's `CONTEXT.md` carries a `## Facts` section: the
  legal entity as the public register shows it, its registered number, the address for notices,
  the date and source of each check, and contacts by role as the author supplies them. A blank
  contact means 'not confirmed', never 'unknown': it is not filled in from a website.
- **Each client folder carries its pair.** Its `CONTEXT.md` also lists the documents in it, one
  bullet each: the file, its register ID once it has one, its status and what it is. Its
  `CLAUDE.md` holds the rules particular to this client: a required format, a standing
  instruction, a recipient's recorded preference (the preference alone, never a personal reason).
- **Units.** A client that is one legal entity with units working with the business separately
  takes `<client-slug>/<unit-slug>/` folders, each with its pair; the facts stay at the client
  level, and each unit's folder records only what differs.
- **Every version stays.** A revised document is a new file beside the old one; the register and
  the Document Control block say which is current.

## Cross-references

- `library/src/CLAUDE.md` — one home per fact, and the rule for new client folders.
- `library/docs/reference/versioning-and-the-register.md` — versioned filenames in a client folder.
- `planning/src/document-register.md` — the register rows for the documents filed here.
