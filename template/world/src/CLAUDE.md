@./CONTEXT.md

# CLAUDE.md — world/src/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `world/CONTEXT.md` → `world/CLAUDE.md`
→ this folder's `CONTEXT.md` (imported above) → this file → the target subfolder's pair.

## Purpose (one line)

Record, once each, the facts and names the novel relies on, in a form the prose can be checked
against.

## How to work here

- **Routing:** each kind of entry has a procedure: characters
  `world/workflows/01-create-a-character/`, places `world/workflows/02-create-a-place/`, any
  single name `world/workflows/03-name-something/`<: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>, creatures
  `world/workflows/04-create-a-creature/`, cultures `world/workflows/05-create-a-culture/`,
  peoples `world/workflows/10-create-a-people/`, eras and events
  `world/workflows/11-chart-the-world-history/`<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>, languages
  `world/workflows/06-build-a-language/`<: endif :>.
- **Model:** **Opus** for every entry and every check; the mechanical tier only for adding a
  register row the author has already decided (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:**
  1. Read `world/src/names-register.md` and the files of the same kind before writing.
  2. Draft the entry with the author, following the target folder's format.
  3. Register every new name, then hand back the open questions as `AUTHOR TO CONFIRM` flags.
- **Definition of done:** the fact or name exists in exactly one file, nothing it says
  contradicts an existing entry or `planning/src/continuity.md` unreported, and its name is in
  the register.

## Guardrails

- **One fact, one home.** If two files would both state a fact, one states it and the other
  links to it. Two copies drift, and the drift reaches the prose.
- **Never invent on the author's behalf.** Options are offered; the author chooses. A gap is
  flagged `<!-- AUTHOR TO CONFIRM: … -->`, not filled.
- **Report contradictions with both locations; never repair them silently.**
- **Frozen once used.** A fact or name already in promoted prose changes only with the
  author's word, after the affected sections are listed.
- **The register is append-only.** A retired name keeps its row, marked retired with the date.
- **Never overwrite an existing entry** without confirming with the author.

## Output & naming

- **Hand-written:** `<slug>.md` per entry, the slug being the registered name in kebab-case;
  one sentence per line, applied when a paragraph is edited, never by mass reflow.
- **Seeded:** `names-register.md`<: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>, `world/src/history/eras.md`<: endif :>: each ships once and is
  never replaced by `copier update`; if deleted, the next update restores it empty.<: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>
- **Seeded once:** the example people and culture, which `copier update` never brings back.<: endif :>
- **Template-owned:** `.gitignore`, which keeps constructed-language audio out of Git whether or
  not the kit is installed; `copier update` keeps it current, so never edit it here.
- **Generated (never hand-edit):** nothing in this folder<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>, apart from each language's
  audio, which `world/src/.gitignore` ignores<: endif :>.
