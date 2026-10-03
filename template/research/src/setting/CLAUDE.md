@./CONTEXT.md

# CLAUDE.md — research/src/setting/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `research/CONTEXT.md` →
`research/CLAUDE.md` → `research/src/CONTEXT.md` → `research/src/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold what is true about the real places, periods and trades the novel depicts, and record every
deliberate departure from it.

## How to work here

- **Routing:** skill `research` via `research/workflows/01-ingest-a-source/`; `fact-check` via
  `research/workflows/02-verify-a-claim/` for a detail the prose states plainly; guide
  `research/docs/reference/real-world-detail.md`.
- **Model:** **Opus** for gathering and judging; the mechanical tier only for file moves
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:**
  1. Name the subject and the period the note is true for.
  2. Gather from primary sources: the period record, the manual, the map, the practitioner.
  3. Write the texture the prose can use, each detail with its source.
  4. Record each deliberate departure here and in `planning/src/continuity.md`.
- **Definition of done:** a drafting session can use the note without re-researching it, and every
  departure is visible as a choice.

## Guardrails

- **Primary over remembered.** Never take a detail from another novel's version of the world.
- **A departure is logged or it is an error.** An unlogged change to the real world is
  indistinguishable from a mistake, to a reader and to `continuity`.
- **Real people and real harm** are flagged for the author against `standards/risk/FICTION.md`
  before anything is drafted from them.
- **Never invent a source.** An unchecked detail that reaches the prose carries a `VERIFY` flag.
- **Never overwrite a note;** supersede it with a dated addition under `## History`.

## Output & naming

- **Hand-written:** `<subject>.md`, named for the subject (for example
  `harbour-town-winter-1850s.md`), never for the chapter.
- **Not here:** invented places and peoples (`world/src/`), quoted passages
  (`research/src/permissions.md`), prose for the reader.
