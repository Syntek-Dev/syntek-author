@./CONTEXT.md

# CLAUDE.md — research/workflows/02-verify-a-claim/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `research/CONTEXT.md` →
`research/CLAUDE.md` → `research/workflows/CONTEXT.md` → `research/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Establish whether a claim is true, on what basis and as of when, before it reaches the page.

## How to work here

**Follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.** The model tags in the checklist
are authoritative: `opus` items are judgement; `sonnet` items belong to the mechanical tier.

- **Routing:** skill `fact-check` (this procedure in skill form), which hands delegated search to
  `research`; guide `research/docs/reference/vetting-evidence.md`; the add-reference skill for the key
  where the project keeps the citation database.
- **Model:** **Opus**: whether a source supports a claim is never mechanical. The mechanical tier
  only for the `make` runs (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** isolate the claim → check whether it is already verified → name the basis it
  needs → reach the primary source → record two dates → record what a study was not about → check
  the conflations → keep going past the convenient answer → for a legal claim, name jurisdiction
  and date → assign the verdict → write the entry → key it → report the flags → hand back.
- **Definition of done:** the claim is one checkable sentence; a primary source was reached; the
  basis and both dates are recorded; a study's limits and the gap to the work's claim are explicit;
  the verdict is one of the six; where the claim narrowed, the usable wording is supplied.

## Guardrails

- **A claim without its basis is decoration: cut it, do not hedge it.**
- **Record what a study was not about, and state the gap in the unit's body,** not only here.
- **Don't stop where it's convenient.** When the evidence starts agreeing with the author, keep
  going, and write into the entry where pushing past that point changed the answer.
- **Contested stays contested; thin stays thin.** Never average, never round a range into a
  headline, never promote one unreplicated finding into 'the research shows'.
- **Legal claims carry jurisdiction and date** and say where the matter is unsettled.
- **Correct against the work's interest, out loud.** Where a fact tells against the argument's
  convenience, say so plainly in the verdict.
- **Claims about the author** are checked against `.claude/MEMORY.md` (Facts), and put to the
  author where it is silent; never inferred.
- **Never mark anything verified without a real source,** and never invent a figure, a source or a
  key.
- **Never overwrite an entry;** supersede it with a dated addition. Figures move, and the history
  of a figure is itself useful.

## Output & naming

- **Produces:** `research/src/evidence/<topic>.md`, one per claim.
- **Also writes:** `VERIFY` flags in the draft for claims not yet checked, and the citation row
  where the project keeps the citation database.
- **Returns:** the verdict, the source, both dates, the basis and the usable wording.
- **Does not touch:** the prose itself, beyond flags; the drafting side applies the usable wording
  with the author.
