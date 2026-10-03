@./CONTEXT.md

# CLAUDE.md — standards/referencing/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `standards/CONTEXT.md` →
`standards/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file →
`harvard-referencing.md`.

## Purpose (one line)

Keep every citation generated, every key permanent and every source real, so the reference list is
always right without anyone typing it.

## How to work here

- **Routing:** `add-reference` turns a recorded source into a database row with a key; `build`
  runs `make refs` before any proof; `fact-check` decides whether a source is fit to cite before
  it is keyed.
- **Model:** **Opus** for anything substantive (keying a source, resolving a disambiguation,
  choosing a source type); the mechanical tier for `make refs` and `make dump`
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps (a new source):**
  1. Confirm the source is recorded in `research/src/` and, if it supports a checkable claim,
     has been through `fact-check`.
  2. Coin the key (`harvard-referencing.md` rule 2) and add the row with `add-reference`.
  3. Run `make refs`, then `make dump`, and commit the database and the dump together.
  4. Cite it inline as `[@key]` in a Markdown document (never in a `.tex`; rule 7) and build a
     proof to see it rendered.
- **Definition of done:** the source is a row with a stable key; `make refs` runs cleanly; a
  proof of the scope shows the reference, correctly styled; nothing was hand-formatted.

## Guardrails

- **Never hand-format a reference.** A wrong-looking entry means a wrong row or a CSL fix, never
  a manual edit in the work or in `build/`. The one exception is a business LaTeX deliverable
  (`.tex`), where keys cannot resolve: there the reference is written out in full from its row
  (`harvard-referencing.md` rule 7).
- **Keys are permanent.** Renaming a key silently breaks every citation of it.
- **Edit the database, never the generated JSON.**
- **No invented sources, and no guessed details.** An incomplete row is left incomplete and
  flagged; a plausible invented publisher is undetectable downstream.
- **`make dump` after every change, and commit both files.** A database nobody committed is lost
  the first time the folder is moved.

## Output & naming

- **Hand-written:** `harvard-referencing.md` and this pair.
- **The master** is `tooling/references.db`, built by `make init` and edited only through
  `add-reference`; its text snapshot is `references.dump.sql`, beside it.
- **Generated (never hand-edit):** `build/references.json` and every rendered reference list.
