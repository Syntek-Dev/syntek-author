@./CONTEXT.md

# CLAUDE.md — research/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (imported
above) → this file → the target procedure in `research/workflows/`.

## Purpose (one line)

Gather, verify and record everything the work stands on (sources, checked claims, answered
questions) before any of it is written about.

## How to work here

- **Routing:** start from the matching procedure in `research/workflows/` (an author procedure in
  `research/workflows/local/` wins); content lands in `research/src/`. Skills: `research` reads
  sources and answers questions; `fact-check` verifies claims; the add-reference skill keys a source where
  the project keeps the citation database.
- **Model:** **Opus** for everything substantive: judging what a source argues, or whether it
  supports a claim, is never mechanical. The mechanical tier only for file moves and `make` runs
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:**
  1. Read the read-order files, then route the material with the table in `research/src/CONTEXT.md`.
  2. Run the procedure; write one file per source, claim or question, with full provenance.
  3. Key the source in the same pass as the note, never later.
  4. Hand the finding back to whoever is drafting, with the narrower usable wording where the
     claim turned out smaller than the draft wanted.
- **Definition of done:** the finding is written up with its source and both dates; its limits and
  the gap to what the work wants to say are recorded; anything contested, confidential or
  undecided is flagged for the author rather than resolved.

## Guardrails

- **Evidence before prose.** A unit drafted ahead of its evidence keeps its unverified claims: the
  argument comes to depend on a fact nobody checked, and removing it later costs a rewrite. This
  is the single most important rule in this layer.
- **Primary sources only.** A blog, a press release, a summary or another book's account is a
  scout that points at the source; the citation you keep is the source that owns the fact.
- **Contested stays contested; thin stays thin.** Never average disagreeing sources, never round a
  range into a headline, never promote one unreplicated finding into 'the research shows'.
- **Don't stop where it's convenient.** When the evidence starts agreeing with the author, keep
  going, and record where pushing past that point changed the answer.
- **Two dates on every claim:** when it was established, and when it was checked.
- **Flag, never decide,** on anything confidential, identifying or legally sensitive. The judgement
  is the author's, and an unflagged risk is a decision made on their behalf.
- **Never invent** a source, a quotation, a page number, a figure or a citation key
  (`.claude/rules/syntek-author/03-authorship.md`).
- **Never overwrite an existing note** without confirming with the author; supersede it with a
  dated addition, so the record of what was believed when survives.

## Output & naming

- **Hand-written:** everything in `src/`, the project guides and the local procedures.
- **Naming:** kebab-case `.md`, one file per source, claim or question, named for its subject and
  never for the unit that first needed it: research is shared between units.
- **Generated (never hand-edit):** nothing in this layer; citation output, where the project keeps
  the citation database, is built outside it.
- **Not here:** prose for the reader (the content layer), plans and briefs (`planning/`), build
  output.
