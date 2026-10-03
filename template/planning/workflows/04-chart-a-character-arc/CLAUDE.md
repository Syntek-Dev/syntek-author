@./CONTEXT.md

# CLAUDE.md — planning/workflows/04-chart-a-character-arc/

Read order: `standards/method/FICTION.md` → `.claude/CLAUDE.md` → `.claude/MEMORY.md` →
`planning/CONTEXT.md` → `planning/CLAUDE.md` → `planning/workflows/CONTEXT.md` →
`planning/workflows/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file →
`STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Plan one character's change so every shift has a place on the page and a cause in the story.

## How to work here

- **Routing:** skill `chart-character-arc`, with `causality` for each beat's cause; guide
  `planning/docs/reference/character-arcs.md`; standard `standards/method/FICTION.md`.
- **Model:** **Opus** throughout (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.
- **Definition of done:** the arc has a type, a truth, a turn and a beat for every shift, each
  tied to a section and a cause; the author has agreed it; the entry and the arc point at each
  other.

## Guardrails

- **Cite the entry; never copy it.** Want, need, wound and voice live in
  `world/src/characters/`. If the arc needs them changed, change the entry, with the author.
- **No shift without a cause.** A beat with nothing in `planning/src/causality.md` behind it is
  sent to `03-chart-the-causality`, not smoothed over.
- **The author decides the ending.** Whether the truth is reached, refused or held is the
  author's call; offer options, never settle it.
- **Never overwrite** an arc or an entry without confirming with the author.

## Output & naming

- **Produces:** `planning/src/arcs/<slug>.md`, the same slug as the character's entry.
- **Also writes:** the entry's `arc:` line.
- **Does not touch:** the prose in `manuscript/src/`, or any other section of the entry.
