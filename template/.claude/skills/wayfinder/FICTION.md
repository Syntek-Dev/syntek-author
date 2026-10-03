# FICTION.md — wayfinder, fiction mode

What a novel charts with a map, where its settled nodes go, and how a language map is ordered.

## Paths and unit

- **Map files:** `planning/src/maps/MAP-<TOPIC>.md`, for example `MAP-PART-TWO.md` or
  `MAP-THE-COAST-TONGUES.md`.
- **Reads (step 5):** `planning/src/outline.md`, the briefs in `planning/src/units/`,
  `planning/src/causality.md`, `planning/src/timeline.md`, `planning/src/continuity.md`,
  `planning/src/arcs/`, the story bible in `world/src/` (with the kits, the peoples, cultures,
  history and language files), and `research/src/setting/`.
- **Procedures that chart with a map:** with the worldbuilding kit, chart-the-world-history in
  `world/workflows/`; with the language kit, a family of languages whose model choices will not
  settle in one sitting, charted before build-language settles any of its members.

## Additions to the steps

- **Step 1 — also** read the open continuity threads (planted set-ups with no payoff, unresolved
  contradictions) and, with the language kit, any language with no real-world model recorded:
  `make lexicon` warns on each.
- **Step 5 — also, on a language map, the first frontier is the unresolved model-and-period
  choices.** Everything else on the map depends on them: a language's sound, its romanisation,
  every name drawn from it and every word's history. So the first nodes are, per language or per
  family (the proto-language first, its daughters after it), one grilling node 'real-world model
  and period', each blocked by the research nodes that establish how each candidate model
  actually sounded, and by any world file too thin to choose from (a people with no physiology
  noted, a culture with no values, a history with no contact or migrations): those are task nodes
  for the author.
- **Step 6 — also wire the language blockers in this order:** world files → model and period →
  sound (phonology, phonotactics, stress) → romanisation → names and core words. The script is a
  chain of its own: its inspiration (medium, tool, origin, script family) is blocked by the
  culture's materials and history, never by the sound model; its glyph inventory by the sound.
- **Step 11 — also** settle the model-and-period nodes of related languages in one batch, so a
  family reads as a family; settle a hostile people's model only with its flag answered
  (modelling an 'evil' people on a real ethnic group's language is always flagged, and ancient or
  extinct models, or blends, are offered instead).

## Domain rules

| A settled decision that is… | Graduates to… |
|---|---|
| a beat's cause | `planning/src/causality.md` |
| a fact the prose will rely on | the brief's `## Continuity facts`; `planning/src/continuity.md` once promoted prose states it |
| a date or the order of events | `planning/src/timeline.md` |
| a character's want, need, wound or voice | the character's file in `world/src/characters/`; the arc in `planning/src/arcs/` |
| a place, people, culture, era or creature | its file in the story bible |
| a name | `world/src/names-register.md`, through create-name |
| a language's real-world model and period | the language's `language.toml` `[[inspiration]]`, and `.claude/MEMORY.md` `Decisions` |
| a script's inspiration | `[meta.inspiration]` in the language's `script/glyphs.toml` |
| a word's flavour, stratum or point of entry | the word's lexicon entry: `echo`, `stratum`, `entered_after` |
| a researched fact about a real language or script family | a note in `research/src/setting/`, through `research` |

- **A map never coins.** It settles the model, the order and the decisions; names are coined by
  create-name, words by the add-word procedure, and a language is built by build-language, each
  in its own session.
- **Variant anti-pattern:** charting names or vocabulary for a language whose model is still
  open. Every name coined before the model is settled is a name that may have to be retired.

## Examples

```text
# MAP-THE-COAST-TONGUES — two related coastal languages and their script

## Destination
Both languages have a confirmed model, a sound system and a romanisation, so names can be coined.

## Frontier
1. [research] How Old English c. 900 sounded: syllables, stress (blocks 3)
2. [task] The Fenward people's file has no physiology or speech notes (blocks 3, 4)
3. [grilling] Proto-Coastal: real-world model and period (blocked by 1, 2)
4. [grilling] Fenward (daughter): model weight and accent (blocked by 3)
5. [grilling] Fenward romanisation (blocked by 4)
6. [grilling] The script's inspiration: medium and origin (blocked by the culture file's materials)

## Fog of war
- Whether the hill traders' tongue is a third language or a dialect.
```
