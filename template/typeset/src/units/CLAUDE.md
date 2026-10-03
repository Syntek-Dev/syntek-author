@./CONTEXT.md

# CLAUDE.md — typeset/src/units/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `typeset/CONTEXT.md` →
`typeset/CLAUDE.md` → `typeset/src/CONTEXT.md` → `typeset/src/CLAUDE.md` → this folder's
`CONTEXT.md` (styled chapters and their bases, imported above) → this file.

## Purpose (one line)

Hold each chapter's styled LaTeX beside its Pandoc base, so styling survives every revision of the
words and every word stays provably the author's.

## How to work here

- **Routing:** `typeset/workflows/02-typeset-a-chapter/` for a first typesetting;
  `typeset/workflows/03-retypeset-after-edits/` after the chapter's Markdown changes. The `typeset`
  skill runs both.
- **Model:** **Opus** for styling and for resolving a merge clash; the mechanical tier for
  `make tex`, copying a first base and `make tex-check`
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps for styling a chapter:**
  1. Work only in `NN-kebab-title.tex`, never in `typeset/src/units/.base/`.
  2. Add house macros around words that are already there; delete only macros you added.
  3. Compare the file with its base: every difference must be a macro.

     ```sh
     git diff --no-index typeset/src/units/.base/NN-kebab-title.tex typeset/src/units/NN-kebab-title.tex
     ```
  4. `make tex-check UNIT=NN-kebab-title` must pass before the work is done.
- **Definition of done:** the styled chapter passes `make tex-check`, its base is the current
  output of `make tex`, and both are ready to commit together.

## Guardrails

- **Never type, retype, reorder or 'correct' a word here.** Words change in the Markdown and
  arrive by `make tex`. That includes a typo you have noticed: report it to the author.
- **Never edit `typeset/src/units/.base/`, and never create a styled file by hand.** A styled
  file starts as a copy of its base.
- **Never overwrite a styled file** with a fresh base: that throws the styling away. Carry it
  forward with `git merge-file`, and ask the author before starting a chapter's styling over.
- **A clash is resolved by the new base's words.** Take the new line, then put the styling back
  on it; never keep the old words because the styling was on them.

## Output & naming

- **Hand-written (styling only):** `NN-kebab-title.tex`, matching the chapter's folder name.
- **Generated (never hand-edit):** `.base/NN-kebab-title.tex`, by `make tex`; the previous base and
  `make tex`'s working copies in `build/typeset/`.
