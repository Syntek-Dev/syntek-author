# CONTEXT.md — world/src/languages/example-tongue/

Example Tongue: the daughter of the example family, seeded once when this project was generated.
It descends from Example Proto through four ordered sound changes shaped after medieval
Castilian, and it is written in a carved alphabet inspired by the structure of ogham. It has
twenty-one phonemes, eleven entries (an irregular word, a learned doublet and two new coinages
among them) and sixteen drawn letters, enough to write every headword. Every word passes
`make lexicon`, and every inherited word and loan re-derives under `make derive`. It belongs to no
book; delete the family whole, or keep it as a reference. `copier update` never brings it back.

## Directory Tree

```text
world/src/languages/example-tongue/
├── CONTEXT.md            ← this file
├── CLAUDE.md             ← operating rules
├── language.toml         ← kind daughter of example-proto; marks formality; model: Old Spanish
├── phonology.toml        ← 21 phonemes; b d g soften between vowels; penultimate stress
├── sound-changes.toml    ← four ordered rules from the parent
├── grammar.md            ← the changes at work, the irregular word, the doublet, what is undecided
├── lexicon.toml          ← quaro, quaru, mibo, mibiga, hebo, hebado, hepom, kelo, mipfebo, -ri, hebori
├── pronunciation.md      ← no narrator chosen yet; the surface IPA each word is sent as
└── script/               ← the alphabet: glyph table, SVGs, rules, numerals still to design
```

## What's here

- `language.toml`, `phonology.toml`, `sound-changes.toml`, `lexicon.toml` — the data the tooling
  checks. **Every inherited word's `proto_form` derives to its IPA through the rules, except
  quaru, which is marked `irregular` with its reason.**
- `grammar.md` — the history at work, and only as much grammar as the eleven entries need.
- `pronunciation.md` — the narrator record, and the surface IPA the tooling produces.
- `world/src/languages/example-tongue/script/` — the writing system; every headword
  transliterates, and `make font` builds it into a font.
- The language's audio folder is created only if the author asks for audio, and Git ignores it.

## Cross-references

- `world/src/languages/example-proto/` — the parent every inherited word comes from.
- `research/src/setting/example-model-old-spanish.md` — the cited facts behind the sound model.
- `research/src/setting/example-model-ogham.md` — the cited facts behind the script's structure.
- `world/src/cultures/example-culture.md` — the speakers: fords, knives, posts and rites.
- `world/docs/reference/building-a-language.md` — the method each file follows.
- `world/docs/reference/lexicon-format.md` — the schema of the data files.
