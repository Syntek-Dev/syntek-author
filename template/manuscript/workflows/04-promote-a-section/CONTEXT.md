# CONTEXT.md — manuscript/workflows/04-promote-a-section/

The step where a section becomes part of the book. On the author's explicit word, this procedure
checks the section is clear of flags and gates, inserts it into the chapter file under its
`<!-- section: <slug> -->` marker in plan order, marks it `promoted`, and records its provenance:
the author's final text, the date and how much the author changed from any AI original. It never
moves the chapter's own status: a chapter becomes `final` only through review and the author's
word.

## Directory Tree

```text
manuscript/workflows/04-promote-a-section/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, what it produces, the one thing that matters)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

- The author says, of a named section, that it is ready: 'promote it', 'put it in the chapter',
  'that one's done'.
- A section promoted earlier has been reopened, revised and approved again.

Reach for a **different** procedure when: the author still has notes
(`manuscript/workflows/02-adapt-a-draft/` or `manuscript/workflows/03-improve-your-draft/`); the
section carries a `VERIFY` flag (`research/workflows/02-verify-a-claim/` first); or every section
is promoted and the chapter needs reviewing (`manuscript/workflows/05-review-a-chapter/`). 'Looks
good' said in passing is not the word: ask.

## What it produces, and where

- **The chapter file** `manuscript/src/NN-kebab-title/NN-kebab-title.md`, with the section's prose
  under its marker (the file is created from the brief the first time a section is promoted).
- **The draft** at `status: promoted`; it stays in the drafts folder as the record of what was
  approved.
- **The ledger entry** with `## Author final`, `promoted` and `change_ratio` filled.
- **A row** in `standards/style/ledger/provenance.md`.
- **The brief's** `sections:` entry set to `promoted`, and the chapter's line under Status in
  `.claude/MEMORY.md` brought up to date.

## The two things this procedure exists to force

- **The author's word.** Nothing reaches the chapter because it seemed finished. Promotion is an act
  the author performs through the AI, on a named section, every time.
- **The record.** A section promoted without its ledger entry cannot be disclosed honestly later,
  and cannot teach `learn-voice` anything. The record is written in the same procedure as the
  promotion, never 'afterwards'.

## Cross-references

- `manuscript/docs/reference/section-anatomy.md` — the chapter file and its markers.
- `manuscript/docs/reference/the-status-ladders.md` — `promoted`, and why the chapter does not move.
- `manuscript/docs/reference/drafting-with-ai.md` — the ledger and the change ratio.
- `standards/verification/verification.md` — any gate set for promoting a section.
