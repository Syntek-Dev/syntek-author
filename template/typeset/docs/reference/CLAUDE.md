@./CONTEXT.md

# CLAUDE.md — typeset/docs/reference/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `typeset/CONTEXT.md` →
`typeset/CLAUDE.md` → `typeset/docs/CONTEXT.md` → `typeset/docs/CLAUDE.md` → this folder's
`CONTEXT.md` (the guide list, imported above) → this file → the guide you need.

## Purpose (one line)

Answer the typesetting questions in a form short enough to read mid-task, without ever becoming a
second copy of a rule or making a page-design choice for the author.

## How to work here

These files are **read, not edited**. Apply a guide while working in `typeset/src/`; cite it from
a procedure; never change it here.

- **Routing:** before reading a guide here, check `typeset/docs/project/` for a file of the same
  name; if one exists, it overrides this one. The table in this folder's `CONTEXT.md` says which
  guide answers which question. Each guide's foot names the rule that owns the requirement.
- **Model:** **Opus** whenever a guide is applied to the book; reading one is part of the
  substantive task it serves (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps when a guide seems wrong for this book:**
  1. Read its governing rule. If the rule says otherwise, the rule wins; report the disagreement
     to the author.
  2. If the practice really differs here, propose a project guide or an override in
     `typeset/docs/project/` to the author. Do not edit this folder.
  3. If the guide is wrong for every book, say so to the author: the fix belongs in the template.
- **Definition of done:** the question was answered from the right guide (project before
  reference), and any disagreement with a rule was reported rather than resolved.

## Guardrails

- **Template-owned.** `copier update` merges over this folder; a local edit is lost or conflicts.
- **A guide never outranks a standard or a rules file.** If they disagree, the guide is the bug.
- **A guide is not a licence to change words.** The guides shape styling; the words come from the
  Markdown, and changes to them go through the section procedures.

## Output & naming

- **Template-owned:** every guide here, kebab-case, named for the question it answers.
- **Hand-written by the author:** nothing here; the author's guides go in `typeset/docs/project/`.
- **Generated:** nothing.
