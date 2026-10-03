# CONTEXT.md — world/docs/reference/

The template's guides for the world layer, one per question a world-building job raises. They
are template-owned: `copier update` replaces them, so changes for this book belong in
`world/docs/project/` under the same filename.

## Directory Tree

```text
world/docs/reference/
├── CONTEXT.md                  ← this file
├── CLAUDE.md                   ← operating rules
<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>├── building-a-language.md      ← the method: the 23 rules, real-world models, choosing from the world
├── lexicon-format.md           ← language, phonology, sound-change and lexicon files, field by field
├── pronunciation.md            ← IPA is canonical; surface IPA is voiced, on request; audio git-ignored
├── writing-systems.md          ← script type and inspiration, filled glyphs, code points, font, print
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>├── creatures.md                ← the bestiary entry: ecology first, rules and limits, lore and truth
├── cultures.md                 ← a culture: values, customs, material life, naming customs
├── peoples.md                  ← what a people is: body and speech first, lifespan, homelands
├── world-history.md            ← eras, events, and the marks events leave in language
<: endif :>├── naming.md                   ← where names come from; clashes and false friends; read aloud
└── story-bible.md              ← what goes in the world files, and what goes elsewhere
```

## What's here

- `story-bible.md` — **the source-of-truth rule in practice:** what is world, what is
  planning, and how a fact settles.
- `naming.md` — the craft of names: where they come from, look-alike, sound-alike and false-friend
  clashes, reader respellings, the read-aloud test, and the register.
<: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>- `peoples.md` — what a people is beneath its cultures: body and speech first, lifespan,
  numbers, homelands, relations, and the depiction check for peoples cast as hostile.
- `cultures.md` — a people's way of life as values that produce customs: material life, social
  structure, rites, internal variety, naming customs, and what speech and writing take from it.
- `world-history.md` — the eras and the events that moved, mixed and divided peoples, and the
  loanwords, splits and borrowed scripts they leave behind.
- `creatures.md` — a creature as a set of rules the story must keep: ecology, anatomy,
  behaviour, limits, weaknesses, and what people believe about it.
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>- `building-a-language.md` — **the governing method for every language:** the author's
  twenty-three rules, real-world models (sound first, structure not vocabulary, every claim
  cited), and how a model is chosen from the world files.
- `lexicon-format.md` — the schema of `language.toml`, `phonology.toml`, `sound-changes.toml`
  and `lexicon.toml`, and what `make lexicon` and `make derive` check.
- `writing-systems.md` — choosing a script and its real-world inspiration, drawing filled
  glyphs on the em grid, code points, the font, and right-to-left scripts in print.
- `pronunciation.md` — IPA first; surface IPA voiced through ElevenLabs on request, with cost
  discipline; `espeak-ng` as the approximate fallback.
<: endif :>
## Cross-references

- `world/docs/project/` — the author's own guides; a same-named file there wins.
- `world/workflows/` — the procedures that apply these guides step by step.
- `standards/method/FICTION.md` — the standard every guide here serves.
