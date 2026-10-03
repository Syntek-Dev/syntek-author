# CONTEXT.md — standards/verification/

The gate standard: what must be true before a unit's status moves up the ladder
(`idea · outlined · draft · structural-review · fact-check · line-edit · final`), and which skill
checks it. `verification.md` numbers the shared gates V1 to V6: V1 gates `idea → outlined`, V2
and V3 together gate `draft → structural-review`, and V4 to V6 gate one review transition each
(`outlined → draft` has no gate of its own). The mode file beside it adds the variant's
sub-gates (V4.1, V5.1 and so on) under V4, V5 or V6. It is a standard, not a checklist:
workflow checklists cite gate numbers and never restate them, and the record of which gates a
unit has passed lives in the unit brief's `verified:` map, not in a separate file.

## Directory Tree

```text
standards/verification/
├── CONTEXT.md          ← this file
├── CLAUDE.md           ← operating rules
├── verification.md     ← gates V1 to V6, the transition each gates, and the skill that runs it
<: if DOC_TYPE == 'theology' -:>
└── THEOLOGY.md         ← sub-gates: argument audit, categories, traditions, steelman
<: endif -:>
<: if DOC_TYPE == 'fiction' -:>
└── FICTION.md          ← sub-gates: continuity, causality, character voice, pacing
<: endif -:>
<: if DOC_TYPE == 'business' -:>
└── BUSINESS.md         ← sub-gates: clause consistency, obligations, tone, issue readiness
<: endif -:>
```

## What's here

- `verification.md` — the six shared gates, the rule that `final` needs the author's word and
  zero flags, and how a gate is recorded and reopened. **A gate passes only when all its
  sub-gates pass.**
<: if DOC_TYPE == 'theology' -:>
- `THEOLOGY.md` — at structural review: `argument-audit`, `category-check`, `tradition-check`
  and `steelman`.

<: endif -:>
<: if DOC_TYPE == 'fiction' -:>
- `FICTION.md` — at structural review: `continuity` and `causality`; at line edit:
  `character-voice` and `pacing`.

<: endif -:>
<: if DOC_TYPE == 'business' -:>
- `BUSINESS.md` — at fact check: `clause-consistency` and `obligation-check`; at line edit:
  `tone` and the issue-readiness checks.

<: endif -:>
## Cross-references

- `planning/src/units/` — every unit brief's `status:` and `verified:` map.
- `standards/method/method.md` — the verdict vocabulary V5 relies on.
- `.claude/rules/syntek-author/03-authorship.md` — the two flags `final` must be free of, and why
  promotion is not finalisation.
- `.claude/skills/run-workflow/SKILL.md` — the router that runs the review workflow in order.
