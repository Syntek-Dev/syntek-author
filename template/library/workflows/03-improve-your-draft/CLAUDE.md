@./CONTEXT.md

# CLAUDE.md — library/workflows/03-improve-your-draft/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/workflows/CONTEXT.md` → `library/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Propose improvements to a section the author wrote, as a reasoned diff at the requested strength,
and apply only what the author accepts.

## How to work here

- **Routing:** the `improve-section` skill (with its `BUSINESS.md` mode file) is this procedure in
  skill form; `spelling` and `grammar` produce the proofreading report. Guide:
  `library/docs/reference/drafting-with-ai.md`.
- **Model:** follow the checklist tags: **Opus** for every proposal and reason; the mechanical tier
  for applying accepted changes and writing ledger rows.
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.
- **Definition of done:** the author has seen every proposal with its reason, accepted or rejected
  each, and the draft carries exactly the accepted ones; every decision is in the ledger.

## Guardrails

- **Report first, then apply what was agreed.** Never edit the author's text before they have seen
  the proposal.
- **Stay at the strength asked for.** A `light` pass that restructures is a rewrite nobody asked
  for.
- **Never alter a figure, a date, a price, a scope boundary, a defined term or a commitment.** Raise
  it as a question instead.
- **Keep what is deliberate:** the author's idiom, a hedge doing honest work, a fragment used for
  effect, an internal note's recorded deviation.
- **Proofreading is a report, not a rewrite:** say what and where, offer the correction, group the
  recurring items, and never comment on the person.
- **Never overwrite the author's draft** with an unaccepted change.

## Output & naming

- **Produces:** the improved draft, in place, at `improved`.
- **Also writes:** ledger rows in `## Improvement decisions`, with the entry's Author original on
  the first pass and its revisions (the author's edits found, the accepted changes); the section's
  status in the brief.
- **Does not touch:** the deliverable `.tex`, or any other section.
