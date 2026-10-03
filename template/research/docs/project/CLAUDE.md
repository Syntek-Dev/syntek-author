@./CONTEXT.md

# CLAUDE.md — research/docs/project/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `research/CONTEXT.md` →
`research/CLAUDE.md` → `research/docs/CONTEXT.md` → `research/docs/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold the author's research guides, which override or extend the template's.

## How to work here

- **Routing:** a guide here with the same name as one in `research/docs/reference/` wins; read it
  instead of the reference guide.
- **Model:** **Opus** for writing or changing a guide (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps to add a guide:**
  1. Confirm with the author that a real, recurring judgement call has no home.
  2. Copy the reference guide's shape: routing frontmatter, the metadata header, `**What it is.**`,
     two to five topic sections, `## How we apply it here`, `## Who implements it`,
     `## Governing standard`.
  3. Keep it between roughly 50 and 80 lines; if it grows into rules, the rules belong in
     `standards/`.
  4. Add a line for it to this folder's `CONTEXT.md`.
- **Definition of done:** the guide is short, defers to a standard, names its skill and workflow,
  and the author has agreed it.

## Guardrails

- **Only on the author's word.** A project guide changes how the evidence base is built; no skill
  writes one unasked (`.claude/rules/syntek-author/06-global-rules.md`).
- **Author-owned.** `copier update` never touches files here, this seeded pair included.
- **Override by name, not by contradiction.** If a project guide and a reference guide disagree,
  give the project guide the reference guide's name so there is exactly one answer.

## Output & naming

- **Hand-written:** every file here.
- **Naming:** kebab-case `.md`, named for the question the guide answers.
