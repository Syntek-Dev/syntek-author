---
type: guide
skills: [create-name]
model: opus
---

# Naming — how a name earns its place in the book

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** A name is the most repeated piece of invention in a novel; the reader meets it
hundreds of times. It has three jobs: to sound as if it came from somewhere, to stay distinct
from every other name on the page, and to be sayable by the reader without stopping. This guide
covers all three, and the register that keeps them checked.

## Names come from somewhere

- **One sound palette per people.** Names from one culture share sounds, syllable shapes and
  endings, so a reader can place a stranger before the narrator does. Fix the palette before the
  third name, not after the thirtieth.
- **From the language, where there is one.** With the constructed-language kit, a name is built
  from its language: it obeys the phonotactics, uses the language's own words where a meaning is
  wanted, and follows the naming habits of the language's real-world models (patronymics,
  place-names, epithets) where the language records them. Never a real word lifted whole.
- **Naming customs say who someone is:** given name, kin name, place name, trade name, epithet,
  title; who may use which, and when a name changes.
- **Register matters.** A title, a sacred name, an intimate name and a name for strangers can
  differ for the same person; record which the prose uses, and when.

## Clashes and false friends

- **Look-alike:** two major names sharing a first letter, a length and an ending blur on the
  page. Keep major characters on different initial letters where possible.
- **Sound-alike:** the same stressed syllable or rhyme blurs when read aloud, and audiobooks are.
- **False friends:** check every prominent name as a word in the languages it is modelled on
  (if any), in English, including slang, and as a brand or a prominent real person. Readers who
  know a model language will find an unintended meaning in it first; check it, never assume.
- **Overload:** apostrophes, doubled vowels and stacked consonants slow every reading.

## Respellings and the read-aloud test

Give every invented name a respelling an English-speaking reader can follow: plain syllables,
hyphenated, stressed syllable in capitals (VAH-ree). Then say every option aloud, as a reader
would, at speed and in a sentence; with the constructed-language kit the author may also ask to
hear it voiced (only on request, as it spends credits). A name that makes the reader stop will
stop them every time. If the respelling needs explaining, change the spelling, not the sound.

## How we apply it here

- `create-name` offers three to five options with reasoning; the author chooses. Never pick a
  name on the author's behalf, and never rename silently.
- Before offering options, read the world files the name comes from: the people, the culture's
  naming customs and, with the constructed-language kit, the language and its models.
- Every option is checked against `world/src/names-register.md` for look-alike and sound-alike
  clashes, and for false friends, before it is offered.
- A name is registered, with IPA, respelling, language, meaning and kind, before it appears in
  promoted prose; a retired name keeps its row, marked retired with the date.
- A name with a likely misspelling gets its wrong form added to `standards/style/terminology.md`.

## Who implements it

- **Skill:** `create-name`: options, clash and false-friend checks, registration.
- **Workflow:** `world/workflows/03-name-something/` for any single name; the character and
  place procedures call the same steps.

## Governing standard

`standards/style/style-sheet.md` and `standards/style/terminology.md` own spelling and the
words to avoid; `standards/method/FICTION.md` owns the story bible as the source of truth;
`standards/risk/FICTION.md` owns borrowing from real languages. The standards own the rules;
this guide owns how a name is chosen and kept distinct.
