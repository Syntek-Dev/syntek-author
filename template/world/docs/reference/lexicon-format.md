---
type: guide
skills: [add-word, build-language]
model: opus
---

# Lexicon format — a language's data files, field by field

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** A language keeps its facts in TOML the tooling reads: `language.toml`,
`phonology.toml`, `sound-changes.toml` (daughters only) and `lexicon.toml`. Every key is present
even when empty (`""` or `[]`), so that a half-made entry cannot pass for a finished one.

## `language.toml` — who speaks it, and what it is modelled on

| Field | Holds |
|---|---|
| `name`, `slug` | Display name; the folder's name in kebab-case, matching `lexicon.toml` `[meta]` |
| `kind`, `parent` | `proto` · `daughter` · `isolate`; a daughter names its parent's slug |
| `culture`, `speakers` | The culture file's path; who speaks it, where and when |
| `values` | Domains where vocabulary runs deep, from the culture's values |
| `word_order`, `morphology` | `SOV` · `SVO` · `VSO` · `VOS` · `OVS` · `OSV` · `free`; `isolating` · `agglutinative` · `fusional` · `polysynthetic` |
| `marks`, `ignores` | What the grammar forces speakers to say; what it lets them leave out |
| `[[inspiration]]` `language`, `period`, `family` | One real-world model per entry; `period` is `ancient` · `classical` · `medieval` · `early-modern` · `modern` |
| `weight`, `borrows`, `sources`, `notes` | `primary` · `secondary` · `accent`; sound first (`phonology`, `phonotactics`, `prosody`), optionally `morphology` · `syntax` · `naming` · `aesthetic`; paths to research notes |

## `phonology.toml` and `sound-changes.toml` — the sound system and its history

| Field | Holds |
|---|---|
| `[inventory]` `consonants`, `vowels` | Phonemic IPA; 20–35 phonemes in all |
| `[classes]` | Single capital letters, each a list of phonemes, usable in templates and sound changes |
| `[phonotactics]` `syllable` | A template such as `(C)V(C)`, or a list of alternative templates |
| `onset_clusters`, `coda_clusters`, `forbidden` | Clusters allowed at each edge of a syllable; sequences forbidden anywhere |
| `[stress]` `rule` | `initial` · `penultimate` · `final` · `lexical` |
| `[[allophone]]` `phoneme`, `surface`, `env` | Ordered context rules turning phonemic into surface IPA (`env` as for sound changes) |
| `[romanisation]`, `[romanisation.exceptions]` | Phoneme → spelling, identity when absent; documented departures from one-to-one, with reasons |
| `[[rule]]` `from`, `to`, `env`, `note` | Daughters only, in `sound-changes.toml`: ordered changes from the parent; in `env`, `_` is the target, `#` a word boundary, class letters allowed |

## `lexicon.toml` — one `[[word]]` per entry

`[meta]` holds `language` and `slug`. Roots and affixes are entries too (`pos = "root"`, `"affix"`).

| Field | Holds |
|---|---|
| `headword`, `ipa` | The romanised form used in prose (unique); phonemic IPA: no slashes or dots; no stress mark unless the language's stress rule is lexical, in which case ˈ marks the stressed syllable |
| `pos` | `noun` · `verb` · `adjective` · `adverb` · `pronoun` · `numeral` · `particle` · `conjunction` · `adposition` · `determiner` · `interjection` · `affix` · `root` · `name`; a `root` or `affix` need not be a word on its own (`-n`, a consonantal root), so its IPA is checked only against the inventory and `forbidden`, never the syllable shapes or stress |
| `senses`, `concept` | Meanings, never one-to-one with English; the core-concept key it fills, for `make coverage` |
| `roots`, `affixes`, `compound_of` | What the word is built from; each must be an entry in this lexicon or, for a daughter, in an ancestor's |
| `proto_form`, `drift` | Daughters: the parent form it descends from; how its meaning moved |
| `loan_from`, `loan_source` | When borrowed: the source language's slug, and the form there |
| `stratum`, `entered_after` | `inherited` · `early-loan` · `late-loan` · `coinage`; daughters: the last sound change already past when it entered (0: it undergoes all) |
| `irregular`, `echo` | `true` only with a note on why; a deliberate echo of a real word, verified and cited, never from memory |
| `derived`, `native` | Headwords formed from this one; leave `native` empty, as `tooling/script.py` derives it |
| `first_used`, `notes` | `<unit-slug>/<section-slug>` once promoted prose uses it; anything else |

## What the tools check

- `make lexicon LANG=<slug>`: inventory size, one spelling per sound, apostrophe and diacritic
  density, every headword and loan parses, stress, roots exist, duplicates, missing keys, a
  missing `[[inspiration]]`; then the names register against the phonotactics.
- `make derive LANG=<slug>`: applies the sound changes after `entered_after` to each
  `proto_form`; reports mismatches not marked `irregular`, and parent words with no reflex.
- `make coverage LANG=<slug>` lists core concepts and pronouns with no word; `make family`
  prints every family tree with its models; `make glossary LANG=<slug>` writes a glossary.

## How we apply it here

- Append entries; never reorder. Retire a word used in promoted prose in `notes`, with the date.
- A word used as a name is registered in `world/src/names-register.md` under this language's slug.

## Who implements it

- **Skills:** `add-word` writes entries; `build-language` writes the other three files.
- **Workflows:** `world/workflows/07-add-a-word/`, `world/workflows/06-build-a-language/`.

## Governing standard

`tooling/lexicon.py` is this schema's executable form; `standards/method/FICTION.md` owns the story
bible as the source of truth. The checker owns what passes; this guide, what each field means.
