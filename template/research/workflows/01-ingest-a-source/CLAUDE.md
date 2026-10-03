@./CONTEXT.md

# CLAUDE.md — research/workflows/01-ingest-a-source/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `research/CONTEXT.md` →
`research/CLAUDE.md` → `research/workflows/CONTEXT.md` → `research/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Read a source properly, note what it argues and where it disagrees with the work, and key it, in
one pass.

## How to work here

**Follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.** The model tags in the checklist
are authoritative: `opus` items are judgement; `sonnet` items belong to the mechanical tier.

- **Routing:** skill `research` (reading, and delegated search when the source must be found);
  the add-reference skill for the key where the project keeps the citation database; guide
  `research/docs/reference/ingesting-sources.md`.
- **Model:** **Opus**: judging what a source argues is not mechanical. The mechanical tier only for
  the `make` runs (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** route → reach the primary → capture the details → note the argument → copy
  the quotable passages with pages → record the disagreement → name the units served → write the
  note → key it → hand back.
- **Definition of done:** someone who has not read the source can decide from the note whether
  they need to; the note says what the work argues, what is quotable and on which page, which units
  it serves and where it disagrees; the source is keyed, or its details are complete.

## Guardrails

- **Route before you write.** Filing a checkable claim in `sources/` bypasses
  `02-verify-a-claim`, the only route by which a claim gets a verdict.
- **Read the primary source.** Not the abstract, not the press release, not another book's account.
- **Capture page numbers now.** Going back later rarely happens, which is how vague citations get
  written.
- **Record where the source disagrees.** It reads like an optional nicety and is the habit that
  makes honest review possible.
- **Do not smuggle a verdict.** The note records what the source says; the unit draws conclusions.
- **Never invent** a source, a key, a page number or a quotation.
- **Never overwrite an existing note;** supersede it with a dated addition.

## Output & naming

- **Produces:** `research/src/sources/<author-short-title>.md`, or a note in the folder the routing
  table names.
- **Also writes:** the citation row and its text snapshot, where the project keeps the citation
  database.
- **Generated (never hand-edit):** the citation data built from the citation database, where there
  is one.
- **Does not touch:** prose for the reader, checked claims (that is `02-verify-a-claim`), plans.
