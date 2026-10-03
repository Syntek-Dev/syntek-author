@./CONTEXT.md

# CLAUDE.md — typeset/workflows/local/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `typeset/CONTEXT.md` →
`typeset/CLAUDE.md` → `typeset/workflows/CONTEXT.md` → `typeset/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (the author's procedure index, imported above) → this file.

## Purpose (one line)

Hold the author's own typesetting procedures, and their overrides of the template's, where
template updates can never reach them.

## How to work here

- **Routing:** `run-workflow` resolves an intent here before it looks in `typeset/workflows/`. A
  folder here with the same name as a template folder replaces it entirely.
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
  1. Confirm with the author, and date the decision in `.claude/MEMORY.md` Decisions.
  2. Copy the template folder here under the same name, all four files, and change only what
     differs.
  3. Add a row to this folder's `CONTEXT.md` naming what it overrides.
- **Definition of done:** the procedure has all four files, cites rules instead of restating them,
  keeps the fidelity check before every print, and is listed in this folder's `CONTEXT.md`.

## Guardrails

- **Author-owned.** Never add, change or delete a procedure here without the author's agreement.
- **An override is a fork.** It stops receiving the template's improvements. Prefer adding a new
  procedure unless the template's procedure is actually wrong for this book.
- **No local procedure may skip `make tex-check`.** A procedure that prints unchecked chapters
  undoes the guarantee the whole layer exists for; raise it with the author instead.
- **Never overwrite an existing procedure** without confirming with the author.

## Output & naming

- **Hand-written:** `NN-verb-first-name/` folders with `CONTEXT.md`, `CLAUDE.md`, `STEPS.md` and
  `CHECKLIST.md`.
- **Generated:** nothing.
