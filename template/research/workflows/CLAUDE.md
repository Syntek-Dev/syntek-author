@./CONTEXT.md

# CLAUDE.md — research/workflows/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `research/CONTEXT.md` →
`research/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file → the chosen
procedure's four files.

## Purpose (one line)

Hold the research layer's ordered procedures, so that ingesting, verifying and mapping happen the
same way every time, before drafting needs them.

## How to work here

- **Routing:** pick by what you have in hand; check `local/` for a same-slug override first.

| You want to… | Procedure |
|---|---|
| Read a work into the evidence base | `01-ingest-a-source/` |
| Check a figure, date, study finding or legal statement before it is written | `02-verify-a-claim/` |
<: if DOC_TYPE == 'theology' :>| Map a passage serious Christians read more than one way | `03-map-a-contested-reading/` |
<: endif :><: if DOC_TYPE != 'business' and INCLUDE_SENSITIVE_CONTENT :>| Work with first-person testimony | `05-handle-testimony-safely/` |
<: endif :>| Answer a wider question from several sources | the `research` skill directly; no procedure |

- **Model:** **Opus** for every judgement; the mechanical tier only for `make` runs and ticks. The
  model tags in each `CHECKLIST.md` are authoritative
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps (running one):** read the procedure's `CONTEXT.md` → `CLAUDE.md` → `STEPS.md`,
  then work the steps in order with `CHECKLIST.md` open, ticking as you go.
- **Concrete steps (changing one):** confirm with the author first, because a procedure change
  alters what evidence the work will accept; put the change in `local/` under the same slug; change
  all four files together.
- **Definition of done (running):** every checklist item ticked or explicitly waived with a reason;
  the output filed in the right `research/src/` folder; everything needing the author's judgement
  flagged rather than resolved.

## Guardrails

- **These procedures run before drafting.** `02-verify-a-claim` is a prerequisite of drafting a
  unit, not a tidy-up after it; running it afterwards produces a unit that quietly keeps its
  unverified claims.
- **Never skip verification.** `02-verify-a-claim` is the only route by which a claim gets a
  verdict; a figure that has not been through it has not been checked by anything.
- **Procedures cite rules; they never restate them.** If a `STEPS.md` starts explaining why a claim
  needs its basis, that text belongs in a standard.
- **Never edit a template procedure in place;** `copier update` replaces it. Override in `local/`.
- **A waived step is recorded, not silent:** say which and why in the hand-back.

## Output & naming

- **Template-owned:** every `NN-name/` folder and this pair.
- **Author-owned:** everything in `local/`.
- **Folders:** `NN-verb-first-kebab-name/`, four files each.
- **Procedures produce nothing here.** Output lands in `research/src/`.
