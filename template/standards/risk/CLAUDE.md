@./CONTEXT.md

# CLAUDE.md — standards/risk/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `standards/CONTEXT.md` →
`standards/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file → `risk.md`,
then the mode file beside it.

## Purpose (one line)

Make sure that what the work says about real people, confidences and hard subjects is a choice
the author made knowingly, never an accident of drafting.

## How to work here

- **Routing:** `structure-review` reads this folder as one of its lenses; `fact-check` applies
  its sourcing rules to claims about real people and organisations; `draft-section` reads it
  before drafting anything that touches a real person or a confidence.<: if DOC_TYPE != 'business' and INCLUDE_SENSITIVE_CONTENT :>
  `sensitivity-pass` applies `sensitive-content.md` before a unit touching a sensitive subject
  is called done.<: endif :>
- **Model:** **Opus** for everything here; a risk judgement is never mechanical.
- **Concrete steps (when a risk appears in a draft):**
  1. Stop at the sentence. Do not soften, anonymise or cut it on your own judgement.
  2. Flag it in place with `AUTHOR TO CONFIRM`, saying what the risk is and the options.
  3. Tell the author in plain words, and wait for the decision.
  4. Record the decision, dated, in `.claude/MEMORY.md` (`## Sensitivities` or
     `## Decisions`), so the same question is not asked again in the next unit.
- **Definition of done:** every risk in the unit is either resolved by the author's recorded
  decision or still flagged; nothing was resolved silently.

## Guardrails

- **Flag and defer.** A skill never decides alone to name, anonymise, soften or keep anything
  covered here; it flags and the author decides.
- **Name the subjects once.** Sensitive topics, named high-risk claim classes and people who
  must not be identified are recorded in `.claude/MEMORY.md` `## Sensitivities`, never copied
  into skills or other governance files, so a change of scope is one edit.
- **Never fabricate or embellish personal detail**, about the author or anyone else.
- **The author's wellbeing comes before the schedule.** On hard material, pause and ask; the
  author sets the pace.

## Output & naming

- **Hand-written:** every file here; nothing is generated.
- **Mode files** add risks; they never relax a rule in `risk.md`.
