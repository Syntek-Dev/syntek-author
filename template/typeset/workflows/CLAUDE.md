@./CONTEXT.md

# CLAUDE.md — typeset/workflows/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `typeset/CONTEXT.md` →
`typeset/CLAUDE.md` → this folder's `CONTEXT.md` (the procedure index, imported above) → this
file → the chosen procedure's `CONTEXT.md`, `CLAUDE.md` and `STEPS.md`, with its `CHECKLIST.md`
open.

## Purpose (one line)

Make the printed book the same way every time, so the author's words are proved intact and the
author's page-design decisions are asked for at the same points every time.

## How to work here

Two modes: **running** a procedure (the normal case) and **changing** one (rare, and the author's
call).

**Running one.** The `run-workflow` skill resolves the author's intent to a procedure, looking in
`typeset/workflows/local/` first; a local folder with the same name as a template folder wins.

| You want to… | Procedure | Usually followed by |
|---|---|---|
| Design the page | `typeset/workflows/01-design-the-page/` | 02 for the first chapter |
| Typeset a chapter | `typeset/workflows/02-typeset-a-chapter/` | 02 for the next chapter, or 04 |
| Re-typeset after edits | `typeset/workflows/03-retypeset-after-edits/` | 04, when the book is due |
| Typeset the book | `typeset/workflows/04-typeset-the-book/` | the author's release decision |

- **Routing:** read the procedure's `CONTEXT.md` → `CLAUDE.md` → `STEPS.md`, then work the steps
  in order with `CHECKLIST.md` open. Each step names its skill; the `typeset` skill's mode file
  adds this project's domain steps.
- **Model:** the `_opus_` and `_sonnet_` tags in each checklist are authoritative. `opus` marks
  the substantive tier; `sonnet` marks the mechanical tier, whose model
  `.claude/rules/syntek-author/05-model-allocation.md` sets. Never lower.
- **Concrete steps (running):** pick the procedure → read its files → work `STEPS.md` in order →
  tick `CHECKLIST.md` → hand back with anything waived and why.
- **Concrete steps (changing one):** confirm with the author first. A template procedure is
  changed by overriding it in `typeset/workflows/local/` under the same folder name, never in
  place. Change all four files together, and date the decision in `.claude/MEMORY.md` Decisions.
- **Definition of done (running):** every checklist item ticked or explicitly waived with a
  reason; every styled chapter touched passes `make tex-check`; the proof has been read.

## Guardrails

- **The check comes before the print.** A print of a chapter that has not passed
  `make tex-check` proves nothing about the author's words.
- **Procedures cite rules; they never restate them.** The class options and macros are in
  `typeset/docs/reference/the-house-class.md`; the check is in
  `typeset/docs/reference/the-fidelity-check.md`.
- **A waived step is recorded, not silent.** Say which and why in the hand-back.
- **Numbering is frozen and append-only.** Never renumber or reuse a number here; template updates
  depend on it. New procedures for this book go in `typeset/workflows/local/`.
- **Template-owned.** `copier update` merges over the numbered folders; edits made in place are
  lost or conflict.

## Output & naming

- **Template-owned:** the numbered procedure folders, `NN-verb-first-kebab-name/`, four files each.
- **Author-owned:** everything in `typeset/workflows/local/` except its pair.
- **Procedures produce nothing here.** Bases and styled chapters land in `typeset/src/units/`,
  page-design records in `typeset/src/page-design.md`, proofs in `build/typeset/`.
