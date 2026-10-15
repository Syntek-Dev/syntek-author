@./CONTEXT.md

# CLAUDE.md — planning/src/questionnaires/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `planning/CONTEXT.md` →
`planning/CLAUDE.md` → `planning/src/CONTEXT.md` → `planning/src/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold the questionnaires that carry a stalled decision to the one person who can answer it, and
the answers that came back, until each decision is settled in its real home.

## How to work here

- **Routing:** `to-questionnaire` writes every questionnaire here, on the author's word only. The
  decision the answers settle is recorded through `grill-with-docs`, a decision-map node through
  `wayfinder`, and a checkable claim in an answer goes to `fact-check` first.
- **Model:** **Opus** for the questions, the recipient's register and folding the answers back;
  the mechanical tier for a `Status` line the author has dictated
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** run the skill; save a returned copy beside its original as
  `…-RETURNED.md`; then resolve each answer by its normal route and clear the `Open questions`
  entry.
- **Definition of done:** every questionnaire here is a draft, out with a recorded block, or
  returned and resolved.

## Guardrails

- **Never send anything.** The author sends a questionnaire; set `sent` only on their word.
- **Never edit a recipient's words.** A returned copy is evidence, kept as received.
- **Nothing confidential leaves the project.** A questionnaire carries no draft, path, flag or
  fact the recipient is not meant to see.
- **Not here:** a business client's intake (a document type the business documents skill
  owns), a permission or an approval (the project's registers), an approach for an endorsement
  or a submission, and an empirical fact (`research`, `fact-check`).

## Output & naming

- **Written by `to-questionnaire`:** `QUESTIONNAIRE-<SLUG>-DD-MM-YYYY.md` (upper-case slug), and
  the returned copy `QUESTIONNAIRE-<SLUG>-DD-MM-YYYY-RETURNED.md`.
- **Ownership:** this `CLAUDE.md` and `CONTEXT.md` are template-owned and updated by
  `copier update`; every questionnaire and returned copy is the author's.
