@./CONTEXT.md

# CLAUDE.md — world/workflows/04-create-a-creature/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `world/CONTEXT.md` → `world/CLAUDE.md`
→ `world/workflows/CONTEXT.md` → `world/workflows/CLAUDE.md` → this folder's `CONTEXT.md`
(imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Make a creature the story can keep its promises about: believable in its world, bound by hard
limits, and beatable only in ways the reader was shown.

## How to work here

- **Routing:** skill `create-creature` (the whole entry, including its names, checked against
  the world); guide `world/docs/reference/creatures.md`.
- **Model:** **Opus** for every step that decides something about the creature; the mechanical
  tier for creating the file and adding register rows
  (`.claude/rules/syntek-author/05-model-allocation.md`). The checklist tags are authoritative.
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go: the job in
  the story → read the world → ecology → anatomy and behaviour → rules, limits and weaknesses →
  lore and names → check against the world → write the entry → register the names → hand back.
- **Definition of done:** the entry states its limits as hard rules; every weakness the plot
  uses is linked to its set-up; nothing contradicts another world file unreported; its names
  are registered.

## Guardrails

- **Ecology before powers.** A creature built from its abilities outwards reads as a plot
  device. Diet, habitat and predators come first, and the body follows from them.
- **Limits are promises.** Write them as rules the story will keep ('cannot cross running
  water'), not as tendencies.
- **A weakness is planted before it is used.** If `planning/src/causality.md` has no set-up for
  it, say so in the hand-back; never invent one in a chapter.
- **Belief is not fact.** Each culture's lore is attributed to that culture.
- **Report contradictions with both locations; never repair them.**
- **Never overwrite an existing entry** without confirming with the author.

## Output & naming

- **Produces:** `world/src/creatures/<slug>.md`, the slug being the creature's main registered
  name in kebab-case.
- **Also writes:** rows in `world/src/names-register.md`.
- **Generated:** nothing.
- **Does not touch:** promoted prose, `planning/src/causality.md` or `planning/src/quests/`
  (missing set-ups and quest links are reported for the author to add there).
