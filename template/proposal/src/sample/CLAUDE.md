@./CONTEXT.md

# CLAUDE.md — proposal/src/sample/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `proposal/CONTEXT.md` →
`proposal/CLAUDE.md` → `proposal/src/CONTEXT.md` → `proposal/src/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Point at the manuscript units a reader will receive, with a reason for each, and copy none of them.

## How to work here

- **Routing:** `proposal/workflows/01-assemble-the-proposal/`; skill `build` for the export.
- **Model:** **Opus** to recommend and justify a selection; the mechanical tier to update the index
  and run the export (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:**
  1. Recommend a selection, with reasons, and let the author choose; record the choice in
     `.claude/MEMORY.md` (Decisions).
  2. Check that every planned section of each chosen unit is promoted, none still in its
     `drafts/`.
  3. Add a row per chosen unit to `sample-index.md`: order, path, the date its last section was
     promoted, reason.
  4. Build each unit from the manuscript: `make docx SCOPE=manuscript/src/<unit>`.
- **Definition of done:** every row points at a unit the author chose whose sections are all
  promoted; each reason says what the unit shows a reader; nothing was copied; the export came
  from the manuscript through the build.

## Guardrails

- **Point, never copy.** If the prose needs changing, change it in the manuscript through its own
  procedures, then rebuild.
- **Only units whose sections are all promoted.** Never work around the `drafts/` exclusion to
  get a sample out faster.
- **Never offer what does not exist.** A sample can be decided before it can be sent.
- **Refresh after a manuscript edit** that changes what a sample unit shows; a stale export is the
  same failure as a copy, arriving more slowly.
- **The selection is the author's.** Recommend; never decide.

## Output & naming

- **Seed:** `sample-index.md`, never overwritten by `copier update`.
- **Generated (never hand-edit):** the `.docx` and `.pdf` built from `manuscript/src/`.
- **Never here:** chapter prose, edits to it, or a private version of a unit.
