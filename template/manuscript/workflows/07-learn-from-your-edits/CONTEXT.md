# CONTEXT.md — manuscript/workflows/07-learn-from-your-edits/

The procedure that turns the author's edits into a better voice guide. It reads the ledger entries
not yet learned from: what the author changed between an AI draft and the promoted text, and which
suggestions and alternatives the author turned down. From the patterns it proposes additions to
`standards/style/voice-notes.md` (and, for a mechanical habit or a term, to the style sheet or the
terminology), each backed by real before-and-after examples, and writes only what the author
approves. It also seeds the voice notes from the author's own samples when the notes are still
empty. It never changes a standard on its own authority.

## Directory Tree

```text
manuscript/workflows/07-learn-from-your-edits/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, what it produces, the one thing that matters)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

- Several promoted sections carry `learned: false` in their ledger entries: a handful, not one.
- A chapter has just been finished, and its sections' records are complete.
- The author says the drafts do not sound like them, or keeps making the same change.
- The project is new, `standards/style/samples/` holds the author's own writing, and the voice
  notes are still empty.

Reach for a **different** procedure when: the author already knows the rule about spelling,
punctuation or numbers they want, which they add to `standards/style/style-sheet.md` themselves; or
the problem is one section's wording (`manuscript/workflows/02-adapt-a-draft/`).

## What it produces, and where

- **A proposal** in chat: each candidate in one sentence, its home, its evidence (before and after,
  with the ledger entry it came from) and how many sections show it.
- **Approved notes** appended under `## Learned` in `standards/style/voice-notes.md`, and approved
  rules and terms in `standards/style/style-sheet.md` and `standards/style/terminology.md`, dated,
  each with its example.
- **`learned: true`** on every promoted ledger entry read in the run; an entry not yet promoted
  stays unlearned.
- **Conflicts** between a proposed note and the style sheet or an existing note, raised for the
  author to settle.
- **A dated entry** in `.claude/MEMORY.md` Decisions (mapped in `00-project.md`
  `## Memory headings`) when an approved note overturns an earlier voice decision.

## The one thing that matters: evidence, not impressions

A voice guide with borrowed examples is a hypothesis, not a standard. Every note this procedure
proposes must point at the author's own text: what they cut, what they wrote instead, what they
refused. A pattern seen once is a preference in context, not a rule; it needs at least two
sections before it becomes a note. And the notes are the author's: nothing is written to the voice
notes until the author has read it and said yes.

## Cross-references

- `manuscript/docs/reference/drafting-with-ai.md` — the ledger, and why rejections teach most.
- `standards/style/ledger/` — the evidence this procedure reads.
- `standards/style/voice-notes.md` — the file it proposes additions to.
- `standards/style/samples/` — the author's own writing, for seeding.
