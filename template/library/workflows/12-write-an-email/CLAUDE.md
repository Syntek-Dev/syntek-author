@./CONTEXT.md

# CLAUDE.md — library/workflows/12-write-an-email/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/workflows/CONTEXT.md` → `library/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Write one email through the loop, filed by correspondent and governing family, consistent with
every other unsent email to the same correspondent, and waiting at Draft for the author.

## How to work here

- **Routing:** the `email-documents` skill, loaded first, holds the mechanics; then the skill of
  the leaf's family (`<family>-documents`; `business-documents` for most client and supplier
  matters) holds the substance. `library/docs/reference/email-standards.md` and the leaf family's
  standard govern. `tone` reads the email as its recipient will; `obligation-check` traces each
  commitment.
- **Model:** **Opus** for every word that may be sent; the mechanical tier for folders, the file's
  fixed parts and ticks.
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go; each loop
  procedure it names is run with its own `CHECKLIST.md` open.
- **Definition of done:** the email is in its correspondent's folder under the right family, named
  from its subject line, with the four-part anatomy, an internal note that records its sources and
  decisions, no unflagged placeholder, nothing that contradicts another unsent email, listed and
  registered, and its `**Status:**` at Draft.

## Guardrails

- **Never send, and never mark sent.** `**Status:**` changes only on the author's word.
- **Read every other unsent email to the same correspondent before drafting,** and again before
  hand-back.
- **No commitment the instruments do not carry,** and never a clause number in the body.
- **Never invent an entity detail, a name or a title:** `[AWAITING USER INPUT]`, flagged in the
  internal note.
- **A follow-up never accuses,** and length is never cut at the cost of an ask, a caveat, a figure
  or a commitment.
- **Never touch an archived thread.**

## Output & naming

- **Produces:** the brief; the body draft and its ledger entry; the authored email
  `<subject-line>-<DD-MM-YYYY>.md`.
- **Also writes:** client or matter folders and leaves with their pairs, on the author's
  confirmation; the folder's `CONTEXT.md` list; the register row.
- **Does not touch:** any archived thread, standard or other correspondent's folder.
