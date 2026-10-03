# CONTEXT.md — world/src/

The story bible itself: one file per character and place, and one register of every invented
name, each recording what is true in the novel's world. These files are notes, not prose. The
order of events, the causes between them and the record of where the reader learned each fact
live in `planning/src/`, not here.

## Directory Tree

```text
world/src/
├── CONTEXT.md              ← this file
├── CLAUDE.md               ← operating rules
├── .gitignore              ← keeps generated language audio (languages/*/audio/) out of Git
├── names-register.md       ← seed: every invented name, with IPA, respelling, language, meaning
├── characters/             ← <slug>.md per character: want, need, wound and the lie, voice
<: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>├── creatures/              ← <slug>.md per creature: ecology, rules and limits, weaknesses
├── cultures/               ← <slug>.md per culture: values, customs, naming customs
├── history/                ← eras.md (seed) + <slug>.md per major event: migration, conquest, contact
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>├── languages/              ← <lang>/ per constructed language: phonology, lexicon, script
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>├── peoples/                ← <slug>.md per people: body and speech, lifespan, homelands
<: endif :>└── places/                 ← <slug>.md per place: geography, senses, history, rules
```

## What's here

- `world/src/names-register.md` — **the single list of every invented name** in the book. It
  ships empty and fills as `create-name` registers names. `spelling` reads it as a list of
  known words; `continuity` checks the prose against it.
- `world/src/characters/` — one file per character who needs more than a name.
- `world/src/places/` — one file per place a scene happens in or depends on.
- `world/src/.gitignore` — template-owned. It ignores `languages/*/audio/`, the pronunciation
  audio the constructed-language kit generates, and ships with every novel, so the audio stays
  out of Git even after the kit is turned off.
<: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>- `world/src/peoples/` — one file per people: what they are, body and speech first. The
  layer beneath culture and language.
- `world/src/cultures/` — one file per culture, naming its people, with the naming customs
  `create-name` follows and the details language work reads.
- `world/src/history/` — the eras in order (`world/src/history/eras.md`, seeded empty) and one
  file per major event, each with its linguistic consequences.
- `world/src/creatures/` — the bestiary, one entry per creature.
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>- `world/src/languages/` — one folder per constructed language, laid out the same way so the
  tooling can check it. Generated audio inside it is ignored by `world/src/.gitignore`.
<: endif :>
## Cross-references

- `world/docs/reference/story-bible.md` — what belongs in these files and what belongs in
  planning.
- `world/docs/reference/naming.md` — how names are chosen and registered.
- `planning/src/continuity.md` — where each fact was established in the prose.
- `planning/src/arcs/` — each character's arc, linked from the character file.
