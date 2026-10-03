@./CONTEXT.md

# CLAUDE.md — manuscript/workflows/10-steelman-the-objections/

Read order: `standards/method/THEOLOGY.md` → `.claude/CLAUDE.md` → `.claude/MEMORY.md` →
`manuscript/CONTEXT.md` → `manuscript/CLAUDE.md` → `manuscript/workflows/CONTEXT.md` →
`manuscript/workflows/CLAUDE.md` → this folder's `CONTEXT.md` (when to use it, imported above) →
this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Audit a chapter against the book's honesty commitments (objections steelmanned, costs conceded
first, contested readings in the body, bias declared, categories kept) and report.

## How to work here

**Follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.** The model tags in the checklist
are authoritative.

- **Routing:** skill `steelman`, which is this procedure in skill form. `tradition-check` for how
  readers in other traditions would push back; `category-check` where an answer slips category;
  `argument-audit` when the prose and the argument map disagree. Guide:
  `manuscript/docs/reference/main-text-and-footnotes.md`.
- **Model:** **Opus** throughout. Judging whether an objection is fairly stated is the least
  mechanical work in the project (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Run it as a reviewer, not as the chapter's author.** Name the owner of each fix: a section
  procedure for wording, `research/workflows/03-map-a-contested-reading/` for a missing map,
  `planning/workflows/02-map-the-argument/` for a missing objection in the plan, and the author for
  anything touching their own conclusions or an objection left standing.
- **Concrete steps:** find what the chapter is committed to → list its objections → apply the three
  tests → check the objection aimed at the author → check every concession by position → check the
  contested readings → check the categories hold → check what is left standing → posture check →
  report with the three verdicts.
- **Definition of done:** every objection passes the recognition test or is flagged with a stronger
  version suggested; every concession is checked by its position on the page; contested readings
  are in the body; categories hold where objections are answered; anything left standing is
  confirmed or escalated; the three verdicts are stated.

## Guardrails

- **The recognition test is the whole thing.** Would someone who holds this view read the paragraph
  and say 'yes, that is what I think'? A fair summary by someone who disagrees still fails. If the
  answer came easily, the objection was too weak.
- **Check omission, not only wording.** The commonest failure is that the strongest objection is
  simply absent, so nothing on the page looks wrong.
- **A concession is checked by position, not vocabulary.** A cost in the same sentence as its
  rebuttal, or in a footnote, has not been conceded.
- **An objection left standing is the author's, always.** If a chapter has answered it, even
  partly, in a note or by implication, report and stop.
- **Never rewrite**, never soften a response, never invent an objection.
- **State the three verdicts even when they pass.** A silent pass is indistinguishable from a check
  that never ran.

## Output & naming

- **Produces:** the report and the three verdicts, in chat.
- **May write:** the steelman gate's date in the chapter brief's `verified:` record (when run as
  the review gate); a dated decision in `.claude/MEMORY.md` once the author decides about an
  objection left standing.
- **Does not touch:** the chapter's prose, the drafts, the argument map or any standard.
