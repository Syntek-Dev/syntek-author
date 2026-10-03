@./CONTEXT.md

# CLAUDE.md — planning/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(imported above) → this file.

## Purpose (one line)

Hold the plan for every unit and for the work as a whole, so drafting always starts from an
agreed brief and never from memory.

## How to work here

- **Routing:** pick a procedure from `planning/workflows/CLAUDE.md` (the `run-workflow` skill
  resolves `workflows/local/` first). A unit's plan → `01-plan-a-unit`; the whole work →
  `09-review-the-whole-work`; a body of decisions too big for one sitting → the `wayfinder`
  skill. Guides: `planning/docs/reference/`, overridden by same-named files in
  `planning/docs/project/`.
- **Model:** **Opus** for substantive work; the mechanical tier for renames, ticks and table
  edits (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:**
  1. Identify the sublayer and read its `CONTEXT.md` and `CLAUDE.md`.
  2. For anything in `src/`, read the guide that governs it first (indexed in
     `planning/docs/reference/CONTEXT.md`).
  3. Change the plan, then check that the outline, the brief and any doc-type plan still agree.
- **Definition of done:** every unit about to be drafted has a brief at `outlined` or later; the
  outline lists every unit in order; nothing here contradicts `.claude/MEMORY.md` Decisions.

## Guardrails

- **Plans, not prose.** A brief says what a section must do, never how it reads. Section text
  belongs in the content layer's drafts folders, written by the drafting skills.
- **Scaffolding is not progress.** Plan the next unit to be drafted, not every unit at once. A
  shelf of briefs with no prose behind them reads as progress and is not.
- **Advice is not a decision.** Reviews and maps record advice and open questions; a decision
  exists only when the author makes and dates it in `.claude/MEMORY.md`
  (`.claude/rules/syntek-author/08-naming-and-memory.md`).
- **Route, do not restate.** Project state lives in MEMORY; a plan links to it. A status or a
  decision copied into a brief drifts from its owner within weeks.
- **Never overwrite** an existing brief, map, review or register without confirming with the
  author.

## Output & naming

- **Hand-written (with the author):** `src/outline.md`, briefs in `src/units/`, the doc type's
  plans and registers.
- **Written by skills:** `src/maps/MAP-<TOPIC>.md` (`wayfinder`),
  `src/reviews/REVIEW-<scope>-DD-MM-YYYY.md` (`structure-review`).
- **Generated (never hand-edit):** nothing; this layer is never built.
- Filenames kebab-case; dates DD/MM/YYYY in prose and DD-MM-YYYY in filenames.
