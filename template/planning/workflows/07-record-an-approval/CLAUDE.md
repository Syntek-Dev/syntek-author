@./CONTEXT.md

# CLAUDE.md — planning/workflows/07-record-an-approval/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `planning/CONTEXT.md` →
`planning/CLAUDE.md` → `planning/workflows/CONTEXT.md` → `planning/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Record one approval event, every field confirmed by the author, and bring the register into step
with it.

## How to work here

- **Routing:** no skill; this is a confirmation-and-record procedure. Guide
  `planning/docs/reference/the-document-register.md`; record shape in the Approvals folder's
  `CONTEXT.md` (by default `planning/src/approvals/CONTEXT.md`).
- **Model:** **Opus** for confirming that the event qualifies and what its scope was; the
  mechanical tier for writing the confirmed fields and the register edit
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.
- **Definition of done:** the record exists with no guessed field and no placeholder, and the
  register shows the status the event produced.

## Guardrails

- **Confirm, never infer.** Every name, role, organisation, date, version and scope comes from
  the author. A field they cannot confirm stops the record.
- **No placeholders.** Unlike a draft, a record is never written with a gap to fill later.
- **No secrets.** Record an e-signature or envelope reference if given; never a password,
  access code or image of a signature.
- **Never overwrite** an existing record; a correction is a dated note at its foot.

## Output & naming

- **Writes:** `approval-<doc-type>-DD-MM-YYYY.md` in the Approvals path (`00-project.md`
  `## Paths`; by default `planning/src/approvals/`); the register row; where applicable, the
  review-schedule row.
- **Does not touch:** the approved document itself.
