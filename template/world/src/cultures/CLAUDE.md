@./CONTEXT.md

# CLAUDE.md — world/src/cultures/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `world/CONTEXT.md` → `world/CLAUDE.md`
→ `world/src/CONTEXT.md` → `world/src/CLAUDE.md` → this folder's `CONTEXT.md` (imported
above) → this file.

## Purpose (one line)

Record each people's way of life once, so that every character, custom and name from that
people is consistent with it.

## How to work here

- **Routing:** skill `create-name` for naming customs and sample names; workflow
  `world/workflows/05-create-a-culture/`; guide `world/docs/reference/cultures.md`.
- **Model:** **Opus** throughout (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** fix the culture's job in the story → read its people's file, and the
  places, characters, history and other cultures it touches → land and livelihood → values and taboos → beliefs and rites →
  power and kinship → customs → naming customs → variety and neighbours → depiction check →
  write the file → register its own name (only when it differs from its people's, which is
  never registered twice) and the sample names the book will use.
- **Definition of done:** a character from this people could be written without inventing a
  custom, every custom has a reason in the land or the values, and the naming customs are
  concrete enough for `create-name` to follow.

## Guardrails

- **Values before customs.** A custom with no reason behind it cannot be broken meaningfully
  by a character; find the reason or cut the custom.
- **No monocultures.** Record disagreement inside the people; a culture with one opinion is a
  character, not a people.
- **Borrow with care.** Where the culture draws on a real one, record what was borrowed and
  run the depiction check in `standards/risk/FICTION.md` before the prose relies on it.
- **Link, do not restate.** A culture names its people in `people`; a character file names
  its culture. Bodies and lifespans stay in the people file, customs in the culture file.
- **Record what speech and writing will need.** Name the materials and tools people write on
  and with, how rank is spoken to, and which words are sacred; language work reads them here
  rather than guessing.
- **Never overwrite an existing culture file** without confirming with the author.

## Output & naming

- **Hand-written:** `world/src/cultures/<slug>.md`, one sentence per line:

```markdown
---
name: ""                 # exactly as registered
ipa: ""                  # broad IPA, no slashes
people: ""               # the slug of its people file in world/src/peoples/
homeland: ""             # the slug of its place file
first_appears: ""        # <unit-slug>/<section-slug>, empty until promoted prose uses it
---

<!-- INTERNAL NOTE: depiction check, DD/MM/YYYY. What this culture borrows from real peoples, if anything, and the outcome. -->

## Land and livelihood
## Values and taboos
## Beliefs and rites
## Power and kinship
## Customs
## Naming customs
## Variety and neighbours
## Role in the story
## Continuity facts
```

- **Seeded once:** `example-culture.md`, the worked example; never restored by `copier update`.
- **Generated:** nothing here.
