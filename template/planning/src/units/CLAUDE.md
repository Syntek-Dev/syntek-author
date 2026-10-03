@./CONTEXT.md

# CLAUDE.md — planning/src/units/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `planning/CONTEXT.md` →
`planning/CLAUDE.md` → `planning/src/CONTEXT.md` → `planning/src/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold one agreed brief per unit, and keep its frontmatter an honest record of where the unit and
its sections stand.

## How to work here

- **Routing:** a new or re-planned brief → `planning/workflows/01-plan-a-unit/` with
  `grill-with-docs`. Section `status` values are kept by `draft-section`, `adapt-section`,
  `improve-section` and `promote-section`; `verified` is written by the verification gates;
  the unit `status` moves only as `standards/verification/verification.md` allows.
- **Model:** **Opus** for planning and re-planning; the mechanical tier for a status tick the
  owning skill reports (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:**
  1. Read the brief in full before drafting, adapting, improving or promoting any section of
     its unit.
  2. Change the plan only through `01-plan-a-unit`, with the author.
  3. After any section changes status, confirm the brief's `sections` entry matches.
- **Definition of done:** the brief matches the author's intent, the outline, and the state of
  every section in the content layer.

## Guardrails

- **One brief per unit.** Never start a second brief for a unit; re-plan the existing one.
- **Slugs are keys.** Never rename a brief, or a section slug, once the section has a ledger
  entry in `standards/style/ledger/`.
- **`final` is earned, not promoted.** A unit reaches `final` only through the review workflow
  and the author's word, never because every section has been promoted.
- **No prose.** A brief says what a section must do. Sample sentences belong in a draft.
- **Never overwrite** a brief without confirming with the author.

## Output & naming

- **Hand-written (with the author):** `<unit>.md`, named for the unit in the content layer.
- **Kept current by skills:** each section's `status`, and `verified`.
