@./CONTEXT.md

# CLAUDE.md — library/src/marketing/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/src/CONTEXT.md` → `library/src/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold the business's marketing copy and plans, every claim in them true and every person in them
there by permission.

## How to work here

- **Routing:** the loop in `library/workflows/`; the `tone` skill applies the brand voice at line
  edit, and `fact-check` checks every claim. A piece of microcopy can be a one-section document.
- **Model:** **Opus** for copy and claims; the mechanical tier for calendars' dates and layout.
- **Concrete steps:**
  1. Name the reader and the one thing the piece should make them do.
  2. Gather the evidence for every claim before drafting it (`research/src/evidence/`).
  3. Draft, revise and promote; check every name, quote and figure; hand back for the author to
     publish.
- **Definition of done:** every claim is backed by a number, a source or the author's own
  experience, or it is cut; every named client and every quotation has recorded permission; the
  copy reads in the house voice.

## Guardrails

- **Specificity earns trust; superlatives spend it.** No 'leading', 'world-class' or 'seamless'
  without the number that earns it; when there is no number, cut the word.
- **No client is named, quoted or shown without their written permission,** recorded in
  `planning/src/approvals/` before publication. A testimonial is quoted verbatim, and edited only
  with its author's agreement.
- **Platforms are named as they name themselves:** LinkedIn, Instagram, X (not Twitter),
  Facebook, TikTok, YouTube.
- **No promise marketing cannot keep.** A claim about what a client will get is a commitment;
  `obligation-check` traces it to the business's standard terms, or it is cut.
- **Never publish.** Publishing is the author's act.

## Output & naming

- **Hand-written:** plans, calendars and case studies (`.tex`); web and campaign copy (`.md`);
  section drafts.
- **Generated (never hand-edit):** issued PDFs beside each `.tex`.
