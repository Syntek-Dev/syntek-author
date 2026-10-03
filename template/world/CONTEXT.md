# CONTEXT.md — world/

The story bible: everything the novel treats as fact about its people, places and names, kept
outside the prose so that the prose can be checked against it. A world file records what is true;
a chapter shows it. This layer does **not** hold the plot (that is `planning/`: causality,
timeline, arcs, the continuity ledger), the prose (`manuscript/`) or checked real-world detail
(`research/src/setting/`).

## Directory Tree

```text
world/
├── CONTEXT.md                  ← this file
├── CLAUDE.md                   ← operating rules for the layer
├── docs/                       ← the guides: how the world is built and named
│   ├── reference/              ← template-owned guides, updated by copier update
│   └── project/                ← your own guides; a same-named file overrides reference/
├── src/                        ← the story bible itself: one file per entry, plus the register
│   ├── .gitignore              ← keeps generated language audio out of Git
│   ├── names-register.md       ← seed: every invented name, with IPA and a reader respelling
│   ├── characters/             ← one file per character
<: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>│   ├── creatures/              ← one bestiary entry per creature
│   ├── cultures/               ← one file per culture: how a people lives
│   ├── history/                ← the eras, and one file per major event
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>│   ├── languages/              ← one folder per constructed language (audio ignored by src/.gitignore)
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>│   ├── peoples/                ← one file per people: body, lifespan, homelands
<: endif :>│   └── places/                 ← one file per place
└── workflows/                  ← the procedures, one folder per world-building job
    ├── NN-verb-first-name/     ← template procedures: CONTEXT · CLAUDE · STEPS · CHECKLIST
    └── local/                  ← your own procedures; a same-slug local workflow wins
```

## What's here

- `world/docs/reference/` — the guides: `story-bible.md` and `naming.md` for every
  novel<: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>; `peoples.md`, `cultures.md`, `world-history.md` and `creatures.md` for the
  worldbuilding kit<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>;
  `building-a-language.md`, `lexicon-format.md`, `writing-systems.md` and `pronunciation.md`
  for the constructed-language kit<: endif :>.
- `world/docs/project/` — your own guides. The template ships only the folder's pair.
- `world/src/` — the bible itself. **`world/src/names-register.md` is the one list of every
  invented name**; `spelling` treats each entry as a known word and `continuity` checks the
  prose against it.
- `world/workflows/` — one procedure per kind of world-building job, numbered and frozen:
  create a character, create a place, name something<: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>, create a creature, create a
  culture, create a people, chart the world history<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>, build a language, add a word, design a script, record a
  pronunciation<: endif :>.

## Cross-references

- `.claude/rules/syntek-author/01-layout-and-routing.md` — the layer table, the pair rule and the
  ownership classes this layer follows.
- `standards/method/FICTION.md` — the story engine, including the rule that the story bible is the
  source of truth.
- `planning/src/continuity.md` — the ledger of facts the prose has established, with section
  references; world files say what is true, the ledger says where the reader learned it.
- `planning/src/arcs/` — how each character changes; each character file links to its arc.
- `manuscript/src/` — the prose the bible is checked against.
