@./CONTEXT.md

# CLAUDE.md — library/src/email/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/src/CONTEXT.md` → `library/src/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold the business's correspondence, filed by correspondent and then by the family that governs its
substance, and the archived threads kept as a record.

## How to work here

- **Routing:** the `email-documents` skill and `library/docs/reference/email-standards.md` govern
  the mechanics (anatomy, naming, subject line, sending); the skill of the leaf's family
  (`<family>-documents`) governs the substance. Load both, the email skill first. An email is a
  one-section document: `library/workflows/12-write-an-email/` plans it and runs it through
  `library/workflows/01-draft-a-section/` (or the author drafts and
  `library/workflows/03-improve-your-draft/` follows) to `library/workflows/04-promote-a-section/`.
  `tone` reads it as its recipient will; `obligation-check` traces any commitment to the instrument
  that carries it.
- **Model:** **Opus** for every word that may be sent.
- **Concrete steps:**
  1. Read the correspondent's facts and every other unsent email to the same correspondent,
     together: two drafts written days apart routinely contradict each other.
  2. Write the internal note first: the purpose, the facts checked with their dates, any deviation.
  3. Draft the body; settle the subject line; name the file from it; leave `**Status:**` at Draft.
- **Definition of done:** the email makes its reason for writing the author's own, asks for one
  clear thing, carries no commitment the instruments do not, agrees with every other unsent email
  to the same correspondent, is listed in its folder's `CONTEXT.md`, and waits at Draft for the
  author.

## Guardrails

- **Never send, and never mark sent.** Sending is the author's act; `**Status:**` changes only on
  the author's word.
- **Never edit an archived thread,** never rename it to the authored pattern and never re-render its
  PDF: its headers and timestamps are what give it weight.
- **Reproduce the substance, never the clause number.** A term described in an email lives in the
  instrument; quoting clause numbers to a client invites a reading of the clause instead of the
  point.
- **Subject lines: the matter first, 50 characters or fewer, never more than 60.** Never restate the
  attachment's title, and never shorten a subject that has already been sent.
- **A follow-up never accuses.** Cut the recital of what they undertook, the count of days elapsed,
  and the denial that you are chasing; make 'no' as easy to give as 'yes'.
- **Never invent an entity detail, a name, a title or an address.** Leave `[AWAITING USER INPUT]`
  and flag it in the internal note.
- **A recipient's preference** (a format, a length, a plain-text copy) is recorded in the client
  folder's `CLAUDE.md` only on the author's instruction, as the preference alone, never the
  personal reason behind it.
- **Never name another client** in an email: correspondence is confidential.

## Output & naming

- **Hand-written:** authored emails `<subject-line>-<DD-MM-YYYY>.md` (the subject in kebab-case, no
  `email-` prefix), section drafts, and the pair of each new correspondent or family folder.
- **Kept as received:** archived threads, under their export name.
- **Generated (never hand-edit):** any PDF, HTML or rich-text copy of an email.
