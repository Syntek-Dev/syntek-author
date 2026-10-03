@./CONTEXT.md

# CLAUDE.md — research/src/evidence/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `research/CONTEXT.md` →
`research/CLAUDE.md` → `research/src/CONTEXT.md` → `research/src/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold one entry per checked claim, with enough provenance that a hostile reader could check it and a
future reader could re-check it.

## How to work here

- **Routing:** skill `fact-check` via `research/workflows/02-verify-a-claim/`; guide
  `research/docs/reference/vetting-evidence.md`. Never write an entry without running the procedure.
- **Model:** **Opus**: judging whether a source supports a claim is not mechanical
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:**
  1. Isolate the claim as one checkable sentence; if it will not reduce to one, record that as the
     finding and stop.
  2. Reach the primary source and record the full basis and both dates.
  3. For a study, record what it was not about and the gap to the work's intended claim.
  4. Assign the verdict and, where the claim is narrower than the draft, the usable wording.
  5. Key the source where the project keeps the citation database.
- **Definition of done:** the entry names the claim, the source, both dates, the basis, the limits,
  the verdict and the units it serves, in the format in `CONTEXT.md`.

## Guardrails

- **A claim without its basis is decoration: cut it, do not hedge it.** 'Roughly' and 'some
  estimates suggest' do not repair a figure with no measurement behind it.
- **Record what a study was not about, and state the gap.** Reaching from a narrow finding to a
  broad conclusion is exactly the move a hostile reviewer is waiting for.
- **Don't stop where it's convenient,** and say so in the entry where pushing past the first
  agreeable source changed the answer.
- **One vocabulary.** The verdict is one of the six in `vetting-evidence.md`; no other word.
- **Legal claims carry jurisdiction and date** and say where the matter is unsettled; never pick
  the ruling that suits the argument.
- **Never invent** a figure, a source or a key.
- **Never overwrite an entry.** Supersede it with a dated addition under `## History`; the history
  of a figure is itself evidence.

## Output & naming

- **Hand-written:** `<topic>.md`, one per claim, named for the claim's subject (for example
  `river-crossing-tolls-1840s.md`), never for the unit.
- **Paired with a citation row** where the project keeps the citation database, written together.
- **Not here:** reading notes on whole works (`research/src/sources/`), answers to wider questions
  (`research/src/notes/`), prose for the reader.
