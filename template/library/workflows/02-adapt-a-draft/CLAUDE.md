@./CONTEXT.md

# CLAUDE.md — library/workflows/02-adapt-a-draft/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/workflows/CONTEXT.md` → `library/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Revise a draft from the author's notes or edits, changing only what was flagged, or adapt a
template into one client's document without loosening its terms.

## How to work here

- **Routing:** the `adapt-section` skill (with its `BUSINESS.md` mode file) is this procedure in
  skill form. `obligation-check` compares a template's commitments with the client version's.
  Guides: `drafting-with-ai.md` and `versioning-and-the-register.md` in `library/docs/reference/`.
- **Model:** follow the checklist tags: **Opus** for mapping notes, revising and every
  alternative; the mechanical tier for status, dates and ledger rows.
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.
- **Definition of done:** every note is answered by a change, an alternative or a question; no
  sentence the notes did not reach has changed; no figure, date, price, scope boundary or
  commitment has changed unless a note changed it; the ledger records each note and what was done.

## Guardrails

- **Change only what was flagged.** Everything the notes did not reach stays word for word,
  punctuation included.
- **Never rewrite the whole section.** If the notes amount to a rewrite, say so and ask whether to
  re-draft through workflow 01 instead.
- **A note that asks for a decision is answered with a question.** 'Make the guarantee stronger'
  is the author's commitment to make; offer wordings at different strengths and let the author
  choose.
- **A template's terms are the floor.** Adapting a template fills placeholders and adjusts what the
  author instructs; it never drops a protection, a limit or a caveat to make a sentence read better.
- **An issued document is not adapted in place.** A change after circulation is a new version.
- **Never overwrite** a draft whose status shows the author edited it since your last pass without
  reading the author's edit first.

## Output & naming

- **Produces:** the revised draft, in place.
- **Also writes:** rows in the ledger entry's `## Improvement decisions`; the section's status in
  the unit brief.
- **Does not touch:** the AI original in the ledger, the deliverable `.tex`, or any other section.
