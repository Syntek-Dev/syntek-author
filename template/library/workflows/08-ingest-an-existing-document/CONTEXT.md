# CONTEXT.md — library/workflows/08-ingest-an-existing-document/

The procedure for bringing a document the business already has into the library: a signed
contract received as a PDF, an old proposal in Word, a policy written before the project existed,
a template bought or inherited. The original is filed unchanged and a Markdown reading copy is
made beside it. Then one of three things happens: a **record** is registered as it stands; a
**working source** becomes a unit, split into section drafts and brought into the house form
through the loop; a **template seed** becomes a reusable template the same way.

## Directory Tree

```text
library/workflows/08-ingest-an-existing-document/
├── CHECKLIST.md            ← verification checklist before marking complete
├── CLAUDE.md               ← operating rules for this workflow
├── CONTEXT.md              ← this file (when to use, what it produces, the failure it prevents)
└── STEPS.md                ← ordered steps to execute
```

## When to use this

- The author hands over a `.docx`, `.pdf`, `.tex` or `.md` document that should live in the
  library, or be revised there.
- A client sends a document of theirs that the business must keep, answer or rework.
- A project is being adopted and its existing documents are being brought in one by one.

Reach for a **different** procedure when: the document is already in the library and needs a
revision (`library/workflows/02-adapt-a-draft/` on a new version); the material is research rather
than a document, such as an article or a regulator's guidance
(`research/workflows/01-ingest-a-source/`); or the author wants a new document modelled on an old
one without keeping the old one (`planning/workflows/01-plan-a-unit/`, citing the old one in the
brief).

## What it produces, and where

- **The original, unchanged,** in its family: at the family root, in
  `library/src/<family>/templates/`, or in `library/src/<family>/client-docs/<client-slug>/`,
  renamed only to the house kebab-case pattern.
- **A Markdown reading copy** beside it, `<name>.reading.md` (same basename), with an internal
  note listing anything the conversion lost. The suffix keeps it out of Drive sync: it is derived,
  never issued.
- **For a record:** a register row (and an approval record if it was executed).
- **For a working source or a template seed:** a unit brief, one section draft per planned section
  at `author-draft`, and a ledger entry for each with an empty `## AI original`.

## The failure this procedure exists to prevent

**A converted copy mistaken for the original.** Conversion loses things quietly: a table's columns,
a footnote, a clause number, a signature. If the converted text is then edited and issued, the
business is relying on words nobody agreed. The original stays untouched as the record, and every
loss in the reading copy is written at its top.

## Cross-references

- `library/docs/reference/versioning-and-the-register.md` — registering a record as it stands.
- `library/docs/reference/document-anatomy.md` — the house form a working source is brought into.
- `library/workflows/02-adapt-a-draft/` — adapting the ingested sections.
