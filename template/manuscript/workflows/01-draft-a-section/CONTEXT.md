# CONTEXT.md — manuscript/workflows/01-draft-a-section/

The front door to writing. This procedure takes **one section** of a chapter (a passage of 300–500
words that does one job) from the chapter's plan to an AI draft in that chapter's drafts folder,
with its ledger entry written and every unchecked claim flagged. It drafts from the plan, the
checked evidence, the voice notes and the author's own samples, never from memory, and it stops at
a draft: what happens next is the author's call.

## Directory Tree

```text
manuscript/workflows/01-draft-a-section/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, what it produces, the one thing that matters)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

- The author asks to draft, write or start a section of a chapter, or 'the next section', and the
  chapter's brief exists in `planning/src/units/` with the section in its `sections:` list.
- A chapter is planned but has no prose, and the author wants a first draft to react to.

Reach for a **different** procedure when: the author would rather write the section themselves
(they write it into the chapter's drafts folder, then `manuscript/workflows/03-improve-your-draft/`);
a draft exists and the author has notes on it (`manuscript/workflows/02-adapt-a-draft/`); the
chapter has no brief yet (`planning/workflows/01-plan-a-unit/`); or the section is approved and
ready for the chapter (`manuscript/workflows/04-promote-a-section/`).

## What it produces, and where

- **A section draft** at `manuscript/src/NN-kebab-title/drafts/<NN>-<section-slug>.md`, with
  `status: ai-draft` and `origin: ai`.
- **A ledger entry** at `standards/style/ledger/<unit-slug>--<section-slug>.md` holding the AI
  original verbatim, with `learned: false` and `format: 2`.
- **Evidence entries** in `research/src/evidence/` for every claim checked before drafting.
- **Inline flags:** `VERIFY` at every checkable claim not yet checked; `AUTHOR TO CONFIRM` at every
  decision only the author can make.
- **The section's status** in the chapter brief's `sections:` list, and, for a chapter's first
  section, the chapter's move from `outlined` to `draft` (no gate of its own; V1 still holds).
- **When the chapter folder is new:** the folder, its `CONTEXT.md` and `CLAUDE.md`, and
  `drafts/README.md`.
- **A hand-back** in chat: where the draft is, what was flagged, and what the author should decide.

## The failure this procedure exists to prevent

A draft written ahead of its evidence keeps its unchecked claims. The prose sets, the argument
comes to lean on a fact, a reading or a figure nobody checked, and by the time anyone checks,
removing it costs a rewrite. That is why gathering and checking (steps 3 and 4) come **before**
drafting, and why anything that could not be checked goes in as a visible `VERIFY` flag rather than
a confident sentence. The second failure is size: a draft too long to judge in one sitting gets
waved through. One section, within its target length, every time.

## Cross-references

- `manuscript/docs/reference/drafting-with-ai.md` — the loop this procedure opens.
- `manuscript/docs/reference/section-anatomy.md` — the draft file, its frontmatter and its name.
- `.claude/rules/syntek-author/03-authorship.md` — never fabricate; the two flags.
- `standards/style/voice-notes.md` and `standards/style/samples/` — what the draft should sound
  like.
- `research/workflows/02-verify-a-claim/` — the full procedure behind step 4.
