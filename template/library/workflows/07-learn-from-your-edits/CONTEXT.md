# CONTEXT.md — library/workflows/07-learn-from-your-edits/

The procedure for turning what the author changed into lasting guidance. It mines the ledger for
sections not yet learned from: what the author changed by hand at each stage of a section's
record, and which proposed improvements they rejected or later undid. It proposes additions to
the voice notes (and, for a mechanical rule or a term, to the style sheet or the terminology), each
with real before-and-after examples from the author's own edits, and writes only what the author
approves. It can also seed the voice notes from the author's samples when the project is new.

## Directory Tree

```text
library/workflows/07-learn-from-your-edits/
├── CHECKLIST.md            ← verification checklist before marking complete
├── CLAUDE.md               ← operating rules for this workflow
├── CONTEXT.md              ← this file (when to use, what it produces, the failure it prevents)
└── STEPS.md                ← ordered steps to execute
```

## When to use this

- Several sections have been promoted since the voice notes last learned, or the author keeps
  making the same change to AI drafts.
- The author asks the AI to 'learn my style', or to stop doing something it keeps doing.
- The project is new and `standards/style/samples/` holds the author's own writing but
  `standards/style/voice-notes.md` is still a stub.

Reach for a **different** procedure when: the lesson is a rule for one document only (record it in
that document's internal note or unit brief); the change is to a standard's rule (the author
changes standards, and only on their explicit instruction); or the author wants a section improved
now (`library/workflows/03-improve-your-draft/`).

## What it produces, and where

- **A proposal** in the hand-back: each pattern found, with at least two real before-and-after
  examples from the ledger, and where it would be recorded.
- **Approved additions** to `standards/style/voice-notes.md` `## Learned`, dated; a term to
  `standards/style/terminology.md`, a mechanical rule to `standards/style/style-sheet.md`, each
  only with the author's approval.
- **Ledger entries marked `learned: true`** once their section is promoted and they are mined; an
  entry not yet promoted stays unlearned.

## The failure this procedure exists to prevent

**A voice guide written from borrowed examples.** A voice note invented by the model describes the
model, not the author, and every later draft drifts towards it. Lessons here come only from what
the author actually did to real text, and they are written down only once the author agrees they
describe how they write.

## Cross-references

- `library/docs/reference/drafting-with-ai.md` — the ledger and why rejections matter most.
- `standards/style/ledger/` — the evidence this procedure reads.
- `standards/style/voice-notes.md` — where approved lessons go.
