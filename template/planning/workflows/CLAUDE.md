@./CONTEXT.md

# CLAUDE.md — planning/workflows/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `planning/CONTEXT.md` →
`planning/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file → the chosen
procedure's own four files.

## Purpose (one line)

Hold the planning layer's ordered procedures, so each kind of plan is made the same way every
time, whoever runs it.

## How to work here

- **Routing:** pick by what you want; `run-workflow` checks `local/<slug>/` before the
  template's folder of the same slug.

| You want to… | Procedure |
|---|---|
| Plan a unit before drafting it | `01-plan-a-unit/` |
<: if DOC_TYPE == 'theology' :>| Lay out a chapter's argument before drafting it | `02-map-the-argument/` |
<: endif :><: if DOC_TYPE == 'fiction' :>| Chart why each beat happens | `03-chart-the-causality/` |
| Plan how a character changes | `04-chart-a-character-arc/` |
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>| Plan a quest to its ending | `05-design-a-quest/` |
<: endif :><: if DOC_TYPE == 'business' :>| Review the documents that are due | `06-run-a-review-cycle/` |
| Record a signing, an approval or a notice | `07-record-an-approval/` |
| Add, change or retire a register row | `08-update-the-register/` |
<: endif :>| Get a structural verdict on the whole work | `09-review-the-whole-work/` |

- **Model:** the `_opus_` / `_sonnet_` tags in each `CHECKLIST.md` are authoritative: Opus for
  every judgement; the mechanical tier only for file creation, table edits and ticks
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps (running one):** read the procedure's `CONTEXT.md` → `CLAUDE.md` →
  `STEPS.md`, then work `STEPS.md` in order with `CHECKLIST.md` open.
- **Concrete steps (changing one):** only on the author's instruction. Change all four files
  together; keep steps ordered, numbered and marked _Substantive._ or _Mechanical._; record a
  change that overturns an earlier decision in `.claude/MEMORY.md`.
- **Definition of done (running):** every checklist item ticked or waived with a reason; the
  output is where the procedure says it is; nothing the author has not agreed was recorded as
  decided.

## Guardrails

- **Order is load-bearing.** Steps that read and question come before steps that write for a
  reason: reversing them produces a plan that has to be redone.
- **Procedures cite rules; they never restate them.** If a `STEPS.md` explains why a rule
  exists, that explanation has drifted out of its standard. Point at the standard.
- **A waived step is recorded, not silent.** Say which step, and why, in the hand-back.
- **Never renumber or reuse a number.** Numbering is frozen and append-only; a template
  procedure you do not want is overridden in `local/`, not deleted.
- **Template folders are template-owned.** Never edit them in place; copy one to `local/` under
  the same slug and change the copy, with the author's instruction.

## Output & naming

- **Folders:** `NN-verb-first-kebab-name/`, four files each. Nothing here is generated.
- **Procedures produce nothing here.** Their output lands in `planning/src/`.
