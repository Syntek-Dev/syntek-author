@./CONTEXT.md

# CLAUDE.md — world/src/history/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `world/CONTEXT.md` → `world/CLAUDE.md`
→ `world/src/CONTEXT.md` → `world/src/CLAUDE.md` → this folder's `CONTEXT.md` (imported
above) → this file.

## Purpose (one line)

Keep one ordered record of the world's past, so that every people, culture and language can say
when it came to be as it is, and why.

## How to work here

- **Routing:** skills `grill-with-docs` (eras and events, recorded as each resolves) and
  `wayfinder` (a decision map when the history is too large for one sitting); workflow
  `world/workflows/11-chart-the-world-history/`; guide `world/docs/reference/world-history.md`.
- **Model:** **Opus** for every era and event; the mechanical tier only for adding a row or a
  file the author has already decided (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:**
  1. Read `world/src/history/eras.md`, the event files, the people and culture files they touch,
     and `planning/src/timeline.md`.
  2. Settle the era first, then the event inside it; an event with no era is not yet placed.
  3. Write the event file from the skeleton below, add its slug to the era's Events cell, and
     hand back the open questions as `AUTHOR TO CONFIRM` flags.
- **Definition of done:** every event belongs to one era in `eras.md`, names the peoples and
  places it touched, states its linguistic consequences (or says there were none), and
  contradicts no people, culture, place or timeline entry unreported.

## Guardrails

- **Order before dates.** Settle which era comes before which; give years only when the story
  or a language needs them. A precise date invites a contradiction.
- **Depth on demand.** Chart an event only when its consequences reach the page or a language.
  An event nobody feels is one more fact that can contradict a chapter.
- **What happened and what is remembered are kept apart.** A character knows their people's
  version, not the record; mixing the two lets a character know too much.
- **Consequences are stated, not implied.** If an event left no loanwords, no split and no
  borrowed script, say so in the section, so that nobody invents one later.
- **This folder does not change a language.** A loan or a split recorded here is handed to the
  language procedures, where the author decides how it shows in the words.
- **Never overwrite an existing event file or era row** without confirming with the author.

## Output & naming

- **Seeded:** `eras.md` ships once and is never replaced by `copier update`; if it is deleted,
  the next update restores an empty one.
- **Hand-written:** `world/src/history/<slug>.md`, one sentence per line:

```markdown
---
name: ""                 # the event as the story names it; registered if the name is invented
kind: ""                 # migration | conquest | contact | split | founding | catastrophe | other
era: ""                  # the era, exactly as written in world/src/history/eras.md
when: ""                 # in the world's reckoning, as precise as the story needs
peoples: []              # slugs of the people files involved
places: []               # slugs of the place files involved
first_appears: ""        # <unit-slug>/<section-slug>, empty until promoted prose uses it
---

## What happened
## Causes
## Who it changed, and how
## Linguistic consequences
## What each people remembers
## Role in the story
## Continuity facts
```

- **Generated:** nothing here.
