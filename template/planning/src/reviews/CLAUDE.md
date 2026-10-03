@./CONTEXT.md

# CLAUDE.md — planning/src/reviews/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `planning/CONTEXT.md` →
`planning/CLAUDE.md` → `planning/src/CONTEXT.md` → `planning/src/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Keep every review's findings as dated advice, separate from the decisions the author makes
about them.

## How to work here

- **Routing:** reviews are written by `structure-review` (forked context) from
  `planning/workflows/09-review-the-whole-work/` or the content layer's review workflow. The
  author's decisions about a review are recorded by `grill-with-docs` in `.claude/MEMORY.md`.
- **Model:** **Opus** throughout (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** read the latest review for the same scope before writing a new one; write
  the new report in the guide's shape; cite the earlier one it supersedes.
- **Definition of done:** the report carries the advice-only status line, names every lens it
  ran, and lists its open decisions for the author.

## Guardrails

- **Advice only.** A review never edits the work, a plan or MEMORY. Its recommendations are
  carried out, if the author agrees, by the procedure that owns each artefact.
- **Never edit an earlier review.** Supersede it with a new, dated report.
- **Keep the dissent.** Where lenses disagree, report both; never average them into a verdict
  nobody gave.
- **Flag, do not assert.** A claim brought in from outside the repository is listed under
  claims to verify, with `VERIFY`, never stated as fact.

## Output & naming

- **Written by `structure-review`:** `REVIEW-<scope>-DD-MM-YYYY.md`; the scope names the work,
  not the session.
