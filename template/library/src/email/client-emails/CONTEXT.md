# CONTEXT.md — library/src/email/client-emails/

Client correspondence, one folder per client, `<client-slug>/`, each split by the family whose
standard governs the email's substance: `<client-slug>/<family>/`. The client slug is the one used
in `library/src/business/client-docs/`, so a client is one word everywhere. The client's facts
(entity, registered number, contacts by role) are not repeated here: they live once, under
`## Facts` in that client's business folder, or where `00-project.md ## Paths` says.

## Directory Tree

```text
library/src/email/client-emails/
├── CONTEXT.md              ← this file (add a tree line for each client folder)
├── CLAUDE.md               ← operating rules
└── <client-slug>/          ← one folder per client, with its pair
    └── <family>/           ← one leaf per governing family, created when first needed
```

## What's here

- Nothing yet. A client folder is created with the first email to that client.
- **The family leaf.** `business/` always exists as a family; any other leaf is a family this
  project uses. The leaf decides which skill and standard govern the substance, so an email is
  filed by the engagement that owns the matter, not by a fresh judgement about its subject.
- **Units.** A client that is one legal entity with units corresponding separately takes one more
  level, `<client-slug>/<unit-slug>/<family>/`, the unit slug matching the one in the client's
  business folder. Correspondence addressed to the client itself, or covering two units, sits at
  the client level. Every other client stays at two levels.
- **Each folder carries its pair.** A client folder's `CONTEXT.md` lists its leaves; a leaf's
  `CONTEXT.md` lists its emails, one bullet each: the file, its register ID, its status and what it
  is. A client folder's `CLAUDE.md` holds recipients' recorded preferences.

## Cross-references

- `library/docs/reference/email-standards.md` — anatomy, subject lines and naming.
- `library/src/business/client-docs/` — the client's facts and units.
- `planning/src/document-register.md` — the register rows for the emails filed here.
