@./CONTEXT.md

# CLAUDE.md — proposal/workflows/local/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `proposal/CONTEXT.md` →
`proposal/CLAUDE.md` → `proposal/workflows/CONTEXT.md` → `proposal/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold the author's own proposal procedures, which extend or override the template's.

## How to work here

- **Routing:** `run-workflow` checks here before `proposal/workflows/`; a same-slug folder here
  wins.
- **Model:** **Opus** for writing or changing a procedure
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps to add a procedure:**
  1. Confirm with the author that the task recurs and has no template procedure, or that the
     template's procedure does not fit this project.
  2. Create `NN-verb-first-name/` with all four files, copying the shape of a template procedure:
     routing frontmatter and the metadata header on `STEPS.md` and `CHECKLIST.md`; each step opens
     with its skill and guide and ends `_Substantive._` or `_Mechanical._`; checklist items end
     with a model tag.
  3. Add a row to the table in this folder's `CONTEXT.md`.
- **Definition of done:** four files, consistent with each other, listed in the index, agreed by
  the author.

## Guardrails

- **Only on the author's word.** No skill writes a procedure unasked.
- **Author-owned.** `copier update` never touches files here, this seeded pair included.
- **Keep 'draft, never send'.** A local procedure may change how the package is made; it never lets
  anything leave the repository without the author sending it.
- **Change all four files together,** and name only skills that exist in `.claude/skills/`.

## Output & naming

- **Hand-written:** every procedure here.
- **Folders:** `NN-verb-first-kebab-name/`, numbered from `01` in this folder's own sequence, or
  the exact slug of the template procedure being overridden.
