@./CONTEXT.md

# CLAUDE.md — planning/src/arcs/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `planning/CONTEXT.md` →
`planning/CLAUDE.md` → `planning/src/CONTEXT.md` → `planning/src/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Plan each character's change before it is written, so the reader believes it when it comes.

## How to work here

- **Routing:** arcs are written by `chart-character-arc` through
  `planning/workflows/04-chart-a-character-arc/`; `causality` checks each beat's cause;
  `character-voice` checks the prose in `manuscript/src/` against the voice markers in the
  character's entry.
- **Model:** **Opus** throughout (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** read the character's entry and the causality chain; write or update the
  arc; set the entry's `arc:` to point here.
- **Definition of done:** the arc has a type, a turn and a beat for every shift, each beat tied
  to a cause; the character's entry and the arc point at each other.

## Guardrails

- **Cite the character entry; never copy it.** Want, need, wound and voice live in
  `world/src/characters/`; an arc that restates them drifts from them.
- **No beat without a cause.** A shift with nothing in `planning/src/causality.md` behind it is
  flagged, not smoothed over.
- **Report contradictions** between an arc and the prose; never silently repair either.
- **Never overwrite** an arc without confirming with the author.

## Output & naming

- **Written by `chart-character-arc` (with the author):** `<slug>.md`, the same slug as the
  character's entry.
