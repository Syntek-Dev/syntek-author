@./CONTEXT.md

# CLAUDE.md — proposal/docs/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `proposal/CONTEXT.md` →
`proposal/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold the proposal layer's guides (the template's in `reference/`, the author's in `project/`),
each deferring to the standard that governs it.

## How to work here

- **Routing:** you are usually reading a guide to apply it in `proposal/src/`. Look in `project/`
  first; a same-named guide there overrides `reference/`.
- **Model:** **Opus** for any substantive change to a guide; the mechanical tier only for a typo or
  a broken link (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps to change a guide:**
  1. Read the guide's governing standard, named at its foot.
  2. Confirm the change is a practice change, not a rule change; a rule belongs in `standards/`,
     with the author's confirmation there first.
  3. Write it in `project/` under the reference guide's name; never edit `reference/`.
  4. Grep `proposal/src/` and `proposal/workflows/` for anything citing it, and reconcile.
- **Definition of done:** short, practical and scannable; defers to its standard; names its skill
  and workflow; nothing in `src/` or `workflows/` contradicts it.

## Guardrails

- **A guide never outranks a standard.** If they disagree, the standard is right.
- **Do not soften 'never invent'.** It covers four different temptations: a plausible comparable
  title, a rounded platform figure, an implied endorsement or offer, and a deadline invented to
  create urgency. Each is trivially checkable, and each discredits everything around it.
- **Guides are for making the pitch, not for sending.** No pitch copy, no emails, no tracker rows.
- **Never self-edit.** No guide is rewritten without the author's explicit instruction
  (`.claude/rules/syntek-author/06-global-rules.md`).

## Output & naming

- **Hand-written:** guides in `project/`, and this pair.
- **Template-owned:** everything in `reference/`.
- **Naming:** kebab-case `.md`, named for the question the guide answers.
- **Not here:** the package itself (`proposal/src/`).
