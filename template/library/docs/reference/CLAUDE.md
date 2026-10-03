@./CONTEXT.md

# CLAUDE.md — library/docs/reference/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/docs/CONTEXT.md` → `library/docs/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold the template's reference guides for the business library, read before any document work and
never edited in place.

## How to work here

- **Routing:** read the guide the workflow step names (each step's `**Guide:**` line). Before
  reading a guide here, check `library/docs/project/` for a same-named file: if one exists, it is
  the guide for this project.
- **Model:** **Opus**; reading a guide is part of the substantive work it serves.
- **Concrete steps:**
  1. Read the guide's routing frontmatter and load the skills it names.
  2. Read the guide, then the governing standard it cites.
  3. Apply it in the step that sent you here.
- **Definition of done:** the step that cited the guide was carried out the way the guide says,
  or the deviation was recorded with the author's reason.

## Guardrails

- **Template-owned: never edit these files.** A change here is lost or conflicts on the next
  `copier update`. Override in `library/docs/project/` with the same filename instead.
- **The standard wins.** If a guide here contradicts a file in `standards/`, follow the standard
  and report the contradiction to the author.
- **Examples are invented.** Every party, figure and place in these guides is made up; never copy
  one into a real document.

## Output & naming

- **Hand-written:** none in this project; these files arrive with the template.
- **Naming:** kebab-case guides, each named for the question it answers.
