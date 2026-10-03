---
workflow: 06-build-a-language
phase: produce
skills: [build-language, research]
model: opus
---

# STEPS.md — build a language

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for building a constructed language, or changing one, by the method in
`world/docs/reference/building-a-language.md`. Each step names the skill and guide it uses.
**Run in order** (world, then models, then family, then sounds, spelling, grammar and words);
the author settles each subsystem before the next, and `CHECKLIST.md` is ticked as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The
> `build-language` skill is this procedure in skill form.

## 1. Fix what the book needs from the language

> **Skill:** `build-language` · **Guide:** `world/docs/reference/building-a-language.md`

Ask the author: names only, a few words, phrases, or speech on the page? Which people speak it,
and how should it feel beside the book's other languages? The answer sets how far down this list
this pass goes. _Substantive._

## 2. Read the speakers' world

> **Skill:** `build-language` · **Guide:** `world/docs/reference/building-a-language.md`

Read the people file in `world/src/peoples/` (body and speech), the culture file in
`world/src/cultures/` (values, rank, the sacred, materials and tools), the eras and events in
`world/src/history/` that touch them, their places, and any related language. List the domains
where vocabulary must run deep. If the files are too thin to justify a choice, stop and say
what is missing and which procedure fills it (`world/workflows/10-create-a-people/`,
`world/workflows/05-create-a-culture/`, `world/workflows/11-chart-the-world-history/`).
_Substantive._

## 3. Propose real-world models and recommend one

> **Skill:** `build-language` · **Guide:** `world/docs/reference/building-a-language.md`

Offer two or three options, each with a real language and period, the reasoning tied to named
world files, what readers will associate it with, a few sample names, and the risks; then state
a recommendation and its reason. Sound comes first: what each borrows in phonology,
phonotactics, stress and rhythm, and how strongly. Always flag a hostile people's language
modelled on a real ethnic group's, and offer ancient or extinct models, or blends, instead. The
author chooses. _Substantive._

## 4. Research the chosen models and cite them

> **Skill:** `research` · **Guide:** `world/docs/reference/building-a-language.md`

Research how each chosen model actually sounds and works, from sources, into notes in
`research/src/setting/`; nothing about a real language is asserted from memory. Each model
becomes an `[[inspiration]]` entry with its weight, what it borrows, and its sources.
_Substantive._

## 5. Place the language in its family

> **Skill:** `build-language` · **Guide:** `world/docs/reference/building-a-language.md`

Proto, daughter or isolate. A daughter names its parent, which must exist and pass
`make lexicon`, and its split is tied to an era or event in the world history where one exists.
Related languages share or descend from related models, and a parent leans older in period than
its daughters. _Substantive._

## 6. Create the language folder

> **Skill:** `build-language` · **Guide:** `world/docs/reference/lexicon-format.md`

Agree the slug. Check that `world/src/languages/<lang>/` does not exist; if it does, stop and
ask. Create the layout shown in `world/src/languages/CONTEXT.md`: the pair, `language.toml`
(with `culture`, `values` and every `[[inspiration]]`), `phonology.toml`, `sound-changes.toml`
for a daughter, `grammar.md`, `lexicon.toml` with `[meta]` only, and `pronunciation.md` from
the skeleton in `world/src/languages/CLAUDE.md`, with no voice chosen. _Mechanical._

## 7. For a daughter, write the ordered sound changes

> **Skill:** `build-language` · **Guide:** `world/docs/reference/building-a-language.md`

Starting from the parent's forms, write the changes in order as `[[rule]]` entries, each regular
and each dated to the history where it can be. Show one derivation per change and one pair of
changes whose order matters. For a proto-language or an isolate, record that this step does not
apply. _Substantive._

## 8. Settle the inventory

> **Skill:** `build-language` · **Guide:** `world/docs/reference/building-a-language.md`

Propose 20–35 phonemes in IPA, modelled on the chosen inspiration and allowed by the people's
bodies; for a daughter, the inventory the changes produced. Add `[classes]`. Write
`[inventory]` once the author approves. _Substantive._

## 9. Settle phonotactics, stress and allophones

> **Skill:** `build-language` · **Guide:** `world/docs/reference/building-a-language.md`

Write the syllable templates, permitted clusters and forbidden sequences, one `[stress]` rule,
and a few ordered `[[allophone]]` rules. Show sample words that pass and one that fails, and say
them aloud for the author. _Substantive._

## 10. Settle the romanisation

> **Skill:** `build-language` · **Guide:** `world/docs/reference/building-a-language.md`

English-friendly by default, with only a few model-flavoured spellings: one spelling per sound,
no apostrophe soup, sparing diacritics, and every exception listed with its reason in
`[romanisation.exceptions]`. _Substantive._

## 11. Record the grammar the book needs

> **Skill:** `build-language` · **Guide:** `world/docs/reference/building-a-language.md`

Word order and morphology type chosen together; what the language marks and what it ignores;
the irregular frequent words; the pronouns. Record each in `language.toml` and `grammar.md` with
an example, and state every undecided point as undecided. _Substantive._

## 12. Build the core lexicon

> **Skill:** `build-language` · **Guide:** `world/docs/reference/lexicon-format.md`

Roots first (entries with `pos = "root"`), then the core concepts and pronouns `make coverage`
lists, deepest in the speakers' value domains, as far as this pass reaches. A daughter's words
come from its parent's through the sound changes. Each later word goes through
`world/workflows/07-add-a-word/`. _Substantive._

## 13. Check the files

> **Skill:** `build-language` · **Guide:** `world/docs/reference/lexicon-format.md`

Run `make lexicon LANG=<slug>`, and `make derive LANG=<slug>` for a daughter, then `make family`.
For a change to a language with words, list every word that now fails and every section of
promoted prose that uses one, and stop for the author before going further. _Mechanical._

## 14. Hand back

> **Skill:** `build-language` · **Guide:** `world/docs/reference/building-a-language.md`

Report the models chosen and their sources, the subsystems settled, what is still undecided,
and the next procedures: `world/workflows/07-add-a-word/` for vocabulary,
`world/workflows/08-design-a-script/` for writing, `world/workflows/09-record-a-pronunciation/`
when the author wants to hear it. _Substantive._
