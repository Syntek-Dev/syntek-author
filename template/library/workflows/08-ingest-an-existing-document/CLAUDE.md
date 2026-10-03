@./CONTEXT.md

# CLAUDE.md — library/workflows/08-ingest-an-existing-document/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/workflows/CONTEXT.md` → `library/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Bring an existing document into the library with its original kept as the record, then register
it or bring it into the house form through the loop.

## How to work here

- **Routing:** the `adapt-section` skill (with its `BUSINESS.md` mode file) carries the conversion
  and adaptation; `fact-check` verifies what the document claims before it is relied on. Guides:
  `versioning-and-the-register.md` and `document-anatomy.md` in `library/docs/reference/`.
- **Model:** follow the checklist tags: the mechanical tier files, converts and splits; **Opus**
  checks the reading copy against the original and does every adaptation.
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.
- **Definition of done:** the original sits unchanged in its family; its reading copy sits beside
  it with every loss noted; a record is registered, or a working source has a brief and section
  drafts ready for the loop.

## Guardrails

- **The original is never edited, re-saved or re-exported.** It is the record of what exists.
- **Every loss is written down.** A reading copy that dropped a table or a clause number says so at
  its top; never repair a loss from memory.
- **Never retype a document from an image of it.** A scanned PDF without a text layer yields no
  reading copy: ask the author for a text source.
- **An ingested document is not checked by being ingested.** Its facts, figures and terms are
  verified before any new document relies on them.
- **Someone else's words stay theirs.** A client's or a third party's text is filed as theirs; the
  internal note on each draft names who wrote it.
- **Never overwrite** an existing file of the same name; stop and ask.
- **No credential, password or bank login** from an ingested document is copied into any other
  file.

## Output & naming

- **Kept as received:** the original, renamed only to the house kebab-case pattern.
- **Derived (never hand-edited):** the Markdown reading copy, `<name>.reading.md`, except its
  internal note. Never give it a plain `.md` name: the suffix is what keeps it from being synced
  or mistaken for a deliverable.
- **Hand-written:** the unit brief (through planning), section drafts, ledger entries, register
  rows.
