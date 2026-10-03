@./CONTEXT.md

# CLAUDE.md — planning/docs/reference/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `planning/CONTEXT.md` →
`planning/CLAUDE.md` → `planning/docs/CONTEXT.md` → `planning/docs/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Serve the template's planning guides read-only, so every project plans the same way until its
author decides otherwise in `planning/docs/project/`.

## How to work here

- **Routing:** check `planning/docs/project/` for a same-named override first; if none exists,
  the guide here applies. The skill and workflow each guide names are the ones to run.
- **Model:** **Opus** for reading a guide into a judgement; nothing here is written
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:**
  1. Find the guide for the question in `CONTEXT.md`.
  2. Check `planning/docs/project/` for an override of the same name.
  3. Apply the guide through the workflow it names; follow its standard where they differ.
- **Definition of done:** the plan you made follows the guide (or its override), and any point
  where the guide did not fit has been reported to the author rather than improvised around.

## Guardrails

- **Read-only.** These files are template-owned and updated by `copier update`. To change one
  for this project, copy it to `planning/docs/project/` under the same name and edit the copy,
  with the author's instruction.
- **Never self-edit.** No skill rewrites a guide without the author's explicit instruction
  (`.claude/rules/syntek-author/06-global-rules.md`).
- **A guide never outranks a standard.** Where a guide and its governing standard disagree, the
  standard wins; report the disagreement.

## Output & naming

- **Template-owned:** every guide here. Nothing in this folder is generated or written by a
  skill.
