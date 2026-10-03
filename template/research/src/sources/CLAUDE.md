@./CONTEXT.md

# CLAUDE.md — research/src/sources/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `research/CONTEXT.md` →
`research/CLAUDE.md` → `research/src/CONTEXT.md` → `research/src/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold reading notes on the works the project draws on: what each argues, what is quotable and on
which page, and where it disagrees.

## How to work here

- **Routing:** skill `research` via `research/workflows/01-ingest-a-source/`; guide
  `research/docs/reference/ingesting-sources.md`; key with the add-reference skill where the project keeps
  the citation database.
- **Model:** **Opus**: judging what a work argues is not mechanical
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:**
  1. Check you are in the right folder with the routing table in `research/src/CONTEXT.md`.
  2. Read the work at its origin; record what it argues, not what it is about.
  3. Copy the passages worth quoting exactly, with page numbers.
  4. Record where it disagrees with the work, and how it would resist the work's conclusion.
  5. Name the units it serves, then key it.
- **Definition of done:** someone who has not read the work can decide from the note whether they
  need to; the work is keyed or its details are complete.

## Guardrails

- **Record the disagreement.** A note that harvests only agreeable quotations produces a work that
  cites people who would not endorse its conclusion. The passage where a source resists the work is
  usually the most valuable thing in the note.
- **Page numbers as you go.** Retrieving them later is miserable and often does not happen.
- **Argument, not summary.** 'It is about X' is not a note; 'it argues X from Y, and concedes Z' is.
- **Do not smuggle a verdict.** The note records what the source says, not what the work should
  conclude from it.
- **Never cite a work from its abstract or from another book's account of it**, and never invent a
  source, a key or a page number.
- **Never overwrite a note;** supersede it with a dated addition under `## History`.

## Output & naming

- **Hand-written:** `<author-short-title>.md`, or `<topic>.md` for a tight cluster of works (for
  example `hartwell-tidal-mills.md`).
- **Paired with a citation row** where the project keeps the citation database.
- **Not here:** checked claims (`research/src/evidence/`), answers to wider questions
  (`research/src/notes/`), prose for the reader.
