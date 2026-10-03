@./CONTEXT.md

# CLAUDE.md — library/src/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold the business's documents, filed by family, with their section drafts beside them until
promotion.

## How to work here

- **Routing:** find the document's family, then its folder: the family root for the business's own
  documents, `library/src/<family>/templates/` for a reusable starting point,
  `library/src/<family>/client-docs/<client-slug>/` for a client's.
  Run the work through `library/workflows/`; the `draft-section` and `promote-section` skills carry
  their business rules in their `BUSINESS.md` mode files.
- **Model:** **Opus** for anything that writes or changes a document; the mechanical tier for
  creating folders, copying the skeleton and ticking the checklist
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:**
  1. Read the family folder's pair, then the client folder's pair if there is one.
  2. Read the unit brief the work belongs to; if none exists, plan the document first
     (`planning/workflows/01-plan-a-unit/`).
  3. Write section drafts in the family's `drafts/<unit-slug>/`; promote into the deliverable only
     on the author's word.
- **Definition of done:** the document is in the right family and folder, named to the house
  pattern, built from the skeleton, with its sections promoted between their markers and its status
  block matching its unit brief.

## Guardrails

- **One home per fact.** A client's legal name, number and contacts live in its `contracts/` client
  folder; other folders cite them. Copying a fact is how two documents come to disagree.
- **A new client folder gets its pair at once**, and the `contracts/` client folder is created
  (pair only) the first time a client appears in any family.
- **Never edit an issued document or a rendered file.** Open a new version instead.
- **Nothing in a drafts folder is ever sent, published, synced or built.**
- **No credential, password or bank login is written into any file,** in any folder, gitignored
  or not.
- **Never overwrite** a document or a draft without the author's confirmation.

## Output & naming

- **Hand-written:** `.tex` deliverables, authored emails (`.md`), section drafts (`.md`), and the
  pair of each new client folder.
- **Naming:** kebab-case; client slugs are short and identical in every family; versioned
  documents follow `library/docs/reference/versioning-and-the-register.md`.
- **Generated (never hand-edit):** the PDF and Word copies beside a `.tex`.
