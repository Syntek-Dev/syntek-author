# CONTEXT.md — tooling/data/

Reference data the conlang tooling reads, kept apart from the scripts so that it can be read and
reviewed as data. It holds one file today: the core vocabulary every constructed language is
measured against. Nothing here describes a particular language; a language's own facts live in
its folder under `world/src/languages/`.

## Directory Tree

```text
tooling/data/
├── CONTEXT.md              ← this file
├── CLAUDE.md               ← operating rules
└── core-concepts.toml      ← about 200 core concepts by domain, and the pronoun grid
```

## What's here

- `core-concepts.toml` — the concepts `python3 tooling/lexicon.py coverage` (`make coverage`)
  checks each lexicon against: a word fills a concept when its `concept` field names the
  concept's key. **Written fresh for this template, from what a story's people need to say; not
  copied from any published word list.** The pronoun grid's cells are expected only when the
  language's `language.toml` `marks` call for them (dual, clusivity, formality, animacy, gender).

## Cross-references

- `tooling/lexicon.py` — `coverage` reads this file; `check` warns on a `concept` key it lacks.
- `world/docs/reference/building-a-language.md` — why the core list comes first.
- `world/docs/reference/lexicon-format.md` — the `concept` field.
