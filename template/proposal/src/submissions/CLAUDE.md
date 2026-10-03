@./CONTEXT.md

# CLAUDE.md — proposal/src/submissions/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `proposal/CONTEXT.md` →
`proposal/CLAUDE.md` → `proposal/src/CONTEXT.md` → `proposal/src/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file → **`tracker.md`**.

## Purpose (one line)

Run the submission drive: which agents are queried, what each is sent, and what comes back,
recorded truthfully.

## How to work here

- **Routing:** skill `approach-a-reader` via `proposal/workflows/02-approach-a-reader/`, then
  `proposal/workflows/03-update-the-tracker/`; guides `query-package-anatomy.md` and
  `approaching-readers.md` in `proposal/docs/reference/`.
- **Model:** **Opus** for choosing agents and tailoring queries; the mechanical tier for a tracker
  date or a file chore (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** read `tracker.md` → confirm why this agent and record their guidelines →
  check the manuscript is finished and the sample promoted → tailor the master query into
  `drafts/` → hand it to the author → log the row only once the author has sent it.
- **Definition of done:** the query names why this agent, follows their guidelines exactly,
  carries the hook, the book's details and comparable titles, and is proofread; nothing was
  invented or sent; the tracker matches what happened.

## Guardrails

- **Read the tracker before drafting anything.** Never query the same agent twice with the same
  book unless they invited it.
- **The agency's guidelines win** over every template target: what to send, how long, in what form.
- **Draft; do not send.** The author sends every query.
- **Never invent** an agent's interest, a request or an offer, and never inflate a status: a
  request for a partial is `requested`, not an offer.
- **An offer is reported to the author at once.** The convention is that the author then tells every
  agent still considering the book; that is the author's message to send.
- **Do not chase before the stated response time;** after it passes, `lapsed`.
- **Never overwrite** a drafted or sent query or a tracker row; corrections are appended with a
  date.

## Output & naming

- **Seed:** `tracker.md`, never overwritten by `copier update`.
- **Hand-written:** `drafts/<agent-slug>.md`, kebab-case from the agent's name (for example
  `drafts/rowan-pell.md`).
- **Not here:** the master query letter, synopses and comparable titles, which sit in
  `proposal/src/`.
