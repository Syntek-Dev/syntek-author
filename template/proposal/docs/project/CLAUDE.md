@./CONTEXT.md

# CLAUDE.md — proposal/docs/project/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `proposal/CONTEXT.md` →
`proposal/CLAUDE.md` → `proposal/docs/CONTEXT.md` → `proposal/docs/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold the author's proposal guides, which override or extend the template's.

## How to work here

- **Routing:** a guide here with the same name as one in `proposal/docs/reference/` wins; read it
  instead of the reference guide.
- **Model:** **Opus** for writing or changing a guide
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps to add a guide:**
  1. Confirm with the author that a real, recurring judgement call has no home, or that a
     publisher or agent requires a different format.
  2. Copy the reference guide's shape: routing frontmatter, the metadata header, `**What it is.**`,
     two to five topic sections, `## How we apply it here`, `## Who implements it`,
     `## Governing standard`.
  3. Keep it between roughly 50 and 80 lines.
  4. Add a line for it to this folder's `CONTEXT.md`.
- **Definition of done:** the guide is short, defers to a standard, names its skill and workflow,
  and the author has agreed it.

## Guardrails

- **Only on the author's word.** No skill writes a project guide unasked
  (`.claude/rules/syntek-author/06-global-rules.md`).
- **Author-owned.** `copier update` never touches files here, this seeded pair included.
- **Override by name, not by contradiction.** Give an overriding guide the reference guide's name,
  so there is exactly one answer.
- **A reader's own requirements win.** Where a publisher or agent publishes a format, a project
  guide records it, and the package follows it over any template guide.

## Output & naming

- **Hand-written:** every file here.
- **Naming:** kebab-case `.md`, named for the question the guide answers.
