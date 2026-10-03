@./CONTEXT.md

# CLAUDE.md — world/src/places/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `world/CONTEXT.md` → `world/CLAUDE.md`
→ `world/src/CONTEXT.md` → `world/src/CLAUDE.md` → this folder's `CONTEXT.md` (imported
above) → this file.

## Purpose (one line)

Give each place the story uses one file that fixes its layout, distances and feel, so that
every scene set there agrees with every other.

## How to work here

- **Routing:** skill `create-name`; workflow `world/workflows/02-create-a-place/`; guide
  `world/docs/reference/story-bible.md`.
- **Model:** **Opus** throughout (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** fix the place's job in the story → read the register, the other place
  files and the timeline → kind, scale and distances → name → senses and history → who holds
  it → write the file → register the name.
- **Definition of done:** a scene could be set here without inventing anything, every journey
  the story makes to or from it has a duration, and its name is registered.

## Guardrails

- **Distances and travel times are facts.** Record them in hours or days by the means of
  travel the story uses, and check them against `planning/src/timeline.md`.
- **Senses over inventory.** Record what a character would notice, not a list of buildings.
- **Real places are researched, not remembered.** A place drawn from a real one cites its
  entry in `research/src/setting/`; a detail that cannot be checked is flagged `VERIFY`.
- **Nest, do not repeat.** A room links to its building with `within`; the building does not
  restate the room.
- **Never overwrite an existing place file** without confirming with the author.

## Output & naming

- **Hand-written:** `world/src/places/<slug>.md`, one sentence per line:

```markdown
---
name: ""                 # exactly as registered
ipa: ""                  # broad IPA, no slashes; empty for an English name
kind: ""                 # settlement | building | room | river | road | region | other
within: ""               # the slug of the larger place, if any
first_appears: ""        # <unit-slug>/<section-slug>, empty until promoted prose uses it
---

## What it is
## Geography and distances
## Senses
## History
## Who holds it and its rules
## Continuity facts
```

- **Generated:** nothing here.
