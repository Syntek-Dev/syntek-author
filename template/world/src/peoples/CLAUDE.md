@./CONTEXT.md

# CLAUDE.md — world/src/peoples/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `world/CONTEXT.md` → `world/CLAUDE.md`
→ `world/src/CONTEXT.md` → `world/src/CLAUDE.md` → this folder's `CONTEXT.md` (imported
above) → this file.

## Purpose (one line)

Record what each people is, once, so that their cultures, their languages and every character
born among them rest on the same body, lifespan and past.

## How to work here

- **Routing:** skills `grill-with-docs` (each section, settled with the author and recorded as
  it resolves) and `create-name` (the people's name); workflow
  `world/workflows/10-create-a-people/`; guide `world/docs/reference/peoples.md`.
- **Model:** **Opus** throughout (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** fix the people's job in the story → read the register, the other peoples,
  the cultures, the places and `world/src/history/` → name, or agree a working name → what
  they are → body and speech → lifespan and generations → numbers and spread → homelands and
  movements → relations to other peoples → depiction check → write the file → register the
  name.
- **Definition of done:** a culture or a language for this people could be built without
  inventing anything about their bodies, lifespan or past; every move or contact the file
  relies on is an event file or a flagged gap; the depiction note is filled; the name is
  registered.

## Guardrails

- **Body and speech are never left blank.** Write 'human, no constraint' when that is the
  answer. A blank leaves the next person to guess, and a guessed physiology reaches the
  language as a sound the speakers could never make.
- **A people is not its culture.** Customs, values and rites go in the culture file, which
  names this people; this file holds what they are.
- **Movements are history.** A migration, conquest or contact the file depends on is charted
  in `world/src/history/`, and linked here by its slug; it is not narrated twice.
- **A hostile people is never a real one in disguise.** Where the story casts a people as an
  enemy or as 'evil', run the depiction check in `standards/risk/FICTION.md` before anything
  else is built on them, and record the outcome in the note.
- **Never overwrite an existing people file** without confirming with the author.

## Output & naming

- **Hand-written:** `world/src/peoples/<slug>.md`, one sentence per line:

```markdown
---
name: ""                 # exactly as registered
ipa: ""                  # broad IPA, no slashes; empty for an English name
kind: ""                 # human | humanlike | non-human | other
homelands: []            # slugs of place files, oldest first
first_appears: ""        # <unit-slug>/<section-slug>, empty until promoted prose uses it
---

<!-- INTERNAL NOTE: depiction check, DD/MM/YYYY. What this people borrows from real peoples, if anything; whether the story casts them as hostile; the outcome. -->

## What they are
## Body and speech
## Lifespan and generations
## Numbers and spread
## Homelands and movements
## Relations to other peoples
## Role in the story
## Continuity facts
```

- **Seeded once:** `example-people.md`, the worked example; never restored by `copier update`.
- **Generated:** nothing here.
