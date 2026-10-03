@./CONTEXT.md

# CLAUDE.md — world/workflows/05-create-a-culture/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `world/CONTEXT.md` → `world/CLAUDE.md`
→ `world/workflows/CONTEXT.md` → `world/workflows/CLAUDE.md` → this folder's `CONTEXT.md`
(imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Describe a culture from the ground up, so that its characters, customs and names are consistent
and its departures from type mean something.

## How to work here

- **Routing:** skill `create-name` for the naming customs and sample names; the rest is built
  with the author step by step; guides `world/docs/reference/cultures.md` and
  `world/docs/reference/naming.md`; depiction risk in `standards/risk/FICTION.md`.
- **Model:** **Opus** for every step that decides something about the culture; the mechanical
  tier for creating the file and adding register rows
  (`.claude/rules/syntek-author/05-model-allocation.md`). The checklist tags are authoritative.
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go: the job in
  the story → read the world, the people's file first → land and livelihood → values, taboos and beliefs → power, kinship
  and customs → naming customs → variety and neighbours → depiction check → write the file →
  register the names → hand back.
- **Definition of done:** every custom has a reason in the land or the values; the culture
  holds disagreement; the naming customs are concrete enough to generate names from; the
  depiction check is recorded; the names are registered.

## Guardrails

- **Ground first.** The people before the culture; land and work before values; values before
  customs. A culture built from its festivals inwards cannot explain itself.
- **Write down what speech and writing will need.** Materials and tools, the domains that need
  many words, forms of address and sacred words are recorded plainly, because language work
  reads them here rather than guessing.
- **No monocultures.** Record at least one internal division; a people with one opinion is a
  character.
- **Borrow with care, and say so.** Anything drawn from a real people is recorded in the file
  and checked against `standards/risk/FICTION.md` before prose relies on it.
- **Offer, do not decide.** The author chooses each value, custom and name.
- **Report contradictions with existing characters, places or prose; never repair them.**
- **Never overwrite an existing culture file** without confirming with the author.

## Output & naming

- **Produces:** `world/src/cultures/<slug>.md`, the slug being the culture's registered name (or
  its people's, when the culture has no name of its own) in kebab-case.
- **Also writes:** rows in `world/src/names-register.md`, never a second row for the people's
  name.
- **Generated:** nothing.
- **Does not touch:** promoted prose, character files (a character who now contradicts the
  culture is reported for the author to resolve), or any standard.
