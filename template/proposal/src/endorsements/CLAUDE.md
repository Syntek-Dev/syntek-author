@./CONTEXT.md

# CLAUDE.md — proposal/src/endorsements/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `proposal/CONTEXT.md` →
`proposal/CLAUDE.md` → `proposal/src/CONTEXT.md` → `proposal/src/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file → **`tracker.md`**.

## Purpose (one line)

Run the endorsement drive: who is asked, what they are sent, and what comes back, recorded
truthfully.

## How to work here

- **Routing:** skill `approach-a-reader` via `proposal/workflows/02-approach-a-reader/`, then
  `proposal/workflows/03-update-the-tracker/`; guides `approaching-readers.md` and
  `book-proposal-anatomy.md` in `proposal/docs/reference/`.
- **Model:** **Opus** for choosing and drafting; the mechanical tier for a tracker date or a file
  chore (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** read `tracker.md` → confirm why this person → check `manuscript/src/` for
  what can be sent → draft the email in `drafts/` → hand it to the author → log the row only once
  the author has sent it.
- **Definition of done:** the email names the specific reason it is this person, leads with the
  hook, states the ask with its effort and date, makes declining easy, is under 250 words and
  proofread; nothing was invented or sent; the tracker matches what happened.

## Guardrails

- **Read the tracker before drafting anything.** A second first approach to someone already
  contacted is entirely preventable and entirely embarrassing.
- **Draft; do not send.** The author sends every email.
- **Never claim an endorsement not given**, never imply interest from anyone not approached, and
  never invent a deadline.
- **Never offer what does not exist.** Check `manuscript/src/` before naming what will be sent.
- **A named person, never a department.**
- **One chase, a fortnight on,** shorter and with an easier exit; then `lapsed`.
- **Received endorsements are verbatim.** Never edit one without the endorser's agreement.
- **Never overwrite** a drafted or sent email, a tracker row or a received endorsement; corrections
  are appended with a date.

## Output & naming

- **Seed:** `tracker.md`, never overwritten by `copier update`.
- **Hand-written:** `drafts/<reader-slug>.md` and `received-<reader-slug>.md`, kebab-case slugs
  from the person's name (for example `drafts/ada-quill.md`).
- **Not here:** the proposal's own endorsement section (`proposal/src/book-proposal/`).
