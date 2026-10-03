# CONTEXT.md — world/src/languages/example-proto/

Example Proto: the parent of the example family, seeded once when this project was generated.
It is a reconstructed proto-language, modelled on the sound of Classical Latin: twenty phonemes,
four roots, four suffixes and ten words, every form marked with an asterisk when prose discusses
it. Its daughter, Example Tongue, descends from it through ordered sound changes, and the pair is
also the smoke test for the language tooling. It belongs to no book; delete the family whole, or
keep it as a reference until your own languages exist. `copier update` never brings it back.

## Directory Tree

```text
world/src/languages/example-proto/
├── CONTEXT.md          ← this file
├── CLAUDE.md           ← operating rules
├── language.toml       ← kind proto; culture; one [[inspiration]]: Classical Latin (classical)
├── phonology.toml      ← 20 phonemes, (C)V(K) and CLV(K), penultimate stress, kʷ → qu, j → y
├── grammar.md          ← suffixes and compounds; what it marks and ignores; what is undecided
├── lexicon.toml        ← 4 roots, 4 suffixes, 10 words
└── pronunciation.md    ← no audio planned: nobody in the book speaks it
```

## What's here

- `language.toml`, `phonology.toml`, `lexicon.toml` — the data the tooling checks. **Every
  headword is the romanised form of its IPA, and every root, suffix and compound it cites is an
  entry here.** A proto-language has no `sound-changes.toml` and no script.
- `grammar.md` — only what the entries need, with every gap stated as undecided.
- `pronunciation.md` — the narrator record, empty on purpose.
- Two words, kelom 'hearth' and fepika 'plank bridge', have no daughter reflex yet, so that
  `make derive` has parent words to propose reflexes for.

## Cross-references

- `world/src/languages/example-tongue/` — the daughter, and `sound-changes.toml`, its history.
- `research/src/setting/example-model-classical-latin.md` — the cited facts behind the model.
- `world/src/cultures/example-culture.md` — the speakers' culture: the rites keep old words.
- `world/docs/reference/building-a-language.md` — the method each file follows.
- `world/docs/reference/lexicon-format.md` — the schema of the three data files.
