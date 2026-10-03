@./CONTEXT.md

# CLAUDE.md — manuscript/docs/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `manuscript/CONTEXT.md` →
`manuscript/CLAUDE.md` → this folder's `CONTEXT.md` (the two owners, imported above) → this file →
the `CONTEXT.md` and `CLAUDE.md` of `manuscript/docs/reference/` or
`manuscript/docs/project/`.

## Purpose (one line)

Hold the manuscript layer's guides in two owned halves, so template improvements arrive by
`copier update` without ever overwriting what the author wrote for this book.

## How to work here

You are usually **reading** a guide to apply it while drafting, not editing it.

- **Routing:** looking for a guide → `manuscript/docs/project/` first, then
  `manuscript/docs/reference/` (a same-named project guide wins). Writing a new guide for this
  book → `manuscript/docs/project/`. Wanting a reference guide changed → the change belongs
  upstream in the template, or as an override in `manuscript/docs/project/` with the author's
  agreement.
- **Model:** **Opus** for any substantive change to a guide; the mechanical tier only for a typo or
  a table's formatting (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps to add a project guide:**
  1. Confirm with the author that the question recurs and has no home in an existing guide.
  2. Confirm it is a *practice*, not a *rule*. A new requirement belongs in `standards/`, and a
     standards change is always the author's decision.
  3. Write it in the guide format: routing frontmatter, `# Title — gloss`, the metadata header,
     **What it is.**, two to five topic sections, `## How we apply it here`, `## Who implements it`,
     `## Governing standard`. Keep it between roughly 50 and 80 lines.
  4. Add it to the tree and the list in `manuscript/docs/project/CONTEXT.md`.
- **Definition of done:** the guide is short enough to read mid-draft, names the skill and the
  workflow that implement it, defers to its standard, and nothing in `manuscript/workflows/` or
  `manuscript/src/` now contradicts it.

## Guardrails

- **A guide never outranks a standard.** If they disagree, the standard is right and the guide is
  a bug: fix the guide, or take the rule change to the author.
- **Do not let a guide grow into a standard.** The moment a guide says 'must' about something no
  standard requires, it has changed category. Move the rule up; leave the practice here.
- **Route, do not restate.** Two copies of a rule drift. Cite the owner.
- **Never edit `manuscript/docs/reference/` in place.** It is template-owned; put the change in
  `manuscript/docs/project/`.
- **Never overwrite a guide the author has written** without confirming.

## Output & naming

- **Hand-written:** guides in `manuscript/docs/project/`, kebab-case and named for the question
  they answer.
- **Template-owned (do not edit here):** everything in `manuscript/docs/reference/`.
- **Generated:** nothing.
