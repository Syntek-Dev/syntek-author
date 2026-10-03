@./CONTEXT.md

# CLAUDE.md — research/docs/reference/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `research/CONTEXT.md` →
`research/CLAUDE.md` → `research/docs/CONTEXT.md` → `research/docs/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file → the guide you need.

## Purpose (one line)

Hold the template's research guides, read mid-task and never edited in place.

## How to work here

- **Routing:** check `research/docs/project/` for a same-named guide first; if one exists, it wins.
  Otherwise read the guide here that matches the task:
  - reading a work into the evidence base → `ingesting-sources.md` (skill `research`);
  - checking a claim before it is written → `vetting-evidence.md` (skill `fact-check`);
<: if DOC_TYPE == 'theology' :>  - a passage serious Christians read more than one way → `contested-readings.md` (skill
    `tradition-check`);
<: endif :><: if DOC_TYPE == 'fiction' :>  - the real world the novel depicts → `real-world-detail.md` (skills `research`, `fact-check`);
<: endif :><: if DOC_TYPE != 'business' and INCLUDE_SENSITIVE_CONTENT :>  - first-person testimony → `handling-testimony.md` (skill `sensitivity-pass`), after
    `standards/risk/sensitive-content.md`.
<: endif :>- **Model:** **Opus** for reading and applying a guide; nothing here is mechanical work
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** read the guide → read its governing standard, named at its foot → apply it
  through the workflow it names → if the practice here does not fit this project, propose a
  project guide to the author rather than bending the reference one.
- **Definition of done:** the guide's practice was applied through its workflow, and any departure
  the project needs is recorded in a same-named guide in `research/docs/project/`, with the
  author's agreement.

## Guardrails

- **Never edit a guide in this folder.** `copier update` replaces it, so an in-place edit is lost
  on the next update and drifts from every project that shares the template.
- **A guide never outranks a standard.** If a guide and its standard disagree, the standard is
  right; report the disagreement to the author.
- **Keep the one verdict vocabulary.** `vetting-evidence.md` defines it; every evidence entry,
  procedure and project guide uses the same six words. A second vocabulary is how two notes
  disagree about the same claim without anyone noticing.

## Output & naming

- **Template-owned:** every guide here, and this pair.
- **Hand-written by the author:** nothing here; project guides go in `research/docs/project/`.
- **Naming:** kebab-case `.md`, named for the question the guide answers.
