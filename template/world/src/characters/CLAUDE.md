@./CONTEXT.md

# CLAUDE.md — world/src/characters/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `world/CONTEXT.md` → `world/CLAUDE.md`
→ `world/src/CONTEXT.md` → `world/src/CLAUDE.md` → this folder's `CONTEXT.md` (imported
above) → this file.

## Purpose (one line)

Give each significant character one file that the prose, the arc and the voice checks can all
be measured against.

## How to work here

- **Routing:** skills `create-name` and `chart-character-arc`; workflow
  `world/workflows/01-create-a-character/`; guide `world/docs/reference/story-bible.md`.
- **Model:** **Opus** throughout; a character is judgement from the first line
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** fix the character's job in the story → read the register and the other
  character files → want, need, wound and the lie → name → voice markers → relationships and
  continuity facts → write the file → register the name → open the arc file.
- **Definition of done:** a reader-facing scene could be written from this file without
  inventing anything the author has not agreed, and the `character-voice` skill has markers
  concrete enough to check dialogue against.

## Guardrails

- **Want and need must differ.** A character whose want is their need has no inner conflict to
  resolve; say so to the author rather than papering over it.
- **Voice markers are testable or they are useless.** 'Speaks formally' cannot be checked;
  'never uses contractions; addresses elders by title' can.
- **Example lines are invented and marked as examples.** Never quote promoted prose here; link
  to the section instead, so a later edit to the prose does not leave a stale copy.
- **Relationships link, they do not restate.** Each person named has their own file or row.
- **Continuity facts carry their section once promoted prose uses them**; until then they are
  decisions, not yet facts the reader has.
- **Never overwrite an existing character file** without confirming with the author.

## Output & naming

- **Hand-written:** `world/src/characters/<slug>.md`, one sentence per line:

```markdown
---
name: ""                 # exactly as registered
ipa: ""                  # broad IPA, no slashes
role: ""                 # protagonist | antagonist | supporting | minor
first_appears: ""        # <unit-slug>/<section-slug>, empty until promoted prose uses it
arc: planning/src/arcs/<slug>.md
---

## Want
## Need
## Wound and the lie
## Voice markers
## Relationships
## Continuity facts
```

- **Generated:** nothing here.
