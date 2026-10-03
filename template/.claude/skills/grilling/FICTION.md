# FICTION.md — grilling, fiction mode

The domain for grilling a novel, and the order in which language, name and word questions open.

## Paths and unit

- **Unit:** a chapter, `manuscript/src/NN-kebab-title/`; its brief is
  `planning/src/units/NN-kebab-title.md`, whose settled-positions slot is `## Continuity facts`.
- **Lookup order (step 1):** `.claude/MEMORY.md` → the brief and `planning/src/outline.md` → the
  story bible: `world/src/names-register.md`, `world/src/characters/`, `world/src/places/` and,
  where the worldbuilding and language kits are installed, the peoples, cultures and history
  files (world/src/peoples/, world/src/cultures/, world/src/history/) and each language folder
  (world/src/languages/) → `planning/src/causality.md`, `planning/src/timeline.md`,
  `planning/src/continuity.md`, `planning/src/arcs/` → `research/src/setting/` and
  `research/src/notes/` → `standards/method/FICTION.md` and `standards/risk/FICTION.md`.
- **Procedures that open with a grilling pass:** `planning/workflows/03-chart-the-causality/`,
  `planning/workflows/04-chart-a-character-arc/`, `world/workflows/01-create-a-character/`,
  `world/workflows/02-create-a-place/`, `world/workflows/03-name-something/`; with the kits, the
  people, culture, world-history, language, word and script procedures in `world/workflows/`.

## Additions to the steps

- **Step 1 — also read the world before any language, name or word question.** Before proposing a
  sound model, a script or a name style, read the **people** (physiology that constrains speech),
  the **culture** (values: where vocabulary runs deep; power and kinship: honorifics; beliefs and
  rites: sacred registers; land, livelihood and materials: a script's medium), the **world
  history** (eras, migrations, conquests and contact: where a proto-language splits, where loans
  come from, when sound changes happened) and the **places** (climate, terrain, neighbours). If
  those files are too thin to justify a choice, the round says what is missing, by file and
  section, and asks for that first. Never guess a model to fill the gap.
- **Step 1 — also order the language surface.** On a language, a name or a word, the real-world
  inspiration and its point in history gates everything else: sound, spelling and naming
  questions stay blocked until it is settled, and it opens the first round alone on that surface.
- **Step 2 — also give a model question two or three options**, each naming: the real-world
  language or blend and its **period** (Old English c. 900 is not Middle English c. 1350); its
  **weight** (primary, secondary or accent); **what is borrowed** (sounds, syllable shapes, stress
  and rhythm first; grammar type and naming habits only optionally); the reasoning, tied to named
  world files; what **readers will associate** with it; three or four sample names sketched for
  flavour; and its **risks**. Then the recommendation and its reason. The period must suit the
  language's place in its family (a proto-language leans older than its daughters), and related
  peoples take related models, so a family reads as a family.
- **Step 2 — also flag a hostile people, always.** When the people is cast as hostile or 'evil'
  and an option models its language on a real ethnic group's language, say so in the question:
  readers carry the association back to real speakers, and harsh-consonant stereotypes are a trap.
  Offer ancient or extinct models, or blends, for antagonists.
- **Step 3 — also settle the three layers separately, in order.** **Sound** first, modelled on the
  inspiration. Then, as its own question, the **romanisation**: how the language is spelt in
  English prose, English-friendly by default with only a few model-flavoured spellings, because
  readers pronounce with English habits. The **native script** comes last and only in the script
  procedure: its own question with its own optional inspiration (medium, tool, origin as native,
  borrowed or adapted, a real script family and its period), taking structure and stroke logic,
  never glyphs. It may come from a family unrelated to the sound model.
- **Step 3 — also, for a word or a name, settle:** which model language and period gives it its
  flavour or a deliberate echo; its **stratum** (inherited, early loan, late loan or coinage); and
  **when in the world's own history it entered** the language, which fixes the sound changes it
  has been through (`entered_after`). An echo of a real word stays a proposal until `research`
  has verified the real word's meaning and cited it.
- **Step 4 — also name where each language answer will be recorded** (`grill-with-docs` owns the
  homes); under `grill-me`, offer to switch the moment one proves load-bearing.

## Domain rules

| Surface | The decisions it turns on |
|---|---|
| Premise | the story's question, whose story it is, what the ending must answer |
| Character | want against need, the wound and the lie, voice markers, arc type |
| Causality | each beat's cause, 'because' and 'therefore', never 'and then' |
| Scene | goal, conflict, outcome; point of view and tense; what the reader learns, and when |
| Ending | what is paid off, what is left open, whose choice settles it |
| World element | a place, people, culture or creature: rules and limits, cost, values, dissent within |
| Language, name or word | the real-world model and its period first; then sound; then romanisation; then the script |

- **The floor:** a scene's goal, conflict and outcome, and each beat's cause
  (`standards/method/FICTION.md` Sections 1 and 3). Grilling keeps going past them.
- **Facts about real languages are never settled by grilling.** What a language's syllables
  allowed, what a word meant, how a script was cut: `research` finds and cites them in
  `research/src/setting/`. Borrow structure and flavour, never vocabulary.
- **Respect living languages.** Taking a minority, Indigenous or sacred language's feel is
  acceptable; lifting its words or sacred terms, or caricaturing it, is flagged against
  `standards/risk/FICTION.md`.
- **The story bible is the source of truth** (`standards/method/FICTION.md` Section 6). A
  contradiction found while grilling is reported to the author, never settled by quietly picking
  one side.
- **Variant anti-patterns:** an event without its cause; a sound inventory before its model; a
  coincidence that resolves a plot.

## Examples

A language round, in an invented world:

```text
**Settled — Fenward homeland:** tidal marsh, salt trade (world/src/places/the-fens.md:9)
**Settled — Contact:** two centuries of trade with the hill peoples (world/src/history/eras.md:14)

**Q1 — The real-world model for Fenward, and its period**

1. **Old English c. 900, primary** — reads old and northern; Hedra, Osmunt, Wulfa
2. **Old English c. 900, primary, with a Celtic accent of the same period** — the trade contact
   made audible in the loans; Hedwen, Osrun, Brevan
3. **A blend: Old English c. 900 with an Old Norse accent** — seafaring; Hedvin, Osgrim, Ulfa

**Recommendation: 2** — the hill trade is the defining event in eras.md, and an accent lets its
loanwords sound borrowed. Research confirms both models' syllable shapes before phonology.
```

A hostile people (Q2, the Ashen Host's tongue) carries its flag in the question: an option modelled
on a living people's language casts its real speakers as the enemy, so options 1 and 2 use an
extinct model and a blend. A word (Q1, 'oath-salt': inherited, or an early loan from the hill
traders in era 2?) recommends the loan, `entered_after` 2, because the salt oath is a trade
custom in the culture file and a loan makes its odd shape a clue.
