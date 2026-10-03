@./CONTEXT.md

# CLAUDE.md — research/workflows/03-map-a-contested-reading/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `research/CONTEXT.md` →
`research/CLAUDE.md` → `research/workflows/CONTEXT.md` → `research/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Map a passage read more than one way, once and properly, so a chapter can name the dispute in a few
sentences without drafting from memory.

## How to work here

**Follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.** The model tags in the checklist
are authoritative: `opus` items are judgement; `sonnet` items belong to the mechanical tier.

- **Routing:** skill `tradition-check`; `category-check` to keep text, inference and conclusion
  apart; `research` to find and read the commentaries; the add-reference skill for keys where the project
  keeps the citation database. Guide `research/docs/reference/contested-readings.md`.
- **Model:** **Opus** throughout (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** check for an existing map → set out the passage → identify the readings →
  state each in its holders' terms → record who holds them → say what each does to the argument →
  record the agreements → read the passage whole → gloss the languages → recommend a reading → run
  the tradition check → write the map → hand back.
- **Definition of done:** every reading would be recognised by someone who holds it; who holds it
  and where is sourced; what each reading does to the argument is explicit; the agreements are
  named; a reading is recommended with an arguable reason and the decision sits with the author;
  the map serves every chapter that needs it.

## Guardrails

- **The recognition test applies here first.** If you cannot state a reading in terms its holders
  would accept, you are not ready to write it: read someone who holds it.
- **Name what turns on it.** The section most often skipped, and the one that earns the map.
- **No false balance, and no unargued preference.** The book may hold a position, for a stated
  reason someone could argue with.
- **The adopted reading is the author's theological conclusion.** Recommend; never decide.
- **Read the passage whole.** A map of half a passage is worse than none.
- **Never attribute a position without a source,** never quote a commentary from memory, and never
  gloss a Hebrew or Greek term from memory; anything unchecked carries a `VERIFY` flag.
- **Never overwrite a map;** supersede it with a dated addition.

## Output & naming

- **Produces:** `research/src/contested-readings/<passage>.md`.
- **Also writes:** citation rows for every source, where the project keeps the citation database.
- **Does not touch:** the chapter's own treatment of the dispute, which is written in the
  manuscript from this map; the argument map, which links to it.
