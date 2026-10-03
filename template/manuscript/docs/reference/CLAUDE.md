@./CONTEXT.md

# CLAUDE.md — manuscript/docs/reference/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `manuscript/CONTEXT.md` →
`manuscript/CLAUDE.md` → `manuscript/docs/CONTEXT.md` → `manuscript/docs/CLAUDE.md` → this
folder's `CONTEXT.md` (the guide list, imported above) → this file → the guide you need.

## Purpose (one line)

Answer the everyday drafting questions in a form short enough to read mid-sentence, without ever
becoming a second copy of a rule.

## How to work here

These files are **read, not edited**. Apply a guide while working in `manuscript/src/`; cite it
from a procedure; never change it here.

- **Routing:** before reading a guide here, check `manuscript/docs/project/` for a file of the same
  name; if one exists, it overrides this one. The table in this folder's `CONTEXT.md` says which
  guide answers which question. Each guide's foot names the standard that owns the rule behind it.
- **Model:** **Opus** whenever a guide is applied to prose; reading one is part of the
  substantive task it serves (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps when a guide seems wrong for this book:**
  1. Read its governing standard. If the standard says otherwise, the standard wins; report the
     disagreement to the author.
  2. If the practice really differs here, propose a project guide or an override in
     `manuscript/docs/project/` to the author. Do not edit this folder.
  3. If the guide is wrong for every book, say so to the author: the fix belongs in the template.
- **Definition of done:** the question was answered from the right guide (project before
  reference), and any disagreement with a standard was reported rather than resolved.

## Guardrails

- **Template-owned.** `copier update` merges over this folder. A local edit here is either lost or
  turns into a merge conflict on the next update; an override in `manuscript/docs/project/` is
  neither.
- **A guide never outranks a standard or a rules file.** If they disagree, the guide is the bug.
- **Never apply a guide as a rewrite licence.** Guides shape drafting and reporting; changes to the
  author's prose still go through the report-then-apply procedures.

## Output & naming

- **Template-owned:** every guide here, kebab-case, named for the question it answers.
- **Hand-written by the author:** nothing here; the author's guides go in
  `manuscript/docs/project/`.
- **Generated:** nothing.
