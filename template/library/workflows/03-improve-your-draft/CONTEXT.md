# CONTEXT.md — library/workflows/03-improve-your-draft/

The procedure for when the author has written a section and wants the AI's help with it. The AI
proposes improvements as a numbered diff, each with a one-line reason, at the strength the author
asks for: `light` (clarity and slips), `edit` (rhythm and structure) or `rework` (restructure, the
substance intact). Nothing is applied until the author accepts it, and every acceptance and
rejection is recorded.

## Directory Tree

```text
library/workflows/03-improve-your-draft/
├── CHECKLIST.md            ← verification checklist before marking complete
├── CLAUDE.md               ← operating rules for this workflow
├── CONTEXT.md              ← this file (when to use, what it produces, the failure it prevents)
└── STEPS.md                ← ordered steps to execute
```

## When to use this

- The author has drafted a section, an email or a clause group and asks for it to be checked,
  tightened, polished or restructured.
- The author pastes text into chat and asks what could be better: it becomes a draft first.

Reach for a **different** procedure when: the AI wrote the draft and the author has notes on it
(`library/workflows/02-adapt-a-draft/`); the section needs writing from scratch
(`library/workflows/01-draft-a-section/`); or the whole document is finished and needs its review
(`library/workflows/05-review-a-document/`).

## What it produces, and where

- **A numbered list of proposals** in the hand-back: the original line, the proposed line, and a
  one-line reason for each.
- **A supportive proofreading report:** what and where, the correction offered, recurring items
  grouped.
- **The improved draft**, in place, with only the accepted proposals applied, at `status: improved`.
- **Ledger rows** for every proposal, accepted or rejected, with the author's note.

## The failure this procedure exists to prevent

**Improvement that changes what was promised.** A tidier sentence that drops 'within five working
days' or turns 'may' into 'will' reads better and binds the business differently. Proposals here
never touch a figure, a date, a price, a scope boundary or a commitment; anything that would is
raised as a question, and the author decides.

## Cross-references

- `library/docs/reference/drafting-with-ai.md` — the loop, and why rejections matter.
- `library/workflows/07-learn-from-your-edits/` — where the rejections recorded here are mined.
- `standards/style/voice-notes.md` — the voice proposals must serve, not replace.
