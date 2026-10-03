@./CONTEXT.md

# CLAUDE.md — tooling/data/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `tooling/CONTEXT.md` →
`tooling/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold the shared reference data the conlang tooling measures every language against.

## How to work here

- **Routing:** `build-language` and `add-word` read `make coverage` to choose what to coin next;
  nothing writes here in the normal course of work.
- **Model:** **Opus** for any change to the data; the mechanical tier for running
  `make coverage` (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps (if the author wants the list changed):**
  1. Say what changes and why, and confirm it with the author first.
  2. Keep every `key` unique and kebab-case; never rename one a lexicon already cites.
  3. Run `make coverage` and `make lexicon` afterwards: a removed key leaves a warning on every
     word that cited it.
- **Definition of done:** the file parses, and `make coverage` runs on every language.

## Guardrails

- **Template-owned.** `copier update` may refine this file; a project-only concept belongs in a
  language's lexicon, not here, or the change is lost or conflicts at the next update.
- **A concept is a meaning, not an English word.** Each `gloss` says which sense is meant, so that
  a language's word can fill it without copying English's way of dividing meanings.
- **Never copy a published list into it.** It was written fresh, and stays that way.

## Output & naming

- **Hand-written:** `core-concepts.toml`.
- **Generated:** nothing here; `make coverage` only reports.
