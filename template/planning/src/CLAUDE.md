@./CONTEXT.md

# CLAUDE.md — planning/src/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `planning/CONTEXT.md` →
`planning/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Keep the plans current and consistent with each other, so every drafting session starts from
the same picture of the work.

## How to work here

- **Routing:** each file or folder has one writer and one procedure.

| File or folder | Written by | Procedure |
|---|---|---|
| `outline.md`, `units/` | the author, with `grill-with-docs` | `planning/workflows/01-plan-a-unit/` |
<: if DOC_TYPE == 'theology' :>| `arguments/` | `category-check`, `argument-audit` | `planning/workflows/02-map-the-argument/` |
<: endif :><: if DOC_TYPE == 'fiction' :>| `causality.md`, `timeline.md` | `causality` | `planning/workflows/03-chart-the-causality/` |
| `continuity.md` | `continuity`, on the author's word | `planning/workflows/03-chart-the-causality/` |
| `arcs/` | `chart-character-arc` | `planning/workflows/04-chart-a-character-arc/` |
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>| `quests/` | `design-quest` | `planning/workflows/05-design-a-quest/` |
<: endif :><: if DOC_TYPE == 'business' :>| `review-schedule.md` | by hand, after each review | `planning/workflows/06-run-a-review-cycle/` |
| `approvals/` (or the Approvals path in `00-project.md` `## Paths`) | by hand, every field confirmed | `planning/workflows/07-record-an-approval/` |
| `document-register.md`, `precedence.md` | by hand, or `promote-section` | `planning/workflows/08-update-the-register/` |
<: endif :>| `maps/` | `wayfinder` | the skill's CHART and RESOLVE steps |
| `reviews/` | `structure-review` | `planning/workflows/09-review-the-whole-work/` |

- **Model:** **Opus** for any plan or judgement; the mechanical tier for adding a row the author
  has dictated, renames and ticks (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** read the governing guide (`planning/docs/reference/CONTEXT.md`); run the
  procedure in the table; after any change, check the outline, the brief and the doc type's
  plans still agree with each other.
- **Definition of done:** no two files here contradict each other, and none contradicts a dated
  decision in `.claude/MEMORY.md`.

## Guardrails

- **One sentence per line** in every artefact here, applied when a paragraph is edited, never by
  mass reflow (`.claude/rules/syntek-author/06-global-rules.md`).
- **Report contradictions; never silently repair them.** When two plans disagree, or a plan
  and the prose disagree, tell the author which is which. They decide which one is wrong.
- **IDs are permanent.** Any numbered entry (a claim, a beat, a fact, a document) keeps its ID
  for life; a retired entry is marked, never deleted or renumbered.
- **No invented entries.** A row records something the author agreed or the work established.
  Never fill a seed with plausible examples.
- **Never overwrite** an existing plan, register or review without confirming with the author.

## Output & naming

- **Hand-written (with the author):** the outline, briefs and the doc type's plans and
  registers.
- **Written by skills:** maps (`MAP-<TOPIC>.md`) and reviews (`REVIEW-<scope>-DD-MM-YYYY.md`).
- Files kebab-case; dates DD/MM/YYYY in prose and DD-MM-YYYY in filenames.
