# CONTEXT.md — world/src/languages/

One folder per constructed language, each laid out identically so that `tooling/lexicon.py`,
`tooling/script.py` and `tooling/font.py` can check, derive, render and build it: who speaks it
and what real languages it is modelled on, the sound system and its history as data, the grammar
as notes, the words as a lexicon, the writing system as a glyph table and filled-outline SVGs,
and the recorded narrator for its audio. Languages form families: a daughter names its parent and
derives from it through ordered sound changes. The IPA in each lexicon is canonical; audio is
derived from it and is never committed.

## Directory Tree

```text
world/src/languages/
├── CONTEXT.md                  ← this file
├── CLAUDE.md                   ← operating rules
└── <lang>/                     ← one language, the folder named for its slug
    ├── CONTEXT.md · CLAUDE.md
    ├── language.toml           ← name, slug, kind (proto, daughter, isolate), parent, culture,
    │                              typology, and one or more real-world [[inspiration]] models
    ├── phonology.toml          ← inventory, classes, phonotactics, stress, allophones, romanisation
    ├── sound-changes.toml      ← daughters only: ordered [[rule]] entries from the parent
    ├── grammar.md              ← word order, morphology, what it marks and ignores, irregulars
    ├── lexicon.toml            ← [meta] + one [[word]] per entry; roots and affixes included
    ├── pronunciation.md        ← narrator voice, model ID, settings, date chosen
    ├── script/                 ← optional: the writing system
    │   ├── CONTEXT.md · CLAUDE.md
    │   ├── script.md           ← type, direction, history, design principles
    │   ├── glyphs.toml         ← [meta] em grid + [meta.inspiration] + one [[glyph]] per letter
    │   ├── glyphs/             ← one filled-outline SVG per glyph and positional form (+ pair)
    │   ├── transliteration.md  ← the rules, in every direction
    │   └── numerals-and-punctuation.md
    └── audio/                  ← generated on request; ignored by world/src/.gitignore
```

## What's here

- `<lang>/` — one language. The data files (`language.toml`, `phonology.toml`,
  `sound-changes.toml`, `lexicon.toml`, `script/glyphs.toml`) are read by the tooling and follow
  the schemas in `world/docs/reference/lexicon-format.md` and
  `world/docs/reference/writing-systems.md`; the Markdown files are notes for the author, one
  sentence per line.
- **Every claim about a real language or script is cited:** each `[[inspiration]]` and
  `[meta.inspiration]` points at a note in `research/src/setting/`.
- A new project may hold an example family, Example Proto and its daughter Example Tongue, seeded
  once when the project was generated, with the research notes their models cite. It shows every
  file with consistent content and doubles as the smoke test for the tooling. **It is yours to
  delete, whole; `copier update` never brings it back.**
- **Audio never enters Git.** The rule lives one level up, in `world/src/.gitignore`
  (`languages/*/audio/`), so it stays in force even if the constructed-language kit is later
  turned off. Audio is regenerable from the IPA, costs credits to make, and large binaries do
  not belong in plain Git.

## Cross-references

- `world/workflows/06-build-a-language/` — building a language, one subsystem at a time.
- `world/workflows/07-add-a-word/` — coining a word from its roots.
- `world/workflows/08-design-a-script/` — the writing system and its font.
- `world/workflows/09-record-a-pronunciation/` — audio from the surface IPA, on request.
- `world/docs/reference/building-a-language.md` — the method behind each file.
- `tooling/data/core-concepts.toml` — the core vocabulary `make coverage` measures against.
