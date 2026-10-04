@./CONTEXT.md

# CLAUDE.md — manuscript/workflows/local/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `manuscript/CONTEXT.md` →
`manuscript/CLAUDE.md` → `manuscript/workflows/CONTEXT.md` → `manuscript/workflows/CLAUDE.md` →
this folder's `CONTEXT.md` (the author's procedure index, imported above) → this file.

## Purpose (one line)

Hold the author's own procedures, and their overrides of the template's, where template updates
can never reach them.

## How to work here

- **Routing:** `run-workflow` resolves an intent here before it looks in `manuscript/workflows/`.
  A folder here with the same slug as a template folder, whatever its number, replaces it entirely.
- **Model:** **Opus** for writing or changing a procedure; the mechanical tier for copying files
  and adding index rows (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps to add a procedure:**
  1. Confirm with the author that the work recurs and that no template procedure covers it.
  2. Take the next free local number and a verb-first kebab name: `NN-verb-first-name/`.
  3. Write all four files in the house format: routing frontmatter (`workflow`, `phase`, `skills`,
     `model`) on `STEPS.md` and `CHECKLIST.md`; the metadata header; numbered steps that each open
     with the skill and the guide they use and end `_Substantive._` or `_Mechanical._`; checklist
     items ending ` · _opus_` or ` · _sonnet_`.
  4. Add a row to this folder's `CONTEXT.md`.
- **Concrete steps to override a template procedure:**
  1. Confirm with the author, and date the decision in `.claude/MEMORY.md` Decisions (mapped in
     `00-project.md` `## Memory headings`).
  2. Copy the template folder here under the same name, all four files, and change only what
     differs.
  3. Add a row to this folder's `CONTEXT.md` naming what it overrides.
- **Definition of done:** the procedure has all four files, cites rules instead of restating them,
  names only skills that exist in this project, and is listed in this folder's `CONTEXT.md`.

## Guardrails

- **Author-owned.** Never add, change or delete a procedure here without the author's agreement.
- **An override is a fork.** It stops receiving the template's improvements. Prefer adding a new
  procedure unless the template's procedure is actually wrong for this book.
- **Change all four files together.** A `STEPS.md` with a stale `CHECKLIST.md` is worse than either
  alone, because the checklist is what gets ticked.
- **Never overwrite an existing procedure** without confirming with the author.

## Output & naming

- **Hand-written:** `NN-verb-first-name/` folders with `CONTEXT.md`, `CLAUDE.md`, `STEPS.md` and
  `CHECKLIST.md`.
- **Generated:** nothing.
