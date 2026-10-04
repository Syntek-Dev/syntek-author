@./CONTEXT.md

# CLAUDE.md — library/workflows/05-review-a-document/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/workflows/CONTEXT.md` → `library/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Review a fully promoted document stage by stage, enter it in the register, and take it to `final`
on the author's word.

## How to work here

- **Routing:** skills in sequence: `structure-review` (forked) · `fact-check` ·
  `clause-consistency` · `obligation-check` · `comprehension` · `flow` · `tone` · `grammar` ·
  `spelling` · `build`. The business gates are in `standards/verification/BUSINESS.md`. Guides:
  `the-status-ladders.md`, `document-anatomy.md` and `versioning-and-the-register.md` in
  `library/docs/reference/`.
- **Model:** follow the checklist tags: **Opus** for every review pass and every judgement; the
  mechanical tier for status lines, dates, the build and the register rows.
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.
- **Definition of done:** every gate from `draft` to `final` has passed and is dated in the brief;
  the register row was written before the issue proof; the author has made the document `final`
  in words; zero flags remain; the issue PDF sits beside the `.tex`; where needed, the review
  schedule and an approval record are written.

## Guardrails

- **Structure, then facts, then the line.** Never run a later stage before an earlier one passes.
- **Reviews are advice.** The structural review is written to `planning/src/reviews/`; the document
  changes only by the author's decision, through the loop or as an agreed correction.
- **A substantive change reopens its section.** Re-draft it through
  `library/workflows/02-adapt-a-draft/` or `library/workflows/03-improve-your-draft/` and promote it
  again through `library/workflows/04-promote-a-section/`, so its ledger stays true; a material
  change also clears its gates (`STEPS.md`, 'Applying agreed fixes'). Agreed corrections (a slip, a
  figure fixed by the fact check) may be applied in the `.tex` directly, made in the section's draft
  too, logged in its ledger entry and listed in the hand-back.
- **A tone pass never changes a figure, a date, a scope boundary or a commitment.**
- **`final` is the author's word, in words, after every gate.** Never set it on a likely yes.
- **Register before the issue proof.** V6.2 needs the row, so the document is registered at the
  end of its line edit, at Status `Draft`, never after `final`.
- **`final` is not issued.** Sending, signing and publishing are the author's acts; the register
  Status records them only on the author's word.
- **Never overwrite a circulated document.** If review finds a problem in one, open a new version.

## Output & naming

- **Produces:** `planning/src/reviews/REVIEW-<scope>-DD-MM-YYYY.md`; the corrected `.tex` at
  `final`; the issue PDF beside it, same basename.
- **Also writes:** evidence entries; the brief's `verified:` map and status; the `.tex` status
  block; register, review-schedule and approval rows through the planning procedures;
  `.claude/MEMORY.md` `## Status` (the author's dated word at `final`).
- **Does not touch:** any standard, or another document in the family (a conflict is reported).
