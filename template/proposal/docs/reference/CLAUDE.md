@./CONTEXT.md

# CLAUDE.md — proposal/docs/reference/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `proposal/CONTEXT.md` →
`proposal/CLAUDE.md` → `proposal/docs/CONTEXT.md` → `proposal/docs/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file → the guide you need.

## Purpose (one line)

Hold the template's proposal guides, read mid-task and never edited in place.

## How to work here

- **Routing:** check `proposal/docs/project/` for a same-named guide first; if one exists, it wins.
  Otherwise read the guide here that matches the task:
<: if DOC_TYPE == 'theology' :>  - assembling the proposal, or deciding whom to ask for an endorsement →
    `book-proposal-anatomy.md` (skill `build`);
<: endif :><: if DOC_TYPE == 'fiction' :>  - assembling the query package, or deciding which agents to query →
    `query-package-anatomy.md` (skill `build`);
<: endif :>  - choosing and checking comparable titles → `comp-titles.md` (skill `research`);
  - drafting one approach → `approaching-readers.md` (skill `approach-a-reader`).
- **Model:** **Opus** for reading and applying a guide
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** read the guide → read its governing standard → apply it through the workflow
  it names → if the practice does not fit this project, propose a project guide to the author
  rather than bending the reference one.
- **Definition of done:** the guide's practice was applied through its workflow, and any departure
  the project needs is recorded in a same-named guide in `proposal/docs/project/`, with the
  author's agreement.

## Guardrails

- **Never edit a guide in this folder.** `copier update` replaces it; an in-place edit is lost on
  the next update.
- **The anatomy guide owns the variant detail.** The shared procedures in `proposal/workflows/`
  defer to it for the parts of the package, the reader, the tracker and its statuses. Keep that
  detail in one place.
- **A guide never outranks a standard.** If a guide and its standard disagree, the standard is
  right; report the disagreement to the author.

## Output & naming

- **Template-owned:** every guide here, and this pair.
- **Hand-written by the author:** nothing here; project guides go in `proposal/docs/project/`.
- **Naming:** kebab-case `.md`, named for the question the guide answers.
