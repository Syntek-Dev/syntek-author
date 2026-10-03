@./CONTEXT.md

# CLAUDE.md — proposal/workflows/02-approach-a-reader/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `proposal/CONTEXT.md` →
`proposal/CLAUDE.md` → `proposal/workflows/CONTEXT.md` → `proposal/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open) → **the
tracker**.

## Purpose (one line)

Draft one tailored, candid approach that is easy to say yes to and easy to decline, and hand it to
the author to send.

## How to work here

**Follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.** The model tags in the checklist
are authoritative: `opus` items are judgement; `sonnet` items belong to the mechanical tier.

- **Routing:** skill `approach-a-reader` (this procedure in skill form; its mode file carries the
  endorser or agent detail); `spelling` and `grammar` for the proofread. Guides:
  `proposal/docs/reference/approaching-readers.md` and the package anatomy beside it.
- **Model:** **Opus**: what to say to whom is the whole task. The mechanical tier only for saving
  the file and the tick (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** read the tracker → confirm why this reader → check what they ask for and what
  exists → start from the master and tailor → write the approach → check nothing is invented →
  proofread → save the draft → hand it to the author → log it once sent → chase only as the rule
  allows.
- **Definition of done:** the approach names the specific reason it is this person, leads with the
  hook, states the ask with its effort and date (or meets the reader's published requirements
  exactly), makes declining easy where the form allows, is within the length the anatomy sets and
  proofread; nothing invented; **nothing sent**.

## Guardrails

- **Read the tracker first, every time.** If the person has a row, this is a revision or a chase,
  never a second first approach.
- **Draft; do not send.** It is the author's name, relationships and standing.
- **If you cannot name why this person, stop.** Generic praise reads as a mail-merge.
- **Never offer what does not exist,** and never invent an endorsement, an interest, an offer or a
  deadline.
- **The reader's own requirements win** over every template target.
- **A named person, never a department** or a general inbox where a name is available.
- **Never overwrite** a drafted or sent approach without confirming.

## Output & naming

- **Produces:** one draft in the `drafts/` folder beside the tracker, `<reader-slug>.md`.
- **Also writes:** a tracker row, through `03-update-the-tracker`, only once the author has sent it.
- **Does not produce:** a sent email, a claimed endorsement or offer, or any change to the package.
