# CONTEXT.md — standards/style/

The style standard: how the work spells, punctuates and sounds, and the evidence its voice is
learned from. Three seeded files hold the decisions (`style-sheet.md` for mechanics,
`voice-notes.md` for voice, `terminology.md` for fixed terms); `samples/` holds the author's own
writing and `ledger/` the provenance of every section, which together are what `learn-voice`
mines. All three seeds ship empty: a voice guide or a style sheet written before the author's
own prose exists would be a guess dressed as a rule. No prose of the work lives here.

## Directory Tree

```text
standards/style/
├── CONTEXT.md         ← this file
├── CLAUDE.md          ← operating rules
├── style-sheet.md     ← mechanics as data: spelling, punctuation, numbers, dates, capitals (seed)
├── voice-notes.md     ← how the work sounds; `## Learned` grows by learn-voice (seed)
├── terminology.md     ← term · meaning · use · avoid (seed)
├── samples/           ← the author's own writing, the evidence for the voice notes
└── ledger/            ← one entry per section: its original, every revision and who made it, the
                         author final, decisions (+ provenance.md); make compare prints it
```

## What's here

- `style-sheet.md` — the project's mechanical decisions. **It overrides the defaults of the
  `spelling` and `grammar` skills**; their variant examples live in their mode files, not here.
  `learn-voice` may propose a mechanical rule from the ledger, written only once approved.
- `voice-notes.md` — the voice every drafting skill writes from. Its `## Learned` section is
  appended to by `learn-voice`, and **only after the author approves** each addition.
- `terminology.md` — the terms the work uses in a fixed sense, with the near-synonyms to avoid.
  A term settled in a grilling session is recorded here by `grill-with-docs`; a term
  `learn-voice` finds in the ledger is written here only once approved.
- `samples/` — the author's own writing, never AI text, never edited.
- `ledger/` — `<unit>--<section-slug>.md` per section and the `provenance.md` register;
  the source of truth for AI disclosure (`make provenance`), and the revision record
  `make compare` prints as each section's path from its original to its final text.

## Cross-references

- `.claude/rules/syntek-author/03-authorship.md` — the authoring loop the ledger records.
- `.claude/rules/syntek-author/06-global-rules.md` — the locale and the supportive proofreading
  default these files refine.
- `standards/method/` — what the prose must do; `style/` decides only how it sounds.
- `tooling/provenance.py` — computes change ratios and the disclosure table from `ledger/`.
