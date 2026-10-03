@./CONTEXT.md

# CLAUDE.md — world/src/creatures/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `world/CONTEXT.md` → `world/CLAUDE.md`
→ `world/src/CONTEXT.md` → `world/src/CLAUDE.md` → this folder's `CONTEXT.md` (imported
above) → this file.

## Purpose (one line)

Keep each creature's rules in one place, so the story never breaks a promise it made about
what a creature can and cannot do.

## How to work here

- **Routing:** skill `create-creature` (with `create-name` for its names); workflow
  `world/workflows/04-create-a-creature/`; guide `world/docs/reference/creatures.md`.
- **Model:** **Opus** throughout (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** fix the creature's job in the story → read the other entries, the
  places and cultures it touches, and `planning/src/continuity.md` → ecology → anatomy and
  behaviour → rules, limits and weaknesses → lore and names → check against the world → write
  the entry → register its names.
- **Definition of done:** the entry's limits are stated as hard rules, every weakness the plot
  uses has a planned set-up, nothing contradicts another world file unreported, and its names
  are registered.

## Guardrails

- **Limits are promises.** A rule recorded here binds every chapter; breaking one later needs
  the author's decision and a reason the reader is given.
- **A weakness used at the climax is planted earlier.** Link the set-up and the payoff in
  `planning/src/causality.md`; a weakness that appears only when needed reads as a cheat.
- **Belief is not fact.** Lore is attributed to the people who hold it; the true account sits
  in the other sections. A character knows only what their people believe.
- **Check against the world, report the clash.** A creature that could not live in the
  habitat a place file describes is a contradiction to report, not to smooth over.
- **Never overwrite an existing entry** without confirming with the author.

## Output & naming

- **Hand-written:** `world/src/creatures/<slug>.md`, one sentence per line:

```markdown
---
name: ""                 # exactly as registered
ipa: ""                  # broad IPA, no slashes
kind: ""                 # beast | bird | swimmer | swarm | spirit | construct | other
first_appears: ""        # <unit-slug>/<section-slug>, empty until promoted prose uses it
---

## Ecology
## Anatomy
## Behaviour
## Lore and names
## Role in the story
## Rules and limits
## Weaknesses
## Continuity facts
```

- **Generated:** nothing here.
