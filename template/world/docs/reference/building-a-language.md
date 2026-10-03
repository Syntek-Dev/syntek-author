---
type: guide
skills: [build-language, add-word, design-script, create-name]
model: opus
---

# Building a language — the method: world first, sound first, history always

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** The governing method for every constructed language in this project: the
author's twenty-three rules, the real-world models each language is built on, and how a model is
chosen from the world files, so that every name and word feels made by one people with one past.

## The twenty-three rules

| # | Group | Rule | Why, and what holds it |
|---|---|---|---|
| 1 | World first | Every language belongs to a culture: `language.toml` names its culture file, and the language is built after its people, culture and history exist in outline. | A language is what a people's life made; built in a vacuum it says nothing about them. |
| 2 | World first | Vocabulary runs deep where the speakers' values do: list those domains in `values` and coin there first and finest. | Many words for one thing show what a people cares about without a line of exposition. |
| 3 | Phonology | 20–35 phonemes, written in IPA in `phonology.toml`. | Fewer sounds thin, more strains the reader; `make lexicon` warns outside the range. |
| 4 | Phonology | Phonotactics carry the flavour: syllable templates, permitted clusters, forbidden sequences. | Readers know a language by its word shapes (how words begin and end) more than by its sounds. |
| 5 | Phonology | One stress rule (`initial`, `penultimate` or `final`); `lexical` only with a stated reason. | One rule gives a steady rhythm that readers and narrators can find. |
| 6 | Phonology | A few allophones, ordered, which the tooling applies to give the surface form. | Real speech shades sounds by context; a few rules make audio and respellings sound lived-in. |
| 7 | Orthography | IPA first; the romanisation is a separate layer chosen for readers. | The sound is the record; spelling is a reader-facing choice, read with English habits. |
| 8 | Orthography | No apostrophe soup; diacritics sparing, and only where they carry meaning. | Every mark slows every reading of every word; `make lexicon` warns on density. |
| 9 | Orthography | One spelling per sound; every exception listed in `[romanisation.exceptions]` with its reason. | A reader who learns a spelling once can say every word with it; the checker enforces it. |
| 10 | Grammar | Choose word order and morphology type together. | They constrain each other; chosen apart they give a grammar no people would speak. |
| 11 | Grammar | Decide what the language marks and what it ignores (`marks`, `ignores`). | What a grammar forces speakers to say, and what it lets them leave out, is a window on the culture. |
| 12 | Grammar | Irregularity lives in the most frequent words: 'to be', 'to go', the pronouns. | Frequent words resist being regularised, so old forms survive there; an irregular rare word looks invented. |
| 13 | Lexicon and etymology | Core list first: about 200 core concepts plus the pronouns (`make coverage`). | Names and phrases draw on these words; filling them early stops later coinages contradicting each other. |
| 14 | Lexicon and etymology | Derive from roots, affixes and compounds; invent a root only when none fits. | Derived words sound related, so the lexicon reads as one language rather than a list. |
| 15 | Lexicon and etymology | Every word has a history: root → sound-shifted form → semantic drift (`proto_form`, `drift`). | Drift explains odd meanings and gives names a depth the reader feels without being told. |
| 16 | Lexicon and etymology | Loanwords are reshaped to the borrower's phonotactics and record their source and when they entered. | Speakers remake foreign words in their own sounds; an unadapted loan breaks the language's sound. |
| 17 | Lexicon and etymology | Meanings overlap English imperfectly: `senses` lists several, never one tidy gloss. | A one-to-one lexicon is English with new spellings. |
| 18 | Sound change | Proto-language first; daughters derived from it by ordered, regular sound changes (`sound-changes.toml`), the Tolkien method. | Related words that differ regularly make a family feel real; `make derive` proves every reflex. |
| 19 | Sound change | Irregularity emerges from sound change, never by hand; a deliberate exception is `irregular = true` with a note. | Irregularity that falls out of history reads as real; inserted irregularity reads as error. |
| 20 | Practical | Dictionary and grammar from day one, under version control. | A word used in one chapter and forgotten by another is an error a reader finds; Git keeps every change. |
| 21 | Practical | Names come from the language: its phonotactics, its words and its models' naming habits. | A name that breaks its language's sound announces the author, not the world; `make lexicon` cross-checks the register. |
| 22 | Practical | Restraint on the page: a few words, glossed by context, never more than three unglossed in a paragraph. | The reader came for the story; `make lint` flags dense paragraphs. |
| 23 | Practical | Test pronounceability aloud before a word or name is fixed. | A name the reader stumbles on is stumbled on every time it appears. |

## Real-world models: how the language sounds

| Principle | What it means here |
|---|---|
| Every language has models | One or more `[[inspiration]]` entries in `language.toml`: language, period, family, weight (`primary`, `secondary`, `accent`), what it borrows, sources. `make lexicon` warns when there is none. |
| Sound first | The model is chiefly how the language sounds (phonology, phonotactics, stress and rhythm, and so how readers hear its names); morphology, syntax and naming habits are optional extras. |
| Structure, not vocabulary | Words are built from the language's own roots. A deliberate echo of a real word goes in the word's `echo`, with the real word, its verified meaning and a source. |
| Cite every claim | What a real language does is researched with `research` and noted in `research/src/setting/`, never asserted from memory; `sources` points at the notes. |
| Families share models | Related languages share or descend from related models, and a parent leans older in period than its daughters; `make family` prints each branch with its models. |
| Three layers, decided apart | Sound is always modelled; romanisation is English-friendly by default with a few model-flavoured spellings; a native script is optional, with its own inspiration in `glyphs.toml` (see `writing-systems.md`). |
| Safeguards | A false-friend check for prominent words (meanings in the model languages, and English slang); a living language's feel may be borrowed, its words, sacred terms or a caricature of it never (`standards/risk/FICTION.md`). |

## Choosing a model: read the world, offer options, recommend

| Step | What it means here |
|---|---|
| Read the world first | The people (`world/src/peoples/`: bodies that constrain speech), the culture (values, rank, the sacred, materials and tools), the history (`world/src/history/`: splits, loans, when changes happened) and the places (climate, terrain, neighbours). |
| Offer options, then recommend | Two or three, each with a real language (or script family) and period, the reasoning tied to named world files, what readers will associate it with, a few sample names, and the risks; then state a recommendation and its reason. The author chooses, and the choice is recorded in `[[inspiration]]`. |
| Thin-world rule | If the files are too thin to justify a choice, say what is missing and which procedure fills it, rather than guess. |
| Hostile peoples | Always flag a hostile or 'evil' people's language modelled on a real ethnic group's (readers carry it back to real people; harsh-consonant stereotypes are a trap); suggest ancient or extinct models, or blends. |

## How we apply it here

- Order: speakers → models → proto or daughter → phonology → orthography → grammar → core
  lexicon → `make lexicon` and `make derive` clean. Grilling on a language or a word opens with
  its model and period.
- A change to a language with words is tried first, and every word it breaks (and every promoted
  section using one) is listed for the author. Data formats: `lexicon-format.md`.

## Who implements it

- **Skills:** `build-language`, `add-word`, `design-script`, `create-name`, `pronounce`.
- **Workflows:** `world/workflows/06-build-a-language/` to `world/workflows/09-record-a-pronunciation/`.

## Governing standard

`standards/method/FICTION.md` owns the story bible as the source of truth, and
`standards/risk/FICTION.md` the living-language and hostile-people safeguards; `tooling/lexicon.py`
runs the checks. The standards own the requirements; this guide owns the method.
