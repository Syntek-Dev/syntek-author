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
  `library/src/<family>/client-docs/<client-slug>/` for a client's. The `draft-section` and
  `promote-section` skills carry their business rules in their `BUSINESS.md` mode files. Each
  family has its skill (`<family>-documents`), its standard
  (`library/docs/reference/<family>-standards.md`) and its create workflow in `library/workflows/`:
  - business → `business-documents` · `library/workflows/10-create-a-business-document/`
<: if DOC_TYPE == 'business' and 'legal' in BUSINESS_FAMILIES :>  - legal → `legal-documents` · `library/workflows/11-create-a-legal-document/`
<: endif :><: if DOC_TYPE == 'business' and 'email' in BUSINESS_FAMILIES :>  - email → `email-documents` (plus the skill of the family that governs the substance) ·
    `library/workflows/12-write-an-email/`; email files by correspondent, not by client document:
    `library/src/email/client-emails/<client-slug>/<family>/` and
    `library/src/email/supplier-emails/<matter-slug>/`
<: endif :><: if DOC_TYPE == 'business' and 'accounting' in BUSINESS_FAMILIES :>  - accounting → `accounting-documents` · `library/workflows/13-create-an-accounting-document/`
<: endif :><: if DOC_TYPE == 'business' and 'social-media' in BUSINESS_FAMILIES :>  - social-media → `social-media-documents` ·
    `library/workflows/14-create-a-social-media-document/`
<: endif :><: if DOC_TYPE == 'business' and 'msp-scp' in BUSINESS_FAMILIES :>  - msp-scp → `msp-scp-documents` · `library/workflows/15-create-an-msp-scp-document/`
<: endif :>- **Model:** **Opus** for anything that writes or changes a document; the mechanical tier for
  creating folders, copying the skeleton and ticking the checklist
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:**
  1. Read the family folder's pair and its standard, then the client folder's pair if there is
     one, and the client's facts.
  2. Read the unit brief the work belongs to; if none exists, plan the document first
     (`planning/workflows/01-plan-a-unit/`).
  3. Write section drafts in the family's `drafts/<unit-slug>/`; promote into the deliverable only
     on the author's word.
- **Definition of done:** the document is in the right family and folder, named to the family's
  pattern, built from the house skeleton, with its sections promoted between their markers and its
  status block matching its unit brief.

## Guardrails

- **One home per fact.** A client's legal name, number, address for notices and contacts live
  under `## Facts` in `library/src/business/client-docs/<client-slug>/CONTEXT.md` (or where
  `00-project.md ## Paths` says); other folders cite them. Copying a fact is how two documents
  come to disagree.
- **A new client folder gets its pair at once,** and the client's folder in
  `library/src/business/client-docs/` is created, with its `## Facts`, the first time the client
  appears in any family. Never create a client folder in a family only to hold facts.
- **Never create a family folder.** The families are chosen when the project is generated; a
  document that fits none goes to the author before it is written.
- **Never edit an issued document or a rendered file.** Open a new version instead.
- **Nothing in a drafts folder is ever sent, published, synced or built.**
- **No credential, password or bank login is written into any file,** in any folder, ignored by
  git or not.
- **Never overwrite** a document or a draft without the author's confirmation.

## Output & naming

- **Hand-written:** `.tex` deliverables, authored emails (`.md`), section drafts (`.md`), and the
  pair of each new client folder.
- **Naming:** kebab-case; client slugs are short and identical in every family; each family's
  patterns are in its standard; versioned documents follow
  `library/docs/reference/versioning-and-the-register.md`.
- **Generated (never hand-edit):** the issued PDF beside a `.tex`, and a Word copy that is sent,
  copied from `build/` beside its source on the author's word, named as the issued PDF, and
  committed with it.
