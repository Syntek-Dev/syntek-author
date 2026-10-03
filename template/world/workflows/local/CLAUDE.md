@./CONTEXT.md

# CLAUDE.md — world/workflows/local/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `world/CONTEXT.md` → `world/CLAUDE.md`
→ `world/workflows/CONTEXT.md` → `world/workflows/CLAUDE.md` → this folder's `CONTEXT.md`
(imported above) → this file.

## Purpose (one line)

Hold the world-layer procedures that belong to this book alone, and the overrides of template
procedures the author has chosen.

## How to work here

- **Routing:** `run-workflow` resolves local first: a folder here with the same slug as one in
  `world/workflows/` wins.
- **Model:** **Opus** for writing or changing a procedure; the checklist tags decide each item
  when it runs (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps (adding one):**
  1. Confirm with the author that the job recurs; a one-off needs no procedure.
  2. Number it in this folder's own sequence (`01-`, `02-` …), or reuse a template slug
     exactly to override that procedure.
  3. Write all four files in the template's shape: routing frontmatter on `STEPS.md` and
     `CHECKLIST.md`, steps that name their skill and guide and end _Substantive._ or
     _Mechanical._, checklist items tagged with the model tier.
  4. Add a row to the table in this folder's `CONTEXT.md`.
- **Definition of done:** the four files exist, the index row is added, and the author has
  agreed the procedure.

## Guardrails

- **Author-owned.** Create or change a procedure here only on the author's instruction.
- **An override replaces the whole template procedure.** Carry across every step you still
  need; nothing from the template version runs.
- **Never overwrite an existing local procedure** without confirming with the author.

## Output & naming

- **Hand-written:** `<NN>-<verb-first-name>/` with `CONTEXT.md`, `CLAUDE.md`, `STEPS.md` and
  `CHECKLIST.md`.
- **Generated:** nothing here.
