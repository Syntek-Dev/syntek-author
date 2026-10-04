@./CONTEXT.md

# CLAUDE.md — manuscript/workflows/05-review-a-chapter/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `manuscript/CONTEXT.md` →
`manuscript/CLAUDE.md` → `manuscript/workflows/CONTEXT.md` → `manuscript/workflows/CLAUDE.md` →
this folder's `CONTEXT.md` (when to use it, imported above) → this file →
`standards/verification/verification.md` and its mode file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Review a whole chapter stage by stage (structure, facts, the line), passing each stage's gates
before the next begins, until the author can call it `final`.

## How to work here

**Follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.** The model tags in the checklist
are authoritative.

- **Routing:** skills in sequence: `structure-review` · `fact-check` · `comprehension` · `flow` ·
  `grammar` · `spelling`, each with its mode file; then, at each stage, the skills that
  `standards/verification/verification.md` and its mode file name for that stage's gates. Fixes go
  through `manuscript/workflows/02-adapt-a-draft/` or `manuscript/workflows/03-improve-your-draft/`
  and back through `manuscript/workflows/04-promote-a-section/`.
- **Model:** **Opus** throughout: every pass is judgement. The mechanical tier only for status and
  ledger updates and the optional proof (`.claude/rules/syntek-author/05-model-allocation.md`).
- **A review can stop at the end of any stage.** The brief records where it stands, so the next
  session continues from there. Hand off rather than compact
  (`.claude/rules/syntek-author/07-session-boundaries.md`).
- **Concrete steps:** fix the scope and find the stage → read the gates → open the review →
  structural review → pass the structural gates → fact check → comprehension → flow → grammar →
  spelling → the line-edit gates and one report → `final` on the author's word → hand back. Agreed
  fixes are applied as `STEPS.md` sets out under 'Applying agreed fixes'.
- **Definition of done:** the chapter stands at the stage its gates have earned, every move dated in
  its brief; every report was delivered and only agreed fixes applied; for `final`, no flag remains
  and the author said so.

## Guardrails

- **Gates are cited, never restated.** `standards/verification/verification.md` and its mode file
  own what each move requires. If a gate seems wrong, report it to the author; do not skip it.
- **Report first.** Every pass reports by location, blocking first, before anything changes.
- **Reviews are advice.** The structural review's file is marked advice only; a decision enters
  `.claude/MEMORY.md` only when the author makes it and dates it.
- **Fix through the sections, not around them.** Any change to promoted wording goes back through
  the section procedures and is promoted again, so the ledger stays true. The one exception is an
  accepted spelling or punctuation correction, which may be applied in the chapter file directly if
  that section's ledger entry is brought up to date with it: its revisions, its author final and
  its ratio (`STEPS.md`, 'Applying agreed fixes').
- **Never mark a chapter `final`** without zero flags, every gate passed, and the author's explicit
  word, recorded with its date in `.claude/MEMORY.md` `## Status` (mapped in `00-project.md`
  `## Memory headings`). A gate waived by the author is dated in `verified:` with the reason.
- **A material change reopens gates.** It clears the date of the gate it reopens and every later
  one, and steps the status back (`STEPS.md`, 'Applying agreed fixes').
- **Never overwrite promoted text** without confirming with the author.

## Output & naming

- **Produces:** `planning/src/reviews/REVIEW-<scope>-DD-MM-YYYY.md`; the line-edit report; the
  chapter's `status:` and `verified:` in its brief.
- **Also writes:** evidence entries; `VERIFY` flags; for accepted corrections, ledger rows,
  revisions, a new author final and its ratio, and the section's `provenance.md` row; the
  author's dated word in `.claude/MEMORY.md` `## Status` (its mapped heading) at `final`.
- **Generated (never hand-edit):** any proof under `build/`.
- **Does not touch:** any standard, or `.claude/MEMORY.md` beyond decisions the author has dated
  and the author's dated word that the chapter is `final`, under `## Status` (its mapped heading).
