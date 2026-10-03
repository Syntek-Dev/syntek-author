@./CONTEXT.md

# CLAUDE.md — world/src/languages/example-tongue/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `world/CONTEXT.md` → `world/CLAUDE.md`
→ `world/src/CONTEXT.md` → `world/src/CLAUDE.md` → `world/src/languages/CONTEXT.md` →
`world/src/languages/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Show a complete, consistent daughter language at the smallest useful size, as a model for the
author's own.

## How to work here

- **Routing:** this is an example, not part of the book. Read it beside
  `world/docs/reference/building-a-language.md`; build the book's own languages with
  `build-language` (`world/workflows/06-build-a-language/`), words with `add-word`
  (`world/workflows/07-add-a-word/`) and scripts with `design-script`
  (`world/workflows/08-design-a-script/`).
- **Model:** **Opus** for any change to the language; the mechanical tier for running
  `make lexicon`, `make derive`, `make coverage`, `make glossary`, `make font` and
  `make script-sample` (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps (if the author keeps it and extends it):**
  1. Treat it as a real language: one subsystem at a time, through the workflows.
  2. A new inherited word starts in the parent: add the parent form there, then derive it here
     with `python3 tooling/lexicon.py derive example-tongue --form <parent ipa>`.
  3. Run `make lexicon` and `make derive` after every change to a data file, and
     `make script-sample` after any new headword, so a missing letter shows at once.
- **Definition of done:** `make lexicon` and `make derive` pass, and every headword still
  transliterates.

## Guardrails

- **Do not use its words in the book by accident.** It is an example; a word from it enters the
  book only if the author adopts the language deliberately, and is then registered in
  `world/src/names-register.md`.
- **Never hand-insert irregularity.** A word that does not derive is either fixed, or marked
  `irregular = true` with the reason the history gives, as quaru is.
- **Keep the family consistent or delete it whole.** A half-deleted family teaches the wrong
  lesson, and `make derive` fails without the parent.
- **Never overwrite a language file** without confirming with the author.

## Output & naming

- **Hand-written:** the files listed in this folder's `CONTEXT.md`.
- **Generated (never hand-edit):** audio, if the author ever asks for any, in this language's
  git-ignored audio folder; the glossary, the font and the script samples in the build folder.
