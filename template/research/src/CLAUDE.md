@./CONTEXT.md

# CLAUDE.md — research/src/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `research/CONTEXT.md` →
`research/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file → the target
subfolder's `CONTEXT.md` and `CLAUDE.md`.

## Purpose (one line)

Hold the evidence base itself, accurate rather than readable, written before the prose that will
use it.

## How to work here

- **Routing:** never write straight into this folder. Route the material with the table in
  `CONTEXT.md`, then work through its procedure:
  - `evidence/` → `fact-check` via `research/workflows/02-verify-a-claim/`;
  - `sources/` → `research` via `research/workflows/01-ingest-a-source/`;
  - `notes/` → the `research` skill, one question at a time;
<: if DOC_TYPE == 'theology' :>  - `contested-readings/` → `tradition-check` via `research/workflows/03-map-a-contested-reading/`;
<: endif :><: if DOC_TYPE == 'fiction' :>  - `setting/` → `research` via `research/workflows/01-ingest-a-source/`; `permissions.md` → a
    row added when a quoted passage enters a draft;
<: endif :><: if DOC_TYPE != 'business' and INCLUDE_SENSITIVE_CONTENT :>  - `testimony/` → `sensitivity-pass` via `research/workflows/05-handle-testimony-safely/`, and
    only with the author.
<: endif :>- **Model:** **Opus** for everything substantive; the mechanical tier only for file moves and
  `make` runs (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** run the procedure → write one file per thing, in the subfolder's entry
  format → key the source in the same pass → hand the finding back to whoever is drafting.
- **Definition of done:** the entry carries full provenance, both dates and, for a claim, its
  verdict; a study's limits and the gap to the work's intended claim are explicit; anything
  confidential or contested is flagged for the author.

## Guardrails

- **Write the note before the unit, not from it.** Extracting provenance after the prose is written
  is how unverified claims survive.
- **One entry per thing.** A file holding six claims makes five invisible.
- **Contested stays contested; thin stays thin.** Never average, never round a range into a
  headline.
- **Never invent** a source, a key, a quotation or a figure, and never hand-format a citation.
- **Never overwrite an existing entry** without confirming; supersede it with a dated addition, so
  the record of what was believed when survives.

## Output & naming

- **Hand-written:** everything here.
- **Naming:** kebab-case `.md` named for the subject, never for the unit that first needed it.
- **Not here:** prose for the reader (the content layer), plans (`planning/`), build output.
