@./CONTEXT.md

# CLAUDE.md — world/workflows/01-create-a-character/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `world/CONTEXT.md` → `world/CLAUDE.md`
→ `world/workflows/CONTEXT.md` → `world/workflows/CLAUDE.md` → this folder's `CONTEXT.md`
(imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Turn the author's idea of a character into one file the whole book can rely on: a person with a
want, a need, a reason for both, a name and a voice.

## How to work here

- **Routing:** skills `chart-character-arc` (want, need, wound and the lie; the arc file) and
  `create-name` (the name); guides `world/docs/reference/story-bible.md` and
  `world/docs/reference/naming.md`; the arc's beats continue in
  `planning/workflows/04-chart-a-character-arc/`.
- **Model:** **Opus** for every step that decides something about the character; the
  mechanical tier for creating the file and adding the register row
  (`.claude/rules/syntek-author/05-model-allocation.md`). The checklist tags are authoritative.
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go: the job in
  the story → read the bible → want, need, wound and the lie → name → voice markers →
  relationships and continuity facts → write the file → register the name → open the arc file
  → hand back.
- **Definition of done:** a scene with this character could be drafted without inventing
  anything about them; their want and need differ; their voice markers are concrete enough to
  test dialogue against; their name is registered; their arc file exists.

## Guardrails

- **Read before inventing.** A new character who shares an initial, a role or a backstory beat
  with an existing one weakens both. The register and the existing files come first.
- **Offer, do not decide.** Give two or three options for want, need and wound, and three to
  five for the name, each with a reason. The author chooses.
- **Want and need must pull against each other.** If they do not, say so; do not paper over it.
- **No details by accident.** Every fixed detail (age, appearance, family) is one the author
  agreed. Anything undecided is flagged, not filled.
- **Contradictions are reported, never repaired.** If the new character conflicts with
  existing prose or files, list both locations for the author.
- **Never overwrite an existing character or arc file** without confirming with the author.

## Output & naming

- **Produces:** `world/src/characters/<slug>.md`, the slug being the registered name in
  kebab-case.
- **Also writes:** a row in `world/src/names-register.md`; `planning/src/arcs/<slug>.md`.
- **Generated:** nothing.
- **Does not touch:** promoted prose, `planning/src/continuity.md` (facts enter it when prose
  establishes them), or any standard.
