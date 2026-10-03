@./CONTEXT.md

# CLAUDE.md — world/workflows/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `world/CONTEXT.md` → `world/CLAUDE.md`
→ this folder's `CONTEXT.md` (imported above) → this file → the chosen procedure's own four
files.

## Purpose (one line)

Hold the world layer's procedures, so that every character, place and name is made the same
way, checked the same way and recorded in the same place, whoever runs the job.

## How to work here

Two modes: **running** a procedure (the normal case) and **changing** one (rare).

**Running one.** Pick by what you are doing. Check `world/workflows/local/` first: a local
procedure with the same slug replaces the one here (`run-workflow` does this for you).

| You want to… | Procedure |
|---|---|
| Bring a significant character into the book | `world/workflows/01-create-a-character/` |
| Set scenes in a new place | `world/workflows/02-create-a-place/` |
| Name a minor character, object, title or anything else | `world/workflows/03-name-something/` |
<: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>| Add a creature to the bestiary | `world/workflows/04-create-a-creature/` |
| Describe how a people lives: values, customs, naming | `world/workflows/05-create-a-culture/` |
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>| Start a constructed language, or change its sound system | `world/workflows/06-build-a-language/` |
| Coin a word in a constructed language | `world/workflows/07-add-a-word/` |
| Design or extend a language's script | `world/workflows/08-design-a-script/` |
| Hear how a word or name is said | `world/workflows/09-record-a-pronunciation/` |
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>| Describe a people: what they are, their bodies, lifespans and homelands | `world/workflows/10-create-a-people/` |
| Chart the eras, migrations, conquests and contact of the world's past | `world/workflows/11-chart-the-world-history/` |
<: endif :>
Read the procedure's `CONTEXT.md` → `CLAUDE.md` → `STEPS.md`, then work `STEPS.md` in order
with `CHECKLIST.md` open.

- **Routing:** each `STEPS.md` names its skills in its frontmatter and its skill and guide on
  every step; `run-workflow` resolves an intent to a procedure.
- **Model:** the `_opus_` / `_sonnet_` tags in each `CHECKLIST.md` are authoritative: Opus for
  every judgement, the mechanical tier for creating files, running `make` and ticking boxes
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps (changing one):** confirm with the author first → change all four files
  together → keep steps numbered and marked _Substantive._ or _Mechanical._ → record anything
  that overturns an earlier decision in `.claude/MEMORY.md`. A new procedure goes in
  `world/workflows/local/`, never here.
- **Definition of done (running):** every checklist item ticked or explicitly waived with a
  reason; the artefact is where the procedure says it should be; every new name is registered.

## Guardrails

- **Order is load-bearing.** Reading the register comes before inventing a name; ecology comes
  before a creature's powers; a people comes before its culture, and the world before its
  language; phonology comes before words. Reversed, each produces work that has to be redone.
- **Procedures cite rules; they never restate them.** If a step explains why the story bible is
  the source of truth, that explanation belongs in the standard. Point at it.
- **The author chooses.** Every procedure offers options; none picks a name or a fact on the
  author's behalf.
- **A waived step is recorded, not silent.** Say which step and why in the hand-back.
- **Numbers are frozen.** Never renumber or reuse a procedure number; the template appends.

## Output & naming

- **Hand-written:** nothing here by the author; template procedures are template-owned and
  replaced by `copier update`. The author's procedures go in `world/workflows/local/`.
- **Folders:** `<NN>-<verb-first-name>/`, four files each, always.
- **Procedures produce nothing here.** Entries land in `world/src/`; generated files land in
  the build folder.
