@./CONTEXT.md

# CLAUDE.md — tooling/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (imported
above) → this file → the `Makefile` at the repository root.

## Purpose (one line)

Keep the build machinery small, dependable and run through `make`, so a proof is one command and
a broken build says exactly what broke.

## How to work here

- **Routing:** `build` runs the proof targets and reads the result;<: if INCLUDE_REFERENCES :>
  `add-reference` changes the reference database (never by hand);<: endif :> `promote-section`
  runs `provenance.py ratio --write` at promotion; `learn-voice` reads `make provenance`.<: if DOC_TYPE != 'business' :>
  `typeset` runs `make tex`, `make tex-check` and `make print` for the printed book.<: endif :><: if DOC_TYPE == 'business' :>
  `promote-section` runs `make section-check` before it writes the ledger.<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>
  `add-word`, `build-language` and `design-script` validate with `make lexicon`, `make derive`,
  `make coverage`, `make font` and `make script-sample`.<: endif :>
- **Model:** the mechanical tier for running a build and reporting what it printed; **Opus** for
  any change to a script, the filter, the schema or the LaTeX
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps (running a build):**
  1. Run the target through `make`; never call Pandoc, XeLaTeX<: if INCLUDE_REFERENCES :>, `sqlite3`<: endif :> or a
     script by hand, because the targets encode the file selection, the filter and the exclusions.
  2. Read the file list the target echoes, and confirm it is what the author meant.
  3. Open the output in `build/` and read it before reporting it built.
- **Concrete steps (changing the machinery):** describe the change and why to the author first;
  keep every script standard-library only<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :> (`font.py` alone declares one dependency, inline,
  and runs with `uv run`)<: endif :>; run the target on a real file before and after, and any
  `--self-test` the script has.
- **Definition of done:** the target ran cleanly, the output was read, and nothing under `build/`
  was edited by hand.

## Guardrails

- **Minimalism is a feature.** No new dependency, server, database or framework without the
  author's decision; a script that needs a package is a script that breaks on the next machine.
- **Never edit `build/`.** Everything there is generated and overwritten on the next run; the
  `Makefile` writes `build/.gitignore` so none of it is committed.
- **Do not defeat the exclusions.** `CONTEXT.md`, `CLAUDE.md`, `README.md` and anything under a
  `drafts/` folder never build: governance is not prose, and an unpromoted draft must never reach
  an editor.
- **One filter for every output.** Every Pandoc run passes through `tooling/pandoc/house.lua`; a
  build that skips it renders the author's marks as plain text.
- **Fail loudly.** A script that cannot do its job exits non-zero with a message that names the
  file and the fix; it never writes a partial or lossy output.<: if INCLUDE_REFERENCES :>
- **Commit the database and its dump together**, after every change (`make dump`).<: endif :>

## Output & naming

- **Hand-written:** every file here; the scripts carry a usage docstring and exit codes
  (0 done, 1 problems found, 2 usage or file error).
- **Generated (never hand-edit):** everything under `build/`, named after the scope or file with
  `/` replaced by `__`<: if INCLUDE_REFERENCES :>; the text dump `references.dump.sql`, written by `make dump`<: endif :>.
- New scripts: `snake_case.py`, standard library only, each with a `make` target.
