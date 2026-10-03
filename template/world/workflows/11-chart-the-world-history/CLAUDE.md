@./CONTEXT.md

# CLAUDE.md — world/workflows/11-chart-the-world-history/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `world/CONTEXT.md` → `world/CLAUDE.md`
→ `world/workflows/CONTEXT.md` → `world/workflows/CLAUDE.md` → this folder's `CONTEXT.md`
(imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Put the world's past in one order, era by era, with every event that shaped a people placed in
it and its marks on language stated, so that nothing later contradicts it.

## How to work here

- **Routing:** skills `grill-with-docs` (the reckoning, each era and each event, recorded as it
  resolves), `wayfinder` (a decision map, when the history is too large for one sitting) and
  `create-name` (any invented name for an event or an era); guide
  `world/docs/reference/world-history.md`.
- **Model:** **Opus** for every era, event and consequence; the mechanical tier for creating
  event files and adding rows the author has decided
  (`.claude/rules/syntek-author/05-model-allocation.md`). The checklist tags are authoritative.
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go: what the
  story needs → read the world → map it if it is large → the reckoning → the eras → choose the
  events → create each file → settle each event → trace its linguistic consequences → what each
  people remembers → check against the world → register names → hand back.
- **Definition of done:** every event belongs to one era; every era and event the author settled
  is recorded; each event states its linguistic consequences or says there were none; every
  contradiction with another file is reported; the language work is listed for the author.

## Guardrails

- **Eras before events, order before dates.** An event with no era is not yet placed; a year is
  given only when the story or a language needs one.
- **Depth on demand.** Chart an event only when its consequences reach the page or a language.
- **The record and the memory are kept apart.** Each people's version is recorded as belief;
  none replaces what happened.
- **Consequences are stated, not implied.** 'No loanwords, no split, no script' is written down
  when it is true.
- **This procedure does not change a language.** A split, loan or borrowed script is listed for
  the language procedures; the author decides how it shows in the words.
- **Offer, do not decide.** The author chooses every era, event and consequence.
- **Never overwrite an event file or an era row** without confirming with the author.

## Output & naming

- **Produces:** rows in `world/src/history/eras.md` and event files at
  `world/src/history/<slug>.md`, the slug being the event's name in kebab-case.
- **Also writes:** a map in `planning/src/maps/` when one is charted, and register rows for any
  invented names.
- **Generated:** nothing.
- **Does not touch:** people, culture, place or language files, `planning/src/timeline.md`, or
  promoted prose; anything they now contradict is reported for the author to resolve.
