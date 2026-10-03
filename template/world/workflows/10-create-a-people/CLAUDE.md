@./CONTEXT.md

# CLAUDE.md — world/workflows/10-create-a-people/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `world/CONTEXT.md` → `world/CLAUDE.md`
→ `world/workflows/CONTEXT.md` → `world/workflows/CLAUDE.md` → this folder's `CONTEXT.md`
(imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Describe what a people is, body first, so that its cultures, its languages and its characters
rest on facts rather than guesses, and so that no people is a real group in disguise.

## How to work here

- **Routing:** skills `grill-with-docs` (each section, settled with the author and recorded in
  the file as it resolves) and `create-name` (the people's name); guide
  `world/docs/reference/peoples.md`; depiction risk in `standards/risk/FICTION.md`.
- **Model:** **Opus** for every step that decides something about the people; the mechanical
  tier for creating the file and adding the register row
  (`.claude/rules/syntek-author/05-model-allocation.md`). The checklist tags are authoritative.
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go: the job in
  the story → read the world → name or working name → create the file → what they are → body
  and speech → lifespan → numbers and spread → homelands and movements → relations → depiction
  check → register → hand back.
- **Definition of done:** every section is settled or flagged; Body and speech is never blank;
  every movement the file relies on is an event file or on the hand-back list; the depiction
  note is filled; the name is registered.

## Guardrails

- **Body first.** Physiology before lifespan, lifespan before history, history before culture.
  A people described from its customs inwards leaves its body to be guessed.
- **'Human, no constraint' is an answer; a blank is not.** Write it down, so that nobody
  building a language later has to guess.
- **A people is not its culture.** Values, customs and rites belong in a culture file; offer
  `world/workflows/05-create-a-culture/` rather than writing them here.
- **Movements are history.** Name each migration, conquest or contact as an event to chart; do
  not narrate it here.
- **Flag a hostile people modelled on a real one, every time.** Run the check in
  `standards/risk/FICTION.md`, offer alternatives, and record the outcome in the note.
- **Offer, do not decide.** The author chooses each fact and the name.
- **Never overwrite an existing people file** without confirming with the author.

## Output & naming

- **Produces:** `world/src/peoples/<slug>.md`, the slug being the people's registered name in
  kebab-case (a working slug, flagged, until the name is settled).
- **Also writes:** a row in `world/src/names-register.md`.
- **Generated:** nothing.
- **Does not touch:** culture files, history files, language files, character files or
  promoted prose; anything they now contradict is reported for the author to resolve.
