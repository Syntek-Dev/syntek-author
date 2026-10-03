@./CONTEXT.md

# CLAUDE.md — planning/src/arguments/

Read order: `standards/method/THEOLOGY.md` → `.claude/CLAUDE.md` → `.claude/MEMORY.md` →
`planning/CONTEXT.md` → `planning/CLAUDE.md` → `planning/src/CONTEXT.md` →
`planning/src/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold one checked argument map per chapter, so the prose argues a structure whose gaps were found
before drafting.

## How to work here

- **Routing:** a map is written and re-audited through `planning/workflows/02-map-the-argument/`.
  `category-check` labels claims; `argument-audit` checks support, and later checks the prose in
  `manuscript/src/` against the map; contested readings are mapped first in
  `research/workflows/03-map-a-contested-reading/`.
- **Model:** **Opus** throughout; categorising a claim is judgement
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** read the chapter's brief and the method standard; write or update the map;
  run the audit; carry agreed claims back into the brief.
- **Definition of done:** every claim has one category and named support or is listed as an open
  move; every objection is stated so its holders would recognise it; every concession is placed
  ahead of its answer.

## Guardrails

- **Never fabricate.** No scripture reference, quotation, original-language gloss or historical
  claim is written from memory. Until it is checked, it carries `<!-- VERIFY: … -->`.
- **Never collapse a category silently.** An inference is not the text; a conclusion is not
  history; an application is not exegesis.
- **Report, never rewrite.** The audit reports unsupported moves and missing premises; the
  author decides how the argument changes.
- **The left-standing objection is the author's.** Never re-designate it or answer it in the map.
- **Never overwrite** a map without confirming with the author.

## Output & naming

- **Hand-written (with the author):** `<unit>.md`, named exactly as the chapter's brief.
- **Not here:** the readings themselves (`research/src/contested-readings/`) or evidence
  entries (`research/src/evidence/`); the map links to both.
