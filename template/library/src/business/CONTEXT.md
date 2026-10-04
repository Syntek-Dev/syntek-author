# CONTEXT.md — library/src/business/

The business family, which every business project has: what the business offers, agrees in
outline and hands over. Proposals and quotes, statements of work, client guides (onboarding packs,
setup guides, implementation plans, handovers), meeting notes, and the business's own plan,
procedures and handbook live here. This family is also the **home of each client's facts**: every
client folder here holds, under `## Facts` in its `CONTEXT.md`, the details every other family
cites. The instruments a proposal leads to, the emails that send it and the invoices that bill it
belong to their own families when this project has them.

## Directory Tree

```text
library/src/business/
├── CONTEXT.md              ← this file
├── CLAUDE.md               ← operating rules
├── templates/              ← reusable starting points: proposal, statement of work, handover
├── client-docs/            ← one <client-slug>/ folder per client; its CONTEXT.md holds the facts
└── drafts/                 ← section drafts, one <unit-slug>/ folder per document (README.md only)
```

## What's here

- **Client documents** in `client-docs/<client-slug>/`: proposals, quotes, statements of work,
  client guides and meeting notes, every version kept. A client that is one legal entity with
  several units that work with the business separately takes one more level,
  `client-docs/<client-slug>/<unit-slug>/`; its facts stay at the client level.
- **The business's own documents** at the family root: its plan, its standard operating
  procedures, its handbook. Living documents carry no version.
- **Templates** in `templates/`: the structure and standard wording a new document starts from,
  with every client value a placeholder.
- **Status as the reader sees it.** A proposal's Document Control block prints Draft, Submitted,
  Accepted or Superseded, matching the register row once there is one.
- **Types, parts, naming and review cycles** are in
  `library/docs/reference/business-standards.md`; the parts every document shares are in
  `library/docs/reference/document-anatomy.md`.

## Cross-references

- `library/docs/reference/business-standards.md` — this family's standard.
- `library/workflows/10-create-a-business-document/` — the procedure that makes a document here.
- `planning/src/precedence.md` — the order of governance between a proposal and the instrument
  that follows it.
- `planning/src/document-register.md` — the register rows for the documents filed here.
