# CONTEXT.md — standards/brand/

The brand standard: how the business sounds and looks in every document it issues, and the one
place each disclaimer's wording lives. **All three files are seeded and author-owned**: they ship
once, empty of entries, and `copier update` never overwrites them, so the author fills them in
place. `brand-voice.md` and `brand-guide.md` carry the house writing rules under each heading,
with every decision only the author can make flagged `AUTHOR TO CONFIRM` until they make it;
`disclaimers.md` holds the trading name the documents use and one wording per document class.
The house drafting principles that template updates keep current, the marks of running copy
among them, live in `standards/method/BUSINESS.md`. Not here: the mechanics of spelling and
punctuation (`standards/style/style-sheet.md`), the person the business writes in
(`standards/style/voice-notes.md`), or logo files (`assets/`).

## Directory Tree

```text
standards/brand/
├── CONTEXT.md        ← this file
├── CLAUDE.md         ← operating rules
├── brand-voice.md    ← how the business sounds: registers, its own marks, high-stakes copy (seed)
├── brand-guide.md    ← how the business looks: logo, palette, type, document layout (seed)
└── disclaimers.md    ← one disclaimer per document class, and the trading name (seed)
```

## What's here

- `brand-voice.md` — the voice of running copy and microcopy, the business's own marks beside
  the house marks, what a copy review keeps and tidies, and the highest-stakes copy. **`tone`
  enforces it at line edit (V6.1).**
- `brand-guide.md` — the visual identity, mapped to the colour and font names in
  `tooling/latex/house-preamble.tex`, so a brand change is one edit.
- `disclaimers.md` — the wording for each document class, and where it goes. **Every document
  takes its disclaimer from here**, never from memory or another document.

## Cross-references

- `standards/method/BUSINESS.md` — the drafting principles the voice serves, and rule 10, the
  house marks of running copy.
- `standards/risk/BUSINESS.md` — rule 4, the disclaimer rule.
- `tooling/latex/` — the house preamble and skeleton that carry the visual identity.
- `assets/` — logo files and other brand assets.
