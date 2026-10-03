@./CONTEXT.md

# CLAUDE.md — research/src/contested-readings/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `research/CONTEXT.md` →
`research/CLAUDE.md` → `research/src/CONTEXT.md` → `research/src/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file → `standards/method/THEOLOGY.md`.

## Purpose (one line)

Map, once and properly, every passage read more than one way that the book leans on, so a chapter
can name the dispute in a few sentences without drafting from memory.

## How to work here

- **Routing:** skill `tradition-check` via `research/workflows/03-map-a-contested-reading/`; guide
  `research/docs/reference/contested-readings.md`; `category-check` keeps text, inference and
  conclusion apart.
- **Model:** **Opus** throughout (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:**
  1. Check whether the map already exists; if it does, read it and extend it rather than starting
     again.
  2. Set out the passage with enough context that the dispute is visible.
  3. State each reading in its holders' own terms, with who holds it and where, from sources.
  4. Say what each reading does to the book's argument, and where the readings agree.
  5. Recommend the reading to adopt, with a reason someone could argue with; the author decides.
- **Definition of done:** every reading would be recognised by someone who holds it; what turns on
  each is explicit; the adopted reading is the author's and its reason is stated; every source is
  cited; the map serves any chapter that needs it, not only the one that commissioned it.

## Guardrails

- **The recognition test applies here first.** A map that caricatures a position produces a
  chapter that caricatures it, and by then the caricature looks researched.
- **Name what turns on it.** 'The argument survives either way' and 'this conclusion depends on it'
  are both findings; skipping the section leaves the chapter guessing.
- **No false balance, no unargued preference.** The book may hold a position, for a stated reason.
- **Read the passage whole.** A map of half a passage looks like diligence and is worse than none.
- **Never attribute a position to a named scholar or tradition without a source,** and never gloss
  a Hebrew or Greek term from memory: mark anything unchecked with a `VERIFY` flag.
- **Never overwrite a map;** supersede it with a dated addition under `## History`.

## Output & naming

- **Hand-written:** `<passage>.md`, named for the passage (book, chapter, verses), never for the
  chapter that needed it.
- **Paired with citation rows** for every commentary cited, where the project keeps the citation
  database.
- **Not here:** the chapter's own treatment of the dispute, which is written in the manuscript from
  this map; empirical evidence (`research/src/evidence/`).
