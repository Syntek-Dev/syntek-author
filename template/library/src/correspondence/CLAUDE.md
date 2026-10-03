@./CONTEXT.md

# CLAUDE.md — library/src/correspondence/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/src/CONTEXT.md` → `library/src/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold the letters and emails the business writes to one reader at a time, and the archived threads
kept as a record.

## How to work here

- **Routing:** an email or short letter is a one-section document:
  `library/workflows/01-draft-a-section/` (or the author drafts and
  `library/workflows/03-improve-your-draft/` follows), then
  `library/workflows/04-promote-a-section/`. The `tone` skill reads it as its recipient will;
  `obligation-check` traces any commitment to the instrument that carries it. The substance of an
  email is governed by the family it concerns: a letter about fees follows the contracts rules as
  well as these.
- **Model:** **Opus** for every word that may be sent.
- **Concrete steps:**
  1. Read the counterparty's facts and every earlier, still unsent email to the same recipient.
  2. Write the internal note first: the purpose, the facts checked with dates, the deviations.
  3. Draft the body; check the subject line; leave `**Status:**` at Draft for the author.
- **Definition of done:** the email makes its reason for writing the author's own, asks for one
  clear thing, carries no commitment the instruments do not, and waits at Draft for the author.

## Guardrails

- **Never send, and never mark sent.** Sending is the author's act; `**Status:**` changes only on
  the author's word.
- **Reproduce the substance, never the clause number.** A term described in an email lives in the
  instrument; quoting clause numbers to a client invites a reading of the clause instead of the
  point.
- **Subject lines: the matter first, about 50 characters, never more than 60.** Never restate the
  attachment's title, and never shorten a subject that has already been sent.
- **A follow-up never accuses.** Cut the recital of what they undertook, the count of days elapsed,
  and the denial that you are chasing; make 'no' as easy to give as 'yes'.
- **A recipient's preference** (a format, a length, a plain-text copy) is recorded in the client
  folder's `CONTEXT.md` only on the author's instruction, as the preference alone, never the
  personal reason behind it.
- **Archived threads are immutable.**

## Output & naming

- **Hand-written:** authored emails (`.md`), letters (`.tex`), section drafts.
- **Kept as received:** archived threads.
- **Generated (never hand-edit):** any PDF or HTML copy of an email or letter.
