@./CONTEXT.md

# CLAUDE.md — library/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(imported above) → this file.

## Purpose (one line)

Produce the business's documents one approved section at a time, so that every sentence that
reaches a client, a member of staff or the public is one the author has seen and accepted.

## How to work here

- **Routing:** identify the sublayer first.
  - Writing, revising or finishing a document → `src/`, through the matching procedure in
    `workflows/`. The `run-workflow` skill resolves the request, `workflows/local/<slug>/` first.
  - Learning how something is done → `docs/reference/` (a same-named guide in `docs/project/`
    wins).
  - A new document with no unit brief → `planning/workflows/01-plan-a-unit/` before anything here.
  - A live document due its scheduled review → `planning/workflows/06-run-a-review-cycle/`.
- **Model:** **Opus** for substantive work; the mechanical tier for renames, ticks and builds
  (`.claude/rules/syntek-author/05-model-allocation.md`). Anything that could change a figure, a
  date, a scope boundary or a commitment is substantive, whatever it looks like.
- **Concrete steps:**
  1. Read the document's unit brief in `planning/src/units/` and the family folder's pair.
  2. Read the client folder's `CONTEXT.md` when the document is for a client: it holds the facts.
  3. Run the procedure in `workflows/` with its `CHECKLIST.md` open.
  4. Hand back with every flag listed; promote and finalise only on the author's word.
- **Definition of done:** the document sits at its versioned path in the right family, built from
  the house skeleton, with every section promoted and recorded in the ledger, every flag at zero,
  the review passed, `final` set on the author's word, and its register row written.

## Guardrails

- **Nothing reaches a reader without the author's word.** Promotion, `final`, issue and sending
  are the author's calls, given in words. A draft that looks finished is still a draft.
- **Never invent a fact the document will be held to:** a price, a date, a service level, a
  counterparty's legal name or registered number, a statute or a section number. Flag it with
  `AUTHOR TO CONFIRM` or `VERIFY` and say why.
- **Shorten the writing, never the obligation.** An edit for length or tone never removes a
  figure, a caveat, a scope boundary or a commitment.
- **Supersede, never rewrite.** Once a document has been circulated, a change is a new version
  file; the issued file is never edited again.
- **Drafts never leave their drafts folder except by promotion**, and nothing in a drafts folder
  is sent, published or synced.
- **Never write a credential, password, access code or bank login into any file here.**
- **Never overwrite** a draft, a promoted section or a document without the author's confirmation.

## Output & naming

- **Hand-written:** nothing at this root; work happens in the sublayers.
- **Documents:** kebab-case, versioned where the family requires it,
  `<doc-type>-<client-slug>-v<major>-<minor>-<DD-MM-YYYY>.tex` for client documents
  (`library/docs/reference/versioning-and-the-register.md`).
- **Generated (never hand-edit):** rendered PDFs and Word copies, and everything under `build/`.
