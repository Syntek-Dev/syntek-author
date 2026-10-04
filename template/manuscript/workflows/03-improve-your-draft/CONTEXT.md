# CONTEXT.md — manuscript/workflows/03-improve-your-draft/

The author wrote the section; the AI suggests. This procedure reads an author-drafted section and
proposes improvements as a **numbered diff**, each with a one-line reason, at the strength the
author chose: `light` (clarity, typos, slips), `edit` (rhythm, sentence order, joins) or `rework`
(restructure, with the argument or the events intact). It is report-then-apply: nothing changes
until the author accepts it, and every proposal, accepted or rejected, is logged in the section's
ledger.

## Directory Tree

```text
manuscript/workflows/03-improve-your-draft/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, what it produces, the one thing that matters)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

- The author has written a section (in the chapter's drafts folder, or pasted in chat) and asks
  for it to be tightened, proofread, polished, or 'made better'.
- A section the author has revised by hand needs a final pass before promotion.

Reach for a **different** procedure when: the section is an AI draft and the author has notes on it
(`manuscript/workflows/02-adapt-a-draft/`); the question is the whole chapter's shape, claims or
flow (`manuscript/workflows/05-review-a-chapter/`); or the section is ready
(`manuscript/workflows/04-promote-a-section/`).

## What it produces, and where

- **A numbered diff** in chat: location, before, after, a one-line reason, grouped so one decision
  can settle a recurring item.
- **Questions, kept apart from the diff,** for anything outside the lane: a figure, a date, a
  citation, a commitment, the argument itself.
- **The accepted changes** applied to the draft, at `status: improved`.
- **Ledger rows** for every proposal, accepted or rejected, in `## Improvement decisions`; the
  author's text as it was before the first pass, as the entry's `## Author original`; and an `ai`
  revision holding the text after the accepted changes.

## What this pass must not do

- **Not change what the author is saying.** Facts, figures, dates, citation keys, commitments and
  the argument belong to the author and to the procedures that check them. This pass asks about
  them; it never edits them.
- **Not tidy away an honest hedge.** A qualification that looks like weak writing is often the
  method doing its job. Check before proposing to cut it.
- **Not sterilise the voice.** The author's cadence, directness and habits are the voice; fix
  errors around them.
- **Not comment on the author.** Proofreading is a report on the text: what and where, with the
  correction offered.

## Cross-references

- `manuscript/docs/reference/drafting-with-ai.md` — where improving sits in the loop.
- `standards/style/voice-notes.md` and `standards/style/style-sheet.md` — what the suggestions
  must respect.
- `standards/method/method.md` — the method a hedge may be serving.
- `manuscript/workflows/07-learn-from-your-edits/` — where the rejected proposals are used.
