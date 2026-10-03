# CONTEXT.md — manuscript/workflows/05-review-a-chapter/

The review that carries a chapter from `draft` to `final`. Once every planned section is promoted,
this procedure runs the review skills in a fixed order (`structure-review` → `fact-check` →
`comprehension` → `flow` → `grammar` → `spelling`), runs at each stage the further gates that
`standards/verification/verification.md` and its mode file set for this kind of book, and moves the
chapter up its ladder one stage at a time as the gates pass. Every pass reports first; agreed fixes
go back through the section procedures; `final` needs the author's word.

## Directory Tree

```text
manuscript/workflows/05-review-a-chapter/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, what it produces, the one thing that matters)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

- Every section in a chapter's brief is promoted and the author wants the chapter reviewed.
- A chapter stopped part-way up the ladder and the author wants to continue from its current stage.
- The author asks whether a chapter is 'done', or asks for a structural read, a fact check or a
  line edit of a whole chapter.

Reach for a **different** procedure when: the work is on one section, not the chapter
(`manuscript/workflows/02-adapt-a-draft/` or `manuscript/workflows/03-improve-your-draft/`); the
review spans several chapters or the whole book (`planning/workflows/09-review-the-whole-work/`);
or only a proof is wanted (`manuscript/workflows/06-build-a-proof/`).

## What it produces, and where

- **A structural review** at `planning/src/reviews/REVIEW-<scope>-DD-MM-YYYY.md`, marked advice
  only.
- **Evidence entries** in `research/src/evidence/` from the fact check, and `VERIFY` flags for
  anything not verified.
- **A line-edit report** in chat: the comprehension, flow, grammar and spelling findings, by
  location, blocking first.
- **Agreed fixes**, applied through the section procedures and recorded in each section's ledger.
- **The chapter's status** in its brief, moved one stage at a time, each move dated in `verified:`.

## The order that matters most

Structure first, then facts, then the line. A structural change can delete a paragraph whose facts
were just checked and whose commas were just fixed; a fact found false can rewrite a sentence that
was just polished. Each stage assumes the one before it is settled, which is why the chapter's
status records where the review stands, and why a later stage never starts before the gates of the
earlier one have passed.

## Cross-references

- `standards/verification/verification.md` — the gates for every move up the ladder, and the
  further gates its mode file adds for this kind of book.
- `manuscript/docs/reference/the-status-ladders.md` — the ladder, and reopening a promoted section.
- `.claude/CLAUDE.md` Section 1 — the reader the comprehension pass reads as.
- `planning/src/reviews/` — where structural reviews are kept, as advice.
