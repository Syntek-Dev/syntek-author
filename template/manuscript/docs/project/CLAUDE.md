@./CONTEXT.md

# CLAUDE.md — manuscript/docs/project/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `manuscript/CONTEXT.md` →
`manuscript/CLAUDE.md` → `manuscript/docs/CONTEXT.md` → `manuscript/docs/CLAUDE.md` → this
folder's `CONTEXT.md` (the author's guide list, imported above) → this file.

## Purpose (one line)

Hold the guides that belong to this book alone, where template updates can never reach them.

## How to work here

- **Routing:** a guide here is read **before** the reference guide of the same name, and replaces
  it. Add a guide only through the steps in `manuscript/docs/CLAUDE.md`.
- **Model:** **Opus** for writing or changing a guide; the mechanical tier for adding a row to this
  folder's list (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps to override a reference guide:**
  1. Confirm with the author that the book genuinely diverges from the reference practice, and
     date that decision in `.claude/MEMORY.md` Decisions.
  2. Copy the reference guide here under the same filename and change only what differs.
  3. List it in this folder's `CONTEXT.md` as an override, with the date and the reason.
- **Definition of done:** the guide is in the house guide format, listed in this folder's
  `CONTEXT.md`, and consistent with every standard it names.

## Guardrails

- **Author-owned.** Never write a guide here, or change one, without the author's agreement.
- **An override is a fork.** It stops receiving template improvements. Prefer a differently named
  guide that cites the reference one unless the reference practice is actually wrong for this book.
- **No rules here.** If a guide needs to say 'must' about something no standard requires, the
  requirement belongs in `standards/`, and a standards change is always the author's decision.
- **Never overwrite an existing guide** without confirming with the author.

## Output & naming

- **Hand-written:** kebab-case `.md` guides, named for the question they answer.
- **Generated:** nothing.
