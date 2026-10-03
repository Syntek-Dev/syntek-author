# CONTEXT.md — world/workflows/06-build-a-language/

The procedure for building a constructed language, or changing one, by the governing method in
`world/docs/reference/building-a-language.md`: read the world its speakers live in, choose
real-world models for how it sounds and cite them, place it in its family, then settle its
sounds, spelling, grammar and core words one subsystem at a time. It ends with a language folder
that `make lexicon` (and, for a daughter, `make derive`) accepts, ready for words, a script and
a voice.

## Directory Tree

```text
world/workflows/06-build-a-language/
├── CHECKLIST.md        ← model-tagged checklist; tick it as you go
├── CLAUDE.md           ← operating rules for this procedure
├── CONTEXT.md          ← this file: when to use it, what it produces
└── STEPS.md            ← the ordered steps, each naming its skill and guide
```

## When to use this

- A people in the book will have names, words or phrases that should sound like one language.
- A daughter language is needed: a people split off, and their speech drifted from their parent's.
- An existing language needs a new subsystem, or a change to its sounds, spelling or models is
  being considered.

Reach for a **different** procedure when the language exists and what is needed is a word
(`world/workflows/07-add-a-word/`), a writing system (`world/workflows/08-design-a-script/`)
or audio (`world/workflows/09-record-a-pronunciation/`); or when the speakers' people, culture
or history is still too thin to build on (`world/workflows/10-create-a-people/`,
`world/workflows/05-create-a-culture/`, `world/workflows/11-chart-the-world-history/`).

## What it produces, and where

- **A language folder** at `world/src/languages/<lang>/`, laid out as
  `world/src/languages/CONTEXT.md` shows, with its pair.
- **`language.toml`**: kind and parent, the culture link, value domains, typology, and one
  `[[inspiration]]` per real-world model, each with its sources.
- **`phonology.toml`**: inventory, classes, phonotactics, stress, allophones and romanisation;
  **`sound-changes.toml`** for a daughter: the ordered changes from its parent.
- **`grammar.md`** and **`lexicon.toml`**: the grammar the book needs, then roots and core words.
- **Research notes** in `research/src/setting/` for every real language the models draw on.

## The failure this procedure exists to prevent

Two, in fact. The language built backwards from a handful of cool words, which share no sound,
derive from nothing and break the moment a rule is written. And the language modelled on
nothing in particular, or on a real people's words, which sounds like a costume: readers who
know the source hear the theft, and readers who do not hear nothing at all. World first, models
chosen and cited, sound before spelling and history before words keeps every later word
derivable and every name sounding as if it belongs.

## Cross-references

- `world/docs/reference/building-a-language.md` — the twenty-three rules and the model method.
- `world/docs/reference/lexicon-format.md` — the data files the checks read.
- `world/src/peoples/`, `world/src/cultures/`, `world/src/history/` — the world the language
  is built from.
- `standards/risk/FICTION.md` — living languages and hostile peoples.
- `tooling/lexicon.py` — the checks behind `make lexicon`, `make derive`, `make coverage` and
  `make family`.
