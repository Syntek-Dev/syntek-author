@./CONTEXT.md

# CLAUDE.md — typeset/src/backmatter/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `typeset/CONTEXT.md` →
`typeset/CLAUDE.md` → `typeset/src/CONTEXT.md` → `typeset/src/CLAUDE.md` → this folder's
`CONTEXT.md` (the pages it holds, imported above) → this file.

## Purpose (one line)

Set the pages after the text with the author's own words, and the generated lists in their place.

## How to work here

- **Routing:** the `typeset` skill, within `typeset/workflows/04-typeset-the-book/`.
- **Model:** **Opus** for setting a page; the mechanical tier for adding its `\houseinput` line
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps for a page:**
  1. Ask the author for the exact words; a generated list (references, a glossary) is made by its
     `make` target, never typed.
  2. Write `<name>.tex` here: plain LaTeX with house macros only; open with `\chapter{…}` when
     the page should appear in the contents.
  3. Add or confirm its `\houseinput{backmatter/<name>}` line in `typeset/src/book.tex`.
  4. `make print`, and read the page.
- **Definition of done:** the page prints in its place, its words are exactly the author's, and
  any list on it was generated.

## Guardrails

- **Never compose these words.** Thanks and a biography in the author's voice are the author's to
  write; ask, and leave the file out until they come.
- **Never name a person the author has not named**, and never add a fact about the author.
- **Never hand-edit a generated list**; regenerate it from its source.
- **Never overwrite a page** the author has approved without confirming.

## Output & naming

- **Hand-written (with the author):** `acknowledgements.tex`, `about-the-author.tex` and any
  other page, named in kebab-case for what it is.
- **Generated (never hand-edit):** the reference list at `build/typeset/references.tex`, written
  by `make print` where the project keeps references.
