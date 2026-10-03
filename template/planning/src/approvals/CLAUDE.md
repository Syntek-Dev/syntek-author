@./CONTEXT.md

# CLAUDE.md — planning/src/approvals/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `planning/CONTEXT.md` →
`planning/CLAUDE.md` → `planning/src/CONTEXT.md` → `planning/src/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Keep a complete, confirmed record of every approval event, so the register's status can always
be traced to evidence.

## How to work here

- **Routing:** records are made only through `planning/workflows/07-record-an-approval/`.
- **Model:** **Opus** for confirming the scope and the event; the mechanical tier for writing
  the confirmed fields (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** confirm every field with the author; write the record; update the register
  row and, where the event sets a review date, the review schedule.
- **Definition of done:** every field is filled from the author's confirmation; the register
  shows the status the event produced.

## Guardrails

- **No guessed fields, no placeholders.** A field the author cannot yet confirm stops the
  record; it is never filled with a plausible value.
- **Names come from the author.** Never infer an approver, a role or an organisation.
- **No secrets.** Record an envelope or reference ID if the author gives one; never a password,
  access code or signature image.
- **Records are not edited after the event.** A correction is a dated note at the foot of the
  record, saying what changed and why.

## Output & naming

- **Hand-written (author-confirmed):** `approval-<doc-type>-DD-MM-YYYY.md`, dated by the approval,
  kebab-case `<doc-type>` naming the document or group.
