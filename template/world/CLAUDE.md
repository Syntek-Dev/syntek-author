@./CONTEXT.md

# CLAUDE.md — world/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (imported
above) → this file → the target folder's `CONTEXT.md` and `CLAUDE.md`.

## Purpose (one line)

Keep one checked record of what is true in the novel's world, so that every chapter can be
measured against it and no fact is invented twice.

## How to work here

- **Routing:** start every job from the matching procedure in `world/workflows/` (the index is
  `world/workflows/CLAUDE.md`); each one names its skill and guide. Names always go through
  `create-name`; arcs through `chart-character-arc`<: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>; creatures through `create-creature`;
  peoples, cultures and the world history through `grill-with-docs`, with `wayfinder` when the
  history is too large for one sitting<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>;
  languages through `build-language`, `add-word`, `design-script` and `pronounce`<: endif :>.
- **Model:** **Opus** for substantive work; the mechanical tier for renames, ticks and builds
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:**
  1. Read `world/src/names-register.md` and the existing files of the kind you are about to
     create, so that nothing new contradicts something old.
  2. Run the procedure; offer options and let the author choose every name and every fact the
     book will rely on.
  3. Write the file under `world/src/`, register any new name, and hand back the open
     questions as `AUTHOR TO CONFIRM` flags.
- **Definition of done:** the new entry exists in one place only, its name is registered with
  IPA and a respelling, it contradicts nothing already established (or the contradiction has
  been reported to the author), and every open decision is flagged rather than guessed.

## Guardrails

- **The story bible is the source of truth, and the author owns it.** Never add a fact the
  author has not agreed. Where a scene needs something the bible lacks, flag
  `<!-- AUTHOR TO CONFIRM: … -->` and ask.
- **Report contradictions; never repair them silently.** If the prose and a world file
  disagree, list both with their locations and let the author decide which changes. A silent
  fix in either direction destroys the record of what the reader has already been told.
- **A name enters the register before it enters promoted prose.** An unregistered name is
  invisible to `spelling` and `continuity`, so its misspellings are invisible too.
- **Depth on demand.** Write what the book uses, or what constrains what it uses. Every unused
  fact is one more thing that can contradict a chapter.<: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>
- **Build from the ground up.** A people before its culture, a culture before its language, and
  the history that moved them before either is final; a layer built before the one beneath it
  stands on guesses.<: endif :>
- **Facts already used in promoted prose are frozen.** Changing one is a change to the book:
  list the affected sections from `planning/src/continuity.md` before editing anything.
- **Never overwrite an existing world file** without confirming with the author.

## Output & naming

- **Hand-written:** one Markdown file per entry, named for the registered name in kebab-case
  (`world/src/characters/<slug>.md`); one sentence per line in `world/src/` files, applied when
  a paragraph is edited, never by mass reflow.
- **Dates and appearances:** dates are DD/MM/YYYY. A first appearance is written
  `<unit-slug>/<section-slug>` and stays empty until promoted prose uses the name.
- **Generated (never hand-edit):** anything under `build/`<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>, and the pronunciation audio in each
  language's audio folder, which `world/src/.gitignore` ignores<: endif :>.
