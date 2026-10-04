# CONTEXT.md — manuscript/workflows/02-adapt-a-draft/

The author has read a draft and has notes on it, or has edited it by hand and wants the rest
brought into line. This procedure makes a **targeted revision**: it changes only what the author
flagged, offers two or three alternatives wherever a note leaves the choice open, and records every
choice in the section's ledger. It never rewrites the whole section. When asked, it also adapts the
author's own earlier material (a talk, an essay, an earlier draft, a story written for another
purpose) into a section, keeping the spine and changing the register.

## Directory Tree

```text
manuscript/workflows/02-adapt-a-draft/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, what it produces, the one thing that matters)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

- The author gives notes on a section draft: 'this paragraph is flat', 'cut the second example',
  'the ending comes too soon'.
- The author has edited an AI draft by hand and asks for the rest of the section to follow suit.
- The author asks for a section to be made from their own existing material.

Reach for a **different** procedure when: the author wrote the section and wants suggestions
rather than a revision to their notes (`manuscript/workflows/03-improve-your-draft/`); there is no
draft yet (`manuscript/workflows/01-draft-a-section/`); the section is approved
(`manuscript/workflows/04-promote-a-section/`); or the notes change what the section is for, which
is a change to the chapter's brief (`planning/workflows/01-plan-a-unit/`).

## What it produces, and where

- **The revised draft**, in place in the chapter's drafts folder, at `status: adapted`.
- **Alternatives** for each open note, offered in chat with a one-line note on what each does
  differently; the original line stays in the file until the author chooses.
- **Ledger rows** in the section's `## Improvement decisions` table: every note applied and every
  alternative offered, with the author's choice; and **revisions**, the text after each kind of
  change, marked with whose change it was.
- **The section's status** updated in the chapter brief's `sections:` list.

## The failure this procedure exists to prevent

A note about one sentence answered by rewriting the whole section. It feels helpful and it is
destructive: every earlier decision the author made in that section is silently undone, the author
has to re-read everything to find what moved, and the ledger learns nothing about what the author
actually wanted. **Change only what was flagged.** Where a note genuinely needs a wider change, say
so and ask before making it.

## Cross-references

- `manuscript/docs/reference/drafting-with-ai.md` — where adapting sits in the loop.
- `manuscript/docs/reference/the-status-ladders.md` — `adapted` and `author-revised`.
- `standards/style/voice-notes.md` — the voice the revision must keep.
- `manuscript/workflows/07-learn-from-your-edits/` — where the choices recorded here are used.
