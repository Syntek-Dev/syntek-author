@./CONTEXT.md

# CLAUDE.md — typeset/docs/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `typeset/CONTEXT.md` →
`typeset/CLAUDE.md` → this folder's `CONTEXT.md` (the two owners, imported above) → this file →
the `CONTEXT.md` and `CLAUDE.md` of `typeset/docs/reference/` or `typeset/docs/project/`.

## Purpose (one line)

Hold the typesetting guides in two owned halves, so template improvements arrive by
`copier update` without ever overwriting what the author wrote for this book.

## How to work here

You are usually **reading** a guide to apply it while typesetting, not editing it.

- **Routing:** looking for a guide → `typeset/docs/project/` first, then
  `typeset/docs/reference/` (a same-named project guide wins). Writing a new guide for this book →
  `typeset/docs/project/`. Wanting a reference guide changed → upstream in the template, or an
  override in `typeset/docs/project/` with the author's agreement.
- **Model:** **Opus** for any substantive change to a guide; the mechanical tier only for a typo
  or a table's formatting (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps to add a project guide:**
  1. Confirm with the author that the question recurs and has no home in an existing guide.
  2. Confirm it is a *practice*, not a *rule* or a page-design choice. A requirement belongs in
     `standards/`; a page-design choice belongs in `typeset/src/page-design.md`.
  3. Write it in the guide format: routing frontmatter, `# Title — gloss`, the metadata header,
     **What it is.**, two to five topic sections, `## How we apply it here`, `## Who implements it`,
     `## Governing standard`. Keep it between roughly 50 and 80 lines.
  4. Add it to the tree and the list in `typeset/docs/project/CONTEXT.md`.
- **Definition of done:** the guide is short enough to read mid-task, names the skill and the
  workflow that implement it, defers to its rule, and nothing in `typeset/workflows/` now
  contradicts it.

## Guardrails

- **A guide never outranks a standard or a rules file.** If they disagree, the guide is the bug.
- **Route, do not restate.** Two copies of a rule drift. Cite the owner.
- **No page-design choices in a guide.** A guide explains the options; the author's choice lives
  in `typeset/src/page-design.md`, where the class options in `typeset/src/book.tex` mirror it.
- **Never edit `typeset/docs/reference/` in place.** It is template-owned.
- **Never overwrite a guide the author has written** without confirming.

## Output & naming

- **Hand-written:** guides in `typeset/docs/project/`, kebab-case and named for the question they
  answer.
- **Template-owned (do not edit here):** everything in `typeset/docs/reference/`.
- **Generated:** nothing.
