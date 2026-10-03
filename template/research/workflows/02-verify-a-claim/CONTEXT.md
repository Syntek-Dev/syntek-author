# CONTEXT.md — research/workflows/02-verify-a-claim/

**The gate.** Every figure, date, study finding and legal statement the work makes passes through
this procedure before it is written. It isolates the claim as one checkable sentence, reaches the
primary source, records the basis and both dates, says what a study was not about, and returns one
of six verdicts. There is no other verification anywhere in the project: this procedure is the
whole of it.

## Directory Tree

```text
research/workflows/02-verify-a-claim/
├── CONTEXT.md        ← this file: when to use it, what it produces
├── CLAUDE.md         ← how to run it; guardrails
├── STEPS.md          ← the ordered procedure
└── CHECKLIST.md      ← tick as you go; model-tagged
```

## When to use this

- A unit is about to state a number, a date, a measurement, a study finding or a legal position.
  **Before drafting**, not after.
- A draft carries a `VERIFY` flag (`make flags` lists them all; that list is the queue).
- The author asks whether a claim is right, still true, or defensible.
- Before an export to anyone outside the project, over any claim last checked more than roughly
  twelve months ago.
- Something plausible has appeared in a draft and nobody can remember where it came from.

Reach for a **different** procedure when the source needs reading rather than checking
(`research/workflows/01-ingest-a-source/`), or when the material belongs to a specialist folder the
routing table in `research/src/CONTEXT.md` names.

## What it produces, and where

- **An entry** at `research/src/evidence/<topic>.md`, one per claim, in the format in
  `research/src/evidence/CONTEXT.md`.
- **A verdict:** `verified` · `verified-with-caveat` · `contested` · `thin` · `cannot-be-dated` ·
  `unsupported`. The last two mean *recommend cutting*.
- **The narrower usable wording**, where the claim is true but smaller than the draft wanted. This
  is the most common useful outcome.
- **A report on the `VERIFY` flags** the verdict clears, and those it keeps.

## Why this matters more than it looks

A claim the work cannot defend costs it the readers best placed to vouch for it: the specialists
who check the numbers first. **A claim the work cannot defend is worse than no claim.** Cut it
rather than hedge it; 'roughly' and 'some estimates suggest' do not repair a figure with no basis.

## Cross-references

- `research/docs/reference/vetting-evidence.md` — the five things a claim carries; the verdicts.
- `research/src/evidence/CONTEXT.md` — the entry format.
- `.claude/skills/fact-check/SKILL.md` — this procedure in skill form.
- `standards/verification/verification.md` — the fact-check gate a unit must pass.
- `.claude/rules/syntek-author/03-authorship.md` — the `VERIFY` flag.
