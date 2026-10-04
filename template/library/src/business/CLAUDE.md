@./CONTEXT.md

# CLAUDE.md — library/src/business/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/src/CONTEXT.md` → `library/src/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold the business's proposals, statements of work, client guides and own documents, each a
promise the business must be able to keep, and the one record of each client's facts.

## How to work here

- **Routing:** the `business-documents` skill and `library/docs/reference/business-standards.md`;
  a new document runs `library/workflows/10-create-a-business-document/`, which plans it and then
  drives the loop (`library/workflows/01-draft-a-section/` to
  `library/workflows/05-review-a-document/`). At fact check `obligation-check` traces every
  commitment; at line edit `tone` applies the brand voice (`00-project.md ## Paths`). Open with
  `grill-with-docs`: a proposal settled in chat is cheaper than one renegotiated in writing.
- **Model:** **Opus** for every section and every review; the mechanical tier only for copying the
  skeleton and ticking the checklist.
- **Concrete steps:**
  1. Read the client's facts in `library/src/business/client-docs/<client-slug>/CONTEXT.md` and
     any earlier document to the same client.
  2. Settle scope, price and dates with the author before drafting the sections that state them.
  3. Draft, adapt or improve, and promote section by section; review to `final`; register.
- **Definition of done:** a reader who sees only the summary knows what they get, what they do
  not, when, and what it costs; every price and date is the author's; every commitment matches
  what the instrument will carry, or is flagged as new.

## Guardrails

- **Scope is stated twice: what is in and what is out.** An unstated boundary is a promise.
- **Investment is a line-item table, never a single total**, and every figure in it comes from the
  author. A missing price is `\dnote{AUTHOR TO CONFIRM: …}`, never an estimate.
- **No commitment the instrument will not carry.** Where a proposal promises more than the
  business's standard terms, flag it for `obligation-check` and the author.
- **Substantiate or cut.** No superlative without a number; no claim about a competitor or the
  client that the author has not confirmed.
- **State how long an offer stands** (Valid until), and never mark a proposal Accepted without the
  author's word and the client's written acceptance on file.
- **Revisions after sending are new versions**
  (`library/docs/reference/versioning-and-the-register.md`).
- **Client documents are confidential.** Never copy one client's content into another client's
  folder; reusable wording goes into a template, with every client detail removed.

## Output & naming

- **Hand-written:** `.tex` deliverables in `client-docs/<client-slug>/` or at the family root, named
  to the patterns in `library/docs/reference/business-standards.md`; section drafts in
  `drafts/<unit-slug>/`; client folder pairs.
- **Generated (never hand-edit):** the issued PDF beside each `.tex`.
