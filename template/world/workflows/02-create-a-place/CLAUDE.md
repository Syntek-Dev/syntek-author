@./CONTEXT.md

# CLAUDE.md — world/workflows/02-create-a-place/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `world/CONTEXT.md` → `world/CLAUDE.md`
→ `world/workflows/CONTEXT.md` → `world/workflows/CLAUDE.md` → this folder's `CONTEXT.md`
(imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Fix a place once (its layout, distances, feel and rules) so that every scene set there, and
every journey to it, agrees with every other.

## How to work here

- **Routing:** skill `create-name` (the name); guides `world/docs/reference/story-bible.md` and
  `world/docs/reference/naming.md`; for a place drawn from a real one,
  `research/docs/reference/real-world-detail.md` and `research/workflows/02-verify-a-claim/`.
- **Model:** **Opus** for every step that decides something about the place; the mechanical
  tier for creating the file and adding the register row
  (`.claude/rules/syntek-author/05-model-allocation.md`). The checklist tags are authoritative.
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go: the job in
  the story → read the bible → kind, scale and distances → name → senses and history → who
  holds it → real-world check → write the file → register the name → hand back.
- **Definition of done:** a scene could be set here without inventing anything; every journey
  the story makes to or from the place has a duration that fits `planning/src/timeline.md`; the
  name is registered.

## Guardrails

- **Distances are facts, and they are checked.** Record travel times by the means of travel the
  story uses, and test each against the timeline before writing them down.
- **Senses over inventory.** Record what a point-of-view character would notice, not every
  building.
- **Real places are researched, not remembered.** Anything drawn from a real place is checked
  through `research/workflows/02-verify-a-claim/`, or flagged `VERIFY` until it is.
- **Offer, do not decide.** The author chooses the name and every fact the book will rely on.
- **Contradictions are reported, never repaired.**
- **Never overwrite an existing place file** without confirming with the author.

## Output & naming

- **Produces:** `world/src/places/<slug>.md`, the slug being the registered name in kebab-case.
- **Also writes:** a row in `world/src/names-register.md`.
- **Generated:** nothing.
- **Does not touch:** promoted prose, `planning/src/timeline.md` (a clash is reported for the
  author to resolve there), or any standard.
