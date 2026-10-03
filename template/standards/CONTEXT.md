# CONTEXT.md — standards/

The supporting layer that holds the rules the whole work is written against: how it sounds and
spells, how it handles claims, what it must not risk, and what each unit must pass before its
status moves. Standards are requirements, not preferences: where a unit contradicts a standard,
the unit is wrong, and a standard changes only openly, with the author. They exist so that units
drafted out of order, months apart, still read as one work. No prose of the work lives here
(that is the content layer), no evidence (that is `research/src/`) and no machinery (that is
`tooling/`).

## Directory Tree

```text
standards/
├── CONTEXT.md        ← this file
├── CLAUDE.md         ← operating rules: how to apply a standard, and how to change one
├── style/            ← style sheet, voice notes, terminology (seeds); samples/ and ledger/
├── method/           ← how the work handles claims: method.md + the doc-type mode file
├── risk/             ← what the work must not risk: risk.md + the doc-type mode file
<: if INCLUDE_REFERENCES -:>
├── referencing/      ← Harvard (Cite Them Right), citation keys, the reference pipeline
<: endif -:>
<: if DOC_TYPE == 'business' -:>
├── brand/            ← brand voice, brand guide, disclaimers by document class
<: endif -:>
└── verification/     ← the numbered gates (V1 to V6) a unit passes as its status moves
```

## What's here

- `style/` — the mechanics (`style-sheet.md`), the voice (`voice-notes.md`) and the fixed terms
  (`terminology.md`), all seeded empty and grown with the author; `samples/` holds the author's
  own writing and `ledger/` the provenance of every section. **The author's word fills them.**
- `method/` — `method.md` (evidence before prose, every claim carries its basis, one verdict
  vocabulary) plus the method particular to this kind of work in its mode file.
- `risk/` — `risk.md` (real people, confidences, consent, flag and defer) plus the domain risks
  in its mode file.
<: if INCLUDE_REFERENCES -:>
- `referencing/` — `harvard-referencing.md`: citations are generated, never hand-formatted, and
  citation keys are never renamed.
<: endif -:>
<: if DOC_TYPE == 'business' -:>
- `brand/` — `brand-voice.md`, `brand-guide.md` and `disclaimers.md`: the voice, the look and
  one wording per document class, all three seeded empty of entries and owned by the author.
<: endif -:>
- `verification/` — `verification.md`: gates V1 to V6, each naming the transition it gates and
  the skill that runs it; the mode file adds the variant's sub-gates under V4 to V6. **Checklists
  cite gate numbers; they never restate the gates.**

## Cross-references

- `.claude/rules/syntek-author/03-authorship.md` — the authoring constitution these standards
  serve: who decides what, never fabricate, the two flags.
- `.claude/rules/syntek-author/06-global-rules.md` — locale, never self-edit, route and do not
  restate.
- `planning/src/units/` — each unit brief carries the `verified:` map that records which gates
  passed, and when.
- `research/src/evidence/` — where `fact-check` records the verdicts `method/` defines.
- `tooling/` — the machinery that enforces what these files describe; if the two disagree, the
  standard is right and the tooling is broken.
