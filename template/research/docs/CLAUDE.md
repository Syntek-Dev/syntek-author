@./CONTEXT.md

# CLAUDE.md — research/docs/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `research/CONTEXT.md` →
`research/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold the research layer's guides (the template's in `reference/`, the author's in `project/`),
each deferring to the standard that governs it.

## How to work here

- **Routing:** you are usually reading a guide to apply it in `research/src/`. Look in `project/`
  first; a same-named guide there overrides `reference/`.
- **Model:** **Opus** for any substantive change to a guide; the mechanical tier only for a typo or
  a broken link (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps to change a guide:**
  1. Read the guide's governing standard, named at its foot.
  2. Confirm the change is a practice change, not a rule change. A rule belongs in `standards/`,
     with the author's confirmation there first.
  3. Write it in `project/` under the reference guide's name; never edit `reference/`.
  4. Grep `research/src/` and `research/workflows/` for anything citing the guide, and reconcile.
- **Definition of done:** the guide is short and scannable mid-task, defers to its standard, names
  the skill and workflow that implement it, and nothing in `src/` or `workflows/` contradicts it.

## Guardrails

- **A guide never outranks a standard.** If they disagree, the standard is right and the guide is
  a bug.
- **Do not soften the two rules that protect people and accuracy:** flag, never decide (an
  unflagged risk is a decision), and a claim without its basis is cut, not hedged. Both look like
  friction; both are why the work survives scrutiny.
- **Do not let a guide grow into a standard.** The moment it says 'must' about something not
  already in `standards/`, it has changed category. Move the rule up; leave the practice here.
- **Never self-edit.** No guide is rewritten without the author's explicit instruction
  (`.claude/rules/syntek-author/06-global-rules.md`).

## Output & naming

- **Hand-written:** guides in `project/`, and this pair.
- **Template-owned:** everything in `reference/`.
- **Naming:** kebab-case `.md`, named for the question the guide answers.
- **Not here:** evidence, notes, maps or references; those live in `research/src/`.
