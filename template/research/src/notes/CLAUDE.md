@./CONTEXT.md

# CLAUDE.md — research/src/notes/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `research/CONTEXT.md` →
`research/CLAUDE.md` → `research/src/CONTEXT.md` → `research/src/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold one cited note per question the work needs answered from several primary sources.

## How to work here

- **Routing:** skill `research` (delegated search runs in the background while the session carries
  on); guide `research/docs/reference/vetting-evidence.md`.
- **Model:** **Opus** for framing the question and judging the sources
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:**
  1. Confirm the repository cannot already answer the question: check `research/src/` and
     `.claude/MEMORY.md` first.
  2. Frame one answerable question, in one sentence.
  3. Read the sources that own the facts; treat every secondary account as a scout.
  4. Write the note in the format in `CONTEXT.md`, every claim cited and dated.
  5. Link the note from whatever it feeds: a unit brief's `sources:` list, or a decision the author
     records in `.claude/MEMORY.md`.
- **Definition of done:** the note exists at `research/src/notes/<topic>.md`, every claim carries
  a primary citation and a checked date, every conflict is stated, and what it feeds links back.

## Guardrails

- **Primary sources only.** A blog, a briefing or a directory listing points at the source; the
  citation kept is the source that owns the fact.
- **Verify an organisation against its official register,** never against its own website or a
  directory.
- **Record conflicts; never average them.** Name both positions and say which governs and why.
- **Every claim carries the date it was checked;** guidance, rates and records change.
- **A note is not a decision.** A durable finding enters `.claude/MEMORY.md` only when the author
  confirms it, through the `grill-with-docs` gate.
- **Never overwrite a note;** supersede it with a dated addition under `## History`.

## Output & naming

- **Hand-written:** `<topic>.md`, one question per note, kebab-case, no version number.
- **Not here:** a reading note on one work (`research/src/sources/`), a single checked claim
  (`research/src/evidence/`), prose for the reader.
