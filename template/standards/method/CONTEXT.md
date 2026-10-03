# CONTEXT.md — standards/method/

The method standard: how the work handles what it claims. `method.md` holds the rules every kind
of work shares (evidence before prose, every claim carries its basis, currency, contested
evidence stays contested, one verdict vocabulary); the doc-type mode file beside it holds the
method particular to this kind of work. Where `style/` governs how the work sounds, this folder
governs whether it is honest. Not here: the evidence itself (`research/src/evidence/`), the
gates a unit passes (`standards/verification/`) and what the work must not risk
(`standards/risk/`).

## Directory Tree

```text
standards/method/
├── CONTEXT.md      ← this file
├── CLAUDE.md       ← operating rules
├── method.md       ← the shared method: claims, evidence, currency, the verdict vocabulary
<: if DOC_TYPE == 'theology' -:>
└── THEOLOGY.md     ← the six claim categories, argument maps, contested readings, steelmanning
<: endif -:>
<: if DOC_TYPE == 'fiction' -:>
└── FICTION.md      ← the story engine: causality, want and need, scene shape, setup and payoff
<: endif -:>
<: if DOC_TYPE == 'business' -:>
└── BUSINESS.md     ← drafting principles: specificity, the obligation kept, precedence, the marks
<: endif -:>
```

## What's here

- `method.md` — the rules every variant shares, and the **one verdict vocabulary**
  (`verified · verified-with-caveat · contested · thin · cannot-be-dated · unsupported`) that
  `fact-check` returns.
<: if DOC_TYPE == 'theology' -:>
- `THEOLOGY.md` — the six claim categories and how a move between them is signalled; arguing
  from a map; naming contested readings in the body; conceding before rebutting; steelmanning;
  an objection left standing; bias declared, not neutralised.

<: endif -:>
<: if DOC_TYPE == 'fiction' -:>
- `FICTION.md` — causality ('because' and 'therefore', never 'and then'); want against need;
  scene goal, conflict and outcome; setup and payoff; point-of-view discipline; the story bible
  as the source of truth.

<: endif -:>
<: if DOC_TYPE == 'business' -:>
- `BUSINESS.md` — specificity over superlatives; shorten the writing, never the obligation;
  stated precedence; defined terms defined once; the clarifying questions as the floor; a
  delivered document as a historical record; the marks of running copy.

<: endif -:>
## Cross-references

- `research/src/evidence/` — where `fact-check` records each verdict this folder defines.
- `standards/verification/verification.md` — the gates that check a unit against these rules.
- `.claude/rules/syntek-author/03-authorship.md` — never fabricate, and the two flags.
- `.claude/skills/fact-check/SKILL.md` — the procedure that enforces `method.md`.
