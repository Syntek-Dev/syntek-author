@./CONTEXT.md

# CLAUDE.md — world/src/languages/example-proto/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `world/CONTEXT.md` → `world/CLAUDE.md`
→ `world/src/CONTEXT.md` → `world/src/CLAUDE.md` → `world/src/languages/CONTEXT.md` →
`world/src/languages/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Show a proto-language at the smallest useful size: the roots a daughter's words descend from.

## How to work here

- **Routing:** this is an example, not part of the book. Read it beside
  `world/docs/reference/building-a-language.md`; build the book's own languages with
  `build-language` through `world/workflows/06-build-a-language/`.
- **Model:** **Opus** for any change to the language; the mechanical tier for running
  `make lexicon`, `make derive` and `make family`
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps (if the author keeps it and extends it):**
  1. Treat it as a real language: one subsystem at a time, through the workflows.
  2. Change a parent form only with its daughter open: every reflex of it must still derive.
  3. Run `make lexicon` and `make derive` after every change to a data file.
- **Definition of done:** `make lexicon` and `make derive` pass, and `make family` shows the
  pair with their models.

## Guardrails

- **Do not use its words in the book by accident.** Nobody in the book speaks a proto-language;
  its forms appear only in word histories, with an asterisk.
- **Keep the family consistent or delete it whole.** Removing this folder without its daughter
  leaves a daughter with no parent, and `make derive` and `make family` fail.
- **Never overwrite a language file** without confirming with the author.

## Output & naming

- **Hand-written:** the files listed in this folder's `CONTEXT.md`.
- **Generated (never hand-edit):** the glossary in the build folder (`make glossary`).
